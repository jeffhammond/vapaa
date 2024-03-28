// SPDX-License-Identifier: MIT

#include <mpi.h>
#include "convert_handles.h"
#include "convert_constants.h"

#include "trampoline.h"

MPI_User_function * real_fn;

void reduce_trampoline(void *invec, void *inoutvec, int *len, MPI_Datatype * datatype)
{
    int rc;
    // because this is _only_ called with a dupe of the original type,
    // we can remove that from the cookie and get it this way instead
    MPI_Datatype parent_datatype;
    {
        int ni, na, nd, combiner;
        rc = MPI_Type_get_envelope(*datatype, &ni, &na, &nd, &combiner);
        if (rc || (ni != 0) || (na != 0) || (nd != 1) || (combiner != MPI_COMBINER_DUP)) {
            printf("%s: MPI_Type_get_envelope failed to do the right thing"
                   "rc=%d ni=%d na=%d nd=%d combiner=%d\n", __func__, rc, ni, na, nd, combiner);
        }
        rc = MPI_Type_get_contents(*datatype, ni, na, nd, NULL, NULL, &parent_datatype);
#if 0
        printf("%s: *datatype=%lx parent_datatype=%lx\n", __func__, (intptr_t)*datatype, (intptr_t)parent_datatype);
#endif
    }
    int flag;
    MPI_User_function* user_fn;
    rc = MPI_Type_get_attr(*datatype, TYPE_ATTR_FOR_USER_OP_FN, &user_fn, &flag);
    if (rc != MPI_SUCCESS || !flag) {
        printf("%s: MPI_Type_get_attr failed: flag=%d rc=%d\n", __func__, flag, rc);
        MPI_Abort(MPI_COMM_SELF,rc);
    }
    MPI_Datatype wrap_type = parent_datatype;
    (*user_fn)(invec,inoutvec,len,&wrap_type);
    // if parent_datatype is derived datatype returned by Type_get_contents, it must be freed
    if (IS_DERIVED_DATATYPE(parent_datatype)) {
        rc = MPI_Type_free(&parent_datatype);
    }
}

// we use the F2C/C2F functions directly here because these functions
// will never have built-in op handles as arguments

void C_MPI_Op_create(MPI_User_function *user_fn, int * commute_f, int * op_f, int * ierror)
{
    MPI_Op op = MPI_OP_NULL;
    //*ierror = MPI_Op_create(user_fn, *commute_f, &op);
    *ierror = MPI_Op_create(reduce_trampoline, *commute_f, &op);
    real_fn = user_fn;    
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

