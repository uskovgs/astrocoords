# Package index

## Coordinates

Create and inspect sky coordinate vectors.

- [`sky_coord()`](https://uskovgs.github.io/astrocoords/reference/sky_coord.md)
  : User-facing sky coordinate constructor
- [`ra_dec()`](https://uskovgs.github.io/astrocoords/reference/ra_dec.md)
  : Sugar constructor for ICRS coordinates
- [`gal_coord()`](https://uskovgs.github.io/astrocoords/reference/gal_coord.md)
  : Sugar constructor for Galactic coordinates
- [`ra()`](https://uskovgs.github.io/astrocoords/reference/ra.md) :
  Right ascension accessor
- [`dec()`](https://uskovgs.github.io/astrocoords/reference/dec.md) :
  Declination accessor
- [`l()`](https://uskovgs.github.io/astrocoords/reference/l.md) :
  Galactic longitude accessor
- [`b()`](https://uskovgs.github.io/astrocoords/reference/b.md) :
  Galactic latitude accessor
- [`frame()`](https://uskovgs.github.io/astrocoords/reference/frame.md)
  : Frame accessor
- [`separation()`](https://uskovgs.github.io/astrocoords/reference/separation.md)
  : Angular separation between sky coordinates

## Frames and Transforms

Define coordinate frames and transform between them.

- [`sky_frame()`](https://uskovgs.github.io/astrocoords/reference/sky_frame.md)
  : Generic sky frame constructor
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

## Time

Convert between calendar dates and JD/MJD.

- [`jd_fromdate()`](https://uskovgs.github.io/astrocoords/reference/jd_fromdate.md)
  : Julian Date from date-time
- [`jd2greg()`](https://uskovgs.github.io/astrocoords/reference/jd2greg.md)
  : POSIXct from Julian Date
- [`mjd2greg()`](https://uskovgs.github.io/astrocoords/reference/mjd2greg.md)
  : POSIXct from Modified Julian Date

## Printing Options

Control how sky coordinates are printed.

- [`set_print_hms()`](https://uskovgs.github.io/astrocoords/reference/set_print_hms.md)
  : Use HMS/DMS print style for sky_coord
- [`set_print_plain()`](https://uskovgs.github.io/astrocoords/reference/set_print_plain.md)
  : Use plain print style for sky_coord
- [`set_print_pair()`](https://uskovgs.github.io/astrocoords/reference/set_print_pair.md)
  : Use pair print style for sky_coord

## Deprecated

Backward-compatible aliases.

- [`radec()`](https://uskovgs.github.io/astrocoords/reference/radec.md)
  : Deprecated alias for parse_coord
