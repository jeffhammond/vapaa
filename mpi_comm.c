#include <mpi.h>

// NOT STANDARD STUFF

void C_MPI_COMM_WORLD(int * comm)
{
    *comm = MPI_Comm_c2f(MPI_COMM_WORLD);
}

void C_MPI_COMM_SELF(int * comm)
{
    *comm = MPI_Comm_c2f(MPI_COMM_SELF);
}

void C_MPI_COMM_NULL(int * comm)
{
    *comm = MPI_Comm_c2f(MPI_COMM_NULL);
}

// STANDARD STUFF

void C_MPI_Comm_rank(int * comm_f, int * rank, int * ierror)
{
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    *ierror = MPI_Comm_rank(comm, rank);
}

void C_MPI_Comm_size(int * comm_f, int * size, int * ierror)
{
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    *ierror = MPI_Comm_size(comm, size);
}
