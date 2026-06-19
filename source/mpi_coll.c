// SPDX-License-Identifier: MIT

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "detect_builtins.h"
#include "detect_sentinels.h"
#include "cfi_util.h"
#include "debug.h"
#ifdef HAVE_PGIF
#include "pgif_util.h"
#endif

static bool C_MPI_REJECT_USER_OP_WITH_BUILTIN_TYPE(MPI_Op op, MPI_Datatype datatype)
{
#if MPI_VERSION >= 5
    (void)op;
    (void)datatype;
    return false;
#else
    return !C_MPI_OP_IS_BUILTIN(op) && C_MPI_TYPE_IS_BUILTIN(datatype);
#endif
}

static int C_MPI_Alltoallv_in_place(void *buffer, const int rcounts[],
                                    const int rdisps[], MPI_Datatype rtype,
                                    MPI_Comm comm);

#ifdef HAVE_PGIF
static int PGIF_MPI_REQUIRE_CONTIG(const VAPAA_PGIF_Desc *desc, MPI_Comm comm)
{
    if (VAPAA_PGIF_buffer_is_contiguous(desc)) {
        return 1;
    }
    VAPAA_Warning("this MPI wrapper requires contiguous buffers.\n");
    MPI_Abort(comm, 99);
    return 0;
}

static void PGIF_MPI_FINISH2(VAPAA_PGIF_Buffer *a, VAPAA_PGIF_Buffer *b)
{
    int rc = VAPAA_PGIF_RELEASE_BUFFER(a);
    VAPAA_Assert(rc == MPI_SUCCESS);
    rc = VAPAA_PGIF_RELEASE_BUFFER(b);
    VAPAA_Assert(rc == MPI_SUCCESS);
}

void pgif_mpi_bcast_(void *buffer, int *count, int *datatype_f, int *root,
                     int *comm_f, int *ierror, VAPAA_PGIF_Desc *buffer_desc)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    VAPAA_PGIF_Buffer b;
    int rc = VAPAA_PGIF_PREPARE_BUFFER(buffer, buffer_desc, *count, datatype,
                                       false, &b);
    VAPAA_Assert(rc == MPI_SUCCESS);
    *ierror = MPI_Bcast(b.addr, b.count, b.datatype, C_MPI_ROOT_F2C(*root),
                        comm);
    rc = VAPAA_PGIF_RELEASE_BUFFER(&b);
    VAPAA_Assert(rc == MPI_SUCCESS);
    C_MPI_RC_FIX(*ierror);
}

void pgif_mpi_reduce_(void *input, void *output, int *count, int *datatype_f,
                      int *op_f, int *root, int *comm_f, int *ierror,
                      VAPAA_PGIF_Desc *input_desc,
                      VAPAA_PGIF_Desc *output_desc)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    if (C_MPI_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        VAPAA_Warning("user-def reduce op with built-in type is not supported. See docs.\n");
        *ierror = MPI_ERR_OP;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (!PGIF_MPI_REQUIRE_CONTIG(input_desc, comm) ||
        !PGIF_MPI_REQUIRE_CONTIG(output_desc, comm)) {
        return;
    }
    *ierror = MPI_Reduce(VAPAA_PGIF_IN_ADDR(input), VAPAA_PGIF_IN_ADDR(output),
                         *count, datatype, op, C_MPI_ROOT_F2C(*root), comm);
    C_MPI_RC_FIX(*ierror);
}

void pgif_mpi_allreduce_(void *input, void *output, int *count,
                         int *datatype_f, int *op_f, int *comm_f,
                         int *ierror, VAPAA_PGIF_Desc *input_desc,
                         VAPAA_PGIF_Desc *output_desc)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    if (C_MPI_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        VAPAA_Warning("user-def reduce op with built-in type is not supported. See docs.\n");
        *ierror = MPI_ERR_OP;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (!PGIF_MPI_REQUIRE_CONTIG(input_desc, comm) ||
        !PGIF_MPI_REQUIRE_CONTIG(output_desc, comm)) {
        return;
    }
    *ierror = MPI_Allreduce(VAPAA_PGIF_IN_ADDR(input),
                            VAPAA_PGIF_IN_ADDR(output), *count, datatype, op,
                            comm);
    C_MPI_RC_FIX(*ierror);
}

