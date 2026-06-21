// SPDX-License-Identifier: MIT

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "detect_builtins.h"
#include "detect_sentinels.h"
#include "cfi_util.h"
#include "vapaa_error_handling.h"
#include "debug.h"
#include "vapaa_wcollective_grequest.h"

static bool VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(MPI_Op op, MPI_Datatype datatype)
{
#if MPI_VERSION >= 5
    (void)op;
    (void)datatype;
    return false;
#else
    return !C_MPI_OP_IS_BUILTIN(op) && C_MPI_TYPE_IS_BUILTIN(datatype);
#endif
}

static void *VAPAA_COLL_ADDR(CFI_cdesc_t *desc)
{
    return C_IS_MPI_BOTTOM(desc->base_addr) ? MPI_BOTTOM : desc->base_addr;
}

static void *VAPAA_COLL_IN_ADDR(CFI_cdesc_t *desc)
{
    return C_IS_MPI_IN_PLACE(desc->base_addr) ? MPI_IN_PLACE : VAPAA_COLL_ADDR(desc);
}

static int VAPAA_COLL_REQUIRE_CONTIG1(CFI_cdesc_t *a, MPI_Comm comm)
{
    if (VAPAA_CFI_is_contiguous(a) == 1) {
        return 1;
    }
    VAPAA_Warning("this MPI wrapper requires contiguous buffers.\n");
    MPI_Abort(comm, 99);
    return 0;
}

static int VAPAA_COLL_REQUIRE_CONTIG2(CFI_cdesc_t *a, CFI_cdesc_t *b, MPI_Comm comm)
{
    if (VAPAA_CFI_is_contiguous(a) == 1 && VAPAA_CFI_is_contiguous(b) == 1) {
        return 1;
    }
    VAPAA_Warning("this MPI wrapper requires contiguous buffers.\n");
    MPI_Abort(comm, 99);
    return 0;
}

static MPI_Datatype *VAPAA_COLL_TYPES_FROMINT(const int types_f[], int n)
{
    if (n <= 0) {
        return NULL;
    }
    MPI_Datatype *types = malloc((size_t)n * sizeof(*types));
    VAPAA_Assert(types != NULL);
    for (int i = 0; i < n; ++i) {
        types[i] = C_MPI_TYPE_FROMINT(types_f[i]);
    }
    return types;
}

static MPI_Datatype *VAPAA_COLL_NULL_TYPES(int n)
{
    if (n <= 0) {
        return NULL;
    }
    MPI_Datatype *types = malloc((size_t)n * sizeof(*types));
    VAPAA_Assert(types != NULL);
    for (int i = 0; i < n; ++i) {
        types[i] = MPI_DATATYPE_NULL;
    }
    return types;
}

static void VAPAA_COLL_WARN_DATATYPE_ARRAY(CFI_cdesc_t *desc, const MPI_Datatype types[], int n,
                                           const char *mpi_function)
{
    for (int i = 0; i < n; ++i) {
        bool seen = false;
        for (int j = 0; j < i; ++j) {
            if (types[j] == types[i]) {
                seen = true;
                break;
            }
        }
        if (!seen) {
            VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, types[i], mpi_function);
        }
    }
}

static MPI_Aint *VAPAA_COLL_AINTS_FROM_INTPTR(const intptr_t aints_f[], int n)
{
    if (n <= 0) {
        return NULL;
    }
    MPI_Aint *aints = malloc((size_t)n * sizeof(*aints));
    VAPAA_Assert(aints != NULL);
    for (int i = 0; i < n; ++i) {
        aints[i] = (MPI_Aint)aints_f[i];
    }
    return aints;
}

static int VAPAA_COLL_Alltoallw_in_place(void *buffer, const int recvcounts[],
                                         const int rdispls[], const MPI_Datatype recvtypes[],
                                         MPI_Comm comm)
{
    MPI_Comm p2p_comm = MPI_COMM_NULL;
    int rank = 0, size = 0, rc = MPI_SUCCESS;

    rc = MPI_Comm_dup(comm, &p2p_comm);
    if (rc != MPI_SUCCESS) return rc;
    rc = MPI_Comm_rank(p2p_comm, &rank);
    if (rc == MPI_SUCCESS) rc = MPI_Comm_size(p2p_comm, &size);

    for (int peer = 0; rc == MPI_SUCCESS && peer < size; ++peer) {
        if (peer == rank || recvcounts[peer] == 0) {
            continue;
        }
        char *addr = (char *)buffer + rdispls[peer];
        rc = MPI_Sendrecv_replace(addr, recvcounts[peer], recvtypes[peer], peer, 0, peer, 0,
                                  p2p_comm, MPI_STATUS_IGNORE);
    }

    int free_rc = MPI_Comm_free(&p2p_comm);
    return rc == MPI_SUCCESS ? free_rc : rc;
}

