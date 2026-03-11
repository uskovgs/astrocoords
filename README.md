
<!-- README.md is generated from README.Rmd. Please edit that file -->

# astrocoords

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

`astrocoords` is an R package for working with astronomical coordinates
and matching catalogs.

It stores sky coordinates as a vector type instead of separate numeric
columns, making coordinate transformations, angular separations, catalog
matching, and spatial joins more natural in R.

It provides:

- sky coordinate objects (`sky_coord`) with ICRS and Galactic frames

- angular separation and frame transformations

- catalog matching (`coord_match()`, `coord_nearest()`)

- spatial joins for data frames (`coord_left_join()`,
  `coord_nearest_join()`, etc.)

- sexagesimal conversion helpers

- Julian Date / Modified Julian Date conversion

Core coordinate and time calculations are based on the
[ERFA](https://github.com/liberfa/erfa) library.

## Installation

You can install the development version of astrocoords from
[GitHub](https://github.com/uskovgs/astrocoords) with:

``` r
# install.packages("pak")
pak::pak("uskovgs/astrocoords")
```

## Quick examples

Create coordinates in the ICRS frame:

``` r
library(astrocoords)
#> 
#> Attaching package: 'astrocoords'
#> The following object is masked from 'package:graphics':
#> 
#>     frame

x <- ra_dec(c(10, 20), c(30, 40))
x
#> <sky|icrs>[2]
#> [1] 00h40m00.0s +30°00'00" 01h20m00.0s +40°00'00"
```

Transform them to Galactic coordinates:

``` r
transform_to(x, galactic())
#> <sky|galactic>[2]
#> [1] +119°59'08" -32°48'23" +128°50'59" -22°32'36"
```

Measure angular separation in arcseconds:

``` r
separation(ra_dec(10, 20), ra_dec(11, 21))
#> [1] 4932.552
```

Find nearest matches between two coordinate vectors:

``` r
coord_nearest(
  ra_dec(c(10, 20), c(0, 0)),
  ra_dec(c(10.001, 19.999), c(0, 0)),
  unit = "arcsec",
  method = "kdtree"
)
#>   x_id y_id sep
#> 1    1    1 3.6
#> 2    2    2 3.6
```

Use a spatial join between two data frames:

``` r
df1 <- data.frame(
  id = 1:2,
  coord = ra_dec(c(10, 20), c(30, 40))
)

df2 <- data.frame(
  name = c("a", "b"),
  coord = ra_dec(c(10.0002, 20.0003), c(30.0001, 39.9998))
)

df1 |>
  coord_left_join(df2, max_sep = 5, unit = "arcsec")
#>   id                  coord name       sep
#> 1  1 00h40m00.0s +30°00'00"    a 0.7199997
#> 2  2 01h20m00.0s +40°00'00"    b 1.0967560
```

Parse a compact coordinate string:

``` r
sc <- parse_coord("J230631.0+155633")
sc
#> <sky|icrs>[1]
#> [1] 23h06m31.0s +15°56'33"
```

``` r
iau_name(sc, prefix = "SRGA J", ra_digits = 3, dec_digits = 2)
#> [1] "SRGA J230631.000+155633.00"
```

Work with Julian Date:

``` r
jd <- datetime_to_jd(as.POSIXct("2026-03-08 12:34:56", tz = "UTC"))
print(jd, digits=11)
#> [1] 2461108.0243

jd_to_datetime(jd, tz = "UTC")
#> [1] "2026-03-08 12:34:56 UTC"
```

## Learn more

- Website: <https://uskovgs.github.io/astrocoords/>
- Reference: <https://uskovgs.github.io/astrocoords/reference/>
- Articles: <https://uskovgs.github.io/astrocoords/articles/>
