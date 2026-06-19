// SPDX-License-Identifier: MIT
//
// Generated missing mpif.h entry points for Vapaa legacy bindings.

#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "detect_sentinels.h"
#include "vapaa_constants.h"

typedef void (*vapaa_c_funptr)(void);

static void f77_store_logical(int *flag, int value)
{
    *flag = value ? 1 : 0;
}

static void *f77_addr(void *addr)
{
    return C_IS_MPI_BOTTOM(addr) ? MPI_BOTTOM : addr;
}

static const void *f77_const_addr(const void *addr)
{
    return C_IS_MPI_BOTTOM(addr) ? MPI_BOTTOM : addr;
}

static const void *f77_in_addr(const void *addr)
{
    return C_IS_MPI_IN_PLACE(addr) ? MPI_IN_PLACE : f77_const_addr(addr);
}

static char *f77_string_to_c(const char *src, size_t len)
{
    while (len > 0 && src[len - 1] == ' ') {
        --len;
    }
    char *dst = malloc(len + 1);
    if (dst == NULL) {
        return NULL;
    }
    memcpy(dst, src, len);
    dst[len] = '\0';
    return dst;
}

static void c_string_to_f77(char *dst, size_t dst_len, const char *src)
{
    size_t src_len = strlen(src);
    if (src_len > dst_len) {
        src_len = dst_len;
    }
    memcpy(dst, src, src_len);
    if (src_len < dst_len) {
        memset(dst + src_len, ' ', dst_len - src_len);
    }
}

enum {
    F77_MPI_STATUS_SIZE = 8,
    F77_MPI_SOURCE = 0,
    F77_MPI_TAG = 1,
    F77_MPI_ERROR = 2,
    F77_MPI_INTERNAL = 3
};

static void f77_status_to_struct(const int status_f77[], struct F_MPI_Status *status)
{
    memset(status, 0, sizeof(*status));
    status->MPI_SOURCE = status_f77[F77_MPI_SOURCE];
    status->MPI_TAG = status_f77[F77_MPI_TAG];
    status->MPI_ERROR = status_f77[F77_MPI_ERROR];
#if defined(MPI_ABI)
    for (int i = 0; i < 5; i++) {
        status->MPI_internal[i] = status_f77[F77_MPI_INTERNAL + i];
    }
#elif defined(MPICH)
    status->count_lo = status_f77[F77_MPI_INTERNAL];
    status->count_hi_and_cancelled = status_f77[F77_MPI_INTERNAL + 1];
#elif defined(OPEN_MPI)
    status->cancelled = status_f77[F77_MPI_INTERNAL];
    memcpy(&status->ucount, &status_f77[F77_MPI_INTERNAL + 1], sizeof(status->ucount));
#endif
}

static void f77_status_from_struct(const struct F_MPI_Status *status, int status_f77[])
{
    for (int i = 0; i < F77_MPI_STATUS_SIZE; i++) {
        status_f77[i] = 0;
    }
    status_f77[F77_MPI_SOURCE] = status->MPI_SOURCE;
    status_f77[F77_MPI_TAG] = status->MPI_TAG;
    status_f77[F77_MPI_ERROR] = status->MPI_ERROR;
#if defined(MPI_ABI)
    for (int i = 0; i < 5; i++) {
        status_f77[F77_MPI_INTERNAL + i] = status->MPI_internal[i];
    }
#elif defined(MPICH)
    status_f77[F77_MPI_INTERNAL] = status->count_lo;
    status_f77[F77_MPI_INTERNAL + 1] = status->count_hi_and_cancelled;
#elif defined(OPEN_MPI)
    status_f77[F77_MPI_INTERNAL] = status->cancelled;
    memcpy(&status_f77[F77_MPI_INTERNAL + 1], &status->ucount, sizeof(status->ucount));
#endif
}

static struct F_MPI_Status *f77_status_arg(int *status_f77, struct F_MPI_Status *status)
{
    if (C_IS_MPI_STATUS_IGNORE(status_f77)) {
        return (struct F_MPI_Status *)status_f77;
    }
    f77_status_to_struct(status_f77, status);
    return status;
}

static struct F_MPI_Status *f77_status_out_arg(int *status_f77, struct F_MPI_Status *status)
{
    if (C_IS_MPI_STATUS_IGNORE(status_f77)) {
        return (struct F_MPI_Status *)status_f77;
    }
    memset(status, 0, sizeof(*status));
    status->MPI_ERROR = status_f77[F77_MPI_ERROR];
    return status;
}

static void f77_status_store(int *status_f77, const struct F_MPI_Status *status)
{
    if (!C_IS_MPI_STATUS_IGNORE(status_f77)) {
        f77_status_from_struct(status, status_f77);
    }
}

static MPI_Status *f77_native_status_out_arg(int *status_f77, MPI_Status *status)
{
    if (C_IS_MPI_STATUS_IGNORE(status_f77)) {
        return MPI_STATUS_IGNORE;
    }
    memset(status, 0, sizeof(*status));
    status->MPI_ERROR = status_f77[F77_MPI_ERROR];
    return status;
}

static void f77_native_status_store(int *status_f77, const MPI_Status *status)
{
    struct F_MPI_Status f_status;
    if (!C_IS_MPI_STATUS_IGNORE(status_f77)) {
        C_MPI_STATUS_FROM_C(status, &f_status);
        f77_status_from_struct(&f_status, status_f77);
    }
}

static struct F_MPI_Status *f77_statuses_out_arg(int count, int statuses_f77[], int *ierror)
{
    if (C_IS_MPI_STATUSES_IGNORE(statuses_f77)) {
        return (struct F_MPI_Status *)statuses_f77;
    }
    struct F_MPI_Status *statuses = calloc((size_t)(count > 0 ? count : 1), sizeof(*statuses));
    if (statuses == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return NULL;
    }
    for (int i = 0; i < count; i++) {
        statuses[i].MPI_ERROR = statuses_f77[i * F77_MPI_STATUS_SIZE + F77_MPI_ERROR];
    }
    return statuses;
}

static void f77_statuses_store_free(int count, int statuses_f77[], struct F_MPI_Status statuses[])
{
    if (!C_IS_MPI_STATUSES_IGNORE(statuses_f77)) {
        for (int i = 0; i < count; i++) {
            f77_status_from_struct(&statuses[i], &statuses_f77[i * F77_MPI_STATUS_SIZE]);
        }
        free(statuses);
    }
}

static MPI_Datatype *f77_datatypes_from_ints(int count, const int types_f[])
{
    MPI_Datatype *types = malloc((size_t)(count > 0 ? count : 1) * sizeof(*types));
    if (types == NULL) {
        return NULL;
    }
    for (int i = 0; i < count; i++) {
        types[i] = C_MPI_TYPE_FROMINT(types_f[i]);
    }
    return types;
}

static MPI_Aint *f77_aints_from_intptrs(int count, const intptr_t values[])
{
    MPI_Aint *aints = malloc((size_t)(count > 0 ? count : 1) * sizeof(*aints));
    if (aints == NULL) {
        return NULL;
    }
    for (int i = 0; i < count; i++) {
        aints[i] = (MPI_Aint)values[i];
    }
    return aints;
}

static void f77_request_store(MPI_Request request, int *request_f)
{
    *request_f = C_MPI_REQUEST_TOINT(request);
}

MAYBE_UNUSED static void f77_unsupported_request(int *request_f, int *ierror)
{
    *request_f = VAPAA_MPI_REQUEST_NULL;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    C_MPI_RC_FIX(*ierror);
}

void mpi_win_null_copy_fn_(int *oldwin, int *keyval, intptr_t *extra, intptr_t *attr_in,
                           intptr_t *attr_out, int *flag, int *ierror)
{
    (void)oldwin; (void)keyval; (void)extra; (void)attr_in; (void)attr_out;
    f77_store_logical(flag, 0);
    *ierror = VAPAA_MPI_SUCCESS;
}

void mpi_win_null_delete_fn_(int *win, int *keyval, intptr_t *attr, intptr_t *extra, int *ierror)
{
    (void)win; (void)keyval; (void)attr; (void)extra;
    *ierror = VAPAA_MPI_SUCCESS;
}

void mpi_win_dup_fn_(int *oldwin, int *keyval, intptr_t *extra, intptr_t *attr_in,
                     intptr_t *attr_out, int *flag, int *ierror)
{
    (void)oldwin; (void)keyval; (void)extra;
    *attr_out = *attr_in;
    f77_store_logical(flag, 1);
    *ierror = VAPAA_MPI_SUCCESS;
}

static int f77_amode_f2c(int f)
{
#if MPI_VERSION >= 5
    return f;
#else
    int c = 0;
    if (f & VAPAA_MPI_MODE_APPEND) c |= MPI_MODE_APPEND;
    if (f & VAPAA_MPI_MODE_CREATE) c |= MPI_MODE_CREATE;
    if (f & VAPAA_MPI_MODE_DELETE_ON_CLOSE) c |= MPI_MODE_DELETE_ON_CLOSE;
    if (f & VAPAA_MPI_MODE_EXCL) c |= MPI_MODE_EXCL;
    if (f & VAPAA_MPI_MODE_RDONLY) c |= MPI_MODE_RDONLY;
    if (f & VAPAA_MPI_MODE_RDWR) c |= MPI_MODE_RDWR;
    if (f & VAPAA_MPI_MODE_SEQUENTIAL) c |= MPI_MODE_SEQUENTIAL;
    if (f & VAPAA_MPI_MODE_UNIQUE_OPEN) c |= MPI_MODE_UNIQUE_OPEN;
    if (f & VAPAA_MPI_MODE_WRONLY) c |= MPI_MODE_WRONLY;
    return c;
#endif
}

MAYBE_UNUSED static int f77_seek_f2c(int f)
{
#if MPI_VERSION >= 5
    return f;
#else
    if (f == VAPAA_MPI_SEEK_CUR) return MPI_SEEK_CUR;
    if (f == VAPAA_MPI_SEEK_END) return MPI_SEEK_END;
    if (f == VAPAA_MPI_SEEK_SET) return MPI_SEEK_SET;
    return f;
#endif
}

MAYBE_UNUSED static int f77_assert_f2c(int f)
{
#if MPI_VERSION >= 5
    return f;
#else
    int c = 0;
    if (f & VAPAA_MPI_MODE_NOCHECK) c |= MPI_MODE_NOCHECK;
    if (f & VAPAA_MPI_MODE_NOPRECEDE) c |= MPI_MODE_NOPRECEDE;
    if (f & VAPAA_MPI_MODE_NOPUT) c |= MPI_MODE_NOPUT;
    if (f & VAPAA_MPI_MODE_NOSTORE) c |= MPI_MODE_NOSTORE;
    if (f & VAPAA_MPI_MODE_NOSUCCEED) c |= MPI_MODE_NOSUCCEED;
    return c;
#endif
}

MAYBE_UNUSED static int f77_lock_f2c(int f)
{
#if MPI_VERSION >= 5
    return f;
#else
    if (f == VAPAA_MPI_LOCK_EXCLUSIVE) return MPI_LOCK_EXCLUSIVE;
    if (f == VAPAA_MPI_LOCK_SHARED) return MPI_LOCK_SHARED;
    return f;
#endif
}

static MPI_Offset f77_offset_f2c(int64_t offset)
{
    return offset == VAPAA_MPI_DISPLACEMENT_CURRENT ? MPI_DISPLACEMENT_CURRENT : (MPI_Offset)offset;
}

intptr_t mpi_aint_add_(intptr_t *base, intptr_t *disp)
{
    extern intptr_t VAPAA_MPI_Aint_add(intptr_t base, intptr_t disp);
    return VAPAA_MPI_Aint_add(*base, *disp);
}

intptr_t mpi_aint_diff_(intptr_t *addr1, intptr_t *addr2)
{
    extern intptr_t VAPAA_MPI_Aint_diff(intptr_t addr1, intptr_t addr2);
    return VAPAA_MPI_Aint_diff(*addr1, *addr2);
}

extern void C_MPI_Abi_get_fortran_booleans(int * logical_size, void * logical_true, void * logical_false, int * is_set, int * ierror);
void mpi_abi_get_fortran_booleans_(int * logical_size, void * logical_true, void * logical_false, int * is_set, int * ierror)
{
    C_MPI_Abi_get_fortran_booleans(logical_size, logical_true, logical_false, is_set, ierror);
}

extern void C_MPI_Abi_get_fortran_info(int * info_f, int * ierror);
void mpi_abi_get_fortran_info_(int * info_f, int * ierror)
{
    C_MPI_Abi_get_fortran_info(info_f, ierror);
}

