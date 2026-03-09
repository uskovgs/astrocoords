.set_sky_coord_notation <- function(notation = c("hmsdms", "plain", "colon", "pair")) {
  notation <- match.arg(notation)
  old <- getOption("astrocoords.notation")
  options(astrocoords.notation = notation)
  invisible(old)
}

.get_sky_coord_notation <- function() {
  getOption("astrocoords.notation", "hmsdms")
}

#' Set printing style for sky coordinates
#'
#' These helpers control how `sky_coord` objects are displayed when printed or
#' formatted.
#'
#' `set_print_hms()` uses sexagesimal notation such as
#' `00h40m00.0s +20d00'00"`.
#'
#' `set_print_plain()` uses a compact plain-text style such as
#' `00 40 000.0 +20 00 00`.
#'
#' `set_print_colon()` uses a compact colon style such as
#' `00:40:00.0 +20:00:00`.
#'
#' `set_print_pair()` prints decimal degree pairs such as `(10, 20)`.
#'
#' The current style is stored in `options(astrocoords.notation = ...)`.
#'
#' @return Invisibly returns the previous notation.
#'
#' @name set_print
#' @rdname set_print
#'
#' @examples
#' x <- ra_dec(10, 20)
#'
#' set_print_hms()
#' format(x)
#'
#' set_print_plain()
#' format(x)
#'
#' set_print_colon()
#' format(x)
#'
#' set_print_pair()
#' format(x)
#' @export
set_print_hms <- function() {
  .set_sky_coord_notation("hmsdms")
}

#' @rdname set_print
#' @export
set_print_plain <- function() {
  .set_sky_coord_notation("plain")
}

#' @rdname set_print
#' @export
set_print_colon <- function() {
  .set_sky_coord_notation("colon")
}

#' @rdname set_print
#' @export
set_print_pair <- function() {
  .set_sky_coord_notation("pair")
}
