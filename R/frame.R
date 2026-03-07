.sky_frame <- function(name, x_name, y_name) {
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
  .sky_frame("icrs", x_name = "ra", y_name = "dec")
}

#' Galactic frame
#'
#' @return A <sky_frame> object.
#' @export
galactic <- function() {
  .sky_frame("galactic", x_name = "l", y_name = "b")
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
