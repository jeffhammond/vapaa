// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdlib.h>
#include <mpi.h>

#include "convert_constants.h"
#include "convert_handles.h"
#include "debug.h"
#include "detect_builtins.h"
#include "pgif_util.h"
#include "vapaa_error_handling.h"

#ifdef HAVE_PGIF

static int pgif_reject_user_op_with_builtin_type(MPI_Op op, MPI_Datatype datatype)
{
#if MPI_VERSION >= 5
    (void) op;
    (void) datatype;
    return 0;
#else
    return !C_MPI_OP_IS_BUILTIN(op) && C_MPI_TYPE_IS_BUILTIN(datatype);
#endif
}

static void finish_request(MPI_Request request, int *request_f, int *ierror)
{
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}

static void unsupported_request(int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    VAPAA_MPI_handle_synthetic_error_comm(C_MPI_COMM_FROMINT(*comm_f), ierror);
    finish_request(request, request_f, ierror);
}

static int require_contig1(const VAPAA_PGIF_Desc *a, MPI_Comm comm)
{
    if (VAPAA_PGIF_buffer_is_contiguous(a)) {
        return 1;
    }
    VAPAA_Warning("this MPI wrapper requires contiguous buffers.\n");
    MPI_Abort(comm, 99);
    return 0;
}

static int require_contig2(const VAPAA_PGIF_Desc *a, const VAPAA_PGIF_Desc *b,
                           MPI_Comm comm)
{
    return require_contig1(a, comm) && require_contig1(b, comm);
}

static void release2(VAPAA_PGIF_Buffer *a, VAPAA_PGIF_Buffer *b)
{
    int rc = VAPAA_PGIF_RELEASE_BUFFER(a);
    VAPAA_Assert(rc == MPI_SUCCESS);
    rc = VAPAA_PGIF_RELEASE_BUFFER(b);
    VAPAA_Assert(rc == MPI_SUCCESS);
}

static MPI_Datatype *types_fromint(const int types_f[], int n)
{
    if (n <= 0) {
        return NULL;
    }
    MPI_Datatype *types = malloc((size_t) n * sizeof(*types));
    VAPAA_Assert(types != NULL);
    for (int i = 0; i < n; i++) {
        types[i] = C_MPI_TYPE_FROMINT(types_f[i]);
    }
    return types;
}

static MPI_Datatype *null_types(int n)
{
    if (n <= 0) {
        return NULL;
    }
    MPI_Datatype *types = malloc((size_t) n * sizeof(*types));
    VAPAA_Assert(types != NULL);
    for (int i = 0; i < n; i++) {
        types[i] = MPI_DATATYPE_NULL;
    }
    return types;
}

static MPI_Aint *aints_from_intptr(const intptr_t aints_f[], int n)
{
    if (n <= 0) {
        return NULL;
    }
    MPI_Aint *aints = malloc((size_t) n * sizeof(*aints));
    VAPAA_Assert(aints != NULL);
    for (int i = 0; i < n; i++) {
        aints[i] = (MPI_Aint) aints_f[i];
    }
    return aints;
}

static int alltoallw_in_place(void *buffer, const int recvcounts[],
                              const int rdispls[],
                              const MPI_Datatype recvtypes[], MPI_Comm comm)
{
    MPI_Comm p2p_comm = MPI_COMM_NULL;
    int rank = 0, size = 0, rc = MPI_SUCCESS;

    rc = MPI_Comm_dup(comm, &p2p_comm);
    if (rc != MPI_SUCCESS) return rc;
    rc = MPI_Comm_rank(p2p_comm, &rank);
    if (rc == MPI_SUCCESS) rc = MPI_Comm_size(p2p_comm, &size);

    for (int peer = 0; rc == MPI_SUCCESS && peer < size; peer++) {
        if (peer == rank || recvcounts[peer] == 0) {
            continue;
        }
        char *addr = (char *) buffer + rdispls[peer];
        rc = MPI_Sendrecv_replace(addr, recvcounts[peer], recvtypes[peer],
                                  peer, 0, peer, 0, p2p_comm,
                                  MPI_STATUS_IGNORE);
    }

    int free_rc = MPI_Comm_free(&p2p_comm);
    return rc == MPI_SUCCESS ? free_rc : rc;
}

static void neighbor_degrees(MPI_Comm comm, int *indegree, int *outdegree)
{
    int topo = MPI_UNDEFINED;
    *indegree = 0;
    *outdegree = 0;
    if (MPI_Topo_test(comm, &topo) != MPI_SUCCESS) {
        return;
    }
    if (topo == MPI_DIST_GRAPH) {
        int weighted = 0;
        (void) MPI_Dist_graph_neighbors_count(comm, indegree, outdegree,
                                              &weighted);
    } else if (topo == MPI_CART) {
        int ndims = 0;
        (void) MPI_Cartdim_get(comm, &ndims);
        *indegree = 2 * ndims;
        *outdegree = 2 * ndims;
    } else if (topo == MPI_GRAPH) {
        int rank = 0, degree = 0;
        (void) MPI_Comm_rank(comm, &rank);
        (void) MPI_Graph_neighbors_count(comm, rank, &degree);
        *indegree = degree;
        *outdegree = degree;
    }
}

void vapaa_mpi_ibarrier_(int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Ibarrier(comm, &request);
    finish_request(request, request_f, ierror);
}

void vapaa_mpi_barrier_init_(int *comm_f, int *info_f, int *request_f,
                             int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Barrier_init(comm, info, &request);
    finish_request(request, request_f, ierror);
#else
    (void) comm_f;
    (void) info_f;
    unsupported_request(comm_f, request_f, ierror);
#endif
}

void vapaa_mpi_ibcast_(void *buffer, int *count, int *datatype_f, int *root,
                       int *comm_f, int *request_f, int *ierror,
                       VAPAA_PGIF_Desc *buffer_desc)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_PGIF_Buffer b;
    int rc = VAPAA_PGIF_PREPARE_BUFFER(buffer, buffer_desc, *count, datatype,
                                       false, &b);
    VAPAA_Assert(rc == MPI_SUCCESS);
    *ierror = MPI_Ibcast(b.addr, b.count, b.datatype, C_MPI_ROOT_F2C(*root),
                         comm, &request);
    rc = VAPAA_PGIF_RELEASE_BUFFER(&b);
    VAPAA_Assert(rc == MPI_SUCCESS);
    finish_request(request, request_f, ierror);
}

void vapaa_mpi_bcast_init_(void *buffer, int *count, int *datatype_f,
                           int *root, int *comm_f, int *info_f,
                           int *request_f, int *ierror,
                           VAPAA_PGIF_Desc *buffer_desc)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    VAPAA_PGIF_Buffer b;
    int rc = VAPAA_PGIF_PREPARE_BUFFER(buffer, buffer_desc, *count, datatype,
                                       false, &b);
    VAPAA_Assert(rc == MPI_SUCCESS);
    *ierror = MPI_Bcast_init(b.addr, b.count, b.datatype,
                             C_MPI_ROOT_F2C(*root), comm, info, &request);
    rc = VAPAA_PGIF_RELEASE_BUFFER(&b);
    VAPAA_Assert(rc == MPI_SUCCESS);
    finish_request(request, request_f, ierror);
