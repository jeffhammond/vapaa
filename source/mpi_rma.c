#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "detect_sentinels.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "cfi_util.h"
#include "debug.h"

// NOT STANDARD STUFF

// STANDARD STUFF

void C_MPI_Compare_and_swap(void *origin_addr, void *compare_addr, void *result_addr,
                           int datatype, int target_rank, MPI_Aint target_disp,
                           int win, int *ierror)
{
    MPI_Datatype c_datatype = C_MPI_TYPE_F2C(datatype);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Compare_and_swap(origin_addr, compare_addr, result_addr,
                                  c_datatype, target_rank, target_disp, c_win);
    
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Compare_and_swap(CFI_cdesc_t *origin_desc, CFI_cdesc_t *compare_desc,
                             CFI_cdesc_t *result_desc, int datatype, int target_rank,
                             MPI_Aint target_disp, int win, int *ierror)
{
    MPI_Datatype c_datatype = C_MPI_TYPE_F2C(datatype);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Compare_and_swap(origin_desc->base_addr, compare_desc->base_addr,
                                  result_desc->base_addr, c_datatype, target_rank,
                                  target_disp, c_win);
    
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Fetch_and_op(void *origin_addr, void *result_addr, int datatype,
                        int target_rank, MPI_Aint target_disp, int op,
                        int win, int *ierror)
{
    MPI_Datatype c_datatype = C_MPI_TYPE_F2C(datatype);
    MPI_Op c_op = C_MPI_OP_F2C(op);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Fetch_and_op(origin_addr, result_addr, c_datatype,
                              target_rank, target_disp, c_op, c_win);
    
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Fetch_and_op(CFI_cdesc_t *origin_desc, CFI_cdesc_t *result_desc,
                          int datatype, int target_rank, MPI_Aint target_disp,
                          int op, int win, int *ierror)
{
    MPI_Datatype c_datatype = C_MPI_TYPE_F2C(datatype);
    MPI_Op c_op = C_MPI_OP_F2C(op);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Fetch_and_op(origin_desc->base_addr, result_desc->base_addr,
                              c_datatype, target_rank, target_disp, c_op, c_win);
    
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Put(void *origin_addr, int origin_count, int origin_datatype,
               int target_rank, MPI_Aint target_disp, int target_count,
               int target_datatype, int win, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Put(origin_addr, origin_count, c_origin_datatype,
                      target_rank, target_disp, target_count,
                      c_target_datatype, c_win);
    
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Put(CFI_cdesc_t *desc, int origin_count, int origin_datatype,
                 int target_rank, MPI_Aint target_disp, int target_count,
                 int target_datatype, int win, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Win c_win = C_MPI_WIN_F2C(win);

    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Put(desc->base_addr, origin_count, c_origin_datatype,
                         target_rank, target_disp, target_count,
                         c_target_datatype, c_win);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, origin_count, c_origin_datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Put(desc->base_addr, 1, subarray_type,
                         target_rank, target_disp, target_count,
                         c_target_datatype, c_win);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Get(void *origin_addr, int origin_count, int origin_datatype,
               int target_rank, MPI_Aint target_disp, int target_count,
               int target_datatype, int win, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Get(origin_addr, origin_count, c_origin_datatype,
                      target_rank, target_disp, target_count,
                      c_target_datatype, c_win);
    
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Get(CFI_cdesc_t *desc, int origin_count, int origin_datatype,
                 int target_rank, MPI_Aint target_disp, int target_count,
                 int target_datatype, int win, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Win c_win = C_MPI_WIN_F2C(win);

    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Get(desc->base_addr, origin_count, c_origin_datatype,
                         target_rank, target_disp, target_count,
                         c_target_datatype, c_win);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, origin_count, c_origin_datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Get(desc->base_addr, 1, subarray_type,
                         target_rank, target_disp, target_count,
                         c_target_datatype, c_win);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Accumulate(void *origin_addr, int origin_count, int origin_datatype,
                      int target_rank, MPI_Aint target_disp, int target_count,
                      int target_datatype, int op, int win, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Op c_op = C_MPI_OP_F2C(op);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Accumulate(origin_addr, origin_count, c_origin_datatype,
                            target_rank, target_disp, target_count,
                            c_target_datatype, c_op, c_win);
    
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Accumulate(CFI_cdesc_t *desc, int origin_count, int origin_datatype,
                        int target_rank, MPI_Aint target_disp, int target_count,
                        int target_datatype, int op, int win, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Op c_op = C_MPI_OP_F2C(op);
    MPI_Win c_win = C_MPI_WIN_F2C(win);

    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Accumulate(desc->base_addr, origin_count, c_origin_datatype,
                                target_rank, target_disp, target_count,
                                c_target_datatype, c_op, c_win);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, origin_count, c_origin_datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Accumulate(desc->base_addr, 1, subarray_type,
                                target_rank, target_disp, target_count,
                                c_target_datatype, c_op, c_win);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif


void C_MPI_Rput(void *origin_addr, int origin_count, int origin_datatype,
                int target_rank, MPI_Aint target_disp, int target_count,
                int target_datatype, int win, int *request, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    MPI_Request c_request;
    
    *ierror = MPI_Rput(origin_addr, origin_count, c_origin_datatype,
                       target_rank, target_disp, target_count,
                       c_target_datatype, c_win, &c_request);
    
    if (*ierror == MPI_SUCCESS) {
        *request = C_MPI_REQUEST_C2F(c_request);
    }
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Rput(CFI_cdesc_t *desc, int origin_count, int origin_datatype,
                  int target_rank, MPI_Aint target_disp, int target_count,
                  int target_datatype, int win, int *request, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    MPI_Request c_request;

    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Rput(desc->base_addr, origin_count, c_origin_datatype,
                          target_rank, target_disp, target_count,
                          c_target_datatype, c_win, &c_request);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, origin_count, c_origin_datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Rput(desc->base_addr, 1, subarray_type,
                          target_rank, target_disp, target_count,
                          c_target_datatype, c_win, &c_request);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    
    if (*ierror == MPI_SUCCESS) {
        *request = C_MPI_REQUEST_C2F(c_request);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Rget(void *origin_addr, int origin_count, int origin_datatype,
                int target_rank, MPI_Aint target_disp, int target_count,
                int target_datatype, int win, int *request, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    MPI_Request c_request;
    
    *ierror = MPI_Rget(origin_addr, origin_count, c_origin_datatype,
                       target_rank, target_disp, target_count,
                       c_target_datatype, c_win, &c_request);
    
    if (*ierror == MPI_SUCCESS) {
        *request = C_MPI_REQUEST_C2F(c_request);
    }
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Rget(CFI_cdesc_t *desc, int origin_count, int origin_datatype,
                  int target_rank, MPI_Aint target_disp, int target_count,
                  int target_datatype, int win, int *request, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    MPI_Request c_request;

    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Rget(desc->base_addr, origin_count, c_origin_datatype,
                          target_rank, target_disp, target_count,
                          c_target_datatype, c_win, &c_request);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, origin_count, c_origin_datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Rget(desc->base_addr, 1, subarray_type,
                          target_rank, target_disp, target_count,
                          c_target_datatype, c_win, &c_request);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    
    if (*ierror == MPI_SUCCESS) {
        *request = C_MPI_REQUEST_C2F(c_request);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Raccumulate(void *origin_addr, int origin_count, int origin_datatype,
                       int target_rank, MPI_Aint target_disp, int target_count,
                       int target_datatype, int op, int win, int *request, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Op c_op = C_MPI_OP_F2C(op);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    MPI_Request c_request;
    
    *ierror = MPI_Raccumulate(origin_addr, origin_count, c_origin_datatype,
                             target_rank, target_disp, target_count,
                             c_target_datatype, c_op, c_win, &c_request);
    
    if (*ierror == MPI_SUCCESS) {
        *request = C_MPI_REQUEST_C2F(c_request);
    }
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Raccumulate(CFI_cdesc_t *desc, int origin_count, int origin_datatype,
                         int target_rank, MPI_Aint target_disp, int target_count,
                         int target_datatype, int op, int win, int *request, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Op c_op = C_MPI_OP_F2C(op);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    MPI_Request c_request;

    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Raccumulate(desc->base_addr, origin_count, c_origin_datatype,
                                 target_rank, target_disp, target_count,
                                 c_target_datatype, c_op, c_win, &c_request);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, origin_count, c_origin_datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Raccumulate(desc->base_addr, 1, subarray_type,
                                 target_rank, target_disp, target_count,
                                 c_target_datatype, c_op, c_win, &c_request);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    
    if (*ierror == MPI_SUCCESS) {
        *request = C_MPI_REQUEST_C2F(c_request);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Rget_accumulate(void *origin_addr, int origin_count, int origin_datatype,
                          void *result_addr, int result_count, int result_datatype,
                          int target_rank, MPI_Aint target_disp, int target_count,
                          int target_datatype, int op, int win, int *request, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_result_datatype = C_MPI_TYPE_F2C(result_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Op c_op = C_MPI_OP_F2C(op);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    MPI_Request c_request;
    
    *ierror = MPI_Rget_accumulate(origin_addr, origin_count, c_origin_datatype,
                                 result_addr, result_count, c_result_datatype,
                                 target_rank, target_disp, target_count,
                                 c_target_datatype, c_op, c_win, &c_request);
    
    if (*ierror == MPI_SUCCESS) {
        *request = C_MPI_REQUEST_C2F(c_request);
    }
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Rget_accumulate(CFI_cdesc_t *origin_desc, int origin_count, int origin_datatype,
                            CFI_cdesc_t *result_desc, int result_count, int result_datatype,
                            int target_rank, MPI_Aint target_disp, int target_count,
                            int target_datatype, int op, int win, int *request, int *ierror)
{
    MPI_Datatype c_origin_datatype = C_MPI_TYPE_F2C(origin_datatype);
    MPI_Datatype c_result_datatype = C_MPI_TYPE_F2C(result_datatype);
    MPI_Datatype c_target_datatype = C_MPI_TYPE_F2C(target_datatype);
    MPI_Op c_op = C_MPI_OP_F2C(op);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    MPI_Request c_request;

    if (1 == CFI_is_contiguous(origin_desc) && 1 == CFI_is_contiguous(result_desc)) {
        *ierror = MPI_Rget_accumulate(origin_desc->base_addr, origin_count, c_origin_datatype,
                                     result_desc->base_addr, result_count, c_result_datatype,
                                     target_rank, target_disp, target_count,
                                     c_target_datatype, c_op, c_win, &c_request);
    } else {
        int rc;
        MPI_Datatype origin_subarray_type = MPI_DATATYPE_NULL;
        MPI_Datatype result_subarray_type = MPI_DATATYPE_NULL;
        
        rc = VAPAA_CFI_CREATE_DATATYPE(origin_desc, origin_count, c_origin_datatype, &origin_subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&origin_subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        
        rc = VAPAA_CFI_CREATE_DATATYPE(result_desc, result_count, c_result_datatype, &result_subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&result_subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        
        *ierror = MPI_Rget_accumulate(origin_desc->base_addr, 1, origin_subarray_type,
                                     result_desc->base_addr, 1, result_subarray_type,
                                     target_rank, target_disp, target_count,
                                     c_target_datatype, c_op, c_win, &c_request);
        
        rc = PMPI_Type_free(&origin_subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_free(&result_subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    
    if (*ierror == MPI_SUCCESS) {
        *request = C_MPI_REQUEST_C2F(c_request);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif
