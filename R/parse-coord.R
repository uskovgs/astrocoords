.parse_j_coord <- function(x) {
  m <- regexec(
    "^J([0-9]{2})([0-9]{2})([0-9]{2}(?:\\.[0-9]*)?)([+-])([0-9]{2})([0-9]{2})([0-9]{2}(?:\\.[0-9]*)?)$",
    x
  )
  parts <- regmatches(x, m)[[1]]
  if (length(parts) == 0L) {
    return(NULL)
  }

  ra_h <- as.numeric(parts[2])
  ra_m <- as.numeric(parts[3])
  ra_s <- as.numeric(parts[4])
  dec_sign <- if (identical(parts[5], "-")) -1 else 1
  dec_d <- as.numeric(parts[6])
  dec_m <- as.numeric(parts[7])
  dec_s <- as.numeric(parts[8])

  list(
    ra = (ra_h + ra_m / 60 + ra_s / 3600) * 15,
    dec = dec_sign * (dec_d + dec_m / 60 + dec_s / 3600)
  )
}

.parse_hms_dms_coord <- function(x) {
  clean <- trimws(x)
  clean <- gsub("[hHdD\u00b0mM'\"sS:,]+", " ", clean)
  clean <- gsub("\\s+", " ", clean)
  clean <- trimws(clean)

  if (!nzchar(clean)) {
    return(NULL)
  }

  tok <- strsplit(clean, " ", fixed = TRUE)[[1]]
  if (length(tok) < 2L || length(tok) > 6L) {
    return(NULL)
  }

  num <- suppressWarnings(as.numeric(tok))
  if (any(is.na(num))) {
    return(NULL)
  }

  ra_h <- num[1]
  ra_m <- if (length(num) >= 2L) num[2] else 0
  ra_s <- if (length(num) >= 3L) num[3] else 0

  dec_pos <- if (length(num) >= 4L) 4L else 2L
  dec_tok <- tok[dec_pos]
  dec_d <- abs(num[dec_pos])
  dec_m <- if (length(num) >= (dec_pos + 1L)) num[dec_pos + 1L] else 0
  dec_s <- if (length(num) >= (dec_pos + 2L)) num[dec_pos + 2L] else 0
  dec_sign <- if (startsWith(dec_tok, "-")) -1 else 1

  list(
    ra = (ra_h + ra_m / 60 + ra_s / 3600) * 15,
    dec = dec_sign * (dec_d + dec_m / 60 + dec_s / 3600)
  )
}

.parse_single_coord <- function(x) {
  x <- trimws(x)
  out <- .parse_j_coord(x)
  if (!is.null(out)) {
    return(out)
  }

  out <- .parse_hms_dms_coord(x)
  if (!is.null(out)) {
    return(out)
  }

  NULL
}

#' Parse coordinate strings into ICRS sky_coord
#'
#' @param x Character vector with ICRS coordinates.
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
parse_coord <- function(x = character()) {
  x <- vctrs::vec_cast(x, character())
  n <- length(x)

  ra <- rep_len(NA_real_, n)
  dec <- rep_len(NA_real_, n)

  idx <- which(!is.na(x))
  for (i in idx) {
    parsed <- .parse_single_coord(x[i])
    if (is.null(parsed)) {
      stop(
        sprintf("Could not parse coordinate at position %d: `%s`.", i, x[i]),
        call. = FALSE
      )
    }

    ra[i] <- parsed$ra
    dec[i] <- parsed$dec
  }

  sky_coord(ra, dec, frame = icrs())
}

#' Deprecated alias for parse_coord
#'
#' Use [parse_coord()] instead.
#'
#' @param x Character vector with ICRS coordinates.
#'
#' @return A <sky_coord> vector in ICRS frame.
#' @seealso [parse_coord()]
#' @export
radec <- function(x = character()) {
  .Deprecated("parse_coord")
  parse_coord(x)
}