static void VAPAA_COLL_NEIGHBOR_DEGREES(MPI_Comm comm, int *indegree, int *outdegree)
{
    int topo = MPI_UNDEFINED;
    *indegree = 0;
    *outdegree = 0;
    if (MPI_Topo_test(comm, &topo) != MPI_SUCCESS) {
        return;
    }
    if (topo == MPI_DIST_GRAPH) {
        int weighted = 0;
        (void)MPI_Dist_graph_neighbors_count(comm, indegree, outdegree, &weighted);
    } else if (topo == MPI_CART) {
        int ndims = 0;
        (void)MPI_Cartdim_get(comm, &ndims);
        *indegree = 2 * ndims;
        *outdegree = 2 * ndims;
    } else if (topo == MPI_GRAPH) {
        int rank = 0, degree = 0;
        (void)MPI_Comm_rank(comm, &rank);
        (void)MPI_Graph_neighbors_count(comm, rank, &degree);
        *indegree = degree;
        *outdegree = degree;
    }
}

static void VAPAA_COLL_FINISH_REQUEST(MPI_Request request, int *request_f, int *ierror)
{
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}

MAYBE_UNUSED static void VAPAA_COLL_UNSUPPORTED_REQUEST(int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    VAPAA_MPI_handle_synthetic_error_comm(C_MPI_COMM_FROMINT(*comm_f), ierror);
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Alltoallw(CFI_cdesc_t *sendbuf, const int sendcounts[], const int sdispls[],
                         const int sendtypes_f[], CFI_cdesc_t *recvbuf, const int recvcounts[],
                         const int rdispls[], const int recvtypes_f[], int *comm_f, int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (!VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        return;
    }
    int size = 0;
    (void)MPI_Comm_size(comm, &size);
    MPI_Datatype *recvtypes = VAPAA_COLL_TYPES_FROMINT(recvtypes_f, size);
    VAPAA_COLL_WARN_DATATYPE_ARRAY(recvbuf, recvtypes, size, "MPI_Alltoallw");
    void *send_addr = VAPAA_COLL_IN_ADDR(sendbuf);
    if (send_addr == MPI_IN_PLACE) {
        *ierror = VAPAA_COLL_Alltoallw_in_place(VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm);
    } else {
        MPI_Datatype *sendtypes = VAPAA_COLL_TYPES_FROMINT(sendtypes_f, size);
        VAPAA_COLL_WARN_DATATYPE_ARRAY(sendbuf, sendtypes, size, "MPI_Alltoallw");
        *ierror = MPI_Alltoallw(send_addr, sendcounts, sdispls, sendtypes,
                                VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm);
        free(sendtypes);
    }
    free(recvtypes);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Ibarrier(int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Ibarrier(comm, &request);
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Barrier_init(int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Barrier_init(comm, info, &request);
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) comm_f;
    (void) info_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

void VAPAA_MPI_Ibcast(CFI_cdesc_t *buffer, int *count, int *datatype_f, int *root, int *comm_f,
                      int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(buffer, datatype, "MPI_Ibcast");
    if (VAPAA_COLL_REQUIRE_CONTIG1(buffer, comm)) {
        *ierror = MPI_Ibcast(VAPAA_COLL_ADDR(buffer), *count, datatype, C_MPI_ROOT_F2C(*root), comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Bcast_init(CFI_cdesc_t *buffer, int *count, int *datatype_f, int *root, int *comm_f, int *info_f,
                          int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(buffer, datatype, "MPI_Bcast_init");
    if (VAPAA_COLL_REQUIRE_CONTIG1(buffer, comm)) {
        *ierror = MPI_Bcast_init(VAPAA_COLL_ADDR(buffer), *count, datatype, C_MPI_ROOT_F2C(*root), comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) buffer;
    (void) count;
    (void) datatype_f;
    (void) root;
    (void) comm_f;
    (void) info_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

#define VAPAA_REDUCE_REQ_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, \
          int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); \
    MPI_Op op = C_MPI_OP_FROMINT(*op_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(sendbuf, datatype); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(recvbuf, datatype); \
    if (VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) { \
        *ierror = MPI_ERR_OP; \
    } else if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_IN_ADDR(sendbuf), VAPAA_COLL_ADDR(recvbuf), *count, datatype, op, comm, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}

#if MPI_VERSION >= 4
#define VAPAA_REDUCE_INIT_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, int *info_f, \
          int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); \
    MPI_Op op = C_MPI_OP_FROMINT(*op_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(sendbuf, datatype); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(recvbuf, datatype); \
    if (VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) { \
        *ierror = MPI_ERR_OP; \
    } else if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_IN_ADDR(sendbuf), VAPAA_COLL_ADDR(recvbuf), *count, datatype, op, comm, info, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}
#else
#define VAPAA_REDUCE_INIT_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, int *info_f, \
          int *request_f, int *ierror) \
{ \
    (void) sendbuf; (void) recvbuf; (void) count; (void) datatype_f; (void) op_f; (void) comm_f; (void) info_f; \
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror); \
}
#endif

VAPAA_REDUCE_REQ_WRAPPER(VAPAA_MPI_Iallreduce, MPI_Iallreduce)
VAPAA_REDUCE_REQ_WRAPPER(VAPAA_MPI_Iscan, MPI_Iscan)
VAPAA_REDUCE_REQ_WRAPPER(VAPAA_MPI_Iexscan, MPI_Iexscan)
VAPAA_REDUCE_INIT_WRAPPER(VAPAA_MPI_Allreduce_init, MPI_Allreduce_init)
VAPAA_REDUCE_INIT_WRAPPER(VAPAA_MPI_Scan_init, MPI_Scan_init)
VAPAA_REDUCE_INIT_WRAPPER(VAPAA_MPI_Exscan_init, MPI_Exscan_init)

void VAPAA_MPI_Ireduce(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *count, int *datatype_f, int *op_f,
                       int *root, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, datatype, "MPI_Ireduce");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, datatype, "MPI_Ireduce");
    if (VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Ireduce(VAPAA_COLL_IN_ADDR(sendbuf), VAPAA_COLL_ADDR(recvbuf), *count, datatype, op,
                              C_MPI_ROOT_F2C(*root), comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Reduce_init(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *count, int *datatype_f, int *op_f,
                           int *root, int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, datatype, "MPI_Reduce_init");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, datatype, "MPI_Reduce_init");
    if (VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Reduce_init(VAPAA_COLL_IN_ADDR(sendbuf), VAPAA_COLL_ADDR(recvbuf), *count, datatype, op,
                                  C_MPI_ROOT_F2C(*root), comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) sendbuf; (void) recvbuf; (void) count; (void) datatype_f; (void) op_f;
    (void) root; (void) comm_f; (void) info_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

#define VAPAA_GATHER_REQ_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *root, int *comm_f, int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f); \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(sendbuf, sendtype); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(recvbuf, recvtype); \
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype, \
                         C_MPI_ROOT_F2C(*root), comm, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}

#if MPI_VERSION >= 4
#define VAPAA_GATHER_INIT_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *root, int *comm_f, int *info_f, int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f); \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(sendbuf, sendtype); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(recvbuf, recvtype); \
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype, \
                         C_MPI_ROOT_F2C(*root), comm, info, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}
#else
#define VAPAA_GATHER_INIT_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *root, int *comm_f, int *info_f, int *request_f, int *ierror) \
{ \
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) recvbuf; (void) recvcount; (void) recvtype_f; \
    (void) root; (void) comm_f; (void) info_f; \
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror); \
}
#endif

VAPAA_GATHER_REQ_WRAPPER(VAPAA_MPI_Igather, MPI_Igather)
VAPAA_GATHER_REQ_WRAPPER(VAPAA_MPI_Iscatter, MPI_Iscatter)
VAPAA_GATHER_INIT_WRAPPER(VAPAA_MPI_Gather_init, MPI_Gather_init)
VAPAA_GATHER_INIT_WRAPPER(VAPAA_MPI_Scatter_init, MPI_Scatter_init)

#define VAPAA_ALLGATHER_REQ_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *comm_f, int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f); \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(sendbuf, sendtype); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(recvbuf, recvtype); \
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype, \
                         comm, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}

