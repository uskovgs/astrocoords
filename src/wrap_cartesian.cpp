#include <Rcpp.h>

#include "erfa.h"

using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::NumericMatrix cpp_era_s2c(
    Rcpp::NumericVector lon,
    Rcpp::NumericVector lat
) {
  R_xlen_t n = lon.size();
  if (lat.size() != n) {
    Rcpp::stop("`lon` and `lat` must have the same length.");
  }

  Rcpp::NumericMatrix out(n, 3);
  for (R_xlen_t i = 0; i < n; ++i) {
    out(i, 0) = NA_REAL;
    out(i, 1) = NA_REAL;
    out(i, 2) = NA_REAL;
  }

  for (R_xlen_t i = 0; i < n; ++i) {
    if (Rcpp::NumericVector::is_na(lon[i]) || Rcpp::NumericVector::is_na(lat[i])) {
      continue;
    }

    double c[3] = {NA_REAL, NA_REAL, NA_REAL};
    eraS2c(lon[i], lat[i], c);
    out(i, 0) = c[0];
    out(i, 1) = c[1];
    out(i, 2) = c[2];
  }

  colnames(out) = Rcpp::CharacterVector::create("x", "y", "z");
  return out;
}
