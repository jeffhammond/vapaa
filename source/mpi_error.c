#include <mpi.h>
#include "ISO_Fortran_binding.h"

// NOT STANDARD STUFF


// STANDARD STUFF

//void C_MPI_Error_string(char * string, int * resultlen, int * ierror)
void C_MPI_Error_string(int * errorcode, CFI_cdesc_t * string_d, int * resultlen, int * ierror)
{
    char * string = string_d -> base_addr;
    *ierror = MPI_Error_string(*errorcode, string, resultlen);
}

void C_MPI_Error_class(int * errorcode, int * errorclass, int * ierror)
{
    *ierror = MPI_Error_class(*errorcode, errorclass);
}
