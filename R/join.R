.find_coord_col <- function(data) {
  idx <- which(sapply(data, is.sky_coord))
  if (length(idx) > 0L) names(data)[[idx[1L]]] else NULL
}

.resolve_coord_col <- function(data, expr_or_name, arg_name, data_arg) {
  if (rlang::quo_is_null(expr_or_name)) {
    col <- .find_coord_col(data)
    if (is.null(col)) {
      rlang::abort(
        paste0(
          "No <sky_coord> column found in `", data_arg,
          "`. Supply `", arg_name, "` explicitly."
        )
      )
    }
    return(col)
  }

  expr <- rlang::quo_get_expr(expr_or_name)
  eval_name <- function() {
    tryCatch(
      rlang::eval_tidy(expr_or_name),
      error = function(cnd) {
        rlang::abort(
          paste0("`", arg_name, "` must be a column name (bare or character)."),
          parent = cnd
        )
      }
    )
  }

  if (rlang::is_symbol(expr)) {
    candidate <- rlang::as_name(expr)
    if (candidate %in% names(data)) {
      col <- candidate
    } else {
      value <- eval_name()
      if (!is.character(value) || length(value) != 1L || is.na(value)) {
        rlang::abort(paste0("`", arg_name, "` must be a column name (bare or character)."))
      }
      col <- value
    }
  } else {
    value <- eval_name()
    if (!is.character(value) || length(value) != 1L || is.na(value)) {
      rlang::abort(paste0("`", arg_name, "` must be a column name (bare or character)."))
    }
    col <- value
  }

  if (!col %in% names(data)) {
    rlang::abort(paste0("Column `", col, "` not found in `", data_arg, "`."))
  }

  if (!inherits(data[[col]], "sky_coord")) {
    rlang::abort(paste0("`", data_arg, "` column `", col, "` must inherit from <sky_coord>."))
  }

  col
}

.apply_suffixes <- function(x_names, y_names, suffix) {
  dup <- intersect(x_names, y_names)
  x_out <- x_names
  y_out <- y_names

  x_dup <- x_out %in% dup
  y_dup <- y_out %in% dup
  x_out[x_dup] <- paste0(x_out[x_dup], suffix[1])
  y_out[y_dup] <- paste0(y_out[y_dup], suffix[2])

  list(x_names = x_out, y_names = y_out)
}

.left_join_from_match <- function(
  x,
  y,
  match_df,
  y_coord_name,
  keep_sep,
  sep_col,
  suffix
) {
  x_out <- as.data.frame(x[match_df$x_id, , drop = FALSE], stringsAsFactors = FALSE)

  y_cols <- setdiff(names(y), y_coord_name)
  y_out <- as.data.frame(y[match_df$y_id, y_cols, drop = FALSE], stringsAsFactors = FALSE)

  renamed <- .apply_suffixes(names(x_out), names(y_out), suffix = suffix)
  names(x_out) <- renamed$x_names
  names(y_out) <- renamed$y_names

  out_names <- c(names(x_out), names(y_out))

  if (anyDuplicated(out_names)) {
    rlang::abort("Duplicate output column names after applying `suffix`.")
  }

  if (keep_sep && sep_col %in% out_names) {
    rlang::abort(paste0("`sep_col` ('", sep_col, "') collides with an existing output column."))
  }

  out <- cbind(x_out, y_out)
  if (keep_sep) {
    out[[sep_col]] <- match_df$sep
  }

  rownames(out) <- NULL
  out
}

.validate_join_args <- function(max_sep, unit, method, multiple, keep_sep, sep_col, suffix) {
  checkmate::assert_number(max_sep, lower = 0, finite = FALSE, .var.name = "max_sep")
  checkmate::assert_choice(unit, c("arcsec", "arcmin", "deg", "rad"), .var.name = "unit")
  checkmate::assert_choice(method, c("kdtree", "bruteforce"), .var.name = "method")
  checkmate::assert_choice(multiple, c("all", "closest"), .var.name = "multiple")
  checkmate::assert_flag(keep_sep, .var.name = "keep_sep")
  checkmate::assert_string(sep_col, min.chars = 1, .var.name = "sep_col")
  checkmate::assert_character(suffix, len = 2, any.missing = FALSE, .var.name = "suffix")
}

