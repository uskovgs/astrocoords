#include <math.h>

#include "erfa.h"
#include "erfam.h"

double eraAnpm(double a)
/*
**  - - - - - - - -
**   e r a A n p m
**  - - - - - - - -
**
**  Normalize angle into the range -pi <= a < +pi.
*/
{
   double w;

   w = fmod(a, ERFA_D2PI);
   if (fabs(w) >= ERFA_DPI) w -= ERFA_DSIGN(ERFA_D2PI, a);

   return w;
}
