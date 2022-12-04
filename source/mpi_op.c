#include <mpi.h>
#include "mpi_handle_conversions.h"
#include "mpi_constant_conversions.h"

// we use the F2C/C2F functions directly here because these functions
// will never have built-in op handles as arguments

void C_MPI_Op_create(MPI_User_function *user_fn, int * commute_f, int * op_f, int * ierror)
{
    MPI_Op op = MPI_OP_NULL;
    *ierror = MPI_Op_create(user_fn, *commute_f, &op);
    *op_f = MPI_Op_c2f(op);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Op_free(int * op_f, int * ierror)
{
    MPI_Op op = MPI_Op_f2c(*op_f);
    *ierror = MPI_Op_free(&op);
    *op_f = MPI_Op_c2f(op);
    C_MPI_RC_FIX(*ierror);
}

