#' Get right ascension (RA)
#'
#' Extract right ascension values (in degrees) from ICRS coordinates.
#'
#' @param x A <sky_coord> vector in ICRS frame.
#'
#' @return Numeric vector with RA values in degrees.
#'
#' @examples
#' x <- ra_dec(c(10, 20), c(-5, 30))
#' ra(x)
#' @export
ra <- function(x) {
  .validate_sky_coord(x)
  .require_frame_name(x, expected = "icrs", accessor = "ra")
  vctrs::vec_data(x)$lon
}

#' Get declination (Dec)
#'
#' Extract declination values (in degrees) from ICRS coordinates.
#'
#' @param x A <sky_coord> vector in ICRS frame.
#'
#' @return Numeric vector with Dec values in degrees.
#'
#' @examples
#' x <- ra_dec(c(10, 20), c(-5, 30))
#' dec(x)
#' @export
dec <- function(x) {
  .validate_sky_coord(x)
  .require_frame_name(x, expected = "icrs", accessor = "dec")
  vctrs::vec_data(x)$lat
}

#' Frame accessor
#'
#' @param x A <sky_coord> vector.
#'
#' @return A <sky_frame> object.
#' @export
frame <- function(x) {
  .validate_sky_coord(x)
  attr(x, "frame", exact = TRUE)
}

.require_frame_name <- function(x, expected, accessor) {
  fr <- frame(x)
  if (!identical(fr$name, expected)) {
    stop(
      sprintf("`%s()` requires <%s> coordinates, got <%s>.", accessor, expected, fr$name),
      call. = FALSE
    )
  }
}

#' Get Galactic longitude (l)
#'
#' Extract Galactic longitude values (in degrees) from Galactic coordinates.
#'
#' @param x A <sky_coord> vector in Galactic frame.
#'
#' @return Numeric vector with Galactic longitude values in degrees.
#'
#' @examples
#' x <- gal_coord(c(120, 121), c(-30, -31))
#' l(x)
#' @export
l <- function(x) {
  .validate_sky_coord(x)
  .require_frame_name(x, expected = "galactic", accessor = "l")
  vctrs::vec_data(x)$lon
}

#' Get Galactic latitude (b)
#'
#' Extract Galactic latitude values (in degrees) from Galactic coordinates.
#'
#' @param x A <sky_coord> vector in Galactic frame.
#'
#' @return Numeric vector with Galactic latitude values in degrees.
#'
#' @examples
#' x <- gal_coord(c(120, 121), c(-30, -31))
#' b(x)
#' @export
b <- function(x) {
  .validate_sky_coord(x)
  .require_frame_name(x, expected = "galactic", accessor = "b")
  vctrs::vec_data(x)$lat
}

#' Create ICRS sky coordinates
#'
#' Convenience wrapper for `sky_coord(..., frame = icrs())`.
#'
#' @param ra,dec Coordinates in degrees.
#'
#' @return A <sky_coord> vector in ICRS frame.
#' @export
ra_dec <- function(ra, dec) {
  sky_coord(ra, dec, frame = icrs())
}

#' Create Galactic sky coordinates
#'
#' Convenience wrapper for `sky_coord(..., frame = galactic())`.
#'
#' @param l,b Coordinates in degrees.
#'
#' @return A <sky_coord> vector in Galactic frame.
#' @export
gal_coord <- function(l, b) {
  sky_coord(l, b, frame = galactic())
}
