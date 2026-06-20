// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <mpi.h>

#include "convert_handles.h"
#include "vapaa_constants.h"
#include "vapaa_error_handling.h"

typedef void (*vapaa_c_funptr)(void);

void mpi_init_(int *ierror);
void mpi_finalize_(int *ierror);
void mpi_comm_rank_(int *comm, int *rank, int *ierror);
void mpi_comm_size_(int *comm, int *size, int *ierror);
void mpi_comm_dup_(int *comm, int *newcomm, int *ierror);
void mpi_comm_free_(int *comm, int *ierror);
void mpi_comm_group_(int *comm, int *group, int *ierror);
void mpi_comm_create_(int *comm, int *group, int *newcomm, int *ierror);
void mpi_comm_create_group_(int *comm, int *group, int *tag, int *newcomm,
                            int *ierror);
void mpi_comm_dup_with_info_(int *comm, int *info, int *newcomm, int *ierror);
void mpi_comm_get_info_(int *comm, int *info, int *ierror);
void mpi_comm_get_parent_(int *parent, int *ierror);
void mpi_comm_idup_(int *comm, int *newcomm, int *request, int *ierror);
void mpi_comm_idup_with_info_(int *comm, int *info, int *newcomm,
                              int *request, int *ierror);
void mpi_comm_set_info_(int *comm, int *info, int *ierror);
void mpi_comm_remote_size_(int *comm, int *size, int *ierror);
void mpi_comm_set_errhandler_(int *comm, int *errhandler, int *ierror);
void mpi_comm_call_errhandler_(int *comm, int *errorcode, int *ierror);
void mpi_comm_create_errhandler_(vapaa_c_funptr fn, int *errhandler,
                                 int *ierror);
void mpi_errhandler_free_(int *errhandler, int *ierror);
void mpi_group_compare_(int *group1, int *group2, int *result, int *ierror);
void mpi_group_difference_(int *group1, int *group2, int *newgroup,
                           int *ierror);
void mpi_group_excl_(int *group, int *n, int ranks[], int *newgroup,
                     int *ierror);
void mpi_group_from_session_pset_(int *session, char *pset_name,
                                  int *newgroup, int *ierror,
                                  size_t pset_name_len);
void mpi_group_intersection_(int *group1, int *group2, int *newgroup,
                             int *ierror);
void mpi_group_range_excl_(int *group, int *n, int ranges[][3],
                           int *newgroup, int *ierror);
void mpi_group_range_incl_(int *group, int *n, int ranges[][3],
                           int *newgroup, int *ierror);
void mpi_group_translate_ranks_(int *group1, int *n, int ranks1[],
                                int *group2, int ranks2[], int *ierror);
void mpi_group_union_(int *group1, int *group2, int *newgroup, int *ierror);
void mpi_group_free_(int *group, int *ierror);
void mpi_barrier_(int *comm, int *ierror);
void mpi_bcast_(void *buffer, int *count, int *datatype, int *root,
                int *comm, int *ierror);
void mpi_reduce_(const void *sendbuf, void *recvbuf, int *count,
                 int *datatype, int *op, int *root, int *comm, int *ierror);
void mpi_scan_(const void *sendbuf, void *recvbuf, int *count, int *datatype,
               int *op, int *comm, int *ierror);
void mpi_scatterv_(const void *sendbuf, const int sendcounts[],
                   const int displs[], int *sendtype, void *recvbuf,
                   int *recvcount, int *recvtype, int *root, int *comm,
                   int *ierror);
void mpi_reduce_local_(void *inbuf, void *inoutbuf, int *count,
                       int *datatype, int *op, int *ierror);
void mpi_bsend_init_(void *buffer, int *count, int *datatype, int *dest,
                     int *tag, int *comm, int *request, int *ierror);
void mpi_request_free_(int *request, int *ierror);
void mpi_wait_(int *request, int *status, int *ierror);
void mpi_op_create_(vapaa_c_funptr user_fn, int *commute, int *op,
                    int *ierror);
void mpi_op_free_(int *op, int *ierror);
void mpi_op_commutative_(int *op, int *commute, int *ierror);
double mpi_wtime_(void);
double mpi_wtick_(void);
void mpi_get_processor_name_(char *name, int *resultlen, int *ierror,
                             size_t name_len);
void mpi_get_library_version_(char *version, int *resultlen, int *ierror,
                              size_t version_len);
void mpi_address_(void *location, intptr_t *address, int *ierror);
void mpi_get_address_(void *location, intptr_t *address, int *ierror);
void mpi_info_create_(int *info, int *ierror);
void mpi_info_create_env_(int *info, int *ierror);
void mpi_info_free_(int *info, int *ierror);
void mpi_keyval_create_(vapaa_c_funptr copy, vapaa_c_funptr del,
                        int *keyval, int *extra, int *ierror);
void mpi_keyval_free_(int *keyval, int *ierror);
void mpi_attr_put_(int *comm, int *keyval, int *attrval, int *ierror);
void mpi_attr_get_(int *comm, int *keyval, int *attrval, int *flag,
                   int *ierror);
void mpi_attr_delete_(int *comm, int *keyval, int *ierror);
void mpi_null_copy_fn_(int *oldcomm, int *keyval, int *extra, int *attr_in,
                       int *attr_out, int *flag, int *ierror);
void mpi_null_delete_fn_(int *comm, int *keyval, int *attr, int *extra,
                         int *ierror);

void mpi_alloc_mem_(intptr_t *size, int *info, void **baseptr, int *ierror);
void mpi_free_mem_(void *base, int *ierror);
void mpi_get_hw_resource_info_(int *info, int *ierror);
void mpi_pcontrol_(int *level, int *ierror);
void mpi_buffer_flush_(int *ierror);
void mpi_buffer_iflush_(int *request, int *ierror);
void mpi_comm_attach_buffer_(int *comm, void *buffer, int *size, int *ierror);
void mpi_comm_detach_buffer_(int *comm, void **buffer, int *size,
                             int *ierror);
void mpi_comm_flush_buffer_(int *comm, int *ierror);
void mpi_comm_iflush_buffer_(int *comm, int *request, int *ierror);
void mpi_comm_spawn_(char *command, void *argv, int *maxprocs, int *info,
                     int *root, int *comm, int *intercomm, int errcodes[],
                     int *ierror, size_t command_len);
void mpi_comm_spawn_multiple_(int *count, void *commands, void *argvs,
                              int maxprocs[], int infos[], int *root,
                              int *comm, int *intercomm, int errcodes[],
                              int *ierror);
void mpi_ibsend_(void *buffer, int *count, int *datatype, int *dest,
                 int *tag, int *comm, int *request, int *ierror);
void mpi_isendrecv_(const void *sendbuf, int *sendcount, int *sendtype,
                    int *dest, int *sendtag, void *recvbuf, int *recvcount,
                    int *recvtype, int *source, int *recvtag, int *comm,
                    int *request, int *ierror);
void mpi_isendrecv_replace_(void *buf, int *count, int *datatype, int *dest,
                            int *sendtag, int *source, int *recvtag,
                            int *comm, int *request, int *ierror);
void mpi_parrived_(const int *request, int *partition, int *flag,
                   int *ierror);
void mpi_pready_(int *partition, const int *request, int *ierror);
void mpi_pready_list_(int *length, const int partitions[], const int *request,
                      int *ierror);
void mpi_pready_range_(int *partition_low, int *partition_high,
                       const int *request, int *ierror);
void mpi_precv_init_(void *buf, int *partitions, int *count, int *datatype,
                     int *source, int *tag, int *comm, int *info,
                     int *request, int *ierror);
void mpi_psend_init_(void *buf, int *partitions, int *count, int *datatype,
                     int *dest, int *tag, int *comm, int *info,
                     int *request, int *ierror);
void mpi_file_close_(int *file, int *ierror);
void mpi_file_get_amode_(int *file, int *amode, int *ierror);
void mpi_file_get_atomicity_(int *file, int *flag, int *ierror);
void mpi_file_get_group_(int *file, int *group, int *ierror);
void mpi_file_get_errhandler_(int *file, int *errhandler, int *ierror);
void mpi_file_get_info_(int *file, int *info, int *ierror);
void mpi_file_get_position_(int *file, int64_t *offset, int *ierror);
void mpi_file_get_position_shared_(int *file, int64_t *offset, int *ierror);
void mpi_file_get_size_(int *file, int64_t *size, int *ierror);
void mpi_file_get_type_extent_(int *file, int *datatype, intptr_t *extent,
                               int *ierror);
