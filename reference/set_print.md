# Set printing style for sky coordinates

These helpers control how \`sky_coord\` objects are displayed when
printed or formatted.

## Usage

``` r
set_print_hms()

set_print_plain()

set_print_colon()

set_print_pair()
```

## Value

Invisibly returns the previous notation.

## Details

\`set_print_hms()\` uses sexagesimal notation such as \`00h40m00.0s
+20d00'00"\`.

\`set_print_plain()\` uses a compact plain-text style such as \`00 40
000.0 +20 00 00\`.

\`set_print_colon()\` uses a compact colon style such as \`00:40:00.0
+20:00:00\`.

\`set_print_pair()\` prints decimal degree pairs such as \`(10, 20)\`.

The current style is stored in \`options(astrocoords.notation = ...)\`.

## Examples

``` r
x <- ra_dec(10, 20)

set_print_hms()
format(x)
#> [1] "00h40m00.0s +20°00'00\""

set_print_plain()
format(x)
#> [1] "00 40 00.0 +20 00 00"

set_print_colon()
format(x)
#> [1] "00:40:00.0 +20:00:00"

set_print_pair()
format(x)
#> [1] "(10, 20)"
```
