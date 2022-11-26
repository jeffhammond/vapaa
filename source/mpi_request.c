#include <mpi.h>
#include "mpi_handle_conversions.h"

void C_MPI_Request_get_status(const int * request_f, int * flag_f, MPI_Status status, int * ierror)
{
    int flag;
    MPI_Request request = C_MPI_REQUEST_F2C(*request_f);
    *ierror = MPI_Request_get_status(request, &flag, &status);
    *flag_f = flag;
}

void C_MPI_Request_free(int * request_f, int * ierror)
{
    MPI_Request request = C_MPI_REQUEST_F2C(*request_f);
    *ierror = MPI_Request_free(&request);
    *request_f = MPI_Request_c2f(request);
}
