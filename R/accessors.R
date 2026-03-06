#' Right ascension accessor
#'
#' @param x A <sky_coord> vector.
#'
#' @return Numeric vector.
#' @export
ra <- function(x) {
  x <- .validate_sky_coord(x)
  vctrs::vec_data(x)$lon
}

#' Declination accessor
#'
#' @param x A <sky_coord> vector.
#'
#' @return Numeric vector.
#' @export
dec <- function(x) {
  x <- .validate_sky_coord(x)
  vctrs::vec_data(x)$lat
}

#' Frame accessor
#'
#' @param x A <sky_coord> vector.
#'
#' @return A <sky_frame> object.
#' @export
frame <- function(x) {
  x <- .validate_sky_coord(x)
  attr(x, "frame", exact = TRUE)
}

#' Sugar constructor for ICRS coordinates
#'
#' @param ra,dec Coordinates in degrees.
#'
#' @return A <sky_coord> vector in ICRS frame.
#' @export
ra_dec <- function(ra, dec) {
  sky_coord(ra, dec, frame = icrs())
}

#' Sugar constructor for Galactic coordinates
#'
#' @param l,b Coordinates in degrees.
#'
#' @return A <sky_coord> vector in Galactic frame.
#' @export
gal_coord <- function(l, b) {
  sky_coord(l, b, frame = galactic())
}
