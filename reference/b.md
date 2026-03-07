# Get Galactic latitude (b)

Extract Galactic latitude values (in degrees) from Galactic coordinates.

## Usage

``` r
b(x)
```

## Arguments

- x:

  A \<sky_coord\> vector in Galactic frame.

## Value

Numeric vector with Galactic latitude values in degrees.

## Examples

``` r
x <- gal_coord(c(120, 121), c(-30, -31))
b(x)
#> [1] -30 -31
```
