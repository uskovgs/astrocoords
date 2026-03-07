.mjd_origin <- 2400000.5

degenerate_jd2 <- function(d1, d2) {
  d1 + d2
}

split_jd2_mjd <- function(jd) {
  list(
    d1 = rep_len(.mjd_origin, length(jd)),
    d2 = jd - .mjd_origin
  )
}

.assert_scale_utc <- function(scale) {
  scale <- toupper(scale)
  if (!identical(scale, "UTC")) {
    stop("Only `scale = \"UTC\"` is supported in this step.", call. = FALSE)
  }
  scale
}

.handle_erfa_status <- function(status, context = "ERFA call") {
  status <- as.integer(status)
  ok <- !is.na(status)
  status <- status[ok]

  if (length(status) == 0L) {
    return(invisible(NULL))
  }

  neg <- sort(unique(status[status < 0L]))
  if (length(neg) > 0L) {
    stop(
      sprintf("%s failed with ERFA status code(s): %s", context, paste(neg, collapse = ", ")),
      call. = FALSE
    )
  }

  pos <- sort(unique(status[status > 0L]))
  if (length(pos) > 0L) {
    warning(
      sprintf("%s returned ERFA warning status code(s): %s", context, paste(pos, collapse = ", ")),
      call. = FALSE
    )
  }

  invisible(NULL)
}

.d2dtf_to_posixct <- function(d1, d2, scale = "UTC", tz = "UTC", ndp = 6L) {
  scale <- .assert_scale_utc(scale)
  out <- cpp_era_d2dtf(scale = scale, ndp = as.integer(ndp), d1 = d1, d2 = d2)
  .handle_erfa_status(out$status, context = "eraD2dtf")

  sec <- out$second + out$fraction / (10^as.integer(ndp))
  ISOdatetime(
    year = out$year,
    month = out$month,
    day = out$day,
    hour = out$hour,
    min = out$minute,
    sec = sec,
    tz = tz
  )
}
