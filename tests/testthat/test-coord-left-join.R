test_that("basic left join keeps obvious match and sep column", {
  x <- data.frame(
    id = c(1L, 2L),
    coord = ra_dec(c(10, 20), c(0, 0))
  )
  y <- data.frame(
    y_id = c(101L, 102L),
    coord = ra_dec(c(10, 30), c(0, 0)),
    score = c(0.5, 0.9)
  )

  out <- coord_left_join(
    x = x,
    y = y,
    x_coord = coord,
    y_coord = coord,
    max_sep = 1,
    unit = "arcsec",
    method = "bruteforce"
  )

  expect_s3_class(out, "data.frame")
  expect_equal(nrow(out), 2L)
  expect_equal(out$id, c(1L, 2L))
  expect_equal(out$y_id, c(101L, NA_integer_))
  expect_true("sep" %in% names(out))
  expect_true(out$sep[1] <= .Machine$double.eps^0.5)
  expect_true(is.na(out$sep[2]))
})

test_that("unmatched x rows are preserved once with NA y columns", {
  x <- data.frame(
    id = c(1L, 2L),
    coord = ra_dec(c(10, 20), c(0, 0))
  )
  y <- data.frame(
    y_id = 200L,
    coord = ra_dec(120, 0),
    y_val = 5
  )

  out <- coord_left_join(
    x = x,
    y = y,
    x_coord = "coord",
    y_coord = "coord",
    max_sep = 1,
    unit = "arcsec",
    method = "bruteforce"
  )

  expect_equal(nrow(out), 2L)
  expect_true(all(is.na(out$y_id)))
  expect_true(all(is.na(out$y_val)))
})

test_that("multiple = all returns repeated x rows", {
  x <- data.frame(
    id = 1L,
    coord = ra_dec(10, 0)
  )
  y <- data.frame(
    y_id = c(1L, 2L),
    coord = ra_dec(c(10, 10 + 0.5 / 3600), c(0, 0))
  )

  out <- coord_left_join(
    x = x,
    y = y,
    x_coord = coord,
    y_coord = coord,
    max_sep = 1,
    unit = "arcsec",
    method = "bruteforce",
    multiple = "all"
  )

  expect_equal(nrow(out), 2L)
  expect_equal(out$id, c(1L, 1L))
  expect_equal(out$y_id, c(1L, 2L))
})

test_that("multiple = closest keeps one nearest match per x_id and tie uses smaller y_id", {
  x <- data.frame(
    id = 1L,
    coord = ra_dec(10, 0)
  )
  y <- data.frame(
    y_tag = c("first_row", "second_row"),
    coord = ra_dec(c(10, 10), c(0, 0))
  )

  out <- coord_left_join(
    x = x,
    y = y,
    x_coord = coord,
    y_coord = coord,
    max_sep = 1,
    unit = "arcsec",
    method = "bruteforce",
    multiple = "closest"
  )

  expect_equal(nrow(out), 1L)
  expect_equal(out$y_tag, "first_row")
})

test_that("auto-detection picks the first sky_coord column", {
  x <- data.frame(
    id = 1L,
    coord_first = ra_dec(10, 0),
    coord_second = ra_dec(200, 0)
  )
  y <- data.frame(
    y_id = 99L,
    coord = ra_dec(10, 0)
  )

  out <- coord_left_join(
    x = x,
    y = y,
    y_coord = coord,
    max_sep = 1,
    unit = "arcsec",
    method = "bruteforce"
  )

  expect_equal(out$y_id, 99L)
})

test_that("bare and character coordinate column names both work", {
  x <- data.frame(
    id = 1:2,
    coord = ra_dec(c(10, 20), c(0, 0))
  )
  y <- data.frame(
    y_id = c(1L, 2L),
    coord = ra_dec(c(10, 20), c(0, 0))
  )

  out_bare <- coord_left_join(
    x = x,
    y = y,
    x_coord = coord,
    y_coord = coord,
    max_sep = 1,
    unit = "arcsec",
    method = "bruteforce"
  )

  out_chr <- coord_left_join(
    x = x,
    y = y,
    x_coord = "coord",
    y_coord = "coord",
    max_sep = 1,
    unit = "arcsec",
    method = "bruteforce"
  )

  expect_equal(out_bare, out_chr, tolerance = .Machine$double.eps^0.5)
})

test_that("duplicate non-key names are suffixed", {
  x <- data.frame(
    id = 1L,
    value = 10,
    coord = ra_dec(10, 0)
  )
  y <- data.frame(
    value = 20,
    flag = TRUE,
    coord = ra_dec(10, 0)
  )

  out <- coord_left_join(
    x = x,
    y = y,
    x_coord = coord,
    y_coord = coord,
    max_sep = 1,
    unit = "arcsec",
    method = "bruteforce",
    suffix = c(".x", ".y")
  )

  expect_true(all(c("value.x", "value.y", "flag") %in% names(out)))
})

test_that("keep_sep = FALSE drops separation column", {
  x <- data.frame(
    id = 1L,
    coord = ra_dec(10, 0)
  )
  y <- data.frame(
    y_id = 1L,
    coord = ra_dec(10, 0)
  )

  out <- coord_left_join(
    x = x,
    y = y,
    x_coord = coord,
    y_coord = coord,
    max_sep = 1,
    unit = "arcsec",
    method = "bruteforce",
    keep_sep = FALSE
  )

  expect_false("sep" %in% names(out))
})

test_that("unit = arcmin is supported", {
  x <- data.frame(
    id = 1L,
    coord = ra_dec(10, 0)
  )
  y <- data.frame(
    y_id = 1L,
    coord = ra_dec(10 + 0.5 / 60, 0)
  )

  out <- coord_left_join(
    x = x,
    y = y,
    x_coord = coord,
    y_coord = coord,
    max_sep = 1,
    unit = "arcmin",
    method = "bruteforce"
  )

  expect_equal(out$y_id, 1L)
})

test_that("output order follows original x order", {
  x <- data.frame(
    id = c("row2", "row1"),
    coord = ra_dec(c(20, 10), c(0, 0))
  )
  y <- data.frame(
    y_id = c(10L, 20L),
    coord = ra_dec(c(10, 20), c(0, 0))
  )

  out <- coord_left_join(
    x = x,
    y = y,
    x_coord = coord,
    y_coord = coord,
    max_sep = 1,
    unit = "arcsec",
    method = "bruteforce",
    multiple = "closest"
  )

  expect_equal(out$id, c("row2", "row1"))
  expect_equal(out$y_id, c(20L, 10L))
})

test_that("sep_col collision errors clearly", {
  x <- data.frame(
    id = 1L,
    sep = 123,
    coord = ra_dec(10, 0)
  )
  y <- data.frame(
    y_id = 1L,
    coord = ra_dec(10, 0)
  )

  expect_error(
    coord_left_join(
      x = x,
      y = y,
      x_coord = coord,
      y_coord = coord,
      max_sep = 1,
      unit = "arcsec",
      method = "bruteforce",
      keep_sep = TRUE,
      sep_col = "sep"
    ),
    "collides"
  )
})
