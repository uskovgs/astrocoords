# Convert date-time to Julian Date (JD)

Convert date-time to Julian Date (JD)

## Usage

``` r
jd_fromdate(x, scale = "UTC")
```

## Arguments

- x:

  Date-time input as \`POSIXct\`, \`POSIXlt\`, or \`Date\`.

  \`Date\` values are interpreted as \`00:00:00\` in UTC.

- scale:

  Time scale used by ERFA. Only \`"UTC"\` is currently supported.

## Value

Numeric vector with Julian Date values (in days).

## Details

The fractional part of JD encodes time of day.

JD starts at noon, so calendar midnight corresponds to \`.5\` in JD.

## See also

[`jd2greg`](https://uskovgs.github.io/astrocoords/reference/jd2greg.md),
[`mjd2greg`](https://uskovgs.github.io/astrocoords/reference/mjd2greg.md)

## Examples

``` r
t <- as.POSIXct("2026-03-08 12:34:56", tz = "UTC")
jd_fromdate(t)
#> [1] 2461108

jd_fromdate(as.Date("2026-03-08"))
#> [1] 2461108
```
