// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <limits.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "mpi_attr_storage.h"
#include "detect_sentinels.h"
#include "vapaa_constants.h"
#include "cfi_util.h"

static void VAPAA_MPI_CLEAR_WIN_NAME(MPI_Win win)
{
    (void) MPI_Win_set_name(win, "");
}

static int VAPAA_MPI_ASSERT_F2C(int f)
{
#if MPI_VERSION >= 5
    return f;
#else
    int c = 0;
    if (f & VAPAA_MPI_MODE_NOCHECK) c |= MPI_MODE_NOCHECK;
    if (f & VAPAA_MPI_MODE_NOSTORE) c |= MPI_MODE_NOSTORE;
    if (f & VAPAA_MPI_MODE_NOPUT) c |= MPI_MODE_NOPUT;
    if (f & VAPAA_MPI_MODE_NOPRECEDE) c |= MPI_MODE_NOPRECEDE;
    if (f & VAPAA_MPI_MODE_NOSUCCEED) c |= MPI_MODE_NOSUCCEED;
    return c;
#endif
}

static int VAPAA_MPI_LOCK_F2C(int f)
{
#if MPI_VERSION >= 5
    return f;
#else
    if (f == VAPAA_MPI_LOCK_EXCLUSIVE) {
        return MPI_LOCK_EXCLUSIVE;
    } else if (f == VAPAA_MPI_LOCK_SHARED) {
        return MPI_LOCK_SHARED;
    } else {
        return f;
    }
#endif
}

#ifdef HAVE_CFI
static void *VAPAA_MPI_RMA_ADDR(CFI_cdesc_t *desc)
{
    return C_IS_MPI_BOTTOM(desc->base_addr) ? MPI_BOTTOM : desc->base_addr;
}
#endif

