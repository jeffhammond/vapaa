#include <mpi.h>

// NOT STANDARD STUFF

void C_MPI_GROUP_NULL(int * group)
{
    *group = MPI_Group_c2f(MPI_GROUP_NULL);
}

// STANDARD STUFF

