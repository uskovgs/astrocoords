# Get declination (Dec)

Extract declination values (in degrees) from ICRS coordinates.

## Usage

``` r
dec(x)
```

## Arguments

- x:

  A \<sky_coord\> vector in ICRS frame.

## Value

Numeric vector with Dec values in degrees.

## Examples

``` r
x <- ra_dec(c(10, 20), c(-5, 30))
dec(x)
#> [1] -5 30
```