void mpi_file_get_view_(int *file, int64_t *disp, int *etype, int *filetype,
                        char *datarep, int *ierror, size_t datarep_len);
void mpi_file_open_(int *comm, char *filename, int *amode, int *info,
                    int *file, int *ierror, size_t filename_len);
void mpi_file_preallocate_(int *file, int64_t *size, int *ierror);
void mpi_file_read_all_begin_(int *file, void *buf, int *count,
                              int *datatype, int *ierror);
void mpi_file_read_all_end_(int *file, void *buf, int *status, int *ierror);
void mpi_file_read_at_all_begin_(int *file, int64_t *offset, void *buf,
                                 int *count, int *datatype, int *ierror);
void mpi_file_read_at_all_end_(int *file, void *buf, int *status,
                               int *ierror);
void mpi_file_read_ordered_begin_(int *file, void *buf, int *count,
                                  int *datatype, int *ierror);
void mpi_file_read_ordered_end_(int *file, void *buf, int *status,
                                int *ierror);
void mpi_file_seek_(int *file, int64_t *offset, int *whence, int *ierror);
void mpi_file_seek_shared_(int *file, int64_t *offset, int *whence,
                           int *ierror);
void mpi_file_set_atomicity_(int *file, int *flag, int *ierror);
void mpi_file_set_errhandler_(int *file, int *errhandler, int *ierror);
void mpi_file_set_info_(int *file, int *info, int *ierror);
void mpi_file_set_size_(int *file, int64_t *size, int *ierror);
void mpi_file_set_view_(int *file, int64_t *disp, int *etype, int *filetype,
                        char *datarep, int *info, int *ierror,
                        size_t datarep_len);
void mpi_file_sync_(int *file, int *ierror);
void mpi_file_write_all_begin_(int *file, void *buf, int *count,
                               int *datatype, int *ierror);
void mpi_file_write_all_end_(int *file, void *buf, int *status, int *ierror);
void mpi_file_write_at_all_begin_(int *file, int64_t *offset, void *buf,
                                  int *count, int *datatype, int *ierror);
void mpi_file_write_at_all_end_(int *file, void *buf, int *status,
                                int *ierror);
void mpi_file_write_ordered_begin_(int *file, void *buf, int *count,
                                   int *datatype, int *ierror);
void mpi_file_write_ordered_end_(int *file, void *buf, int *status,
                                 int *ierror);

void mpi_session_attach_buffer_(int *session, void *buffer, int *size,
                                int *ierror);
void mpi_session_create_errhandler_(vapaa_c_funptr fn, int *errhandler,
                                    int *ierror);
void mpi_session_detach_buffer_(int *session, void **buffer, int *size,
                                int *ierror);
void mpi_session_finalize_(int *session, int *ierror);
void mpi_session_flush_buffer_(int *session, int *ierror);
void mpi_session_get_info_(int *session, int *info, int *ierror);
void mpi_session_get_nth_pset_(int *session, int *info, int *n,
                               int *pset_len, char *pset_name, int *ierror,
                               size_t pset_name_len);
void mpi_session_get_num_psets_(int *session, int *info, int *npset_names,
                                int *ierror);
void mpi_session_get_pset_info_(int *session, char *pset_name, int *info,
                                int *ierror, size_t pset_name_len);
void mpi_session_iflush_buffer_(int *session, int *request, int *ierror);
void mpi_session_init_(int *info, int *errhandler, int *session, int *ierror);
void mpi_session_call_errhandler_(int *session, int *errorcode, int *ierror);
void mpi_session_get_errhandler_(int *session, int *errhandler, int *ierror);
void mpi_session_set_errhandler_(int *session, int *errhandler, int *ierror);
void mpi_sizeof_(int *ierror);
void mpi_status_f082f_(int *ierror);
void mpi_status_f2f08_(int *ierror);
void mpi_request_get_status_(int *request, int *flag, int *status,
                             int *ierror);
void mpi_request_get_status_all_(int *count, int requests[], int *flag,
                                 int statuses[], int *ierror);
void mpi_request_get_status_any_(int *count, int requests[], int *index,
                                 int *flag, int *status, int *ierror);
void mpi_request_get_status_some_(int *incount, int requests[], int *outcount,
                                  int indices[], int statuses[], int *ierror);
void mpi_add_error_class_(int *errorclass, int *ierror);
void mpi_add_error_code_(int *errorclass, int *errorcode, int *ierror);
void mpi_add_error_string_(int *errorcode, char *string, int *ierror,
                           size_t string_len);
void mpi_remove_error_class_(int *errorclass, int *ierror);
void mpi_remove_error_code_(int *errorcode, int *ierror);
void mpi_remove_error_string_(int *errorcode, int *ierror);
void mpi_register_datarep_(char *datarep, vapaa_c_funptr read_fn,
                           vapaa_c_funptr write_fn, vapaa_c_funptr extent_fn,
                           intptr_t *extra, int *ierror, size_t datarep_len);
void mpi_register_datarep_c_(char *datarep, vapaa_c_funptr read_fn,
                             vapaa_c_funptr write_fn,
                             vapaa_c_funptr extent_fn, intptr_t *extra,
                             int *ierror, size_t datarep_len);

void mpi_type_contiguous_(int *count, int *oldtype, int *newtype,
                          int *ierror);
void mpi_type_free_(int *datatype, int *ierror);
void mpi_type_create_darray_(int *size, int *rank, int *ndims, int *gsizes,
                             int *distribs, int *dargs, int *psizes,
                             int *order, int *oldtype, int *newtype,
                             int *ierror);
void mpi_type_create_f90_complex_(int *p, int *r, int *newtype, int *ierror);
void mpi_type_create_f90_integer_(int *r, int *newtype, int *ierror);
void mpi_type_create_f90_real_(int *p, int *r, int *newtype, int *ierror);
void mpi_type_extent_(int *datatype, intptr_t *extent, int *ierror);
void mpi_type_get_contents_(int *datatype, int *maxints, int *maxadds,
                            int *maxtypes, int *ints, intptr_t *adds,
                            int *types, int *ierror);
void mpi_type_get_envelope_(int *datatype, int *nints, int *nadds,
                            int *ntypes, int *combiner, int *ierror);
void mpi_type_get_extent_x_(int *datatype, int64_t *lb, int64_t *extent,
                            int *ierror);
void mpi_type_get_true_extent_x_(int *datatype, int64_t *lb, int64_t *extent,
                                 int *ierror);
void mpi_type_get_value_index_(int *value_type, int *index_type,
                               int *pair_type, int *ierror);
void mpi_type_indexed_(int *count, int *blocklengths, int *displacements,
                       int *oldtype, int *newtype, int *ierror);
void mpi_type_match_size_(int *typeclass, int *size, int *datatype,
                          int *ierror);
void mpi_type_size_x_(int *datatype, int64_t *size, int *ierror);

void mpi_win_allocate_(intptr_t *size, int *disp_unit, int *info, int *comm,
                       void **baseptr, int *win, int *ierror);
void mpi_win_allocate_shared_(intptr_t *size, int *disp_unit, int *info,
                              int *comm, void **baseptr, int *win,
                              int *ierror);
void mpi_win_attach_(int *win, void *base, intptr_t *size, int *ierror);
void mpi_win_call_errhandler_(int *win, int *errorcode, int *ierror);
void mpi_win_complete_(int *win, int *ierror);
void mpi_win_create_(void *base, intptr_t *size, int *disp_unit, int *info,
                     int *comm, int *win, int *ierror);
void mpi_win_create_dynamic_(int *info, int *comm, int *win, int *ierror);
void mpi_win_create_errhandler_(vapaa_c_funptr fn, int *errhandler,
                                int *ierror);
void mpi_win_detach_(int *win, void *base, int *ierror);
void mpi_win_free_(int *win, int *ierror);
void mpi_win_get_group_(int *win, int *group, int *ierror);
void mpi_win_post_(int *group, int *assert, int *win, int *ierror);
void mpi_win_set_errhandler_(int *win, int *errhandler, int *ierror);
void mpi_win_set_info_(int *win, int *info, int *ierror);
void mpi_win_shared_query_(int *win, int *rank, intptr_t *size,
                           int *disp_unit, void **baseptr, int *ierror);
void mpi_win_start_(int *group, int *assert, int *win, int *ierror);
void mpi_win_test_(int *win, int *flag, int *ierror);
void mpi_win_wait_(int *win, int *ierror);
void mpi_win_null_copy_fn_(int *oldwin, int *keyval, intptr_t *extra,
                           intptr_t *attr_in, intptr_t *attr_out, int *flag,
                           int *ierror);
