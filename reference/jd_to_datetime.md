# Convert Julian Date (JD) to date-time

Convert Julian Date values back to regular date-time values.

## Usage

``` r
jd_to_datetime(jd, tz = "UTC")
```

## Arguments

- jd:

  Numeric vector of Julian Date values.

- tz:

  Time zone for output \`POSIXct\` values.

## Value

\`POSIXct\` vector.

## Details

\`tz\` changes only how time is displayed, not the physical moment.

Uses ERFA with \`scale = "UTC"\`. Leap seconds are handled by ERFA.

## See also

[`datetime_to_jd`](https://uskovgs.github.io/astrocoords/reference/datetime_to_jd.md),
[`mjd_to_datetime`](https://uskovgs.github.io/astrocoords/reference/mjd_to_datetime.md)

## Examples

``` r
jd <- 2461107.5
jd_to_datetime(jd, tz = "UTC")
#> [1] "2026-03-08 UTC"
jd_to_datetime(jd, tz = "Europe/Moscow")
#> [1] "2026-03-08 MSK"

x <- as.POSIXct("2026-03-08 00:00:00", tz = "UTC")
jd_to_datetime(datetime_to_jd(x), tz = "UTC")
#> [1] "2026-03-08 UTC"
```
