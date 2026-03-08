# Leap-second dates (UTC)

Return UTC dates where the TAI-UTC offset changes by one second.

## Usage

``` r
leap_second_dates()
```

## Value

Date vector with leap-second change dates (effective at 00:00 UTC).

## Details

Values are provided by ERFA.

The returned date is when the new UTC offset is already in effect (00:00
UTC at the start of that date).

The first returned date is \`1972-07-01\` (the first leap second was
inserted at the end of \`1972-06-30\`).

## Examples

``` r
leap_second_dates()
#>  [1] "1972-07-01" "1973-01-01" "1974-01-01" "1975-01-01" "1976-01-01"
#>  [6] "1977-01-01" "1978-01-01" "1979-01-01" "1980-01-01" "1981-07-01"
#> [11] "1982-07-01" "1983-07-01" "1985-07-01" "1988-01-01" "1990-01-01"
#> [16] "1991-01-01" "1992-07-01" "1993-07-01" "1994-07-01" "1996-01-01"
#> [21] "1997-07-01" "1999-01-01" "2006-01-01" "2009-01-01" "2012-07-01"
#> [26] "2015-07-01" "2017-01-01"
```
