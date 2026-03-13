#' Angular separation between sky coordinates
#'
#' @param x,y <sky_coord> vectors.
#' @param unit Separation unit: `"arcsec"` (default), `"arcmin"`, `"deg"`,
#'   or `"rad"`.
#'
#' @return Numeric vector of angular separation.
#' @examples
#' x <- ra_dec(10, 20)
#' y <- ra_dec(11, 21)
#' separation(x, y)
#'
#' g <- transform_to(x, galactic())
#' separation(g, y)
#' @export
separation <- function(x, y, unit = "arcsec") {
  UseMethod("separation")
}

#' @export
separation.default <- function(x, y, unit = "arcsec") {
  .validate_sky_coord(x)
}

#' @export
separation.sky_coord <- function(x, y, unit = "arcsec") {
  .validate_sky_coord(x)
  .validate_sky_coord(y)
  checkmate::assert_choice(
    unit,
    choices = c("arcsec", "arcmin", "deg", "rad"),
    .var.name = "unit"
  )


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

  dist_rad <- cpp_era_seps(
    lon1 = .deg_to_rad(data_x$lon),
    lat1 = .deg_to_rad(data_x$lat),
    lon2 = .deg_to_rad(data_y$lon),
    lat2 = .deg_to_rad(data_y$lat)
  )
  
  dist_rad * .coeff_rad_to_unit(unit)
}



