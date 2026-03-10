.new_sky_coord <- function(lon = double(), lat = double(), frame = icrs()) {
  lon <- vctrs::vec_cast(lon, double())
  lat <- vctrs::vec_cast(lat, double())

  args <- vctrs::vec_recycle_common(
    lon = lon,
    lat = lat
  )

  .validate_frame(frame)
  .validate_ranges_for_frame(args$lon, args$lat, frame)

  vctrs::new_rcrd(
    fields = list(
      lon = args$lon,
      lat = args$lat
    ),
    frame = frame,
    class = "sky_coord"
  )
}

#' Check whether an object is a sky_coord vector
#'
#' @param x Any R object.
#'
#' @return `TRUE` if `x` inherits from `<sky_coord>`, otherwise `FALSE`.
#' @export
is.sky_coord <- function(x) {
  inherits(x, "sky_coord")
}

#' Create sky coordinates
#'
#' Create a vector of sky coordinates in degrees.
#'
#' @param lon Longitude-like coordinate in degrees.
#'
#'   For `frame = icrs()`, this is right ascension (`ra`) and must be between
#'   `0` and `360`.
#'
#'   For `frame = galactic()`, this is Galactic longitude (`l`) and must be
#'   between `0` and `360`.
#'
#' @param lat Latitude-like coordinate in degrees.
#'
#'   For `frame = icrs()`, this is declination (`dec`) and must be between
#'   `-90` and `90`.
#'
#'   For `frame = galactic()`, this is Galactic latitude (`b`) and must be
#'   between `-90` and `90`.
#'
#' @param frame A sky frame object. Supported frames are
#'   \code{\link[=icrs]{icrs()}} and \code{\link[=galactic]{galactic()}}.
#'   The default is \code{\link[=icrs]{icrs()}}.
#'
#' @return A <sky_coord> vector.
#'
#' @examples
#' x <- sky_coord(10, 20)
#' x
#'
#' g <- sky_coord(120, -30, frame = galactic())
#' g
#'
#' ra_dec(10, 20)
#' gal_coord(120, -30)
#' @export
sky_coord <- function(
  lon = double(),
  lat = double(),
  frame = icrs()
) {
  .new_sky_coord(lon, lat, frame = frame)
}

.coord_to_hmsdms <- function(x, kind, nsec = 1L, style = "hmsdms") {
  checkmate::assert_choice(kind, c("ra", "dec", "l", "b", "lon", "lat"))
  checkmate::assert_choice(style, c("hmsdms", "plain", "colon"))
  checkmate::assert_int(nsec, lower = 0)

  
  if (kind == "ra") {
    sep <- switch(
      style,
      hmsdms = "hms",
      plain = " ",
      ":"
    )
    return(deg_to_hms(x, digits = nsec, sep = sep))
  } else {
    sep <- switch(
      style, 
      hmsdms = "dms",
      plain = " ",
      ":"
    )
    return(deg_to_dms(x, digits = max(nsec - 1L, 0L), sep = sep))
  }
}

.sky_coord_format_style <- function() {
  style <- getOption("astrocoords.notation", "hmsdms")
  checkmate::assert_choice(style, c("pair", "hmsdms", "plain", "colon"))
  style
}

#' @export
format.sky_coord <- function(x, ..., style = .sky_coord_format_style()) {
  checkmate::assert_choice(style, c("pair", "hmsdms", "plain", "colon"))
  lon <- vctrs::vec_data(x)$lon
  lat <- vctrs::vec_data(x)$lat
  fr <- frame(x)

  if (style == "pair") {
    ok <- !(is.na(lon) | is.na(lat))
    out <- rep_len("NA", length(lon))
    out[ok] <- paste0(
      "(", format(lon[ok], trim = TRUE), ", ", format(lat[ok], trim = TRUE), ")"
    )
    return(out)
  } else {

    nsec <- getOption("astrocoords.nsec", 1L)
    lon_fmt <- .coord_to_hmsdms(lon, kind = fr$x_name, nsec = nsec, style = style)
    lat_fmt <- .coord_to_hmsdms(lat, kind = fr$y_name, nsec = nsec, style = style)
    out <- ifelse(is.na(lon_fmt) | is.na(lat_fmt), "NA", paste(lon_fmt, lat_fmt))
    return(out)
  }
  
}

#' @export
print.sky_coord <- function(x, ...) {
  fr <- frame(x)
  cat("<sky|",fr$name,">[", length(x), "]\n", sep = "")
  print(format(x, ...), quote = FALSE)
  invisible(x)
}

#' vctrs ptype methods for sky_coord
#'
#' Internal methods used by vctrs/pillar to display type abbreviations.
#'
#' @param x A <sky_coord> vector.
#'
#' @name sky_coord-vctrs-methods
#' @keywords internal
#' @export
vec_ptype_abbr.sky_coord <- function(x, ...) {
  fr_name <- tryCatch(frame(x)$name, error = function(e) NA_character_)
  fr_short <- if (is.na(fr_name) || !nzchar(fr_name)) {
    "?"
  } else if (identical(fr_name, "galactic")) {
    "gal"
  } else {
    fr_name
  }

  paste0("sky|", fr_short)
}

#' @rdname sky_coord-vctrs-methods
#' @export
vec_ptype_full.sky_coord <- function(x, ...) {
  paste0("sky_coord<", format(frame(x)), ">")
}