#else
    (void) buffer;
    (void) count;
    (void) datatype_f;
    (void) root;
    (void) comm_f;
    (void) info_f;
    (void) buffer_desc;
    unsupported_request(comm_f, request_f, ierror);
#endif
}

#define REDUCE_REQ(name, mpi_fn)                                                \
void name(void *sendbuf, void *recvbuf, int *count, int *datatype_f,           \
          int *op_f, int *comm_f, int *request_f, int *ierror,                 \
          VAPAA_PGIF_Desc *send_desc, VAPAA_PGIF_Desc *recv_desc)              \
{                                                                              \
    MPI_Request request = MPI_REQUEST_NULL;                                     \
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);                   \
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);                                       \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    if (pgif_reject_user_op_with_builtin_type(op, datatype)) {                 \
        *ierror = MPI_ERR_OP;                                                  \
    } else if (require_contig2(send_desc, recv_desc, comm)) {                  \
        *ierror = mpi_fn(VAPAA_PGIF_IN_ADDR(sendbuf), VAPAA_PGIF_ADDR(recvbuf),\
                         *count, datatype, op, comm, &request);                \
    }                                                                          \
    finish_request(request, request_f, ierror);                                \
}

#if MPI_VERSION >= 4
#define REDUCE_INIT(name, mpi_fn)                                               \
void name(void *sendbuf, void *recvbuf, int *count, int *datatype_f,           \
          int *op_f, int *comm_f, int *info_f, int *request_f, int *ierror,    \
          VAPAA_PGIF_Desc *send_desc, VAPAA_PGIF_Desc *recv_desc)              \
{                                                                              \
    MPI_Request request = MPI_REQUEST_NULL;                                     \
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);                   \
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);                                       \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);                               \
    if (pgif_reject_user_op_with_builtin_type(op, datatype)) {                 \
        *ierror = MPI_ERR_OP;                                                  \
    } else if (require_contig2(send_desc, recv_desc, comm)) {                  \
        *ierror = mpi_fn(VAPAA_PGIF_IN_ADDR(sendbuf), VAPAA_PGIF_ADDR(recvbuf),\
                         *count, datatype, op, comm, info, &request);          \
    }                                                                          \
    finish_request(request, request_f, ierror);                                \
}
#else
#define REDUCE_INIT(name, mpi_fn)                                               \
void name(void *sendbuf, void *recvbuf, int *count, int *datatype_f,           \
          int *op_f, int *comm_f, int *info_f, int *request_f, int *ierror,    \
          VAPAA_PGIF_Desc *send_desc, VAPAA_PGIF_Desc *recv_desc)              \
{                                                                              \
    (void) sendbuf; (void) recvbuf; (void) count; (void) datatype_f;           \
    (void) op_f; (void) comm_f; (void) info_f; (void) send_desc;               \
    (void) recv_desc;                                                          \
    unsupported_request(comm_f, request_f, ierror);                                    \
}
#endif

REDUCE_REQ(vapaa_mpi_iallreduce_, MPI_Iallreduce)
REDUCE_REQ(vapaa_mpi_iscan_, MPI_Iscan)
REDUCE_REQ(vapaa_mpi_iexscan_, MPI_Iexscan)
REDUCE_INIT(vapaa_mpi_allreduce_init_, MPI_Allreduce_init)
REDUCE_INIT(vapaa_mpi_scan_init_, MPI_Scan_init)
REDUCE_INIT(vapaa_mpi_exscan_init_, MPI_Exscan_init)

#define GATHER_REQ_ROOT(name, mpi_fn)                                           \
void name(void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,       \
          int *recvcount, int *recvtype_f, int *root, int *comm_f,             \
          int *request_f, int *ierror, VAPAA_PGIF_Desc *send_desc,             \
          VAPAA_PGIF_Desc *recv_desc)                                          \
{                                                                              \
    MPI_Request request = MPI_REQUEST_NULL;                                     \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);                   \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);                   \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    VAPAA_PGIF_Buffer sb, rb;                                                  \
    int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,         \
                                       sendtype, true, &sb);                   \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    rc = VAPAA_PGIF_PREPARE_BUFFER(recvbuf, recv_desc, *recvcount, recvtype,   \
                                   true, &rb);                                 \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    *ierror = mpi_fn(sb.addr, sb.count, sb.datatype, rb.addr, rb.count,        \
                     rb.datatype, C_MPI_ROOT_F2C(*root), comm, &request);      \
    release2(&sb, &rb);                                                        \
    finish_request(request, request_f, ierror);                                \
}

#define GATHER_REQ(name, mpi_fn)                                                \
void name(void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,       \
          int *recvcount, int *recvtype_f, int *comm_f, int *request_f,        \
          int *ierror, VAPAA_PGIF_Desc *send_desc, VAPAA_PGIF_Desc *recv_desc) \
{                                                                              \
    MPI_Request request = MPI_REQUEST_NULL;                                     \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);                   \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);                   \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    VAPAA_PGIF_Buffer sb, rb;                                                  \
    int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,         \
                                       sendtype, true, &sb);                   \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    rc = VAPAA_PGIF_PREPARE_BUFFER(recvbuf, recv_desc, *recvcount, recvtype,   \
                                   true, &rb);                                 \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    *ierror = mpi_fn(sb.addr, sb.count, sb.datatype, rb.addr, rb.count,        \
                     rb.datatype, comm, &request);                             \
    release2(&sb, &rb);                                                        \
    finish_request(request, request_f, ierror);                                \
}

#if MPI_VERSION >= 4
#define GATHER_INIT_ROOT(name, mpi_fn)                                          \
void name(void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,       \
          int *recvcount, int *recvtype_f, int *root, int *comm_f,             \
          int *info_f, int *request_f, int *ierror,                            \
          VAPAA_PGIF_Desc *send_desc, VAPAA_PGIF_Desc *recv_desc)              \
{                                                                              \
    MPI_Request request = MPI_REQUEST_NULL;                                     \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);                   \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);                   \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);                               \
    VAPAA_PGIF_Buffer sb, rb;                                                  \
    int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,         \
                                       sendtype, true, &sb);                   \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    rc = VAPAA_PGIF_PREPARE_BUFFER(recvbuf, recv_desc, *recvcount, recvtype,   \
                                   true, &rb);                                 \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    *ierror = mpi_fn(sb.addr, sb.count, sb.datatype, rb.addr, rb.count,        \
                     rb.datatype, C_MPI_ROOT_F2C(*root), comm, info, &request);\
    release2(&sb, &rb);                                                        \
    finish_request(request, request_f, ierror);                                \
}