void mpi_win_dup_fn_(int *oldwin, int *keyval, intptr_t *extra,
                     intptr_t *attr_in, intptr_t *attr_out, int *flag,
                     int *ierror);

void VAPAA_MPI_Get_address_nocfi(void *location, intptr_t *address,
                                 int *ierror);
void VAPAA_MPI_Free_mem_nocfi(void *base, int *ierror);
void VAPAA_MPI_Get_count_c(const struct F_MPI_Status *status, int *datatype,
                           int64_t *count, int *ierror);
void VAPAA_MPI_Get_elements_c(const struct F_MPI_Status *status,
                              int *datatype, int64_t *count, int *ierror);
void VAPAA_MPI_Type_get_extent_x(int *datatype, int64_t *lb, int64_t *extent,
                                 int *ierror);
void VAPAA_MPI_Type_get_true_extent_x(int *datatype, int64_t *lb,
                                      int64_t *extent, int *ierror);

static int g_rank = 0;
static int g_size = 0;
static int g_errors = 0;
static int g_legacy_op_calls = 0;
static int g_legacy_comm_errhandler_calls = 0;

static int is_unsupported(int ierr)
{
    if (ierr == VAPAA_MPI_ERR_UNSUPPORTED_OPERATION) {
        return 1;
    }
#ifdef MPI_ERR_UNSUPPORTED_OPERATION
    if (ierr == MPI_ERR_UNSUPPORTED_OPERATION) {
        return 1;
    }
#endif
    return 0;
}

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
    if (ierr == MPI_SUCCESS || is_unsupported(ierr)) {
        return;
    }
    note_error(label, ierr);
}

static void check_success_or_unavailable(int ierr, const char *label)
{
    if (ierr == MPI_SUCCESS || is_unsupported(ierr) ||
        ierr == VAPAA_MPI_ERR_INTERN || ierr == MPI_ERR_INTERN) {
        return;
    }
    note_error(label, ierr);
}

static void check_datarep_registration(int ierr, const char *label)
{
    if (ierr == MPI_SUCCESS || is_unsupported(ierr) || ierr == MPI_ERR_OTHER) {
        return;
    }
#ifdef MPI_ERR_UNSUPPORTED_DATAREP
    if (ierr == MPI_ERR_UNSUPPORTED_DATAREP) {
        return;
    }
#endif
    note_error(label, ierr);
}

static void wait_if_live(int *request, const char *label)
{
    int ierr = MPI_SUCCESS;
    int status[8] = {0};

    if (*request == VAPAA_MPI_REQUEST_NULL) {
        return;
    }
    mpi_wait_(request, status, &ierr);
    check_success(ierr, label);
}

static void free_type_if_live(int *datatype, const char *label)
{
    int ierr = MPI_SUCCESS;

    if (*datatype == VAPAA_MPI_DATATYPE_NULL) {
        return;
    }
    mpi_type_free_(datatype, &ierr);
    check_success(ierr, label);
}

static void free_group_if_live(int *group, const char *label)
{
    int ierr = MPI_SUCCESS;

    if (*group == VAPAA_MPI_GROUP_NULL || *group == VAPAA_MPI_GROUP_EMPTY) {
        return;
    }
    mpi_group_free_(group, &ierr);
    check_success(ierr, label);
}

static void legacy_user_op(void *invec, void *inoutvec, int *len,
                           int *datatype)
{
    int *in = invec;
    int *inout = inoutvec;

    (void)datatype;
    for (int i = 0; i < *len; i++) {
        inout[i] += in[i];
    }
    g_legacy_op_calls++;
}

static void legacy_comm_errhandler(int *comm, int *errorcode)
{
    (void)comm;
    *errorcode = VAPAA_MPI_SUCCESS;
    g_legacy_comm_errhandler_calls++;
}

static void legacy_datarep_read(void *userbuf, int *datatype, int *count,
                                void *filebuf, int64_t *position,
                                intptr_t *extra, int *ierror)
{
    (void)userbuf;
    (void)datatype;
    (void)count;
    (void)filebuf;
    (void)position;
    (void)extra;
    *ierror = MPI_SUCCESS;
}

static void legacy_datarep_write(void *userbuf, int *datatype, int *count,
                                 void *filebuf, int64_t *position,
                                 intptr_t *extra, int *ierror)
{
    legacy_datarep_read(userbuf, datatype, count, filebuf, position, extra,
                        ierror);
}

static void legacy_datarep_read_c(void *userbuf, int *datatype,
                                  int64_t *count, void *filebuf,
                                  int64_t *position, intptr_t *extra,
                                  int *ierror)
{
    (void)userbuf;
    (void)datatype;
    (void)count;
    (void)filebuf;
    (void)position;
    (void)extra;
    *ierror = MPI_SUCCESS;
}

static void legacy_datarep_write_c(void *userbuf, int *datatype,
                                   int64_t *count, void *filebuf,
                                   int64_t *position, intptr_t *extra,
                                   int *ierror)
{
    legacy_datarep_read_c(userbuf, datatype, count, filebuf, position, extra,
                          ierror);
}

static void legacy_datarep_extent(int *datatype, intptr_t *extent,
                                  intptr_t *extra, int *ierror)
{
    MPI_Aint lb = 0;
    MPI_Aint ext = 0;
    MPI_Datatype dtype = C_MPI_TYPE_FROMINT(*datatype);

    (void)extra;
    *ierror = MPI_Type_get_extent(dtype, &lb, &ext);
    *extent = (intptr_t)ext;
}

static void run_basic_legacy_wrappers(void)
{
    int ierr = MPI_SUCCESS;
    int world = VAPAA_MPI_COMM_WORLD;
    int self = VAPAA_MPI_COMM_SELF;
    int errors_return = VAPAA_MPI_ERRORS_RETURN;
    int dtype = VAPAA_MPI_INTEGER;
    int op = VAPAA_MPI_SUM;
    int root = 0;
    int one = 1;
    int value = (g_rank == 0) ? 91 : -1;
    int send = g_rank + 1;
    int reduced = -1;
    int scanned = -1;
    int sendcounts[4] = {1, 1, 1, 1};
    int displs[4] = {0, 1, 2, 3};
    int scatter_send[4] = {30, 31, 32, 33};
    int scatter_recv = -1;
    int request = VAPAA_MPI_REQUEST_NULL;
    int tag = 770;
    int dest = VAPAA_MPI_PROC_NULL;
    int group = VAPAA_MPI_GROUP_NULL;
    int compare = VAPAA_MPI_UNDEFINED;
    int info = VAPAA_MPI_INFO_NULL;
    int keyval = VAPAA_MPI_KEYVAL_INVALID;
    int extra = 0;
    int attr = 1234;
    int attr_out = 0;
    int flag = 0;
    int resultlen = 0;
    intptr_t address = 0;
    char processor[MPI_MAX_PROCESSOR_NAME] = {0};
    char version[MPI_MAX_LIBRARY_VERSION_STRING] = {0};

    mpi_comm_set_errhandler_(&world, &errors_return, &ierr);
    check_success(ierr, "mpi_comm_set_errhandler world");
    mpi_comm_set_errhandler_(&self, &errors_return, &ierr);
    check_success(ierr, "mpi_comm_set_errhandler self");

    (void)mpi_wtime_();
    (void)mpi_wtick_();
    mpi_get_processor_name_(processor, &resultlen, &ierr, sizeof(processor));
    check_success(ierr, "mpi_get_processor_name");
    mpi_get_library_version_(version, &resultlen, &ierr, sizeof(version));
    check_success(ierr, "mpi_get_library_version");

    mpi_barrier_(&world, &ierr);
    check_success(ierr, "mpi_barrier");
    mpi_bcast_(&value, &one, &dtype, &root, &world, &ierr);
    check_success(ierr, "mpi_bcast");
    if (value != 91) {
        note_error("mpi_bcast payload", value);
    }
    mpi_reduce_(&send, &reduced, &one, &dtype, &op, &root, &world, &ierr);
    check_success(ierr, "mpi_reduce");
    mpi_scan_(&send, &scanned, &one, &dtype, &op, &world, &ierr);
    check_success(ierr, "mpi_scan");
    mpi_scatterv_(scatter_send, sendcounts, displs, &dtype, &scatter_recv,
                  &one, &dtype, &root, &world, &ierr);
    check_success(ierr, "mpi_scatterv");

    mpi_bsend_init_(&value, &one, &dtype, &dest, &tag, &world, &request,
                    &ierr);
    check_success(ierr, "mpi_bsend_init PROC_NULL");
    if (request != VAPAA_MPI_REQUEST_NULL) {
        mpi_request_free_(&request, &ierr);
        check_success(ierr, "mpi_request_free bsend_init");
    }

    mpi_address_(&value, &address, &ierr);
    check_success(ierr, "mpi_address");
    mpi_get_address_(&value, &address, &ierr);
    check_success(ierr, "mpi_get_address");

    mpi_info_create_env_(&info, &ierr);
    check_success_or_unsupported(ierr, "mpi_info_create_env");
    if (ierr == MPI_SUCCESS && info != VAPAA_MPI_INFO_NULL) {
        mpi_info_free_(&info, &ierr);
        check_success(ierr, "mpi_info_free env");
    }

    mpi_comm_group_(&world, &group, &ierr);
    check_success(ierr, "mpi_comm_group world");
    mpi_group_compare_(&group, &group, &compare, &ierr);
    check_success(ierr, "mpi_group_compare");
    mpi_group_free_(&group, &ierr);
    check_success(ierr, "mpi_group_free world");

    mpi_comm_remote_size_(&self, &g_size, &ierr);

    mpi_keyval_create_((vapaa_c_funptr)mpi_null_copy_fn_,
                       (vapaa_c_funptr)mpi_null_delete_fn_, &keyval, &extra,
                       &ierr);
    check_success(ierr, "mpi_keyval_create");
    if (ierr == MPI_SUCCESS) {
        mpi_attr_put_(&self, &keyval, &attr, &ierr);
        check_success(ierr, "mpi_attr_put");
        mpi_attr_get_(&self, &keyval, &attr_out, &flag, &ierr);
        check_success(ierr, "mpi_attr_get");
        mpi_attr_delete_(&self, &keyval, &ierr);
        check_success(ierr, "mpi_attr_delete");
        mpi_keyval_free_(&keyval, &ierr);
        check_success(ierr, "mpi_keyval_free");
    }

    mpi_null_copy_fn_(&self, &keyval, &extra, &attr, &attr_out, &flag, &ierr);
    check_success(ierr, "mpi_null_copy_fn");
    mpi_null_delete_fn_(&self, &keyval, &attr, &extra, &ierr);
    check_success(ierr, "mpi_null_delete_fn");
}

