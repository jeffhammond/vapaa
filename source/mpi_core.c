#include <stdio.h>
#include <stdlib.h> // NULL
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "mpi_handle_conversions.h"
#include "mpi_constant_conversions.h"

// STANDARD STUFF

void C_MPI_Init(int * ierror)
{
    *ierror = MPI_Init(NULL, NULL);
    if (sizeof(MPI_Fint) != sizeof(int)) {
        fprintf(stderr, "MPI_Fint is wider than C int, which violates our design assumptions.\n");
    }
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Finalize(int * ierror)
{
    *ierror = MPI_Finalize();
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Init_thread(int * required_f, int * provided_f, int * ierror)
{
    int required = -1, provided = -1;
    required = C_MPI_THREAD_LEVEL_F2C(*required_f);
    *ierror = MPI_Init_thread(NULL, NULL, required, &provided);
    *provided_f = C_MPI_THREAD_LEVEL_F2C(provided);

    if (sizeof(MPI_Fint) != sizeof(int)) {
        fprintf(stderr, "MPI_Fint is wider than C int, which violates our design assumptions.\n");
    }
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Initialized(int * flag, int * ierror)
{
    *ierror = MPI_Initialized(flag);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Finalized(int * flag, int * ierror)
{
    *ierror = MPI_Finalized(flag);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Query_thread(int * provided_f, int * ierror)
{
    int provided = -1;
    *ierror = MPI_Query_thread(&provided);
    *provided_f = C_MPI_THREAD_LEVEL_F2C(provided);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Abort(int * comm_f, int * errorcode, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Abort(comm, *errorcode);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Get_version(int * version, int * subversion, int * ierror)
{
    *ierror = MPI_Get_version(version, subversion);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void C_MPI_Get_library_version(CFI_cdesc_t * version_d, int * resultlen, int * ierror)
{
    char * version = version_d -> base_addr;
    *ierror = MPI_Get_library_version(version, resultlen);
    C_MPI_RC_FIX(*ierror);
}
#else
#warning C_MPI_Get_library_version is probably broken...
void C_MPI_Get_library_version(char * version, int * resultlen, int * ierror)
{
    *ierror = MPI_Get_library_version(version, resultlen);
    C_MPI_RC_FIX(*ierror);
}
#endif

double C_MPI_Wtime(void)
{
    return MPI_Wtime();
}

double C_MPI_Wtick(void)
{
    return MPI_Wtick();
}
