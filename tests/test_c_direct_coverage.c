// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

#include <mpi.h>

#include "ISO_Fortran_binding.h"
#include "cfi_util.h"
#include "convert_handles.h"
#include "vapaa_constants.h"
#include "vapaa_error_handling.h"

void C_MPI_Init(int *ierror);
void C_MPI_Finalize(int *ierror);
void C_MPI_Comm_rank(int *comm_f, int *rank, int *ierror);
void C_MPI_Comm_size(int *comm_f, int *size, int *ierror);
void C_MPI_Comm_set_errhandler(int *comm_f, int *errhandler_f, int *ierror);
void C_MPI_Initialized(int *flag, int *ierror);
void C_MPI_Finalized(int *flag, int *ierror);
void C_MPI_Query_thread(int *provided_f, int *ierror);
void C_MPI_Is_thread_main(int *flag, int *ierror);
void C_MPI_Get_version(int *version, int *subversion, int *ierror);
void C_MPI_Set_fortran_type_sizes(int *logical_size, int *integer_size,
                                  int *real_size, int *double_precision_size,
                                  int *ierror);
void C_MPI_Comm_group(int *comm_f, int *group_f, int *ierror);
void C_MPI_Group_free(int *group_f, int *ierror);
void C_MPI_Info_create(int *info_f, int *ierror);
void C_MPI_Info_free(int *info_f, int *ierror);
void C_MPI_Comm_set_name(int *comm_f, char *name, int *ierror);
void C_MPI_Comm_get_name(int *comm_f, char *name, int *resultlen, int *ierror);
void CFI_MPI_Comm_set_name(int *comm_f, CFI_cdesc_t *name_d, int *ierror);
void CFI_MPI_Comm_get_name(int *comm_f, CFI_cdesc_t *name_d, int *resultlen,
                           int *ierror);
void C_MPI_Win_set_name(int *win_f, char *name, int *ierror);
void C_MPI_Win_get_name(int *win_f, char *name, int *resultlen, int *ierror);
void CFI_MPI_Win_set_name(int *win_f, CFI_cdesc_t *name_d, int *ierror);
void CFI_MPI_Win_get_name(int *win_f, CFI_cdesc_t *name_d, int *resultlen,
                          int *ierror);
void CFI_MPI_Alltoall(CFI_cdesc_t *input, int *scount, int *stype_f,
                      CFI_cdesc_t *output, int *rcount, int *rtype_f,
                      int *comm_f, int *ierror);
void CFI_MPI_Allgatherv(CFI_cdesc_t *input, int *scount, int *stype_f,
                        CFI_cdesc_t *output, const int rcounts[],
                        const int rdisps[], int *rtype_f, int *comm_f,
                        int *ierror);
void CFI_MPI_Scatterv(CFI_cdesc_t *input, const int scounts[],
                      const int sdisps[], int *stype_f, CFI_cdesc_t *output,
                      int *rcount, int *rtype_f, int *root, int *comm_f,
                      int *ierror);

void C_MPI_Bcast(void *buffer, int count, int datatype_f, int root, int comm_f,
                 int *ierror);
void C_MPI_Reduce(const void *input, void *output, int *count, int *datatype_f,
                  int *op_f, int *root, int *comm_f, int *ierror);
void C_MPI_Allgatherv(const void *input, int *scount, int *stype_f,
                      void *output, const int rcounts[],
                      const int rdisps[], int *rtype_f, int *comm_f,
                      int *ierror);
void C_MPI_Scatterv(const void *input, const int scounts[],
                    const int sdisps[], int *stype_f, void *output,
                    int *rcount, int *rtype_f, int *root, int *comm_f,
                    int *ierror);
void VAPAA_MPI_Sendrecv_replace(CFI_cdesc_t *buf, int *count, int *datatype_f,
                                int *dest, int *sendtag, int *source,
                                int *recvtag, int *comm_f,
                                struct F_MPI_Status *status, int *ierror);
void VAPAA_MPI_Scan(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *count,
                    int *datatype_f, int *op_f, int *comm_f, int *ierror);
void VAPAA_MPI_Exscan(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *count,
                      int *datatype_f, int *op_f, int *comm_f, int *ierror);
void VAPAA_MPI_Reduce_scatter(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf,
                              const int recvcounts[], int *datatype_f,
                              int *op_f, int *comm_f, int *ierror);
void VAPAA_MPI_Reduce_scatter_block(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf,
                                    int *recvcount, int *datatype_f, int *op_f,
                                    int *comm_f, int *ierror);
void VAPAA_MPI_Reduce_local(CFI_cdesc_t *inbuf, CFI_cdesc_t *inoutbuf,
                            int *count, int *datatype_f, int *op_f,
                            int *ierror);
void VAPAA_MPI_Pack_external(const char datarep[], CFI_cdesc_t *inbuf,
                             int *incount, int *datatype_f, CFI_cdesc_t *outbuf,
                             intptr_t *outsize, intptr_t *position,
                             int *ierror);
void VAPAA_MPI_Unpack_external(const char datarep[], CFI_cdesc_t *inbuf,
                               intptr_t *insize, intptr_t *position,
                               CFI_cdesc_t *outbuf, int *outcount,
                               int *datatype_f, int *ierror);

void C_MPI_Send_c(void *buffer, int64_t count, int datatype_f, int dest,
                  int tag, int comm_f, int *ierror);
void CFI_MPI_Send_c(CFI_cdesc_t *desc, int64_t count, int datatype_f, int dest,
                    int tag, int comm_f, int *ierror);
void C_MPI_Recv_c(void *buffer, int64_t count, int datatype_f, int source,
                  int tag, int comm_f, struct F_MPI_Status *status,
                  int *ierror);
void CFI_MPI_Recv_c(CFI_cdesc_t *desc, int64_t count, int datatype_f,
                    int source, int tag, int comm_f, struct F_MPI_Status *status,
                    int *ierror);
void C_MPI_Ibsend(void *buffer, int count, int datatype_f, int dest, int tag,
                  int comm_f, int *request_f, int *ierror);
void C_MPI_Bsend_init(void *buffer, int count, int datatype_f, int dest,
                      int tag, int comm_f, int *request_f, int *ierror);
void CFI_MPI_Recv_init(CFI_cdesc_t *desc, int count, int datatype_f, int source,
                       int tag, int comm_f, int *request_f, int *ierror);
void CFI_MPI_Buffer_attach(CFI_cdesc_t *desc, int size, int *ierror);
void C_MPI_Buffer_flush(int *ierror);
void C_MPI_Buffer_iflush(int *request_f, int *ierror);
void C_MPI_Wait(int *request_f, struct F_MPI_Status *status, int *ierror);
void C_MPI_Request_free(int *request_f, int *ierror);
void CFI_MPI_Pack(CFI_cdesc_t *indesc, int incount, int datatype_f,
                  CFI_cdesc_t *outdesc, int outsize, int *position,
                  int comm_f, int *ierror);
void CFI_MPI_Unpack(CFI_cdesc_t *indesc, int insize, int *position,
                    CFI_cdesc_t *outdesc, int outcount, int datatype_f,
                    int comm_f, int *ierror);

void C_MPI_File_open(int *comm_f, char *filename, int *amode_f, int *info_f,
                     int *file_f, int *ierror);
