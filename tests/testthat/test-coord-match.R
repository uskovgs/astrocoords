test_that("coord_match bruteforce evaluates all pair combinations", {
  x <- ra_dec(c(0, 10), c(0, 0))
  y <- ra_dec(c(0, 20, 40), c(0, 0, 0))

  out <- coord_match(
    x = x,
    y = y,
    max_sep = 180,
    unit = "deg",
    method = "bruteforce"
  )

  expect_equal(nrow(out), 6L)
  expect_false(any(is.na(out[, "y_id"])))
  expect_equal(sort(unique(out[ , "x_id"])), c(1L, 2L))
  expect_equal(sort(unique(out[ ,"y_id"])), c(1L, 2L, 3L))
})
