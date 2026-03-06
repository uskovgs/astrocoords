#' Generic sky frame constructor
#'
#' @param name Frame name.
#' @param x_name Name of the longitude-like axis.
#' @param y_name Name of the latitude-like axis.
#'
#' @return A <sky_frame> object.
#' @export
sky_frame <- function(name, x_name, y_name) {
  structure(
    list(
      name = name,
      x_name = x_name,
      y_name = y_name
    ),
    class = c(name, "sky_frame")
  )
}

#' ICRS frame
#'
#' @return A <sky_frame> object.
#' @export
icrs <- function() {
  sky_frame("icrs", x_name = "ra", y_name = "dec")
}

#' Galactic frame
#'
#' @return A <sky_frame> object.
#' @export
galactic <- function() {
  sky_frame("galactic", x_name = "l", y_name = "b")
}

.validate_frame <- function(x) {
  if (!inherits(x, "sky_frame")) {
    stop("`frame` must be a <sky_frame> object.", call. = FALSE)
  }

  x
}

.same_frame <- function(x, y) {
  identical(unclass(x), unclass(y))
}

#' @export
format.sky_frame <- function(x, ...) {
  x$name
}

#' @export
print.sky_frame <- function(x, ...) {
  cat("<sky_frame>", format(x), "\n")
  invisible(x)
}