#if MPI_VERSION >= 4
#define VAPAA_ALLGATHER_INIT_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *comm_f, int *info_f, int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f); \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(sendbuf, sendtype); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(recvbuf, recvtype); \
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype, \
                         comm, info, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}
#else
#define VAPAA_ALLGATHER_INIT_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *comm_f, int *info_f, int *request_f, int *ierror) \
{ \
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) recvbuf; (void) recvcount; (void) recvtype_f; \
    (void) comm_f; (void) info_f; \
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror); \
}
#endif

VAPAA_ALLGATHER_REQ_WRAPPER(VAPAA_MPI_Iallgather, MPI_Iallgather)
VAPAA_ALLGATHER_REQ_WRAPPER(VAPAA_MPI_Ialltoall, MPI_Ialltoall)
VAPAA_ALLGATHER_INIT_WRAPPER(VAPAA_MPI_Allgather_init, MPI_Allgather_init)
VAPAA_ALLGATHER_INIT_WRAPPER(VAPAA_MPI_Alltoall_init, MPI_Alltoall_init)

void VAPAA_MPI_Igatherv(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf,
                        const int recvcounts[], const int displs[], int *recvtype_f, int *root, int *comm_f,
                        int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Igatherv");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Igatherv");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Igatherv(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf),
                               recvcounts, displs, recvtype, C_MPI_ROOT_F2C(*root), comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Gatherv_init(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf,
                            const int recvcounts[], const int displs[], int *recvtype_f, int *root, int *comm_f,
                            int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Gatherv_init");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Gatherv_init");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Gatherv_init(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                   recvcounts, displs, recvtype, C_MPI_ROOT_F2C(*root), comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) recvbuf; (void) recvcounts; (void) displs;
    (void) recvtype_f; (void) root; (void) comm_f; (void) info_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