#define GATHER_INIT(name, mpi_fn)                                               \
void name(void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,       \
          int *recvcount, int *recvtype_f, int *comm_f, int *info_f,           \
          int *request_f, int *ierror, VAPAA_PGIF_Desc *send_desc,             \
          VAPAA_PGIF_Desc *recv_desc)                                          \
{                                                                              \
    MPI_Request request = MPI_REQUEST_NULL;                                     \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);                   \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);                   \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);                               \
    VAPAA_PGIF_Buffer sb, rb;                                                  \
    int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,         \
                                       sendtype, true, &sb);                   \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    rc = VAPAA_PGIF_PREPARE_BUFFER(recvbuf, recv_desc, *recvcount, recvtype,   \
                                   true, &rb);                                 \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    *ierror = mpi_fn(sb.addr, sb.count, sb.datatype, rb.addr, rb.count,        \
                     rb.datatype, comm, info, &request);                       \
    release2(&sb, &rb);                                                        \
    finish_request(request, request_f, ierror);                                \
}
#else
#define GATHER_INIT_ROOT(name, mpi_fn)                                          \
void name(void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,       \
          int *recvcount, int *recvtype_f, int *root, int *comm_f,             \
          int *info_f, int *request_f, int *ierror,                            \
          VAPAA_PGIF_Desc *send_desc, VAPAA_PGIF_Desc *recv_desc)              \
{                                                                              \
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) recvbuf;       \
    (void) recvcount; (void) recvtype_f; (void) root; (void) comm_f;           \
    (void) info_f; (void) send_desc; (void) recv_desc;                         \
    unsupported_request(comm_f, request_f, ierror);                                    \
}
#define GATHER_INIT(name, mpi_fn)                                               \
void name(void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,       \
          int *recvcount, int *recvtype_f, int *comm_f, int *info_f,           \
          int *request_f, int *ierror, VAPAA_PGIF_Desc *send_desc,             \
          VAPAA_PGIF_Desc *recv_desc)                                          \
{                                                                              \
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) recvbuf;       \
    (void) recvcount; (void) recvtype_f; (void) comm_f; (void) info_f;         \
    (void) send_desc; (void) recv_desc;                                        \
    unsupported_request(comm_f, request_f, ierror);                                    \
}
#endif

GATHER_REQ_ROOT(vapaa_mpi_igather_, MPI_Igather)
GATHER_REQ_ROOT(vapaa_mpi_iscatter_, MPI_Iscatter)
GATHER_INIT_ROOT(vapaa_mpi_gather_init_, MPI_Gather_init)
GATHER_INIT_ROOT(vapaa_mpi_scatter_init_, MPI_Scatter_init)
GATHER_REQ(vapaa_mpi_iallgather_, MPI_Iallgather)
GATHER_REQ(vapaa_mpi_ialltoall_, MPI_Ialltoall)
GATHER_INIT(vapaa_mpi_allgather_init_, MPI_Allgather_init)
GATHER_INIT(vapaa_mpi_alltoall_init_, MPI_Alltoall_init)

void vapaa_mpi_ireduce_(void *sendbuf, void *recvbuf, int *count,
                        int *datatype_f, int *op_f, int *root, int *comm_f,
                        int *request_f, int *ierror,
                        VAPAA_PGIF_Desc *send_desc,
                        VAPAA_PGIF_Desc *recv_desc)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (pgif_reject_user_op_with_builtin_type(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (require_contig2(send_desc, recv_desc, comm)) {
        *ierror = MPI_Ireduce(VAPAA_PGIF_IN_ADDR(sendbuf),
                              VAPAA_PGIF_ADDR(recvbuf), *count, datatype, op,
                              C_MPI_ROOT_F2C(*root), comm, &request);
    }
    finish_request(request, request_f, ierror);
}

void vapaa_mpi_reduce_init_(void *sendbuf, void *recvbuf, int *count,
                            int *datatype_f, int *op_f, int *root,
                            int *comm_f, int *info_f, int *request_f,
                            int *ierror, VAPAA_PGIF_Desc *send_desc,
                            VAPAA_PGIF_Desc *recv_desc)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (pgif_reject_user_op_with_builtin_type(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (require_contig2(send_desc, recv_desc, comm)) {
        *ierror = MPI_Reduce_init(VAPAA_PGIF_IN_ADDR(sendbuf),
                                  VAPAA_PGIF_ADDR(recvbuf), *count, datatype,
                                  op, C_MPI_ROOT_F2C(*root), comm, info,
                                  &request);
    }
    finish_request(request, request_f, ierror);
#else
    (void) sendbuf; (void) recvbuf; (void) count; (void) datatype_f;
    (void) op_f; (void) root; (void) comm_f; (void) info_f;
    (void) send_desc; (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
#endif
}

#define V_REQ_SEND_OK_RECV_CONTIG_ROOT(name, mpi_fn)                            \
void name(void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,       \
          const int recvcounts[], const int displs[], int *recvtype_f,         \
          int *root, int *comm_f, int *request_f, int *ierror,                 \
          VAPAA_PGIF_Desc *send_desc, VAPAA_PGIF_Desc *recv_desc)              \
{                                                                              \
    MPI_Request request = MPI_REQUEST_NULL;                                     \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);                   \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);                   \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    if (require_contig1(recv_desc, comm)) {                                     \
        VAPAA_PGIF_Buffer sb;                                                  \
        int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,     \
                                           sendtype, true, &sb);               \
        VAPAA_Assert(rc == MPI_SUCCESS);                                       \
        *ierror = mpi_fn(sb.addr, sb.count, sb.datatype,                       \
                         VAPAA_PGIF_ADDR(recvbuf), recvcounts, displs,         \
                         recvtype, C_MPI_ROOT_F2C(*root), comm, &request);     \
        rc = VAPAA_PGIF_RELEASE_BUFFER(&sb);                                   \
        VAPAA_Assert(rc == MPI_SUCCESS);                                       \
    }                                                                          \
    finish_request(request, request_f, ierror);                                \
}

#define V_REQ_SEND_OK_RECV_CONTIG(name, mpi_fn)                                 \
void name(void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,       \
          const int recvcounts[], const int displs[], int *recvtype_f,         \
          int *comm_f, int *request_f, int *ierror,                            \
          VAPAA_PGIF_Desc *send_desc, VAPAA_PGIF_Desc *recv_desc)              \
{                                                                              \
    MPI_Request request = MPI_REQUEST_NULL;                                     \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);                   \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);                   \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    if (require_contig1(recv_desc, comm)) {                                     \
        VAPAA_PGIF_Buffer sb;                                                  \
        int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,     \
                                           sendtype, true, &sb);               \
        VAPAA_Assert(rc == MPI_SUCCESS);                                       \
        *ierror = mpi_fn(sb.addr, sb.count, sb.datatype,                       \
                         VAPAA_PGIF_ADDR(recvbuf), recvcounts, displs,         \
                         recvtype, comm, &request);                            \
        rc = VAPAA_PGIF_RELEASE_BUFFER(&sb);                                   \
        VAPAA_Assert(rc == MPI_SUCCESS);                                       \
    }                                                                          \
    finish_request(request, request_f, ierror);                                \
}

V_REQ_SEND_OK_RECV_CONTIG_ROOT(vapaa_mpi_igatherv_, MPI_Igatherv)
V_REQ_SEND_OK_RECV_CONTIG(vapaa_mpi_iallgatherv_, MPI_Iallgatherv)

