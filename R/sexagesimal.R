.sex_split_abs <- function(x, digits) {
  
  dd <- floor(abs(x))
  mm_full <- (abs(x) - dd) * 60
  mm <- floor(mm_full)
  ss <- round((mm_full - mm) * 60, digits)

  # if round(59.99995, 1) -> 60 then:
  is_out_sec <- ss >= 60 
  if (any(is_out_sec, na.rm = TRUE)) {
    ss[is_out_sec] <- 0
    mm[is_out_sec] <- mm[is_out_sec] + 1
  }

  is_out_mins <- mm >= 60
  if (any(is_out_mins, na.rm = TRUE)) {
    mm[is_out_mins] <- 0
    dd[is_out_mins] <- dd[is_out_mins] + 1
  }

  list(
    dd = dd,
    mm = mm,
    ss = ss
  )
}


#' Format degrees as RA-like HMS strings
#'
#' Convert numeric degree values to hours-minutes-seconds text.
#'
#' Input is normalized to the `[0, 360)` range before formatting, 
#' so for example `370` is treated as `10`.
#'
#' @param x Numeric vector of angles in degrees.
#' @param digits Number of decimal places in the seconds field.
#' @param sep Output style:
#'   - `":"` gives strings like `"00:40:00.0"`
#'   - `" "` gives strings like `"00 40 00.0"`
#'   - `"hms"` gives strings like `"00h40m00.0s"`
#'
#' @return Character vector with one formatted value per input element.
#'
#' @examples
#' deg_to_hms(10, sep = ":")
#' deg_to_hms(370, sep = " ")
#' deg_to_hms(1.123456, digits=5, sep = "hms")
#' @export
deg_to_hms <- function(x, digits = 1L, sep = ":") {
  checkmate::assert_numeric(x, finite = TRUE)
  checkmate::assert_int(digits, lower = 0L)
  checkmate::assert_choice(sep, c(":", " ", "hms"))

  x <- x %% 360
  parts <- .sex_split_abs(x / 15, digits = digits)
  hh <- parts$dd %% 24 # 23:59:59.95 -> 24:00:00 --> 0
  mm <- parts$mm
  ss <- parts$ss

  hh <- sprintf("%02d", hh)
  mm <- sprintf("%02d", mm)
  n_dig <- if (digits > 0L) digits + 3L else 2L
  ss <- sprintf(paste0("%0", n_dig, ".", digits, "f"), ss)

  out <- switch(
    sep,
    ":" = paste0(hh, ":", mm, ":", ss),
    " " = paste0(hh, " ", mm, " ", ss),
    hms = paste0(hh, "h", mm, "m", ss, "s")
  )

  out[is.na(x)] <- NA_character_
  out
}

#' Format degrees as DMS strings
#'
#' Convert numeric degree values to degree-minute-second text.
#'
#' Unlike [deg_to_hms()], values are not wrapped or normalized.
#'
#' @param x Numeric vector of angles in degrees.
#' @param digits Number of decimal places in the seconds field.
#' @param sep Output style:
#'   - `":"` gives strings like `"+20:00:00"`
#'   - `" "` gives strings like `"+20 00 00"`
#'   - `"dms"` gives strings like `"+20°00'00\""`
#' @param signed If `TRUE`, include `+` for non-negative values.
#'
#' @return Character vector with one formatted value per input element.
#'
#' @examples
#' deg_to_dms(-23.5)
#' cat(deg_to_dms(20, sep = "dms"))
#' deg_to_dms(20, digits=5, sep = " ", signed = FALSE)
#' @export
deg_to_dms <- function(x, digits = 0L, sep = ":", signed = TRUE) {
  checkmate::assert_numeric(x, finite = TRUE)
  checkmate::assert_int(digits, lower = 0L)
  checkmate::assert_choice(sep, c(":", " ", "dms"))
  checkmate::assert_flag(signed, .var.name = "signed")
  

  parts <- .sex_split_abs(x, digits = digits)
  dd <- parts$dd
  mm <- parts$mm
  ss <- parts$ss

  

  sign_chr <- ifelse(x < 0, "-", if (signed) "+" else "")
  n_dig <- if (digits > 0L) digits + 3L else 2L
  dd <- sprintf("%02d", dd)
  mm <- sprintf("%02d", mm)
  
  ss <- sprintf(paste0("%0", n_dig, ".", digits, "f"), ss)

  out <- switch(
    sep,
    ":"  = paste0(sign_chr, dd, ":", mm, ":", ss),
    " "  = paste0(sign_chr, dd, " ", mm, " ", ss),
    dms  = paste0(sign_chr, dd, "\u00b0", mm, "'", ss, "\"")
  )

  out[is.na(x)] <- NA_character_
  out
}

#' Convert HMS components to degrees
#'
#' Convert hour-minute-second components to decimal degrees.
#'
#' @param h Hours. Allowed range is `0 <= h < 24`, with one special case:
#'   `h = 24` is allowed only when `m = 0` and `s = 0`.
#' @param m Minutes. Allowed range is `0 <= m < 60`.
#' @param s Seconds. Allowed range is `0 <= s < 60`.
#'
#' @return Numeric vector in degrees.
#' @examples
#' hms_to_deg(12, 34, 56)
#' 
#' hms_to_deg(24.0)
#' @export
hms_to_deg <- function(h = 0, m = 0, s = 0) {
  checkmate::assert_numeric(h, lower = 0)
  checkmate::assert_numeric(m, lower = 0)
  checkmate::assert_numeric(s, lower = 0)

  args <- vctrs::vec_recycle_common(h = h, m = m, s = s)
  h <- args$h
  m <- args$m
  s <- args$s

  is_na <- is.na(h) | is.na(m) | is.na(s)

  is_24_boundary <- !is_na & (h == 24) & (m == 0) & (s == 0)

  checkmate::assert_true(all(is_na | ((h < 24) | is_24_boundary)))
  checkmate::assert_true(all(is_na | (m < 60)))
  checkmate::assert_true(all(is_na | (s < 60)))

  h_eff <- ifelse(is_24_boundary, 24, h)
  out <- (h_eff + m / 60 + s / 3600) * 15
  out
}


#' Convert DMS components to degrees
#'
#' Convert degree-minute-second components to decimal degrees.
#'
#' @param d Degrees (signed).
#' @param m Arcminutes.
#' @param s Arcseconds.
#'
#' @return Numeric vector in degrees.
#' @examples
#' dms_to_deg(-76, 54, 3.21)
#' @export
dms_to_deg <- function(d, m = 0, s = 0) {
  checkmate::assert_numeric(d)
  checkmate::assert_numeric(m, lower = 0)
  checkmate::assert_numeric(s, lower = 0)

  args <- vctrs::vec_recycle_common(d = d, m = m, s = s)
  d <- args$d
  m <- args$m
  s <- args$s

  checkmate::assert_true(all(is.na(m) | (m >= 0 & m < 60) ))
  checkmate::assert_true(all(is.na(s) | (s >= 0 & s < 60) ))

  sign_d <- ifelse(d < 0, -1, 1)
  sign_d * (abs(d) + m / 60 + s / 3600)
}
