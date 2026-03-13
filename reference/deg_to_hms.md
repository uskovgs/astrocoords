# Format degrees as RA-like HMS strings

Convert numeric degree values to hours-minutes-seconds text.

## Usage

``` r
deg_to_hms(x, digits = 1L, sep = ":")
```

## Arguments

- x:

  Numeric vector of angles in degrees.

- digits:

  Number of decimal places in the seconds field.

- sep:

  Output style: - \`":"\` gives strings like \`"00:40:00.0"\` - \`" "\`
  gives strings like \`"00 40 00.0"\` - \`"hms"\` gives strings like
  \`"00h40m00.0s"\` - \`""\` gives strings like \`"004000.0"\`

## Value

Character vector with one formatted value per input element.

## Details

Input is normalized to the \`\[0, 360)\` range before formatting, so for
example \`370\` is treated as \`10\`.

## Examples

``` r
deg_to_hms(10, sep = ":")
#> [1] "00:40:00.0"
deg_to_hms(370, sep = " ")
#> [1] "00 40 00.0"
deg_to_hms(1.123456, digits=5, sep = "hms")
#> [1] "00h04m29.62944s"
```