void C_MPI_File_close(int *file_f, int *ierror);
void C_MPI_File_delete(char *filename, int *info_f, int *ierror);
void C_MPI_File_set_size(int *file_f, size_t *size_f, int *ierror);
void C_MPI_File_preallocate(int *file_f, size_t *size_f, int *ierror);
void C_MPI_File_get_size(int *file_f, size_t *size_f, int *ierror);
void C_MPI_File_set_view(int *file_f, int64_t *disp_f, int *etype_f,
                         int *filetype_f, char *datarep, int *info_f,
                         int *ierror);
void C_MPI_File_read_at(int *file_f, size_t *offset_f, void *buffer,
                        int *count_f, int *datatype_f, MPI_Status *status,
                        int *ierror);
void C_MPI_File_read_at_all(int *file_f, size_t *offset_f, void *buffer,
                            int *count_f, int *datatype_f,
                            MPI_Status *status, int *ierror);
void C_MPI_File_write_at(int *file_f, size_t *offset_f, void *buffer,
                         int *count_f, int *datatype_f, MPI_Status *status,
                         int *ierror);
void C_MPI_File_write_at_all(int *file_f, size_t *offset_f, void *buffer,
                             int *count_f, int *datatype_f,
                             MPI_Status *status, int *ierror);
void C_MPI_File_read(int *file_f, void *buffer, int *count_f,
                     int *datatype_f, MPI_Status *status, int *ierror);
void C_MPI_File_read_all(int *file_f, void *buffer, int *count_f,
                         int *datatype_f, MPI_Status *status, int *ierror);
void C_MPI_File_write(int *file_f, void *buffer, int *count_f,
                      int *datatype_f, MPI_Status *status, int *ierror);
void C_MPI_File_write_all(int *file_f, void *buffer, int *count_f,
                          int *datatype_f, MPI_Status *status, int *ierror);

void VAPAA_MPI_Comm_attach_buffer(int *comm_f, CFI_cdesc_t *buffer,
                                  int *size, int *ierror);
void VAPAA_MPI_Comm_attach_buffer_c(int *comm_f, CFI_cdesc_t *buffer,
                                    int64_t *size, int *ierror);
void VAPAA_MPI_Comm_detach_buffer(int *comm_f, void **buffer_addr,
                                  int *size, int *ierror);
void VAPAA_MPI_Comm_detach_buffer_c(int *comm_f, void **buffer_addr,
                                    int64_t *size_f, int *ierror);
void VAPAA_MPI_Comm_flush_buffer(int *comm_f, int *ierror);
void VAPAA_MPI_Comm_iflush_buffer(int *comm_f, int *request_f, int *ierror);
void VAPAA_MPI_Comm_create_from_group(int *group_f, CFI_cdesc_t *stringtag_d,
                                      int *info_f, int *errhandler_f,
                                      int *newcomm_f, int *ierror);
void VAPAA_MPI_Intercomm_create_from_groups(int *local_group_f,
                                            int *local_leader,
                                            int *remote_group_f,
                                            int *remote_leader,
                                            CFI_cdesc_t *stringtag_d,
                                            int *info_f, int *errhandler_f,
                                            int *newintercomm_f, int *ierror);
void VAPAA_MPI_Session_init(int *info_f, int *errhandler_f, int *session_f,
                            int *ierror);
void VAPAA_MPI_Session_finalize(int *session_f, int *ierror);
void VAPAA_MPI_Session_get_info(int *session_f, int *info_f, int *ierror);
void VAPAA_MPI_Session_get_num_psets(int *session_f, int *info_f,
                                     int *npset_names, int *ierror);
void VAPAA_MPI_Session_get_nth_pset(int *session_f, int *info_f, int *n,
                                    int *pset_len, CFI_cdesc_t *pset_name_d,
                                    int *ierror);
void VAPAA_MPI_Session_get_pset_info(int *session_f, CFI_cdesc_t *pset_name_d,
                                     int *info_f, int *ierror);
void VAPAA_MPI_Session_attach_buffer(int *session_f, CFI_cdesc_t *buffer,
                                     int *size, int *ierror);
void VAPAA_MPI_Session_attach_buffer_c(int *session_f, CFI_cdesc_t *buffer,
                                       int64_t *size, int *ierror);
void VAPAA_MPI_Session_detach_buffer(int *session_f, void **buffer_addr,
                                     int *size, int *ierror);
void VAPAA_MPI_Session_detach_buffer_c(int *session_f, void **buffer_addr,
                                       int64_t *size_f, int *ierror);
void VAPAA_MPI_Session_flush_buffer(int *session_f, int *ierror);
void VAPAA_MPI_Session_iflush_buffer(int *session_f, int *request_f,
                                     int *ierror);

void VAPAA_MPI_Win_allocate(intptr_t *size_f, int *disp_unit, int *info_f,
                            int *comm_f, void **baseptr, int *win_f,
                            int *ierror);
void VAPAA_MPI_Win_allocate_c(intptr_t *size_f, intptr_t *disp_unit_f,
                              int *info_f, int *comm_f, void **baseptr,
                              int *win_f, int *ierror);
void VAPAA_MPI_Win_allocate_shared(intptr_t *size_f, int *disp_unit,
                                   int *info_f, int *comm_f, void **baseptr,
                                   int *win_f, int *ierror);
void VAPAA_MPI_Win_allocate_shared_c(intptr_t *size_f,
                                     intptr_t *disp_unit_f, int *info_f,
                                     int *comm_f, void **baseptr,
                                     int *win_f, int *ierror);
void VAPAA_MPI_Win_create_nocfi(void *base, intptr_t *size_f, int *disp_unit,
                                int *info_f, int *comm_f, int *win_f,
                                int *ierror);
void VAPAA_MPI_Win_free(int *win_f, int *ierror);
void VAPAA_MPI_Win_lock(int *lock_type_f, int *rank, int *assert_f,
                        int *win_f, int *ierror);
void VAPAA_MPI_Win_unlock(int *rank, int *win_f, int *ierror);
void VAPAA_MPI_Win_shared_query(int *win_f, int *rank, intptr_t *size_f,
                                int *disp_unit, void **baseptr, int *ierror);
void VAPAA_MPI_Win_shared_query_c(int *win_f, int *rank, intptr_t *size_f,
                                  intptr_t *disp_unit_f, void **baseptr,
                                  int *ierror);
void VAPAA_MPI_Win_get_info(int *win_f, int *info_f, int *ierror);
void VAPAA_MPI_Win_set_info(int *win_f, int *info_f, int *ierror);
void VAPAA_MPI_Compare_and_swap(CFI_cdesc_t *origin_addr,
                                CFI_cdesc_t *compare_addr,
                                CFI_cdesc_t *result_addr, int *datatype_f,
                                int *target_rank, intptr_t *target_disp,
                                int *win_f, int *ierror);
void VAPAA_MPI_Fetch_and_op(CFI_cdesc_t *origin_addr, CFI_cdesc_t *result_addr,
                            int *datatype_f, int *target_rank,
                            intptr_t *target_disp, int *op_f, int *win_f,
                            int *ierror);

void VAPAA_MPI_Op_create_c(void (*fn)(void), int *commute, int *op_f,
                           int *ierror);
void VAPAA_MPI_Op_commutative(int *op_f, int *commute, int *ierror);

static int g_rank = 0;
static int g_errors = 0;

static void note_error(const char *label, int ierr)
{
    fprintf(stderr, "FAIL: %s rank=%d ierr=%d\n", label, g_rank, ierr);
    g_errors++;
}

