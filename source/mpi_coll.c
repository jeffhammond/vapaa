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

void C_MPI_Barrier(int * comm_f, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Barrier(comm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Bcast(void * buffer, int * count, int * datatype_f, int * root, int * comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Bcast(buffer, *count, datatype, *root, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Bcast(CFI_cdesc_t * desc, int * count, int * datatype_f, int * root, int * comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);

    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Bcast(desc->base_addr, *count, datatype, *root, comm);
    } else
    {
        int rc;

        // in theory, we can replace this test with a test for any contiguous datatype...
        if ( VAPAA_MPI_DATATYPE_IS_BUILTIN(datatype) )
        {
            MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
            rc = VAPAA_CFI_CREATE_DATATYPE(desc, *count, datatype, &subarray_type);
            VAPAA_Assert(rc == MPI_SUCCESS);
            rc = PMPI_Type_commit(&subarray_type);
            VAPAA_Assert(rc == MPI_SUCCESS);
            *ierror = MPI_Bcast(desc->base_addr, 1, subarray_type, *root, comm);
            rc = PMPI_Type_free(&subarray_type);
            VAPAA_Assert(rc == MPI_SUCCESS);
        }
        // it is effectively impossible to reason about non-contig subarrays
        // and non-contig datatypes, so we create a contiguous temporary buffer
        else
        {
#if 0
            VAPAA_Warning("Non-contiguous subarrays with user-defined datatypes is not supported.\n");
            *ierror = MPI_ERR_TYPE;
            C_MPI_RC_FIX(*ierror);
            return;
#endif
            fflush(0);
            usleep(100*1000);
            const void ** before = VAPAA_CFI_CREATE_ELEMENT_ADDRESSES(desc);
            fflush(0);
            usleep(100*1000);
            MPI_Datatype elem_dt = VAPAA_CFI_TO_MPI_TYPE(desc->type);
            MPI_Datatype indexed_datatype = VAPAA_CFI_CREATE_INDEXED_FROM_CFI_AND_MPIDT(before, *count, datatype, elem_dt);
            rc = PMPI_Type_commit(&indexed_datatype);
            VAPAA_Assert(rc == MPI_SUCCESS);
            free(before);
            fflush(0);
            usleep(100*1000);

            *ierror = MPI_Bcast(desc->base_addr, 1, indexed_datatype, *root, comm);

            rc = MPI_Type_free(&indexed_datatype);
            VAPAA_Assert(rc == MPI_SUCCESS);

#if 0
            int me;
            rc = PMPI_Comm_rank(comm, &me);
            VAPAA_Assert(rc == MPI_SUCCESS);

            size_t scount   = VAPAA_CFI_GET_TOTAL_ELEMENTS(desc);
            size_t bytes    = scount * desc->elem_len;
            void * subarray = malloc(bytes);
            memset(subarray,'$',bytes);

            int pack_size, type_size;
            rc = PMPI_Pack_size(*count, datatype, comm, &pack_size);
            VAPAA_Assert(rc == MPI_SUCCESS);
            rc = PMPI_Type_size(datatype, &type_size);
            VAPAA_Assert(rc == MPI_SUCCESS);
            void * packed = malloc(pack_size);
            memset(packed,'#',pack_size);

            printf("bytes=%zu pack_size=%d type_size=%d\n", bytes, pack_size, type_size);

            if (me == *root)
            {
                rc = VAPAA_CFI_SERIALIZE_SUBARRAY(desc, subarray);
#if 1
                fflush(0);
                usleep(100*1000);
                printf("root subarray=[");
                for (size_t i=0; i<bytes; i++) {
                    printf("%c", ((char*)subarray)[i]);
                }
                printf("]\n");
                fflush(0);
                usleep(100*1000);
#endif
                int position = 0;
                rc = PMPI_Pack(subarray, *count, datatype, packed, pack_size, &position, comm);
                VAPAA_Assert(rc == MPI_SUCCESS);
#if 1
                fflush(0);
                usleep(100*1000);
                printf("root pack=[");
                for (int i=0; i<pack_size; i++) {
                    printf("%c", ((char*)packed)[i]);
                }
                printf("]\n");
                fflush(0);
                usleep(100*1000);
#endif
            }

            *ierror = MPI_Bcast(packed, pack_size, MPI_PACKED, *root, comm);

            if (me != *root)
            {
#if 1
                fflush(0);
                usleep(100*1000);
                printf("recv pack=[");
                for (int i=0; i<pack_size; i++) {
                    printf("%c", ((char*)packed)[i]);
                }
                printf("]\n");
                fflush(0);
                usleep(100*1000);
#endif
                int position = 0;
                rc = PMPI_Unpack(packed, pack_size, &position, subarray, 1, datatype, comm);
                VAPAA_Assert(rc == MPI_SUCCESS);
#if 1
                fflush(0);
                usleep(100*1000);
                printf("recv subarray=[");
                for (size_t i=0; i<bytes; i++) {
                    printf("%c", ((char*)subarray)[i]);
                }
                printf("]\n");
                fflush(0);
                usleep(100*1000);
#endif
                //rc = VAPAA_CFI_DESERIALIZE_SUBARRAY(subarray, desc);
                rc = VAPAA_CFI_DESERIALIZE_SUBARRAY_MPIDT_NONCONTIG(subarray, desc, *count, datatype);
            }

            free(packed);
            free(subarray);
#endif
        }
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Reduce(const void * input, void * output, int * count, int * datatype_f, int * op_f, int * root,  int * comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Op op = C_MPI_OP_F2C(*op_f);
    if ( ! C_MPI_OP_IS_BUILTIN(op) && C_MPI_TYPE_IS_BUILTIN(datatype) ) {
        VAPAA_Warning("user-def reduce op with built-in type is not supported. See docs.\n");
        *ierror = MPI_ERR_OP;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Reduce(input, output, *count, datatype, op, *root, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Reduce(CFI_cdesc_t * input, CFI_cdesc_t * output, int * count, int * datatype_f, int * op_f, int * root, int * comm_f, int * ierror)
{
    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr))  in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Op op = C_MPI_OP_F2C(*op_f);
    if ( ! C_MPI_OP_IS_BUILTIN(op) && C_MPI_TYPE_IS_BUILTIN(datatype) ) {
        VAPAA_Warning("user-def reduce op with built-in type is not supported. See docs.\n");
        *ierror = MPI_ERR_OP;
        C_MPI_RC_FIX(*ierror);
        return;
    }

    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(output)) ) {
        *ierror = MPI_Reduce(in_addr, out_addr, *count, datatype, op, *root, comm);
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
        *ierror = MPI_Reduce(in_addr, out_addr, 1, subarray_type, op, *root, comm);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
#endif
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Allreduce(const void * input, void * output, int * count, int * datatype_f, int * op_f, int * comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Op op = C_MPI_OP_F2C(*op_f);
    if ( ! C_MPI_OP_IS_BUILTIN(op) && C_MPI_TYPE_IS_BUILTIN(datatype) ) {
        VAPAA_Warning("user-def reduce op with built-in type is not supported. See docs.\n");
        *ierror = MPI_ERR_OP;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
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

    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Op op = C_MPI_OP_F2C(*op_f);
    if ( ! C_MPI_OP_IS_BUILTIN(op) && C_MPI_TYPE_IS_BUILTIN(datatype) ) {
        VAPAA_Warning("user-def reduce op with built-in type is not supported. See docs.\n");
        *ierror = MPI_ERR_OP;
        C_MPI_RC_FIX(*ierror);
        return;
    }

    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(output)) ) {
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
    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Gather(input, *scount, stype, output, *rcount, rtype, *root, comm);
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

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);

    bool in_contiguous  = (1 == CFI_is_contiguous(input));
    bool out_contiguous = (1 == CFI_is_contiguous(output));

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

    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Gather(in_addr, in_count, in_type, out_addr, out_count, out_type, *root, comm);
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
    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
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

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);

    bool in_contiguous  = (1 == CFI_is_contiguous(input));
    bool out_contiguous = (1 == CFI_is_contiguous(output));

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

    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
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
    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Scatter(input, *scount, stype, output, *rcount, rtype, *root, comm);
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

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);

    bool in_contiguous  = (1 == CFI_is_contiguous(input));
    bool out_contiguous = (1 == CFI_is_contiguous(output));

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

    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Scatter(in_addr, in_count, in_type, out_addr, out_count, out_type, *root, comm);
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
    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
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

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);

    bool in_contiguous  = (1 == CFI_is_contiguous(input));
    bool out_contiguous = (1 == CFI_is_contiguous(output));

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

    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
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
    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Gatherv(input, *scount, stype, output, rcounts, rdisps, rtype, *root, comm);
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

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);

    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(output)) ) {
        *ierror = MPI_Gatherv(in_addr, *scount, stype, out_addr, rcounts, rdisps, rtype, *root, comm);
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
    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
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

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);

    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(output)) ) {
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
    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Scatterv(input, scounts, sdisps, stype, output, *rcount, rtype, *root, comm);
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

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);

    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(output)) ) {
        *ierror = MPI_Scatterv(in_addr, scounts, sdisps, stype, out_addr, *rcount, rtype, *root, comm);
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
    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (C_IS_MPI_IN_PLACE(input))  input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Alltoallv(input, scounts, sdisps, stype, output, rcounts, rdisps, rtype, comm);
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

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);

    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(output)) ) {
        *ierror = MPI_Alltoallv(in_addr, scounts, sdisps, stype, out_addr, rcounts, rdisps, rtype, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif
