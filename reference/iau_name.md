# Build IAU-style source names from sky coordinates

Build IAU-style source names from sky coordinates

## Usage

``` r
iau_name(x, prefix = NULL, epoch = "J", ra_digits = 1, dec_digits = 0)
```

## Arguments

- x:

  A \<sky_coord\> vector.

- prefix:

  Optional string added before the epoch code.

- epoch:

  Epoch code, usually "J".

- ra_digits:

  Number of digits after the decimal point in RA seconds.

- dec_digits:

  Number of digits after the decimal point in Dec seconds.

## Value

Character vector.

## Examples

``` r
x <- parse_coord("J230631.0+155633")

iau_name(x)
#> [1] "J230631.0+155633"
iau_name(x, prefix = "SRGA J")
#> [1] "SRGA J230631.0+155633"
iau_name(x, ra_digits = 2, dec_digits = 1)
#> [1] "J230631.00+155633.0"

# Non-ICRS inputs are transformed internally
iau_name(transform_to(x, galactic()))
#> [1] "J230631.0+155633"
```
