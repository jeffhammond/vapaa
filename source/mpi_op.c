// SPDX-License-Identifier: MIT

#include <stdio.h>
#include <mpi.h>
#include "convert_handles.h"
#include "convert_constants.h"

static int op_f_index = 0;

void C_MPI_Op_create(MPI_User_function *user_fn, int * commute_f, int * op_f, int * ierror)
{
    MPI_Op op = MPI_OP_NULL;
    *ierror = MPI_Op_create(user_fn, *commute_f, &op);
    *op_f = op_f_index++;
    int rc = add_op_f2c(*op_f, op);
    if (rc != 1) printf("add_op_f2c failed\n");
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Op_free(int * op_f, int * ierror)
{
    MPI_Op op;
    int rc = find_op_f2c(*op_f, &op);
    if (rc != 1) printf("find_op_f2c failed\n");
    *ierror = MPI_Op_free(&op);
    rc = remove_op_f2c(*op_f);
    if (rc != 1) printf("remove_op_f2c failed\n");
    *op_f = VAPAA_MPI_OP_NULL;
    C_MPI_RC_FIX(*ierror);
}

