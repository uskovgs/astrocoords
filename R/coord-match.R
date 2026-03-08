.match_unit_to_rad <- function(x, unit) {
  if (unit == "rad") {
    return(x)
  }
  if (unit == "deg") {
    return(.deg_to_rad(x))
  }
  x / .arcsec_per_rad
}

.match_rad_to_unit <- function(x, unit) {
  if (unit == "rad") {
    return(x)
  }
  if (unit == "deg") {
    return(.rad_to_deg(x))
  }
  x * .arcsec_per_rad
}

.coord_match_method_auto <- function(n_x, n_y) {
  if (as.double(n_x) * as.double(n_y) <= 1e6) "bruteforce" else "kdtree"
}

.coord_match_empty <- function() {
  data.frame(
    x_id = integer(),
    y_id = integer(),
    sep = double()
  )
}

.coord_match_expand_ids <- function(id_list) {
  n <- length(id_list)
  if (n == 0L) {
    return(
      data.frame(
        x_id = integer(),
        y_id = integer()
      )
    )
  }

  lens <- lengths(id_list)
  if (!any(lens > 0L)) {
    return(
      data.frame(
        x_id = integer(),
        y_id = integer()
      )
    )
  }

  data.frame(
    x_id = rep.int(seq_len(n), lens),
    y_id = as.integer(unlist(id_list, use.names = FALSE))
  )
}

.coord_match_add_unmatched <- function(out, n_x) {
  if (n_x == 0L) {
    return(out)
  }

  missing_x <- setdiff(seq_len(n_x), unique(out$x_id))
  if (length(missing_x) == 0L) {
    return(out)
  }

  out <- rbind(
    out,
    data.frame(
      x_id = as.integer(missing_x),
      y_id = rep(NA_integer_, length(missing_x)),
      sep = rep(NA_real_, length(missing_x))
    )
  )

  rownames(out) <- NULL
  out
}

.coord_match_sort <- function(out) {
  if (nrow(out) == 0L) {
    return(out)
  }

  ord <- order(
    out$x_id,
    is.na(out$sep),
    out$sep,
    is.na(out$y_id),
    out$y_id
  )

  out <- out[ord, c("x_id", "y_id", "sep"), drop = FALSE]
  rownames(out) <- NULL
  out
}

.coord_match_bruteforce <- function(x, y, theta, unit) {
  n_x <- length(x)
  n_y <- length(y)
  x_id <- rep.int(seq_len(n_x), each = n_y)
  y_id <- rep.int(seq_len(n_y), times = n_x)

  sep_arcsec <- separation(x[x_id], y[y_id])
  sep_rad <- sep_arcsec / .arcsec_per_rad

  keep <- sep_rad <= theta
  if (!any(keep)) {
    return(.coord_match_empty())
  }

  data.frame(
    x_id = as.integer(x_id[keep]),
    y_id = as.integer(y_id[keep]),
    sep = .match_rad_to_unit(sep_rad[keep], unit)
  )
}

.coord_match_kdtree <- function(x, y, theta, unit, recalc_by_erfa) {
  if (!requireNamespace("dbscan", quietly = TRUE)) {
    stop(
      "`coord_match(..., method = \"kdtree\")` requires package `dbscan`.",
      call. = FALSE
    )
  }

  x_cart <- to_cartesian(x)
  y_cart <- to_cartesian(y)
  x_ok <- which(stats::complete.cases(x_cart))
  y_ok <- which(stats::complete.cases(y_cart))

  if (length(x_ok) == 0L || length(y_ok) == 0L) {
    return(.coord_match_empty())
  }

  radius_3d <- if (is.infinite(theta)) 2 else 2 * sin(theta / 2)
  nn <- dbscan::frNN(
    x = as.matrix(y_cart[y_ok, , drop = FALSE]),
    query = as.matrix(x_cart[x_ok, , drop = FALSE]),
    eps = radius_3d,
    sort = TRUE
  )

  pairs_local <- .coord_match_expand_ids(nn$id)
  if (nrow(pairs_local) == 0L) {
    return(.coord_match_empty())
  }

  x_id <- x_ok[pairs_local$x_id]
  y_id <- y_ok[pairs_local$y_id]

  dx <- x_cart$x[x_id] - y_cart$x[y_id]
  dy <- x_cart$y[x_id] - y_cart$y[y_id]
  dz <- x_cart$z[x_id] - y_cart$z[y_id]
  candidates <- data.frame(
    x_id = as.integer(x_id),
    y_id = as.integer(y_id),
    dist_3d = sqrt(dx * dx + dy * dy + dz * dz)
  )

  if (isTRUE(recalc_by_erfa)) {
    sep_rad <- separation(x[candidates$x_id], y[candidates$y_id]) / .arcsec_per_rad
  } else {
    sep_rad <- 2 * asin(pmin(pmax(candidates$dist_3d / 2, -1), 1))
  }

  keep <- sep_rad <= theta
  if (!any(keep)) {
    return(.coord_match_empty())
  }

  data.frame(
    x_id = candidates$x_id[keep],
    y_id = candidates$y_id[keep],
    sep = .match_rad_to_unit(sep_rad[keep], unit)
  )
}

