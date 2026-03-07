# Get right ascension (RA)

Extract right ascension values (in degrees) from ICRS coordinates.

## Usage

``` r
ra(x)
```

## Arguments

- x:

  A \<sky_coord\> vector in ICRS frame.

## Value

Numeric vector with RA values in degrees.

## Examples

``` r
x <- ra_dec(c(10, 20), c(-5, 30))
ra(x)
#> [1] 10 20
```