static void run_missing_comm_group_wrappers(void)
{
    int ierr = MPI_SUCCESS;
    int self = VAPAA_MPI_COMM_SELF;
    int info = VAPAA_MPI_INFO_NULL;
    int self_group = VAPAA_MPI_GROUP_NULL;
    int empty_group = VAPAA_MPI_GROUP_NULL;
    int same_group = VAPAA_MPI_GROUP_NULL;
    int union_group = VAPAA_MPI_GROUP_NULL;
    int intersection_group = VAPAA_MPI_GROUP_NULL;
    int difference_group = VAPAA_MPI_GROUP_NULL;
    int range_empty_group = VAPAA_MPI_GROUP_NULL;
    int created = VAPAA_MPI_COMM_NULL;
    int dupcomm = VAPAA_MPI_COMM_NULL;
    int parent = VAPAA_MPI_COMM_NULL;
    int info_out = VAPAA_MPI_INFO_NULL;
    int request = VAPAA_MPI_REQUEST_NULL;
    int tag = 0;
    int one = 1;
    int rank0[1] = {0};
    int translated[1] = {-1};
    int ranges[1][3] = {{0, 0, 1}};

    mpi_info_create_(&info, &ierr);
    check_success(ierr, "mpi_info_create comm_group");

    mpi_comm_group_(&self, &self_group, &ierr);
    check_success(ierr, "mpi_comm_group self");
    mpi_group_excl_(&self_group, &one, rank0, &empty_group, &ierr);
    check_success(ierr, "mpi_group_excl self");
    mpi_group_range_incl_(&self_group, &one, ranges, &same_group, &ierr);
    check_success(ierr, "mpi_group_range_incl self");
    mpi_group_range_excl_(&self_group, &one, ranges, &range_empty_group,
                          &ierr);
    check_success(ierr, "mpi_group_range_excl self");
    mpi_group_translate_ranks_(&same_group, &one, rank0, &self_group,
                               translated, &ierr);
    check_success(ierr, "mpi_group_translate_ranks self");
    mpi_group_union_(&same_group, &self_group, &union_group, &ierr);
    check_success(ierr, "mpi_group_union self");
    mpi_group_intersection_(&same_group, &self_group, &intersection_group,
                            &ierr);
    check_success(ierr, "mpi_group_intersection self");
    mpi_group_difference_(&self_group, &same_group, &difference_group, &ierr);
    check_success(ierr, "mpi_group_difference self");

    mpi_comm_dup_with_info_(&self, &info, &dupcomm, &ierr);
    check_success(ierr, "mpi_comm_dup_with_info");
    if (dupcomm != VAPAA_MPI_COMM_NULL) {
        mpi_comm_get_info_(&dupcomm, &info_out, &ierr);
        check_success(ierr, "mpi_comm_get_info");
        if (info_out != VAPAA_MPI_INFO_NULL) {
            mpi_info_free_(&info_out, &ierr);
            check_success(ierr, "mpi_info_free comm_get_info");
        }
        mpi_comm_set_info_(&dupcomm, &info, &ierr);
        check_success_or_unavailable(ierr, "mpi_comm_set_info");
        mpi_comm_free_(&dupcomm, &ierr);
        check_success(ierr, "mpi_comm_free dup_with_info");
    }

    mpi_comm_create_(&self, &same_group, &created, &ierr);
    check_success(ierr, "mpi_comm_create self");
    if (created != VAPAA_MPI_COMM_NULL) {
        mpi_comm_free_(&created, &ierr);
        check_success(ierr, "mpi_comm_free create");
    }
    mpi_comm_create_group_(&self, &same_group, &tag, &created, &ierr);
    check_success(ierr, "mpi_comm_create_group self");
    if (created != VAPAA_MPI_COMM_NULL) {
        mpi_comm_free_(&created, &ierr);
        check_success(ierr, "mpi_comm_free create_group");
    }

    mpi_comm_idup_(&self, &dupcomm, &request, &ierr);
    check_success(ierr, "mpi_comm_idup");
    wait_if_live(&request, "mpi_comm_idup wait");
    if (dupcomm != VAPAA_MPI_COMM_NULL) {
        mpi_comm_free_(&dupcomm, &ierr);
        check_success(ierr, "mpi_comm_free idup");
    }
    mpi_comm_idup_with_info_(&self, &info, &dupcomm, &request, &ierr);
    check_success_or_unsupported(ierr, "mpi_comm_idup_with_info");
    if (ierr == MPI_SUCCESS) {
        wait_if_live(&request, "mpi_comm_idup_with_info wait");
    }
    if (ierr == MPI_SUCCESS && dupcomm != VAPAA_MPI_COMM_NULL) {
        mpi_comm_free_(&dupcomm, &ierr);
        check_success(ierr, "mpi_comm_free idup_with_info");
    }
    mpi_comm_get_parent_(&parent, &ierr);
    check_success(ierr, "mpi_comm_get_parent");

#if MPI_VERSION < 4
    {
        int session = VAPAA_MPI_SESSION_NULL;
        int pset_group = VAPAA_MPI_GROUP_NULL;
        char pset[] = "mpi://WORLD";

        mpi_group_from_session_pset_(&session, pset, &pset_group, &ierr,
                                     strlen(pset));
        check_success_or_unsupported(ierr, "mpi_group_from_session_pset");
    }
#endif

    free_group_if_live(&difference_group, "mpi_group_free difference");
    free_group_if_live(&intersection_group, "mpi_group_free intersection");
    free_group_if_live(&union_group, "mpi_group_free union");
    free_group_if_live(&range_empty_group, "mpi_group_free range_excl");
    free_group_if_live(&same_group, "mpi_group_free range_incl");
    free_group_if_live(&empty_group, "mpi_group_free excl");
    free_group_if_live(&self_group, "mpi_group_free self");
    if (info != VAPAA_MPI_INFO_NULL) {
        mpi_info_free_(&info, &ierr);
        check_success(ierr, "mpi_info_free comm_group");
    }
}

