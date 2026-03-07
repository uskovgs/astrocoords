#include "erfadatextra.h"

int eraDatini(const eraLEAPSECOND *builtin, int n_builtin,
              eraLEAPSECOND **leapseconds)
{
  *leapseconds = (eraLEAPSECOND *)builtin;
  return n_builtin;
}