extern void C_MPI_Abi_get_info(int * info_f, int * ierror);
void mpi_abi_get_info_(int * info_f, int * ierror)
{
    C_MPI_Abi_get_info(info_f, ierror);
}

extern void C_MPI_Abi_get_version(int * abi_major, int * abi_minor, int * ierror);
void mpi_abi_get_version_(int * abi_major, int * abi_minor, int * ierror)
{
    C_MPI_Abi_get_version(abi_major, abi_minor, ierror);
}

extern void C_MPI_Abi_set_fortran_booleans(int * logical_size, void * logical_true, void * logical_false, int * ierror);
void mpi_abi_set_fortran_booleans_(int * logical_size, void * logical_true, void * logical_false, int * ierror)
{
    C_MPI_Abi_set_fortran_booleans(logical_size, logical_true, logical_false, ierror);
}

extern void C_MPI_Abi_set_fortran_info(int * info_f, int * ierror);
void mpi_abi_set_fortran_info_(int * info_f, int * ierror)
{
    C_MPI_Abi_set_fortran_info(info_f, ierror);
}

void mpi_accumulate_(void *origin_addr, int *origin_count, int *origin_datatype_f, int *target_rank, intptr_t *target_disp, int *target_count, int *target_datatype_f, int *op_f, int *win_f, int *ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Accumulate(f77_const_addr(origin_addr), *origin_count, origin_datatype, C_MPI_DEST_F2C(*target_rank), (MPI_Aint)*target_disp, *target_count, target_datatype, op, win);
    C_MPI_RC_FIX(*ierror);
}

extern void C_MPI_Allgather(const void * input, int * scount, int * stype_f, void * output, int * rcount, int * rtype_f, int * comm_f, int * ierror);
void mpi_allgather_(const void * input, int * scount, int * stype_f, void * output, int * rcount, int * rtype_f, int * comm_f, int * ierror)
{
    C_MPI_Allgather(input, scount, stype_f, output, rcount, rtype_f, comm_f, ierror);
}

