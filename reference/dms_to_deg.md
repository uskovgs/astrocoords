# Convert DMS components to degrees

Convert degree-minute-second components to decimal degrees.

## Usage

``` r
dms_to_deg(d, m = 0, s = 0)
```

## Arguments

- d:

  Degrees (signed).

- m:

  Arcminutes.

- s:

  Arcseconds.

## Value

Numeric vector in degrees.

## Examples

``` r
dms_to_deg(-76, 54, 3.21)
#> [1] -76.90089
```
