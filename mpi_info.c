#include <mpi.h>

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// NOT STANDARD STUFF

void C_MPI_INFO_NULL(int * comm)
{
    *comm = MPI_Info_c2f(MPI_INFO_NULL);
}

// STANDARD STUFF