static void check_success(int ierr, const char *label)
{
    if (ierr != MPI_SUCCESS) {
        note_error(label, ierr);
    }
}

static void check_success_or_unsupported(int ierr, const char *label)
{
    if (ierr == VAPAA_MPI_ERR_UNSUPPORTED_OPERATION) {
        return;
    }
#ifdef MPI_ERR_UNSUPPORTED_OPERATION
    if (ierr == MPI_ERR_UNSUPPORTED_OPERATION) {
        return;
    }
#endif
    check_success(ierr, label);
}

static void check_success_or_unavailable(int ierr, const char *label)
{
    if (ierr == VAPAA_MPI_ERR_UNSUPPORTED_OPERATION ||
        ierr == VAPAA_MPI_ERR_INTERN || ierr == VAPAA_MPI_ERR_COMM) {
        return;
    }
#ifdef MPI_ERR_UNSUPPORTED_OPERATION
    if (ierr == MPI_ERR_UNSUPPORTED_OPERATION) {
        return;
    }
#endif
    if (ierr == MPI_ERR_INTERN) {
        return;
    }
    if (ierr == MPI_ERR_COMM) {
        return;
    }
    check_success(ierr, label);
}

static void check_failure(int ierr, const char *label)
{
    if (ierr == MPI_SUCCESS) {
        note_error(label, ierr);
    }
}

static void set_cfi_1d(CFI_cdesc_t *desc, void *base, size_t elem_len,
                       CFI_type_t type, CFI_index_t extent,
                       CFI_index_t stride)
{
    memset(desc, 0, sizeof(CFI_CDESC_T(1)));
    desc->base_addr = base;
    desc->elem_len = elem_len;
    desc->version = CFI_VERSION;
    desc->rank = 1;
    desc->attribute = CFI_attribute_other;
    desc->type = type;
    desc->dim[0].lower_bound = 0;
    desc->dim[0].extent = extent;
    desc->dim[0].sm = stride;
}

static void wait_if_live(int *request_f, const char *label)
{
    int ierr = MPI_SUCCESS;
    struct F_MPI_Status status;

    memset(&status, 0, sizeof(status));
    if (*request_f == VAPAA_MPI_REQUEST_NULL) {
        return;
    }
    C_MPI_Wait(request_f, &status, &ierr);
    check_success(ierr, label);
}

static void free_request_if_live(int *request_f, const char *label)
{
    int ierr = MPI_SUCCESS;

    if (*request_f == VAPAA_MPI_REQUEST_NULL) {
        return;
    }
    C_MPI_Request_free(request_f, &ierr);
    check_success(ierr, label);
}

static void run_core_queries(void)
{
    int ierr = MPI_SUCCESS;
    int flag = 0;
    int provided = -1;
    int version = -1;
    int subversion = -1;
    int logical_size = (int)sizeof(int);
    int integer_size = (int)sizeof(int);
    int real_size = (int)sizeof(float);
    int double_precision_size = (int)sizeof(double);

    C_MPI_Initialized(&flag, &ierr);
    check_success(ierr, "C_MPI_Initialized");
    if (!flag) {
        note_error("C_MPI_Initialized flag", flag);
    }

    C_MPI_Finalized(&flag, &ierr);
    check_success(ierr, "C_MPI_Finalized");
    if (flag) {
        note_error("C_MPI_Finalized flag before finalize", flag);
    }

    C_MPI_Query_thread(&provided, &ierr);
    check_success(ierr, "C_MPI_Query_thread");
    C_MPI_Is_thread_main(&flag, &ierr);
    check_success(ierr, "C_MPI_Is_thread_main");
    C_MPI_Get_version(&version, &subversion, &ierr);
    check_success(ierr, "C_MPI_Get_version");
    if (version != 5 || subversion != 0) {
        note_error("C_MPI_Get_version value", version);
    }

    C_MPI_Set_fortran_type_sizes(&logical_size, &integer_size, &real_size,
                                 &double_precision_size, &ierr);
    check_success(ierr, "C_MPI_Set_fortran_type_sizes");
}

static void run_direct_misc_wrappers(void)
{
    int ierr = MPI_SUCCESS;
    int world = VAPAA_MPI_COMM_WORLD;
    int dtype = VAPAA_MPI_INTEGER;
    int op = VAPAA_MPI_SUM;
    int one = 1;
    int proc_null = VAPAA_MPI_PROC_NULL;
    int tag = 123;
    int send = g_rank + 1;
    int recv = -1;
    int block_recv = -1;
    int local_in = 3;
    int local_inout = 4;
    int replace_value = 19;
    int recvcounts[4] = {1, 1, 1, 1};
    int reduce_scatter_send[4] = {
        g_rank + 1, g_rank + 2, g_rank + 3, g_rank + 4
    };
    int reduce_scatter_recv = -1;
    int pack_in = 771 + g_rank;
    int pack_out = -1;
    char external_buffer[128] = {0};
    intptr_t external_size = (intptr_t)sizeof(external_buffer);
    intptr_t position = 0;
    intptr_t used = 0;
    struct F_MPI_Status status;
    CFI_CDESC_T(1) send_storage;
    CFI_CDESC_T(1) recv_storage;
    CFI_CDESC_T(1) block_recv_storage;
    CFI_CDESC_T(1) local_in_storage;
    CFI_CDESC_T(1) local_inout_storage;
    CFI_CDESC_T(1) replace_storage;
    CFI_CDESC_T(1) rs_send_storage;
    CFI_CDESC_T(1) rs_recv_storage;
    CFI_CDESC_T(1) pack_in_storage;
    CFI_CDESC_T(1) pack_out_storage;
    CFI_CDESC_T(1) external_storage;
    CFI_cdesc_t *send_desc = (CFI_cdesc_t *)&send_storage;
    CFI_cdesc_t *recv_desc = (CFI_cdesc_t *)&recv_storage;
    CFI_cdesc_t *block_recv_desc = (CFI_cdesc_t *)&block_recv_storage;
    CFI_cdesc_t *local_in_desc = (CFI_cdesc_t *)&local_in_storage;
    CFI_cdesc_t *local_inout_desc = (CFI_cdesc_t *)&local_inout_storage;
    CFI_cdesc_t *replace_desc = (CFI_cdesc_t *)&replace_storage;
    CFI_cdesc_t *rs_send_desc = (CFI_cdesc_t *)&rs_send_storage;
    CFI_cdesc_t *rs_recv_desc = (CFI_cdesc_t *)&rs_recv_storage;
    CFI_cdesc_t *pack_in_desc = (CFI_cdesc_t *)&pack_in_storage;
    CFI_cdesc_t *pack_out_desc = (CFI_cdesc_t *)&pack_out_storage;
    CFI_cdesc_t *external_desc = (CFI_cdesc_t *)&external_storage;

    memset(&status, 0, sizeof(status));
    set_cfi_1d(send_desc, &send, sizeof(int), CFI_type_int, 1, sizeof(int));
    set_cfi_1d(recv_desc, &recv, sizeof(int), CFI_type_int, 1, sizeof(int));
    set_cfi_1d(block_recv_desc, &block_recv, sizeof(int), CFI_type_int, 1,
               sizeof(int));
    set_cfi_1d(local_in_desc, &local_in, sizeof(int), CFI_type_int, 1,
               sizeof(int));
    set_cfi_1d(local_inout_desc, &local_inout, sizeof(int), CFI_type_int, 1,
               sizeof(int));
    set_cfi_1d(replace_desc, &replace_value, sizeof(int), CFI_type_int, 1,
               sizeof(int));
    set_cfi_1d(rs_send_desc, reduce_scatter_send, sizeof(int), CFI_type_int, 4,
               sizeof(int));
    set_cfi_1d(rs_recv_desc, &reduce_scatter_recv, sizeof(int), CFI_type_int, 1,
               sizeof(int));
    set_cfi_1d(pack_in_desc, &pack_in, sizeof(int), CFI_type_int, 1,
               sizeof(int));
    set_cfi_1d(pack_out_desc, &pack_out, sizeof(int), CFI_type_int, 1,
               sizeof(int));
    set_cfi_1d(external_desc, external_buffer, sizeof(char), CFI_type_char,
               (CFI_index_t)sizeof(external_buffer), sizeof(char));

    VAPAA_MPI_Sendrecv_replace(replace_desc, &one, &dtype, &proc_null, &tag,
                               &proc_null, &tag, &world, &status, &ierr);
    check_success(ierr, "VAPAA_MPI_Sendrecv_replace PROC_NULL");

    VAPAA_MPI_Scan(send_desc, recv_desc, &one, &dtype, &op, &world, &ierr);
    check_success(ierr, "VAPAA_MPI_Scan");
    VAPAA_MPI_Exscan(send_desc, recv_desc, &one, &dtype, &op, &world, &ierr);
    check_success(ierr, "VAPAA_MPI_Exscan");

    VAPAA_MPI_Reduce_scatter(rs_send_desc, rs_recv_desc, recvcounts, &dtype, &op,
                             &world, &ierr);
    check_success(ierr, "VAPAA_MPI_Reduce_scatter");
    VAPAA_MPI_Reduce_scatter_block(rs_send_desc, block_recv_desc, &one, &dtype,
                                   &op, &world, &ierr);
    check_success(ierr, "VAPAA_MPI_Reduce_scatter_block");

    VAPAA_MPI_Reduce_local(local_in_desc, local_inout_desc, &one, &dtype, &op,
                           &ierr);
    check_success(ierr, "VAPAA_MPI_Reduce_local");
    if (local_inout != 7) {
        note_error("VAPAA_MPI_Reduce_local payload", local_inout);
    }

    VAPAA_MPI_Pack_external("external32", pack_in_desc, &one, &dtype,
                            external_desc, &external_size, &position, &ierr);
    check_success(ierr, "VAPAA_MPI_Pack_external");
    used = position;
    position = 0;
    VAPAA_MPI_Unpack_external("external32", external_desc, &used, &position,
                              pack_out_desc, &one, &dtype, &ierr);
    check_success(ierr, "VAPAA_MPI_Unpack_external");
    if (pack_out != pack_in) {
        note_error("external32 roundtrip payload", pack_out);
    }
}

