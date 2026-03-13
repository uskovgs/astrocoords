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
  checkmate::assert_true(length(x) == length(y))
}


.validate_frame <- function(x) {
  checkmate::assert_class(x, "sky_frame", .var.name = checkmate::vname(x))
}

.validate_ranges_for_frame <- function(lon, lat, frame) {
  checkmate::assert_numeric(
    lon,
    lower = frame$x_min,
    upper = frame$x_max,
    .var.name = frame$x_name,
    any.missing = TRUE,
    finite = FALSE
  )

  checkmate::assert_numeric(
    lat,
    lower = frame$y_min,
    upper = frame$y_max,
    .var.name = frame$y_name,
    any.missing = TRUE,
    finite = FALSE
  )
}

.validate_sky_coord <- function(x) {
  checkmate::assert_class(x, "sky_coord", .var.name = checkmate::vname(x))
}