void mpi_allgather_init_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Allgather_init(f77_in_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), *recvcount, recvtype, comm, info, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcount; (void)sendtype_f; (void)recvbuf; (void)recvcount; (void)recvtype_f;  (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

extern void C_MPI_Allgatherv(const void * input, int * scount, int * stype_f, void * output, const int rcounts[], const int rdisps[], int * rtype_f, int * comm_f, int * ierror);
void mpi_allgatherv_(const void * input, int * scount, int * stype_f, void * output, const int rcounts[], const int rdisps[], int * rtype_f, int * comm_f, int * ierror)
{
    C_MPI_Allgatherv(input, scount, stype_f, output, rcounts, rdisps, rtype_f, comm_f, ierror);
}

void mpi_allgatherv_init_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, const int recvcounts[], const int displs[], int *recvtype_f, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Allgatherv_init(f77_in_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), recvcounts, displs, recvtype, comm, info, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcount; (void)sendtype_f; (void)recvbuf; (void)recvcounts; (void)displs; (void)recvtype_f; (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

extern void VAPAA_MPI_Alloc_mem(intptr_t *size_f, int *info_f, void **baseptr, int *ierror);
void mpi_alloc_mem_(intptr_t *size_f, int *info_f, void **baseptr, int *ierror)
{
    VAPAA_MPI_Alloc_mem(size_f, info_f, baseptr, ierror);
}

void mpi_allreduce_init_(const void *sendbuf, void *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Allreduce_init(f77_in_addr(sendbuf), f77_addr(recvbuf), *count, datatype, op, comm, info, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)recvbuf; (void)count; (void)datatype_f; (void)op_f;  (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_alltoall_init_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Alltoall_init(f77_in_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), *recvcount, recvtype, comm, info, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcount; (void)sendtype_f; (void)recvbuf; (void)recvcount; (void)recvtype_f;  (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_alltoallv_init_(const void *sendbuf, const int sendcounts[], const int sdispls[], int *sendtype_f, void *recvbuf, const int recvcounts[], const int rdispls[], int *recvtype_f, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Alltoallv_init(f77_in_addr(sendbuf), sendcounts, sdispls, sendtype, f77_addr(recvbuf), recvcounts, rdispls, recvtype, comm, info, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcounts; (void)sdispls; (void)sendtype_f; (void)recvbuf; (void)recvcounts; (void)rdispls; (void)recvtype_f; (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_alltoallw_init_(const void *sendbuf, const int sendcounts[], const int sdispls[], const int sendtypes_f[], void *recvbuf, const int recvcounts[], const int rdispls[], const int recvtypes_f[], int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    int comm_size = 0; *ierror = MPI_Comm_size(comm, &comm_size); if (*ierror != MPI_SUCCESS) { C_MPI_RC_FIX(*ierror); return; }
    MPI_Datatype *sendtypes = f77_datatypes_from_ints(comm_size, sendtypes_f);
    MPI_Datatype *recvtypes = f77_datatypes_from_ints(comm_size, recvtypes_f);
    if (sendtypes == NULL || recvtypes == NULL) { free(sendtypes); free(recvtypes); *ierror = MPI_ERR_OTHER; C_MPI_RC_FIX(*ierror); return; }
    *ierror = MPI_Alltoallw_init(f77_in_addr(sendbuf), sendcounts, sdispls, sendtypes, f77_addr(recvbuf), recvcounts, rdispls, recvtypes, comm, info, &request);
    free(sendtypes); free(recvtypes); f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcounts; (void)sdispls; (void)sendtypes_f; (void)recvbuf; (void)recvcounts; (void)rdispls; (void)recvtypes_f; (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

extern void VAPAA_MPI_Barrier_init(int *comm_f, int *info_f, int *request_f, int *ierror);
void mpi_barrier_init_(int *comm_f, int *info_f, int *request_f, int *ierror)
{
    VAPAA_MPI_Barrier_init(comm_f, info_f, request_f, ierror);
}

void mpi_bcast_init_(void *buffer, int *count, int *datatype_f, int *root, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Bcast_init(f77_addr(buffer), *count, datatype, C_MPI_ROOT_F2C(*root), comm, info, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
#else
    (void)buffer; (void)count; (void)datatype_f; (void)root; (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

extern void C_MPI_Buffer_flush(int * ierror);
void mpi_buffer_flush_(int * ierror)
{
    C_MPI_Buffer_flush(ierror);
}

extern void C_MPI_Buffer_iflush(int * request_f, int * ierror);
void mpi_buffer_iflush_(int * request_f, int * ierror)
{
    C_MPI_Buffer_iflush(request_f, ierror);
}

extern void C_MPI_Cart_coords(int * comm_f, int * rank, int * maxdims, int * coords, int * ierror);
void mpi_cart_coords_(int * comm_f, int * rank, int * maxdims, int * coords, int * ierror)
{
    C_MPI_Cart_coords(comm_f, rank, maxdims, coords, ierror);
}

extern void C_MPI_Cart_map(int * comm_f, int * ndims, int * dims, int * periods, int * newrank, int * ierror);
void mpi_cart_map_(int * comm_f, int * ndims, int * dims, int * periods, int * newrank, int * ierror)
{
    C_MPI_Cart_map(comm_f, ndims, dims, periods, newrank, ierror);
}

extern void C_MPI_Cart_rank(int * comm_f, int * coords, int * rank, int * ierror);
void mpi_cart_rank_(int * comm_f, int * coords, int * rank, int * ierror)
{
    C_MPI_Cart_rank(comm_f, coords, rank, ierror);
}

extern void C_MPI_Cart_sub(int * comm_f, int * remain_dims, int * newcomm_f, int * ierror);
void mpi_cart_sub_(int * comm_f, int * remain_dims, int * newcomm_f, int * ierror)
{
    C_MPI_Cart_sub(comm_f, remain_dims, newcomm_f, ierror);
}

extern void C_MPI_Cartdim_get(int * comm_f, int * ndims, int * ierror);
void mpi_cartdim_get_(int * comm_f, int * ndims, int * ierror)
{
    C_MPI_Cartdim_get(comm_f, ndims, ierror);
}

void mpi_close_port_(char *port_name, int *ierror, size_t port_name_len)
{
    char *port_c = f77_string_to_c(port_name, port_name_len);
    if (port_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    *ierror = MPI_Close_port(port_c);
    free(port_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_comm_accept_(char *port_name, int *info_f, int *root, int *comm_f, int *newcomm_f, int *ierror, size_t port_name_len)
{
    char *port_c = f77_string_to_c(port_name, port_name_len);
    if (port_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f), newcomm = MPI_COMM_NULL;
    *ierror = MPI_Comm_accept(port_c, info, C_MPI_ROOT_F2C(*root), comm, &newcomm);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    free(port_c); C_MPI_RC_FIX(*ierror);
}

void mpi_comm_attach_buffer_(int *comm_f, void *buffer, int *size, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_attach_buffer(comm, f77_addr(buffer), *size);
#else
    (void)comm_f; (void)buffer; (void)size; *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

extern void C_MPI_Comm_compare(int * comm1_f, int * comm2_f, int * result_f, int * ierror);
void mpi_comm_compare_(int * comm1_f, int * comm2_f, int * result_f, int * ierror)
{
    C_MPI_Comm_compare(comm1_f, comm2_f, result_f, ierror);
}

void mpi_comm_connect_(char *port_name, int *info_f, int *root, int *comm_f, int *newcomm_f, int *ierror, size_t port_name_len)
{
    char *port_c = f77_string_to_c(port_name, port_name_len);
    if (port_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f), newcomm = MPI_COMM_NULL;
    *ierror = MPI_Comm_connect(port_c, info, C_MPI_ROOT_F2C(*root), comm, &newcomm);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    free(port_c); C_MPI_RC_FIX(*ierror);
}

extern void C_MPI_Comm_create(int * comm_f, int * group_f, int * newcomm_f, int * ierror);
void mpi_comm_create_(int * comm_f, int * group_f, int * newcomm_f, int * ierror)
{
    C_MPI_Comm_create(comm_f, group_f, newcomm_f, ierror);
}

void mpi_comm_create_from_group_(int *group_f, char *stringtag, int *info_f, int *errhandler_f, int *newcomm_f, int *ierror, size_t stringtag_len)
{
#if MPI_VERSION >= 4
    char *tag_c = f77_string_to_c(stringtag, stringtag_len);
    if (tag_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    MPI_Group group = C_MPI_GROUP_FROMINT(*group_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f); MPI_Errhandler errhandler = C_MPI_ERRHANDLER_FROMINT(*errhandler_f); MPI_Comm newcomm = MPI_COMM_NULL;
    *ierror = MPI_Comm_create_from_group(group, tag_c, info, errhandler, &newcomm);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm); free(tag_c); C_MPI_RC_FIX(*ierror);
#else
    (void)group_f; (void)stringtag; (void)info_f; (void)errhandler_f; (void)stringtag_len; *newcomm_f = VAPAA_MPI_COMM_NULL; *ierror = MPI_ERR_UNSUPPORTED_OPERATION; C_MPI_RC_FIX(*ierror);
#endif
}

extern void C_MPI_Comm_create_group(int * comm_f, int * group_f, int * tag_f, int * newcomm_f, int * ierror);
void mpi_comm_create_group_(int * comm_f, int * group_f, int * tag_f, int * newcomm_f, int * ierror)
{
    C_MPI_Comm_create_group(comm_f, group_f, tag_f, newcomm_f, ierror);
}

extern void VAPAA_MPI_Comm_detach_buffer(int *comm_f, void **buffer_addr, int *size, int *ierror);
void mpi_comm_detach_buffer_(int *comm_f, void **buffer_addr, int *size, int *ierror)
{
    VAPAA_MPI_Comm_detach_buffer(comm_f, buffer_addr, size, ierror);
}

extern void VAPAA_MPI_Comm_disconnect(int *comm_f, int *ierror);
void mpi_comm_disconnect_(int *comm_f, int *ierror)
{
    VAPAA_MPI_Comm_disconnect(comm_f, ierror);
}

extern void C_MPI_Comm_dup_with_info(int * comm_f, int * info_f, int * newcomm_f, int * ierror);
void mpi_comm_dup_with_info_(int * comm_f, int * info_f, int * newcomm_f, int * ierror)
{
    C_MPI_Comm_dup_with_info(comm_f, info_f, newcomm_f, ierror);
}

extern void VAPAA_MPI_Comm_flush_buffer(int *comm_f, int *ierror);
void mpi_comm_flush_buffer_(int *comm_f, int *ierror)
{
    VAPAA_MPI_Comm_flush_buffer(comm_f, ierror);
}

extern void VAPAA_MPI_Comm_get_info(int *comm_f, int *info_f, int *ierror);
void mpi_comm_get_info_(int *comm_f, int *info_f, int *ierror)
{
    VAPAA_MPI_Comm_get_info(comm_f, info_f, ierror);
}

extern void VAPAA_MPI_Comm_get_parent(int *parent_f, int *ierror);
void mpi_comm_get_parent_(int *parent_f, int *ierror)
{
    VAPAA_MPI_Comm_get_parent(parent_f, ierror);
}

extern void C_MPI_Comm_idup(int * comm_f, int * newcomm_f, int * request_f, int * ierror);
void mpi_comm_idup_(int * comm_f, int * newcomm_f, int * request_f, int * ierror)
{
    C_MPI_Comm_idup(comm_f, newcomm_f, request_f, ierror);
}

extern void C_MPI_Comm_idup_with_info(int * comm_f, int * info_f, int * newcomm_f, int * request_f, int * ierror);
void mpi_comm_idup_with_info_(int * comm_f, int * info_f, int * newcomm_f, int * request_f, int * ierror)
{
    C_MPI_Comm_idup_with_info(comm_f, info_f, newcomm_f, request_f, ierror);
}

extern void VAPAA_MPI_Comm_iflush_buffer(int *comm_f, int *request_f, int *ierror);
void mpi_comm_iflush_buffer_(int *comm_f, int *request_f, int *ierror)
{
    VAPAA_MPI_Comm_iflush_buffer(comm_f, request_f, ierror);
}

extern void VAPAA_MPI_Comm_join(int *fd, int *intercomm_f, int *ierror);
void mpi_comm_join_(int *fd, int *intercomm_f, int *ierror)
{
    VAPAA_MPI_Comm_join(fd, intercomm_f, ierror);
}

extern void VAPAA_MPI_Comm_remote_group(int *comm_f, int *group_f, int *ierror);
void mpi_comm_remote_group_(int *comm_f, int *group_f, int *ierror)
{
    VAPAA_MPI_Comm_remote_group(comm_f, group_f, ierror);
}

extern void VAPAA_MPI_Comm_set_info(int *comm_f, int *info_f, int *ierror);
void mpi_comm_set_info_(int *comm_f, int *info_f, int *ierror)
{
    VAPAA_MPI_Comm_set_info(comm_f, info_f, ierror);
}

void mpi_comm_spawn_(char *command, void *argv, int *maxprocs, int *info_f, int *root, int *comm_f, int *intercomm_f, int errcodes_f[], int *ierror, size_t command_len)
{
    (void)command; (void)argv; (void)maxprocs; (void)info_f; (void)root; (void)comm_f; (void)errcodes_f; (void)command_len;
    *intercomm_f = VAPAA_MPI_COMM_NULL;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    C_MPI_RC_FIX(*ierror);
}

void mpi_comm_spawn_multiple_(int *count, void *commands, void *argvs, int maxprocs[], int infos[], int *root, int *comm_f, int *intercomm_f, int errcodes_f[], int *ierror)
{
    (void)count; (void)commands; (void)argvs; (void)maxprocs; (void)infos; (void)root; (void)comm_f; (void)errcodes_f;
    *intercomm_f = VAPAA_MPI_COMM_NULL;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_Comm_test_inter(int *comm_f, int *flag, int *ierror);
void mpi_comm_test_inter_(int *comm_f, int *flag, int *ierror)
{
    VAPAA_MPI_Comm_test_inter(comm_f, flag, ierror);
}

void mpi_compare_and_swap_(void *origin_addr, void *compare_addr, void *result_addr, int *datatype_f, int *target_rank, intptr_t *target_disp, int *win_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Compare_and_swap(f77_const_addr(origin_addr), f77_const_addr(compare_addr), f77_addr(result_addr), datatype, C_MPI_DEST_F2C(*target_rank), (MPI_Aint)*target_disp, win);
    C_MPI_RC_FIX(*ierror);
}

void mpi_exscan_init_(const void *sendbuf, void *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Exscan_init(f77_in_addr(sendbuf), f77_addr(recvbuf), *count, datatype, op, comm, info, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)recvbuf; (void)count; (void)datatype_f; (void)op_f;  (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_fetch_and_op_(void *origin_addr, void *result_addr, int *datatype_f, int *target_rank, intptr_t *target_disp, int *op_f, int *win_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Fetch_and_op(f77_const_addr(origin_addr), f77_addr(result_addr), datatype, C_MPI_DEST_F2C(*target_rank), (MPI_Aint)*target_disp, op, win);
    C_MPI_RC_FIX(*ierror);
}

extern void C_MPI_File_call_errhandler(int * file_f, int * errorcode_f, int * ierror);
void mpi_file_call_errhandler_(int * file_f, int * errorcode_f, int * ierror)
{
    C_MPI_File_call_errhandler(file_f, errorcode_f, ierror);
}

extern void C_MPI_File_close(int * file_f, int * ierror);
void mpi_file_close_(int * file_f, int * ierror)
{
    C_MPI_File_close(file_f, ierror);
}

extern void VAPAA_MPI_File_create_errhandler(vapaa_c_funptr fn, int *errhandler_f, int *ierror);
void mpi_file_create_errhandler_(vapaa_c_funptr fn, int *errhandler_f, int *ierror)
{
    VAPAA_MPI_File_create_errhandler(fn, errhandler_f, ierror);
}

void mpi_file_delete_(char *filename, int *info_f, int *ierror, size_t filename_len)
{
    char *filename_c = f77_string_to_c(filename, filename_len);
    if (filename_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_File_delete(filename_c, info);
    free(filename_c);
    C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_File_get_amode(int *fh_f, int *amode_f, int *ierror);
void mpi_file_get_amode_(int *fh_f, int *amode_f, int *ierror)
{
    VAPAA_MPI_File_get_amode(fh_f, amode_f, ierror);
}

extern void VAPAA_MPI_File_get_atomicity(int *fh_f, int *flag, int *ierror);
void mpi_file_get_atomicity_(int *fh_f, int *flag, int *ierror)
{
    VAPAA_MPI_File_get_atomicity(fh_f, flag, ierror);
}

extern void VAPAA_MPI_File_get_byte_offset(int *fh_f, int64_t *offset_f, int64_t *disp_f, int *ierror);
void mpi_file_get_byte_offset_(int *fh_f, int64_t *offset_f, int64_t *disp_f, int *ierror)
{
    VAPAA_MPI_File_get_byte_offset(fh_f, offset_f, disp_f, ierror);
}

extern void C_MPI_File_get_errhandler(int * file_f, int * errhandler_f, int * ierror);
void mpi_file_get_errhandler_(int * file_f, int * errhandler_f, int * ierror)
{
    C_MPI_File_get_errhandler(file_f, errhandler_f, ierror);
}

extern void VAPAA_MPI_File_get_group(int *fh_f, int *group_f, int *ierror);
void mpi_file_get_group_(int *fh_f, int *group_f, int *ierror)
{
    VAPAA_MPI_File_get_group(fh_f, group_f, ierror);
}

extern void VAPAA_MPI_File_get_info(int *fh_f, int *info_f, int *ierror);
void mpi_file_get_info_(int *fh_f, int *info_f, int *ierror)
{
    VAPAA_MPI_File_get_info(fh_f, info_f, ierror);
}

extern void VAPAA_MPI_File_get_position(int *fh_f, int64_t *offset_f, int *ierror);
void mpi_file_get_position_(int *fh_f, int64_t *offset_f, int *ierror)
{
    VAPAA_MPI_File_get_position(fh_f, offset_f, ierror);
}

extern void VAPAA_MPI_File_get_position_shared(int *fh_f, int64_t *offset_f, int *ierror);
void mpi_file_get_position_shared_(int *fh_f, int64_t *offset_f, int *ierror)
{
    VAPAA_MPI_File_get_position_shared(fh_f, offset_f, ierror);
}

void mpi_file_get_size_(int *file_f, int64_t *size_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset size = 0;
    *ierror = MPI_File_get_size(file, &size);
    *size_f = (int64_t)size;
    C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_File_get_type_extent(int *fh_f, int *datatype_f, intptr_t *extent_f, int *ierror);
void mpi_file_get_type_extent_(int *fh_f, int *datatype_f, intptr_t *extent_f, int *ierror)
{
    VAPAA_MPI_File_get_type_extent(fh_f, datatype_f, extent_f, ierror);
}

void mpi_file_get_view_(int *file_f, int64_t *disp_f, int *etype_f, int *filetype_f, char *datarep, int *ierror, size_t datarep_len)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset disp = 0;
    MPI_Datatype etype = MPI_DATATYPE_NULL, filetype = MPI_DATATYPE_NULL;
    char datarep_c[VAPAA_MPI_MAX_DATAREP_STRING] = {0};
    *ierror = MPI_File_get_view(file, &disp, &etype, &filetype, datarep_c);
    *disp_f = (int64_t)disp;
    *etype_f = C_MPI_TYPE_TOINT(etype);
    *filetype_f = C_MPI_TYPE_TOINT(filetype);
    if (*ierror == MPI_SUCCESS) c_string_to_f77(datarep, datarep_len, datarep_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_iread_(int *file_f, void *buf, int *count_f, int *datatype_f, int *request_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_File_iread(file, f77_addr(buf), *count_f, datatype, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_iread_all_(int *file_f, void *buf, int *count_f, int *datatype_f, int *request_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_File_iread_all(file, f77_addr(buf), *count_f, datatype, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_iread_at_(int *file_f, int64_t *offset_f, void *buf, int *count_f, int *datatype_f, int *request_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_File_iread_at(file, f77_offset_f2c(*offset_f), f77_addr(buf), *count_f, datatype, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_iread_at_all_(int *file_f, int64_t *offset_f, void *buf, int *count_f, int *datatype_f, int *request_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_File_iread_at_all(file, f77_offset_f2c(*offset_f), f77_addr(buf), *count_f, datatype, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_iread_shared_(int *file_f, void *buf, int *count_f, int *datatype_f, int *request_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_File_iread_shared(file, f77_addr(buf), *count_f, datatype, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_iwrite_(int *file_f, void *buf, int *count_f, int *datatype_f, int *request_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_File_iwrite(file, f77_addr(buf), *count_f, datatype, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_iwrite_all_(int *file_f, void *buf, int *count_f, int *datatype_f, int *request_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_File_iwrite_all(file, f77_addr(buf), *count_f, datatype, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_iwrite_at_(int *file_f, int64_t *offset_f, void *buf, int *count_f, int *datatype_f, int *request_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_File_iwrite_at(file, f77_offset_f2c(*offset_f), f77_addr(buf), *count_f, datatype, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_iwrite_at_all_(int *file_f, int64_t *offset_f, void *buf, int *count_f, int *datatype_f, int *request_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_File_iwrite_at_all(file, f77_offset_f2c(*offset_f), f77_addr(buf), *count_f, datatype, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_iwrite_shared_(int *file_f, void *buf, int *count_f, int *datatype_f, int *request_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_File_iwrite_shared(file, f77_addr(buf), *count_f, datatype, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_open_(int *comm_f, char *filename, int *amode_f, int *info_f, int *file_f, int *ierror, size_t filename_len)
{
    char *filename_c = f77_string_to_c(filename, filename_len);
    if (filename_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    MPI_File file = MPI_FILE_NULL;
    *ierror = MPI_File_open(comm, filename_c, f77_amode_f2c(*amode_f), info, &file);
    *file_f = C_MPI_FILE_TOINT(file);
    free(filename_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_preallocate_(int *file_f, int64_t *size_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    *ierror = MPI_File_preallocate(file, (MPI_Offset)*size_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_read_(int *file_f, void *buf, int *count_f, int *datatype_f, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_read(file, f77_addr(buf), *count_f, datatype, status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_read_all_(int *file_f, void *buf, int *count_f, int *datatype_f, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_read_all(file, f77_addr(buf), *count_f, datatype, status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_read_all_begin_(int *file_f, void *buf, int *count_f, int *datatype_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_read_all_begin(file, f77_addr(buf), *count_f, datatype);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_read_all_end_(int *file_f, void *buf, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_read_all_end(file, f77_addr(buf), status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_read_at_(int *file_f, int64_t *offset_f, void *buf, int *count_f, int *datatype_f, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_read_at(file, f77_offset_f2c(*offset_f), f77_addr(buf), *count_f, datatype, status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_read_at_all_(int *file_f, int64_t *offset_f, void *buf, int *count_f, int *datatype_f, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_read_at_all(file, f77_offset_f2c(*offset_f), f77_addr(buf), *count_f, datatype, status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_read_at_all_begin_(int *file_f, int64_t *offset_f, void *buf, int *count_f, int *datatype_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_read_at_all_begin(file, f77_offset_f2c(*offset_f), f77_addr(buf), *count_f, datatype);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_read_at_all_end_(int *file_f, void *buf, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_read_at_all_end(file, f77_addr(buf), status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_read_ordered_(int *file_f, void *buf, int *count_f, int *datatype_f, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_read_ordered(file, f77_addr(buf), *count_f, datatype, status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_read_ordered_begin_(int *file_f, void *buf, int *count_f, int *datatype_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_read_ordered_begin(file, f77_addr(buf), *count_f, datatype);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_read_ordered_end_(int *file_f, void *buf, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_read_ordered_end(file, f77_addr(buf), status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_read_shared_(int *file_f, void *buf, int *count_f, int *datatype_f, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_read_shared(file, f77_addr(buf), *count_f, datatype, status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_File_seek(int *fh_f, int64_t *offset_f, int *whence, int *ierror);
void mpi_file_seek_(int *fh_f, int64_t *offset_f, int *whence, int *ierror)
{
    VAPAA_MPI_File_seek(fh_f, offset_f, whence, ierror);
}

extern void VAPAA_MPI_File_seek_shared(int *fh_f, int64_t *offset_f, int *whence, int *ierror);
void mpi_file_seek_shared_(int *fh_f, int64_t *offset_f, int *whence, int *ierror)
{
    VAPAA_MPI_File_seek_shared(fh_f, offset_f, whence, ierror);
}

extern void VAPAA_MPI_File_set_atomicity(int *fh_f, int *flag, int *ierror);
void mpi_file_set_atomicity_(int *fh_f, int *flag, int *ierror)
{
    VAPAA_MPI_File_set_atomicity(fh_f, flag, ierror);
}

extern void C_MPI_File_set_errhandler(int * file_f, int * errhandler_f, int * ierror);
void mpi_file_set_errhandler_(int * file_f, int * errhandler_f, int * ierror)
{
    C_MPI_File_set_errhandler(file_f, errhandler_f, ierror);
}

extern void VAPAA_MPI_File_set_info(int *fh_f, int *info_f, int *ierror);
void mpi_file_set_info_(int *fh_f, int *info_f, int *ierror)
{
    VAPAA_MPI_File_set_info(fh_f, info_f, ierror);
}

void mpi_file_set_size_(int *file_f, int64_t *size_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    *ierror = MPI_File_set_size(file, (MPI_Offset)*size_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_set_view_(int *file_f, int64_t *disp_f, int *etype_f, int *filetype_f, char *datarep, int *info_f, int *ierror, size_t datarep_len)
{
    char *datarep_c = f77_string_to_c(datarep, datarep_len);
    if (datarep_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype etype = C_MPI_TYPE_FROMINT(*etype_f);
    MPI_Datatype filetype = C_MPI_TYPE_FROMINT(*filetype_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_File_set_view(file, f77_offset_f2c(*disp_f), etype, filetype, datarep_c, info);
    free(datarep_c);
    C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_File_sync(int *fh_f, int *ierror);
void mpi_file_sync_(int *fh_f, int *ierror)
{
    VAPAA_MPI_File_sync(fh_f, ierror);
}

void mpi_file_write_(int *file_f, void *buf, int *count_f, int *datatype_f, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_write(file, f77_addr(buf), *count_f, datatype, status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_write_all_(int *file_f, void *buf, int *count_f, int *datatype_f, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_write_all(file, f77_addr(buf), *count_f, datatype, status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_write_all_begin_(int *file_f, void *buf, int *count_f, int *datatype_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_write_all_begin(file, f77_addr(buf), *count_f, datatype);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_write_all_end_(int *file_f, void *buf, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_write_all_end(file, f77_addr(buf), status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_write_at_(int *file_f, int64_t *offset_f, void *buf, int *count_f, int *datatype_f, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_write_at(file, f77_offset_f2c(*offset_f), f77_addr(buf), *count_f, datatype, status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_write_at_all_(int *file_f, int64_t *offset_f, void *buf, int *count_f, int *datatype_f, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_write_at_all(file, f77_offset_f2c(*offset_f), f77_addr(buf), *count_f, datatype, status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_write_at_all_begin_(int *file_f, int64_t *offset_f, void *buf, int *count_f, int *datatype_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_write_at_all_begin(file, f77_offset_f2c(*offset_f), f77_addr(buf), *count_f, datatype);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_write_at_all_end_(int *file_f, void *buf, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_write_at_all_end(file, f77_addr(buf), status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_write_ordered_(int *file_f, void *buf, int *count_f, int *datatype_f, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_write_ordered(file, f77_addr(buf), *count_f, datatype, status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_write_ordered_begin_(int *file_f, void *buf, int *count_f, int *datatype_f, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_write_ordered_begin(file, f77_addr(buf), *count_f, datatype);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_write_ordered_end_(int *file_f, void *buf, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_write_ordered_end(file, f77_addr(buf), status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_file_write_shared_(int *file_f, void *buf, int *count_f, int *datatype_f, int *status, int *ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Status status_c;
    MPI_Status *status_arg = f77_native_status_out_arg(status, &status_c);
    *ierror = MPI_File_write_shared(file, f77_addr(buf), *count_f, datatype, status_arg);
    if (*ierror == MPI_SUCCESS) f77_native_status_store(status, &status_c);
    C_MPI_RC_FIX(*ierror);
}

void mpi_free_mem_(void *base, int *ierror)
{
    *ierror = MPI_Free_mem(f77_addr(base));
    C_MPI_RC_FIX(*ierror);
}

void mpi_gather_init_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *root, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Gather_init(f77_in_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), *recvcount, recvtype, C_MPI_ROOT_F2C(*root), comm, info, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcount; (void)sendtype_f; (void)recvbuf; (void)recvcount; (void)recvtype_f; (void)root; (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_gatherv_init_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, const int recvcounts[], const int displs[], int *recvtype_f, int *root, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Gatherv_init(f77_in_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), recvcounts, displs, recvtype, C_MPI_ROOT_F2C(*root), comm, info, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcount; (void)sendtype_f; (void)recvbuf; (void)recvcounts; (void)displs; (void)recvtype_f; (void)root; (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_get_(void *origin_addr, int *origin_count, int *origin_datatype_f, int *target_rank, intptr_t *target_disp, int *target_count, int *target_datatype_f, int *win_f, int *ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Get(f77_addr(origin_addr), *origin_count, origin_datatype, C_MPI_DEST_F2C(*target_rank), (MPI_Aint)*target_disp, *target_count, target_datatype, win);
    C_MPI_RC_FIX(*ierror);
}

void mpi_get_accumulate_(void *origin_addr, int *origin_count, int *origin_datatype_f, void *result_addr, int *result_count, int *result_datatype_f, int *target_rank, intptr_t *target_disp, int *target_count, int *target_datatype_f, int *op_f, int *win_f, int *ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype result_datatype = C_MPI_TYPE_FROMINT(*result_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Get_accumulate(f77_const_addr(origin_addr), *origin_count, origin_datatype, f77_addr(result_addr), *result_count, result_datatype, C_MPI_DEST_F2C(*target_rank), (MPI_Aint)*target_disp, *target_count, target_datatype, op, win);
    C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_Get_elements(const struct F_MPI_Status *status_f, int *datatype_f, int *count, int *ierror);
void mpi_get_elements_(int *status, int *datatype_f, int *count, int *ierror)
{
    struct F_MPI_Status status_arg;
    VAPAA_MPI_Get_elements(f77_status_arg(status, &status_arg), datatype_f, count, ierror);
}

extern void VAPAA_MPI_Get_elements_x(const struct F_MPI_Status *status_f, int *datatype_f, int64_t *count_f, int *ierror);
void mpi_get_elements_x_(int *status, int *datatype_f, int64_t *count_f, int *ierror)
{
    struct F_MPI_Status status_arg;
    VAPAA_MPI_Get_elements_x(f77_status_arg(status, &status_arg), datatype_f, count_f, ierror);
}

extern void C_MPI_Get_hw_resource_info(int * hw_info_f, int * ierror);
void mpi_get_hw_resource_info_(int * hw_info_f, int * ierror)
{
    C_MPI_Get_hw_resource_info(hw_info_f, ierror);
}

extern void C_MPI_Graph_create(int * comm_old_f, int * nnodes, int * indx, int * edges, int * reorder, int * comm_graph_f, int * ierror);
void mpi_graph_create_(int * comm_old_f, int * nnodes, int * indx, int * edges, int * reorder, int * comm_graph_f, int * ierror)
{
    C_MPI_Graph_create(comm_old_f, nnodes, indx, edges, reorder, comm_graph_f, ierror);
}

extern void C_MPI_Graph_get(int * comm_f, int * maxindex, int * maxedges, int * indx, int * edges, int * ierror);
void mpi_graph_get_(int * comm_f, int * maxindex, int * maxedges, int * indx, int * edges, int * ierror)
{
    C_MPI_Graph_get(comm_f, maxindex, maxedges, indx, edges, ierror);
}

extern void C_MPI_Graph_map(int * comm_f, int * nnodes, int * indx, int * edges, int * newrank, int * ierror);
void mpi_graph_map_(int * comm_f, int * nnodes, int * indx, int * edges, int * newrank, int * ierror)
{
    C_MPI_Graph_map(comm_f, nnodes, indx, edges, newrank, ierror);
}

extern void C_MPI_Graph_neighbors(int * comm_f, int * rank, int * maxneighbors, int * neighbors, int * ierror);
void mpi_graph_neighbors_(int * comm_f, int * rank, int * maxneighbors, int * neighbors, int * ierror)
{
    C_MPI_Graph_neighbors(comm_f, rank, maxneighbors, neighbors, ierror);
}

extern void C_MPI_Graph_neighbors_count(int * comm_f, int * rank, int * nneighbors, int * ierror);
void mpi_graph_neighbors_count_(int * comm_f, int * rank, int * nneighbors, int * ierror)
{
    C_MPI_Graph_neighbors_count(comm_f, rank, nneighbors, ierror);
}

extern void C_MPI_Graphdims_get(int * comm_f, int * nnodes, int * nedges, int * ierror);
void mpi_graphdims_get_(int * comm_f, int * nnodes, int * nedges, int * ierror)
{
    C_MPI_Graphdims_get(comm_f, nnodes, nedges, ierror);
}

extern void C_MPI_Group_difference(int * group1_f, int * group2_f, int * newgroup_f, int * ierror);
void mpi_group_difference_(int * group1_f, int * group2_f, int * newgroup_f, int * ierror)
{
    C_MPI_Group_difference(group1_f, group2_f, newgroup_f, ierror);
}

extern void C_MPI_Group_excl(int * group_f, int * n, int * ranks, int * newgroup_f, int * ierror);
void mpi_group_excl_(int * group_f, int * n, int * ranks, int * newgroup_f, int * ierror)
{
    C_MPI_Group_excl(group_f, n, ranks, newgroup_f, ierror);
}

extern void C_MPI_Group_from_session_pset(int * session_f, char * pset_name, int * newgroup_f, int * ierror);
void mpi_group_from_session_pset_(int *session_f, char *pset_name, int *newgroup_f, int *ierror, size_t pset_name_len)
{
    char *pset_c = f77_string_to_c(pset_name, pset_name_len);
    if (pset_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    C_MPI_Group_from_session_pset(session_f, pset_c, newgroup_f, ierror);
    free(pset_c);
}

extern void C_MPI_Group_intersection(int * group1_f, int * group2_f, int * newgroup_f, int * ierror);
void mpi_group_intersection_(int * group1_f, int * group2_f, int * newgroup_f, int * ierror)
{
    C_MPI_Group_intersection(group1_f, group2_f, newgroup_f, ierror);
}

extern void C_MPI_Group_range_excl(int * group_f, int * n, int ranges_f[][3], int * newgroup_f, int * ierror);
void mpi_group_range_excl_(int * group_f, int * n, int ranges_f[][3], int * newgroup_f, int * ierror)
{
    C_MPI_Group_range_excl(group_f, n, ranges_f, newgroup_f, ierror);
}

extern void C_MPI_Group_range_incl(int * group_f, int * n, int ranges_f[][3], int * newgroup_f, int * ierror);
void mpi_group_range_incl_(int * group_f, int * n, int ranges_f[][3], int * newgroup_f, int * ierror)
{
    C_MPI_Group_range_incl(group_f, n, ranges_f, newgroup_f, ierror);
}

extern void C_MPI_Group_translate_ranks(int * group1_f, int * n, int * ranks1, int * group2_f, int * ranks2, int * ierror);
void mpi_group_translate_ranks_(int * group1_f, int * n, int * ranks1, int * group2_f, int * ranks2, int * ierror)
{
    C_MPI_Group_translate_ranks(group1_f, n, ranks1, group2_f, ranks2, ierror);
}

extern void C_MPI_Group_union(int * group1_f, int * group2_f, int * newgroup_f, int * ierror);
void mpi_group_union_(int * group1_f, int * group2_f, int * newgroup_f, int * ierror)
{
    C_MPI_Group_union(group1_f, group2_f, newgroup_f, ierror);
}

void mpi_iallgather_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Iallgather(f77_in_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), *recvcount, recvtype, comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_iallgatherv_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, const int recvcounts[], const int displs[], int *recvtype_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Iallgatherv(f77_in_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), recvcounts, displs, recvtype, comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_ibsend_(void *buffer, int *count, int *datatype_f, int *dest, int *tag, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Ibsend(f77_addr(buffer), *count, datatype, C_MPI_DEST_F2C(*dest), C_MPI_TAG_F2C(*tag), comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_ineighbor_allgather_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Ineighbor_allgather(f77_const_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), *recvcount, recvtype, comm, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
}

void mpi_ineighbor_allgatherv_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, const int recvcounts[], const int displs[], int *recvtype_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL; MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Ineighbor_allgatherv(f77_const_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), recvcounts, displs, recvtype, comm, &request); f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
}

void mpi_ineighbor_alltoall_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Ineighbor_alltoall(f77_const_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), *recvcount, recvtype, comm, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
}

void mpi_ineighbor_alltoallv_(const void *sendbuf, const int sendcounts[], const int sdispls[], int *sendtype_f, void *recvbuf, const int recvcounts[], const int rdispls[], int *recvtype_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL; MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Ineighbor_alltoallv(f77_const_addr(sendbuf), sendcounts, sdispls, sendtype, f77_addr(recvbuf), recvcounts, rdispls, recvtype, comm, &request); f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
}

void mpi_ineighbor_alltoallw_(const void *sendbuf, const int sendcounts[], const intptr_t sdispls_f[], const int sendtypes_f[], void *recvbuf, const int recvcounts[], const intptr_t rdispls_f[], const int recvtypes_f[], int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    int indegree = 0, outdegree = 0, weighted = 0;
    int topo = MPI_UNDEFINED; (void)MPI_Topo_test(comm, &topo);
    if (topo == MPI_DIST_GRAPH) { (void)MPI_Dist_graph_neighbors_count(comm, &indegree, &outdegree, &weighted); }
    else if (topo == MPI_CART) { (void)MPI_Cartdim_get(comm, &outdegree); outdegree *= 2; indegree = outdegree; }
    else if (topo == MPI_GRAPH) { int rank = 0; (void)MPI_Comm_rank(comm, &rank); (void)MPI_Graph_neighbors_count(comm, rank, &outdegree); indegree = outdegree; }
    MPI_Datatype *sendtypes = f77_datatypes_from_ints(outdegree, sendtypes_f);
    MPI_Datatype *recvtypes = f77_datatypes_from_ints(indegree, recvtypes_f);
    MPI_Aint *sdispls = f77_aints_from_intptrs(outdegree, sdispls_f);
    MPI_Aint *rdispls = f77_aints_from_intptrs(indegree, rdispls_f);
    if (sendtypes == NULL || recvtypes == NULL || sdispls == NULL || rdispls == NULL) { free(sendtypes); free(recvtypes); free(sdispls); free(rdispls); *ierror = MPI_ERR_OTHER; C_MPI_RC_FIX(*ierror); return; }
    *ierror = MPI_Ineighbor_alltoallw(f77_const_addr(sendbuf), sendcounts, sdispls, sendtypes, f77_addr(recvbuf), recvcounts, rdispls, recvtypes, comm, &request);
    free(sendtypes); free(recvtypes); free(sdispls); free(rdispls); f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_Intercomm_create(int *local_comm_f, int *local_leader, int *peer_comm_f, int *remote_leader, int *tag, int *newintercomm_f, int *ierror);
void mpi_intercomm_create_(int *local_comm_f, int *local_leader, int *peer_comm_f, int *remote_leader, int *tag, int *newintercomm_f, int *ierror)
{
    VAPAA_MPI_Intercomm_create(local_comm_f, local_leader, peer_comm_f, remote_leader, tag, newintercomm_f, ierror);
}

void mpi_intercomm_create_from_groups_(int *local_group_f, int *local_leader, int *remote_group_f, int *remote_leader, char *stringtag, int *info_f, int *errhandler_f, int *newintercomm_f, int *ierror, size_t stringtag_len)
{
#if MPI_VERSION >= 4
    char *tag_c = f77_string_to_c(stringtag, stringtag_len);
    if (tag_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    MPI_Group local_group = C_MPI_GROUP_FROMINT(*local_group_f), remote_group = C_MPI_GROUP_FROMINT(*remote_group_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f); MPI_Errhandler errhandler = C_MPI_ERRHANDLER_FROMINT(*errhandler_f); MPI_Comm newintercomm = MPI_COMM_NULL;
    *ierror = MPI_Intercomm_create_from_groups(local_group, *local_leader, remote_group, *remote_leader, tag_c, info, errhandler, &newintercomm);
    *newintercomm_f = C_MPI_COMM_TOINT(newintercomm); free(tag_c); C_MPI_RC_FIX(*ierror);
#else
    (void)local_group_f; (void)local_leader; (void)remote_group_f; (void)remote_leader; (void)stringtag; (void)info_f; (void)errhandler_f; (void)stringtag_len; *newintercomm_f = VAPAA_MPI_COMM_NULL; *ierror = MPI_ERR_UNSUPPORTED_OPERATION; C_MPI_RC_FIX(*ierror);
#endif
}

extern void VAPAA_MPI_Intercomm_merge(int *intercomm_f, int *high, int *newintracomm_f, int *ierror);
void mpi_intercomm_merge_(int *intercomm_f, int *high, int *newintracomm_f, int *ierror)
{
    VAPAA_MPI_Intercomm_merge(intercomm_f, high, newintracomm_f, ierror);
}

void mpi_iscatter_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *root, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Iscatter(f77_in_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), *recvcount, recvtype, C_MPI_ROOT_F2C(*root), comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_iscatterv_(const void *sendbuf, const int sendcounts[], const int displs[], int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *root, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Iscatterv(f77_in_addr(sendbuf), sendcounts, displs, sendtype, f77_addr(recvbuf), *recvcount, recvtype, C_MPI_ROOT_F2C(*root), comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_isendrecv_(const void *sendbuf, int *sendcount, int *sendtype_f, int *dest, int *sendtag, void *recvbuf, int *recvcount, int *recvtype_f, int *source, int *recvtag, int *comm_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL; MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Isendrecv(f77_const_addr(sendbuf), *sendcount, sendtype, C_MPI_DEST_F2C(*dest), C_MPI_TAG_F2C(*sendtag), f77_addr(recvbuf), *recvcount, recvtype, C_MPI_SOURCE_F2C(*source), C_MPI_TAG_F2C(*recvtag), comm, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcount; (void)sendtype_f; (void)dest; (void)sendtag; (void)recvbuf; (void)recvcount; (void)recvtype_f; (void)source; (void)recvtag; (void)comm_f; f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_isendrecv_replace_(void *buf, int *count, int *datatype_f, int *dest, int *sendtag, int *source, int *recvtag, int *comm_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL; MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Isendrecv_replace(f77_addr(buf), *count, datatype, C_MPI_DEST_F2C(*dest), C_MPI_TAG_F2C(*sendtag), C_MPI_SOURCE_F2C(*source), C_MPI_TAG_F2C(*recvtag), comm, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)buf; (void)count; (void)datatype_f; (void)dest; (void)sendtag; (void)source; (void)recvtag; (void)comm_f; f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_lookup_name_(char *service_name, int *info_f, char *port_name, int *ierror, size_t service_name_len, size_t port_name_len)
{
    char *service_c = f77_string_to_c(service_name, service_name_len); if (service_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f); char tmp[VAPAA_MPI_MAX_PORT_NAME] = {0};
    *ierror = MPI_Lookup_name(service_c, info, tmp); if (*ierror == MPI_SUCCESS) c_string_to_f77(port_name, port_name_len, tmp);
    free(service_c); C_MPI_RC_FIX(*ierror);
}

void mpi_neighbor_allgather_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *comm_f, int *ierror)
{

    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Neighbor_allgather(f77_const_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), *recvcount, recvtype, comm);
    C_MPI_RC_FIX(*ierror);
}

void mpi_neighbor_allgather_init_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Neighbor_allgather_init(f77_const_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), *recvcount, recvtype, comm, info, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcount; (void)sendtype_f; (void)recvbuf; (void)recvcount; (void)recvtype_f; (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_neighbor_allgatherv_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, const int recvcounts[], const int displs[], int *recvtype_f, int *comm_f, int *ierror)
{
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Neighbor_allgatherv(f77_const_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), recvcounts, displs, recvtype, comm); C_MPI_RC_FIX(*ierror);
}

void mpi_neighbor_allgatherv_init_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, const int recvcounts[], const int displs[], int *recvtype_f, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL; MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Neighbor_allgatherv_init(f77_const_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), recvcounts, displs, recvtype, comm, info, &request); f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcount; (void)sendtype_f; (void)recvbuf; (void)recvcounts; (void)displs; (void)recvtype_f; (void)comm_f; (void)info_f; f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_neighbor_alltoall_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *comm_f, int *ierror)
{

    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Neighbor_alltoall(f77_const_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), *recvcount, recvtype, comm);
    C_MPI_RC_FIX(*ierror);
}

void mpi_neighbor_alltoall_init_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Neighbor_alltoall_init(f77_const_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), *recvcount, recvtype, comm, info, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcount; (void)sendtype_f; (void)recvbuf; (void)recvcount; (void)recvtype_f; (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_neighbor_alltoallv_(const void *sendbuf, const int sendcounts[], const int sdispls[], int *sendtype_f, void *recvbuf, const int recvcounts[], const int rdispls[], int *recvtype_f, int *comm_f, int *ierror)
{
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Neighbor_alltoallv(f77_const_addr(sendbuf), sendcounts, sdispls, sendtype, f77_addr(recvbuf), recvcounts, rdispls, recvtype, comm); C_MPI_RC_FIX(*ierror);
}

void mpi_neighbor_alltoallv_init_(const void *sendbuf, const int sendcounts[], const int sdispls[], int *sendtype_f, void *recvbuf, const int recvcounts[], const int rdispls[], int *recvtype_f, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL; MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Neighbor_alltoallv_init(f77_const_addr(sendbuf), sendcounts, sdispls, sendtype, f77_addr(recvbuf), recvcounts, rdispls, recvtype, comm, info, &request); f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcounts; (void)sdispls; (void)sendtype_f; (void)recvbuf; (void)recvcounts; (void)rdispls; (void)recvtype_f; (void)comm_f; (void)info_f; f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_neighbor_alltoallw_(const void *sendbuf, const int sendcounts[], const intptr_t sdispls_f[], const int sendtypes_f[], void *recvbuf, const int recvcounts[], const intptr_t rdispls_f[], const int recvtypes_f[], int *comm_f, int *ierror)
{

    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    int indegree = 0, outdegree = 0, weighted = 0;
    int topo = MPI_UNDEFINED; (void)MPI_Topo_test(comm, &topo);
    if (topo == MPI_DIST_GRAPH) { (void)MPI_Dist_graph_neighbors_count(comm, &indegree, &outdegree, &weighted); }
    else if (topo == MPI_CART) { (void)MPI_Cartdim_get(comm, &outdegree); outdegree *= 2; indegree = outdegree; }
    else if (topo == MPI_GRAPH) { int rank = 0; (void)MPI_Comm_rank(comm, &rank); (void)MPI_Graph_neighbors_count(comm, rank, &outdegree); indegree = outdegree; }
    MPI_Datatype *sendtypes = f77_datatypes_from_ints(outdegree, sendtypes_f);
    MPI_Datatype *recvtypes = f77_datatypes_from_ints(indegree, recvtypes_f);
    MPI_Aint *sdispls = f77_aints_from_intptrs(outdegree, sdispls_f);
    MPI_Aint *rdispls = f77_aints_from_intptrs(indegree, rdispls_f);
    if (sendtypes == NULL || recvtypes == NULL || sdispls == NULL || rdispls == NULL) { free(sendtypes); free(recvtypes); free(sdispls); free(rdispls); *ierror = MPI_ERR_OTHER; C_MPI_RC_FIX(*ierror); return; }
    *ierror = MPI_Neighbor_alltoallw(f77_const_addr(sendbuf), sendcounts, sdispls, sendtypes, f77_addr(recvbuf), recvcounts, rdispls, recvtypes, comm);
    free(sendtypes); free(recvtypes); free(sdispls); free(rdispls); C_MPI_RC_FIX(*ierror);
}

void mpi_neighbor_alltoallw_init_(const void *sendbuf, const int sendcounts[], const intptr_t sdispls_f[], const int sendtypes_f[], void *recvbuf, const int recvcounts[], const intptr_t rdispls_f[], const int recvtypes_f[], int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    int indegree = 0, outdegree = 0, weighted = 0;
    int topo = MPI_UNDEFINED; (void)MPI_Topo_test(comm, &topo);
    if (topo == MPI_DIST_GRAPH) { (void)MPI_Dist_graph_neighbors_count(comm, &indegree, &outdegree, &weighted); }
    else if (topo == MPI_CART) { (void)MPI_Cartdim_get(comm, &outdegree); outdegree *= 2; indegree = outdegree; }
    else if (topo == MPI_GRAPH) { int rank = 0; (void)MPI_Comm_rank(comm, &rank); (void)MPI_Graph_neighbors_count(comm, rank, &outdegree); indegree = outdegree; }
    MPI_Datatype *sendtypes = f77_datatypes_from_ints(outdegree, sendtypes_f);
    MPI_Datatype *recvtypes = f77_datatypes_from_ints(indegree, recvtypes_f);
    MPI_Aint *sdispls = f77_aints_from_intptrs(outdegree, sdispls_f);
    MPI_Aint *rdispls = f77_aints_from_intptrs(indegree, rdispls_f);
    if (sendtypes == NULL || recvtypes == NULL || sdispls == NULL || rdispls == NULL) { free(sendtypes); free(recvtypes); free(sdispls); free(rdispls); *ierror = MPI_ERR_OTHER; C_MPI_RC_FIX(*ierror); return; }
    *ierror = MPI_Neighbor_alltoallw_init(f77_const_addr(sendbuf), sendcounts, sdispls, sendtypes, f77_addr(recvbuf), recvcounts, rdispls, recvtypes, comm, info, &request);
    free(sendtypes); free(recvtypes); free(sdispls); free(rdispls); f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcounts; (void)sdispls_f; (void)sendtypes_f; (void)recvbuf; (void)recvcounts; (void)rdispls_f; (void)recvtypes_f; (void)comm_f; (void)info_f; f77_unsupported_request(request_f, ierror);
#endif
}

extern void VAPAA_MPI_Op_commutative(int *op_f, int *commute, int *ierror);
void mpi_op_commutative_(int *op_f, int *commute, int *ierror)
{
    VAPAA_MPI_Op_commutative(op_f, commute, ierror);
}

extern void VAPAA_MPI_Op_create_c(vapaa_c_funptr fn, int *commute, int *op_f, int *ierror);
void mpi_op_create_c_(vapaa_c_funptr fn, int *commute, int *op_f, int *ierror)
{
    VAPAA_MPI_Op_create_c(fn, commute, op_f, ierror);
}

void mpi_open_port_(int *info_f, char *port_name, int *ierror, size_t port_name_len)
{
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    char tmp[VAPAA_MPI_MAX_PORT_NAME] = {0};
    *ierror = MPI_Open_port(info, tmp);
    if (*ierror == MPI_SUCCESS) c_string_to_f77(port_name, port_name_len, tmp);
    C_MPI_RC_FIX(*ierror);
}

extern void C_MPI_Parrived(const int * request_f, int * partition, int * flag, int * ierror);
void mpi_parrived_(const int * request_f, int * partition, int * flag, int * ierror)
{
    C_MPI_Parrived(request_f, partition, flag, ierror);
}

extern void C_MPI_Pcontrol(int * level, int * ierror);
void mpi_pcontrol_(int * level, int * ierror)
{
    C_MPI_Pcontrol(level, ierror);
}

extern void C_MPI_Pready(int * partition, const int * request_f, int * ierror);
void mpi_pready_(int * partition, const int * request_f, int * ierror)
{
    C_MPI_Pready(partition, request_f, ierror);
}

extern void C_MPI_Pready_list(int * length, const int partitions[], const int * request_f, int * ierror);
void mpi_pready_list_(int * length, const int partitions[], const int * request_f, int * ierror)
{
    C_MPI_Pready_list(length, partitions, request_f, ierror);
}

extern void C_MPI_Pready_range(int * partition_low, int * partition_high, const int * request_f, int * ierror);
void mpi_pready_range_(int * partition_low, int * partition_high, const int * request_f, int * ierror)
{
    C_MPI_Pready_range(partition_low, partition_high, request_f, ierror);
}

void mpi_precv_init_(void *buf, int *partitions, int *count, int *datatype_f, int *source, int *tag, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL; MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Precv_init(f77_addr(buf), *partitions, *count, datatype, C_MPI_SOURCE_F2C(*source), C_MPI_TAG_F2C(*tag), comm, info, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)buf; (void)partitions; (void)count; (void)datatype_f; (void)source; (void)tag; (void)comm_f; (void)info_f; f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_psend_init_(void *buf, int *partitions, int *count, int *datatype_f, int *dest, int *tag, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL; MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Psend_init(f77_addr(buf), *partitions, *count, datatype, C_MPI_DEST_F2C(*dest), C_MPI_TAG_F2C(*tag), comm, info, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)buf; (void)partitions; (void)count; (void)datatype_f; (void)dest; (void)tag; (void)comm_f; (void)info_f; f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_publish_name_(char *service_name, int *info_f, char *port_name, int *ierror, size_t service_name_len, size_t port_name_len)
{
    char *service_c = f77_string_to_c(service_name, service_name_len); char *port_c = f77_string_to_c(port_name, port_name_len);
    if (service_c == NULL || port_c == NULL) { free(service_c); free(port_c); *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f); *ierror = MPI_Publish_name(service_c, info, port_c);
    free(service_c); free(port_c); C_MPI_RC_FIX(*ierror);
}

void mpi_put_(void *origin_addr, int *origin_count, int *origin_datatype_f, int *target_rank, intptr_t *target_disp, int *target_count, int *target_datatype_f, int *win_f, int *ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Put(f77_const_addr(origin_addr), *origin_count, origin_datatype, C_MPI_DEST_F2C(*target_rank), (MPI_Aint)*target_disp, *target_count, target_datatype, win);
    C_MPI_RC_FIX(*ierror);
}

void mpi_raccumulate_(void *origin_addr, int *origin_count, int *origin_datatype_f, int *target_rank, intptr_t *target_disp, int *target_count, int *target_datatype_f, int *op_f, int *win_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Raccumulate(f77_const_addr(origin_addr), *origin_count, origin_datatype, C_MPI_DEST_F2C(*target_rank), (MPI_Aint)*target_disp, *target_count, target_datatype, op, win, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_reduce_init_(const void *sendbuf, void *recvbuf, int *count, int *datatype_f, int *op_f, int *root, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Reduce_init(f77_in_addr(sendbuf), f77_addr(recvbuf), *count, datatype, op, C_MPI_ROOT_F2C(*root), comm, info, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)recvbuf; (void)count; (void)datatype_f; (void)op_f; (void)root; (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_reduce_scatter_block_init_(const void *sendbuf, void *recvbuf, int *recvcount, int *datatype_f, int *op_f, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL; MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); MPI_Op op = C_MPI_OP_FROMINT(*op_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Reduce_scatter_block_init(f77_in_addr(sendbuf), f77_addr(recvbuf), *recvcount, datatype, op, comm, info, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)recvbuf; (void)recvcount; (void)datatype_f; (void)op_f; (void)comm_f; (void)info_f; f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_reduce_scatter_init_(const void *sendbuf, void *recvbuf, const int recvcounts[], int *datatype_f, int *op_f, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL; MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); MPI_Op op = C_MPI_OP_FROMINT(*op_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Reduce_scatter_init(f77_in_addr(sendbuf), f77_addr(recvbuf), recvcounts, datatype, op, comm, info, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)recvbuf; (void)recvcounts; (void)datatype_f; (void)op_f; (void)comm_f; (void)info_f; f77_unsupported_request(request_f, ierror);
#endif
}

extern void VAPAA_MPI_Register_datarep(const char datarep[], vapaa_c_funptr read_fn, vapaa_c_funptr write_fn, vapaa_c_funptr extent_fn, intptr_t *extra, int *ierror);
void mpi_register_datarep_(char *datarep, vapaa_c_funptr read_fn, vapaa_c_funptr write_fn, vapaa_c_funptr extent_fn, intptr_t *extra, int *ierror, size_t datarep_len)
{
    char *datarep_c = f77_string_to_c(datarep, datarep_len);
    if (datarep_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    VAPAA_MPI_Register_datarep(datarep_c, read_fn, write_fn, extent_fn, extra, ierror);
    free(datarep_c);
}

extern void VAPAA_MPI_Register_datarep_c(const char datarep[], vapaa_c_funptr read_fn, vapaa_c_funptr write_fn, vapaa_c_funptr extent_fn, intptr_t *extra, int *ierror);
void mpi_register_datarep_c_(char *datarep, vapaa_c_funptr read_fn, vapaa_c_funptr write_fn, vapaa_c_funptr extent_fn, intptr_t *extra, int *ierror, size_t datarep_len)
{
    char *datarep_c = f77_string_to_c(datarep, datarep_len);
    if (datarep_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    VAPAA_MPI_Register_datarep_c(datarep_c, read_fn, write_fn, extent_fn, extra, ierror);
    free(datarep_c);
}

extern void C_MPI_Remove_error_class(int * errorclass, int * ierror);
void mpi_remove_error_class_(int * errorclass, int * ierror)
{
    C_MPI_Remove_error_class(errorclass, ierror);
}

extern void C_MPI_Remove_error_code(int * errorcode, int * ierror);
void mpi_remove_error_code_(int * errorcode, int * ierror)
{
    C_MPI_Remove_error_code(errorcode, ierror);
}

extern void C_MPI_Remove_error_string(int * errorcode, int * ierror);
void mpi_remove_error_string_(int * errorcode, int * ierror)
{
    C_MPI_Remove_error_string(errorcode, ierror);
}

extern void C_MPI_Request_get_status(const int *request_f, int *flag_f, struct F_MPI_Status *status_f, int *ierror);
void mpi_request_get_status_(int *request_f, int *flag, int *status, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Request_get_status(request_f, flag, f77_status_out_arg(status, &status_arg), ierror);
    if (*flag) f77_status_store(status, &status_arg);
    f77_store_logical(flag, *flag);
}

extern void C_MPI_Request_get_status_all(int *count, int requests_f[], int *flag_f, struct F_MPI_Status statuses_f[], int *ierror);
void mpi_request_get_status_all_(int *count, int requests_f[], int *flag, int statuses[], int *ierror)
{
    struct F_MPI_Status *statuses_arg = f77_statuses_out_arg(*count, statuses, ierror);
    if (statuses_arg == NULL && !C_IS_MPI_STATUSES_IGNORE(statuses)) return;
    C_MPI_Request_get_status_all(count, requests_f, flag, statuses_arg, ierror);
    if (*flag) {
        f77_statuses_store_free(*count, statuses, statuses_arg);
    } else if (!C_IS_MPI_STATUSES_IGNORE(statuses)) {
        free(statuses_arg);
    }
    f77_store_logical(flag, *flag);
}

extern void C_MPI_Request_get_status_any(int *count, int requests_f[], int *index_f, int *flag_f, struct F_MPI_Status *status_f, int *ierror);
void mpi_request_get_status_any_(int *count, int requests_f[], int *index, int *flag, int *status, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Request_get_status_any(count, requests_f, index, flag, f77_status_out_arg(status, &status_arg), ierror);
    if (*flag && *index != VAPAA_MPI_UNDEFINED) {
        f77_status_store(status, &status_arg);
        *index += 1;
    }
    f77_store_logical(flag, *flag);
}

extern void C_MPI_Request_get_status_some(int *incount, int requests_f[], int *outcount_f, int indices[], struct F_MPI_Status statuses_f[], int *ierror);
void mpi_request_get_status_some_(int *incount, int requests_f[], int *outcount, int indices[], int statuses[], int *ierror)
{
    struct F_MPI_Status *statuses_arg = f77_statuses_out_arg(*incount, statuses, ierror);
    if (statuses_arg == NULL && !C_IS_MPI_STATUSES_IGNORE(statuses)) return;
    C_MPI_Request_get_status_some(incount, requests_f, outcount, indices, statuses_arg, ierror);
    if (*outcount > 0) {
        for (int i = 0; i < *outcount; i++) indices[i] += 1;
        f77_statuses_store_free(*outcount, statuses, statuses_arg);
    } else if (!C_IS_MPI_STATUSES_IGNORE(statuses)) {
        free(statuses_arg);
    }
}

void mpi_rget_(void *origin_addr, int *origin_count, int *origin_datatype_f, int *target_rank, intptr_t *target_disp, int *target_count, int *target_datatype_f, int *win_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Rget(f77_addr(origin_addr), *origin_count, origin_datatype, C_MPI_DEST_F2C(*target_rank), (MPI_Aint)*target_disp, *target_count, target_datatype, win, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_rget_accumulate_(void *origin_addr, int *origin_count, int *origin_datatype_f, void *result_addr, int *result_count, int *result_datatype_f, int *target_rank, intptr_t *target_disp, int *target_count, int *target_datatype_f, int *op_f, int *win_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype result_datatype = C_MPI_TYPE_FROMINT(*result_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Rget_accumulate(f77_const_addr(origin_addr), *origin_count, origin_datatype, f77_addr(result_addr), *result_count, result_datatype, C_MPI_DEST_F2C(*target_rank), (MPI_Aint)*target_disp, *target_count, target_datatype, op, win, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_rput_(void *origin_addr, int *origin_count, int *origin_datatype_f, int *target_rank, intptr_t *target_disp, int *target_count, int *target_datatype_f, int *win_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype origin_datatype = C_MPI_TYPE_FROMINT(*origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_FROMINT(*target_datatype_f);
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Rput(f77_const_addr(origin_addr), *origin_count, origin_datatype, C_MPI_DEST_F2C(*target_rank), (MPI_Aint)*target_disp, *target_count, target_datatype, win, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_scan_init_(const void *sendbuf, void *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Scan_init(f77_in_addr(sendbuf), f77_addr(recvbuf), *count, datatype, op, comm, info, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)recvbuf; (void)count; (void)datatype_f; (void)op_f;  (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_scatter_init_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *root, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Scatter_init(f77_in_addr(sendbuf), *sendcount, sendtype, f77_addr(recvbuf), *recvcount, recvtype, C_MPI_ROOT_F2C(*root), comm, info, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcount; (void)sendtype_f; (void)recvbuf; (void)recvcount; (void)recvtype_f; (void)root; (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_scatterv_init_(const void *sendbuf, const int sendcounts[], const int displs[], int *sendtype_f, void *recvbuf, int *recvcount, int *recvtype_f, int *root, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f), recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Scatterv_init(f77_in_addr(sendbuf), sendcounts, displs, sendtype, f77_addr(recvbuf), *recvcount, recvtype, C_MPI_ROOT_F2C(*root), comm, info, &request);
    f77_request_store(request, request_f); C_MPI_RC_FIX(*ierror);
#else
    (void)sendbuf; (void)sendcounts; (void)displs; (void)sendtype_f; (void)recvbuf; (void)recvcount; (void)recvtype_f; (void)root; (void)comm_f; (void)info_f;
    f77_unsupported_request(request_f, ierror);
#endif
}

void mpi_session_attach_buffer_(int *session_f, void *buffer, int *size, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f);
    *ierror = MPI_Session_attach_buffer(session, f77_addr(buffer), *size);
#else
    (void)session_f; (void)buffer; (void)size; *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

extern void C_MPI_Session_call_errhandler(int * session_f, int * errorcode_f, int * ierror);
void mpi_session_call_errhandler_(int * session_f, int * errorcode_f, int * ierror)
{
    C_MPI_Session_call_errhandler(session_f, errorcode_f, ierror);
}

extern void VAPAA_MPI_Session_create_errhandler(vapaa_c_funptr fn, int *errhandler_f, int *ierror);
void mpi_session_create_errhandler_(vapaa_c_funptr fn, int *errhandler_f, int *ierror)
{
    VAPAA_MPI_Session_create_errhandler(fn, errhandler_f, ierror);
}

extern void VAPAA_MPI_Session_detach_buffer(int *session_f, void **buffer_addr, int *size, int *ierror);
void mpi_session_detach_buffer_(int *session_f, void **buffer_addr, int *size, int *ierror)
{
    VAPAA_MPI_Session_detach_buffer(session_f, buffer_addr, size, ierror);
}

extern void VAPAA_MPI_Session_finalize(int *session_f, int *ierror);
void mpi_session_finalize_(int *session_f, int *ierror)
{
    VAPAA_MPI_Session_finalize(session_f, ierror);
}

extern void VAPAA_MPI_Session_flush_buffer(int *session_f, int *ierror);
void mpi_session_flush_buffer_(int *session_f, int *ierror)
{
    VAPAA_MPI_Session_flush_buffer(session_f, ierror);
}

extern void C_MPI_Session_get_errhandler(int * session_f, int * errhandler_f, int * ierror);
void mpi_session_get_errhandler_(int * session_f, int * errhandler_f, int * ierror)
{
    C_MPI_Session_get_errhandler(session_f, errhandler_f, ierror);
}

extern void VAPAA_MPI_Session_get_info(int *session_f, int *info_f, int *ierror);
void mpi_session_get_info_(int *session_f, int *info_f, int *ierror)
{
    VAPAA_MPI_Session_get_info(session_f, info_f, ierror);
}

void mpi_session_get_nth_pset_(int *session_f, int *info_f, int *n, int *pset_len, char *pset_name, int *ierror, size_t pset_name_len)
{
#if MPI_VERSION >= 4
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f); MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    char *tmp = calloc(pset_name_len + 1, 1); if (tmp == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    *ierror = MPI_Session_get_nth_pset(session, info, *n, pset_len, tmp);
    if (*ierror == MPI_SUCCESS) c_string_to_f77(pset_name, pset_name_len, tmp);
    free(tmp);
#else
    (void)session_f; (void)info_f; (void)n; (void)pset_name; (void)pset_name_len; *pset_len = 0; *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_Session_get_num_psets(int *session_f, int *info_f, int *npset_names, int *ierror);
void mpi_session_get_num_psets_(int *session_f, int *info_f, int *npset_names, int *ierror)
{
    VAPAA_MPI_Session_get_num_psets(session_f, info_f, npset_names, ierror);
}

void mpi_session_get_pset_info_(int *session_f, char *pset_name, int *info_f, int *ierror, size_t pset_name_len)
{
#if MPI_VERSION >= 4
    char *pset_c = f77_string_to_c(pset_name, pset_name_len); if (pset_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f); MPI_Info info = MPI_INFO_NULL;
    *ierror = MPI_Session_get_pset_info(session, pset_c, &info); *info_f = C_MPI_INFO_TOINT(info);
    free(pset_c);
#else
    (void)session_f; (void)pset_name; (void)pset_name_len; *info_f = VAPAA_MPI_INFO_NULL; *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_Session_iflush_buffer(int *session_f, int *request_f, int *ierror);
void mpi_session_iflush_buffer_(int *session_f, int *request_f, int *ierror)
{
    VAPAA_MPI_Session_iflush_buffer(session_f, request_f, ierror);
}

extern void VAPAA_MPI_Session_init(int *info_f, int *errhandler_f, int *session_f, int *ierror);
void mpi_session_init_(int *info_f, int *errhandler_f, int *session_f, int *ierror)
{
    VAPAA_MPI_Session_init(info_f, errhandler_f, session_f, ierror);
}

extern void C_MPI_Session_set_errhandler(int * session_f, int * errhandler_f, int * ierror);
void mpi_session_set_errhandler_(int * session_f, int * errhandler_f, int * ierror)
{
    C_MPI_Session_set_errhandler(session_f, errhandler_f, ierror);
}

void mpi_sizeof_(int *ierror)
{
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    C_MPI_RC_FIX(*ierror);
}

void mpi_status_f082f_(int *ierror)
{
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    C_MPI_RC_FIX(*ierror);
}

void mpi_status_f2f08_(int *ierror)
{
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    C_MPI_RC_FIX(*ierror);
}

extern void C_MPI_Status_get_error(struct F_MPI_Status *status_f, int *error, int *ierror);
void mpi_status_get_error_(int *status, int *error, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Status_get_error(f77_status_arg(status, &status_arg), error, ierror);
}

extern void C_MPI_Status_get_source(struct F_MPI_Status *status_f, int *source, int *ierror);
void mpi_status_get_source_(int *status, int *source, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Status_get_source(f77_status_arg(status, &status_arg), source, ierror);
}

extern void C_MPI_Status_get_tag(struct F_MPI_Status *status_f, int *tag, int *ierror);
void mpi_status_get_tag_(int *status, int *tag, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Status_get_tag(f77_status_arg(status, &status_arg), tag, ierror);
}

extern void C_MPI_Status_set_elements_x(struct F_MPI_Status *status_f, int datatype_f, MPI_Count *count, int *ierror);
void mpi_status_set_elements_x_(int *status, int *datatype_f, int64_t *count_f, int *ierror)
{
    struct F_MPI_Status status_arg;
    MPI_Count count = (MPI_Count)*count_f;
    C_MPI_Status_set_elements_x(f77_status_arg(status, &status_arg), *datatype_f, &count, ierror);
    f77_status_store(status, &status_arg);
}

extern void C_MPI_Status_set_error(struct F_MPI_Status *status_f, int *error, int *ierror);
void mpi_status_set_error_(int *status, int *error, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Status_set_error(f77_status_arg(status, &status_arg), error, ierror);
    f77_status_store(status, &status_arg);
}

extern void C_MPI_Status_set_source(struct F_MPI_Status *status_f, int *source, int *ierror);
void mpi_status_set_source_(int *status, int *source, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Status_set_source(f77_status_arg(status, &status_arg), source, ierror);
    f77_status_store(status, &status_arg);
}

extern void C_MPI_Status_set_tag(struct F_MPI_Status *status_f, int *tag, int *ierror);
void mpi_status_set_tag_(int *status, int *tag, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Status_set_tag(f77_status_arg(status, &status_arg), tag, ierror);
    f77_status_store(status, &status_arg);
}

extern void C_MPI_Test_cancelled(struct F_MPI_Status *status_f, int *flag, int *ierror);
void mpi_test_cancelled_(int *status, int *flag, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Test_cancelled(f77_status_arg(status, &status_arg), flag, ierror);
    f77_store_logical(flag, *flag);
}

extern void VAPAA_MPI_Type_create_darray(int *size, int *rank, int *ndims, int *gsizes, int *distribs_f, int *dargs_f, int *psizes, int *order_f, int *oldtype_f, int *newtype_f, int *ierror);
void mpi_type_create_darray_(int *size, int *rank, int *ndims, int *gsizes, int *distribs_f, int *dargs_f, int *psizes, int *order_f, int *oldtype_f, int *newtype_f, int *ierror)
{
    VAPAA_MPI_Type_create_darray(size, rank, ndims, gsizes, distribs_f, dargs_f, psizes, order_f, oldtype_f, newtype_f, ierror);
}

extern void VAPAA_MPI_Type_create_f90_complex(int *p, int *r, int *newtype_f, int *ierror);
void mpi_type_create_f90_complex_(int *p, int *r, int *newtype_f, int *ierror)
{
    VAPAA_MPI_Type_create_f90_complex(p, r, newtype_f, ierror);
}

extern void VAPAA_MPI_Type_create_f90_integer(int *r, int *newtype_f, int *ierror);
void mpi_type_create_f90_integer_(int *r, int *newtype_f, int *ierror)
{
    VAPAA_MPI_Type_create_f90_integer(r, newtype_f, ierror);
}

extern void VAPAA_MPI_Type_create_f90_real(int *p, int *r, int *newtype_f, int *ierror);
void mpi_type_create_f90_real_(int *p, int *r, int *newtype_f, int *ierror)
{
    VAPAA_MPI_Type_create_f90_real(p, r, newtype_f, ierror);
}

void mpi_type_extent_(int *datatype_f, intptr_t *extent_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Aint lb = 0, extent = 0;
    *ierror = MPI_Type_get_extent(datatype, &lb, &extent);
    *extent_f = (intptr_t)extent;
    C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_Type_get_extent_x(int *datatype_f, int64_t *lb_f, int64_t *extent_f, int *ierror);
void mpi_type_get_extent_x_(int *datatype_f, int64_t *lb_f, int64_t *extent_f, int *ierror)
{
    VAPAA_MPI_Type_get_extent_x(datatype_f, lb_f, extent_f, ierror);
}

extern void VAPAA_MPI_Type_get_true_extent_x(int *datatype_f, int64_t *lb_f, int64_t *extent_f, int *ierror);
void mpi_type_get_true_extent_x_(int *datatype_f, int64_t *lb_f, int64_t *extent_f, int *ierror)
{
    VAPAA_MPI_Type_get_true_extent_x(datatype_f, lb_f, extent_f, ierror);
}

extern void VAPAA_MPI_Type_get_value_index(int *value_type_f, int *index_type_f, int *pair_type_f, int *ierror);
void mpi_type_get_value_index_(int *value_type_f, int *index_type_f, int *pair_type_f, int *ierror)
{
    VAPAA_MPI_Type_get_value_index(value_type_f, index_type_f, pair_type_f, ierror);
}

extern void VAPAA_MPI_Type_indexed(int *count, int *blocklengths, int *displacements, int *oldtype_f, int *newtype_f, int *ierror);
void mpi_type_indexed_(int *count, int *blocklengths, int *displacements, int *oldtype_f, int *newtype_f, int *ierror)
{
    VAPAA_MPI_Type_indexed(count, blocklengths, displacements, oldtype_f, newtype_f, ierror);
}

extern void VAPAA_MPI_Type_match_size(int *typeclass_f, int *size, int *datatype_f, int *ierror);
void mpi_type_match_size_(int *typeclass_f, int *size, int *datatype_f, int *ierror)
{
    VAPAA_MPI_Type_match_size(typeclass_f, size, datatype_f, ierror);
}

extern void VAPAA_MPI_Type_size_x(int *datatype_f, int64_t *size_f, int *ierror);
void mpi_type_size_x_(int *datatype_f, int64_t *size_f, int *ierror)
{
    VAPAA_MPI_Type_size_x(datatype_f, size_f, ierror);
}

void mpi_unpublish_name_(char *service_name, int *info_f, char *port_name, int *ierror, size_t service_name_len, size_t port_name_len)
{
    char *service_c = f77_string_to_c(service_name, service_name_len); char *port_c = f77_string_to_c(port_name, port_name_len);
    if (service_c == NULL || port_c == NULL) { free(service_c); free(port_c); *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f); *ierror = MPI_Unpublish_name(service_c, info, port_c);
    free(service_c); free(port_c); C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_Win_allocate(intptr_t *size_f, int *disp_unit, int *info_f, int *comm_f, void **baseptr, int *win_f, int *ierror);
void mpi_win_allocate_(intptr_t *size_f, int *disp_unit, int *info_f, int *comm_f, void **baseptr, int *win_f, int *ierror)
{
    VAPAA_MPI_Win_allocate(size_f, disp_unit, info_f, comm_f, baseptr, win_f, ierror);
}

extern void VAPAA_MPI_Win_allocate_shared(intptr_t *size_f, int *disp_unit, int *info_f, int *comm_f, void **baseptr, int *win_f, int *ierror);
void mpi_win_allocate_shared_(intptr_t *size_f, int *disp_unit, int *info_f, int *comm_f, void **baseptr, int *win_f, int *ierror)
{
    VAPAA_MPI_Win_allocate_shared(size_f, disp_unit, info_f, comm_f, baseptr, win_f, ierror);
}

void mpi_win_attach_(int *win_f, void *base, intptr_t *size_f, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_attach(win, f77_addr(base), (MPI_Aint)*size_f);
    C_MPI_RC_FIX(*ierror);
}

extern void C_MPI_Win_call_errhandler(int * win_f, int * errorcode_f, int * ierror);
void mpi_win_call_errhandler_(int * win_f, int * errorcode_f, int * ierror)
{
    C_MPI_Win_call_errhandler(win_f, errorcode_f, ierror);
}

extern void VAPAA_MPI_Win_complete(int *win_f, int *ierror);
void mpi_win_complete_(int *win_f, int *ierror)
{
    VAPAA_MPI_Win_complete(win_f, ierror);
}

void mpi_win_create_(void *base, intptr_t *size_f, int *disp_unit, int *info_f, int *comm_f, int *win_f, int *ierror)
{
    MPI_Win win = MPI_WIN_NULL; MPI_Info info = C_MPI_INFO_FROMINT(*info_f); MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Win_create(f77_addr(base), (MPI_Aint)*size_f, *disp_unit, info, comm, &win);
    if (*ierror == MPI_SUCCESS) (void)MPI_Win_set_name(win, "");
    *win_f = C_MPI_WIN_TOINT(win); C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_Win_create_dynamic(int *info_f, int *comm_f, int *win_f, int *ierror);
void mpi_win_create_dynamic_(int *info_f, int *comm_f, int *win_f, int *ierror)
{
    VAPAA_MPI_Win_create_dynamic(info_f, comm_f, win_f, ierror);
}

extern void VAPAA_MPI_Win_create_errhandler(vapaa_c_funptr fn, int *errhandler_f, int *ierror);
void mpi_win_create_errhandler_(vapaa_c_funptr fn, int *errhandler_f, int *ierror)
{
    VAPAA_MPI_Win_create_errhandler(fn, errhandler_f, ierror);
}

extern void VAPAA_MPI_Win_create_keyval(vapaa_c_funptr copy_fn, vapaa_c_funptr delete_fn, int *keyval, intptr_t *extra_state, int *ierror);
void mpi_win_create_keyval_(vapaa_c_funptr copy_fn, vapaa_c_funptr delete_fn, int *keyval, intptr_t *extra_state, int *ierror)
{
    VAPAA_MPI_Win_create_keyval(copy_fn, delete_fn, keyval, extra_state, ierror);
}

extern void VAPAA_MPI_Win_delete_attr(int *win_f, int *keyval, int *ierror);
void mpi_win_delete_attr_(int *win_f, int *keyval, int *ierror)
{
    VAPAA_MPI_Win_delete_attr(win_f, keyval, ierror);
}

void mpi_win_detach_(int *win_f, void *base, int *ierror)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f);
    *ierror = MPI_Win_detach(win, f77_addr(base));
    C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_Win_fence(int *assert_f, int *win_f, int *ierror);
void mpi_win_fence_(int *assert_f, int *win_f, int *ierror)
{
    VAPAA_MPI_Win_fence(assert_f, win_f, ierror);
}

extern void VAPAA_MPI_Win_flush(int *rank, int *win_f, int *ierror);
void mpi_win_flush_(int *rank, int *win_f, int *ierror)
{
    VAPAA_MPI_Win_flush(rank, win_f, ierror);
}

extern void VAPAA_MPI_Win_flush_all(int *win_f, int *ierror);
void mpi_win_flush_all_(int *win_f, int *ierror)
{
    VAPAA_MPI_Win_flush_all(win_f, ierror);
}

extern void VAPAA_MPI_Win_flush_local(int *rank, int *win_f, int *ierror);
void mpi_win_flush_local_(int *rank, int *win_f, int *ierror)
{
    VAPAA_MPI_Win_flush_local(rank, win_f, ierror);
}

extern void VAPAA_MPI_Win_flush_local_all(int *win_f, int *ierror);
void mpi_win_flush_local_all_(int *win_f, int *ierror)
{
    VAPAA_MPI_Win_flush_local_all(win_f, ierror);
}

extern void VAPAA_MPI_Win_free(int *win_f, int *ierror);
void mpi_win_free_(int *win_f, int *ierror)
{
    VAPAA_MPI_Win_free(win_f, ierror);
}

extern void VAPAA_MPI_Win_free_keyval(int *keyval, int *ierror);
void mpi_win_free_keyval_(int *keyval, int *ierror)
{
    VAPAA_MPI_Win_free_keyval(keyval, ierror);
}

extern void VAPAA_MPI_Win_get_attr(int *win_f, int *keyval, intptr_t *attrval_f, int *flag, int *ierror);
void mpi_win_get_attr_(int *win_f, int *keyval, intptr_t *attrval_f, int *flag, int *ierror)
{
    VAPAA_MPI_Win_get_attr(win_f, keyval, attrval_f, flag, ierror);
}

extern void C_MPI_Win_get_errhandler(int * win_f, int * errhandler_f, int * ierror);
void mpi_win_get_errhandler_(int * win_f, int * errhandler_f, int * ierror)
{
    C_MPI_Win_get_errhandler(win_f, errhandler_f, ierror);
}

extern void VAPAA_MPI_Win_get_group(int *win_f, int *group_f, int *ierror);
void mpi_win_get_group_(int *win_f, int *group_f, int *ierror)
{
    VAPAA_MPI_Win_get_group(win_f, group_f, ierror);
}

extern void VAPAA_MPI_Win_get_info(int *win_f, int *info_f, int *ierror);
void mpi_win_get_info_(int *win_f, int *info_f, int *ierror)
{
    VAPAA_MPI_Win_get_info(win_f, info_f, ierror);
}

void mpi_win_get_name_(int *win_f, char *name, int *resultlen, int *ierror, size_t name_len)
{
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f); char tmp[VAPAA_MPI_MAX_OBJECT_NAME] = {0};
    *ierror = MPI_Win_get_name(win, tmp, resultlen);
    if (*ierror == MPI_SUCCESS) c_string_to_f77(name, name_len, tmp);
    C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_Win_lock(int *lock_type_f, int *rank, int *assert_f, int *win_f, int *ierror);
void mpi_win_lock_(int *lock_type_f, int *rank, int *assert_f, int *win_f, int *ierror)
{
    VAPAA_MPI_Win_lock(lock_type_f, rank, assert_f, win_f, ierror);
}

extern void VAPAA_MPI_Win_lock_all(int *assert_f, int *win_f, int *ierror);
void mpi_win_lock_all_(int *assert_f, int *win_f, int *ierror)
{
    VAPAA_MPI_Win_lock_all(assert_f, win_f, ierror);
}

extern void VAPAA_MPI_Win_post(int *group_f, int *assert_f, int *win_f, int *ierror);
void mpi_win_post_(int *group_f, int *assert_f, int *win_f, int *ierror)
{
    VAPAA_MPI_Win_post(group_f, assert_f, win_f, ierror);
}

extern void VAPAA_MPI_Win_set_attr(int *win_f, int *keyval, intptr_t *attrval_f, int *ierror);
void mpi_win_set_attr_(int *win_f, int *keyval, intptr_t *attrval_f, int *ierror)
{
    VAPAA_MPI_Win_set_attr(win_f, keyval, attrval_f, ierror);
}

extern void C_MPI_Win_set_errhandler(int * win_f, int * errhandler_f, int * ierror);
void mpi_win_set_errhandler_(int * win_f, int * errhandler_f, int * ierror)
{
    C_MPI_Win_set_errhandler(win_f, errhandler_f, ierror);
}

extern void VAPAA_MPI_Win_set_info(int *win_f, int *info_f, int *ierror);
void mpi_win_set_info_(int *win_f, int *info_f, int *ierror)
{
    VAPAA_MPI_Win_set_info(win_f, info_f, ierror);
}

void mpi_win_set_name_(int *win_f, char *name, int *ierror, size_t name_len)
{
    char *name_c = f77_string_to_c(name, name_len); if (name_c == NULL) { *ierror = VAPAA_MPI_ERR_NO_MEM; return; }
    MPI_Win win = C_MPI_WIN_FROMINT(*win_f); *ierror = MPI_Win_set_name(win, name_c);
    free(name_c); C_MPI_RC_FIX(*ierror);
}

extern void VAPAA_MPI_Win_shared_query(int *win_f, int *rank, intptr_t *size_f, int *disp_unit, void **baseptr, int *ierror);
void mpi_win_shared_query_(int *win_f, int *rank, intptr_t *size_f, int *disp_unit, void **baseptr, int *ierror)
{
    VAPAA_MPI_Win_shared_query(win_f, rank, size_f, disp_unit, baseptr, ierror);
}

extern void VAPAA_MPI_Win_start(int *group_f, int *assert_f, int *win_f, int *ierror);
void mpi_win_start_(int *group_f, int *assert_f, int *win_f, int *ierror)
{
    VAPAA_MPI_Win_start(group_f, assert_f, win_f, ierror);
}

extern void VAPAA_MPI_Win_sync(int *win_f, int *ierror);
void mpi_win_sync_(int *win_f, int *ierror)
{
    VAPAA_MPI_Win_sync(win_f, ierror);
}

extern void VAPAA_MPI_Win_test(int *win_f, int *flag, int *ierror);
void mpi_win_test_(int *win_f, int *flag, int *ierror)
{
    VAPAA_MPI_Win_test(win_f, flag, ierror);
}

extern void VAPAA_MPI_Win_unlock(int *rank, int *win_f, int *ierror);
void mpi_win_unlock_(int *rank, int *win_f, int *ierror)
{
    VAPAA_MPI_Win_unlock(rank, win_f, ierror);
}

extern void VAPAA_MPI_Win_unlock_all(int *win_f, int *ierror);
void mpi_win_unlock_all_(int *win_f, int *ierror)
{
    VAPAA_MPI_Win_unlock_all(win_f, ierror);
}

extern void VAPAA_MPI_Win_wait(int *win_f, int *ierror);
void mpi_win_wait_(int *win_f, int *ierror)
{
    VAPAA_MPI_Win_wait(win_f, ierror);
}