void VAPAA_MPI_Iscatterv(CFI_cdesc_t *sendbuf, const int sendcounts[], const int displs[], int *sendtype_f,
                         CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, int *root, int *comm_f,
                         int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Iscatterv");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Iscatterv");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Iscatterv(VAPAA_COLL_IN_ADDR(sendbuf), sendcounts, displs, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                *recvcount, recvtype, C_MPI_ROOT_F2C(*root), comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Scatterv_init(CFI_cdesc_t *sendbuf, const int sendcounts[], const int displs[], int *sendtype_f,
                             CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, int *root, int *comm_f,
                             int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Scatterv_init");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Scatterv_init");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Scatterv_init(VAPAA_COLL_IN_ADDR(sendbuf), sendcounts, displs, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                    *recvcount, recvtype, C_MPI_ROOT_F2C(*root), comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcounts; (void) displs; (void) sendtype_f; (void) recvbuf; (void) recvcount;
    (void) recvtype_f; (void) root; (void) comm_f; (void) info_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

void VAPAA_MPI_Iallgatherv(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf,
                           const int recvcounts[], const int displs[], int *recvtype_f, int *comm_f,
                           int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Iallgatherv");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Iallgatherv");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Iallgatherv(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                  recvcounts, displs, recvtype, comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Allgatherv_init(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf,
                               const int recvcounts[], const int displs[], int *recvtype_f, int *comm_f,
                               int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Allgatherv_init");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Allgatherv_init");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Allgatherv_init(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                      recvcounts, displs, recvtype, comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) recvbuf; (void) recvcounts; (void) displs;
    (void) recvtype_f; (void) comm_f; (void) info_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

void VAPAA_MPI_Ialltoallv(CFI_cdesc_t *sendbuf, const int sendcounts[], const int sdispls[], int *sendtype_f,
                          CFI_cdesc_t *recvbuf, const int recvcounts[], const int rdispls[], int *recvtype_f,
                          int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Ialltoallv");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Ialltoallv");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Ialltoallv(VAPAA_COLL_IN_ADDR(sendbuf), sendcounts, sdispls, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                 recvcounts, rdispls, recvtype, comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Alltoallv_init(CFI_cdesc_t *sendbuf, const int sendcounts[], const int sdispls[], int *sendtype_f,
                              CFI_cdesc_t *recvbuf, const int recvcounts[], const int rdispls[], int *recvtype_f,
                              int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Alltoallv_init");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Alltoallv_init");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Alltoallv_init(VAPAA_COLL_IN_ADDR(sendbuf), sendcounts, sdispls, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                     recvcounts, rdispls, recvtype, comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcounts; (void) sdispls; (void) sendtype_f; (void) recvbuf; (void) recvcounts;
    (void) rdispls; (void) recvtype_f; (void) comm_f; (void) info_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

void VAPAA_MPI_Ialltoallw(CFI_cdesc_t *sendbuf, const int sendcounts[], const int sdispls[],
                          const int sendtypes_f[], CFI_cdesc_t *recvbuf, const int recvcounts[],
                          const int rdispls[], const int recvtypes_f[], int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        int size = 0;
        (void)MPI_Comm_size(comm, &size);
        MPI_Datatype *recvtypes = VAPAA_COLL_TYPES_FROMINT(recvtypes_f, size);
        VAPAA_COLL_WARN_DATATYPE_ARRAY(recvbuf, recvtypes, size, "MPI_Ialltoallw");
        if (VAPAA_COLL_IN_ADDR(sendbuf) == MPI_IN_PLACE) {
            int *zero_counts = calloc((size_t)(size > 0 ? size : 1), sizeof(*zero_counts));
            int *zero_displs = calloc((size_t)(size > 0 ? size : 1), sizeof(*zero_displs));
            MPI_Datatype *sendtypes = VAPAA_COLL_NULL_TYPES(size);
            VAPAA_Assert(zero_counts != NULL && zero_displs != NULL);
            *ierror = VAPAA_Grequest_alltoallw(MPI_IN_PLACE, zero_counts, zero_displs, sendtypes,
                                                VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm,
                                                zero_counts, zero_displs, sendtypes, recvtypes, &request);
        } else {
            MPI_Datatype *sendtypes = VAPAA_COLL_TYPES_FROMINT(sendtypes_f, size);
            VAPAA_COLL_WARN_DATATYPE_ARRAY(sendbuf, sendtypes, size, "MPI_Ialltoallw");
            *ierror = VAPAA_Grequest_alltoallw(VAPAA_COLL_ADDR(sendbuf), sendcounts, sdispls, sendtypes,
                                                VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm,
                                                NULL, NULL, sendtypes, recvtypes, &request);
        }
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Alltoallw_init(CFI_cdesc_t *sendbuf, const int sendcounts[], const int sdispls[],
                              const int sendtypes_f[], CFI_cdesc_t *recvbuf, const int recvcounts[],
                              const int rdispls[], const int recvtypes_f[], int *comm_f, int *info_f,
                              int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        int size = 0;
        (void)MPI_Comm_size(comm, &size);
        MPI_Datatype *recvtypes = VAPAA_COLL_TYPES_FROMINT(recvtypes_f, size);
        VAPAA_COLL_WARN_DATATYPE_ARRAY(recvbuf, recvtypes, size, "MPI_Alltoallw_init");
        if (VAPAA_COLL_IN_ADDR(sendbuf) == MPI_IN_PLACE) {
            int *zero_counts = calloc((size_t)(size > 0 ? size : 1), sizeof(*zero_counts));
            int *zero_displs = calloc((size_t)(size > 0 ? size : 1), sizeof(*zero_displs));
            MPI_Datatype *sendtypes = VAPAA_COLL_NULL_TYPES(size);
            VAPAA_Assert(zero_counts != NULL && zero_displs != NULL);
            *ierror = MPI_Alltoallw_init(MPI_IN_PLACE, zero_counts, zero_displs, sendtypes,
                                         VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm, info,
                                         &request);
            free(zero_counts);
            free(zero_displs);
            free(sendtypes);
        } else {
            MPI_Datatype *sendtypes = VAPAA_COLL_TYPES_FROMINT(sendtypes_f, size);
            VAPAA_COLL_WARN_DATATYPE_ARRAY(sendbuf, sendtypes, size, "MPI_Alltoallw_init");
            *ierror = MPI_Alltoallw_init(VAPAA_COLL_ADDR(sendbuf), sendcounts, sdispls, sendtypes,
                                         VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm, info,
                                         &request);
            free(sendtypes);
        }
        free(recvtypes);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcounts; (void) sdispls; (void) sendtypes_f; (void) recvbuf; (void) recvcounts;
    (void) rdispls; (void) recvtypes_f; (void) comm_f; (void) info_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

void VAPAA_MPI_Ireduce_scatter(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, const int recvcounts[],
                               int *datatype_f, int *op_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, datatype, "MPI_Ireduce_scatter");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, datatype, "MPI_Ireduce_scatter");
    if (VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Ireduce_scatter(VAPAA_COLL_IN_ADDR(sendbuf), VAPAA_COLL_ADDR(recvbuf), recvcounts,
                                      datatype, op, comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Reduce_scatter_init(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, const int recvcounts[],
                                   int *datatype_f, int *op_f, int *comm_f, int *info_f, int *request_f,
                                   int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, datatype, "MPI_Reduce_scatter_init");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, datatype, "MPI_Reduce_scatter_init");
    if (VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Reduce_scatter_init(VAPAA_COLL_IN_ADDR(sendbuf), VAPAA_COLL_ADDR(recvbuf), recvcounts,
                                          datatype, op, comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) sendbuf; (void) recvbuf; (void) recvcounts; (void) datatype_f; (void) op_f; (void) comm_f; (void) info_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

void VAPAA_MPI_Ireduce_scatter_block(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *recvcount,
                                     int *datatype_f, int *op_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, datatype, "MPI_Ireduce_scatter_block");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, datatype, "MPI_Ireduce_scatter_block");
    if (VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Ireduce_scatter_block(VAPAA_COLL_IN_ADDR(sendbuf), VAPAA_COLL_ADDR(recvbuf), *recvcount,
                                            datatype, op, comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Reduce_scatter_block_init(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *recvcount,
                                         int *datatype_f, int *op_f, int *comm_f, int *info_f, int *request_f,
                                         int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, datatype, "MPI_Reduce_scatter_block_init");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, datatype, "MPI_Reduce_scatter_block_init");
    if (VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Reduce_scatter_block_init(VAPAA_COLL_IN_ADDR(sendbuf), VAPAA_COLL_ADDR(recvbuf), *recvcount,
                                                datatype, op, comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) sendbuf; (void) recvbuf; (void) recvcount; (void) datatype_f; (void) op_f; (void) comm_f; (void) info_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

void VAPAA_MPI_Isendrecv(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, int *dest, int *sendtag,
                         CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, int *source, int *recvtag,
                         int *comm_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Isendrecv");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Isendrecv");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Isendrecv(VAPAA_COLL_ADDR(sendbuf), *sendcount, sendtype, C_MPI_DEST_F2C(*dest),
                                C_MPI_TAG_F2C(*sendtag), VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype,
                                C_MPI_SOURCE_F2C(*source), C_MPI_TAG_F2C(*recvtag), comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) dest; (void) sendtag;
    (void) recvbuf; (void) recvcount; (void) recvtype_f; (void) source; (void) recvtag; (void) comm_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

void VAPAA_MPI_Isendrecv_replace(CFI_cdesc_t *buf, int *count, int *datatype_f, int *dest, int *sendtag,
                                 int *source, int *recvtag, int *comm_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(buf, datatype, "MPI_Isendrecv_replace");
    if (VAPAA_COLL_REQUIRE_CONTIG1(buf, comm)) {
        *ierror = MPI_Isendrecv_replace(VAPAA_COLL_ADDR(buf), *count, datatype, C_MPI_DEST_F2C(*dest),
                                        C_MPI_TAG_F2C(*sendtag), C_MPI_SOURCE_F2C(*source),
                                        C_MPI_TAG_F2C(*recvtag), comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) buf; (void) count; (void) datatype_f; (void) dest; (void) sendtag; (void) source; (void) recvtag; (void) comm_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

#define VAPAA_NEIGHBOR_SIMPLE(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *comm_f, int *ierror) \
{ \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f); \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(sendbuf, sendtype); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(recvbuf, recvtype); \
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype, comm); \
    } \
    C_MPI_RC_FIX(*ierror); \
}

#define VAPAA_NEIGHBOR_SIMPLE_REQ(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *comm_f, int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f); \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(sendbuf, sendtype); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(recvbuf, recvtype); \
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype, comm, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}

#if MPI_VERSION >= 4
#define VAPAA_NEIGHBOR_SIMPLE_INIT(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *comm_f, int *info_f, int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f); \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(sendbuf, sendtype); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(recvbuf, recvtype); \
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype, comm, info, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}
#else
#define VAPAA_NEIGHBOR_SIMPLE_INIT(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *comm_f, int *info_f, int *request_f, int *ierror) \
{ \
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) recvbuf; (void) recvcount; (void) recvtype_f; \
    (void) comm_f; (void) info_f; \
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror); \
}
#endif

VAPAA_NEIGHBOR_SIMPLE(VAPAA_MPI_Neighbor_allgather, MPI_Neighbor_allgather)
VAPAA_NEIGHBOR_SIMPLE(VAPAA_MPI_Neighbor_alltoall, MPI_Neighbor_alltoall)
VAPAA_NEIGHBOR_SIMPLE_REQ(VAPAA_MPI_Ineighbor_allgather, MPI_Ineighbor_allgather)
VAPAA_NEIGHBOR_SIMPLE_REQ(VAPAA_MPI_Ineighbor_alltoall, MPI_Ineighbor_alltoall)
VAPAA_NEIGHBOR_SIMPLE_INIT(VAPAA_MPI_Neighbor_allgather_init, MPI_Neighbor_allgather_init)
VAPAA_NEIGHBOR_SIMPLE_INIT(VAPAA_MPI_Neighbor_alltoall_init, MPI_Neighbor_alltoall_init)

void VAPAA_MPI_Neighbor_allgatherv(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf,
                                   const int recvcounts[], const int displs[], int *recvtype_f, int *comm_f,
                                   int *ierror)
{
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Neighbor_allgatherv");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Neighbor_allgatherv");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Neighbor_allgatherv(VAPAA_COLL_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                          recvcounts, displs, recvtype, comm);
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Ineighbor_allgatherv(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf,
                                    const int recvcounts[], const int displs[], int *recvtype_f, int *comm_f,
                                    int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Ineighbor_allgatherv");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Ineighbor_allgatherv");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Ineighbor_allgatherv(VAPAA_COLL_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                           recvcounts, displs, recvtype, comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Neighbor_allgatherv_init(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf,
                                        const int recvcounts[], const int displs[], int *recvtype_f, int *comm_f,
                                        int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Neighbor_allgatherv_init");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Neighbor_allgatherv_init");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Neighbor_allgatherv_init(VAPAA_COLL_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                               recvcounts, displs, recvtype, comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) recvbuf; (void) recvcounts; (void) displs;
    (void) recvtype_f; (void) comm_f; (void) info_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

void VAPAA_MPI_Neighbor_alltoallv(CFI_cdesc_t *sendbuf, const int sendcounts[], const int sdispls[], int *sendtype_f,
                                  CFI_cdesc_t *recvbuf, const int recvcounts[], const int rdispls[], int *recvtype_f,
                                  int *comm_f, int *ierror)
{
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Neighbor_alltoallv");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Neighbor_alltoallv");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Neighbor_alltoallv(VAPAA_COLL_ADDR(sendbuf), sendcounts, sdispls, sendtype,
                                         VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtype, comm);
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Ineighbor_alltoallv(CFI_cdesc_t *sendbuf, const int sendcounts[], const int sdispls[], int *sendtype_f,
                                   CFI_cdesc_t *recvbuf, const int recvcounts[], const int rdispls[], int *recvtype_f,
                                   int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Ineighbor_alltoallv");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Ineighbor_alltoallv");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Ineighbor_alltoallv(VAPAA_COLL_ADDR(sendbuf), sendcounts, sdispls, sendtype,
                                          VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtype, comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Neighbor_alltoallv_init(CFI_cdesc_t *sendbuf, const int sendcounts[], const int sdispls[], int *sendtype_f,
                                       CFI_cdesc_t *recvbuf, const int recvcounts[], const int rdispls[], int *recvtype_f,
                                       int *comm_f, int *info_f, int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(sendbuf, sendtype, "MPI_Neighbor_alltoallv_init");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(recvbuf, recvtype, "MPI_Neighbor_alltoallv_init");
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Neighbor_alltoallv_init(VAPAA_COLL_ADDR(sendbuf), sendcounts, sdispls, sendtype,
                                              VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtype, comm, info,
                                              &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcounts; (void) sdispls; (void) sendtype_f; (void) recvbuf; (void) recvcounts;
    (void) rdispls; (void) recvtype_f; (void) comm_f; (void) info_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}

static void VAPAA_COLL_NEIGHBOR_ALLTOALLW_TYPES(MPI_Comm comm, const int sendtypes_f[], const int recvtypes_f[],
                                                MPI_Datatype **sendtypes, MPI_Datatype **recvtypes,
                                                int *outdegree, int *indegree)
{
    VAPAA_COLL_NEIGHBOR_DEGREES(comm, indegree, outdegree);
    *sendtypes = VAPAA_COLL_TYPES_FROMINT(sendtypes_f, *outdegree);
    *recvtypes = VAPAA_COLL_TYPES_FROMINT(recvtypes_f, *indegree);
}

void VAPAA_MPI_Neighbor_alltoallw(CFI_cdesc_t *sendbuf, const int sendcounts[], const intptr_t sdispls_f[],
                                  const int sendtypes_f[], CFI_cdesc_t *recvbuf, const int recvcounts[],
                                  const intptr_t rdispls_f[], const int recvtypes_f[], int *comm_f, int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        int outdegree = 0, indegree = 0;
        MPI_Datatype *sendtypes = NULL, *recvtypes = NULL;
        VAPAA_COLL_NEIGHBOR_ALLTOALLW_TYPES(comm, sendtypes_f, recvtypes_f, &sendtypes, &recvtypes, &outdegree, &indegree);
        VAPAA_COLL_WARN_DATATYPE_ARRAY(sendbuf, sendtypes, outdegree, "MPI_Neighbor_alltoallw");
        VAPAA_COLL_WARN_DATATYPE_ARRAY(recvbuf, recvtypes, indegree, "MPI_Neighbor_alltoallw");
        MPI_Aint *sdispls = VAPAA_COLL_AINTS_FROM_INTPTR(sdispls_f, outdegree);
        MPI_Aint *rdispls = VAPAA_COLL_AINTS_FROM_INTPTR(rdispls_f, indegree);
        *ierror = MPI_Neighbor_alltoallw(VAPAA_COLL_ADDR(sendbuf), sendcounts, sdispls, sendtypes,
                                         VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm);
        free(sendtypes); free(recvtypes); free(sdispls); free(rdispls);
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Ineighbor_alltoallw(CFI_cdesc_t *sendbuf, const int sendcounts[], const intptr_t sdispls_f[],
                                   const int sendtypes_f[], CFI_cdesc_t *recvbuf, const int recvcounts[],
                                   const intptr_t rdispls_f[], const int recvtypes_f[], int *comm_f, int *request_f,
                                   int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        int outdegree = 0, indegree = 0;
        MPI_Datatype *sendtypes = NULL, *recvtypes = NULL;
        VAPAA_COLL_NEIGHBOR_ALLTOALLW_TYPES(comm, sendtypes_f, recvtypes_f, &sendtypes, &recvtypes, &outdegree, &indegree);
        VAPAA_COLL_WARN_DATATYPE_ARRAY(sendbuf, sendtypes, outdegree, "MPI_Ineighbor_alltoallw");
        VAPAA_COLL_WARN_DATATYPE_ARRAY(recvbuf, recvtypes, indegree, "MPI_Ineighbor_alltoallw");
        MPI_Aint *sdispls = VAPAA_COLL_AINTS_FROM_INTPTR(sdispls_f, outdegree);
        MPI_Aint *rdispls = VAPAA_COLL_AINTS_FROM_INTPTR(rdispls_f, indegree);
        *ierror = VAPAA_Grequest_neighbor_alltoallw(VAPAA_COLL_ADDR(sendbuf), sendcounts, sdispls, sendtypes,
                                                    VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm,
                                                    sdispls, sendtypes, rdispls, recvtypes, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Neighbor_alltoallw_init(CFI_cdesc_t *sendbuf, const int sendcounts[], const intptr_t sdispls_f[],
                                       const int sendtypes_f[], CFI_cdesc_t *recvbuf, const int recvcounts[],
                                       const intptr_t rdispls_f[], const int recvtypes_f[], int *comm_f, int *info_f,
                                       int *request_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        int outdegree = 0, indegree = 0;
        MPI_Datatype *sendtypes = NULL, *recvtypes = NULL;
        VAPAA_COLL_NEIGHBOR_ALLTOALLW_TYPES(comm, sendtypes_f, recvtypes_f, &sendtypes, &recvtypes, &outdegree, &indegree);
        VAPAA_COLL_WARN_DATATYPE_ARRAY(sendbuf, sendtypes, outdegree, "MPI_Neighbor_alltoallw_init");
        VAPAA_COLL_WARN_DATATYPE_ARRAY(recvbuf, recvtypes, indegree, "MPI_Neighbor_alltoallw_init");
        MPI_Aint *sdispls = VAPAA_COLL_AINTS_FROM_INTPTR(sdispls_f, outdegree);
        MPI_Aint *rdispls = VAPAA_COLL_AINTS_FROM_INTPTR(rdispls_f, indegree);
        *ierror = MPI_Neighbor_alltoallw_init(VAPAA_COLL_ADDR(sendbuf), sendcounts, sdispls, sendtypes,
                                              VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm, info,
                                              &request);
        free(sendtypes); free(recvtypes); free(sdispls); free(rdispls);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcounts; (void) sdispls_f; (void) sendtypes_f; (void) recvbuf; (void) recvcounts;
    (void) rdispls_f; (void) recvtypes_f; (void) comm_f; (void) info_f;
    VAPAA_COLL_UNSUPPORTED_REQUEST(comm_f, request_f, ierror);
#endif
}
