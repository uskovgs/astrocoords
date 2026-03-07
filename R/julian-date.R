#' Julian Date from date-time
#'
#' @param x POSIXct/POSIXlt or Date vector.
#' @param scale ERFA timescale. Only "UTC" is currently supported.
#'
#' @return Numeric vector with Julian Date.
#' @export
jd_fromdate <- function(x, scale = "UTC") {
  scale <- .assert_scale_utc(scale)

  if (inherits(x, "Date")) {
    x <- as.POSIXct(x, tz = "UTC")
  } else if (inherits(x, "POSIXt")) {
    x <- as.POSIXct(x, tz = "UTC")
  } else {
    stop("`x` must be a POSIXct/POSIXlt or Date vector.", call. = FALSE)
  }

  lt <- as.POSIXlt(x, tz = "UTC")
  out <- cpp_era_dtf2d(
    scale = scale,
    year = lt$year + 1900L,
    month = lt$mon + 1L,
    day = lt$mday,
    hour = lt$hour,
    minute = lt$min,
    second = lt$sec
  )

  .handle_erfa_status(out$status, context = "eraDtf2d")
  degenerate_jd2(out$d1, out$d2)
}

#' POSIXct from Julian Date
#'
#' @param jd Numeric vector of Julian Date.
#' @param scale ERFA timescale. Only "UTC" is currently supported.
#' @param tz Time zone for returned POSIXct.
#'
#' @return POSIXct vector.
#' @export
jd2greg <- function(jd, scale = "UTC", tz = "UTC") {
  scale <- .assert_scale_utc(scale)
  jd <- vctrs::vec_cast(jd, double())

  parts <- split_jd2_mjd(jd)
  .d2dtf_to_posixct(parts$d1, parts$d2, scale = scale, tz = tz, ndp = 6L)
}

#' POSIXct from Modified Julian Date
#'
#' @param mjd Numeric vector of Modified Julian Date.
#' @param scale ERFA timescale. Only "UTC" is currently supported.
#' @param tz Time zone for returned POSIXct.
#'
#' @return POSIXct vector.
#' @export
mjd2greg <- function(mjd, scale = "UTC", tz = "UTC") {
  scale <- .assert_scale_utc(scale)
  mjd <- vctrs::vec_cast(mjd, double())

  d1 <- rep_len(.mjd_origin, length(mjd))
  d2 <- mjd
  .d2dtf_to_posixct(d1, d2, scale = scale, tz = tz, ndp = 6L)
}
