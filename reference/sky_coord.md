# Create sky coordinates

Create a vector of sky coordinates in degrees.

## Usage

``` r
sky_coord(lon = double(), lat = double(), frame = icrs())
```

## Arguments

- lon:

  Longitude-like coordinate in degrees.

  For \`frame = icrs()\`, this is right ascension (\`ra\`) and must be
  between \`0\` and \`360\`.

  For \`frame = galactic()\`, this is Galactic longitude (\`l\`) and
  must be between \`0\` and \`360\`.

- lat:

  Latitude-like coordinate in degrees.

  For \`frame = icrs()\`, this is declination (\`dec\`) and must be
  between \`-90\` and \`90\`.

  For \`frame = galactic()\`, this is Galactic latitude (\`b\`) and must
  be between \`-90\` and \`90\`.

- frame:

  A sky frame object. Supported frames are
  [`icrs()`](https://uskovgs.github.io/astrocoords/reference/icrs.md)
  and
  [`galactic()`](https://uskovgs.github.io/astrocoords/reference/galactic.md).
  The default is
  [`icrs()`](https://uskovgs.github.io/astrocoords/reference/icrs.md).

## Value

A \<sky_coord\> vector.

## Examples

``` r
x <- sky_coord(10, 20)
x
#> <sky_coord[1] icrs>
#> [1] (10, 20)

g <- sky_coord(120, -30, frame = galactic())
g
#> <sky_coord[1] galactic>
#> [1] (120, -30)

ra_dec(10, 20)
#> <sky_coord[1] icrs>
#> [1] (10, 20)
gal_coord(120, -30)
#> <sky_coord[1] galactic>
#> [1] (120, -30)
```