static void run_legacy_trampoline_slots(void)
{
    int ierr = MPI_SUCCESS;
    int self = VAPAA_MPI_COMM_SELF;
    int errors_return = VAPAA_MPI_ERRORS_RETURN;
    int errcode = VAPAA_MPI_ERR_OTHER;
    int comm_handlers[32];
    int ops[64];
    int commute = 1;
    int one = 1;
    int dtype = VAPAA_MPI_INTEGER;

    for (int i = 0; i < 32; i++) {
        comm_handlers[i] = VAPAA_MPI_ERRHANDLER_NULL;
        mpi_comm_create_errhandler_((vapaa_c_funptr)legacy_comm_errhandler,
                                    &comm_handlers[i], &ierr);
        check_success(ierr, "mpi_comm_create_errhandler slot");
    }
    for (int i = 0; i < 32; i++) {
        mpi_comm_set_errhandler_(&self, &comm_handlers[i], &ierr);
        check_success(ierr, "mpi_comm_set_errhandler custom");
        mpi_comm_call_errhandler_(&self, &errcode, &ierr);
        check_success(ierr, "mpi_comm_call_errhandler custom");
    }
    mpi_comm_set_errhandler_(&self, &errors_return, &ierr);
    check_success(ierr, "mpi_comm_set_errhandler reset");
    for (int i = 0; i < 32; i++) {
        mpi_errhandler_free_(&comm_handlers[i], &ierr);
        check_success(ierr, "mpi_errhandler_free custom");
    }

    for (int i = 0; i < 64; i++) {
        ops[i] = VAPAA_MPI_OP_NULL;
        mpi_op_create_((vapaa_c_funptr)legacy_user_op, &commute, &ops[i],
                       &ierr);
        check_success(ierr, "mpi_op_create slot");
    }
    for (int i = 0; i < 64; i++) {
        int in = 2;
        int inout = 3;
        int is_commutative = 0;

        mpi_reduce_local_(&in, &inout, &one, &dtype, &ops[i], &ierr);
        check_success(ierr, "mpi_reduce_local custom op");
        if (inout != 5) {
            note_error("mpi_reduce_local custom op payload", inout);
        }
        mpi_op_commutative_(&ops[i], &is_commutative, &ierr);
        check_success(ierr, "mpi_op_commutative custom op");
    }
    for (int i = 0; i < 64; i++) {
        mpi_op_free_(&ops[i], &ierr);
        check_success(ierr, "mpi_op_free custom");
    }

    if (g_legacy_comm_errhandler_calls != 32) {
        note_error("legacy comm errhandler trampoline count",
                   g_legacy_comm_errhandler_calls);
    }
    if (g_legacy_op_calls != 64) {
        note_error("legacy op trampoline count", g_legacy_op_calls);
    }
}

static void run_missing_memory_status_and_p2p(void)
{
    int ierr = MPI_SUCCESS;
    int world = VAPAA_MPI_COMM_WORLD;
    int self = VAPAA_MPI_COMM_SELF;
    int info = VAPAA_MPI_INFO_NULL;
    int dtype = VAPAA_MPI_INTEGER;
    int one = 1;
    int zero = 0;
    int tag = 780;
    int proc_null = VAPAA_MPI_PROC_NULL;
    int request = VAPAA_MPI_REQUEST_NULL;
    int partition = 0;
    int partitions[2] = {0, 1};
    int length = 2;
    int flag = 0;
    int buffer[256] = {0};
    int bsend_payload = 13;
    int recv_payload = -1;
    int recvcount = 1;
    int maxprocs = 0;
    int intercomm = VAPAA_MPI_COMM_NULL;
    int errcodes[1] = {0};
    int command_count = 0;
    int maxprocs_vec[1] = {0};
    int infos[1] = {VAPAA_MPI_INFO_NULL};
    int level = 0;
    int hw_info = VAPAA_MPI_INFO_NULL;
    int errors_return = VAPAA_MPI_ERRORS_RETURN;
    int session = VAPAA_MPI_SESSION_NULL;
    int session_errhandler = VAPAA_MPI_ERRHANDLER_NULL;
    int pset_len = VAPAA_MPI_MAX_PSET_NAME_LEN;
    int npsets = -1;
    intptr_t bytes = 64;
    intptr_t address = 0;
    int buffer_size = (int)sizeof(buffer);
    void *base = NULL;
    void *detached = NULL;
    char command[] = "ignored";
    char pset[VAPAA_MPI_MAX_PSET_NAME_LEN] = {0};
    MPI_Status c_status;
    struct F_MPI_Status f_status;
    int64_t count_c = -1;

    mpi_alloc_mem_(&bytes, &info, &base, &ierr);
    check_success(ierr, "mpi_alloc_mem");
    if (ierr == MPI_SUCCESS) {
        mpi_free_mem_(base, &ierr);
        check_success(ierr, "mpi_free_mem");
    }
    mpi_alloc_mem_(&bytes, &info, &base, &ierr);
    check_success(ierr, "mpi_alloc_mem nocfi");
    if (ierr == MPI_SUCCESS) {
        VAPAA_MPI_Get_address_nocfi(base, &address, &ierr);
        check_success(ierr, "VAPAA_MPI_Get_address_nocfi");
        VAPAA_MPI_Free_mem_nocfi(base, &ierr);
        check_success(ierr, "VAPAA_MPI_Free_mem_nocfi");
    }

    memset(&c_status, 0, sizeof(c_status));
    memset(&f_status, 0, sizeof(f_status));
    ierr = MPI_Recv(&recv_payload, 0, MPI_INT, MPI_PROC_NULL, tag,
                    MPI_COMM_SELF, &c_status);
    check_success(ierr, "native MPI_Recv PROC_NULL");
    C_MPI_STATUS_FROM_C(&c_status, &f_status);
    VAPAA_MPI_Get_count_c(&f_status, &dtype, &count_c, &ierr);
    check_success(ierr, "VAPAA_MPI_Get_count_c");
    VAPAA_MPI_Get_elements_c(&f_status, &dtype, &count_c, &ierr);
    check_success(ierr, "VAPAA_MPI_Get_elements_c");

    mpi_buffer_flush_(&ierr);
    check_success_or_unsupported(ierr, "mpi_buffer_flush");
    mpi_buffer_iflush_(&request, &ierr);
    check_success_or_unsupported(ierr, "mpi_buffer_iflush");
    wait_if_live(&request, "mpi_buffer_iflush wait");

    mpi_comm_attach_buffer_(&self, buffer, &buffer_size, &ierr);
    check_success_or_unsupported(ierr, "mpi_comm_attach_buffer");
    mpi_comm_flush_buffer_(&self, &ierr);
    check_success_or_unsupported(ierr, "mpi_comm_flush_buffer");
    mpi_comm_iflush_buffer_(&self, &request, &ierr);
    check_success_or_unsupported(ierr, "mpi_comm_iflush_buffer");
    wait_if_live(&request, "mpi_comm_iflush_buffer wait");
    mpi_comm_detach_buffer_(&self, &detached, &buffer_size, &ierr);
    check_success_or_unsupported(ierr, "mpi_comm_detach_buffer");

    mpi_ibsend_(&bsend_payload, &one, &dtype, &proc_null, &tag, &world,
                &request, &ierr);
    check_success(ierr, "mpi_ibsend PROC_NULL");
    wait_if_live(&request, "mpi_ibsend wait");

    mpi_isendrecv_(&bsend_payload, &one, &dtype, &proc_null, &tag,
                   &recv_payload, &recvcount, &dtype, &proc_null, &tag,
                   &world, &request, &ierr);
    check_success_or_unsupported(ierr, "mpi_isendrecv PROC_NULL");
    wait_if_live(&request, "mpi_isendrecv wait");
    mpi_isendrecv_replace_(&recv_payload, &one, &dtype, &proc_null, &tag,
                           &proc_null, &tag, &world, &request, &ierr);
    check_success_or_unsupported(ierr, "mpi_isendrecv_replace PROC_NULL");
    wait_if_live(&request, "mpi_isendrecv_replace wait");

    request = VAPAA_MPI_REQUEST_NULL;
    mpi_parrived_(&request, &partition, &flag, &ierr);
    check_success_or_unsupported(ierr, "mpi_parrived");
    mpi_pready_(&partition, &request, &ierr);
    check_success_or_unsupported(ierr, "mpi_pready");
    mpi_pready_list_(&length, partitions, &request, &ierr);
    check_success_or_unsupported(ierr, "mpi_pready_list");
    mpi_pready_range_(&partitions[0], &partitions[1], &request, &ierr);
    check_success_or_unsupported(ierr, "mpi_pready_range");
    mpi_precv_init_(&recv_payload, &length, &one, &dtype, &proc_null, &tag,
                    &self, &info, &request, &ierr);
    check_success_or_unsupported(ierr, "mpi_precv_init PROC_NULL");
    if (request != VAPAA_MPI_REQUEST_NULL) {
        mpi_request_free_(&request, &ierr);
        check_success(ierr, "mpi_precv_init free");
    }
    mpi_psend_init_(&bsend_payload, &length, &one, &dtype, &proc_null, &tag,
                    &self, &info, &request, &ierr);
    check_success_or_unsupported(ierr, "mpi_psend_init PROC_NULL");
    if (request != VAPAA_MPI_REQUEST_NULL) {
        mpi_request_free_(&request, &ierr);
        check_success(ierr, "mpi_psend_init free");
    }

    mpi_comm_spawn_(command, NULL, &maxprocs, &info, &zero, &self,
                    &intercomm, errcodes, &ierr, strlen(command));
    check_success_or_unsupported(ierr, "mpi_comm_spawn unsupported");
    mpi_comm_spawn_multiple_(&command_count, NULL, NULL, maxprocs_vec, infos,
                             &zero, &self, &intercomm, errcodes, &ierr);
    check_success_or_unsupported(ierr, "mpi_comm_spawn_multiple unsupported");

    mpi_get_hw_resource_info_(&hw_info, &ierr);
    check_success_or_unsupported(ierr, "mpi_get_hw_resource_info");
    if (ierr == MPI_SUCCESS && hw_info != VAPAA_MPI_INFO_NULL) {
        mpi_info_free_(&hw_info, &ierr);
        check_success(ierr, "mpi_get_hw_resource_info free");
    }
    mpi_pcontrol_(&level, &ierr);
    check_success(ierr, "mpi_pcontrol");

#if MPI_VERSION < 4
    mpi_session_attach_buffer_(&session, buffer, &buffer_size, &ierr);
    check_success_or_unsupported(ierr, "mpi_session_attach_buffer");
    mpi_session_create_errhandler_((vapaa_c_funptr)legacy_comm_errhandler,
                                   &session_errhandler, &ierr);
    check_success_or_unsupported(ierr, "mpi_session_create_errhandler");
    mpi_session_detach_buffer_(&session, &detached, &buffer_size, &ierr);
    check_success_or_unsupported(ierr, "mpi_session_detach_buffer");
    mpi_session_flush_buffer_(&session, &ierr);
    check_success_or_unsupported(ierr, "mpi_session_flush_buffer");
    mpi_session_get_info_(&session, &info, &ierr);
    check_success_or_unsupported(ierr, "mpi_session_get_info");
    mpi_session_get_nth_pset_(&session, &info, &zero, &pset_len, pset, &ierr,
                              sizeof(pset));
    check_success_or_unsupported(ierr, "mpi_session_get_nth_pset");
    mpi_session_get_num_psets_(&session, &info, &npsets, &ierr);
    check_success_or_unsupported(ierr, "mpi_session_get_num_psets");
    mpi_session_get_pset_info_(&session, pset, &info, &ierr, sizeof(pset));
    check_success_or_unsupported(ierr, "mpi_session_get_pset_info");
    mpi_session_iflush_buffer_(&session, &request, &ierr);
    check_success_or_unsupported(ierr, "mpi_session_iflush_buffer");
    wait_if_live(&request, "mpi_session_iflush_buffer wait");
    mpi_session_init_(&info, &errors_return, &session, &ierr);
    check_success_or_unsupported(ierr, "mpi_session_init");
    mpi_session_call_errhandler_(&session, &errcodes[0], &ierr);
    check_success_or_unsupported(ierr, "mpi_session_call_errhandler");
    mpi_session_get_errhandler_(&session, &session_errhandler, &ierr);
    check_success_or_unsupported(ierr, "mpi_session_get_errhandler");
    mpi_session_set_errhandler_(&session, &errors_return, &ierr);
    check_success_or_unsupported(ierr, "mpi_session_set_errhandler");
    mpi_session_finalize_(&session, &ierr);
    check_success_or_unsupported(ierr, "mpi_session_finalize");
#endif

    mpi_sizeof_(&ierr);
    check_success_or_unsupported(ierr, "mpi_sizeof");
    mpi_status_f082f_(&ierr);
    check_success_or_unsupported(ierr, "mpi_status_f082f");
    mpi_status_f2f08_(&ierr);
    check_success_or_unsupported(ierr, "mpi_status_f2f08");
}

