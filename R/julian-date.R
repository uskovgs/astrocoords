#' Convert date-time to Julian Date (JD)
#'
#' Convert regular calendar date-times to Julian Date.
#'
#' @param x Date-time values as `POSIXct`, `POSIXlt`, or `Date`.
#'
#'   `Date` values are treated as midnight (`00:00:00`) in UTC.
#'
#' @return Numeric vector of Julian Date values (days).
#'
#' @details
#' JD is a continuous day count used in astronomy.
#'
#' The fractional part is time of day.
#'
#' JD starts at noon, so midnight is shown as `.5`.
#'
#' Uses ERFA with `scale = "UTC"`. Leap seconds are handled by ERFA.
#'
#' @seealso \code{\link{jd_to_datetime}}, \code{\link{mjd_to_datetime}}
#'
#' @examples
#' old_accuracy <- getOption("digits")
#' options(digits = 11)
#'
#' t <- as.POSIXct("2026-03-08 12:34:56", tz = "UTC")
#' datetime_to_jd(t)
#'
#' datetime_to_jd(as.Date("2026-03-08"))
#'
#' options(digits = old_accuracy)
#' @export
datetime_to_jd <- function(x) {
  if (inherits(x, "Date")) {
    x <- as.POSIXct(x, tz = "UTC")
  } else if (inherits(x, "POSIXt")) {
    x <- as.POSIXct(x, tz = "UTC")
  } else {
    stop("`x` must be a POSIXct/POSIXlt or Date vector.", call. = FALSE)
  }

  lt <- as.POSIXlt(x, tz = "UTC")
  out <- cpp_era_dtf2d(
    scale = "UTC",
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

#' Convert Julian Date (JD) to date-time
#'
#' Convert Julian Date values back to regular date-time values.
#'
#' @param jd Numeric vector of Julian Date values.
#' @param tz Time zone for output `POSIXct` values.
#'
#' @return `POSIXct` vector.
#'
#' @details
#' `tz` changes only how time is displayed, not the physical moment.
#'
#' Uses ERFA with `scale = "UTC"`. Leap seconds are handled by ERFA.
#'
#' @seealso \code{\link{datetime_to_jd}}, \code{\link{mjd_to_datetime}}
#'
#' @examples
#' jd <- 2461107.5
#' jd_to_datetime(jd, tz = "UTC")
#' jd_to_datetime(jd, tz = "Europe/Moscow")
#'
#' x <- as.POSIXct("2026-03-08 00:00:00", tz = "UTC")
#' jd_to_datetime(datetime_to_jd(x), tz = "UTC")
#' @export
jd_to_datetime <- function(jd, tz = "UTC") {
  jd <- vctrs::vec_cast(jd, double())

  parts <- split_jd2_mjd(jd)
  .d2dtf_to_posixct(parts$d1, parts$d2, scale = "UTC", tz = tz, ndp = 6L)
}

#' Convert Modified Julian Date (MJD) to date-time
#'
#' Convert MJD values to regular date-time values.
#'
#' @param mjd Numeric vector of Modified Julian Date values.
#' @param tz Time zone for output `POSIXct` values.
#'
#' @return `POSIXct` vector.
#'
#' @details
#' MJD is related to JD by:
#' \deqn{MJD = JD - 2400000.5}
#'
#' Uses ERFA with `scale = "UTC"`. Leap seconds are handled by ERFA.
#'
#' @seealso \code{\link{jd_to_datetime}}, \code{\link{datetime_to_jd}}
#'
#' @examples
#' mjd_to_datetime(61107, tz = "UTC")
#'
#' m <- 61107.25
#' mjd_to_datetime(m, tz = "UTC")
#' jd_to_datetime(m + 2400000.5, tz = "UTC")
#' @export
mjd_to_datetime <- function(mjd, tz = "UTC") {
  mjd <- vctrs::vec_cast(mjd, double())

  d1 <- rep_len(.mjd_origin, length(mjd))
  d2 <- mjd
  .d2dtf_to_posixct(d1, d2, scale = "UTC", tz = tz, ndp = 6L)
}
