test_that("roundtrip POSIXct -> JD -> POSIXct works for UTC", {
  x <- as.POSIXct(
    c("2024-01-05 12:34:56", "2010-06-15 00:00:01"),
    tz = "UTC"
  )

  jd <- datetime_to_jd(x)
  back <- jd_to_datetime(jd, tz = "UTC")

  expect_s3_class(back, "POSIXct")
  expect_equal(as.numeric(back), as.numeric(x), tolerance = 1e-6)
})

test_that("Date input is supported and maps to midnight UTC", {
  jd <- datetime_to_jd(as.Date("2026-03-08"))
  expect_equal(jd, 2461107.5, tolerance = 1e-10)
})

test_that("mjd_to_datetime works for known MJD", {
  x <- mjd_to_datetime(51544, tz = "UTC")
  expect_equal(format(x, tz = "UTC", usetz = FALSE), "2000-01-01")
})

test_that("vectorized conversion works", {
  x <- as.POSIXct(
    c("2020-01-01 00:00:00", "2020-01-02 00:00:00", "2020-01-03 00:00:00"),
    tz = "UTC"
  )
  jd <- datetime_to_jd(x)
  back <- jd_to_datetime(jd, tz = "UTC")

  expect_length(jd, 3L)
  expect_equal(as.numeric(back), as.numeric(x), tolerance = 1e-6)
})

test_that("time conversion function names are consistent", {
  x <- as.POSIXct("2026-03-08 12:34:56", tz = "UTC")

  expect_equal(jd_to_datetime(datetime_to_jd(x), tz = "UTC"), x)
  expect_equal(mjd_to_datetime(61107.25, tz = "UTC"), jd_to_datetime(61107.25 + 2400000.5, tz = "UTC"))
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

test_that("leap_second_dates returns known ERFA table dates", {
  x <- leap_second_dates()

  expect_s3_class(x, "Date")
  expect_true(as.Date("1972-07-01") %in% x)
  expect_true(as.Date("2017-01-01") %in% x)
})
