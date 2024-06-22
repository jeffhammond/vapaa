// SPDX-License-Identifier: MIT

#include <stdio.h>
#include <stdlib.h> // NULL
#include <string.h> // memset
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"

// STANDARD STUFF

void C_MPI_Init(int * ierror)
{
    *ierror = MPI_Init(NULL, NULL);
    // it is not clear if we need this - do we rely on MPI_Fint anywhere?
    if (sizeof(MPI_Fint) != sizeof(int)) {
        fprintf(stderr, "MPI_Fint is wider than C int, which violates our design assumptions.\n");
    }
    C_MPI_RC_FIX(*ierror);

    // DEBUG
    MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN);
    MPI_Comm_set_errhandler(MPI_COMM_SELF, MPI_ERRORS_RETURN);
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
    // it is not clear if we need this - do we rely on MPI_Fint anywhere?
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

void C_MPI_Get_library_version(char * version, int * resultlen, int * ierror)
{
    // we can fix this with malloc...
    if (VAPAA_MPI_MAX_LIBRARY_VERSION_STRING < MPI_MAX_LIBRARY_VERSION_STRING) {
        fprintf(stderr,"C_MPI_Get_library_version: buffer is not large enough - "
                       "bad things are going to happen now!\n"
                       "VAPAA_MPI_MAX_LIBRARY_VERSION_STRING=%d, MPI_MAX_LIBRARY_VERSION_STRING=%d\n",
                       VAPAA_MPI_MAX_LIBRARY_VERSION_STRING, MPI_MAX_LIBRARY_VERSION_STRING);
    }
    memset(version,0,VAPAA_MPI_MAX_LIBRARY_VERSION_STRING);
    *ierror = MPI_Get_library_version(version, resultlen);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Get_library_version(CFI_cdesc_t * version_d, int * resultlen, int * ierror)
{
    // we can fix this with malloc...
    if (VAPAA_MPI_MAX_LIBRARY_VERSION_STRING < MPI_MAX_LIBRARY_VERSION_STRING) {
        fprintf(stderr,"C_MPI_Get_library_version: buffer is not large enough - "
                       "bad things are going to happen now!\n"
                       "VAPAA_MPI_MAX_LIBRARY_VERSION_STRING=%d, MPI_MAX_LIBRARY_VERSION_STRING=%d\n",
                       VAPAA_MPI_MAX_LIBRARY_VERSION_STRING, MPI_MAX_LIBRARY_VERSION_STRING);
    }
    char * version = version_d -> base_addr;
    memset(version,0,VAPAA_MPI_MAX_LIBRARY_VERSION_STRING);
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
