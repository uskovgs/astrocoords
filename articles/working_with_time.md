# Working with time

``` r
library(astrocoords)
#> 
#> Attaching package: 'astrocoords'
#> The following object is masked from 'package:graphics':
#> 
#>     frame
```

This vignette shows a few simple ways to work with Julian Date (JD) and
Modified Julian Date (MJD).

Astronomers often use JD for exact time stamps.

``` r
now_utc <- as.POSIXct("2026-03-08 12:34:56", tz = "UTC")
datetime_to_jd(now_utc)
#> [1] 2461108
```

If you start from a calendar date without a clock time, the function
uses midnight UTC.

``` r
datetime_to_jd(as.Date("2026-03-08"))
#> [1] 2461108
```

You can also go back from JD to a normal R date-time.

``` r
jd <- datetime_to_jd(now_utc)
jd_to_datetime(jd, tz = "UTC")
#> [1] "2026-03-08 12:34:56 UTC"
```

MJD is just a shifted version of JD. The package can convert it back to
a normal date-time too.

``` r
mjd_to_datetime(51544, tz = "UTC")
#> [1] "2000-01-01 UTC"
```
