# Parse coordinate strings into ICRS sky_coord

Parse coordinate strings into ICRS sky_coord

## Usage

``` r
parse_coord(x = character())
```

## Arguments

- x:

  Character vector with ICRS coordinates.

## Value

A \<sky_coord\> vector in ICRS frame.

## Examples

``` r
library(astrocoords)

parse_coord("12 34 56 -76 54 3.210")
#> <sky|icrs>[1]
#> [1] 12h34m56.0s -76°54'03"

parse_coord("12:34:56 -76:54:3.210")
#> <sky|icrs>[1]
#> [1] 12h34m56.0s -76°54'03"

parse_coord("12h34m56s -76d54m3.210s")
#> <sky|icrs>[1]
#> [1] 12h34m56.0s -76°54'03"
```
