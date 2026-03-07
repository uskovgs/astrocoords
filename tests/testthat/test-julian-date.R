test_that("roundtrip POSIXct -> JD -> POSIXct works for UTC", {
  x <- as.POSIXct(
    c("2024-01-05 12:34:56", "2010-06-15 00:00:01"),
    tz = "UTC"
  )

  jd <- jd_fromdate(x, scale = "UTC")
  back <- jd2greg(jd, scale = "UTC", tz = "UTC")

  expect_s3_class(back, "POSIXct")
  expect_equal(as.numeric(back), as.numeric(x), tolerance = 1e-6)
})

test_that("Date input is supported and maps to midnight UTC", {
  jd <- jd_fromdate(as.Date("2026-03-08"), scale = "UTC")
  expect_equal(jd, 2461107.5, tolerance = 1e-10)
})

test_that("mjd2greg works for known MJD", {
  x <- mjd2greg(51544, scale = "UTC", tz = "UTC")
  expect_equal(format(x, tz = "UTC", usetz = FALSE), "2000-01-01")
})

test_that("vectorized conversion works", {
  x <- as.POSIXct(
    c("2020-01-01 00:00:00", "2020-01-02 00:00:00", "2020-01-03 00:00:00"),
    tz = "UTC"
  )
  jd <- jd_fromdate(x)
  back <- jd2greg(jd, tz = "UTC")

  expect_length(jd, 3L)
  expect_equal(as.numeric(back), as.numeric(x), tolerance = 1e-6)
})

test_that("invalid calendar dates produce errors via status handling", {
  out <- astrocoords:::cpp_era_cal2jd(2024L, 2L, 31L)
  expect_true(out$status < 0L)
  expect_error(astrocoords:::.handle_erfa_status(out$status, "eraCal2jd"), "failed")
})

test_that("positive ERFA status is surfaced as warning when encountered", {
  out <- astrocoords:::cpp_era_dtf2d("UTC", 2014L, 6L, 30L, 23L, 59L, 60)

  if (is.na(out$status) || out$status <= 0L) {
    skip("No positive leap-second-related status returned by ERFA for this input.")
  }

  expect_warning(
    astrocoords:::.handle_erfa_status(out$status, "eraDtf2d"),
    "warning status"
  )
})
