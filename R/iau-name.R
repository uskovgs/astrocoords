.format_iau_ra <- function(ra_deg, digits = 1L) {
  digits <- max(as.integer(digits), 0L)
  factor <- 10^digits
  total_units <- round(((ra_deg %% 360) / 15) * 3600 * factor)
  day_units <- 24L * 3600L * factor
  total_units <- total_units %% day_units

  hour_units <- 3600L * factor
  minute_units <- 60L * factor

  hh <- total_units %/% hour_units
  rem <- total_units %% hour_units
  mm <- rem %/% minute_units
  rem <- rem %% minute_units
  ss <- rem / factor

  sec_width <- 2L + if (digits > 0L) digits + 1L else 0L
  sec_fmt <- paste0("%0", sec_width, ".", digits, "f")

  paste0(
    sprintf("%02d", hh),
    sprintf("%02d", mm),
    sprintf(sec_fmt, ss)
  )
}

.format_iau_dec <- function(dec_deg, digits = 0L) {
  digits <- max(as.integer(digits), 0L)
  factor <- 10^digits
  sign_str <- ifelse(dec_deg < 0, "-", "+")
  total_units <- round(abs(dec_deg) * 3600 * factor)

  degree_units <- 3600L * factor
  minute_units <- 60L * factor

  dd <- total_units %/% degree_units
  rem <- total_units %% degree_units
  mm <- rem %/% minute_units
  rem <- rem %% minute_units
  ss <- rem / factor

  sec_width <- 2L + if (digits > 0L) digits + 1L else 0L
  sec_fmt <- paste0("%0", sec_width, ".", digits, "f")

  paste0(
    sign_str,
    sprintf("%02d", dd),
    sprintf("%02d", mm),
    sprintf(sec_fmt, ss)
  )
}

#' Build IAU-style source names from sky coordinates
#'
#' @param x A <sky_coord> vector.
#' @param prefix Optional string added before the epoch code.
#' @param epoch Epoch code, usually "J".
#' @param ra_digits Number of digits after the decimal point in RA seconds.
#' @param dec_digits Number of digits after the decimal point in Dec seconds.
#'
#' @return Character vector.
#'
#' @examples
#' x <- parse_coord("J230631.0+155633")
#'
#' iau_name(x)
#' iau_name(x, prefix = "SRGA J")
#' iau_name(x, ra_digits = 2, dec_digits = 1)
#'
#' # Non-ICRS inputs are transformed internally
#' iau_name(transform_to(x, galactic()))
#' @export
iau_name <- function(x, prefix = NULL, epoch = "J", ra_digits = 1, dec_digits = 0) {
  x <- .validate_sky_coord(x)

  if (!is.null(prefix)) {
    prefix <- vctrs::vec_cast(prefix, character())
    if (length(prefix) != 1L || is.na(prefix)) {
      stop("`prefix` must be NULL or a single non-missing string.", call. = FALSE)
    }
  }

  epoch <- vctrs::vec_cast(epoch, character())
  if (length(epoch) != 1L || is.na(epoch)) {
    stop("`epoch` must be a single non-missing string.", call. = FALSE)
  }

  if (!identical(frame(x)$name, "icrs")) {
    x <- transform_to(x, icrs())
  }

  lon <- vctrs::vec_data(x)$lon
  lat <- vctrs::vec_data(x)$lat
  ok <- !(is.na(lon) | is.na(lat))
  name_prefix <- if (is.null(prefix)) epoch else prefix

  out <- rep_len(NA_character_, length(lon))
  out[ok] <- paste0(
    name_prefix,
    .format_iau_ra(lon[ok], digits = ra_digits),
    .format_iau_dec(lat[ok], digits = dec_digits)
  )

  out
}
