.coord_match_empty <- function() {
  matrix(
    numeric(0),
    ncol = 3,
    dimnames = list(NULL, c("x_id", "y_id", "sep"))
  )
}

.coord_match_expand_ids <- function(id_list) {
  n <- length(id_list)
  if (n == 0L) {
    return(.coord_match_empty())
  }

  lens <- lengths(id_list)
  if (!any(lens > 0L)) {
    return(.coord_match_empty())
  }

  cbind(
    x_id = rep.int(seq_len(n), lens),
    y_id = as.integer(unlist(id_list, use.names = FALSE))
  )
}

.coord_match_add_unmatched <- function(out, n_x) {
  if (n_x == 0L) {
    return(out)
  }

  if (nrow(out) == 0L) {
    missing_x <- seq_len(n_x)
  } else {
    matched <- rep_len(FALSE, n_x)
    x_id <- out[, "x_id"]
    x_id <- x_id[!is.na(x_id)]
    if (length(x_id) > 0L) {
      matched[as.integer(x_id)] <- TRUE
    }
    missing_x <- which(!matched)
  }

  if (length(missing_x) == 0L) {
    return(out)
  }

  rbind(
    out,
    cbind(
      x_id = as.integer(missing_x),
      y_id = rep(NA_integer_, length(missing_x)),
      sep = rep(NA_real_, length(missing_x))
    )
  )
}

.coord_match_sort <- function(out) {
  if (nrow(out) == 0L) {
    return(out)
  }

  x_id <- out[, "x_id"]
  y_id <- out[, "y_id"]
  sep <- out[, "sep"]

  if (anyNA(sep) || anyNA(y_id)) {
    ord <- order(x_id, is.na(sep), sep, is.na(y_id), y_id)
  } else {
    ord <- order(x_id, sep, y_id)
  }

  out[ord, c("x_id", "y_id", "sep"), drop = FALSE]
}

.coord_match_bruteforce <- function(x, y, theta) {
  n_x <- length(x)
  n_y <- length(y)
  x_id <- rep(seq_len(n_x), each = n_y)
  y_id <- rep.int(seq_len(n_y), n_x)

  data_x <- vctrs::vec_data(x)
  data_y <- vctrs::vec_data(y)

  lon_x_rad <- .deg_to_rad(data_x$lon)
  lat_x_rad <- .deg_to_rad(data_x$lat)
  lon_y_rad <- .deg_to_rad(data_y$lon)
  lat_y_rad <- .deg_to_rad(data_y$lat)

  sep_rad <- cpp_era_seps(
    lon1 = lon_x_rad[x_id],
    lat1 = lat_x_rad[x_id],
    lon2 = lon_y_rad[y_id],
    lat2 = lat_y_rad[y_id]
  )

  keep <- sep_rad <= theta
  if (!any(keep)) {
    return(.coord_match_empty())
  }

  cbind(
    x_id = x_id[keep], 
    y_id = y_id[keep], 
    sep = sep_rad[keep]
  )
}

.coord_match_kdtree <- function(x, y, theta) {
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
    x = y_cart[y_ok, , drop = FALSE],
    query = x_cart[x_ok, , drop = FALSE],
    eps = radius_3d,
    sort = FALSE
  )

  pairs_local <- .coord_match_expand_ids(nn$id)
  if (nrow(pairs_local) == 0L) {
    return(.coord_match_empty())
  }

  x_id <- x_ok[pairs_local[, "x_id"]]
  y_id <- y_ok[pairs_local[, "y_id"]]

  dx <- x_cart[x_id, 1] - y_cart[y_id, 1]
  dy <- x_cart[x_id, 2] - y_cart[y_id, 2]
  dz <- x_cart[x_id, 3] - y_cart[y_id, 3]
  
  dist_3d <- sqrt(dx * dx + dy * dy + dz * dz)
  keep_chord <- dist_3d <= radius_3d
  if (!any(keep_chord)) {
    return(.coord_match_empty())
  }

  x_id <- x_id[keep_chord]
  y_id <- y_id[keep_chord]
  dist_3d <- dist_3d[keep_chord]
  sep_rad <- 2 * asin(pmin(pmax(dist_3d / 2, -1), 1))

  cbind(
    x_id = x_id,
    y_id = y_id,
    sep = sep_rad
  )
}

#' Match two sky catalogs within angular radius
#'
#' Low-level spherical catalog matching for two `sky_coord` vectors.
#'
#' @param x,y `<sky_coord>` vectors.
#' @param max_sep Maximum separation threshold.
#'   Used in [coord_match()]. [coord_nearest()] always uses `Inf`.
#' @param unit Separation unit: `"arcsec"`, `"arcmin"`, `"deg"`, or `"rad"`.
#' @param method Matching backend: `"kdtree"` or `"bruteforce"`.
#' @param sort If `TRUE` (default), sort matches by `x_id`, then `sep`, then `y_id`.
#'   Set to `FALSE` to skip sorting for better performance.
#'
#' @return Numeric matrix with columns `x_id`, `y_id`, `sep`.
#'   `sep` is returned in the same unit as `unit`.
#'
#' @details
#' If frames differ, `y` is transformed to the frame of `x`.
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
  unit = "arcsec",
  method = "kdtree",
  sort = TRUE
) {
  .validate_sky_coord(x)
  .validate_sky_coord(y)
  checkmate::assert_number(max_sep, lower = 0, finite = FALSE, .var.name = "max_sep")
  checkmate::assert_choice(unit, c("arcsec", "arcmin", "deg", "rad"), .var.name = "unit")
  checkmate::assert_choice(method, c("kdtree", "bruteforce"), .var.name = "method")
  checkmate::assert_logical(sort, any.missing = FALSE)
  

  n_x <- length(x)
  n_y <- length(y)
  unit_coeff <- .coeff_rad_to_unit(unit)
  theta_rad <- max_sep / unit_coeff

  if (n_x == 0L) {
    return(.coord_match_empty())
  }

  if (n_y == 0L) {
    return(
      cbind(
        x_id = seq_len(n_x),
        y_id = rep(NA_integer_, n_x),
        sep = rep(NA_real_, n_x)
      )
    )
  }

  if (!.same_frame(frame(x), frame(y))) {
    y <- transform_to(y, frame(x))
  }

  if (method == "kdtree") {
    out <- .coord_match_kdtree(
      x = x,
      y = y,
      theta = theta_rad
    )
  } else {
    out <- .coord_match_bruteforce(
      x = x,
      y = y,
      theta = theta_rad
    )
  }

  out <- .coord_match_add_unmatched(out, n_x)
  out[, "sep"] <- out[, "sep"] * unit_coeff

  if (!sort) {
    return(out)  
  }
  .coord_match_sort(out)
  
}

#' @rdname coord_match
#' @export
coord_nearest <- function(
  x,
  y,
  unit = "arcsec",
  method = "kdtree"
) {
  out <- coord_match(
    x = x,
    y = y,
    max_sep = Inf,
    unit = unit,
    method = method,
    sort = TRUE
  )

  if (nrow(out) == 0L) {
    return(out)
  }

  out[!duplicated(out[, "x_id"]), c("x_id", "y_id", "sep"), drop = FALSE]
}
