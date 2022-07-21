#include <mpi.h>

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// NOT STANDARD STUFF

void C_MPI_FILE_NULL(int * file)
{
    *file = MPI_File_c2f(MPI_FILE_NULL);
}

// STANDARD STUFF

