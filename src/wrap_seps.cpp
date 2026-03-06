#include <Rcpp.h>


#include "erfa.h"


using namespace Rcpp;



// [[Rcpp::export]]
Rcpp::NumericVector cpp_era_seps(
    Rcpp::NumericVector lon1,
    Rcpp::NumericVector lat1,
    Rcpp::NumericVector lon2,
    Rcpp::NumericVector lat2
) {
  R_xlen_t n = lon1.size();

  if (lat1.size() != n || lon2.size() != n || lat2.size() != n) {
    Rcpp::stop("All inputs must have the same length.");
  }

  Rcpp::NumericVector out(n);

  for (R_xlen_t i = 0; i < n; ++i) {
    if (Rcpp::NumericVector::is_na(lon1[i]) ||
        Rcpp::NumericVector::is_na(lat1[i]) ||
        Rcpp::NumericVector::is_na(lon2[i]) ||
        Rcpp::NumericVector::is_na(lat2[i])) {
      out[i] = NA_REAL;
      continue;
    }

    out[i] = eraSeps(lon1[i], lat1[i], lon2[i], lat2[i]);
  }

  return out;
}

