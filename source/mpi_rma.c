// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "cfi_util.h"
#include "debug.h"

void C_MPI_Get(void * origin_addr, int origin_count, int origin_datatype_f,
               int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
               int win_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Get(origin_addr, origin_count, origin_datatype,
                      target_rank, (MPI_Aint)target_disp, target_count, target_datatype,
                      win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Put(const void * origin_addr, int origin_count, int origin_datatype_f,
               int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
               int win_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Put(origin_addr, origin_count, origin_datatype,
                      target_rank, (MPI_Aint)target_disp, target_count, target_datatype,
                      win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Rget(void * origin_addr, int origin_count, int origin_datatype_f,
                int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
                int win_f, int * request_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_Rget(origin_addr, origin_count, origin_datatype,
                       target_rank, (MPI_Aint)target_disp, target_count, target_datatype,
                       win, &request);
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Rput(const void * origin_addr, int origin_count, int origin_datatype_f,
                int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
                int win_f, int * request_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_Rput(origin_addr, origin_count, origin_datatype,
                       target_rank, (MPI_Aint)target_disp, target_count, target_datatype,
                       win, &request);
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Accumulate(const void * origin_addr, int origin_count, int origin_datatype_f,
                      int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
                      int op_f, int win_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Op op = C_MPI_OP_F2C(op_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Accumulate(origin_addr, origin_count, origin_datatype,
                             target_rank, (MPI_Aint)target_disp, target_count, target_datatype,
                             op, win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Fetch_and_op(const void * origin_addr, void * result_addr, int datatype_f,
                        int target_rank, intptr_t target_disp, int op_f, int win_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Op op = C_MPI_OP_F2C(op_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Fetch_and_op(origin_addr, result_addr, datatype,
                               target_rank, (MPI_Aint)target_disp, op, win);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Get(CFI_cdesc_t * desc, int origin_count, int origin_datatype_f,
                 int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
                 int win_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Get(desc->base_addr, origin_count, origin_datatype,
                          target_rank, (MPI_Aint)target_disp, target_count, target_datatype, win);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, origin_count, origin_datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Get(desc->base_addr, 1, subarray_type,
                          target_rank, (MPI_Aint)target_disp, target_count, target_datatype, win);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    C_MPI_RC_FIX(*ierror);
}

void CFI_MPI_Put(CFI_cdesc_t * desc, int origin_count, int origin_datatype_f,
                 int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
                 int win_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Put(desc->base_addr, origin_count, origin_datatype,
                          target_rank, (MPI_Aint)target_disp, target_count, target_datatype, win);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, origin_count, origin_datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Put(desc->base_addr, 1, subarray_type,
                          target_rank, (MPI_Aint)target_disp, target_count, target_datatype, win);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    C_MPI_RC_FIX(*ierror);
}

void CFI_MPI_Rget(CFI_cdesc_t * desc, int origin_count, int origin_datatype_f,
                  int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
                  int win_f, int * request_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    MPI_Request request = MPI_REQUEST_NULL;
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Rget(desc->base_addr, origin_count, origin_datatype,
                           target_rank, (MPI_Aint)target_disp, target_count, target_datatype, win, &request);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, origin_count, origin_datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Rget(desc->base_addr, 1, subarray_type,
                           target_rank, (MPI_Aint)target_disp, target_count, target_datatype, win, &request);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

void CFI_MPI_Rput(CFI_cdesc_t * desc, int origin_count, int origin_datatype_f,
                  int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
                  int win_f, int * request_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    MPI_Request request = MPI_REQUEST_NULL;
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Rput(desc->base_addr, origin_count, origin_datatype,
                           target_rank, (MPI_Aint)target_disp, target_count, target_datatype, win, &request);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, origin_count, origin_datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Rput(desc->base_addr, 1, subarray_type,
                           target_rank, (MPI_Aint)target_disp, target_count, target_datatype, win, &request);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

void CFI_MPI_Accumulate(CFI_cdesc_t * desc, int origin_count, int origin_datatype_f,
                        int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
                        int op_f, int win_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Op op = C_MPI_OP_F2C(op_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Accumulate(desc->base_addr, origin_count, origin_datatype,
                                 target_rank, (MPI_Aint)target_disp, target_count, target_datatype, op, win);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, origin_count, origin_datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Accumulate(desc->base_addr, 1, subarray_type,
                                 target_rank, (MPI_Aint)target_disp, target_count, target_datatype, op, win);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    C_MPI_RC_FIX(*ierror);
}

void CFI_MPI_Fetch_and_op(CFI_cdesc_t * origin_desc, CFI_cdesc_t * result_desc, int datatype_f,
                          int target_rank, intptr_t target_disp, int op_f, int win_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Op op = C_MPI_OP_F2C(op_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Fetch_and_op(origin_desc->base_addr, result_desc->base_addr, datatype,
                               target_rank, (MPI_Aint)target_disp, op, win);
    C_MPI_RC_FIX(*ierror);
}
#endif
