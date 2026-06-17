// SPDX-License-Identifier: MIT

#include <mpi.h>
#include "convert_handles.h"
#include "convert_constants.h"

// User-defined ops are dynamic handles and still pass through Vapaa's handle
// conversion layer so MPI-5 ABI builds use fromint/toint.

void C_MPI_Op_create(MPI_User_function *user_fn, int * commute_f, int * op_f, int * ierror)
{
    MPI_Op op = MPI_OP_NULL;
    *ierror = MPI_Op_create(user_fn, *commute_f, &op);
    *op_f = C_MPI_OP_TOINT(op);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Op_free(int * op_f, int * ierror)
{
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    *ierror = MPI_Op_free(&op);
    *op_f = C_MPI_OP_TOINT(op);
    C_MPI_RC_FIX(*ierror);
}
