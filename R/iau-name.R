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
  .validate_sky_coord(x)

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

  if (frame(x)$name != "icrs") {
    x <- transform_to(x, icrs())
  }

  lon <- vctrs::vec_data(x)$lon
  lat <- vctrs::vec_data(x)$lat
  ok <- !(is.na(lon) | is.na(lat))
  name_prefix <- if (is.null(prefix)) epoch else prefix

  out <- rep_len(NA_character_, length(lon))
  out[ok] <- paste0(
    name_prefix,
    deg_to_hms(lon[ok], digits = ra_digits, sep = ""),
    deg_to_dms(lat[ok], digits = dec_digits, sep = "")
  )

  out
}