#define PGIF_COLL_SIMPLE2_ROOT(name, mpi_fn)                                           \
void name(void *input, int *scount, int *stype_f, void *output, int *rcount,          \
          int *rtype_f, int *root, int *comm_f, int *ierror,                          \
          VAPAA_PGIF_Desc *input_desc, VAPAA_PGIF_Desc *output_desc)                  \
{                                                                                     \
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);                                \
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);                                \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                                      \
    VAPAA_PGIF_Buffer inbuf, outbuf;                                                  \
    int rc = VAPAA_PGIF_PREPARE_BUFFER(input, input_desc, *scount, stype, true,       \
                                       &inbuf);                                       \
    VAPAA_Assert(rc == MPI_SUCCESS);                                                  \
    rc = VAPAA_PGIF_PREPARE_BUFFER(output, output_desc, *rcount, rtype, true,         \
                                   &outbuf);                                          \
    VAPAA_Assert(rc == MPI_SUCCESS);                                                  \
    *ierror = mpi_fn(inbuf.addr, inbuf.count, inbuf.datatype, outbuf.addr,            \
                     outbuf.count, outbuf.datatype, C_MPI_ROOT_F2C(*root), comm);     \
    PGIF_MPI_FINISH2(&inbuf, &outbuf);                                                \
    C_MPI_RC_FIX(*ierror);                                                            \
}

#define PGIF_COLL_SIMPLE2(name, mpi_fn)                                               \
void name(void *input, int *scount, int *stype_f, void *output, int *rcount,          \
          int *rtype_f, int *comm_f, int *ierror, VAPAA_PGIF_Desc *input_desc,        \
          VAPAA_PGIF_Desc *output_desc)                                               \
{                                                                                     \
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);                                \
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);                                \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);                                      \
    VAPAA_PGIF_Buffer inbuf, outbuf;                                                  \
    int rc = VAPAA_PGIF_PREPARE_BUFFER(input, input_desc, *scount, stype, true,       \
                                       &inbuf);                                       \
    VAPAA_Assert(rc == MPI_SUCCESS);                                                  \
    rc = VAPAA_PGIF_PREPARE_BUFFER(output, output_desc, *rcount, rtype, true,         \
                                   &outbuf);                                          \
    VAPAA_Assert(rc == MPI_SUCCESS);                                                  \
    *ierror = mpi_fn(inbuf.addr, inbuf.count, inbuf.datatype, outbuf.addr,            \
                     outbuf.count, outbuf.datatype, comm);                            \
    PGIF_MPI_FINISH2(&inbuf, &outbuf);                                                \
    C_MPI_RC_FIX(*ierror);                                                            \
}

PGIF_COLL_SIMPLE2_ROOT(pgif_mpi_gather_, MPI_Gather)
PGIF_COLL_SIMPLE2(pgif_mpi_allgather_, MPI_Allgather)
PGIF_COLL_SIMPLE2_ROOT(pgif_mpi_scatter_, MPI_Scatter)
PGIF_COLL_SIMPLE2(pgif_mpi_alltoall_, MPI_Alltoall)

