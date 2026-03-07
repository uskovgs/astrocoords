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
