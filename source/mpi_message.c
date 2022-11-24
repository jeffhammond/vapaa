#include <mpi.h>

// NOT STANDARD STUFF

void C_MPI_MESSAGE_NULL(int * message)
{
    *message = MPI_Message_c2f(MPI_MESSAGE_NULL);
}

// STANDARD STUFF

