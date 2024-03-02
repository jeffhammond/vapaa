// SPDX-License-Identifier: MIT

#include <mpi.h>
#include "convert_handles.h"
#include "convert_constants.h"

void C_MPI_Status_set_elements(struct F_MPI_Status * status_f, int datatype_f, int count, int * ierror)
{
    MPI_Status status;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    *ierror = MPI_Status_set_elements(&status, datatype, count);
    C_MPI_STATUS_C2F(&status, status_f);
    C_MPI_RC_FIX(*ierror);
}