static void run_collectives(void)
{
    int ierr = MPI_SUCCESS;
    int world = VAPAA_MPI_COMM_WORLD;
    int dtype = VAPAA_MPI_INTEGER;
    int op = VAPAA_MPI_SUM;
    int root = 0;
    int one = 1;
    int send = g_rank + 1;
    int bcast_value = (g_rank == 0) ? 77 : -1;
    int reduced = -1;
    int gathered[4] = {-1, -1, -1, -1};
    int scattered = -1;
    int cfi_gathered[4] = {-1, -1, -1, -1};
    int cfi_scattered = -1;
    int counts[4] = {1, 1, 1, 1};
    int displs[4] = {0, 1, 2, 3};
    int sendv[4] = {11, 12, 13, 14};
    int cfi_sendv[4] = {21, 22, 23, 24};
    int alltoall_send[8] = {-1, -1, -1, -1, -1, -1, -1, -1};
    int alltoall_recv[8] = {-1, -1, -1, -1, -1, -1, -1, -1};
    CFI_CDESC_T(1) send_storage;
    CFI_CDESC_T(1) gather_storage;
    CFI_CDESC_T(1) scatter_in_storage;
    CFI_CDESC_T(1) scatter_out_storage;
    CFI_CDESC_T(1) alltoall_in_storage;
    CFI_CDESC_T(1) alltoall_out_storage;
    CFI_cdesc_t *send_desc = (CFI_cdesc_t *)&send_storage;
    CFI_cdesc_t *gather_desc = (CFI_cdesc_t *)&gather_storage;
    CFI_cdesc_t *scatter_in_desc = (CFI_cdesc_t *)&scatter_in_storage;
    CFI_cdesc_t *scatter_out_desc = (CFI_cdesc_t *)&scatter_out_storage;
    CFI_cdesc_t *alltoall_in_desc = (CFI_cdesc_t *)&alltoall_in_storage;
    CFI_cdesc_t *alltoall_out_desc = (CFI_cdesc_t *)&alltoall_out_storage;

    set_cfi_1d(send_desc, &send, sizeof(int), CFI_type_int, 1,
               sizeof(int));
    set_cfi_1d(gather_desc, cfi_gathered, sizeof(int), CFI_type_int, 4,
               sizeof(int));
    set_cfi_1d(scatter_in_desc, cfi_sendv, sizeof(int), CFI_type_int, 4,
               sizeof(int));
    set_cfi_1d(scatter_out_desc, &cfi_scattered, sizeof(int), CFI_type_int, 1,
               sizeof(int));
    for (int i = 0; i < 4; i++) {
        alltoall_send[2 * i] = g_rank * 100 + i;
    }
    set_cfi_1d(alltoall_in_desc, alltoall_send, sizeof(int), CFI_type_int, 4,
               2 * (CFI_index_t)sizeof(int));
    set_cfi_1d(alltoall_out_desc, alltoall_recv, sizeof(int), CFI_type_int, 4,
               2 * (CFI_index_t)sizeof(int));

    C_MPI_Bcast(&bcast_value, 1, dtype, root, world, &ierr);
    check_success(ierr, "C_MPI_Bcast");
    if (bcast_value != 77) {
        note_error("C_MPI_Bcast payload", bcast_value);
    }

    C_MPI_Reduce(&send, &reduced, &one, &dtype, &op, &root, &world, &ierr);
    check_success(ierr, "C_MPI_Reduce");

    C_MPI_Allgatherv(&send, &one, &dtype, gathered, counts, displs, &dtype,
                     &world, &ierr);
    check_success(ierr, "C_MPI_Allgatherv");

    C_MPI_Scatterv(sendv, counts, displs, &dtype, &scattered, &one, &dtype,
                   &root, &world, &ierr);
    check_success(ierr, "C_MPI_Scatterv");

    CFI_MPI_Allgatherv(send_desc, &one, &dtype, gather_desc, counts, displs,
                       &dtype, &world, &ierr);
    check_success(ierr, "CFI_MPI_Allgatherv");

    CFI_MPI_Scatterv(scatter_in_desc, counts, displs, &dtype,
                     scatter_out_desc, &one, &dtype, &root, &world, &ierr);
    check_success(ierr, "CFI_MPI_Scatterv");

    CFI_MPI_Alltoall(alltoall_in_desc, &one, &dtype, alltoall_out_desc, &one,
                     &dtype, &world, &ierr);
    check_success(ierr, "CFI_MPI_Alltoall noncontig");
    for (int i = 0; i < 4 && ierr == MPI_SUCCESS; i++) {
        if (alltoall_recv[2 * i] != i * 100 + g_rank) {
            note_error("CFI_MPI_Alltoall payload", alltoall_recv[2 * i]);
        }
    }
}

