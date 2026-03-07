`%||%` <- function(x, y) if (is.null(x)) y else x

.rad_to_deg <- function(x) {
  x * 180 / pi
}

.deg_to_rad <- function(x) {
  x * pi / 180
}

.normalize_lon_deg <- function(x) {
  x %% 360
}

.validate_equal_lengths <- function(x, y) {
  if (vctrs::vec_size(x) != vctrs::vec_size(y)) {
    stop("`x` and `y` must have the same length.")
  }
}

.validate_longitude <- function(lon, name = "lon") {
  checkmate::assert_numeric(
    lon,
    lower = 0,
    upper = 360,
    any.missing = TRUE,
    finite = FALSE,
    .var.name = name
  )
}

.validate_latitude <- function(lat, name = "lat") {
  checkmate::assert_numeric(
    lat,
    lower = -90,
    upper = 90,
    any.missing = TRUE,
    finite = FALSE,
    .var.name = name
  )
}

.validate_frame <- function(x) {
  checkmate::assert_class(x, "sky_frame", .var.name = checkmate::vname(x))
  x
}

.validate_ranges_for_frame <- function(lon, lat, frame) {
  x_name <- frame$x_name %||% "lon"
  y_name <- frame$y_name %||% "lat"

  .validate_longitude(lon, name = x_name)
  .validate_latitude(lat, name = y_name)
}

.validate_sky_coord <- function(x) {
  checkmate::assert_class(x, "sky_coord", .var.name = checkmate::vname(x))
  x
}
