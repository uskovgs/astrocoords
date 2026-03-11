.parse_j_coord <- function(x) {
  j_pattern <- "J(\\d{2})(\\d{2})(\\d{2}(?:\\.\\d*)?)([+-])(\\d{2})(\\d{2})(\\d{2}(?:\\.\\d*)?)(?!\\d)"
  parts <- stringi::stri_match_first_regex(
    x,
    j_pattern
  )
  ok <- !is.na(parts[, 1])
  n <- length(x)
  ra <- rep_len(NA_real_, n)
  dec <- rep_len(NA_real_, n)

  if (any(ok)) {
    ra_h <- as.numeric(parts[ok, 2])
    ra_m <- as.numeric(parts[ok, 3])
    ra_s <- as.numeric(parts[ok, 4])
    dec_sign <- ifelse(parts[ok, 5] == "-", -1, 1)
    dec_d <- as.numeric(parts[ok, 6])
    dec_m <- as.numeric(parts[ok, 7])
    dec_s <- as.numeric(parts[ok, 8])

    ra[ok] <- hms_to_deg(ra_h, ra_m, ra_s)
    dec[ok] <- dms_to_deg(dec_sign * dec_d, dec_m, dec_s)
  }

  list(ra = ra, dec = dec)
}



.parse_hms_dms_coord <- function(x) {
  clean <- stringi::stri_trim_both(x)
  clean <- stringi::stri_replace_all_regex(
    clean,
    "[hHdD\\u00B0mM'\"\\u2019sS:,]+",
    " "
  )
  clean <- stringi::stri_replace_all_regex(clean, "\\s+", " ")
  clean <- stringi::stri_trim_both(clean)

  parts <- stringi::stri_match_first_regex(
    clean,
    "^([0-9]{1,2}) ([0-9]{1,2}) ([0-9]{1,2}(?:\\.[0-9]*)?) ([+-][0-9]{1,2}) ([0-9]{1,2}) ([0-9]{1,2}(?:\\.[0-9]*)?)$"
  )

  ok <- !is.na(parts[, 1])
  n <- length(x)
  ra <- rep_len(NA_real_, n)
  dec <- rep_len(NA_real_, n)

  if (any(ok)) {
    ra_h <- as.numeric(parts[ok, 2])
    ra_m <- as.numeric(parts[ok, 3])
    ra_s <- as.numeric(parts[ok, 4])
    dec_d <- as.numeric(parts[ok, 5])
    dec_m <- as.numeric(parts[ok, 6])
    dec_s <- as.numeric(parts[ok, 7])

    ra[ok] <- hms_to_deg(ra_h, ra_m, ra_s)
    dec[ok] <- dms_to_deg(dec_d, dec_m, dec_s)
  }

  list(ra = ra, dec = dec)
}

.parse_coord <- function(x) {
  x <- trimws(x)
  n <- length(x)
  ra <- rep_len(NA_real_, n)
  dec <- rep_len(NA_real_, n)

  is_j <- stringi::stri_detect_regex(
    x,
    "J\\d{2}\\d{2}\\d{2}(?:\\.\\d*)?[+-]\\d{2}\\d{2}\\d{2}(?:\\.\\d*)?(?!\\d)"
  )
  is_hms_dms <- !is_j

  if (any(is_j)) {
    parsed_j <- .parse_j_coord(x[is_j])
    ra[is_j] <- parsed_j$ra
    dec[is_j] <- parsed_j$dec
  }

  if (any(is_hms_dms)) {
    parsed_h <- .parse_hms_dms_coord(x[is_hms_dms])
    ra[is_hms_dms] <- parsed_h$ra
    dec[is_hms_dms] <- parsed_h$dec
  }

  list(ra = ra, dec = dec)
}

#' Parse coordinate strings into ICRS sky_coord
#'
#' Parse a character vector of ICRS coordinates into a `sky_coord` vector.
#' The parser currently supports two input families:
#'
#' 1. Compact J-style token (can appear inside catalog names):
#'    - `JHHMMSS(.s)+DDMMSS(.s)`
#'    - examples: `"J230631.0+155633"`, `"SRGA J230631.0+155633"`
#'
#' 2. Sexagesimal token with full components:
#'    - `HH MM SS +/-DD MM SS`
#'    - all six components are required (no partial forms)
#'    - separators may be spaces, `:`, or HMS/DMS markers (`h m s d \\u00B0 ' "`)
#'    - examples: `"12 34 56 -76 54 3.210"`,
#'      `"12:34:56 -76:54:3.210"`,
#'      `"12h34m56s -76d54m3.210s"`
#'
#' @param x Character vector with ICRS coordinates. `NA` values are preserved.
#'
#' @return A <sky_coord> vector in ICRS frame.
#' @export
#' 
#' @examples
#' library(astrocoords)
#' 
#' parse_coord("12 34 56 -76 54 3.210")
#' 
#' parse_coord("12:34:56 -76:54:3.210")
#' 
#' parse_coord("12h34m56s -76d54m3.210s")
#'
#' parse_coord(c(
#'   "SRGA J230631.0+155633",
#'   "J230631.0+155633",
#'   "12:34:56 -76:54:3.210"
#' ))
#' 
parse_coord <- function(x = character()) {
  x <- vctrs::vec_cast(x, character())
  n <- length(x)

  ra <- rep_len(NA_real_, n)
  dec <- rep_len(NA_real_, n)

  idx <- which(!is.na(x))
  if (length(idx) > 0L) {
    parsed <- .parse_coord(x[idx])
    ok <- !is.na(parsed$ra) & !is.na(parsed$dec)
    if (any(!ok)) {
      bad_local <- which(!ok)[1]
      bad_pos <- idx[bad_local]
      stop(
        sprintf("Could not parse coordinate at position %d: `%s`.", bad_pos, x[bad_pos]),
        call. = FALSE
      )
    }

    ra[idx] <- parsed$ra
    dec[idx] <- parsed$dec
  }

  sky_coord(ra, dec, frame = icrs())
}
