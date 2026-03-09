test_that("to_cartesian returns expected unit vectors", {
  x <- ra_dec(c(0, 90, 0), c(0, 0, 90))
  out <- to_cartesian(x)

  expect_true(is.matrix(out))
  expect_equal(colnames(out), c("x", "y", "z"))
  expect_equal(out[, "x"], c(1, 0, 0), tolerance = .Machine$double.eps)
  expect_equal(out[, "y"], c(0, 1, 0), tolerance = .Machine$double.eps)
  expect_equal(out[, "z"], c(0, 0, 1), tolerance = .Machine$double.eps)
})

test_that("to_cartesian validates input class", {
  expect_error(to_cartesian(1), "sky_coord")
})
