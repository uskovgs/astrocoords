.circular_diff_deg <- function(a, b) {
  abs((((a - b) + 180) %% 360) - 180)
}

test_that("ICRS and Galactic transforms round-trip", {
  x <- ra_dec(c(10, 120, 359.5), c(20, -30, 5))
  g <- transform_to(x, galactic())
  back <- transform_to(g, icrs())

  expect_equal(frame(g)$name, "galactic")
  expect_equal(frame(back)$name, "icrs")
  expect_true(all(.circular_diff_deg(ra(back), ra(x)) < 1e-9))
  expect_equal(dec(back), dec(x), tolerance = 1e-9)
})

test_that("transforms preserve NA values", {
  x <- ra_dec(c(10, NA_real_), c(20, NA_real_))
  g <- transform_to(x, galactic())
  back <- transform_to(g, icrs())

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
  expect_error(transform_to(1, icrs()), "Must inherit from class 'sky_coord'")
  custom_frame <- structure(
    list(name = "custom", x_name = "u", y_name = "v"),
    class = c("custom", "sky_frame")
  )
  expect_error(
    transform_to(x, custom_frame),
    "Unsupported transformation"
  )
})

test_that("base transform for sky_coord errors with transform_to hint", {
  x <- ra_dec(10, 20)
  expect_error(
    transform(x, frame = galactic()),
    "`transform\\(\\)` is not supported for `sky_coord` objects\\."
  )
  expect_error(
    transform(x, galactic()),
    "Did you mean `transform_to\\(\\)`\\?"
  )
})
