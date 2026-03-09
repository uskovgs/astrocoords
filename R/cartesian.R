#' Convert sky coordinates to Cartesian unit vectors
#'
#' Convert spherical sky coordinates (degrees) to unit Cartesian vectors.
#'
#' @param x A `<sky_coord>` vector.
#'
#' @return A numeric matrix with columns `x`, `y`, `z`.
#' @export
to_cartesian <- function(x) {
  x <- .validate_sky_coord(x)
  data <- vctrs::vec_data(x)

  cpp_era_s2c(
    lon = .deg_to_rad(data$lon),
    lat = .deg_to_rad(data$lat)
  )
}
