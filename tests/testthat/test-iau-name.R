test_that("iau_name formats ICRS coordinates", {
  x <- ra_dec(346.6291666666667, 15.9425)

  expect_equal(
    iau_name(x),
    "J230631.0+155633"
  )
})

test_that("iau_name supports prefix and precision arguments", {
  x <- ra_dec(10, 20)

  expect_equal(
    iau_name(x, prefix = "SDSS", ra_digits = 1, dec_digits = 0),
    "SDSS004000.0+200000"
  )
})

test_that("iau_name treats prefix as full name prefix", {
  x <- parse_coord("J230631.0+155633")

  expect_equal(
    iau_name(x, prefix = "B"),
    "B230631.0+155633"
  )

  expect_equal(
    iau_name(x, prefix = "SRGA J"),
    "SRGA J230631.0+155633"
  )
})

test_that("iau_name auto-transforms non-ICRS coordinates", {
  x <- gal_coord(122.45025, 23.822222)
  out <- iau_name(x)

  expect_type(out, "character")
  expect_true(startsWith(out, "J"))
})
