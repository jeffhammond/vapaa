#include <mpi.h>

// NOT STANDARD STUFF

void C_MPI_FILE_NULL(int * file)
{
    *file = MPI_File_c2f(MPI_FILE_NULL);
}

// STANDARD STUFF