void vapaa_mpi_iscatterv_(void *sendbuf, const int sendcounts[],
                          const int displs[], int *sendtype_f, void *recvbuf,
                          int *recvcount, int *recvtype_f, int *root,
                          int *comm_f, int *request_f, int *ierror,
                          VAPAA_PGIF_Desc *send_desc,
                          VAPAA_PGIF_Desc *recv_desc)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (require_contig1(send_desc, comm)) {
        VAPAA_PGIF_Buffer rb;
        int rc = VAPAA_PGIF_PREPARE_BUFFER(recvbuf, recv_desc, *recvcount,
                                           recvtype, true, &rb);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Iscatterv(VAPAA_PGIF_ADDR(sendbuf), sendcounts, displs,
                                sendtype, rb.addr, rb.count, rb.datatype,
                                C_MPI_ROOT_F2C(*root), comm, &request);
        rc = VAPAA_PGIF_RELEASE_BUFFER(&rb);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    finish_request(request, request_f, ierror);
}

void vapaa_mpi_ialltoallv_(void *sendbuf, const int sendcounts[],
                           const int sdispls[], int *sendtype_f,
                           void *recvbuf, const int recvcounts[],
                           const int rdispls[], int *recvtype_f, int *comm_f,
                           int *request_f, int *ierror,
                           VAPAA_PGIF_Desc *send_desc,
                           VAPAA_PGIF_Desc *recv_desc)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (require_contig2(send_desc, recv_desc, comm)) {
        *ierror = MPI_Ialltoallv(VAPAA_PGIF_IN_ADDR(sendbuf), sendcounts,
                                 sdispls, sendtype, VAPAA_PGIF_ADDR(recvbuf),
                                 recvcounts, rdispls, recvtype, comm,
                                 &request);
    }
    finish_request(request, request_f, ierror);
}

/* Persistent vector collectives use the same descriptor restrictions as their
 * nonblocking counterparts. */
#if MPI_VERSION >= 4
#define V_INIT_SEND_OK_RECV_CONTIG_ROOT(name, mpi_fn)                           \
void name(void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,       \
          const int recvcounts[], const int displs[], int *recvtype_f,         \
          int *root, int *comm_f, int *info_f, int *request_f, int *ierror,    \
          VAPAA_PGIF_Desc *send_desc, VAPAA_PGIF_Desc *recv_desc)              \
{                                                                              \
    MPI_Request request = MPI_REQUEST_NULL;                                     \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);                   \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);                   \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);                               \
    if (require_contig1(recv_desc, comm)) {                                     \
        VAPAA_PGIF_Buffer sb;                                                  \
        int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,     \
                                           sendtype, true, &sb);               \
        VAPAA_Assert(rc == MPI_SUCCESS);                                       \
        *ierror = mpi_fn(sb.addr, sb.count, sb.datatype,                       \
                         VAPAA_PGIF_ADDR(recvbuf), recvcounts, displs,         \
                         recvtype, C_MPI_ROOT_F2C(*root), comm, info,          \
                         &request);                                            \
        rc = VAPAA_PGIF_RELEASE_BUFFER(&sb);                                   \
        VAPAA_Assert(rc == MPI_SUCCESS);                                       \
    }                                                                          \
    finish_request(request, request_f, ierror);                                \
}

#define V_INIT_SEND_OK_RECV_CONTIG(name, mpi_fn)                                \
void name(void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,       \
          const int recvcounts[], const int displs[], int *recvtype_f,         \
          int *comm_f, int *info_f, int *request_f, int *ierror,               \
          VAPAA_PGIF_Desc *send_desc, VAPAA_PGIF_Desc *recv_desc)              \
{                                                                              \
    MPI_Request request = MPI_REQUEST_NULL;                                     \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);                   \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);                   \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);                               \
    if (require_contig1(recv_desc, comm)) {                                     \
        VAPAA_PGIF_Buffer sb;                                                  \
        int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,     \
                                           sendtype, true, &sb);               \
        VAPAA_Assert(rc == MPI_SUCCESS);                                       \
        *ierror = mpi_fn(sb.addr, sb.count, sb.datatype,                       \
                         VAPAA_PGIF_ADDR(recvbuf), recvcounts, displs,         \
                         recvtype, comm, info, &request);                      \
        rc = VAPAA_PGIF_RELEASE_BUFFER(&sb);                                   \
        VAPAA_Assert(rc == MPI_SUCCESS);                                       \
    }                                                                          \
    finish_request(request, request_f, ierror);                                \
}

V_INIT_SEND_OK_RECV_CONTIG_ROOT(vapaa_mpi_gatherv_init_, MPI_Gatherv_init)
V_INIT_SEND_OK_RECV_CONTIG(vapaa_mpi_allgatherv_init_, MPI_Allgatherv_init)
#else
void vapaa_mpi_gatherv_init_(void *sendbuf, int *sendcount,
                             int *sendtype_f, void *recvbuf,
                             const int recvcounts[], const int displs[],
                             int *recvtype_f, int *root, int *comm_f,
                             int *info_f, int *request_f, int *ierror,
                             VAPAA_PGIF_Desc *send_desc,
                             VAPAA_PGIF_Desc *recv_desc)
{
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) recvbuf;
    (void) recvcounts; (void) displs; (void) recvtype_f; (void) root;
    (void) comm_f; (void) info_f; (void) send_desc; (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
}

void vapaa_mpi_allgatherv_init_(void *sendbuf, int *sendcount,
                                int *sendtype_f, void *recvbuf,
                                const int recvcounts[], const int displs[],
                                int *recvtype_f, int *comm_f, int *info_f,
                                int *request_f, int *ierror,
                                VAPAA_PGIF_Desc *send_desc,
                                VAPAA_PGIF_Desc *recv_desc)
{
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) recvbuf;
    (void) recvcounts; (void) displs; (void) recvtype_f; (void) comm_f;
    (void) info_f; (void) send_desc; (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
}
#endif

