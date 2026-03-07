# Get Galactic longitude (l)

Extract Galactic longitude values (in degrees) from Galactic
coordinates.

## Usage

``` r
l(x)
```

## Arguments

- x:

  A \<sky_coord\> vector in Galactic frame.

## Value

Numeric vector with Galactic longitude values in degrees.

## Examples

``` r
x <- gal_coord(c(120, 121), c(-30, -31))
l(x)
#> [1] 120 121
```
