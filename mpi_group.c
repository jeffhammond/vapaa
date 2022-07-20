#include <mpi.h>

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// NOT STANDARD STUFF

void C_MPI_GROUP_NULL(int * comm)
{
    *comm = MPI_Group_c2f(MPI_GROUP_NULL);
}

// STANDARD STUFF

