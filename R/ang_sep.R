#' Angular separation on the sphere
#'
#' @param lon1,lat1 First point.
#' @param lon2,lat2 Second point.
#' @param unit "rad" or "deg".
#'
#' @return Numeric vector.
#' @export
ang_sep <- function(lon1, lat1, lon2, lat2, unit = c("rad", "deg")) {
  unit <- match.arg(unit)

  n <- max(length(lon1), length(lat1), length(lon2), length(lat2))
  lon1 <- rep_len(lon1, n)
  lat1 <- rep_len(lat1, n)
  lon2 <- rep_len(lon2, n)
  lat2 <- rep_len(lat2, n)

  if (unit == "deg") {
    to_rad <- pi / 180
    out <- cpp_era_seps(
      lon1 * to_rad,
      lat1 * to_rad,
      lon2 * to_rad,
      lat2 * to_rad
    )
    out * 180 / pi
  } else {
    cpp_era_seps(lon1, lat1, lon2, lat2)
  }
}