void vapaa_mpi_scatterv_init_(void *sendbuf, const int sendcounts[],
                              const int displs[], int *sendtype_f,
                              void *recvbuf, int *recvcount, int *recvtype_f,
                              int *root, int *comm_f, int *info_f,
                              int *request_f, int *ierror,
                              VAPAA_PGIF_Desc *send_desc,
                              VAPAA_PGIF_Desc *recv_desc)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (require_contig1(send_desc, comm)) {
        VAPAA_PGIF_Buffer rb;
        int rc = VAPAA_PGIF_PREPARE_BUFFER(recvbuf, recv_desc, *recvcount,
                                           recvtype, true, &rb);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Scatterv_init(VAPAA_PGIF_ADDR(sendbuf), sendcounts,
                                    displs, sendtype, rb.addr, rb.count,
                                    rb.datatype, C_MPI_ROOT_F2C(*root), comm,
                                    info, &request);
        rc = VAPAA_PGIF_RELEASE_BUFFER(&rb);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    finish_request(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcounts; (void) displs; (void) sendtype_f;
    (void) recvbuf; (void) recvcount; (void) recvtype_f; (void) root;
    (void) comm_f; (void) info_f; (void) send_desc; (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
#endif
}

void vapaa_mpi_alltoallv_init_(void *sendbuf, const int sendcounts[],
                               const int sdispls[], int *sendtype_f,
                               void *recvbuf, const int recvcounts[],
                               const int rdispls[], int *recvtype_f,
                               int *comm_f, int *info_f, int *request_f,
                               int *ierror, VAPAA_PGIF_Desc *send_desc,
                               VAPAA_PGIF_Desc *recv_desc)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (require_contig2(send_desc, recv_desc, comm)) {
        *ierror = MPI_Alltoallv_init(VAPAA_PGIF_IN_ADDR(sendbuf), sendcounts,
                                     sdispls, sendtype,
                                     VAPAA_PGIF_ADDR(recvbuf), recvcounts,
                                     rdispls, recvtype, comm, info, &request);
    }
    finish_request(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcounts; (void) sdispls; (void) sendtype_f;
    (void) recvbuf; (void) recvcounts; (void) rdispls; (void) recvtype_f;
    (void) comm_f; (void) info_f; (void) send_desc; (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
#endif
}

void vapaa_mpi_ialltoallw_(void *sendbuf, const int sendcounts[],
                           const int sdispls[], const int sendtypes_f[],
                           void *recvbuf, const int recvcounts[],
                           const int rdispls[], const int recvtypes_f[],
                           int *comm_f, int *request_f, int *ierror,
                           VAPAA_PGIF_Desc *send_desc,
                           VAPAA_PGIF_Desc *recv_desc)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (require_contig2(send_desc, recv_desc, comm)) {
        int size = 0;
        (void) MPI_Comm_size(comm, &size);
        MPI_Datatype *recvtypes = types_fromint(recvtypes_f, size);
        if (VAPAA_PGIF_IN_ADDR(sendbuf) == MPI_IN_PLACE) {
            int *zero_counts = calloc((size_t) (size > 0 ? size : 1),
                                      sizeof(*zero_counts));
            int *zero_displs = calloc((size_t) (size > 0 ? size : 1),
                                      sizeof(*zero_displs));
            MPI_Datatype *sendtypes = null_types(size);
            VAPAA_Assert(zero_counts != NULL && zero_displs != NULL);
            *ierror = MPI_Ialltoallw(MPI_IN_PLACE, zero_counts, zero_displs,
                                     sendtypes, VAPAA_PGIF_ADDR(recvbuf),
                                     recvcounts, rdispls, recvtypes, comm,
                                     &request);
            free(zero_counts);
            free(zero_displs);
            free(sendtypes);
        } else {
            MPI_Datatype *sendtypes = types_fromint(sendtypes_f, size);
            *ierror = MPI_Ialltoallw(VAPAA_PGIF_ADDR(sendbuf), sendcounts,
                                     sdispls, sendtypes,
                                     VAPAA_PGIF_ADDR(recvbuf), recvcounts,
                                     rdispls, recvtypes, comm, &request);
            free(sendtypes);
        }
        free(recvtypes);
    }
    finish_request(request, request_f, ierror);
}

void vapaa_mpi_alltoallw_(void *sendbuf, const int sendcounts[],
                          const int sdispls[], const int sendtypes_f[],
                          void *recvbuf, const int recvcounts[],
                          const int rdispls[], const int recvtypes_f[],
                          int *comm_f, int *ierror,
                          VAPAA_PGIF_Desc *send_desc,
                          VAPAA_PGIF_Desc *recv_desc)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (require_contig2(send_desc, recv_desc, comm)) {
        int size = 0;
        (void) MPI_Comm_size(comm, &size);
        MPI_Datatype *recvtypes = types_fromint(recvtypes_f, size);
        if (VAPAA_PGIF_IN_ADDR(sendbuf) == MPI_IN_PLACE) {
            *ierror = alltoallw_in_place(VAPAA_PGIF_ADDR(recvbuf), recvcounts,
                                         rdispls, recvtypes, comm);
        } else {
            MPI_Datatype *sendtypes = types_fromint(sendtypes_f, size);
            *ierror = MPI_Alltoallw(VAPAA_PGIF_ADDR(sendbuf), sendcounts,
                                    sdispls, sendtypes,
                                    VAPAA_PGIF_ADDR(recvbuf), recvcounts,
                                    rdispls, recvtypes, comm);
            free(sendtypes);
        }
        free(recvtypes);
    }
    C_MPI_RC_FIX(*ierror);
}

void vapaa_mpi_alltoallw_init_(void *sendbuf, const int sendcounts[],
                               const int sdispls[], const int sendtypes_f[],
                               void *recvbuf, const int recvcounts[],
                               const int rdispls[], const int recvtypes_f[],
                               int *comm_f, int *info_f, int *request_f,
                               int *ierror, VAPAA_PGIF_Desc *send_desc,
                               VAPAA_PGIF_Desc *recv_desc)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (require_contig2(send_desc, recv_desc, comm)) {
        int size = 0;
        (void) MPI_Comm_size(comm, &size);
        MPI_Datatype *recvtypes = types_fromint(recvtypes_f, size);
        MPI_Datatype *sendtypes = NULL;
        const int *active_sendcounts = sendcounts;
        const int *active_sdispls = sdispls;
        if (VAPAA_PGIF_IN_ADDR(sendbuf) == MPI_IN_PLACE) {
            active_sendcounts = calloc((size_t) (size > 0 ? size : 1),
                                       sizeof(*active_sendcounts));
            active_sdispls = calloc((size_t) (size > 0 ? size : 1),
                                    sizeof(*active_sdispls));
            sendtypes = null_types(size);
            VAPAA_Assert(active_sendcounts != NULL && active_sdispls != NULL);
            *ierror = MPI_Alltoallw_init(MPI_IN_PLACE, active_sendcounts,
                                         active_sdispls, sendtypes,
                                         VAPAA_PGIF_ADDR(recvbuf), recvcounts,
                                         rdispls, recvtypes, comm, info,
                                         &request);
            free((void *) active_sendcounts);
            free((void *) active_sdispls);
        } else {
            sendtypes = types_fromint(sendtypes_f, size);
            *ierror = MPI_Alltoallw_init(VAPAA_PGIF_ADDR(sendbuf), sendcounts,
                                         sdispls, sendtypes,
                                         VAPAA_PGIF_ADDR(recvbuf), recvcounts,
                                         rdispls, recvtypes, comm, info,
                                         &request);
        }
        free(sendtypes);
        free(recvtypes);
    }
    finish_request(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcounts; (void) sdispls; (void) sendtypes_f;
    (void) recvbuf; (void) recvcounts; (void) rdispls; (void) recvtypes_f;
    (void) comm_f; (void) info_f; (void) send_desc; (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
#endif
}

#define REDSCAT_REQ(name, mpi_fn)                                               \
void name(void *sendbuf, void *recvbuf, const int recvcounts[], int *datatype_f,\
          int *op_f, int *comm_f, int *request_f, int *ierror,                 \
          VAPAA_PGIF_Desc *send_desc, VAPAA_PGIF_Desc *recv_desc)              \
{                                                                              \
    MPI_Request request = MPI_REQUEST_NULL;                                     \
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);                   \
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);                                       \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    if (pgif_reject_user_op_with_builtin_type(op, datatype)) {                 \
        *ierror = MPI_ERR_OP;                                                  \
    } else if (require_contig2(send_desc, recv_desc, comm)) {                  \
        *ierror = mpi_fn(VAPAA_PGIF_IN_ADDR(sendbuf), VAPAA_PGIF_ADDR(recvbuf),\
                         recvcounts, datatype, op, comm, &request);            \
    }                                                                          \
    finish_request(request, request_f, ierror);                                \
}

REDSCAT_REQ(vapaa_mpi_ireduce_scatter_, MPI_Ireduce_scatter)

