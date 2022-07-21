#include <mpi.h>

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// NOT STANDARD STUFF

void C_MPI_STATUS_IGNORE(MPI_F08_status * status, int * ierror)
{
    *ierror = MPI_Status_c2f08(MPI_STATUS_IGNORE,status);
}

// STANDARD STUFF

