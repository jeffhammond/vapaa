#ifndef CFI_UTIL_H
#define CFI_UTIL_H

#include <mpi.h>
#include "ISO_Fortran_binding.h"

int VAPAA_CFI_CREATE_DATATYPE(const CFI_cdesc_t * desc, int count, MPI_Datatype input_datatype, 
                              MPI_Datatype * array_datatype);

#endif // CFI_UTIL_H
