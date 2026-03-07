#include <math.h>

#include "erfa.h"
#include "erfam.h"

double eraAnp(double a)
/*
**  - - - - - - -
**   e r a A n p
**  - - - - - - -
**
**  Normalize angle into the range 0 <= a < 2pi.
*/
{
   double w;

   w = fmod(a, ERFA_D2PI);
   if (w < 0) w += ERFA_D2PI;

   return w;
}
