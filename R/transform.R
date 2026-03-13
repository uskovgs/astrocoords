.transform_icrs_to_galactic <- function(x) {

  data <- vctrs::vec_data(x)
  out <- cpp_era_icrs2g(
    .deg_to_rad(data$lon),
    .deg_to_rad(data$lat)
  )

  sky_coord(
    lon = .rad_to_deg(out$x),
    lat = .rad_to_deg(out$y),
    frame = galactic()
  )
}

.transform_galactic_to_icrs <- function(x) {

  data <- vctrs::vec_data(x)
  out <- cpp_era_g2icrs(
    .deg_to_rad(data$lon),
    .deg_to_rad(data$lat)
  )

  sky_coord(
    lon = .rad_to_deg(out$x),
    lat = .rad_to_deg(out$y),
    frame = icrs()
  )
}

#' Transform sky coordinates to another frame
#'
#' Convert a \code{sky_coord} vector between supported coordinate frames.
#'
#' @param x A \code{<sky_coord>} vector.
#' @param frame Target frame. Use \code{\link[=icrs]{icrs()}} or
#'   \code{\link[=galactic]{galactic()}}.
#'
#' @return A transformed \code{<sky_coord>} vector.
#'
#' @details
#' Supported transformations are:
#' \itemize{
#'   \item \code{icrs() -> galactic()}
#'   \item \code{galactic() -> icrs()}
#' }
#'
#' If \code{x} is already in the requested \code{frame}, it is returned
#' unchanged.
#'
#' For \code{icrs() <-> galactic()} conversion, ERFA documentation states
#' matrix-element precision at about 20 microarcseconds.
#'
#' Use \code{transform_to()} (not \code{transform()}) for \code{sky_coord}
#' objects.
#'
#' @examples
#' x <- ra_dec(c(10, 120), c(20, -30))
#' x
#'
#' g <- transform_to(x, galactic())
#' g
#'
#' transform_to(g, icrs())
#'
#' # Pipe-friendly workflow
#' ra_dec(10, 20) |>
#'   transform_to(galactic()) |>
#'   transform_to(icrs())
#' @export
transform_to <- function(x, frame) {
  UseMethod("transform_to")
}

#' @export
transform_to.default <- function(x, frame) {
  .validate_sky_coord(x)
}

#' @export
transform_to.sky_coord <- function(x, frame) {
  .validate_sky_coord(x)
  dst <- .validate_frame(frame)
  src <- frame(x)

  if (.same_frame(src, dst)) {
    return(x)
  }

  if (src$name == "icrs" && dst$name == "galactic") {
    return(.transform_icrs_to_galactic(x))
  }

  if (src$name == "galactic" && dst$name == "icrs") {
    return(.transform_galactic_to_icrs(x))
  }

  stop(
    sprintf("Unsupported transformation: <%s> -> <%s>.", src$name, dst$name),
    call. = FALSE
  )
}

#' @export
transform.sky_coord <- function(`_data`, ...) {
  rlang::abort(
    c(
      "`transform()` is not supported for `sky_coord` objects.",
      "i" = "Did you mean `transform_to()`?",
      ">" = "Example: `transform_to(x, galactic())`"
    )
  )
}
