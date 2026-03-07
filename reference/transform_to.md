# Transform sky coordinates to another frame

Convert a `sky_coord` vector between supported coordinate frames.

## Usage

``` r
transform_to(x, frame)
```

## Arguments

- x:

  A `<sky_coord>` vector.

- frame:

  Target frame. Use
  [`icrs()`](https://uskovgs.github.io/astrocoords/reference/icrs.md) or
  [`galactic()`](https://uskovgs.github.io/astrocoords/reference/galactic.md).

## Value

A transformed `<sky_coord>` vector.

## Details

Supported transformations are:

- `icrs() -> galactic()`

- `galactic() -> icrs()`

If `x` is already in the requested `frame`, it is returned unchanged.

Use `transform_to()` (not
[`transform()`](https://rdrr.io/r/base/transform.html)) for `sky_coord`
objects.

## Examples

``` r
x <- ra_dec(c(10, 120), c(20, -30))
x
#> <sky_coord[2] icrs>
#> [1] (10, 20)   (120, -30)

g <- transform_to(x, galactic())
g
#> <sky_coord[2] galactic>
#> [1] (119.2694, -42.79039515) (247.0829, -0.04805424) 

transform_to(g, icrs())
#> <sky_coord[2] icrs>
#> [1] (10, 20)   (120, -30)

# Pipe-friendly workflow
ra_dec(10, 20) |>
  transform_to(galactic()) |>
  transform_to(icrs())
#> <sky_coord[1] icrs>
#> [1] (10, 20)
```
