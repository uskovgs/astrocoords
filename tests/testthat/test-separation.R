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
  expect_error(separation(1, 2), "Must inherit from class 'sky_coord'")
})

test_that("separation supports galactic and mixed-frame inputs", {
  x <- gal_coord(0, 0)
  y_gal <- gal_coord(90, 0)
  y_icrs <- transform_to(y_gal, icrs())

  expect_equal(separation(x, y_gal), 90 * 3600, tolerance = 1e-8)
  expect_equal(separation(x, y_icrs), 90 * 3600, tolerance = 1e-8)
})

test_that("separation supports output unit conversion", {
  x <- sky_coord(0, 0)
  y <- sky_coord(90, 0)

  expect_equal(separation(x, y, unit = "rad"), pi / 2, tolerance = 1e-12)
  expect_equal(separation(x, y, unit = "deg"), 90, tolerance = 1e-8)
  expect_equal(separation(x, y, unit = "arcmin"), 90 * 60, tolerance = 1e-8)
  expect_equal(separation(x, y, unit = "arcsec"), 90 * 3600, tolerance = 1e-8)
})

test_that("separation validates unit argument", {
  x <- sky_coord(0, 0)
  y <- sky_coord(1, 0)

  expect_error(separation(x, y, unit = "foo"), "unit")
})
