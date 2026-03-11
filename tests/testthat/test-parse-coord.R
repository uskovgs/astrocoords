test_that("parse_coord parses compact J-form", {
  x <- parse_coord("J230631.0+155633")

  expect_s3_class(x, "sky_coord")
  expect_equal(frame(x)$name, "icrs")
  expect_equal(ra(x), 346.6291666666667, tolerance = 1e-12)
  expect_equal(dec(x), 15.9425, tolerance = 1e-12)
})

test_that("parse_coord parses J-coordinates inside catalog names", {
  x <- parse_coord("SRGA J230631.0+155633")

  expect_s3_class(x, "sky_coord")
  expect_equal(frame(x)$name, "icrs")
  expect_equal(ra(x), 346.6291666666667, tolerance = 1e-12)
  expect_equal(dec(x), 15.9425, tolerance = 1e-12)
})

test_that("parse_coord parses spaced hms/dms and preserves NA", {
  x <- parse_coord(c("12 34 56 -76 54 3.210", NA_character_))

  expect_equal(ra(x)[1], (12 + 34 / 60 + 56 / 3600) * 15, tolerance = 1e-12)
  expect_equal(dec(x)[1], -(76 + 54 / 60 + 3.210 / 3600), tolerance = 1e-12)
  expect_true(is.na(ra(x)[2]))
  expect_true(is.na(dec(x)[2]))
})

test_that("parse_coord parses hms/dms marker format", {
  x <- parse_coord("12h34m56s -76d54m3.210s")

  expect_equal(ra(x), (12 + 34 / 60 + 56 / 3600) * 15, tolerance = 1e-12)
  expect_equal(dec(x), -(76 + 54 / 60 + 3.210 / 3600), tolerance = 1e-12)
})

test_that("parse_coord validates parsed ranges via sky_coord", {
  expect_error(parse_coord("99 00 00 +00 00 00"))
})