void pgif_mpi_gatherv_(void *input, int *scount, int *stype_f, void *output,
                       const int rcounts[], const int rdisps[], int *rtype_f,
                       int *root, int *comm_f, int *ierror,
                       VAPAA_PGIF_Desc *input_desc,
                       VAPAA_PGIF_Desc *output_desc)
{
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (!PGIF_MPI_REQUIRE_CONTIG(output_desc, comm)) {
        return;
    }
    VAPAA_PGIF_Buffer inbuf;
    int rc = VAPAA_PGIF_PREPARE_BUFFER(input, input_desc, *scount, stype, true,
                                       &inbuf);
    VAPAA_Assert(rc == MPI_SUCCESS);
    *ierror = MPI_Gatherv(inbuf.addr, inbuf.count, inbuf.datatype,
                          VAPAA_PGIF_IN_ADDR(output), rcounts, rdisps, rtype,
                          C_MPI_ROOT_F2C(*root), comm);
    rc = VAPAA_PGIF_RELEASE_BUFFER(&inbuf);
    VAPAA_Assert(rc == MPI_SUCCESS);
    C_MPI_RC_FIX(*ierror);
}

void pgif_mpi_allgatherv_(void *input, int *scount, int *stype_f,
                          void *output, const int rcounts[],
                          const int rdisps[], int *rtype_f, int *comm_f,
                          int *ierror, VAPAA_PGIF_Desc *input_desc,
                          VAPAA_PGIF_Desc *output_desc)
{
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (!PGIF_MPI_REQUIRE_CONTIG(output_desc, comm)) {
        return;
    }
    VAPAA_PGIF_Buffer inbuf;
    int rc = VAPAA_PGIF_PREPARE_BUFFER(input, input_desc, *scount, stype, true,
                                       &inbuf);
    VAPAA_Assert(rc == MPI_SUCCESS);
    *ierror = MPI_Allgatherv(inbuf.addr, inbuf.count, inbuf.datatype,
                             VAPAA_PGIF_IN_ADDR(output), rcounts, rdisps, rtype,
                             comm);
    rc = VAPAA_PGIF_RELEASE_BUFFER(&inbuf);
    VAPAA_Assert(rc == MPI_SUCCESS);
    C_MPI_RC_FIX(*ierror);
}

void pgif_mpi_scatterv_(void *input, const int scounts[], const int sdisps[],
                        int *stype_f, void *output, int *rcount, int *rtype_f,
                        int *root, int *comm_f, int *ierror,
                        VAPAA_PGIF_Desc *input_desc,
                        VAPAA_PGIF_Desc *output_desc)
{
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (!PGIF_MPI_REQUIRE_CONTIG(input_desc, comm)) {
        return;
    }
    VAPAA_PGIF_Buffer outbuf;
    int rc = VAPAA_PGIF_PREPARE_BUFFER(output, output_desc, *rcount, rtype,
                                       true, &outbuf);
    VAPAA_Assert(rc == MPI_SUCCESS);
    *ierror = MPI_Scatterv(VAPAA_PGIF_IN_ADDR(input), scounts, sdisps, stype,
                           outbuf.addr, outbuf.count, outbuf.datatype,
                           C_MPI_ROOT_F2C(*root), comm);
    rc = VAPAA_PGIF_RELEASE_BUFFER(&outbuf);
    VAPAA_Assert(rc == MPI_SUCCESS);
    C_MPI_RC_FIX(*ierror);
}

