// SPDX-License-Identifier: MIT

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "detect_builtins.h"
#include "detect_sentinels.h"
#include "cfi_util.h"
#include "debug.h"

static bool VAPAA_REJECT_USER_OP_WITH_BUILTIN_TYPE(MPI_Op op, MPI_Datatype datatype)
{
#if MPI_VERSION >= 5
    (void)op;
    (void)datatype;
    return false;
#else
    return !C_MPI_OP_IS_BUILTIN(op) && C_MPI_TYPE_IS_BUILTIN(datatype);
#endif
}

#ifdef HAVE_CFI
static void *VAPAA_ADDR(CFI_cdesc_t *desc)
{
    return C_IS_MPI_BOTTOM(desc->base_addr) ? MPI_BOTTOM : desc->base_addr;
}

static int VAPAA_REQUIRE_CONTIG2(CFI_cdesc_t *a, CFI_cdesc_t *b, MPI_Comm comm)
{
    if (VAPAA_CFI_is_contiguous(a) == 1 && VAPAA_CFI_is_contiguous(b) == 1) {
        return 1;
    }
    VAPAA_Warning("this MPI wrapper requires contiguous buffers.\n");
    MPI_Abort(comm, 99);
    return 0;
}

void VAPAA_MPI_Sendrecv_replace(CFI_cdesc_t *buf, int *count, int *datatype_f, int *dest, int *sendtag,
                                int *source, int *recvtag, int *comm_f, struct F_MPI_Status *status, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (VAPAA_CFI_is_contiguous(buf) == 1) {
        MPI_Status status_c;
        MPI_Status *status_arg = MPI_STATUS_IGNORE;
        if (!C_IS_MPI_STATUS_IGNORE(status)) {
            C_MPI_STATUS_TO_C(status, &status_c);
            status_arg = &status_c;
        }
        *ierror = MPI_Sendrecv_replace(VAPAA_ADDR(buf), *count, datatype, C_MPI_DEST_F2C(*dest),
                                       C_MPI_TAG_F2C(*sendtag), C_MPI_SOURCE_F2C(*source),
                                       C_MPI_TAG_F2C(*recvtag), comm, status_arg);
        if (!C_IS_MPI_STATUS_IGNORE(status)) {
            C_MPI_STATUS_FROM_C(&status_c, status);
        }
    } else {
        VAPAA_Warning("MPI_Sendrecv_replace requires a contiguous buffer.\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}

#define VAPAA_SCANLIKE_WRAPPER(name, mpi_fn) \
void name(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, int *ierror) \
{ \
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); \
    MPI_Op op = C_MPI_OP_FROMINT(*op_f); \
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f); \
    if (VAPAA_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) { \
        VAPAA_Warning("user-defined reduce op with built-in type is not supported without the MPI-5 ABI.\n"); \
        *ierror = MPI_ERR_OP; \
        C_MPI_RC_FIX(*ierror); \
        return; \
    } \
    if (VAPAA_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) { \
        void *saddr = C_IS_MPI_IN_PLACE(sendbuf->base_addr) ? MPI_IN_PLACE : VAPAA_ADDR(sendbuf); \
        *ierror = mpi_fn(saddr, VAPAA_ADDR(recvbuf), *count, datatype, op, comm); \
    } \
    C_MPI_RC_FIX(*ierror); \
}

VAPAA_SCANLIKE_WRAPPER(VAPAA_MPI_Scan, MPI_Scan)
VAPAA_SCANLIKE_WRAPPER(VAPAA_MPI_Exscan, MPI_Exscan)

void VAPAA_MPI_Reduce_scatter(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, const int recvcounts[],
                              int *datatype_f, int *op_f, int *comm_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (VAPAA_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        VAPAA_Warning("user-defined reduce op with built-in type is not supported without the MPI-5 ABI.\n");
        *ierror = MPI_ERR_OP;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    if (VAPAA_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        void *saddr = C_IS_MPI_IN_PLACE(sendbuf->base_addr) ? MPI_IN_PLACE : VAPAA_ADDR(sendbuf);
        *ierror = MPI_Reduce_scatter(saddr, VAPAA_ADDR(recvbuf), recvcounts, datatype, op, comm);
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Reduce_scatter_block(CFI_cdesc_t *sendbuf, CFI_cdesc_t *recvbuf, int *recvcount,
                                    int *datatype_f, int *op_f, int *comm_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    if (VAPAA_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        VAPAA_Warning("user-defined reduce op with built-in type is not supported without the MPI-5 ABI.\n");
        *ierror = MPI_ERR_OP;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    if (VAPAA_REQUIRE_CONTIG2(sendbuf, recvbuf, comm)) {
        void *saddr = C_IS_MPI_IN_PLACE(sendbuf->base_addr) ? MPI_IN_PLACE : VAPAA_ADDR(sendbuf);
        *ierror = MPI_Reduce_scatter_block(saddr, VAPAA_ADDR(recvbuf), *recvcount, datatype, op, comm);
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Reduce_local(CFI_cdesc_t *inbuf, CFI_cdesc_t *inoutbuf, int *count, int *datatype_f, int *op_f,
                            int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    if (VAPAA_REJECT_USER_OP_WITH_BUILTIN_TYPE(op, datatype)) {
        VAPAA_Warning("user-defined reduce op with built-in type is not supported without the MPI-5 ABI.\n");
        *ierror = MPI_ERR_OP;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    if (VAPAA_CFI_is_contiguous(inbuf) == 1 && VAPAA_CFI_is_contiguous(inoutbuf) == 1) {
        *ierror = MPI_Reduce_local(VAPAA_ADDR(inbuf), VAPAA_ADDR(inoutbuf), *count, datatype, op);
    } else {
        *ierror = MPI_ERR_ARG;
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Pack_external(const char datarep[], CFI_cdesc_t *inbuf, int *incount, int *datatype_f,
                             CFI_cdesc_t *outbuf, intptr_t *outsize, intptr_t *position, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    if (VAPAA_CFI_is_contiguous(outbuf) != 1) {
        VAPAA_Warning("MPI_Pack_external requires the output buffer be contiguous.\n");
        *ierror = MPI_ERR_BUFFER;
    } else if (VAPAA_CFI_is_contiguous(inbuf) == 1) {
        MPI_Aint pos = (MPI_Aint)*position;
        *ierror = MPI_Pack_external(datarep, VAPAA_ADDR(inbuf), *incount, datatype, VAPAA_ADDR(outbuf),
                                    (MPI_Aint)*outsize, &pos);
        *position = (intptr_t)pos;
    } else {
        *ierror = MPI_ERR_BUFFER;
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Unpack_external(const char datarep[], CFI_cdesc_t *inbuf, intptr_t *insize, intptr_t *position,
                               CFI_cdesc_t *outbuf, int *outcount, int *datatype_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    if (VAPAA_CFI_is_contiguous(inbuf) != 1) {
        VAPAA_Warning("MPI_Unpack_external requires the input buffer be contiguous.\n");
        *ierror = MPI_ERR_BUFFER;
    } else if (VAPAA_CFI_is_contiguous(outbuf) == 1) {
        MPI_Aint pos = (MPI_Aint)*position;
        *ierror = MPI_Unpack_external(datarep, VAPAA_ADDR(inbuf), (MPI_Aint)*insize, &pos,
                                      VAPAA_ADDR(outbuf), *outcount, datatype);
        *position = (intptr_t)pos;
    } else {
        *ierror = MPI_ERR_BUFFER;
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void VAPAA_MPI_Pack_size(int *incount, int *datatype_f, int *comm_f, int *size, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Pack_size(*incount, datatype, comm, size);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Pack_external_size(const char datarep[], int *incount, int *datatype_f, intptr_t *size_f, int *ierror)
{
    MPI_Aint size = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_Pack_external_size(datarep, *incount, datatype, &size);
    *size_f = (intptr_t)size;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Op_commutative(int *op_f, int *commute, int *ierror)
{
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    *ierror = MPI_Op_commutative(op, commute);
    C_MPI_RC_FIX(*ierror);
}
