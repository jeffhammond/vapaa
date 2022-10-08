#include <mpi.h>

// NOT STANDARD STUFF

void C_MPI_WIN_NULL(int * win)
{
    *win = MPI_Win_c2f(MPI_WIN_NULL);
}

// STANDARD STUFF

