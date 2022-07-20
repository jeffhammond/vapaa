#include <mpi.h>

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// NOT STANDARD STUFF

void C_MPI_COMM_WORLD(int * comm)
{
    *comm = MPI_Comm_c2f(MPI_COMM_WORLD);
}

void C_MPI_COMM_NULL(int * comm)
{
    *comm = MPI_Comm_c2f(MPI_COMM_NULL);
}
// STANDARD STUFF

void C_MPI_Init(int * ierror)
{
    *ierror = MPI_Init(NULL, NULL);
}

void C_MPI_Finalize(int * ierror)
{
    *ierror = MPI_Finalize();
}

void C_MPI_Init_thread(int * required, int * provided, int * ierror)
{
    *ierror = MPI_Init_thread(NULL, NULL, *required, provided);
}

void C_MPI_Initialized(int * flag, int * ierror)
{
    *ierror = MPI_Initialized(flag);
}

void C_MPI_Finalized(int * flag, int * ierror)
{
    *ierror = MPI_Finalized(flag);
}

void C_MPI_Query_thread(int * provided, int * ierror)
{
    *ierror = MPI_Query_thread(provided);
}

void C_MPI_Abort(int * comm_f, int * errorcode, int * ierror)
{
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    *ierror = MPI_Abort(comm, *errorcode);
}

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