static void run_missing_file_wrappers(void)
{
    int ierr = MPI_SUCCESS;
    int self = VAPAA_MPI_COMM_SELF;
    int info = VAPAA_MPI_INFO_NULL;
    int file = VAPAA_MPI_FILE_NULL;
    int dtype = VAPAA_MPI_INTEGER;
    int errors_return = VAPAA_MPI_ERRORS_RETURN;
    int amode = VAPAA_MPI_MODE_CREATE | VAPAA_MPI_MODE_RDWR |
                VAPAA_MPI_MODE_DELETE_ON_CLOSE;
    int zero_count = 0;
    int atomicity = 0;
    int group = VAPAA_MPI_GROUP_NULL;
    int errhandler = VAPAA_MPI_ERRHANDLER_NULL;
    int info_out = VAPAA_MPI_INFO_NULL;
    int etype = VAPAA_MPI_DATATYPE_NULL;
    int filetype = VAPAA_MPI_DATATYPE_NULL;
    int whence = VAPAA_MPI_SEEK_SET;
    int status[8] = {0};
    int buffer[4] = {1, 2, 3, 4};
    int64_t offset = 0;
    int64_t size = 128;
    int64_t disp = 0;
    intptr_t extent = 0;
    char filename[96];
    char datarep[64] = {0};

    mpi_info_create_(&info, &ierr);
    check_success(ierr, "mpi_info_create file");

    snprintf(filename, sizeof(filename), "f77_direct_file_%d.dat", g_rank);
    mpi_file_open_(&self, filename, &amode, &info, &file, &ierr,
                   strlen(filename));
    check_success(ierr, "mpi_file_open");
    if (ierr != MPI_SUCCESS) {
        if (info != VAPAA_MPI_INFO_NULL) {
            mpi_info_free_(&info, &ierr);
            check_success(ierr, "mpi_info_free file after open failure");
        }
        return;
    }

    mpi_file_set_errhandler_(&file, &errors_return, &ierr);
    check_success(ierr, "mpi_file_set_errhandler");
    mpi_file_get_errhandler_(&file, &errhandler, &ierr);
    check_success(ierr, "mpi_file_get_errhandler");
    if (errhandler != VAPAA_MPI_ERRHANDLER_NULL) {
        mpi_errhandler_free_(&errhandler, &ierr);
        check_success(ierr, "mpi_file get errhandler free");
    }
    mpi_file_get_group_(&file, &group, &ierr);
    check_success(ierr, "mpi_file_get_group");
    free_group_if_live(&group, "mpi_file group free");
    mpi_file_get_amode_(&file, &amode, &ierr);
    check_success(ierr, "mpi_file_get_amode");
    mpi_file_get_atomicity_(&file, &atomicity, &ierr);
    check_success(ierr, "mpi_file_get_atomicity");
    mpi_file_set_atomicity_(&file, &atomicity, &ierr);
    check_success(ierr, "mpi_file_set_atomicity");
    mpi_file_get_info_(&file, &info_out, &ierr);
    check_success(ierr, "mpi_file_get_info");
    if (info_out != VAPAA_MPI_INFO_NULL) {
        mpi_info_free_(&info_out, &ierr);
        check_success(ierr, "mpi_file info free");
    }
    mpi_file_set_info_(&file, &info, &ierr);
    check_success(ierr, "mpi_file_set_info");
    mpi_file_preallocate_(&file, &size, &ierr);
    check_success(ierr, "mpi_file_preallocate");
    mpi_file_set_size_(&file, &size, &ierr);
    check_success(ierr, "mpi_file_set_size");
    mpi_file_get_size_(&file, &size, &ierr);
    check_success(ierr, "mpi_file_get_size");
    mpi_file_get_type_extent_(&file, &dtype, &extent, &ierr);
    check_success(ierr, "mpi_file_get_type_extent");
    mpi_file_set_view_(&file, &disp, &dtype, &dtype, "native", &info, &ierr,
                       strlen("native"));
    check_success(ierr, "mpi_file_set_view");
    mpi_file_get_view_(&file, &disp, &etype, &filetype, datarep, &ierr,
                       sizeof(datarep));
    check_success(ierr, "mpi_file_get_view");
    mpi_file_seek_(&file, &offset, &whence, &ierr);
    check_success(ierr, "mpi_file_seek");
    mpi_file_get_position_(&file, &offset, &ierr);
    check_success(ierr, "mpi_file_get_position");
    mpi_file_seek_shared_(&file, &offset, &whence, &ierr);
    check_success(ierr, "mpi_file_seek_shared");
    mpi_file_get_position_shared_(&file, &offset, &ierr);
    check_success(ierr, "mpi_file_get_position_shared");

    mpi_file_write_all_begin_(&file, buffer, &zero_count, &dtype, &ierr);
    check_success(ierr, "mpi_file_write_all_begin");
    mpi_file_write_all_end_(&file, buffer, status, &ierr);
    check_success(ierr, "mpi_file_write_all_end");
    mpi_file_read_all_begin_(&file, buffer, &zero_count, &dtype, &ierr);
    check_success(ierr, "mpi_file_read_all_begin");
    mpi_file_read_all_end_(&file, buffer, status, &ierr);
    check_success(ierr, "mpi_file_read_all_end");
    mpi_file_write_at_all_begin_(&file, &offset, buffer, &zero_count, &dtype,
                                 &ierr);
    check_success(ierr, "mpi_file_write_at_all_begin");
    mpi_file_write_at_all_end_(&file, buffer, status, &ierr);
    check_success(ierr, "mpi_file_write_at_all_end");
    mpi_file_read_at_all_begin_(&file, &offset, buffer, &zero_count, &dtype,
                                &ierr);
    check_success(ierr, "mpi_file_read_at_all_begin");
    mpi_file_read_at_all_end_(&file, buffer, status, &ierr);
    check_success(ierr, "mpi_file_read_at_all_end");
    mpi_file_write_ordered_begin_(&file, buffer, &zero_count, &dtype, &ierr);
    check_success(ierr, "mpi_file_write_ordered_begin");
    mpi_file_write_ordered_end_(&file, buffer, status, &ierr);
    check_success(ierr, "mpi_file_write_ordered_end");
    mpi_file_read_ordered_begin_(&file, buffer, &zero_count, &dtype, &ierr);
    check_success(ierr, "mpi_file_read_ordered_begin");
    mpi_file_read_ordered_end_(&file, buffer, status, &ierr);
    check_success(ierr, "mpi_file_read_ordered_end");

    mpi_file_sync_(&file, &ierr);
    check_success(ierr, "mpi_file_sync");
    mpi_file_close_(&file, &ierr);
    check_success(ierr, "mpi_file_close");
    if (info != VAPAA_MPI_INFO_NULL) {
        mpi_info_free_(&info, &ierr);
        check_success(ierr, "mpi_info_free file");
    }
}

