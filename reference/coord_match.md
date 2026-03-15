# Match two sky catalogs within angular radius

Low-level spherical catalog matching for two \`sky_coord\` vectors.

## Usage

``` r
coord_match(x, y, max_sep, unit = "arcsec", method = "kdtree", sort = TRUE)

coord_nearest(x, y, unit = "arcsec", method = "kdtree")
```

## Arguments

- x, y:

  \`\<sky_coord\>\` vectors.

- max_sep:

  Maximum separation threshold. Used in \[coord_match()\].
  \[coord_nearest()\] always uses \`Inf\`.

- unit:

  Separation unit: \`"arcsec"\`, \`"arcmin"\`, \`"deg"\`, or \`"rad"\`.

- method:

  Matching backend: \`"kdtree"\` or \`"bruteforce"\`.

- sort:

  If \`TRUE\` (default), sort matches by \`x_id\`, then \`sep\`, then
  \`y_id\`. Set to \`FALSE\` to skip sorting for better performance.

## Value

Numeric matrix with columns \`x_id\`, \`y_id\`, \`sep\`. \`sep\` is
returned in the same unit as \`unit\`.

## Details

If frames differ, \`y\` is transformed to the frame of \`x\`.

Rows are sorted by \`x_id\`, then \`sep\`, then \`y_id\`.

If an \`x_id\` has no matches, one row is returned with \`y_id = NA\`
and \`sep = NA\`.
