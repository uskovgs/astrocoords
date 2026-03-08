# Convert Modified Julian Date (MJD) to date-time

Convert MJD values to regular date-time values.

## Usage

``` r
mjd_to_datetime(mjd, tz = "UTC")
```

## Arguments

- mjd:

  Numeric vector of Modified Julian Date values.

- tz:

  Time zone for output \`POSIXct\` values.

## Value

\`POSIXct\` vector.

## Details

MJD is related to JD by: \$\$MJD = JD - 2400000.5\$\$

Uses ERFA with \`scale = "UTC"\`. Leap seconds are handled by ERFA.

## See also

[`jd_to_datetime`](https://uskovgs.github.io/astrocoords/reference/jd_to_datetime.md),
[`datetime_to_jd`](https://uskovgs.github.io/astrocoords/reference/datetime_to_jd.md)

## Examples

``` r
mjd_to_datetime(61107, tz = "UTC")
#> [1] "2026-03-08 UTC"

m <- 61107.25
mjd_to_datetime(m, tz = "UTC")
#> [1] "2026-03-08 06:00:00 UTC"
jd_to_datetime(m + 2400000.5, tz = "UTC")
#> [1] "2026-03-08 06:00:00 UTC"
```
