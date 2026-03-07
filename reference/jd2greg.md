# Convert Julian Date (JD) to POSIXct

Convert Julian Date (JD) to POSIXct

## Usage

``` r
jd2greg(jd, scale = "UTC", tz = "UTC")
```

## Arguments

- jd:

  Numeric vector of Julian Date values.

- scale:

  Time scale used by ERFA. Only \`"UTC"\` is currently supported.

- tz:

  Time zone for the returned \`POSIXct\` vector.

## Value

\`POSIXct\` vector.

## Details

\`tz\` affects the returned clock representation, not the underlying
moment.

## See also

[`jd_fromdate`](https://uskovgs.github.io/astrocoords/reference/jd_fromdate.md),
[`mjd2greg`](https://uskovgs.github.io/astrocoords/reference/mjd2greg.md)

## Examples

``` r
jd <- 2461107.5
jd2greg(jd, tz = "UTC")
#> [1] "2026-03-08 UTC"
jd2greg(jd, tz = "Europe/Moscow")
#> [1] "2026-03-08 MSK"

x <- as.POSIXct("2026-03-08 00:00:00", tz = "UTC")
jd2greg(jd_fromdate(x), tz = "UTC")
#> [1] "2026-03-08 UTC"
```
