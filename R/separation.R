.arcsec_per_rad <- 180 / pi * 3600

#' Angular separation between sky coordinates
#'
#' @param x,y <sky_coord> vectors.
#'
#' @return Numeric vector in arcseconds.
#' @export
separation <- function(x, y) {
  UseMethod("separation")
}

#' @export
separation.default <- function(x, y) {
  stop("`x` must be a <sky_coord>.", call. = FALSE)
}

#' @export
separation.sky_coord <- function(x, y) {
  x <- .validate_sky_coord(x, "x")
  y <- .validate_sky_coord(y, "y")

  coords <- vctrs::vec_recycle_common(x = x, y = y)
  x <- coords$x
  y <- coords$y

  frame_x <- frame(x)
  frame_y <- frame(y)

  if (!.same_frame(frame_x, frame_y)) {
    stop("`x` and `y` must use the same frame.", call. = FALSE)
  }

  data_x <- vctrs::vec_data(x)
  data_y <- vctrs::vec_data(y)

  cpp_era_seps(
    lon1 = .deg_to_rad(data_x$lon),
    lat1 = .deg_to_rad(data_x$lat),
    lon2 = .deg_to_rad(data_y$lon),
    lat2 = .deg_to_rad(data_y$lat)
  ) * .arcsec_per_rad
}
