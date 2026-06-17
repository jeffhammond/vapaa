// SPDX-License-Identifier: MIT

#include <mpi.h>
#include "convert_handles.h"
#include "convert_constants.h"

void C_MPI_Request_get_status(const int * request_f, int * flag_f, MPI_Status status, int * ierror)
{
    int flag;
    MPI_Request request = C_MPI_REQUEST_FROMINT(*request_f);
    *ierror = MPI_Request_get_status(request, &flag, &status);
    *flag_f = flag;
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Request_free(int * request_f, int * ierror)
{
    MPI_Request request = C_MPI_REQUEST_FROMINT(*request_f);
    *ierror = MPI_Request_free(&request);
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}
