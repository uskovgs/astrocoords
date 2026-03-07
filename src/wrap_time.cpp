#include <Rcpp.h>

#include "erfa.h"

using namespace Rcpp;

namespace {

bool is_na_int(int x) {
  return x == NA_INTEGER;
}

}  // namespace

// [[Rcpp::export]]
Rcpp::List cpp_era_cal2jd(
    Rcpp::IntegerVector year,
    Rcpp::IntegerVector month,
    Rcpp::IntegerVector day
) {
  R_xlen_t n = year.size();
  if (month.size() != n || day.size() != n) {
    Rcpp::stop("`year`, `month`, and `day` must have the same length.");
  }

  Rcpp::NumericVector djm0(n, NA_REAL);
  Rcpp::NumericVector djm(n, NA_REAL);
  Rcpp::IntegerVector status(n, NA_INTEGER);

  for (R_xlen_t i = 0; i < n; ++i) {
    if (is_na_int(year[i]) || is_na_int(month[i]) || is_na_int(day[i])) {
      continue;
    }

    double out_djm0 = NA_REAL;
    double out_djm = NA_REAL;
    int st = eraCal2jd(year[i], month[i], day[i], &out_djm0, &out_djm);

    djm0[i] = out_djm0;
    djm[i] = out_djm;
    status[i] = st;
  }

  return Rcpp::List::create(
    Rcpp::Named("djm0") = djm0,
    Rcpp::Named("djm") = djm,
    Rcpp::Named("status") = status
  );
}

// [[Rcpp::export]]
Rcpp::List cpp_era_jd2cal(
    Rcpp::NumericVector d1,
    Rcpp::NumericVector d2
) {
  R_xlen_t n = d1.size();
  if (d2.size() != n) {
    Rcpp::stop("`d1` and `d2` must have the same length.");
  }

  Rcpp::IntegerVector year(n, NA_INTEGER);
  Rcpp::IntegerVector month(n, NA_INTEGER);
  Rcpp::IntegerVector day(n, NA_INTEGER);
  Rcpp::NumericVector fd(n, NA_REAL);
  Rcpp::IntegerVector status(n, NA_INTEGER);

  for (R_xlen_t i = 0; i < n; ++i) {
    if (Rcpp::NumericVector::is_na(d1[i]) || Rcpp::NumericVector::is_na(d2[i])) {
      continue;
    }

    int iy = NA_INTEGER;
    int im = NA_INTEGER;
    int id = NA_INTEGER;
    double ifd = NA_REAL;
    int st = eraJd2cal(d1[i], d2[i], &iy, &im, &id, &ifd);

    year[i] = iy;
    month[i] = im;
    day[i] = id;
    fd[i] = ifd;
    status[i] = st;
  }

  return Rcpp::List::create(
    Rcpp::Named("year") = year,
    Rcpp::Named("month") = month,
    Rcpp::Named("day") = day,
    Rcpp::Named("fd") = fd,
    Rcpp::Named("status") = status
  );
}

// [[Rcpp::export]]
Rcpp::List cpp_era_dtf2d(
    std::string scale,
    Rcpp::IntegerVector year,
    Rcpp::IntegerVector month,
    Rcpp::IntegerVector day,
    Rcpp::IntegerVector hour,
    Rcpp::IntegerVector minute,
    Rcpp::NumericVector second
) {
  R_xlen_t n = year.size();
  if (month.size() != n || day.size() != n || hour.size() != n ||
      minute.size() != n || second.size() != n) {
    Rcpp::stop("All calendar/time vectors must have the same length.");
  }

  Rcpp::NumericVector d1(n, NA_REAL);
  Rcpp::NumericVector d2(n, NA_REAL);
  Rcpp::IntegerVector status(n, NA_INTEGER);

  for (R_xlen_t i = 0; i < n; ++i) {
    if (is_na_int(year[i]) || is_na_int(month[i]) || is_na_int(day[i]) ||
        is_na_int(hour[i]) || is_na_int(minute[i]) ||
        Rcpp::NumericVector::is_na(second[i])) {
      continue;
    }

    double out_d1 = NA_REAL;
    double out_d2 = NA_REAL;
    int st = eraDtf2d(
      scale.c_str(),
      year[i],
      month[i],
      day[i],
      hour[i],
      minute[i],
      second[i],
      &out_d1,
      &out_d2
    );

    d1[i] = out_d1;
    d2[i] = out_d2;
    status[i] = st;
  }

  return Rcpp::List::create(
    Rcpp::Named("d1") = d1,
    Rcpp::Named("d2") = d2,
    Rcpp::Named("status") = status
  );
}

// [[Rcpp::export]]
Rcpp::List cpp_era_d2dtf(
    std::string scale,
    int ndp,
    Rcpp::NumericVector d1,
    Rcpp::NumericVector d2
) {
  R_xlen_t n = d1.size();
  if (d2.size() != n) {
    Rcpp::stop("`d1` and `d2` must have the same length.");
  }

  Rcpp::IntegerVector year(n, NA_INTEGER);
  Rcpp::IntegerVector month(n, NA_INTEGER);
  Rcpp::IntegerVector day(n, NA_INTEGER);
  Rcpp::IntegerVector hour(n, NA_INTEGER);
  Rcpp::IntegerVector minute(n, NA_INTEGER);
  Rcpp::IntegerVector second(n, NA_INTEGER);
  Rcpp::IntegerVector fraction(n, NA_INTEGER);
  Rcpp::IntegerVector status(n, NA_INTEGER);

  for (R_xlen_t i = 0; i < n; ++i) {
    if (Rcpp::NumericVector::is_na(d1[i]) || Rcpp::NumericVector::is_na(d2[i])) {
      continue;
    }

    int iy = NA_INTEGER;
    int im = NA_INTEGER;
    int id = NA_INTEGER;
    int ihmsf[4] = {NA_INTEGER, NA_INTEGER, NA_INTEGER, NA_INTEGER};
    int st = eraD2dtf(scale.c_str(), ndp, d1[i], d2[i], &iy, &im, &id, ihmsf);

    year[i] = iy;
    month[i] = im;
    day[i] = id;
    hour[i] = ihmsf[0];
    minute[i] = ihmsf[1];
    second[i] = ihmsf[2];
    fraction[i] = ihmsf[3];
    status[i] = st;
  }

  return Rcpp::List::create(
    Rcpp::Named("year") = year,
    Rcpp::Named("month") = month,
    Rcpp::Named("day") = day,
    Rcpp::Named("hour") = hour,
    Rcpp::Named("minute") = minute,
    Rcpp::Named("second") = second,
    Rcpp::Named("fraction") = fraction,
    Rcpp::Named("status") = status
  );
}