void vapaa_mpi_ireduce_scatter_block_(void *sendbuf, void *recvbuf,
                                      int *recvcount, int *datatype_f,
                                      int *op_f, int *comm_f, int *request_f,
                                      int *ierror,
                                      VAPAA_PGIF_Desc *send_desc,
                                      VAPAA_PGIF_Desc *recv_desc)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (pgif_reject_user_op_with_builtin_type(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (require_contig2(send_desc, recv_desc, comm)) {
        *ierror = MPI_Ireduce_scatter_block(VAPAA_PGIF_IN_ADDR(sendbuf),
                                            VAPAA_PGIF_ADDR(recvbuf),
                                            *recvcount, datatype, op, comm,
                                            &request);
    }
    finish_request(request, request_f, ierror);
}

void vapaa_mpi_isendrecv_(void *sendbuf, int *sendcount, int *sendtype_f,
                          int *dest, int *sendtag, void *recvbuf,
                          int *recvcount, int *recvtype_f, int *source,
                          int *recvtag, int *comm_f, int *request_f,
                          int *ierror, VAPAA_PGIF_Desc *send_desc,
                          VAPAA_PGIF_Desc *recv_desc)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_PGIF_Buffer sb, rb;
    int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,
                                       sendtype, false, &sb);
    VAPAA_Assert(rc == MPI_SUCCESS);
    rc = VAPAA_PGIF_PREPARE_BUFFER(recvbuf, recv_desc, *recvcount, recvtype,
                                   false, &rb);
    VAPAA_Assert(rc == MPI_SUCCESS);
    *ierror = MPI_Isendrecv(sb.addr, sb.count, sb.datatype,
                            C_MPI_DEST_F2C(*dest), C_MPI_TAG_F2C(*sendtag),
                            rb.addr, rb.count, rb.datatype,
                            C_MPI_SOURCE_F2C(*source),
                            C_MPI_TAG_F2C(*recvtag), comm, &request);
    release2(&sb, &rb);
    finish_request(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) dest;
    (void) sendtag; (void) recvbuf; (void) recvcount; (void) recvtype_f;
    (void) source; (void) recvtag; (void) comm_f; (void) send_desc;
    (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
#endif
}

void vapaa_mpi_isendrecv_replace_(void *buf, int *count, int *datatype_f,
                                  int *dest, int *sendtag, int *source,
                                  int *recvtag, int *comm_f, int *request_f,
                                  int *ierror, VAPAA_PGIF_Desc *buf_desc)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_PGIF_Buffer b;
    int rc = VAPAA_PGIF_PREPARE_BUFFER(buf, buf_desc, *count, datatype, false,
                                       &b);
    VAPAA_Assert(rc == MPI_SUCCESS);
    *ierror = MPI_Isendrecv_replace(b.addr, b.count, b.datatype,
                                    C_MPI_DEST_F2C(*dest),
                                    C_MPI_TAG_F2C(*sendtag),
                                    C_MPI_SOURCE_F2C(*source),
                                    C_MPI_TAG_F2C(*recvtag), comm, &request);
    rc = VAPAA_PGIF_RELEASE_BUFFER(&b);
    VAPAA_Assert(rc == MPI_SUCCESS);
    finish_request(request, request_f, ierror);
#else
    (void) buf; (void) count; (void) datatype_f; (void) dest; (void) sendtag;
    (void) source; (void) recvtag; (void) comm_f; (void) buf_desc;
    unsupported_request(comm_f, request_f, ierror);
#endif
}

#define NEIGHBOR_SIMPLE(name, mpi_fn)                                           \
void name(void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,       \
          int *recvcount, int *recvtype_f, int *comm_f, int *ierror,           \
          VAPAA_PGIF_Desc *send_desc, VAPAA_PGIF_Desc *recv_desc)              \
{                                                                              \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);                   \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);                   \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    VAPAA_PGIF_Buffer sb, rb;                                                  \
    int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,         \
                                       sendtype, false, &sb);                  \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    rc = VAPAA_PGIF_PREPARE_BUFFER(recvbuf, recv_desc, *recvcount, recvtype,   \
                                   false, &rb);                                \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    *ierror = mpi_fn(sb.addr, sb.count, sb.datatype, rb.addr, rb.count,        \
                     rb.datatype, comm);                                       \
    release2(&sb, &rb);                                                        \
    C_MPI_RC_FIX(*ierror);                                                     \
}

#define NEIGHBOR_SIMPLE_REQ(name, mpi_fn)                                       \
void name(void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,       \
          int *recvcount, int *recvtype_f, int *comm_f, int *request_f,        \
          int *ierror, VAPAA_PGIF_Desc *send_desc, VAPAA_PGIF_Desc *recv_desc) \
{                                                                              \
    MPI_Request request = MPI_REQUEST_NULL;                                     \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);                   \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);                   \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    VAPAA_PGIF_Buffer sb, rb;                                                  \
    int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,         \
                                       sendtype, false, &sb);                  \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    rc = VAPAA_PGIF_PREPARE_BUFFER(recvbuf, recv_desc, *recvcount, recvtype,   \
                                   false, &rb);                                \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    *ierror = mpi_fn(sb.addr, sb.count, sb.datatype, rb.addr, rb.count,        \
                     rb.datatype, comm, &request);                             \
    release2(&sb, &rb);                                                        \
    finish_request(request, request_f, ierror);                                \
}

#if MPI_VERSION >= 4
#define NEIGHBOR_SIMPLE_INIT(name, mpi_fn)                                      \
void name(void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,       \
          int *recvcount, int *recvtype_f, int *comm_f, int *info_f,           \
          int *request_f, int *ierror, VAPAA_PGIF_Desc *send_desc,             \
          VAPAA_PGIF_Desc *recv_desc)                                          \
{                                                                              \
    MPI_Request request = MPI_REQUEST_NULL;                                     \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);                   \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);                   \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                               \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);                               \
    VAPAA_PGIF_Buffer sb, rb;                                                  \
    int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,         \
                                       sendtype, false, &sb);                  \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    rc = VAPAA_PGIF_PREPARE_BUFFER(recvbuf, recv_desc, *recvcount, recvtype,   \
                                   false, &rb);                                \
    VAPAA_Assert(rc == MPI_SUCCESS);                                           \
    *ierror = mpi_fn(sb.addr, sb.count, sb.datatype, rb.addr, rb.count,        \
                     rb.datatype, comm, info, &request);                       \
    release2(&sb, &rb);                                                        \
    finish_request(request, request_f, ierror);                                \
}
#endif

NEIGHBOR_SIMPLE(vapaa_mpi_neighbor_allgather_, MPI_Neighbor_allgather)
NEIGHBOR_SIMPLE(vapaa_mpi_neighbor_alltoall_, MPI_Neighbor_alltoall)
NEIGHBOR_SIMPLE_REQ(vapaa_mpi_ineighbor_allgather_, MPI_Ineighbor_allgather)
NEIGHBOR_SIMPLE_REQ(vapaa_mpi_ineighbor_alltoall_, MPI_Ineighbor_alltoall)

