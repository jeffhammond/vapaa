#include <mpi.h>

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// NOT STANDARD STUFF

void C_MPI_WIN_NULL(int * win)
{
    *win = MPI_Win_c2f(MPI_WIN_NULL);
}

// STANDARD STUFF