static void run_p2p_and_partitioned(void)
{
    int ierr = MPI_SUCCESS;
    int world = VAPAA_MPI_COMM_WORLD;
    int dtype = VAPAA_MPI_INTEGER;
    int req = VAPAA_MPI_REQUEST_NULL;
    int value = 5;
    int outsize = 64;
    int position = 0;
    int cfi_values[4] = {1, 2, 3, 4};
    int cfi_recv[4] = {-1, -1, -1, -1};
    int pack_position = 0;
    int pack_source = 11;
    char pack_bytes[64] = {0};
    struct F_MPI_Status status;
    CFI_CDESC_T(1) cfi_contig_storage;
    CFI_CDESC_T(1) cfi_noncontig_storage;
    CFI_CDESC_T(1) cfi_recv_storage;
    CFI_CDESC_T(1) cfi_pack_source_storage;
    CFI_CDESC_T(1) cfi_pack_contig_storage;
    CFI_CDESC_T(1) cfi_pack_noncontig_storage;
    CFI_cdesc_t *cfi_contig = (CFI_cdesc_t *)&cfi_contig_storage;
    CFI_cdesc_t *cfi_noncontig = (CFI_cdesc_t *)&cfi_noncontig_storage;
    CFI_cdesc_t *cfi_recv_desc = (CFI_cdesc_t *)&cfi_recv_storage;
    CFI_cdesc_t *cfi_pack_source = (CFI_cdesc_t *)&cfi_pack_source_storage;
    CFI_cdesc_t *cfi_pack_contig = (CFI_cdesc_t *)&cfi_pack_contig_storage;
    CFI_cdesc_t *cfi_pack_noncontig = (CFI_cdesc_t *)&cfi_pack_noncontig_storage;

    memset(&status, 0, sizeof(status));
    set_cfi_1d(cfi_contig, cfi_values, sizeof(int), CFI_type_int, 2,
               sizeof(int));
    set_cfi_1d(cfi_noncontig, cfi_values, sizeof(int), CFI_type_int, 2,
               2 * (CFI_index_t)sizeof(int));
    set_cfi_1d(cfi_recv_desc, cfi_recv, sizeof(int), CFI_type_int, 2,
               2 * (CFI_index_t)sizeof(int));
    set_cfi_1d(cfi_pack_source, &pack_source, sizeof(int), CFI_type_int, 1,
               sizeof(int));
    set_cfi_1d(cfi_pack_contig, pack_bytes, sizeof(char), CFI_type_char,
               (CFI_index_t)sizeof(pack_bytes), sizeof(char));
    set_cfi_1d(cfi_pack_noncontig, pack_bytes, sizeof(char), CFI_type_char,
               8, 2);

    C_MPI_Send_c(&value, 1, dtype, VAPAA_MPI_PROC_NULL, 10, world, &ierr);
    check_success(ierr, "C_MPI_Send_c PROC_NULL");
    C_MPI_Recv_c(&value, 1, dtype, VAPAA_MPI_PROC_NULL, 10, world, &status,
                 &ierr);
    check_success(ierr, "C_MPI_Recv_c PROC_NULL");
    C_MPI_Send_c(&value, -1, dtype, VAPAA_MPI_PROC_NULL, 10, world, &ierr);
    check_failure(ierr, "C_MPI_Send_c negative count");
    C_MPI_Recv_c(&value, -1, dtype, VAPAA_MPI_PROC_NULL, 10, world, &status,
                 &ierr);
    check_failure(ierr, "C_MPI_Recv_c negative count");
    CFI_MPI_Send_c(cfi_contig, -1, dtype, VAPAA_MPI_PROC_NULL, 10, world,
                   &ierr);
    check_failure(ierr, "CFI_MPI_Send_c negative count");
    CFI_MPI_Recv_c(cfi_contig, -1, dtype, VAPAA_MPI_PROC_NULL, 10, world,
                   &status, &ierr);
    check_failure(ierr, "CFI_MPI_Recv_c negative count");
    CFI_MPI_Send_c(cfi_noncontig, (int64_t)INT_MAX + 1, dtype,
                   VAPAA_MPI_PROC_NULL, 10, world, &ierr);
    check_failure(ierr, "CFI_MPI_Send_c large noncontig count");
    CFI_MPI_Recv_c(cfi_noncontig, (int64_t)INT_MAX + 1, dtype,
                   VAPAA_MPI_PROC_NULL, 10, world, &status, &ierr);
    check_failure(ierr, "CFI_MPI_Recv_c large noncontig count");
    CFI_MPI_Recv_c(cfi_recv_desc, 2, dtype, VAPAA_MPI_PROC_NULL, 10, world,
                   &status, &ierr);
    check_success(ierr, "CFI_MPI_Recv_c noncontig PROC_NULL");

    C_MPI_Ibsend(&value, 1, dtype, VAPAA_MPI_PROC_NULL, 11, world, &req,
                 &ierr);
    check_success(ierr, "C_MPI_Ibsend PROC_NULL");
    wait_if_live(&req, "C_MPI_Ibsend wait");

    C_MPI_Bsend_init(&value, 1, dtype, VAPAA_MPI_PROC_NULL, 12, world, &req,
                     &ierr);
    check_success(ierr, "C_MPI_Bsend_init PROC_NULL");
    free_request_if_live(&req, "C_MPI_Bsend_init free");
    CFI_MPI_Recv_init(cfi_recv_desc, 2, dtype, VAPAA_MPI_PROC_NULL, 12, world,
                      &req, &ierr);
    check_success(ierr, "CFI_MPI_Recv_init noncontig PROC_NULL");
    free_request_if_live(&req, "CFI_MPI_Recv_init free");

    CFI_MPI_Buffer_attach(cfi_noncontig, 64, &ierr);
    check_failure(ierr, "CFI_MPI_Buffer_attach noncontig");
    CFI_MPI_Pack(cfi_pack_source, 1, dtype, cfi_pack_noncontig, outsize,
                 &pack_position, world, &ierr);
    check_failure(ierr, "CFI_MPI_Pack noncontig output");
    CFI_MPI_Unpack(cfi_pack_noncontig, outsize, &position, cfi_contig, 1,
                   dtype, world, &ierr);
    check_failure(ierr, "CFI_MPI_Unpack noncontig input");
    CFI_MPI_Unpack(cfi_pack_contig, 0, &position, cfi_recv_desc, 2, dtype,
                   world, &ierr);
    check_success(ierr, "CFI_MPI_Unpack noncontig output empty");

    C_MPI_Buffer_flush(&ierr);
    check_success_or_unsupported(ierr, "C_MPI_Buffer_flush");
    C_MPI_Buffer_iflush(&req, &ierr);
    check_success_or_unsupported(ierr, "C_MPI_Buffer_iflush");
    wait_if_live(&req, "C_MPI_Buffer_iflush wait");
}

