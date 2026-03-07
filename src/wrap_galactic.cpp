#include <Rcpp.h>

#include "erfa.h"

using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::List cpp_era_icrs2g(Rcpp::NumericVector ra, Rcpp::NumericVector dec) {
  R_xlen_t n = ra.size();

  if (dec.size() != n) {
    Rcpp::stop("`ra` and `dec` must have the same length.");
  }

  Rcpp::NumericVector x(n);
  Rcpp::NumericVector y(n);

  for (R_xlen_t i = 0; i < n; ++i) {
    if (Rcpp::NumericVector::is_na(ra[i]) || Rcpp::NumericVector::is_na(dec[i])) {
      x[i] = NA_REAL;
      y[i] = NA_REAL;
      continue;
    }

    double l = 0.0;
    double b = 0.0;
    eraIcrs2g(ra[i], dec[i], &l, &b);
    x[i] = l;
    y[i] = b;
  }

  return Rcpp::List::create(
    Rcpp::Named("x") = x,
    Rcpp::Named("y") = y
  );
}

// [[Rcpp::export]]
Rcpp::List cpp_era_g2icrs(Rcpp::NumericVector l, Rcpp::NumericVector b) {
  R_xlen_t n = l.size();

  if (b.size() != n) {
    Rcpp::stop("`l` and `b` must have the same length.");
  }

  Rcpp::NumericVector x(n);
  Rcpp::NumericVector y(n);

  for (R_xlen_t i = 0; i < n; ++i) {
    if (Rcpp::NumericVector::is_na(l[i]) || Rcpp::NumericVector::is_na(b[i])) {
      x[i] = NA_REAL;
      y[i] = NA_REAL;
      continue;
    }

    double ra = 0.0;
    double dec = 0.0;
    eraG2icrs(l[i], b[i], &ra, &dec);
    x[i] = ra;
    y[i] = dec;
  }

  return Rcpp::List::create(
    Rcpp::Named("x") = x,
    Rcpp::Named("y") = y
  );
}
