#include <mpi.h>

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// NOT STANDARD STUFF

void C_MPI_OP_NULL(int * op)
{
    *op = MPI_Op_c2f(MPI_OP_NULL);
}

// STANDARD STUFF

