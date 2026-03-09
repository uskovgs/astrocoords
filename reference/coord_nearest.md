# Nearest-neighbor match for sky catalogs

Return one nearest source in \`y\` for each source in \`x\`.

## Usage

``` r
coord_nearest(x, y, unit = "arcsec", method = "kdtree")
```

## Arguments

- x, y:

  \`\<sky_coord\>\` vectors.

- unit:

  Separation unit: \`"arcsec"\`, \`"arcmin"\`, \`"deg"\`, or \`"rad"\`.

- method:

  Matching backend: \`"kdtree"\` or \`"bruteforce"\`.

## Value

Base \`data.frame\` with columns \`x_id\`, \`y_id\`, \`sep\`.

## Details

Internally calls \`coord_match(..., max_sep = Inf)\` and keeps only one
nearest row per \`x_id\`.
