.circular_diff_deg <- function(a, b) {
  abs((((a - b) + 180) %% 360) - 180)
}

test_that("ICRS and Galactic transforms round-trip", {
  x <- ra_dec(c(10, 120, 359.5), c(20, -30, 5))
  g <- transform_icrs_to_galactic(x)
  back <- transform_galactic_to_icrs(g)

  expect_equal(frame(g)$name, "galactic")
  expect_equal(frame(back)$name, "icrs")
  expect_true(all(.circular_diff_deg(ra(back), ra(x)) < 1e-9))
  expect_equal(dec(back), dec(x), tolerance = 1e-9)
})

test_that("transforms preserve NA values", {
  x <- ra_dec(c(10, NA_real_), c(20, NA_real_))
  g <- transform_icrs_to_galactic(x)
  back <- transform_galactic_to_icrs(g)

  expect_equal(is.na(l(g)), c(FALSE, TRUE))
  expect_equal(is.na(b(g)), c(FALSE, TRUE))
  expect_equal(is.na(ra(back)), c(FALSE, TRUE))
  expect_equal(is.na(dec(back)), c(FALSE, TRUE))
})

test_that("transform_to dispatch and behavior", {
  x <- ra_dec(10, 20)
  g <- transform_to(x, galactic())
  id <- transform_to(x, icrs())

  expect_equal(frame(g)$name, "galactic")
  expect_identical(id, x)
  expect_error(transform_to(1, icrs()), "must be a <sky_coord>")
  expect_error(
    transform_to(x, sky_frame("custom", "u", "v")),
    "Unsupported transformation"
  )
})

test_that("base transform returns sky_coord for sky_coord input", {
  x <- ra_dec(10, 20)
  y <- transform(x, frame = galactic())
  y2 <- transform(x, galactic())

  expect_s3_class(y, "sky_coord")
  expect_s3_class(y2, "sky_coord")
  expect_equal(frame(y)$name, "galactic")
  expect_equal(frame(y2)$name, "galactic")
})