static void run_file_wrappers(void)
{
    int ierr = MPI_SUCCESS;
    int self = VAPAA_MPI_COMM_SELF;
    int info = VAPAA_MPI_INFO_NULL;
    int dtype = VAPAA_MPI_INTEGER;
    int file = VAPAA_MPI_FILE_NULL;
    int count = 4;
    int amode = VAPAA_MPI_MODE_CREATE | VAPAA_MPI_MODE_RDWR |
                VAPAA_MPI_MODE_DELETE_ON_CLOSE;
    int buf[4] = {g_rank + 10, g_rank + 20, g_rank + 30, g_rank + 40};
    int got[4] = {-1, -1, -1, -1};
    size_t offset = 0;
    size_t file_size = 128;
    int64_t disp = 0;
    MPI_Status status;
    char filename[128];
    char delete_name[128];
    FILE *fp = NULL;

    snprintf(filename, sizeof(filename), "c_direct_%d.dat", g_rank);
    C_MPI_File_open(&self, filename, &amode, &info, &file, &ierr);
    check_success(ierr, "C_MPI_File_open");
    if (ierr != MPI_SUCCESS) {
        return;
    }

    C_MPI_File_preallocate(&file, &file_size, &ierr);
    check_success(ierr, "C_MPI_File_preallocate");
    C_MPI_File_set_size(&file, &file_size, &ierr);
    check_success(ierr, "C_MPI_File_set_size");
    C_MPI_File_get_size(&file, &file_size, &ierr);
    check_success(ierr, "C_MPI_File_get_size");
    C_MPI_File_set_view(&file, &disp, &dtype, &dtype, "native", &info, &ierr);
    check_success(ierr, "C_MPI_File_set_view");

    C_MPI_File_write_at(&file, &offset, buf, &count, &dtype, &status, &ierr);
    check_success(ierr, "C_MPI_File_write_at");
    C_MPI_File_read_at(&file, &offset, got, &count, &dtype, &status, &ierr);
    check_success(ierr, "C_MPI_File_read_at");

    C_MPI_File_write_at_all(&file, &offset, buf, &count, &dtype, &status,
                            &ierr);
    check_success(ierr, "C_MPI_File_write_at_all");
    C_MPI_File_read_at_all(&file, &offset, got, &count, &dtype, &status,
                           &ierr);
    check_success(ierr, "C_MPI_File_read_at_all");

    MPI_File_seek(C_MPI_FILE_FROMINT(file), 0, MPI_SEEK_SET);
    C_MPI_File_write(&file, buf, &count, &dtype, &status, &ierr);
    check_success(ierr, "C_MPI_File_write");
    MPI_File_seek(C_MPI_FILE_FROMINT(file), 0, MPI_SEEK_SET);
    C_MPI_File_read(&file, got, &count, &dtype, &status, &ierr);
    check_success(ierr, "C_MPI_File_read");

    MPI_File_seek(C_MPI_FILE_FROMINT(file), 0, MPI_SEEK_SET);
    C_MPI_File_write_all(&file, buf, &count, &dtype, &status, &ierr);
    check_success(ierr, "C_MPI_File_write_all");
    MPI_File_seek(C_MPI_FILE_FROMINT(file), 0, MPI_SEEK_SET);
    C_MPI_File_read_all(&file, got, &count, &dtype, &status, &ierr);
    check_success(ierr, "C_MPI_File_read_all");

    C_MPI_File_close(&file, &ierr);
    check_success(ierr, "C_MPI_File_close");

    snprintf(delete_name, sizeof(delete_name), "c_direct_delete_%d.dat",
             g_rank);
    fp = fopen(delete_name, "w");
    if (fp != NULL) {
        fclose(fp);
        C_MPI_File_delete(delete_name, &info, &ierr);
        check_success(ierr, "C_MPI_File_delete");
    } else {
        note_error("fopen delete target", 1);
    }
}

