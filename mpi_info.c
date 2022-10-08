#include <mpi.h>

// NOT STANDARD STUFF

void C_MPI_INFO_NULL(int * info)
{
    *info = MPI_Info_c2f(MPI_INFO_NULL);
}

// STANDARD STUFF

