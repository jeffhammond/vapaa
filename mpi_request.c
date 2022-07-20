#include <mpi.h>

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// NOT STANDARD STUFF

void C_MPI_REQUEST_NULL(int * comm)
{
    *comm = MPI_Request_c2f(MPI_REQUEST_NULL);
}

// STANDARD STUFF

