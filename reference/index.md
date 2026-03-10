# Package index

## Coordinates

Create and inspect sky coordinate vectors.

- [`sky_coord()`](https://uskovgs.github.io/astrocoords/reference/sky_coord.md)
  : Create sky coordinates
- [`is.sky_coord()`](https://uskovgs.github.io/astrocoords/reference/is.sky_coord.md)
  : Check whether an object is a sky_coord vector
- [`ra_dec()`](https://uskovgs.github.io/astrocoords/reference/ra_dec.md)
  : Create ICRS sky coordinates
- [`gal_coord()`](https://uskovgs.github.io/astrocoords/reference/gal_coord.md)
  : Create Galactic sky coordinates
- [`ra()`](https://uskovgs.github.io/astrocoords/reference/ra.md) : Get
  right ascension (RA)
- [`dec()`](https://uskovgs.github.io/astrocoords/reference/dec.md) :
  Get declination (Dec)
- [`l()`](https://uskovgs.github.io/astrocoords/reference/l.md) : Get
  Galactic longitude (l)
- [`b()`](https://uskovgs.github.io/astrocoords/reference/b.md) : Get
  Galactic latitude (b)
- [`frame()`](https://uskovgs.github.io/astrocoords/reference/frame.md)
  : Frame accessor
- [`separation()`](https://uskovgs.github.io/astrocoords/reference/separation.md)
  : Angular separation between sky coordinates

## Matching

Low-level catalog matching helpers.

- [`coord_match()`](https://uskovgs.github.io/astrocoords/reference/coord_match.md)
  [`coord_nearest()`](https://uskovgs.github.io/astrocoords/reference/coord_match.md)
  : Match two sky catalogs within angular radius
- [`coord_left_join()`](https://uskovgs.github.io/astrocoords/reference/coord_left_join.md)
  [`coord_nearest_join()`](https://uskovgs.github.io/astrocoords/reference/coord_left_join.md)
  [`coord_right_join()`](https://uskovgs.github.io/astrocoords/reference/coord_left_join.md)
  [`coord_full_join()`](https://uskovgs.github.io/astrocoords/reference/coord_left_join.md)
  [`coord_inner_join()`](https://uskovgs.github.io/astrocoords/reference/coord_left_join.md)
  : Spatial left join for sky coordinates

## Frames and Transforms

Define coordinate frames and transform between them.

- [`to_cartesian()`](https://uskovgs.github.io/astrocoords/reference/to_cartesian.md)
  : Convert sky coordinates to Cartesian unit vectors
- [`icrs()`](https://uskovgs.github.io/astrocoords/reference/icrs.md) :
  ICRS frame
- [`galactic()`](https://uskovgs.github.io/astrocoords/reference/galactic.md)
  : Galactic frame
- [`transform_to()`](https://uskovgs.github.io/astrocoords/reference/transform_to.md)
  : Transform sky coordinates to another frame

## Parsing and Naming

Parse source coordinates and build IAU-style names.

- [`parse_coord()`](https://uskovgs.github.io/astrocoords/reference/parse_coord.md)
  : Parse coordinate strings into ICRS sky_coord
- [`iau_name()`](https://uskovgs.github.io/astrocoords/reference/iau_name.md)
  : Build IAU-style source names from sky coordinates
- [`deg_to_hms()`](https://uskovgs.github.io/astrocoords/reference/deg_to_hms.md)
  : Format degrees as RA-like HMS strings
- [`deg_to_dms()`](https://uskovgs.github.io/astrocoords/reference/deg_to_dms.md)
  : Format degrees as DMS strings

## Time

Convert between calendar dates and JD/MJD.

- [`datetime_to_jd()`](https://uskovgs.github.io/astrocoords/reference/datetime_to_jd.md)
  : Convert date-time to Julian Date (JD)
- [`jd_to_datetime()`](https://uskovgs.github.io/astrocoords/reference/jd_to_datetime.md)
  : Convert Julian Date (JD) to date-time
- [`mjd_to_datetime()`](https://uskovgs.github.io/astrocoords/reference/mjd_to_datetime.md)
  : Convert Modified Julian Date (MJD) to date-time
- [`leap_second_dates()`](https://uskovgs.github.io/astrocoords/reference/leap_second_dates.md)
  : Leap-second dates (UTC)

## Printing Options

Control how sky coordinates are printed.

- [`set_print_hms()`](https://uskovgs.github.io/astrocoords/reference/set_print.md)
  [`set_print_plain()`](https://uskovgs.github.io/astrocoords/reference/set_print.md)
  [`set_print_colon()`](https://uskovgs.github.io/astrocoords/reference/set_print.md)
  [`set_print_pair()`](https://uskovgs.github.io/astrocoords/reference/set_print.md)
  : Set printing style for sky coordinates

## Deprecated

Backward-compatible aliases.

- [`radec()`](https://uskovgs.github.io/astrocoords/reference/radec.md)
  : Deprecated alias for parse_coord
