#' Transform ICRS coordinates to Galactic frame
#'
#' @param x A <sky_coord> vector in ICRS frame.
#'
#' @return A <sky_coord> vector in Galactic frame.
#' @export
transform_icrs_to_galactic <- function(x) {
  x <- .validate_sky_coord(x)
  if (!identical(frame(x)$name, "icrs")) {
    stop("`x` must be in <icrs> frame.", call. = FALSE)
  }

  data <- vctrs::vec_data(x)
  out <- cpp_era_icrs2g(
    .deg_to_rad(data$lon),
    .deg_to_rad(data$lat)
  )

  sky_coord(
    lon = .normalize_lon_deg(.rad_to_deg(out$x)),
    lat = .rad_to_deg(out$y),
    frame = galactic()
  )
}

#' Transform Galactic coordinates to ICRS frame
#'
#' @param x A <sky_coord> vector in Galactic frame.
#'
#' @return A <sky_coord> vector in ICRS frame.
#' @export
transform_galactic_to_icrs <- function(x) {
  x <- .validate_sky_coord(x)
  if (!identical(frame(x)$name, "galactic")) {
    stop("`x` must be in <galactic> frame.", call. = FALSE)
  }

  data <- vctrs::vec_data(x)
  out <- cpp_era_g2icrs(
    .deg_to_rad(data$lon),
    .deg_to_rad(data$lat)
  )

  sky_coord(
    lon = .normalize_lon_deg(.rad_to_deg(out$x)),
    lat = .rad_to_deg(out$y),
    frame = icrs()
  )
}

#' Transform sky coordinates to another frame
#'
#' @param x A <sky_coord> vector.
#' @param frame Target frame.
#'
#' @return A transformed <sky_coord> vector.
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
  x <- .validate_sky_coord(x)
  target_frame <- .validate_frame(frame)

  src <- attr(x, "frame", exact = TRUE)
  dst <- target_frame

  if (.same_frame(src, dst)) {
    return(x)
  }

  if (identical(src$name, "icrs") && identical(dst$name, "galactic")) {
    return(transform_icrs_to_galactic(x))
  }

  if (identical(src$name, "galactic") && identical(dst$name, "icrs")) {
    return(transform_galactic_to_icrs(x))
  }

  stop(
    sprintf("Unsupported transformation: <%s> -> <%s>.", src$name, dst$name),
    call. = FALSE
  )
}

#' @export
transform.sky_coord <- function(`_data`, frame = NULL, ...) {
  if (is.null(frame)) {
    stop("`frame` must be provided for sky_coord transformation.", call. = FALSE)
  }
  transform_to(`_data`, frame = frame)
}