void vapaa_mpi_neighbor_allgatherv_(void *sendbuf, int *sendcount,
                                    int *sendtype_f, void *recvbuf,
                                    const int recvcounts[], const int displs[],
                                    int *recvtype_f, int *comm_f, int *ierror,
                                    VAPAA_PGIF_Desc *send_desc,
                                    VAPAA_PGIF_Desc *recv_desc)
{
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (require_contig1(recv_desc, comm)) {
        VAPAA_PGIF_Buffer sb;
        int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,
                                           sendtype, false, &sb);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Neighbor_allgatherv(sb.addr, sb.count, sb.datatype,
                                          VAPAA_PGIF_ADDR(recvbuf), recvcounts,
                                          displs, recvtype, comm);
        rc = VAPAA_PGIF_RELEASE_BUFFER(&sb);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    C_MPI_RC_FIX(*ierror);
}

void vapaa_mpi_ineighbor_allgatherv_(void *sendbuf, int *sendcount,
                                     int *sendtype_f, void *recvbuf,
                                     const int recvcounts[], const int displs[],
                                     int *recvtype_f, int *comm_f,
                                     int *request_f, int *ierror,
                                     VAPAA_PGIF_Desc *send_desc,
                                     VAPAA_PGIF_Desc *recv_desc)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (require_contig1(recv_desc, comm)) {
        VAPAA_PGIF_Buffer sb;
        int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,
                                           sendtype, false, &sb);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Ineighbor_allgatherv(sb.addr, sb.count, sb.datatype,
                                           VAPAA_PGIF_ADDR(recvbuf),
                                           recvcounts, displs, recvtype, comm,
                                           &request);
        rc = VAPAA_PGIF_RELEASE_BUFFER(&sb);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    finish_request(request, request_f, ierror);
}

void vapaa_mpi_neighbor_alltoallv_(void *sendbuf, const int sendcounts[],
                                   const int sdispls[], int *sendtype_f,
                                   void *recvbuf, const int recvcounts[],
                                   const int rdispls[], int *recvtype_f,
                                   int *comm_f, int *ierror,
                                   VAPAA_PGIF_Desc *send_desc,
                                   VAPAA_PGIF_Desc *recv_desc)
{
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (require_contig2(send_desc, recv_desc, comm)) {
        *ierror = MPI_Neighbor_alltoallv(VAPAA_PGIF_ADDR(sendbuf), sendcounts,
                                         sdispls, sendtype,
                                         VAPAA_PGIF_ADDR(recvbuf), recvcounts,
                                         rdispls, recvtype, comm);
    }
    C_MPI_RC_FIX(*ierror);
}

void vapaa_mpi_ineighbor_alltoallv_(void *sendbuf, const int sendcounts[],
                                    const int sdispls[], int *sendtype_f,
                                    void *recvbuf, const int recvcounts[],
                                    const int rdispls[], int *recvtype_f,
                                    int *comm_f, int *request_f, int *ierror,
                                    VAPAA_PGIF_Desc *send_desc,
                                    VAPAA_PGIF_Desc *recv_desc)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (require_contig2(send_desc, recv_desc, comm)) {
        *ierror = MPI_Ineighbor_alltoallv(VAPAA_PGIF_ADDR(sendbuf), sendcounts,
                                          sdispls, sendtype,
                                          VAPAA_PGIF_ADDR(recvbuf), recvcounts,
                                          rdispls, recvtype, comm, &request);
    }
    finish_request(request, request_f, ierror);
}

static void neighbor_alltoallw_types(MPI_Comm comm, const int sendtypes_f[],
                                     const int recvtypes_f[],
                                     MPI_Datatype **sendtypes,
                                     MPI_Datatype **recvtypes, int *outdegree,
                                     int *indegree)
{
    neighbor_degrees(comm, indegree, outdegree);
    *sendtypes = types_fromint(sendtypes_f, *outdegree);
    *recvtypes = types_fromint(recvtypes_f, *indegree);
}

void vapaa_mpi_neighbor_alltoallw_(void *sendbuf, const int sendcounts[],
                                   const intptr_t sdispls_f[],
                                   const int sendtypes_f[], void *recvbuf,
                                   const int recvcounts[],
                                   const intptr_t rdispls_f[],
                                   const int recvtypes_f[], int *comm_f,
                                   int *ierror, VAPAA_PGIF_Desc *send_desc,
                                   VAPAA_PGIF_Desc *recv_desc)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (require_contig2(send_desc, recv_desc, comm)) {
        int outdegree = 0, indegree = 0;
        MPI_Datatype *sendtypes = NULL, *recvtypes = NULL;
        neighbor_alltoallw_types(comm, sendtypes_f, recvtypes_f, &sendtypes,
                                 &recvtypes, &outdegree, &indegree);
        MPI_Aint *sdispls = aints_from_intptr(sdispls_f, outdegree);
        MPI_Aint *rdispls = aints_from_intptr(rdispls_f, indegree);
        *ierror = MPI_Neighbor_alltoallw(VAPAA_PGIF_ADDR(sendbuf), sendcounts,
                                         sdispls, sendtypes,
                                         VAPAA_PGIF_ADDR(recvbuf), recvcounts,
                                         rdispls, recvtypes, comm);
        free(sendtypes); free(recvtypes); free(sdispls); free(rdispls);
    }
    C_MPI_RC_FIX(*ierror);
}

void vapaa_mpi_ineighbor_alltoallw_(void *sendbuf, const int sendcounts[],
                                    const intptr_t sdispls_f[],
                                    const int sendtypes_f[], void *recvbuf,
                                    const int recvcounts[],
                                    const intptr_t rdispls_f[],
                                    const int recvtypes_f[], int *comm_f,
                                    int *request_f, int *ierror,
                                    VAPAA_PGIF_Desc *send_desc,
                                    VAPAA_PGIF_Desc *recv_desc)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (require_contig2(send_desc, recv_desc, comm)) {
        int outdegree = 0, indegree = 0;
        MPI_Datatype *sendtypes = NULL, *recvtypes = NULL;
        neighbor_alltoallw_types(comm, sendtypes_f, recvtypes_f, &sendtypes,
                                 &recvtypes, &outdegree, &indegree);
        MPI_Aint *sdispls = aints_from_intptr(sdispls_f, outdegree);
        MPI_Aint *rdispls = aints_from_intptr(rdispls_f, indegree);
        *ierror = MPI_Ineighbor_alltoallw(VAPAA_PGIF_ADDR(sendbuf), sendcounts,
                                          sdispls, sendtypes,
                                          VAPAA_PGIF_ADDR(recvbuf), recvcounts,
                                          rdispls, recvtypes, comm, &request);
        free(sendtypes); free(recvtypes); free(sdispls); free(rdispls);
    }
    finish_request(request, request_f, ierror);
}

/* Persistent reduce-scatter and neighbor initializers are contiguous-only in
 * this direct layer, matching the CFI implementation's runtime requirement. */