static void run_missing_error_request_datarep_wrappers(void)
{
    int ierr = MPI_SUCCESS;
    int requests[2] = {VAPAA_MPI_REQUEST_NULL, VAPAA_MPI_REQUEST_NULL};
    int status[8] = {0};
    int statuses[16] = {0};
    int indices[2] = {-1, -1};
    int count = 2;
    int flag = 0;
    int index = -1;
    int outcount = -1;

    mpi_request_get_status_(&requests[0], &flag, status, &ierr);
    check_success_or_unsupported(ierr, "mpi_request_get_status");
    mpi_request_get_status_all_(&count, requests, &flag, statuses, &ierr);
    check_success_or_unsupported(ierr, "mpi_request_get_status_all");
    mpi_request_get_status_any_(&count, requests, &index, &flag, status,
                                &ierr);
    check_success_or_unsupported(ierr, "mpi_request_get_status_any");
    mpi_request_get_status_some_(&count, requests, &outcount, indices,
                                 statuses, &ierr);
    check_success_or_unsupported(ierr, "mpi_request_get_status_some");

    {
        int errorclass = VAPAA_MPI_ERR_OTHER;
        int errorcode = VAPAA_MPI_ERR_OTHER;
        char error_string[] = "f77 custom error";

        mpi_add_error_class_(&errorclass, &ierr);
        check_success(ierr, "mpi_add_error_class");
        mpi_add_error_code_(&errorclass, &errorcode, &ierr);
        check_success(ierr, "mpi_add_error_code");
        mpi_add_error_string_(&errorcode, error_string, &ierr,
                              strlen(error_string));
        check_success(ierr, "mpi_add_error_string");
        mpi_remove_error_string_(&errorcode, &ierr);
        check_success_or_unsupported(ierr, "mpi_remove_error_string");
        mpi_remove_error_code_(&errorcode, &ierr);
        check_success_or_unsupported(ierr, "mpi_remove_error_code");
        mpi_remove_error_class_(&errorclass, &ierr);
        check_success_or_unsupported(ierr, "mpi_remove_error_class");
    }

    {
        char datarep[64];
        intptr_t extra_state = 7;

        snprintf(datarep, sizeof(datarep), "vapaa_f77_datarep_%d", g_rank);
        mpi_register_datarep_(datarep, (vapaa_c_funptr)legacy_datarep_read,
                              (vapaa_c_funptr)legacy_datarep_write,
                              (vapaa_c_funptr)legacy_datarep_extent,
                              &extra_state, &ierr, strlen(datarep));
        check_datarep_registration(ierr, "mpi_register_datarep");

        snprintf(datarep, sizeof(datarep), "vapaa_f77_datarep_c_%d", g_rank);
        mpi_register_datarep_c_(datarep,
                                (vapaa_c_funptr)legacy_datarep_read_c,
                                (vapaa_c_funptr)legacy_datarep_write_c,
                                (vapaa_c_funptr)legacy_datarep_extent,
                                &extra_state, &ierr, strlen(datarep));
        check_datarep_registration(ierr, "mpi_register_datarep_c");
    }
}

static void run_missing_datatype_wrappers(void)
{
    int ierr = MPI_SUCCESS;
    int dtype = VAPAA_MPI_INTEGER;
    int contiguous = VAPAA_MPI_DATATYPE_NULL;
    int indexed = VAPAA_MPI_DATATYPE_NULL;
    int darray = VAPAA_MPI_DATATYPE_NULL;
    int f90_integer = VAPAA_MPI_DATATYPE_NULL;
    int f90_integer_again = VAPAA_MPI_DATATYPE_NULL;
    int f90_real = VAPAA_MPI_DATATYPE_NULL;
    int f90_complex = VAPAA_MPI_DATATYPE_NULL;
    int matched = VAPAA_MPI_DATATYPE_NULL;
    int pair = VAPAA_MPI_DATATYPE_NULL;
    int two = 2;
    int blocklengths[2] = {1, 1};
    int displacements[2] = {0, 2};
    int nints = 0, nadds = 0, ntypes = 0, combiner = 0;
    int ints[4] = {0, 0, 0, 0};
    intptr_t addrs[4] = {0, 0, 0, 0};
    int types[4] = {0, 0, 0, 0};
    intptr_t extent = 0;
    int64_t lb_x = 0, extent_x = 0, size_x = 0;
    int darray_size = 1;
    int darray_rank = 0;
    int ndims = 1;
    int gsizes[1] = {4};
    int distribs[1] = {VAPAA_MPI_DISTRIBUTE_NONE};
    int dargs[1] = {VAPAA_MPI_DISTRIBUTE_DFLT_DARG};
    int psizes[1] = {1};
    int order = VAPAA_MPI_ORDER_C;
    int typeclass = VAPAA_MPI_TYPECLASS_INTEGER;
    int type_size = 4;
    int p = 6;
    int r = 9;

    mpi_type_contiguous_(&two, &dtype, &contiguous, &ierr);
    check_success(ierr, "mpi_type_contiguous");
    free_type_if_live(&contiguous, "mpi_type_free contiguous");

    mpi_type_indexed_(&two, blocklengths, displacements, &dtype, &indexed,
                      &ierr);
    check_success(ierr, "mpi_type_indexed");
    free_type_if_live(&indexed, "mpi_type_free indexed");

    mpi_type_create_darray_(&darray_size, &darray_rank, &ndims, gsizes,
                            distribs, dargs, psizes, &order, &dtype, &darray,
                            &ierr);
    check_success(ierr, "mpi_type_create_darray");
    free_type_if_live(&darray, "mpi_type_free darray");

    mpi_type_create_f90_integer_(&r, &f90_integer, &ierr);
    check_success(ierr, "mpi_type_create_f90_integer");
    mpi_type_create_f90_integer_(&r, &f90_integer_again, &ierr);
    check_success(ierr, "mpi_type_create_f90_integer cached");
    mpi_type_create_f90_real_(&p, &r, &f90_real, &ierr);
    check_success(ierr, "mpi_type_create_f90_real");
    mpi_type_create_f90_complex_(&p, &r, &f90_complex, &ierr);
    check_success(ierr, "mpi_type_create_f90_complex");

    mpi_type_get_envelope_(&f90_integer, &nints, &nadds, &ntypes, &combiner,
                           &ierr);
    check_success(ierr, "mpi_type_get_envelope f90");
    mpi_type_get_contents_(&f90_integer, &nints, &nadds, &ntypes, ints, addrs,
                           types, &ierr);
    check_success(ierr, "mpi_type_get_contents f90");

    mpi_type_extent_(&dtype, &extent, &ierr);
    check_success(ierr, "mpi_type_extent");
    mpi_type_get_extent_x_(&dtype, &lb_x, &extent_x, &ierr);
    check_success(ierr, "mpi_type_get_extent_x");
    mpi_type_get_true_extent_x_(&dtype, &lb_x, &extent_x, &ierr);
    check_success(ierr, "mpi_type_get_true_extent_x");
    VAPAA_MPI_Type_get_extent_x(&dtype, &lb_x, &extent_x, &ierr);
    check_success(ierr, "VAPAA_MPI_Type_get_extent_x");
    VAPAA_MPI_Type_get_true_extent_x(&dtype, &lb_x, &extent_x, &ierr);
    check_success(ierr, "VAPAA_MPI_Type_get_true_extent_x");
    mpi_type_size_x_(&dtype, &size_x, &ierr);
    check_success(ierr, "mpi_type_size_x");
    mpi_type_match_size_(&typeclass, &type_size, &matched, &ierr);
    check_success(ierr, "mpi_type_match_size");
    mpi_type_get_value_index_(&dtype, &dtype, &pair, &ierr);
    check_success_or_unsupported(ierr, "mpi_type_get_value_index");
}

