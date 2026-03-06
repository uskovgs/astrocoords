#' Set sky_coord print notation
#'
#' @param notation One of "hmsdms", "plain", "pair".
#'
#' @return Invisibly returns the previous notation.
#' @export
set_sky_coord_notation <- function(notation = c("hmsdms", "plain", "pair")) {
  notation <- match.arg(notation)
  old <- getOption("astrocoords.notation")
  options(astrocoords.notation = notation)
  invisible(old)
}

#' Get sky_coord print notation
#'
#' @return Current notation value. Defaults to "hmsdms".
#' @export
get_sky_coord_notation <- function() {
  getOption("astrocoords.notation", "hmsdms")
}

#' Use HMS/DMS print style for sky_coord
#'
#' @return Invisibly returns the previous notation.
#' @export
set_print_hms <- function() {
  set_sky_coord_notation("hmsdms")
}

#' Use plain print style for sky_coord
#'
#' @return Invisibly returns the previous notation.
#' @export
set_print_plain <- function() {
  set_sky_coord_notation("plain")
}

#' Use pair print style for sky_coord
#'
#' @return Invisibly returns the previous notation.
#' @export
set_print_pair <- function() {
  set_sky_coord_notation("pair")
}