static void run_direct_comm_wrappers(void)
{
    int ierr = MPI_SUCCESS;
    int self = VAPAA_MPI_COMM_SELF;
    int info = VAPAA_MPI_INFO_NULL;
    int errhandler = VAPAA_MPI_ERRORS_RETURN;
    int group = VAPAA_MPI_GROUP_NULL;
    int newcomm = VAPAA_MPI_COMM_NULL;
    int session = VAPAA_MPI_SESSION_NULL;
    int req = VAPAA_MPI_REQUEST_NULL;
    int size = 1024;
    int npsets = -1;
    int nth = 0;
    int pset_len = VAPAA_MPI_MAX_PSET_NAME_LEN;
    int leader = 0;
    int buffer[256] = {0};
    int64_t csize = sizeof(buffer);
    void *detached = NULL;
    char tag[] = "c-direct-group";
    char pset[VAPAA_MPI_MAX_PSET_NAME_LEN] = {0};
    CFI_CDESC_T(1) tag_storage;
    CFI_CDESC_T(1) pset_storage;
    CFI_CDESC_T(1) buffer_storage;
    CFI_cdesc_t *tag_desc = (CFI_cdesc_t *)&tag_storage;
    CFI_cdesc_t *pset_desc = (CFI_cdesc_t *)&pset_storage;
    CFI_cdesc_t *buffer_desc = (CFI_cdesc_t *)&buffer_storage;

    set_cfi_1d(tag_desc, tag, sizeof(char), CFI_type_char,
               (CFI_index_t)strlen(tag) + 1, sizeof(char));
    set_cfi_1d(pset_desc, pset, sizeof(char), CFI_type_char,
               VAPAA_MPI_MAX_PSET_NAME_LEN, sizeof(char));
    set_cfi_1d(buffer_desc, buffer, sizeof(int), CFI_type_int, 256,
               sizeof(int));

    C_MPI_Comm_group(&self, &group, &ierr);
    check_success(ierr, "C_MPI_Comm_group self");

    VAPAA_MPI_Comm_create_from_group(&group, tag_desc, &info, &errhandler,
                                     &newcomm, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Comm_create_from_group");
    VAPAA_MPI_Intercomm_create_from_groups(&group, &leader, &group, &leader,
                                           tag_desc, &info, &errhandler,
                                           &newcomm, &ierr);
    check_success_or_unavailable(ierr,
                                 "VAPAA_MPI_Intercomm_create_from_groups");

    VAPAA_MPI_Comm_attach_buffer(&self, buffer_desc, &size, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Comm_attach_buffer");
    VAPAA_MPI_Comm_flush_buffer(&self, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Comm_flush_buffer");
    VAPAA_MPI_Comm_iflush_buffer(&self, &req, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Comm_iflush_buffer");
    wait_if_live(&req, "VAPAA_MPI_Comm_iflush_buffer wait");
    VAPAA_MPI_Comm_detach_buffer(&self, &detached, &size, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Comm_detach_buffer");

    detached = NULL;
    VAPAA_MPI_Comm_attach_buffer_c(&self, buffer_desc, &csize, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Comm_attach_buffer_c");
    VAPAA_MPI_Comm_flush_buffer(&self, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Comm_flush_buffer c");
    VAPAA_MPI_Comm_detach_buffer_c(&self, &detached, &csize, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Comm_detach_buffer_c");

    VAPAA_MPI_Session_init(&info, &errhandler, &session, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Session_init");
    VAPAA_MPI_Session_get_info(&session, &info, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Session_get_info");
    VAPAA_MPI_Session_get_num_psets(&session, &info, &npsets, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Session_get_num_psets");
    VAPAA_MPI_Session_get_nth_pset(&session, &info, &nth, &pset_len,
                                   pset_desc, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Session_get_nth_pset");
    VAPAA_MPI_Session_get_pset_info(&session, pset_desc, &info, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Session_get_pset_info");
    VAPAA_MPI_Session_attach_buffer(&session, buffer_desc, &size, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Session_attach_buffer");
    VAPAA_MPI_Session_flush_buffer(&session, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Session_flush_buffer");
    VAPAA_MPI_Session_iflush_buffer(&session, &req, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Session_iflush_buffer");
    wait_if_live(&req, "VAPAA_MPI_Session_iflush_buffer wait");
    VAPAA_MPI_Session_detach_buffer(&session, &detached, &size, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Session_detach_buffer");

    detached = NULL;
    VAPAA_MPI_Session_attach_buffer_c(&session, buffer_desc, &csize, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Session_attach_buffer_c");
    VAPAA_MPI_Session_flush_buffer(&session, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Session_flush_buffer c");
    VAPAA_MPI_Session_detach_buffer_c(&session, &detached, &csize, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Session_detach_buffer_c");
    VAPAA_MPI_Session_finalize(&session, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Session_finalize");

    C_MPI_Group_free(&group, &ierr);
    check_success(ierr, "C_MPI_Group_free self");
}

static void run_direct_win_wrappers(void)
{
    int ierr = MPI_SUCCESS;
    int self = VAPAA_MPI_COMM_SELF;
    int info = VAPAA_MPI_INFO_NULL;
    int dtype = VAPAA_MPI_INTEGER;
    int op = VAPAA_MPI_REPLACE;
    int lock = VAPAA_MPI_LOCK_EXCLUSIVE;
    int zero = 0;
    int disp_unit = sizeof(int);
    int win = VAPAA_MPI_WIN_NULL;
    int win2 = VAPAA_MPI_WIN_NULL;
    int win3 = VAPAA_MPI_WIN_NULL;
    int rank = 0;
    int resultlen = 0;
    int info_out = VAPAA_MPI_INFO_NULL;
    int basebuf[4] = {0, 0, 0, 0};
    int origin = 7;
    int compare = 0;
    int result = -1;
    intptr_t size = sizeof(basebuf);
    intptr_t zero_disp = 0;
    intptr_t c_disp_unit = sizeof(int);
    void *baseptr = NULL;
    void *queryptr = NULL;
    char name[] = "c-direct-win";
    char got_name[VAPAA_MPI_MAX_OBJECT_NAME] = {0};
    CFI_CDESC_T(1) origin_storage;
    CFI_CDESC_T(1) compare_storage;
    CFI_CDESC_T(1) result_storage;
    CFI_CDESC_T(1) name_storage;
    CFI_cdesc_t *origin_desc = (CFI_cdesc_t *)&origin_storage;
    CFI_cdesc_t *compare_desc = (CFI_cdesc_t *)&compare_storage;
    CFI_cdesc_t *result_desc = (CFI_cdesc_t *)&result_storage;
    CFI_cdesc_t *name_desc = (CFI_cdesc_t *)&name_storage;

    set_cfi_1d(origin_desc, &origin, sizeof(int), CFI_type_int, 1,
               sizeof(int));
    set_cfi_1d(compare_desc, &compare, sizeof(int), CFI_type_int, 1,
               sizeof(int));
    set_cfi_1d(result_desc, &result, sizeof(int), CFI_type_int, 1,
               sizeof(int));
    set_cfi_1d(name_desc, name, sizeof(char), CFI_type_char,
               (CFI_index_t)strlen(name) + 1, sizeof(char));

    C_MPI_Info_create(&info, &ierr);
    check_success(ierr, "C_MPI_Info_create win info");

    VAPAA_MPI_Win_allocate(&size, &disp_unit, &info, &self, &baseptr, &win,
                           &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Win_allocate");
    if (ierr == MPI_SUCCESS) {
        VAPAA_MPI_Win_set_info(&win, &info, &ierr);
        check_success(ierr, "VAPAA_MPI_Win_set_info allocated");
        VAPAA_MPI_Win_get_info(&win, &info_out, &ierr);
        check_success(ierr, "VAPAA_MPI_Win_get_info allocated");
        C_MPI_Info_free(&info_out, &ierr);
        check_success(ierr, "C_MPI_Info_free win info_out");
        VAPAA_MPI_Win_free(&win, &ierr);
        check_success(ierr, "VAPAA_MPI_Win_free allocated");
    }

    VAPAA_MPI_Win_allocate_c(&size, &c_disp_unit, &info, &self, &baseptr,
                             &win, &ierr);
    check_success_or_unsupported(ierr, "VAPAA_MPI_Win_allocate_c");
    if (ierr == MPI_SUCCESS) {
        VAPAA_MPI_Win_free(&win, &ierr);
        check_success(ierr, "VAPAA_MPI_Win_free allocate_c");
    }

    VAPAA_MPI_Win_allocate_shared(&size, &disp_unit, &info, &self, &baseptr,
                                  &win2, &ierr);
    check_success_or_unavailable(ierr, "VAPAA_MPI_Win_allocate_shared");
    if (ierr == MPI_SUCCESS) {
        VAPAA_MPI_Win_shared_query(&win2, &rank, &size, &disp_unit,
                                   &queryptr, &ierr);
        check_success(ierr, "VAPAA_MPI_Win_shared_query");
        VAPAA_MPI_Win_free(&win2, &ierr);
        check_success(ierr, "VAPAA_MPI_Win_free shared");
    }

    VAPAA_MPI_Win_allocate_shared_c(&size, &c_disp_unit, &info, &self,
                                    &baseptr, &win2, &ierr);
    check_success_or_unavailable(ierr, "VAPAA_MPI_Win_allocate_shared_c");
    if (ierr == MPI_SUCCESS) {
        VAPAA_MPI_Win_shared_query_c(&win2, &rank, &size, &c_disp_unit,
                                     &queryptr, &ierr);
        check_success(ierr, "VAPAA_MPI_Win_shared_query_c");
        VAPAA_MPI_Win_free(&win2, &ierr);
        check_success(ierr, "VAPAA_MPI_Win_free shared_c");
    }

    VAPAA_MPI_Win_create_nocfi(basebuf, &size, &disp_unit, &info, &self,
                               &win3, &ierr);
    check_success(ierr, "VAPAA_MPI_Win_create_nocfi");
    if (ierr == MPI_SUCCESS) {
        C_MPI_Win_set_name(&win3, name, &ierr);
        check_success(ierr, "C_MPI_Win_set_name");
        C_MPI_Win_get_name(&win3, got_name, &resultlen, &ierr);
        check_success(ierr, "C_MPI_Win_get_name");
        CFI_MPI_Win_set_name(&win3, name_desc, &ierr);
        check_success(ierr, "CFI_MPI_Win_set_name");
        memset(got_name, 0, sizeof(got_name));
        set_cfi_1d(name_desc, got_name, sizeof(char), CFI_type_char,
                   VAPAA_MPI_MAX_OBJECT_NAME, sizeof(char));
        CFI_MPI_Win_get_name(&win3, name_desc, &resultlen, &ierr);
        check_success(ierr, "CFI_MPI_Win_get_name");

        VAPAA_MPI_Win_lock(&lock, &zero, &zero, &win3, &ierr);
        check_success(ierr, "VAPAA_MPI_Win_lock");
        VAPAA_MPI_Compare_and_swap(origin_desc, compare_desc, result_desc,
                                   &dtype, &zero, &zero_disp, &win3, &ierr);
        check_success(ierr, "VAPAA_MPI_Compare_and_swap");
        VAPAA_MPI_Fetch_and_op(origin_desc, result_desc, &dtype, &zero,
                               &zero_disp, &op, &win3, &ierr);
        check_success(ierr, "VAPAA_MPI_Fetch_and_op");
        VAPAA_MPI_Win_unlock(&zero, &win3, &ierr);
        check_success(ierr, "VAPAA_MPI_Win_unlock");
        VAPAA_MPI_Win_free(&win3, &ierr);
        check_success(ierr, "VAPAA_MPI_Win_free nocfi");
    }

    C_MPI_Info_free(&info, &ierr);
    check_success(ierr, "C_MPI_Info_free win info");
}

static void run_names_and_callbacks(void)
{
    int ierr = MPI_SUCCESS;
    int self = VAPAA_MPI_COMM_SELF;
    int errhandler = VAPAA_MPI_ERRORS_RETURN;
    int op = VAPAA_MPI_OP_NULL;
    int commute = 0;
    int resultlen = 0;
    char name[] = "c-direct-comm";
    char got_name[VAPAA_MPI_MAX_OBJECT_NAME] = {0};
    CFI_CDESC_T(1) name_storage;
    CFI_cdesc_t *name_desc = (CFI_cdesc_t *)&name_storage;

    C_MPI_Comm_set_errhandler(&self, &errhandler, &ierr);
    check_success(ierr, "C_MPI_Comm_set_errhandler self again");
    C_MPI_Comm_set_name(&self, name, &ierr);
    check_success(ierr, "C_MPI_Comm_set_name");
    C_MPI_Comm_get_name(&self, got_name, &resultlen, &ierr);
    check_success(ierr, "C_MPI_Comm_get_name");

    set_cfi_1d(name_desc, name, sizeof(char), CFI_type_char,
               (CFI_index_t)strlen(name) + 1, sizeof(char));
    CFI_MPI_Comm_set_name(&self, name_desc, &ierr);
    check_success(ierr, "CFI_MPI_Comm_set_name");
    memset(got_name, 0, sizeof(got_name));
    set_cfi_1d(name_desc, got_name, sizeof(char), CFI_type_char,
               VAPAA_MPI_MAX_OBJECT_NAME, sizeof(char));
    CFI_MPI_Comm_get_name(&self, name_desc, &resultlen, &ierr);
    check_success(ierr, "CFI_MPI_Comm_get_name");

    VAPAA_MPI_Op_create_c(NULL, &commute, &op, &ierr);
    check_failure(ierr, "VAPAA_MPI_Op_create_c null callback");
    op = VAPAA_MPI_SUM;
    VAPAA_MPI_Op_commutative(&op, &commute, &ierr);
    check_success(ierr, "VAPAA_MPI_Op_commutative");
}

static void run_synthetic_error_helpers(void)
{
    int ierr = MPI_SUCCESS;
    int err = MPI_SUCCESS;
    int self = VAPAA_MPI_COMM_SELF;
    MPI_File file = MPI_FILE_NULL;
    MPI_Win win = MPI_WIN_NULL;
    int winbuf[2] = {0, 0};
    char filename[128];

    VAPAA_MPI_note_comm_errhandler_set();
    VAPAA_MPI_note_file_errhandler_set();
    VAPAA_MPI_note_win_errhandler_set();
    VAPAA_MPI_note_session_errhandler_set();

    VAPAA_MPI_handle_synthetic_error_no_object(&err);
    VAPAA_MPI_handle_synthetic_error_comm(MPI_COMM_SELF, &err);
    C_MPI_Fatal_if_missing_ierror(&err);

    err = MPI_ERR_OTHER;
    VAPAA_MPI_handle_synthetic_error_no_object(&err);
    err = MPI_ERR_OTHER;
    VAPAA_MPI_handle_synthetic_error_comm(MPI_COMM_SELF, &err);

    snprintf(filename, sizeof(filename), "c_direct_error_%d.dat", g_rank);
    ierr = MPI_File_open(MPI_COMM_SELF, filename,
                         MPI_MODE_CREATE | MPI_MODE_RDWR |
                             MPI_MODE_DELETE_ON_CLOSE,
                         MPI_INFO_NULL, &file);
    check_success(ierr, "native MPI_File_open synthetic error");
    if (ierr == MPI_SUCCESS) {
        ierr = MPI_File_set_errhandler(file, MPI_ERRORS_RETURN);
        check_success(ierr, "native MPI_File_set_errhandler synthetic error");
        err = MPI_SUCCESS;
        VAPAA_MPI_handle_synthetic_error_file(file, &err);
        err = MPI_ERR_OTHER;
        VAPAA_MPI_handle_synthetic_error_file(file, &err);
        ierr = MPI_File_close(&file);
        check_success(ierr, "native MPI_File_close synthetic error");
    }

    ierr = MPI_Win_create(winbuf, sizeof(winbuf), sizeof(int), MPI_INFO_NULL,
                          MPI_COMM_SELF, &win);
    check_success(ierr, "native MPI_Win_create synthetic error");
    if (ierr == MPI_SUCCESS) {
        ierr = MPI_Win_set_errhandler(win, MPI_ERRORS_RETURN);
        check_success(ierr, "native MPI_Win_set_errhandler synthetic error");
        err = MPI_SUCCESS;
        VAPAA_MPI_handle_synthetic_error_win(win, &err);
        err = MPI_ERR_OTHER;
        VAPAA_MPI_handle_synthetic_error_win(win, &err);
        ierr = MPI_Win_free(&win);
        check_success(ierr, "native MPI_Win_free synthetic error");
    }

#if MPI_VERSION < 4
    err = MPI_SUCCESS;
    VAPAA_MPI_handle_synthetic_error_session_null(&err);
#endif

    (void)self;
}

int main(void)
{
    int ierr = MPI_SUCCESS;
    int world = VAPAA_MPI_COMM_WORLD;
    int self = VAPAA_MPI_COMM_SELF;
    int errhandler = VAPAA_MPI_ERRORS_RETURN;
    int nranks = 0;

    C_MPI_Init(&ierr);
    check_success(ierr, "C_MPI_Init");
    C_MPI_Comm_rank(&world, &g_rank, &ierr);
    check_success(ierr, "C_MPI_Comm_rank");
    C_MPI_Comm_size(&world, &nranks, &ierr);
    check_success(ierr, "C_MPI_Comm_size");

    C_MPI_Comm_set_errhandler(&world, &errhandler, &ierr);
    check_success(ierr, "C_MPI_Comm_set_errhandler world");
    C_MPI_Comm_set_errhandler(&self, &errhandler, &ierr);
    check_success(ierr, "C_MPI_Comm_set_errhandler self");

    run_core_queries();
    run_collectives();
    run_direct_misc_wrappers();
    run_p2p_and_partitioned();
    run_file_wrappers();
    run_direct_comm_wrappers();
    run_direct_win_wrappers();
    run_names_and_callbacks();
    run_synthetic_error_helpers();

    C_MPI_Finalize(&ierr);
    check_success(ierr, "C_MPI_Finalize");

    if (g_errors == 0) {
        if (g_rank == 0) {
            printf("Test passed\n");
        }
        return 0;
    }

    fprintf(stderr, "Test failed with %d errors on rank %d\n", g_errors,
            g_rank);
    return 1;
}
