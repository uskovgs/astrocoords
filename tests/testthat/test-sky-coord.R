test_that("constructor works in degrees", {
  x <- sky_coord(180, 45)

  expect_s3_class(x, "sky_coord")
  expect_equal(ra(x), 180)
  expect_equal(dec(x), 45)
  expect_s3_class(frame(x), "icrs")
  expect_equal(format(frame(x)), "icrs")
})

test_that("latitude validation rejects invalid values", {
  expect_error(
    sky_coord(0, 91),
    "between -90 and 90"
  )

  expect_error(
    new_sky_coord(0, 91, frame = icrs()),
    "between -90 and 90"
  )
})

test_that("constructor recycles inputs", {
  x <- sky_coord(c(0, 90), 0)

  expect_equal(vctrs::vec_size(x), 2L)
  expect_equal(ra(x), c(0, 90))
  expect_equal(dec(x), c(0, 0))
})

test_that("galactic frame and sugar constructors work", {
  x <- sky_coord(120, -30, frame = galactic())
  y <- gal_coord(120, -30)
  z <- ra_dec(10, 20)

  expect_equal(frame(x)$name, "galactic")
  expect_equal(frame(x)$x_name, "l")
  expect_equal(frame(x)$y_name, "b")
  expect_equal(ra(x), 120)
  expect_equal(dec(x), -30)
  expect_equal(ra(y), 120)
  expect_equal(dec(y), -30)
  expect_equal(frame(z)$name, "icrs")
})

test_that("format supports configurable styles", {
  x <- sky_coord(10, 20)
  old <- options()
  on.exit(options(old), add = TRUE)

  expect_equal(format(x), "00h40m00.0s +20\u00b000'00\"")

  options(astrocoords.notation = "pair")
  expect_equal(format(x), "(10, 20)")

  options(astrocoords.notation = "hmsdms")
  expect_equal(format(x), "00h40m00.0s +20\u00b000'00\"")

  options(astrocoords.notation = "plain")
  expect_equal(format(x), "00 40 000.0 +20 00 00")
})

test_that("print shows compact header with frame", {
  x <- sky_coord(10, 20)
  out <- capture.output(print(x))

  expect_match(out[1], "^<sky_coord\\[1\\] icrs>$")
})

test_that("notation helpers work", {
  old_notation <- getOption("astrocoords.notation")
  if (is.null(old_notation)) {
    on.exit(options(astrocoords.notation = NULL), add = TRUE)
  } else {
    on.exit(options(astrocoords.notation = old_notation), add = TRUE)
  }
  options(astrocoords.notation = NULL)

  expect_equal(get_sky_coord_notation(), "hmsdms")
  set_print_plain()
  expect_equal(get_sky_coord_notation(), "plain")
  set_print_pair()
  expect_equal(get_sky_coord_notation(), "pair")
  set_print_hms()
  expect_equal(get_sky_coord_notation(), "hmsdms")
})