void VAPAA_MPI_Win_allocate(intptr_t *size_f, int *disp_unit, int *info_f, int *comm_f, void **baseptr, int *win_f, int *ierror)
{
    MPI_Win win = MPI_WIN_NULL;
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Win_allocate((MPI_Aint) *size_f, *disp_unit, info, comm, baseptr, &win);
    if (*ierror == MPI_SUCCESS) VAPAA_MPI_CLEAR_WIN_NAME(win);
    *win_f = C_MPI_WIN_TOINT(win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_allocate_c(intptr_t *size_f, intptr_t *disp_unit_f, int *info_f, int *comm_f, void **baseptr, int *win_f, int *ierror)
{
    MPI_Win win = MPI_WIN_NULL;
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
#if MPI_VERSION >= 4
    *ierror = MPI_Win_allocate_c((MPI_Aint) *size_f, (MPI_Aint) *disp_unit_f, info, comm, baseptr, &win);
#else
    if (*disp_unit_f > INT_MAX || *disp_unit_f < INT_MIN) {
        *ierror = MPI_ERR_ARG;
    } else {
        *ierror = MPI_Win_allocate((MPI_Aint) *size_f, (int) *disp_unit_f, info, comm, baseptr, &win);
    }
#endif
    if (*ierror == MPI_SUCCESS) VAPAA_MPI_CLEAR_WIN_NAME(win);
    *win_f = C_MPI_WIN_TOINT(win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_allocate_shared(intptr_t *size_f, int *disp_unit, int *info_f, int *comm_f, void **baseptr, int *win_f, int *ierror)
{
    MPI_Win win = MPI_WIN_NULL;
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Win_allocate_shared((MPI_Aint) *size_f, *disp_unit, info, comm, baseptr, &win);
    if (*ierror == MPI_SUCCESS) VAPAA_MPI_CLEAR_WIN_NAME(win);
    *win_f = C_MPI_WIN_TOINT(win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_allocate_shared_c(intptr_t *size_f, intptr_t *disp_unit_f, int *info_f, int *comm_f, void **baseptr, int *win_f, int *ierror)
{
    MPI_Win win = MPI_WIN_NULL;
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
#if MPI_VERSION >= 4
    *ierror = MPI_Win_allocate_shared_c((MPI_Aint) *size_f, (MPI_Aint) *disp_unit_f, info, comm, baseptr, &win);
#else
    if (*disp_unit_f > INT_MAX || *disp_unit_f < INT_MIN) {
        *ierror = MPI_ERR_ARG;
    } else {
        *ierror = MPI_Win_allocate_shared((MPI_Aint) *size_f, (int) *disp_unit_f, info, comm, baseptr, &win);
    }
#endif
    if (*ierror == MPI_SUCCESS) VAPAA_MPI_CLEAR_WIN_NAME(win);
    *win_f = C_MPI_WIN_TOINT(win);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void VAPAA_MPI_Put(CFI_cdesc_t *origin_addr, int *origin_count, int *origin_datatype_f, int *target_rank,
                   intptr_t *target_disp, int *target_count, int *target_datatype_f, int *win_f, int *ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(origin_addr, origin_datatype, "MPI_Put");
    *ierror = MPI_Put(VAPAA_MPI_RMA_ADDR(origin_addr), *origin_count, origin_datatype,
                      C_MPI_DEST_F2C(*target_rank), (MPI_Aint) *target_disp,
                      *target_count, target_datatype, win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Get(CFI_cdesc_t *origin_addr, int *origin_count, int *origin_datatype_f, int *target_rank,
                   intptr_t *target_disp, int *target_count, int *target_datatype_f, int *win_f, int *ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(origin_addr, origin_datatype, "MPI_Get");
    *ierror = MPI_Get(VAPAA_MPI_RMA_ADDR(origin_addr), *origin_count, origin_datatype,
                      C_MPI_DEST_F2C(*target_rank), (MPI_Aint) *target_disp,
                      *target_count, target_datatype, win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Accumulate(CFI_cdesc_t *origin_addr, int *origin_count, int *origin_datatype_f, int *target_rank,
                          intptr_t *target_disp, int *target_count, int *target_datatype_f, int *op_f, int *win_f,
                          int *ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(origin_addr, origin_datatype, "MPI_Accumulate");
    *ierror = MPI_Accumulate(VAPAA_MPI_RMA_ADDR(origin_addr), *origin_count, origin_datatype,
                             C_MPI_DEST_F2C(*target_rank), (MPI_Aint) *target_disp,
                             *target_count, target_datatype, op, win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Get_accumulate(CFI_cdesc_t *origin_addr, int *origin_count, int *origin_datatype_f,
                              CFI_cdesc_t *result_addr, int *result_count, int *result_datatype_f,
                              int *target_rank, intptr_t *target_disp, int *target_count,
                              int *target_datatype_f, int *op_f, int *win_f, int *ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype result_datatype = C_MPI_TYPE_FROMINT(*result_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(origin_addr, origin_datatype, "MPI_Get_accumulate");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(result_addr, result_datatype, "MPI_Get_accumulate");
    *ierror = MPI_Get_accumulate(VAPAA_MPI_RMA_ADDR(origin_addr), *origin_count, origin_datatype,
                                 VAPAA_MPI_RMA_ADDR(result_addr), *result_count, result_datatype,
                                 C_MPI_DEST_F2C(*target_rank), (MPI_Aint) *target_disp,
                                 *target_count, target_datatype, op, win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Rput(CFI_cdesc_t *origin_addr, int *origin_count, int *origin_datatype_f, int *target_rank,
                    intptr_t *target_disp, int *target_count, int *target_datatype_f, int *win_f,
                    int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(origin_addr, origin_datatype, "MPI_Rput");
    *ierror = MPI_Rput(VAPAA_MPI_RMA_ADDR(origin_addr), *origin_count, origin_datatype,
                       C_MPI_DEST_F2C(*target_rank), (MPI_Aint) *target_disp,
                       *target_count, target_datatype, win, &request);
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Rget(CFI_cdesc_t *origin_addr, int *origin_count, int *origin_datatype_f, int *target_rank,
                    intptr_t *target_disp, int *target_count, int *target_datatype_f, int *win_f,
                    int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(origin_addr, origin_datatype, "MPI_Rget");
    *ierror = MPI_Rget(VAPAA_MPI_RMA_ADDR(origin_addr), *origin_count, origin_datatype,
                       C_MPI_DEST_F2C(*target_rank), (MPI_Aint) *target_disp,
                       *target_count, target_datatype, win, &request);
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Raccumulate(CFI_cdesc_t *origin_addr, int *origin_count, int *origin_datatype_f, int *target_rank,
                           intptr_t *target_disp, int *target_count, int *target_datatype_f, int *op_f, int *win_f,
                           int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(origin_addr, origin_datatype, "MPI_Raccumulate");
    *ierror = MPI_Raccumulate(VAPAA_MPI_RMA_ADDR(origin_addr), *origin_count, origin_datatype,
                              C_MPI_DEST_F2C(*target_rank), (MPI_Aint) *target_disp,
                              *target_count, target_datatype, op, win, &request);
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Rget_accumulate(CFI_cdesc_t *origin_addr, int *origin_count, int *origin_datatype_f,
                               CFI_cdesc_t *result_addr, int *result_count, int *result_datatype_f,
                               int *target_rank, intptr_t *target_disp, int *target_count,
                               int *target_datatype_f, int *op_f, int *win_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype result_datatype = C_MPI_TYPE_FROMINT(*result_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(origin_addr, origin_datatype, "MPI_Rget_accumulate");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(result_addr, result_datatype, "MPI_Rget_accumulate");
    *ierror = MPI_Rget_accumulate(VAPAA_MPI_RMA_ADDR(origin_addr), *origin_count, origin_datatype,
                                  VAPAA_MPI_RMA_ADDR(result_addr), *result_count, result_datatype,
                                  C_MPI_DEST_F2C(*target_rank), (MPI_Aint) *target_disp,
                                  *target_count, target_datatype, op, win, &request);
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Compare_and_swap(CFI_cdesc_t *origin_addr, CFI_cdesc_t *compare_addr, CFI_cdesc_t *result_addr,
                                int *datatype_f, int *target_rank, intptr_t *target_disp, int *win_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(origin_addr, datatype, "MPI_Compare_and_swap");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(compare_addr, datatype, "MPI_Compare_and_swap");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(result_addr, datatype, "MPI_Compare_and_swap");
    *ierror = MPI_Compare_and_swap(VAPAA_MPI_RMA_ADDR(origin_addr), VAPAA_MPI_RMA_ADDR(compare_addr),
                                   VAPAA_MPI_RMA_ADDR(result_addr), datatype, C_MPI_DEST_F2C(*target_rank),
                                   (MPI_Aint) *target_disp, win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Fetch_and_op(CFI_cdesc_t *origin_addr, CFI_cdesc_t *result_addr, int *datatype_f,
                            int *target_rank, intptr_t *target_disp, int *op_f, int *win_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(origin_addr, datatype, "MPI_Fetch_and_op");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(result_addr, datatype, "MPI_Fetch_and_op");
    *ierror = MPI_Fetch_and_op(VAPAA_MPI_RMA_ADDR(origin_addr), VAPAA_MPI_RMA_ADDR(result_addr),
                               datatype, C_MPI_DEST_F2C(*target_rank), (MPI_Aint) *target_disp, op, win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_create(CFI_cdesc_t *base, intptr_t *size_f, int *disp_unit, int *info_f, int *comm_f, int *win_f, int *ierror)
{
    MPI_Win win = MPI_WIN_NULL;
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Win_create(base->base_addr, (MPI_Aint) *size_f, *disp_unit, info, comm, &win);
    if (*ierror == MPI_SUCCESS) VAPAA_MPI_CLEAR_WIN_NAME(win);
    *win_f = C_MPI_WIN_TOINT(win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_attach(int *win_f, CFI_cdesc_t *base, intptr_t *size_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_attach(win, base->base_addr, (MPI_Aint) *size_f);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_detach(int *win_f, CFI_cdesc_t *base, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_detach(win, base->base_addr);
    C_MPI_RC_FIX(*ierror);
}
#endif

void VAPAA_MPI_Win_create_dynamic(int *info_f, int *comm_f, int *win_f, int *ierror)
{
    MPI_Win win = MPI_WIN_NULL;
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Win_create_dynamic(info, comm, &win);
    if (*ierror == MPI_SUCCESS) VAPAA_MPI_CLEAR_WIN_NAME(win);
    *win_f = C_MPI_WIN_TOINT(win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_free(int *win_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_free(&win);
    *win_f = C_MPI_WIN_TOINT(win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_shared_query(int *win_f, int *rank, intptr_t *size_f, int *disp_unit, void **baseptr, int *ierror)
{
    MPI_Aint size = 0;
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_shared_query(win, *rank, &size, disp_unit, baseptr);
    *size_f = (intptr_t) size;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_shared_query_c(int *win_f, int *rank, intptr_t *size_f, intptr_t *disp_unit_f, void **baseptr, int *ierror)
{
    MPI_Aint size = 0;
    int disp_unit = 0;
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_shared_query(win, *rank, &size, &disp_unit, baseptr);
    *size_f = (intptr_t) size;
    *disp_unit_f = (intptr_t) disp_unit;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_get_group(int *win_f, int *group_f, int *ierror)
{
    MPI_Group group = MPI_GROUP_NULL;
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_get_group(win, &group);
    *group_f = C_MPI_GROUP_TOINT(group);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_get_info(int *win_f, int *info_f, int *ierror)
{
    MPI_Info info = MPI_INFO_NULL;
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_get_info(win, &info);
    *info_f = C_MPI_INFO_TOINT(info);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_set_info(int *win_f, int *info_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Win_set_info(win, info);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void VAPAA_MPI_Win_get_name(int *win_f, CFI_cdesc_t *name_d, int *resultlen, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_get_name(win, (char *) name_d->base_addr, resultlen);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_set_name(int *win_f, CFI_cdesc_t *name_d, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_set_name(win, (char *) name_d->base_addr);
    C_MPI_RC_FIX(*ierror);
}
#endif

void VAPAA_MPI_Win_delete_attr(int *win_f, int *keyval, int *ierror)
{
    void *attrval = NULL;
    int flag = 0;
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    int keyval_c = C_MPI_WIN_ATTR_GLOBAL_F2C(*keyval);
    (void) MPI_Win_get_attr(win, keyval_c, &attrval, &flag);
    *ierror = MPI_Win_delete_attr(win, keyval_c);
    if (*ierror == MPI_SUCCESS && flag) {
        VAPAA_MPI_Attr_forget(attrval);
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_free_keyval(int *keyval, int *ierror)
{
    *ierror = MPI_Win_free_keyval(keyval);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_get_attr(int *win_f, int *keyval, intptr_t *attrval_f, int *flag, int *ierror)
{
    void *attrval = NULL;
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    const int keyval_c = C_MPI_WIN_ATTR_GLOBAL_F2C(*keyval);
    *ierror = MPI_Win_get_attr(win, keyval_c, &attrval, flag);
    if (*ierror == MPI_SUCCESS && *flag && keyval_c == MPI_WIN_SIZE) {
        *attrval_f = attrval == NULL ? 0 : (intptr_t)*(MPI_Aint *)attrval;
    } else if (*ierror == MPI_SUCCESS && *flag && C_MPI_WIN_ATTR_GLOBAL_IS_PREDEFINED_VALUE(keyval_c)) {
        *attrval_f = attrval == NULL ? 0 : (intptr_t)*(int *)attrval;
    } else if (*ierror == MPI_SUCCESS && *flag && VAPAA_MPI_Attr_load_aint(attrval, attrval_f)) {
        /* Fortran-set attributes are stored as C-visible integer storage. */
    } else {
        *attrval_f = (intptr_t) attrval;
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_set_attr(int *win_f, int *keyval, intptr_t *attrval_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_set_attr(win, C_MPI_WIN_ATTR_GLOBAL_F2C(*keyval),
                               VAPAA_MPI_Attr_store_aint(*attrval_f));
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_fence(int *assert_f, int *win_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_fence(VAPAA_MPI_ASSERT_F2C(*assert_f), win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_start(int *group_f, int *assert_f, int *win_f, int *ierror)
{
    MPI_Group group = C_MPI_GROUP_FROMINT(*group_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_start(group, VAPAA_MPI_ASSERT_F2C(*assert_f), win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_complete(int *win_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_complete(win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_post(int *group_f, int *assert_f, int *win_f, int *ierror)
{
    MPI_Group group = C_MPI_GROUP_FROMINT(*group_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_post(group, VAPAA_MPI_ASSERT_F2C(*assert_f), win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_wait(int *win_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_wait(win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_test(int *win_f, int *flag, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_test(win, flag);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_lock(int *lock_type_f, int *rank, int *assert_f, int *win_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_lock(VAPAA_MPI_LOCK_F2C(*lock_type_f), *rank, VAPAA_MPI_ASSERT_F2C(*assert_f), win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_unlock(int *rank, int *win_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_unlock(*rank, win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_lock_all(int *assert_f, int *win_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_lock_all(VAPAA_MPI_ASSERT_F2C(*assert_f), win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_unlock_all(int *win_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_unlock_all(win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_flush(int *rank, int *win_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_flush(*rank, win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_flush_all(int *win_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_flush_all(win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_flush_local(int *rank, int *win_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_flush_local(*rank, win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_flush_local_all(int *win_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_flush_local_all(win);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_sync(int *win_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_sync(win);
    C_MPI_RC_FIX(*ierror);
}