void vapaa_mpi_reduce_scatter_init_(void *sendbuf, void *recvbuf,
                                    const int recvcounts[], int *datatype_f,
                                    int *op_f, int *comm_f, int *info_f,
                                    int *request_f, int *ierror,
                                    VAPAA_PGIF_Desc *send_desc,
                                    VAPAA_PGIF_Desc *recv_desc)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (pgif_reject_user_op_with_builtin_type(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (require_contig2(send_desc, recv_desc, comm)) {
        *ierror = MPI_Reduce_scatter_init(VAPAA_PGIF_IN_ADDR(sendbuf),
                                          VAPAA_PGIF_ADDR(recvbuf),
                                          recvcounts, datatype, op, comm, info,
                                          &request);
    }
    finish_request(request, request_f, ierror);
#else
    (void) sendbuf; (void) recvbuf; (void) recvcounts; (void) datatype_f;
    (void) op_f; (void) comm_f; (void) info_f; (void) send_desc;
    (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
#endif
}

void vapaa_mpi_reduce_scatter_block_init_(void *sendbuf, void *recvbuf,
                                          int *recvcount, int *datatype_f,
                                          int *op_f, int *comm_f, int *info_f,
                                          int *request_f, int *ierror,
                                          VAPAA_PGIF_Desc *send_desc,
                                          VAPAA_PGIF_Desc *recv_desc)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (pgif_reject_user_op_with_builtin_type(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (require_contig2(send_desc, recv_desc, comm)) {
        *ierror = MPI_Reduce_scatter_block_init(VAPAA_PGIF_IN_ADDR(sendbuf),
                                                VAPAA_PGIF_ADDR(recvbuf),
                                                *recvcount, datatype, op, comm,
                                                info, &request);
    }
    finish_request(request, request_f, ierror);
#else
    (void) sendbuf; (void) recvbuf; (void) recvcount; (void) datatype_f;
    (void) op_f; (void) comm_f; (void) info_f; (void) send_desc;
    (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
#endif
}

/* Less commonly used persistent neighborhood/vector forms. */
#if MPI_VERSION >= 4
NEIGHBOR_SIMPLE_INIT(vapaa_mpi_neighbor_allgather_init_,
                     MPI_Neighbor_allgather_init)
NEIGHBOR_SIMPLE_INIT(vapaa_mpi_neighbor_alltoall_init_,
                     MPI_Neighbor_alltoall_init)
#else
void vapaa_mpi_neighbor_allgather_init_(void *sendbuf, int *sendcount,
                                        int *sendtype_f, void *recvbuf,
                                        int *recvcount, int *recvtype_f,
                                        int *comm_f, int *info_f,
                                        int *request_f, int *ierror,
                                        VAPAA_PGIF_Desc *send_desc,
                                        VAPAA_PGIF_Desc *recv_desc)
{
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) recvbuf;
    (void) recvcount; (void) recvtype_f; (void) comm_f; (void) info_f;
    (void) send_desc; (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
}

void vapaa_mpi_neighbor_alltoall_init_(void *sendbuf, int *sendcount,
                                       int *sendtype_f, void *recvbuf,
                                       int *recvcount, int *recvtype_f,
                                       int *comm_f, int *info_f,
                                       int *request_f, int *ierror,
                                       VAPAA_PGIF_Desc *send_desc,
                                       VAPAA_PGIF_Desc *recv_desc)
{
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) recvbuf;
    (void) recvcount; (void) recvtype_f; (void) comm_f; (void) info_f;
    (void) send_desc; (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
}
#endif

void vapaa_mpi_neighbor_allgatherv_init_(void *sendbuf, int *sendcount,
                                         int *sendtype_f, void *recvbuf,
                                         const int recvcounts[],
                                         const int displs[], int *recvtype_f,
                                         int *comm_f, int *info_f,
                                         int *request_f, int *ierror,
                                         VAPAA_PGIF_Desc *send_desc,
                                         VAPAA_PGIF_Desc *recv_desc)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (require_contig1(recv_desc, comm)) {
        VAPAA_PGIF_Buffer sb;
        int rc = VAPAA_PGIF_PREPARE_BUFFER(sendbuf, send_desc, *sendcount,
                                           sendtype, false, &sb);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Neighbor_allgatherv_init(sb.addr, sb.count, sb.datatype,
                                               VAPAA_PGIF_ADDR(recvbuf),
                                               recvcounts, displs, recvtype,
                                               comm, info, &request);
        rc = VAPAA_PGIF_RELEASE_BUFFER(&sb);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    finish_request(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcount; (void) sendtype_f; (void) recvbuf;
    (void) recvcounts; (void) displs; (void) recvtype_f; (void) comm_f;
    (void) info_f; (void) send_desc; (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
#endif
}

void vapaa_mpi_neighbor_alltoallv_init_(void *sendbuf, const int sendcounts[],
                                        const int sdispls[], int *sendtype_f,
                                        void *recvbuf, const int recvcounts[],
                                        const int rdispls[], int *recvtype_f,
                                        int *comm_f, int *info_f,
                                        int *request_f, int *ierror,
                                        VAPAA_PGIF_Desc *send_desc,
                                        VAPAA_PGIF_Desc *recv_desc)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (require_contig2(send_desc, recv_desc, comm)) {
        *ierror = MPI_Neighbor_alltoallv_init(VAPAA_PGIF_ADDR(sendbuf),
                                              sendcounts, sdispls, sendtype,
                                              VAPAA_PGIF_ADDR(recvbuf),
                                              recvcounts, rdispls, recvtype,
                                              comm, info, &request);
    }
    finish_request(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcounts; (void) sdispls; (void) sendtype_f;
    (void) recvbuf; (void) recvcounts; (void) rdispls; (void) recvtype_f;
    (void) comm_f; (void) info_f; (void) send_desc; (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
#endif
}

void vapaa_mpi_neighbor_alltoallw_init_(void *sendbuf, const int sendcounts[],
                                        const intptr_t sdispls_f[],
                                        const int sendtypes_f[], void *recvbuf,
                                        const int recvcounts[],
                                        const intptr_t rdispls_f[],
                                        const int recvtypes_f[], int *comm_f,
                                        int *info_f, int *request_f,
                                        int *ierror, VAPAA_PGIF_Desc *send_desc,
                                        VAPAA_PGIF_Desc *recv_desc)
{
#if MPI_VERSION >= 4
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (require_contig2(send_desc, recv_desc, comm)) {
        int outdegree = 0, indegree = 0;
        MPI_Datatype *sendtypes = NULL, *recvtypes = NULL;
        neighbor_alltoallw_types(comm, sendtypes_f, recvtypes_f, &sendtypes,
                                 &recvtypes, &outdegree, &indegree);
        MPI_Aint *sdispls = aints_from_intptr(sdispls_f, outdegree);
        MPI_Aint *rdispls = aints_from_intptr(rdispls_f, indegree);
        *ierror = MPI_Neighbor_alltoallw_init(VAPAA_PGIF_ADDR(sendbuf),
                                              sendcounts, sdispls, sendtypes,
                                              VAPAA_PGIF_ADDR(recvbuf),
                                              recvcounts, rdispls, recvtypes,
                                              comm, info, &request);
        free(sendtypes); free(recvtypes); free(sdispls); free(rdispls);
    }
    finish_request(request, request_f, ierror);
#else
    (void) sendbuf; (void) sendcounts; (void) sdispls_f; (void) sendtypes_f;
    (void) recvbuf; (void) recvcounts; (void) rdispls_f; (void) recvtypes_f;
    (void) comm_f; (void) info_f; (void) send_desc; (void) recv_desc;
    unsupported_request(comm_f, request_f, ierror);
#endif
}

#endif
