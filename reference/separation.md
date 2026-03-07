# Angular separation between sky coordinates

Angular separation between sky coordinates

## Usage

``` r
separation(x, y)
```

## Arguments

- x, y:

  \<sky_coord\> vectors.

## Value

Numeric vector in arcseconds.

## Examples

``` r
x <- ra_dec(10, 20)
y <- ra_dec(11, 21)
separation(x, y)
#> [1] 4932.552

g <- transform(x, galactic())
separation(g, y)
#> [1] 4932.552
```
