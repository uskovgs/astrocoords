# POSIXct from Modified Julian Date

POSIXct from Modified Julian Date

## Usage

``` r
mjd2greg(mjd, scale = "UTC", tz = "UTC")
```

## Arguments

- mjd:

  Numeric vector of Modified Julian Date.

- scale:

  ERFA timescale. Only "UTC" is currently supported.

- tz:

  Time zone for returned POSIXct.

## Value

POSIXct vector.
