#include <mpi.h>

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// NOT STANDARD STUFF

void C_MPI_DATATYPE_NULL(int * datatype)
{
    *datatype = MPI_Type_c2f(MPI_DATATYPE_NULL);
}

// STANDARD STUFF

