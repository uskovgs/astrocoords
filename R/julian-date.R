#' Convert date-time to Julian Date (JD)
#'
#' @param x Date-time input as `POSIXct`, `POSIXlt`, or `Date`.
#'
#'   `Date` values are interpreted as `00:00:00` in UTC.
#'
#' @param scale Time scale used by ERFA. Only `"UTC"` is currently supported.
#'
#' @return Numeric vector with Julian Date values (in days).
#'
#' @details
#' The fractional part of JD encodes time of day.
#'
#' JD starts at noon, so calendar midnight corresponds to `.5` in JD.
#'
#' @seealso \code{\link{jd2greg}}, \code{\link{mjd2greg}}
#'
#' @examples
#' t <- as.POSIXct("2026-03-08 12:34:56", tz = "UTC")
#' jd_fromdate(t)
#'
#' jd_fromdate(as.Date("2026-03-08"))
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

#' Convert Julian Date (JD) to POSIXct
#'
#' @param jd Numeric vector of Julian Date values.
#' @param scale Time scale used by ERFA. Only `"UTC"` is currently supported.
#' @param tz Time zone for the returned `POSIXct` vector.
#'
#' @return `POSIXct` vector.
#'
#' @details
#' `tz` affects the returned clock representation, not the underlying moment.
#'
#' @seealso \code{\link{jd_fromdate}}, \code{\link{mjd2greg}}
#'
#' @examples
#' jd <- 2461107.5
#' jd2greg(jd, tz = "UTC")
#' jd2greg(jd, tz = "Europe/Moscow")
#'
#' x <- as.POSIXct("2026-03-08 00:00:00", tz = "UTC")
#' jd2greg(jd_fromdate(x), tz = "UTC")
#' @export
jd2greg <- function(jd, scale = "UTC", tz = "UTC") {
  scale <- .assert_scale_utc(scale)
  jd <- vctrs::vec_cast(jd, double())

  parts <- split_jd2_mjd(jd)
  .d2dtf_to_posixct(parts$d1, parts$d2, scale = scale, tz = tz, ndp = 6L)
}

#' Convert Modified Julian Date (MJD) to POSIXct
#'
#' @param mjd Numeric vector of Modified Julian Date values.
#' @param scale Time scale used by ERFA. Only `"UTC"` is currently supported.
#' @param tz Time zone for the returned `POSIXct` vector.
#'
#' @return `POSIXct` vector.
#'
#' @details
#' MJD is related to JD by:
#' \deqn{MJD = JD - 2400000.5}
#'
#' @seealso \code{\link{jd2greg}}, \code{\link{jd_fromdate}}
#'
#' @examples
#' mjd2greg(61107, tz = "UTC")
#'
#' m <- 61107.25
#' mjd2greg(m, tz = "UTC")
#' jd2greg(m + 2400000.5, tz = "UTC")
#' @export
mjd2greg <- function(mjd, scale = "UTC", tz = "UTC") {
  scale <- .assert_scale_utc(scale)
  mjd <- vctrs::vec_cast(mjd, double())

  d1 <- rep_len(.mjd_origin, length(mjd))
  d2 <- mjd
  .d2dtf_to_posixct(d1, d2, scale = scale, tz = tz, ndp = 6L)
}
