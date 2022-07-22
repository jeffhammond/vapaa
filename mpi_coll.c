#include <mpi.h>

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// STANDARD STUFF

void C_MPI_Barrier(int * comm_f, int * ierror)
{
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    *ierror = MPI_Barrier(comm);
}
