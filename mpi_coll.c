#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// STANDARD STUFF

void C_MPI_Barrier(int * comm_f, int * ierror)
{
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    *ierror = MPI_Barrier(comm);
}

void C_MPI_Bcast(void * buffer, int * count, int * datatype_f, int * root, int * comm_f, int * ierror)
{
    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    *ierror = MPI_Bcast(buffer, *count, datatype, *root, comm);
}
