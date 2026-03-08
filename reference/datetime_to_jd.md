# Convert date-time to Julian Date (JD)

Convert regular calendar date-times to Julian Date.

## Usage

``` r
datetime_to_jd(x)
```

## Arguments

- x:

  Date-time values as \`POSIXct\`, \`POSIXlt\`, or \`Date\`.

  \`Date\` values are treated as midnight (\`00:00:00\`) in UTC.

## Value

Numeric vector of Julian Date values (days).

## Details

JD is a continuous day count used in astronomy.

The fractional part is time of day.

JD starts at noon, so midnight is shown as \`.5\`.

Uses ERFA with \`scale = "UTC"\`. Leap seconds are handled by ERFA.

## See also

[`jd_to_datetime`](https://uskovgs.github.io/astrocoords/reference/jd_to_datetime.md),
[`mjd_to_datetime`](https://uskovgs.github.io/astrocoords/reference/mjd_to_datetime.md)

## Examples

``` r
old_accuracy <- getOption("digits")
options(digits = 11)

t <- as.POSIXct("2026-03-08 12:34:56", tz = "UTC")
datetime_to_jd(t)
#> [1] 2461108.0243

datetime_to_jd(as.Date("2026-03-08"))
#> [1] 2461107.5

options(digits = old_accuracy)
```
