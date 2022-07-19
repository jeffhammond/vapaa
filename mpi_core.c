#include <mpi.h>

void C_MPI_Init(int * ierror_c)
{
    *ierror_c = MPI_Init(NULL, NULL);
}

void C_MPI_Finalize(int * ierror_c)
{
    *ierror_c = MPI_Finalize();
}

void C_MPI_Init_thread(int * required_c, int * provided_c, int * ierror_c)
{
    *ierror_c = MPI_Init_thread(NULL, NULL, *required_c, provided_c);
}

void C_MPI_Initialized(int * flag_c, int * ierror_c)
{
    *ierror_c = MPI_Initialized(flag_c);
}

void C_MPI_Finalized(int * flag_c, int * ierror_c)
{
    *ierror_c = MPI_Finalized(flag_c);
}

void C_MPI_Query_thread(int * provided_c, int * ierror_c)
{
    *ierror_c = MPI_Query_thread(provided_c);
}
