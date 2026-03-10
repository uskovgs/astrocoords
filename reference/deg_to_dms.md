# Format degrees as DMS strings

Convert numeric degree values to degree-minute-second text.

## Usage

``` r
deg_to_dms(x, digits = 0L, sep = ":", signed = TRUE)
```

## Arguments

- x:

  Numeric vector of angles in degrees.

- digits:

  Number of decimal places in the seconds field.

- sep:

  Output style: - \`":"\` gives strings like \`"+20:00:00"\` - \`" "\`
  gives strings like \`"+20 00 00"\` - \`"dms"\` gives strings like
  \`"+20°00'00\\"\`

- signed:

  If \`TRUE\`, include \`+\` for non-negative values.

## Value

Character vector with one formatted value per input element.

## Details

Unlike \[deg_to_hms()\], values are not wrapped or normalized.

## Examples

``` r
deg_to_dms(-23.5)
#> [1] "-23:30:00"
cat(deg_to_dms(20, sep = "dms"))
#> +20°00'00"
deg_to_dms(20, digits=5, sep = " ", signed = FALSE)
#> [1] "20 00 00.00000"
```
