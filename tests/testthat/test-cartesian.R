test_that("to_cartesian returns expected unit vectors", {
  x <- ra_dec(c(0, 90, 0), c(0, 0, 90))
  out <- to_cartesian(x)

  expect_s3_class(out, "data.frame")
  expect_named(out, c("x", "y", "z"))
  expect_equal(out$x, c(1, 0, 0), tolerance = 1e-12)
  expect_equal(out$y, c(0, 1, 0), tolerance = 1e-12)
  expect_equal(out$z, c(0, 0, 1), tolerance = 1e-12)
})

test_that("to_cartesian validates input class", {
  expect_error(to_cartesian(1), "sky_coord")
})
