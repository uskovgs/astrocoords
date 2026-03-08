#include <Rcpp.h>

#include "erfa.h"

using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::List cpp_era_s2c(
    Rcpp::NumericVector lon,
    Rcpp::NumericVector lat
) {
  R_xlen_t n = lon.size();
  if (lat.size() != n) {
    Rcpp::stop("`lon` and `lat` must have the same length.");
  }

  Rcpp::NumericVector x(n, NA_REAL);
  Rcpp::NumericVector y(n, NA_REAL);
  Rcpp::NumericVector z(n, NA_REAL);

  for (R_xlen_t i = 0; i < n; ++i) {
    if (Rcpp::NumericVector::is_na(lon[i]) || Rcpp::NumericVector::is_na(lat[i])) {
      continue;
    }

    double c[3] = {NA_REAL, NA_REAL, NA_REAL};
    eraS2c(lon[i], lat[i], c);
    x[i] = c[0];
    y[i] = c[1];
    z[i] = c[2];
  }

  return Rcpp::List::create(
    Rcpp::Named("x") = x,
    Rcpp::Named("y") = y,
    Rcpp::Named("z") = z
  );
}
