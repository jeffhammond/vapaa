#include <mpi.h>

void C_MPI_Init(int * ierror_c)
{
    *ierror_c = MPI_Init(NULL, NULL);
}

void C_MPI_Finalize(int * ierror_c)
{
    *ierror_c = MPI_Finalize();
}
