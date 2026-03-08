# test_that("coord_match finds obvious matches and keeps unmatched x rows", {
#   x <- ra_dec(c(10, 200), c(0, 0))
#   y <- ra_dec(c(10 + 0.5 / 3600, 50), c(0, 0))

#   out <- coord_match(
#     x = x,
#     y = y,
#     max_sep = 1,
#     unit = "arcsec",
#     method = "bruteforce"
#   )

#   expect_s3_class(out, "data.frame")
#   expect_named(out, c("x_id", "y_id", "sep"))
#   expect_equal(out$x_id, c(1L, 2L))
#   expect_equal(out$y_id, c(1L, NA_integer_))
#   expect_true(out$sep[1] <= 1)
#   expect_true(is.na(out$sep[2]))
# })

# test_that("coord_match bruteforce and kdtree agree on small example", {
#   skip_if_not_installed("dbscan")

#   set.seed(1)
#   x <- ra_dec(runif(8, 0, 360), runif(8, -60, 60))
#   y <- ra_dec(runif(9, 0, 360), runif(9, -60, 60))

#   out_bruteforce <- coord_match(
#     x = x,
#     y = y,
#     max_sep = 30,
#     unit = "deg",
#     method = "bruteforce"
#   )
#   out_kdtree <- coord_match(
#     x = x,
#     y = y,
#     max_sep = 30,
#     unit = "deg",
#     method = "kdtree",
#     recalc_by_erfa = TRUE
#   )

#   expect_equal(out_kdtree, out_bruteforce, tolerance = 1e-10)
# })

# test_that("coord_match recalc_by_erfa modes are nearly identical", {
#   skip_if_not_installed("dbscan")

#   set.seed(2)
#   x <- ra_dec(runif(5, 0, 360), runif(5, -70, 70))
#   y <- ra_dec(runif(6, 0, 360), runif(6, -70, 70))

#   out_fast <- coord_match(
#     x = x,
#     y = y,
#     max_sep = 180,
#     unit = "rad",
#     method = "kdtree",
#     recalc_by_erfa = FALSE
#   )
#   out_exact <- coord_match(
#     x = x,
#     y = y,
#     max_sep = 180,
#     unit = "rad",
#     method = "kdtree",
#     recalc_by_erfa = TRUE
#   )

#   ord_fast <- order(out_fast$x_id, out_fast$y_id)
#   ord_exact <- order(out_exact$x_id, out_exact$y_id)

#   expect_equal(out_fast$x_id[ord_fast], out_exact$x_id[ord_exact])
#   expect_equal(out_fast$y_id[ord_fast], out_exact$y_id[ord_exact])
#   expect_equal(out_fast$sep[ord_fast], out_exact$sep[ord_exact], tolerance = 1e-8)
# })

# test_that("coord_match handles frame mismatch via transform_to", {
#   x <- ra_dec(c(10, 120), c(20, -30))
#   y <- transform_to(x, galactic())

#   out <- coord_match(
#     x = x,
#     y = y,
#     max_sep = 1e-3,
#     unit = "arcsec",
#     method = "bruteforce"
#   )

#   expect_equal(out$x_id, c(1L, 2L))
#   expect_equal(out$y_id, c(1L, 2L))
#   expect_true(all(out$sep <= 1e-3))
# })

# test_that("coord_nearest returns one nearest neighbor per x", {
#   x <- ra_dec(c(0, 10, 20), c(0, 0, 0))
#   y <- ra_dec(c(0.001, 0.010, 10.2, 30), c(0, 0, 0, 0))

#   out <- coord_nearest(
#     x = x,
#     y = y,
#     unit = "arcsec",
#     method = "bruteforce"
#   )

#   expect_s3_class(out, "data.frame")
#   expect_named(out, c("x_id", "y_id", "sep"))
#   expect_equal(out$x_id, c(1L, 2L, 3L))
#   expect_equal(out$y_id, c(1L, 3L, 3L))
#   expect_false(any(is.na(out$sep)))
# })
