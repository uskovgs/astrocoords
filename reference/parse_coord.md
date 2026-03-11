# Parse coordinate strings into ICRS sky_coord

Parse a character vector of ICRS coordinates into a \`sky_coord\`
vector. The parser currently supports two input families:

## Usage

``` r
parse_coord(x = character())
```

## Arguments

- x:

  Character vector with ICRS coordinates. \`NA\` values are preserved.

## Value

A \<sky_coord\> vector in ICRS frame.

## Details

1\. Compact J-style token (can appear inside catalog names): -
\`JHHMMSS(.s)+DDMMSS(.s)\` - examples: \`"J230631.0+155633"\`, \`"SRGA
J230631.0+155633"\`

2\. Sexagesimal token with full components: - \`HH MM SS +/-DD MM SS\` -
all six components are required (no partial forms) - separators may be
spaces, \`:\`, or HMS/DMS markers (\`h m s d \u00B0 ' "\`) - examples:
\`"12 34 56 -76 54 3.210"\`, \`"12:34:56 -76:54:3.210"\`, \`"12h34m56s
-76d54m3.210s"\`

## Examples

``` r
library(astrocoords)

parse_coord("12 34 56 -76 54 3.210")
#> <sky|icrs>[1]
#> [1] 12h34m56.0s -76°54'03"

parse_coord("12:34:56 -76:54:3.210")
#> <sky|icrs>[1]
#> [1] 12h34m56.0s -76°54'03"

parse_coord("12h34m56s -76d54m3.210s")
#> <sky|icrs>[1]
#> [1] 12h34m56.0s -76°54'03"

parse_coord(c(
  "SRGA J230631.0+155633",
  "J230631.0+155633",
  "12:34:56 -76:54:3.210"
))
#> <sky|icrs>[3]
#> [1] 23h06m31.0s +15°56'33" 23h06m31.0s +15°56'33" 12h34m56.0s -76°54'03"
```
