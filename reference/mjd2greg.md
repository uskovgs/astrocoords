# Convert Modified Julian Date (MJD) to POSIXct

Convert Modified Julian Date (MJD) to POSIXct

## Usage

``` r
mjd2greg(mjd, scale = "UTC", tz = "UTC")
```

## Arguments

- mjd:

  Numeric vector of Modified Julian Date values.

- scale:

  Time scale used by ERFA. Only \`"UTC"\` is currently supported.

- tz:

  Time zone for the returned \`POSIXct\` vector.

## Value

\`POSIXct\` vector.

## Details

MJD is related to JD by: \$\$MJD = JD - 2400000.5\$\$

## See also

[`jd2greg`](https://uskovgs.github.io/astrocoords/reference/jd2greg.md),
[`jd_fromdate`](https://uskovgs.github.io/astrocoords/reference/jd_fromdate.md)

## Examples

``` r
mjd2greg(61107, tz = "UTC")
#> [1] "2026-03-08 UTC"

m <- 61107.25
mjd2greg(m, tz = "UTC")
#> [1] "2026-03-08 06:00:00 UTC"
jd2greg(m + 2400000.5, tz = "UTC")
#> [1] "2026-03-08 06:00:00 UTC"
```
