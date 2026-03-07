# POSIXct from Julian Date

POSIXct from Julian Date

## Usage

``` r
jd2greg(jd, scale = "UTC", tz = "UTC")
```

## Arguments

- jd:

  Numeric vector of Julian Date.

- scale:

  ERFA timescale. Only "UTC" is currently supported.

- tz:

  Time zone for returned POSIXct.

## Value

POSIXct vector.
