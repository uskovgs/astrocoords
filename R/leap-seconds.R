#' Leap-second dates (UTC)
#'
#' Return UTC dates where the TAI-UTC offset changes by one second.
#'
#' Values are provided by ERFA.
#'
#' @return Date vector with leap-second change dates (effective at 00:00 UTC).
#'
#' @details
#' The returned date is when the new UTC offset is already in effect
#' (00:00 UTC at the start of that date).
#'
#' The first returned date is `1972-07-01` (the first leap second was inserted
#' at the end of `1972-06-30`).
#'
#' @examples
#' leap_second_dates()
#' @export
leap_second_dates <- function() {
  start <- as.Date("1972-01-01")
  end <- as.Date(sprintf("%04d-12-31", as.integer(format(Sys.Date(), "%Y"))))
  days <- seq.Date(start - 1L, end, by = "day")
  lt <- as.POSIXlt(days, tz = "UTC")

  out <- cpp_era_dat(
    year = lt$year + 1900L,
    month = lt$mon + 1L,
    day = lt$mday
  )
  .handle_erfa_status(out$status, context = "eraDat")

  delta <- diff(out$deltat)
  leap <- c(FALSE, abs(delta - 1.0) < 1e-6)
  days[leap]
}