void pgif_mpi_alltoallv_(void *input, const int scounts[],
                         const int sdisps[], int *stype_f, void *output,
                         const int rcounts[], const int rdisps[],
                         int *rtype_f, int *comm_f, int *ierror,
                         VAPAA_PGIF_Desc *input_desc,
                         VAPAA_PGIF_Desc *output_desc)
{
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (!PGIF_MPI_REQUIRE_CONTIG(input_desc, comm) ||
        !PGIF_MPI_REQUIRE_CONTIG(output_desc, comm)) {
        return;
    }
    void *in_addr = VAPAA_PGIF_IN_ADDR(input);
    void *out_addr = VAPAA_PGIF_IN_ADDR(output);
    if (in_addr == MPI_IN_PLACE) {
        *ierror = C_MPI_Alltoallv_in_place(out_addr, rcounts, rdisps, rtype,
                                           comm);
    } else {
        *ierror = MPI_Alltoallv(in_addr, scounts, sdisps, stype, out_addr,
                                rcounts, rdisps, rtype, comm);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

static int C_MPI_Alltoallv_in_place(void *buffer, const int rcounts[], const int rdisps[],
                                    MPI_Datatype rtype, MPI_Comm comm)
{
    MPI_Comm p2p_comm = MPI_COMM_NULL;
    MPI_Aint lb = 0, extent = 0;
    int rank = 0, size = 0, rc = MPI_SUCCESS;

    rc = MPI_Comm_dup(comm, &p2p_comm);
    if (rc != MPI_SUCCESS) return rc;
    rc = MPI_Comm_rank(p2p_comm, &rank);
    if (rc == MPI_SUCCESS) rc = MPI_Comm_size(p2p_comm, &size);
    if (rc == MPI_SUCCESS) rc = MPI_Type_get_extent(rtype, &lb, &extent);
    (void)lb;

    for (int peer = 0; rc == MPI_SUCCESS && peer < size; ++peer) {
        if (peer == rank || rcounts[peer] == 0) {
            continue;
        }
        char *addr = (char *)buffer + (MPI_Aint)rdisps[peer] * extent;
        rc = MPI_Sendrecv_replace(addr, rcounts[peer], rtype, peer, 0, peer, 0,
                                  p2p_comm, MPI_STATUS_IGNORE);
    }

    int free_rc = MPI_Comm_free(&p2p_comm);
    return rc == MPI_SUCCESS ? free_rc : rc;
}

void C_MPI_Barrier(int * comm_f, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Barrier(comm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Bcast(void * buffer, int count, int datatype_f, int root, int comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(comm_f);
    *ierror = MPI_Bcast(buffer, count, datatype, C_MPI_ROOT_F2C(root), comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Bcast(CFI_cdesc_t * desc, int count, int datatype_f, int root, int comm_f, int * ierror)
{
    int rc;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(comm_f);

    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, datatype, "MPI_Bcast");

    if (1 == VAPAA_CFI_is_contiguous(desc)) {
        *ierror = MPI_Bcast(desc->base_addr, count, datatype, C_MPI_ROOT_F2C(root), comm);
    }
    else {
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, count, datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Bcast(desc->base_addr, 1, subarray_type, C_MPI_ROOT_F2C(root), comm);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Reduce(const void * input, void * output, int * count, int * datatype_f, int * op_f, int * root,  int * comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    if (C_MPI_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        VAPAA_Warning("user-def reduce op with built-in type is not supported. See docs.\n");
        *ierror = MPI_ERR_OP;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Reduce(input, output, *count, datatype, op, C_MPI_ROOT_F2C(*root), comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Reduce(CFI_cdesc_t * input, CFI_cdesc_t * output, int * count, int * datatype_f, int * op_f, int * root, int * comm_f, int * ierror)
{
    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr))  in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(input, datatype, "MPI_Reduce");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(output, datatype, "MPI_Reduce");
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    if (C_MPI_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        VAPAA_Warning("user-def reduce op with built-in type is not supported. See docs.\n");
        *ierror = MPI_ERR_OP;
        C_MPI_RC_FIX(*ierror);
        return;
    }

    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if ( (1 == VAPAA_CFI_is_contiguous(input)) && (1 == VAPAA_CFI_is_contiguous(output)) ) {
        *ierror = MPI_Reduce(in_addr, out_addr, *count, datatype, op, C_MPI_ROOT_F2C(*root), comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
#if 0
        // if the input and output buffers are both non-contiguous and they are not the same
        // shape, it is impossible to do this without copying one because we can only pass
        // one datatype.
        // of course, if we use user-defined datatypes, we need have user-defined reductions
        // that apply the operators for the datatypes in question.
        // see https://github.com/mpi-forum/mpi-issues/issues/663 for details.
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, *count, datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Reduce(in_addr, out_addr, 1, subarray_type, op, C_MPI_ROOT_F2C(*root), comm);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
#endif
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Allreduce(const void * input, void * output, int * count, int * datatype_f, int * op_f, int * comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    if (C_MPI_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        VAPAA_Warning("user-def reduce op with built-in type is not supported. See docs.\n");
        *ierror = MPI_ERR_OP;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Allreduce(input, output, *count, datatype, op, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Allreduce(CFI_cdesc_t * input, CFI_cdesc_t * output, int * count, int * datatype_f, int * op_f, int * comm_f, int * ierror)
{
    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr))  in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(input, datatype, "MPI_Allreduce");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(output, datatype, "MPI_Allreduce");
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    if (C_MPI_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        VAPAA_Warning("user-def reduce op with built-in type is not supported. See docs.\n");
        *ierror = MPI_ERR_OP;
        C_MPI_RC_FIX(*ierror);
        return;
    }

    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if ( (1 == VAPAA_CFI_is_contiguous(input)) && (1 == VAPAA_CFI_is_contiguous(output)) ) {
        *ierror = MPI_Allreduce(in_addr, out_addr, *count, datatype, op, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
#if 0
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, *count, datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Allreduce(in_addr, out_addr, 1, subarray_type, op, comm);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
#endif
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Gather(const void * input, int * scount, int * stype_f, void * output, int * rcount, int * rtype_f, int * root, int * comm_f, int * ierror)
{
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Gather(input, *scount, stype, output, *rcount, rtype, C_MPI_ROOT_F2C(*root), comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Gather(CFI_cdesc_t * input, int * scount, int * stype_f, CFI_cdesc_t * output, int * rcount, int * rtype_f, int * root, int * comm_f, int * ierror)
{
    int rc;

    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr))  in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(input, stype, "MPI_Gather");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(output, rtype, "MPI_Gather");

    bool in_contiguous  = (1 == VAPAA_CFI_is_contiguous(input));
    bool out_contiguous = (1 == VAPAA_CFI_is_contiguous(output));

    int in_count  = *scount;
    int out_count = *rcount;

    MPI_Datatype in_type  = stype;
    MPI_Datatype out_type = rtype;

    if (!in_contiguous) {
        in_count = 1;
        rc = VAPAA_CFI_CREATE_DATATYPE(input, *scount, stype, &in_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&in_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }

    if (!out_contiguous) {
        out_count = 1;
        rc = VAPAA_CFI_CREATE_DATATYPE(output, *rcount, rtype, &out_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&out_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }

    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Gather(in_addr, in_count, in_type, out_addr, out_count, out_type, C_MPI_ROOT_F2C(*root), comm);
    C_MPI_RC_FIX(*ierror);

    if (!in_contiguous) {
        rc = PMPI_Type_free(&in_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }

    if (!out_contiguous) {
        rc = PMPI_Type_free(&out_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
}
#endif

void C_MPI_Allgather(const void * input, int * scount, int * stype_f, void * output, int * rcount, int * rtype_f, int * comm_f, int * ierror)
{
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Allgather(input, *scount, stype, output, *rcount, rtype, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Allgather(CFI_cdesc_t * input, int * scount, int * stype_f, CFI_cdesc_t * output, int * rcount, int * rtype_f, int * comm_f, int * ierror)
{
    int rc;

    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr))  in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(input, stype, "MPI_Allgather");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(output, rtype, "MPI_Allgather");

    bool in_contiguous  = (1 == VAPAA_CFI_is_contiguous(input));
    bool out_contiguous = (1 == VAPAA_CFI_is_contiguous(output));

    int in_count  = *scount;
    int out_count = *rcount;

    MPI_Datatype in_type  = stype;
    MPI_Datatype out_type = rtype;

    if (!in_contiguous) {
        in_count = 1;
        rc = VAPAA_CFI_CREATE_DATATYPE(input, *scount, stype, &in_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&in_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }

    if (!out_contiguous) {
        out_count = 1;
        rc = VAPAA_CFI_CREATE_DATATYPE(output, *rcount, rtype, &out_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&out_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }

    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Allgather(in_addr, in_count, in_type, out_addr, out_count, out_type, comm);
    C_MPI_RC_FIX(*ierror);

    if (!in_contiguous) {
        rc = PMPI_Type_free(&in_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }

    if (!out_contiguous) {
        rc = PMPI_Type_free(&out_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
}
#endif

void C_MPI_Scatter(const void * input, int * scount, int * stype_f, void * output, int * rcount, int * rtype_f, int * root, int * comm_f, int * ierror)
{
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Scatter(input, *scount, stype, output, *rcount, rtype, C_MPI_ROOT_F2C(*root), comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Scatter(CFI_cdesc_t * input, int * scount, int * stype_f, CFI_cdesc_t * output, int * rcount, int * rtype_f, int * root, int * comm_f, int * ierror)
{
    int rc;

    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr))  in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(input, stype, "MPI_Scatter");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(output, rtype, "MPI_Scatter");

    bool in_contiguous  = (1 == VAPAA_CFI_is_contiguous(input));
    bool out_contiguous = (1 == VAPAA_CFI_is_contiguous(output));

    int in_count  = *scount;
    int out_count = *rcount;

    MPI_Datatype in_type  = stype;
    MPI_Datatype out_type = rtype;

    if (!in_contiguous) {
        in_count = 1;
        rc = VAPAA_CFI_CREATE_DATATYPE(input, *scount, stype, &in_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&in_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }

    if (!out_contiguous) {
        out_count = 1;
        rc = VAPAA_CFI_CREATE_DATATYPE(output, *rcount, rtype, &out_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&out_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }

    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Scatter(in_addr, in_count, in_type, out_addr, out_count, out_type, C_MPI_ROOT_F2C(*root), comm);
    C_MPI_RC_FIX(*ierror);

    if (!in_contiguous) {
        rc = PMPI_Type_free(&in_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }

    if (!out_contiguous) {
        rc = PMPI_Type_free(&out_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
}
#endif

void C_MPI_Alltoall(const void * input, int * scount, int * stype_f, void * output, int * rcount, int * rtype_f, int * comm_f, int * ierror)
{
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Alltoall(input, *scount, stype, output, *rcount, rtype, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Alltoall(CFI_cdesc_t * input, int * scount, int * stype_f, CFI_cdesc_t * output, int * rcount, int * rtype_f, int * comm_f, int * ierror)
{
    int rc;

    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr))  in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(input, stype, "MPI_Alltoall");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(output, rtype, "MPI_Alltoall");

    bool in_contiguous  = (1 == VAPAA_CFI_is_contiguous(input));
    bool out_contiguous = (1 == VAPAA_CFI_is_contiguous(output));

    int in_count  = *scount;
    int out_count = *rcount;

    MPI_Datatype in_type  = stype;
    MPI_Datatype out_type = rtype;

    if (!in_contiguous) {
        in_count = 1;
        rc = VAPAA_CFI_CREATE_DATATYPE(input, *scount, stype, &in_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&in_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }

    if (!out_contiguous) {
        out_count = 1;
        rc = VAPAA_CFI_CREATE_DATATYPE(output, *rcount, rtype, &out_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&out_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }

    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Alltoall(in_addr, in_count, in_type, out_addr, out_count, out_type, comm);
    C_MPI_RC_FIX(*ierror);

    if (!in_contiguous) {
        rc = PMPI_Type_free(&in_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }

    if (!out_contiguous) {
        rc = PMPI_Type_free(&out_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
}
#endif

/****************** v-collectives ******************/

void C_MPI_Gatherv(const void * input, int * scount, int * stype_f,
                         void * output, const int rcounts[], const int rdisps[], int * rtype_f,
                   int * root, int * comm_f, int * ierror)
{
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Gatherv(input, *scount, stype, output, rcounts, rdisps, rtype, C_MPI_ROOT_F2C(*root), comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Gatherv(CFI_cdesc_t * input, int * scount, int * stype_f,
                     CFI_cdesc_t * output, const int rcounts[], const int rdisps[], int * rtype_f,
                     int * root, int * comm_f, int * ierror)
{
    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr))  in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(input, stype, "MPI_Gatherv");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(output, rtype, "MPI_Gatherv");
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);

    if ( (1 == VAPAA_CFI_is_contiguous(input)) && (1 == VAPAA_CFI_is_contiguous(output)) ) {
        *ierror = MPI_Gatherv(in_addr, *scount, stype, out_addr, rcounts, rdisps, rtype, C_MPI_ROOT_F2C(*root), comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Allgatherv(const void * input, int * scount, int * stype_f,
                            void * output, const int rcounts[], const int rdisps[], int * rtype_f,
                      int * comm_f, int * ierror)
{
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Allgatherv(input, *scount, stype, output, rcounts, rdisps, rtype, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Allgatherv(CFI_cdesc_t * input, int * scount, int * stype_f,
                        CFI_cdesc_t * output, const int rcounts[], const int rdisps[], int * rtype_f,
                        int * comm_f, int * ierror)
{
    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr))  in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(input, stype, "MPI_Allgatherv");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(output, rtype, "MPI_Allgatherv");
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);

    if ( (1 == VAPAA_CFI_is_contiguous(input)) && (1 == VAPAA_CFI_is_contiguous(output)) ) {
        *ierror = MPI_Allgatherv(in_addr, *scount, stype, out_addr, rcounts, rdisps, rtype, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Scatterv(const void * input, const int scounts[], const int sdisps[], int * stype_f,
                          void * output, int * rcount, int * rtype_f,
                    int * root, int * comm_f, int * ierror)
{
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Scatterv(input, scounts, sdisps, stype, output, *rcount, rtype, C_MPI_ROOT_F2C(*root), comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Scatterv(CFI_cdesc_t * input, const int scounts[], const int sdisps[], int * stype_f,
                      CFI_cdesc_t * output, int * rcount, int * rtype_f,
                      int * root, int * comm_f, int * ierror)
{
    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr)) in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(input, stype, "MPI_Scatterv");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(output, rtype, "MPI_Scatterv");
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);

    if ( (1 == VAPAA_CFI_is_contiguous(input)) && (1 == VAPAA_CFI_is_contiguous(output)) ) {
        *ierror = MPI_Scatterv(in_addr, scounts, sdisps, stype, out_addr, *rcount, rtype, C_MPI_ROOT_F2C(*root), comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Alltoallv(const void * input, const int scounts[], const int sdisps[], int * stype_f,
                           void * output, const int rcounts[], const int rdisps[], int * rtype_f,
                     int * comm_f, int * ierror)
{
    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    if (input == MPI_IN_PLACE) {
        *ierror = C_MPI_Alltoallv_in_place(output, rcounts, rdisps, rtype, comm);
    } else {
        *ierror = MPI_Alltoallv(input, scounts, sdisps, stype, output, rcounts, rdisps, rtype, comm);
    }
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Alltoallv(CFI_cdesc_t * input, const int scounts[], const int sdisps[], int * stype_f,
                       CFI_cdesc_t * output, const int rcounts[], const int rdisps[], int * rtype_f,
                       int * comm_f, int * ierror)
{
    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr))  in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_FROMINT(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_FROMINT(*rtype_f);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(input, stype, "MPI_Alltoallv");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(output, rtype, "MPI_Alltoallv");
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);

    if ( (1 == VAPAA_CFI_is_contiguous(input)) && (1 == VAPAA_CFI_is_contiguous(output)) ) {
        if (in_addr == MPI_IN_PLACE) {
            *ierror = C_MPI_Alltoallv_in_place(out_addr, rcounts, rdisps, rtype, comm);
        } else {
            *ierror = MPI_Alltoallv(in_addr, scounts, sdisps, stype, out_addr, rcounts, rdisps, rtype, comm);
        }
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif
