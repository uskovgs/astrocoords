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
jd_fromdate(now_utc)
#> [1] 2461108
```

If you start from a calendar date without a clock time, the function
uses midnight UTC.

``` r
jd_fromdate(as.Date("2026-03-08"))
#> [1] 2461108
```

You can also go back from JD to a normal R date-time.

``` r
jd <- jd_fromdate(now_utc)
jd2greg(jd, tz = "UTC")
#> [1] "2026-03-08 12:34:56 UTC"
```

MJD is just a shifted version of JD. The package can convert it back to
a normal date-time too.

``` r
mjd2greg(51544, tz = "UTC")
#> [1] "2000-01-01 UTC"
```
