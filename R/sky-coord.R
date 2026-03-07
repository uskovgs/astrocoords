.new_sky_coord <- function(lon = double(), lat = double(), frame = icrs()) {
  lon <- vctrs::vec_cast(lon, double())
  lat <- vctrs::vec_cast(lat, double())
  frame <- .validate_frame(frame)

  .validate_equal_lengths(lon, lat)
  .validate_ranges_for_frame(lon, lat, frame)

  out <- vctrs::new_rcrd(
    fields = list(
      lon = lon,
      lat = lat
    ),
    class = "sky_coord"
  )

  attr(out, "frame") <- frame
  out
}

#' User-facing sky coordinate constructor
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
#' @param frame A sky frame object. Supported frames are [icrs()] and
#'   [galactic()]. The default is [icrs()].
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
  args <- vctrs::vec_recycle_common(
    lon = lon,
    lat = lat
  )

  .new_sky_coord(args$lon, args$lat, frame = frame)
}

.format_coord_number <- function(x) {
  format(x, trim = TRUE, digits = getOption("digits"))
}

.coord_to_hmsdms <- function(x, kind, nsec = 1L, plain = FALSE) {
  x <- vctrs::vec_cast(x, double())
  nsec <- max(as.integer(nsec), 0L)

  if (kind == "ra") {
    x <- x / 15
  }

  units <- if (kind == "ra") c("h", "m", "s") else c("\u00b0", "'", "\"")
  sign_x <- if (kind %in% c("dec", "lat")) ifelse(sign(x) >= 0, "+", "-") else rep_len("", length(x))
  x0 <- abs(x)
  x1 <- as.integer(x0)
  x2_tmp <- (x0 - x1) * 60
  x2 <- as.integer(x2_tmp)
  x3 <- (x2_tmp - x2) * 60

  sec_digits <- if (kind %in% c("dec", "lat")) max(nsec - 1L, 0L) else nsec
  sec_width <- sec_digits + if (plain && kind == "ra") 4L else 3L
  if (kind %in% c("dec", "lat")) {
    sec_width <- sec_digits + 2L
  }
  sec_fmt <- paste0("%0", sec_width, ".", sec_digits, "f")

  if (plain) {
    out <- paste0(
      sign_x,
      sprintf("%02d", x1),
      " ",
      sprintf("%02d", x2),
      " ",
      sprintf(sec_fmt, round(x3, sec_digits))
    )
  } else {
    out <- paste0(
      sign_x,
      sprintf("%02d", x1),
      units[1],
      sprintf("%02d", x2),
      units[2],
      sprintf(sec_fmt, round(x3, sec_digits)),
      units[3]
    )
  }

  out[is.na(x)] <- NA_character_
  out
}

.sky_coord_format_style <- function() {
  style <- getOption("astrocoords.notation", "hmsdms")
  match.arg(style, c("pair", "hmsdms", "plain"))
}

#' @export
format.sky_coord <- function(x, ..., style = .sky_coord_format_style()) {
  style <- match.arg(style, c("pair", "hmsdms", "plain"))
  lon <- vctrs::vec_data(x)$lon
  lat <- vctrs::vec_data(x)$lat
  fr <- frame(x)

  if (style == "pair") {
    ok <- !(is.na(lon) | is.na(lat))
    out <- rep_len("NA", length(lon))
    out[ok] <- paste0(
      "(",
      .format_coord_number(lon[ok]),
      ", ",
      .format_coord_number(lat[ok]),
      ")"
    )
    return(out)
  }

  nsec <- getOption("astrocoords.sky_coord.nsec", 1L)
  is_plain <- identical(style, "plain")
  lon_kind <- if (identical(fr$x_name, "ra")) "ra" else "lon"
  lat_kind <- if (identical(fr$y_name, "dec")) "dec" else "lat"
  lon_fmt <- .coord_to_hmsdms(lon, kind = lon_kind, nsec = nsec, plain = is_plain)
  lat_fmt <- .coord_to_hmsdms(lat, kind = lat_kind, nsec = nsec, plain = is_plain)
  ifelse(is.na(lon_fmt) | is.na(lat_fmt), "NA", paste(lon_fmt, lat_fmt))
}

#' @export
print.sky_coord <- function(x, ...) {
  fr <- frame(x)
  cat("<sky_coord[", length(x), "] ", fr$name, ">\n", sep = "")
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
  "sky"
}

#' @rdname sky_coord-vctrs-methods
#' @export
vec_ptype_full.sky_coord <- function(x, ...) {
  paste0("sky_coord<", format(frame(x)), ">")
}
