# astrocoords

`astrocoords` is a small R package for basic astronomical coordinates
and time conversion.

Core coordinate and time calculations in `astrocoords` are based on the
[ERFA](https://github.com/liberfa/erfa) library.

It currently supports:

- ICRS and Galactic sky coordinates
- angular separation on the sphere
- simple frame transformation between ICRS and Galactic
- Julian Date / Modified Julian Date conversion

## Installation

You can install the development version of astrocoords from
[GitHub](https://github.com/) with:

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
#> <sky_coord[2] icrs>
#> [1] 00h40m00.0s +30°00'00" 01h19m60.0s +40°00'00"
```

Transform them to Galactic coordinates:

``` r
transform(x, galactic())
#> <sky_coord[2] galactic>
#> [1] 119°59'08.0" -32°48'23" 128°50'58.6" -22°32'36"
```

Measure angular separation in arcseconds:

``` r
separation(ra_dec(10, 20), ra_dec(11, 21))
#> [1] 4932.552
```

Parse a compact coordinate string:

``` r
parse_coord("J230615.4+155635")
#> <sky_coord[1] icrs>
#> [1] 23h06m15.4s +15°56'35"
```

Work with Julian Date:

``` r
jd <- jd_fromdate(as.POSIXct("2026-03-08 12:34:56", tz = "UTC"))
jd
#> [1] 2461108

jd2greg(jd, tz = "UTC")
#> [1] "2026-03-08 12:34:56 UTC"
```
