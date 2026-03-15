# Angular separation between sky coordinates

Angular separation between sky coordinates

## Usage

``` r
separation(x, y, unit = "arcsec")
```

## Arguments

- x, y:

  \<sky_coord\> vectors.

- unit:

  Separation unit: \`"arcsec"\` (default), \`"arcmin"\`, \`"deg"\`, or
  \`"rad"\`.

## Value

Numeric vector of angular separation.

## Examples

``` r
x <- ra_dec(10, 20)
y <- ra_dec(11, 21)
separation(x, y)
#> [1] 4932.552

g <- transform_to(x, galactic())
separation(g, y)
#> [1] 4932.552
```
