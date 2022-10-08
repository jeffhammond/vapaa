#include <mpi.h>

// NOT STANDARD STUFF

void C_MPI_REQUEST_NULL(int * request)
{
    *request = MPI_Request_c2f(MPI_REQUEST_NULL);
}

// STANDARD STUFF

