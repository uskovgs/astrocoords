# Get started

``` r
library(astrocoords)
#> 
#> Attaching package: 'astrocoords'
#> The following object is masked from 'package:graphics':
#> 
#>     frame
```

This vignette shows the basic ideas of the package.

You can create sky coordinates in the ICRS frame or in the Galactic
frame.

``` r
ra_dec(10, 20)
#> <sky_coord[1] icrs>
#> [1] 00h40m00.0s +20°00'00"
gal_coord(120, -30)
#> <sky_coord[1] galactic>
#> [1] 120°00'00.0" -30°00'00"
```

The general constructor is
[`sky_coord()`](https://uskovgs.github.io/astrocoords/reference/sky_coord.md).
You choose the frame with
[`icrs()`](https://uskovgs.github.io/astrocoords/reference/icrs.md) or
[`galactic()`](https://uskovgs.github.io/astrocoords/reference/galactic.md).

``` r
sky_coord(c(10, 20), c(30, 40), frame = icrs())
#> <sky_coord[2] icrs>
#> [1] 00h40m00.0s +30°00'00" 01h19m60.0s +40°00'00"
sky_coord(c(120, 121), c(-30, -31), frame = galactic())
#> <sky_coord[2] galactic>
#> [1] 120°00'00.0" -30°00'00" 121°00'00.0" -31°00'00"
```

You can measure angular separation between two points. The result is in
arcseconds.

``` r
x1 <- ra_dec(10, 20)
x2 <- ra_dec(11, 21)

separation(x1, x2)
#> [1] 4932.552
```

You can also transform coordinates between ICRS and Galactic.

``` r
x <- ra_dec(c(10, 20), c(30, 40))
g <- transform_to(x, galactic())
g
#> <sky_coord[2] galactic>
#> [1] 119°59'08.0" -32°48'23" 128°50'58.6" -22°32'36"

transform_to(g, icrs())
#> <sky_coord[2] icrs>
#> [1] 00h40m00.0s +29°59'60" 01h20m00.0s +39°59'60"
```

Accessors depend on the frame. Use
[`ra()`](https://uskovgs.github.io/astrocoords/reference/ra.md) and
[`dec()`](https://uskovgs.github.io/astrocoords/reference/dec.md) for
ICRS, and [`l()`](https://uskovgs.github.io/astrocoords/reference/l.md)
and [`b()`](https://uskovgs.github.io/astrocoords/reference/b.md) for
Galactic.

``` r
x <- ra_dec(10, 20)
ra(x)
#> [1] 10
dec(x)
#> [1] 20

g <- gal_coord(120, -30)
l(g)
#> [1] 120
b(g)
#> [1] -30
```

You can also parse compact ICRS strings.

``` r
parse_coord("J230631.0+155633")
#> <sky_coord[1] icrs>
#> [1] 23h06m31.0s +15°56'33"
```

You can build a simple IAU-style source name from ICRS coordinates.

``` r
parse_coord("J230631.0+155633") |>
  iau_name(prefix = "SRGA J")
#> [1] "SRGA J230631.0+155633"
```