.match_df_for_join <- function(x, y, x_coord_name, y_coord_name, max_sep, unit, method, multiple) {
  match_df <- coord_match(
    x = x[[x_coord_name]],
    y = y[[y_coord_name]],
    max_sep = max_sep,
    unit = unit,
    method = method
  )

  if (multiple != "closest" || nrow(match_df) == 0L) {
    return(match_df)
  }

  is_self_join <- identical(x, y) && identical(x_coord_name, y_coord_name)
  if (is_self_join) {
    is_self_pair <- !is.na(match_df$y_id) & (match_df$x_id == match_df$y_id)
    match_df <- match_df[!is_self_pair, c("x_id", "y_id", "sep"), drop = FALSE]

    missing_x <- setdiff(seq_len(nrow(x)), unique(match_df$x_id))
    if (length(missing_x) > 0L) {
      match_df <- rbind(
        match_df,
        data.frame(
          x_id = as.integer(missing_x),
          y_id = rep(NA_integer_, length(missing_x)),
          sep = rep(NA_real_, length(missing_x))
        )
      )
    }

    if (nrow(match_df) > 0L) {
      ord <- order(match_df$x_id, is.na(match_df$sep), match_df$sep, is.na(match_df$y_id), match_df$y_id)
      match_df <- match_df[ord, c("x_id", "y_id", "sep"), drop = FALSE]
    }
  }

  match_df <- match_df[!duplicated(match_df$x_id), c("x_id", "y_id", "sep"), drop = FALSE]
  rownames(match_df) <- NULL
  match_df
}

.append_unmatched_y <- function(match_df, n_y) {
  matched_y <- unique(match_df$y_id[!is.na(match_df$y_id)])
  missing_y <- setdiff(seq_len(n_y), matched_y)

  if (length(missing_y) == 0L) {
    return(match_df)
  }

  rbind(
    match_df,
    data.frame(
      x_id = rep(NA_integer_, length(missing_y)),
      y_id = as.integer(missing_y),
      sep = rep(NA_real_, length(missing_y))
    )
  )
}

#' Spatial left join for sky coordinates
#'
#' Join two tables by angular distance between `<sky_coord>` columns.
#'
#' @param x,y Data frames (or tibble-like objects).
#' @param x_coord,y_coord Coordinate column in `x`/`y`. Supports bare names or
#'   character names. If `NULL`, the first `<sky_coord>` column is auto-detected.
#' @param max_sep Maximum separation threshold passed to [coord_match()].
#'   Used in [coord_left_join()]. [coord_nearest_join()] always uses `Inf`.
#' @param unit Separation unit passed to [coord_match()]:
#'   `"arcsec"`, `"arcmin"`, `"deg"`, or `"rad"`.
#' @param method Matching backend passed to [coord_match()]:
#'   `"kdtree"` or `"bruteforce"`.
#' @param multiple How to handle multiple matches per row of `x`:
#'   `"all"` keeps all matches, `"closest"` keeps one nearest match per `x` row.
#'   Used in [coord_left_join()].
#' @param keep_sep If `TRUE`, append the separation column to output.
#' @param sep_col Name of the separation column in output.
#' @param suffix Length-2 character vector for duplicate non-key column names.
#'
#' @return A joined table. Currently returned as a base `data.frame`.
#' @export
coord_left_join <- function(
  x,
  y,
  x_coord = NULL,
  y_coord = NULL,
  max_sep,
  unit = "arcsec",
  method = "kdtree",
  multiple = "all",
  keep_sep = TRUE,
  sep_col = "sep",
  suffix = c(".x", ".y")
) {
  checkmate::assert_data_frame(x, .var.name = "x")
  checkmate::assert_data_frame(y, .var.name = "y")
  .validate_join_args(max_sep, unit, method, multiple, keep_sep, sep_col, suffix)

  x_coord_name <- .resolve_coord_col(
    data = x,
    expr_or_name = rlang::enquo(x_coord),
    arg_name = "x_coord",
    data_arg = "x"
  )
  y_coord_name <- .resolve_coord_col(
    data = y,
    expr_or_name = rlang::enquo(y_coord),
    arg_name = "y_coord",
    data_arg = "y"
  )

  match_df <- .match_df_for_join(
    x = x,
    y = y,
    x_coord_name = x_coord_name,
    y_coord_name = y_coord_name,
    max_sep = max_sep,
    unit = unit,
    method = method,
    multiple = multiple
  )

  .left_join_from_match(
    x = x,
    y = y,
    match_df = match_df,
    y_coord_name = y_coord_name,
    keep_sep = keep_sep,
    sep_col = sep_col,
    suffix = suffix
  )
}

#' @rdname coord_left_join
#' @export
coord_nearest_join <- function(
  x,
  y,
  x_coord = NULL,
  y_coord = NULL,
  unit = "arcsec",
  method = "kdtree",
  keep_sep = TRUE,
  sep_col = "sep",
  suffix = c(".x", ".y")
) {
  coord_left_join(
    x = x,
    y = y,
    x_coord = {{ x_coord }},
    y_coord = {{ y_coord }},
    max_sep = Inf,
    unit = unit,
    method = method,
    multiple = "closest",
    keep_sep = keep_sep,
    sep_col = sep_col,
    suffix = suffix
  )
}

