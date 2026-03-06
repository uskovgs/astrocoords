test_that("separation returns known angular distances", {
  origin <- sky_coord(0, 0)
  same <- sky_coord(0, 0)
  quarter_turn <- sky_coord(90, 0)

  expect_equal(separation(origin, same), 0)
  expect_equal(separation(origin, quarter_turn), 90 * 3600, tolerance = 1e-8)
})

test_that("separation works vectorized", {
  x <- sky_coord(c(0, 0), c(0, 0))
  y <- sky_coord(c(0, 90), c(0, 0))

  expect_equal(
    separation(x, y),
    c(0, 90 * 3600),
    tolerance = 1e-8
  )
})

test_that("separation is S3 and validates class", {
  expect_error(separation(1, 2), "must be a <sky_coord>")
})

test_that("separation supports galactic and checks frame match", {
  x <- gal_coord(0, 0)
  y <- gal_coord(90, 0)
  z <- ra_dec(90, 0)

  expect_equal(separation(x, y), 90 * 3600, tolerance = 1e-8)
  expect_error(separation(x, z), "must use the same frame")
})
