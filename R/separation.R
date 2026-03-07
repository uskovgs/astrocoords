.arcsec_per_rad <- 180 / pi * 3600

#' Angular separation between sky coordinates
#'
#' @param x,y <sky_coord> vectors.
#'
#' @return Numeric vector in arcseconds.
#' @examples
#' x <- ra_dec(10, 20)
#' y <- ra_dec(11, 21)
#' separation(x, y)
#'
#' g <- transform_to(x, galactic())
#' separation(g, y)
#' @export
separation <- function(x, y) {
  UseMethod("separation")
}

#' @export
separation.default <- function(x, y) {
  .validate_sky_coord(x)
}

#' @export
separation.sky_coord <- function(x, y) {
  x <- .validate_sky_coord(x)
  y <- .validate_sky_coord(y)

  coords <- vctrs::vec_recycle_common(x = x, y = y)
  x <- coords$x
  y <- coords$y

  frame_x <- frame(x)
  frame_y <- frame(y)

  if (!.same_frame(frame_x, frame_y)) {
    y <- transform_to(y, frame_x)
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