#' A coord_right_join() keeps all observations in y.
#' @rdname coord_left_join
#' @export
coord_right_join <- function(
  x,
  y,
  x_coord = NULL,
  y_coord = NULL,
  max_sep,
  unit = "arcsec",
  method = "kdtree",
  multiple = "all",
  keep_sep = TRUE,
  sep_col = "sep",
  suffix = c(".x", ".y")
) {
  checkmate::assert_data_frame(x, .var.name = "x")
  checkmate::assert_data_frame(y, .var.name = "y")
  .validate_join_args(max_sep, unit, method, multiple, keep_sep, sep_col, suffix)

  x_coord_name <- .resolve_coord_col(x, rlang::enquo(x_coord), "x_coord", "x")
  y_coord_name <- .resolve_coord_col(y, rlang::enquo(y_coord), "y_coord", "y")

  match_df <- .match_df_for_join(
    x = x,
    y = y,
    x_coord_name = x_coord_name,
    y_coord_name = y_coord_name,
    max_sep = max_sep,
    unit = unit,
    method = method,
    multiple = multiple
  )

  match_df <- match_df[!is.na(match_df$y_id), c("x_id", "y_id", "sep"), drop = FALSE]
  match_df <- .append_unmatched_y(match_df, nrow(y))
  if (nrow(match_df) > 0L) {
    ord <- order(match_df$y_id, is.na(match_df$sep), match_df$sep, is.na(match_df$x_id), match_df$x_id)
    match_df <- match_df[ord, c("x_id", "y_id", "sep"), drop = FALSE]
  }
  rownames(match_df) <- NULL

  .left_join_from_match(
    x = x,
    y = y,
    match_df = match_df,
    y_coord_name = y_coord_name,
    keep_sep = keep_sep,
    sep_col = sep_col,
    suffix = suffix
  )
}

#' A coord_full_join() keeps all observations in x and y.
#' @rdname coord_left_join
#' @export
coord_full_join <- function(
  x,
  y,
  x_coord = NULL,
  y_coord = NULL,
  max_sep,
  unit = "arcsec",
  method = "kdtree",
  multiple = "all",
  keep_sep = TRUE,
  sep_col = "sep",
  suffix = c(".x", ".y")
) {
  checkmate::assert_data_frame(x, .var.name = "x")
  checkmate::assert_data_frame(y, .var.name = "y")
  .validate_join_args(max_sep, unit, method, multiple, keep_sep, sep_col, suffix)

  x_coord_name <- .resolve_coord_col(x, rlang::enquo(x_coord), "x_coord", "x")
  y_coord_name <- .resolve_coord_col(y, rlang::enquo(y_coord), "y_coord", "y")

  match_df <- .match_df_for_join(
    x = x,
    y = y,
    x_coord_name = x_coord_name,
    y_coord_name = y_coord_name,
    max_sep = max_sep,
    unit = unit,
    method = method,
    multiple = multiple
  )

  match_df <- .append_unmatched_y(match_df, nrow(y))
  rownames(match_df) <- NULL

  .left_join_from_match(
    x = x,
    y = y,
    match_df = match_df,
    y_coord_name = y_coord_name,
    keep_sep = keep_sep,
    sep_col = sep_col,
    suffix = suffix
  )
}

#' An coord_inner_join() only keeps observations from x that have a matching key in y.
#' @rdname coord_left_join
#' @export
coord_inner_join <- function(
  x,
  y,
  x_coord = NULL,
  y_coord = NULL,
  max_sep,
  unit = "arcsec",
  method = "kdtree",
  multiple = "all",
  keep_sep = TRUE,
  sep_col = "sep",
  suffix = c(".x", ".y")
) {
  checkmate::assert_data_frame(x, .var.name = "x")
  checkmate::assert_data_frame(y, .var.name = "y")
  .validate_join_args(max_sep, unit, method, multiple, keep_sep, sep_col, suffix)

  x_coord_name <- .resolve_coord_col(x, rlang::enquo(x_coord), "x_coord", "x")
  y_coord_name <- .resolve_coord_col(y, rlang::enquo(y_coord), "y_coord", "y")

  match_df <- .match_df_for_join(
    x = x,
    y = y,
    x_coord_name = x_coord_name,
    y_coord_name = y_coord_name,
    max_sep = max_sep,
    unit = unit,
    method = method,
    multiple = multiple
  )

  match_df <- match_df[!is.na(match_df$y_id), c("x_id", "y_id", "sep"), drop = FALSE]
  rownames(match_df) <- NULL

  .left_join_from_match(
    x = x,
    y = y,
    match_df = match_df,
    y_coord_name = y_coord_name,
    keep_sep = keep_sep,
    sep_col = sep_col,
    suffix = suffix
  )
}
