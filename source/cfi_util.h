#ifndef CFI_UTIL_H
#define CFI_UTIL_H

#include <stdbool.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"

#define MAYBE_UNUSED __attribute__((unused))

//#define VAPAA_MAX(a,b) ((a) > (b) ? (a) : (b))

bool VAPAA_MPI_DATATYPE_IS_BUILTIN(MPI_Datatype t);
MPI_Datatype VAPAA_CFI_TO_MPI_TYPE(CFI_type_t type);
void VAPAA_CFI_GET_TYPE_ATTRIBUTE(CFI_attribute_t attribute, char * name);
void VAPAA_CFI_GET_TYPE_NAME(CFI_type_t type, char * name);
void VAPAA_CFI_PRINT_INFO(CFI_cdesc_t * desc);

// this function only handles the case where the datatype passed to the communication function
// is a named aka pre-defined aka built-in datatype, corresponding to the elements of the array.
int VAPAA_CFI_CREATE_DATATYPE(CFI_cdesc_t * desc, ssize_t count, MPI_Datatype input_datatype, 
                              MPI_Datatype * array_datatype);

#endif // CFI_UTIL_H
