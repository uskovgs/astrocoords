test_that("constructor works in degrees", {
  x <- sky_coord(180, 45)

  expect_s3_class(x, "sky_coord")
  expect_equal(ra(x), 180)
  expect_equal(dec(x), 45)
  expect_s3_class(frame(x), "icrs")
  expect_equal(format(frame(x)), "icrs")
})

test_that("is.sky_coord returns logical scalar", {
  x <- sky_coord(180, 45)

  expect_true(is.sky_coord(x))
  expect_false(is.sky_coord(1))
})

test_that("coordinate range validation rejects invalid values", {
  expect_error(
    sky_coord(361, 0),
    "ra"
  )

  expect_error(
    sky_coord(0, 91),
    "dec"
  )

  expect_error(
    gal_coord(361, 0),
    "\\bl\\b"
  )

  expect_error(
    gal_coord(0, 91),
    "\\bb\\b"
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
  expect_equal(frame(x)$x_min, 0)
  expect_equal(frame(x)$x_max, 360)
  expect_equal(frame(x)$y_min, -90)
  expect_equal(frame(x)$y_max, 90)
  expect_equal(l(x), 120)
  expect_equal(b(x), -30)
  expect_equal(l(y), 120)
  expect_equal(b(y), -30)
  expect_equal(frame(z)$name, "icrs")
  expect_equal(ra(z), 10)
  expect_equal(dec(z), 20)
})

test_that("frame-specific accessors validate frame", {
  x_icrs <- ra_dec(10, 20)
  x_gal <- gal_coord(120, -30)

  expect_error(l(x_icrs), "requires <galactic>")
  expect_error(b(x_icrs), "requires <galactic>")
  expect_error(ra(x_gal), "requires <icrs>")
  expect_error(dec(x_gal), "requires <icrs>")
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
  expect_equal(format(x), "00 40 00.0 +20 00 00")

  options(astrocoords.notation = "colon")
  expect_equal(format(x), "00:40:00.0 +20:00:00")
})

test_that("print shows compact header with frame", {
  x <- sky_coord(10, 20)
  out <- capture.output(print(x))

  expect_match(out[1], "^<sky\\|icrs>\\[1\\]$")
})

test_that("notation helpers work", {
  old_notation <- getOption("astrocoords.notation")
  if (is.null(old_notation)) {
    on.exit(options(astrocoords.notation = NULL), add = TRUE)
  } else {
    on.exit(options(astrocoords.notation = old_notation), add = TRUE)
  }
  options(astrocoords.notation = NULL)

  expect_equal(getOption("astrocoords.notation", "hmsdms"), "hmsdms")
  set_print_plain()
  expect_equal(getOption("astrocoords.notation"), "plain")
  set_print_pair()
  expect_equal(getOption("astrocoords.notation"), "pair")
  set_print_colon()
  expect_equal(getOption("astrocoords.notation"), "colon")
  set_print_hms()
  expect_equal(getOption("astrocoords.notation"), "hmsdms")
})

test_that("deg_to_hms and deg_to_dms are used for formatting helpers", {
  expect_equal(deg_to_hms(10), "00:40:00.0")
  expect_equal(deg_to_hms(10, sep = " "), "00 40 00.0")
  expect_equal(deg_to_hms(10, sep = "hms"), "00h40m00.0s")
  expect_equal(deg_to_dms(20, sep = "dms"), "+20°00'00\"")
  expect_equal(deg_to_dms(20, signed = FALSE), "20:00:00")
})
