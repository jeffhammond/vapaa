#include <stdio.h>
#include <stdlib.h> // NULL
#include <mpi.h>

// We assume MPI_Fint is C int. This is verified during initialization.

// STANDARD STUFF

void C_MPI_Init(int * ierror)
{
    *ierror = MPI_Init(NULL, NULL);
    if (sizeof(MPI_Fint) != sizeof(int)) {
        fprintf(stderr, "MPI_Fint is wider than C int, which violates our design assumptions.\n");
    }
}

void C_MPI_Finalize(int * ierror)
{
    *ierror = MPI_Finalize();
}

void C_MPI_Init_thread(int * required, int * provided, int * ierror)
{
    *ierror = MPI_Init_thread(NULL, NULL, *required, provided);
    if (sizeof(MPI_Fint) != sizeof(int)) {
        fprintf(stderr, "MPI_Fint is wider than C int, which violates our design assumptions.\n");
    }
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

void C_MPI_Get_version(int * version, int * subversion, int * ierror)
{
    *ierror = MPI_Get_version(version, subversion);
}