static void run_missing_win_wrappers(void)
{
    int ierr = MPI_SUCCESS;
    int self = VAPAA_MPI_COMM_SELF;
    int info = VAPAA_MPI_INFO_NULL;
    int errors_return = VAPAA_MPI_ERRORS_RETURN;
    int disp_unit = (int)sizeof(int);
    int rank = 0;
    int win = VAPAA_MPI_WIN_NULL;
    int allocated_win = VAPAA_MPI_WIN_NULL;
    int shared_win = VAPAA_MPI_WIN_NULL;
    int dynamic_win = VAPAA_MPI_WIN_NULL;
    int group = VAPAA_MPI_GROUP_NULL;
    int assert = VAPAA_MPI_MODE_NOCHECK;
    int flag = 0;
    int keyval = 0;
    int errorcode = VAPAA_MPI_ERR_OTHER;
    int errhandler = VAPAA_MPI_ERRHANDLER_NULL;
    int basebuf[4] = {0, 0, 0, 0};
    int dynbuf[2] = {0, 0};
    intptr_t size = sizeof(basebuf);
    intptr_t dyn_size = sizeof(dynbuf);
    intptr_t out_size = 0;
    intptr_t extra = 0;
    intptr_t attr_in = 17;
    intptr_t attr_out = 0;
    void *baseptr = NULL;
    void *queryptr = NULL;

    mpi_info_create_(&info, &ierr);
    check_success(ierr, "mpi_info_create win");

    mpi_win_allocate_(&size, &disp_unit, &info, &self, &baseptr,
                      &allocated_win, &ierr);
    check_success_or_unsupported(ierr, "mpi_win_allocate");
    if (ierr == MPI_SUCCESS) {
        mpi_win_set_errhandler_(&allocated_win, &errors_return, &ierr);
        check_success(ierr, "mpi_win_set_errhandler allocated");
        mpi_win_set_info_(&allocated_win, &info, &ierr);
        check_success(ierr, "mpi_win_set_info allocated");
        mpi_win_free_(&allocated_win, &ierr);
        check_success(ierr, "mpi_win_free allocated");
    }

    mpi_win_allocate_shared_(&size, &disp_unit, &info, &self, &baseptr,
                             &shared_win, &ierr);
    check_success_or_unavailable(ierr, "mpi_win_allocate_shared");
    if (ierr == MPI_SUCCESS) {
        mpi_win_shared_query_(&shared_win, &rank, &out_size, &disp_unit,
                              &queryptr, &ierr);
        check_success(ierr, "mpi_win_shared_query");
        mpi_win_free_(&shared_win, &ierr);
        check_success(ierr, "mpi_win_free shared");
    }

    mpi_win_create_(basebuf, &size, &disp_unit, &info, &self, &win, &ierr);
    check_success(ierr, "mpi_win_create");
    if (ierr == MPI_SUCCESS) {
        mpi_win_set_errhandler_(&win, &errors_return, &ierr);
        check_success(ierr, "mpi_win_set_errhandler");
        mpi_win_call_errhandler_(&win, &errorcode, &ierr);
        check_success(ierr, "mpi_win_call_errhandler");

        mpi_win_get_group_(&win, &group, &ierr);
        check_success(ierr, "mpi_win_get_group");
        mpi_win_post_(&group, &assert, &win, &ierr);
        check_success(ierr, "mpi_win_post");
        mpi_win_start_(&group, &assert, &win, &ierr);
        check_success(ierr, "mpi_win_start");
        mpi_win_complete_(&win, &ierr);
        check_success(ierr, "mpi_win_complete");
        mpi_win_wait_(&win, &ierr);
        check_success(ierr, "mpi_win_wait");

        mpi_win_post_(&group, &assert, &win, &ierr);
        check_success(ierr, "mpi_win_post test");
        mpi_win_start_(&group, &assert, &win, &ierr);
        check_success(ierr, "mpi_win_start test");
        mpi_win_complete_(&win, &ierr);
        check_success(ierr, "mpi_win_complete test");
        do {
            mpi_win_test_(&win, &flag, &ierr);
            check_success(ierr, "mpi_win_test");
        } while (ierr == MPI_SUCCESS && !flag);

        mpi_group_free_(&group, &ierr);
        check_success(ierr, "mpi_group_free win group");
        mpi_win_free_(&win, &ierr);
        check_success(ierr, "mpi_win_free");
    }

    mpi_win_create_dynamic_(&info, &self, &dynamic_win, &ierr);
    check_success(ierr, "mpi_win_create_dynamic");
    if (ierr == MPI_SUCCESS) {
        mpi_win_set_errhandler_(&dynamic_win, &errors_return, &ierr);
        check_success(ierr, "mpi_win_set_errhandler dynamic");
        mpi_win_attach_(&dynamic_win, dynbuf, &dyn_size, &ierr);
        check_success(ierr, "mpi_win_attach dynamic");
        mpi_win_detach_(&dynamic_win, dynbuf, &ierr);
        check_success(ierr, "mpi_win_detach dynamic");
        mpi_win_free_(&dynamic_win, &ierr);
        check_success(ierr, "mpi_win_free dynamic");
    }

    mpi_win_create_errhandler_((vapaa_c_funptr)legacy_comm_errhandler,
                               &errhandler, &ierr);
    check_success(ierr, "mpi_win_create_errhandler");
    if (ierr == MPI_SUCCESS) {
        mpi_errhandler_free_(&errhandler, &ierr);
        check_success(ierr, "mpi_win errhandler free");
    }

    mpi_win_null_copy_fn_(&win, &keyval, &extra, &attr_in, &attr_out, &flag,
                          &ierr);
    check_success(ierr, "mpi_win_null_copy_fn");
    mpi_win_dup_fn_(&win, &keyval, &extra, &attr_in, &attr_out, &flag, &ierr);
    check_success(ierr, "mpi_win_dup_fn");

    if (info != VAPAA_MPI_INFO_NULL) {
        mpi_info_free_(&info, &ierr);
        check_success(ierr, "mpi_info_free win");
    }
}

int main(void)
{
    int ierr = MPI_SUCCESS;
    int world = VAPAA_MPI_COMM_WORLD;

    mpi_init_(&ierr);
    check_success(ierr, "mpi_init");
    mpi_comm_rank_(&world, &g_rank, &ierr);
    check_success(ierr, "mpi_comm_rank");
    mpi_comm_size_(&world, &g_size, &ierr);
    check_success(ierr, "mpi_comm_size");

    run_basic_legacy_wrappers();
    run_missing_comm_group_wrappers();
    run_legacy_trampoline_slots();
    run_missing_memory_status_and_p2p();
    run_missing_file_wrappers();
    run_missing_error_request_datarep_wrappers();
    run_missing_datatype_wrappers();
    run_missing_win_wrappers();

    mpi_finalize_(&ierr);
    check_success(ierr, "mpi_finalize");

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