#' Match two sky catalogs within angular radius
#'
#' Low-level spherical catalog matching for two `sky_coord` vectors.
#'
#' @param x,y `<sky_coord>` vectors.
#' @param max_sep Maximum separation threshold.
#' @param unit Separation unit: `"arcsec"`, `"deg"`, or `"rad"`.
#' @param method Matching backend: `"auto"`, `"kdtree"`, or `"bruteforce"`.
#' @param recalc_by_erfa If `TRUE`, recompute candidate separations with
#'   `separation()`; otherwise use inverse chord-distance formula.
#'
#' @return Base `data.frame` with columns `x_id`, `y_id`, `sep`.
#'
#' @details
#' If frames differ, `y` is transformed to the frame of `x`.
#'
#' `method = "auto"` uses `"bruteforce"` when `length(x) * length(y) <= 1e6`,
#' and `"kdtree"` otherwise.
#'
#' Rows are sorted by `x_id`, then `sep`, then `y_id`.
#'
#' If an `x_id` has no matches, one row is returned with `y_id = NA` and
#' `sep = NA`.
#' @export
coord_match <- function(
  x,
  y,
  max_sep,
  unit = c("arcsec", "deg", "rad"),
  method = c("auto", "kdtree", "bruteforce"),
  recalc_by_erfa = FALSE
) {
  x <- .validate_sky_coord(x)
  y <- .validate_sky_coord(y)
  unit <- match.arg(unit)
  method <- match.arg(method)
  checkmate::assert_number(max_sep, lower = 0, finite = FALSE, .var.name = "max_sep")
  checkmate::assert_flag(recalc_by_erfa, .var.name = "recalc_by_erfa")

  n_x <- length(x)
  n_y <- length(y)
  theta <- .match_unit_to_rad(max_sep, unit)

  if (!.same_frame(frame(x), frame(y))) {
    y <- transform_to(y, frame(x))
  }

  if (method == "auto") {
    method <- .coord_match_method_auto(n_x, n_y)
  }

  if (n_x == 0L) {
    return(.coord_match_empty())
  }

  if (n_y == 0L) {
    return(
      data.frame(
        x_id = as.integer(seq_len(n_x)),
        y_id = rep(NA_integer_, n_x),
        sep = rep(NA_real_, n_x)
      )
    )
  }

  if (method == "kdtree") {
    out <- .coord_match_kdtree(
      x = x,
      y = y,
      theta = theta,
      unit = unit,
      recalc_by_erfa = recalc_by_erfa
    )
  } else {
    out <- .coord_match_bruteforce(
      x = x,
      y = y,
      theta = theta,
      unit = unit
    )
  }

  out <- .coord_match_add_unmatched(out, n_x)
  .coord_match_sort(out)
}

#' Nearest-neighbor match for sky catalogs
#'
#' Return one nearest source in `y` for each source in `x`.
#'
#' @inheritParams coord_match
#'
#' @return Base `data.frame` with columns `x_id`, `y_id`, `sep`.
#'
#' @details
#' Internally calls `coord_match(..., max_sep = Inf)` and keeps only
#' one nearest row per `x_id`.
#' @export
coord_nearest <- function(
  x,
  y,
  unit = c("arcsec", "deg", "rad"),
  method = c("auto", "kdtree", "bruteforce"),
  recalc_by_erfa = FALSE
) {
  out <- coord_match(
    x = x,
    y = y,
    max_sep = Inf,
    unit = match.arg(unit),
    method = match.arg(method),
    recalc_by_erfa = recalc_by_erfa
  )

  if (nrow(out) == 0L) {
    return(out)
  }

  out <- out[!duplicated(out$x_id), c("x_id", "y_id", "sep"), drop = FALSE]
  rownames(out) <- NULL
  out
}
