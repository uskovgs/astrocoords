# Convert HMS components to degrees

Convert hour-minute-second components to decimal degrees.

## Usage

``` r
hms_to_deg(h = 0, m = 0, s = 0)
```

## Arguments

- h:

  Hours. Allowed range is \`0 \<= h \< 24\`, with one special case: \`h
  = 24\` is allowed only when \`m = 0\` and \`s = 0\`.

- m:

  Minutes. Allowed range is \`0 \<= m \< 60\`.

- s:

  Seconds. Allowed range is \`0 \<= s \< 60\`.

## Value

Numeric vector in degrees.

## Examples

``` r
hms_to_deg(12, 34, 56)
#> [1] 188.7333

hms_to_deg(24.0)
#> [1] 360
```
