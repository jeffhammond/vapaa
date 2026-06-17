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
#include "debug.h"

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
    if (CFI_is_contiguous(a) == 1) {
        return 1;
    }
    VAPAA_Warning("this MPI wrapper requires contiguous buffers.\n");
    MPI_Abort(comm, 99);
    return 0;
}

static int VAPAA_COLL_REQUIRE_CONTIG2(CFI_cdesc_t *a, CFI_cdesc_t *b, MPI_Comm comm)
{
    if (CFI_is_contiguous(a) == 1 && CFI_is_contiguous(b) == 1) {
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
    MPI_Datatype *sendtypes = VAPAA_COLL_TYPES_FROMINT(sendtypes_f, size);
    MPI_Datatype *recvtypes = VAPAA_COLL_TYPES_FROMINT(recvtypes_f, size);
    *ierror = MPI_Alltoallw(VAPAA_COLL_IN_ADDR(sendbuf), sendcounts, sdispls, sendtypes,
                            VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm);
    free(sendtypes);
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
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Barrier_init(comm, info, &request);
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Ibcast(CFI_cdesc_t *buffer, int *count, int *datatype_f, int *root, int *comm_f,
                      int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (VAPAA_COLL_REQUIRE_CONTIG1(buffer, comm)) {
        *ierror = MPI_Ibcast(VAPAA_COLL_ADDR(buffer), *count, datatype, C_MPI_ROOT_F2C(*root), comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Bcast_init(CFI_cdesc_t *buffer, int *count, int *datatype_f, int *root, int *comm_f, int *info_f,
                          int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REQUIRE_CONTIG1(buffer, comm)) {
        *ierror = MPI_Bcast_init(VAPAA_COLL_ADDR(buffer), *count, datatype, C_MPI_ROOT_F2C(*root), comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

#define VAPAA_REDUCE_REQ_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, \
          int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); \
    MPI_Op op = C_MPI_OP_FROMINT(*op_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    if (VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) { \
        *ierror = MPI_ERR_OP; \
    } else if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_IN_ADDR(sendbuf), VAPAA_COLL_ADDR(recvbuf), *count, datatype, op, comm, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}

#define VAPAA_REDUCE_INIT_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, int *info_f, \
          int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); \
    MPI_Op op = C_MPI_OP_FROMINT(*op_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f); \
    if (VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) { \
        *ierror = MPI_ERR_OP; \
    } else if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_IN_ADDR(sendbuf), VAPAA_COLL_ADDR(recvbuf), *count, datatype, op, comm, info, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}

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
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Reduce_init(VAPAA_COLL_IN_ADDR(sendbuf), VAPAA_COLL_ADDR(recvbuf), *count, datatype, op,
                                  C_MPI_ROOT_F2C(*root), comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

#define VAPAA_GATHER_REQ_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *root, int *comm_f, int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f); \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype, \
                         C_MPI_ROOT_F2C(*root), comm, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}

#define VAPAA_GATHER_INIT_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *root, int *comm_f, int *info_f, int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f); \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f); \
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype, \
                         C_MPI_ROOT_F2C(*root), comm, info, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}

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
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype, \
                         comm, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}

#define VAPAA_ALLGATHER_INIT_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *comm_f, int *info_f, int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f); \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f); \
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype, \
                         comm, info, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}

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
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Gatherv_init(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                   recvcounts, displs, recvtype, C_MPI_ROOT_F2C(*root), comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Iscatterv(CFI_cdesc_t *sendbuf, const int sendcounts[], const int displs[], int *sendtype_f,
                         CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, int *root, int *comm_f,
                         int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
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
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Scatterv_init(VAPAA_COLL_IN_ADDR(sendbuf), sendcounts, displs, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                    *recvcount, recvtype, C_MPI_ROOT_F2C(*root), comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Iallgatherv(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf,
                           const int recvcounts[], const int displs[], int *recvtype_f, int *comm_f,
                           int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
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
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Allgatherv_init(VAPAA_COLL_IN_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                      recvcounts, displs, recvtype, comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Ialltoallv(CFI_cdesc_t *sendbuf, const int sendcounts[], const int sdispls[], int *sendtype_f,
                          CFI_cdesc_t *recvbuf, const int recvcounts[], const int rdispls[], int *recvtype_f,
                          int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
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
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Alltoallv_init(VAPAA_COLL_IN_ADDR(sendbuf), sendcounts, sdispls, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                     recvcounts, rdispls, recvtype, comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
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
        MPI_Datatype *sendtypes = VAPAA_COLL_TYPES_FROMINT(sendtypes_f, size);
        MPI_Datatype *recvtypes = VAPAA_COLL_TYPES_FROMINT(recvtypes_f, size);
        *ierror = MPI_Ialltoallw(VAPAA_COLL_IN_ADDR(sendbuf), sendcounts, sdispls, sendtypes,
                                 VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm, &request);
        free(sendtypes);
        free(recvtypes);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Alltoallw_init(CFI_cdesc_t *sendbuf, const int sendcounts[], const int sdispls[],
                              const int sendtypes_f[], CFI_cdesc_t *recvbuf, const int recvcounts[],
                              const int rdispls[], const int recvtypes_f[], int *comm_f, int *info_f,
                              int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        int size = 0;
        (void)MPI_Comm_size(comm, &size);
        MPI_Datatype *sendtypes = VAPAA_COLL_TYPES_FROMINT(sendtypes_f, size);
        MPI_Datatype *recvtypes = VAPAA_COLL_TYPES_FROMINT(recvtypes_f, size);
        *ierror = MPI_Alltoallw_init(VAPAA_COLL_IN_ADDR(sendbuf), sendcounts, sdispls, sendtypes,
                                     VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm, info, &request);
        free(sendtypes);
        free(recvtypes);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Ireduce_scatter(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, const int recvcounts[],
                               int *datatype_f, int *op_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
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
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Reduce_scatter_init(VAPAA_COLL_IN_ADDR(sendbuf), VAPAA_COLL_ADDR(recvbuf), recvcounts,
                                          datatype, op, comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Ireduce_scatter_block(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *recvcount,
                                     int *datatype_f, int *op_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
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
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        *ierror = MPI_ERR_OP;
    } else if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Reduce_scatter_block_init(VAPAA_COLL_IN_ADDR(sendbuf), VAPAA_COLL_ADDR(recvbuf), *recvcount,
                                                datatype, op, comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Isendrecv(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, int *dest, int *sendtag,
                         CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, int *source, int *recvtag,
                         int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Isendrecv(VAPAA_COLL_ADDR(sendbuf), *sendcount, sendtype, C_MPI_DEST_F2C(*dest),
                                C_MPI_TAG_F2C(*sendtag), VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype,
                                C_MPI_SOURCE_F2C(*source), C_MPI_TAG_F2C(*recvtag), comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Isendrecv_replace(CFI_cdesc_t *buf, int *count, int *datatype_f, int *dest, int *sendtag,
                                 int *source, int *recvtag, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (VAPAA_COLL_REQUIRE_CONTIG1(buf, comm)) {
        *ierror = MPI_Isendrecv_replace(VAPAA_COLL_ADDR(buf), *count, datatype, C_MPI_DEST_F2C(*dest),
                                        C_MPI_TAG_F2C(*sendtag), C_MPI_SOURCE_F2C(*source),
                                        C_MPI_TAG_F2C(*recvtag), comm, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

#define VAPAA_NEIGHBOR_SIMPLE(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *comm_f, int *ierror) \
{ \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f); \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
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
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype, comm, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}

#define VAPAA_NEIGHBOR_SIMPLE_INIT(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, int *sendcount, int *sendtype_f, CFI_cdesc_t *recvbuf, int *recvcount, int *recvtype_f, \
          int *comm_f, int *info_f, int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f); \
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f); \
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        *ierror = mpi_fn(VAPAA_COLL_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf), *recvcount, recvtype, comm, info, &request); \
    } \
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror); \
}

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
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Neighbor_allgatherv_init(VAPAA_COLL_ADDR(sendbuf), *sendcount, sendtype, VAPAA_COLL_ADDR(recvbuf),
                                               recvcounts, displs, recvtype, comm, info, &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Neighbor_alltoallv(CFI_cdesc_t *sendbuf, const int sendcounts[], const int sdispls[], int *sendtype_f,
                                  CFI_cdesc_t *recvbuf, const int recvcounts[], const int rdispls[], int *recvtype_f,
                                  int *comm_f, int *ierror)
{
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
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
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        *ierror = MPI_Neighbor_alltoallv_init(VAPAA_COLL_ADDR(sendbuf), sendcounts, sdispls, sendtype,
                                              VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtype, comm, info,
                                              &request);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
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
        MPI_Aint *sdispls = VAPAA_COLL_AINTS_FROM_INTPTR(sdispls_f, outdegree);
        MPI_Aint *rdispls = VAPAA_COLL_AINTS_FROM_INTPTR(rdispls_f, indegree);
        *ierror = MPI_Ineighbor_alltoallw(VAPAA_COLL_ADDR(sendbuf), sendcounts, sdispls, sendtypes,
                                          VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm, &request);
        free(sendtypes); free(recvtypes); free(sdispls); free(rdispls);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}

void VAPAA_MPI_Neighbor_alltoallw_init(CFI_cdesc_t *sendbuf, const int sendcounts[], const intptr_t sdispls_f[],
                                       const int sendtypes_f[], CFI_cdesc_t *recvbuf, const int recvcounts[],
                                       const intptr_t rdispls_f[], const int recvtypes_f[], int *comm_f, int *info_f,
                                       int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    if (VAPAA_COLL_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        int outdegree = 0, indegree = 0;
        MPI_Datatype *sendtypes = NULL, *recvtypes = NULL;
        VAPAA_COLL_NEIGHBOR_ALLTOALLW_TYPES(comm, sendtypes_f, recvtypes_f, &sendtypes, &recvtypes, &outdegree, &indegree);
        MPI_Aint *sdispls = VAPAA_COLL_AINTS_FROM_INTPTR(sdispls_f, outdegree);
        MPI_Aint *rdispls = VAPAA_COLL_AINTS_FROM_INTPTR(rdispls_f, indegree);
        *ierror = MPI_Neighbor_alltoallw_init(VAPAA_COLL_ADDR(sendbuf), sendcounts, sdispls, sendtypes,
                                              VAPAA_COLL_ADDR(recvbuf), recvcounts, rdispls, recvtypes, comm, info,
                                              &request);
        free(sendtypes); free(recvtypes); free(sdispls); free(rdispls);
    }
    VAPAA_COLL_FINISH_REQUEST(request, request_f, ierror);
}
