#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "mpi_handle_conversions.h"
#include "mpi_constant_conversions.h"
#include "mpi_detect_builtins.h"
#include "mpi_detect_sentinels.h"

extern void * f08_mpi_in_place_address;

// STANDARD STUFF

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
    //void * buffer   = desc->base_addr;
    //CFI_type_t type = desc->type;
    //CFI_rank_t rank = desc->rank;
    //CFI_dim_t  dim[CFI_MAX_RANK] = desc->dim;

    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Bcast(desc->base_addr, *count, datatype, *root, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Reduce(const void * input, void * output, int * count, int * datatype_f, int * op_f, int * root,  int * comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Op op = C_MPI_OP_F2C(*op_f);
    if ( ! C_MPI_OP_IS_BUILTIN(op) && C_MPI_TYPE_IS_BUILTIN(datatype) ) {
        fprintf(stderr,"MPI F08: user-def reduce op with built-in type is not supported. See docs.\n");
    }
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (C_IS_MPI_IN_PLACE(input)) input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Reduce(input, output, *count, datatype, op, *root, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Reduce(CFI_cdesc_t * input, CFI_cdesc_t * output, int * count, int * datatype_f, int * op_f, int * root, int * comm_f, int * ierror)
{
    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr)) in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Op op = C_MPI_OP_F2C(*op_f);
    if ( ! C_MPI_OP_IS_BUILTIN(op) && C_MPI_TYPE_IS_BUILTIN(datatype) ) {
        fprintf(stderr,"MPI F08: user-def reduce op with built-in type is not supported. See docs.\n");
    }
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(output)) ) {
        *ierror = MPI_Reduce(in_addr, out_addr, *count, datatype, op, *root, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Allreduce(const void * input, void * output, int * count, int * datatype_f, int * op_f, int * comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Op op = C_MPI_OP_F2C(*op_f);
    if ( ! C_MPI_OP_IS_BUILTIN(op) && C_MPI_TYPE_IS_BUILTIN(datatype) ) {
        fprintf(stderr,"MPI F08: user-def reduce op with built-in type is not supported. See docs.\n");
    }
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (C_IS_MPI_IN_PLACE(input)) input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Allreduce(input, output, *count, datatype, op, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Allreduce(CFI_cdesc_t * input, CFI_cdesc_t * output, int * count, int * datatype_f, int * op_f, int * comm_f, int * ierror)
{
    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr)) in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Op op = C_MPI_OP_F2C(*op_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);

#if 0
    // thanks to https://github.com/mpi-forum/mpi-issues/issues/654,
    // we can only a user-defined type with a user-defined reduction.
    // however, we cannot fix this by creating a user-defined type
    // on-the-fly, because then the user reduction code will not see
    // the type passed to the reduction call.

    MPI_Datatype temptype = MPI_DATATYPE_NULL;
    if ( ! C_MPI_OP_IS_BUILTIN(op) ) {
        if ( C_MPI_TYPE_IS_BUILTIN(datatype) ) {
            MPI_Type_contiguous(1, datatype, &temptype);
            MPI_Type_commit(&temptype);
        }
    }
#else
    if ( ! C_MPI_OP_IS_BUILTIN(op) && C_MPI_TYPE_IS_BUILTIN(datatype) ) {
        fprintf(stderr,"MPI F08: user-def reduce op with built-in type is not supported. See docs.\n");
    }
#endif

#ifdef JEFF_DEBUG
    printf("dt=%d (F), %d (C)\n", *datatype_f, datatype);
#endif

    // TODO optional count and datatype checking???

    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(output)) ) {
        *ierror = MPI_Allreduce(in_addr, out_addr, *count, datatype, op, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Gather(const void * input, int * scount, int * stype_f, void * output, int * rcount, int * rtype_f, int * root, int * comm_f, int * ierror)
{
    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (C_IS_MPI_IN_PLACE(input)) input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Gather(input, *scount, stype, output, *rcount, rtype, *root, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Gather(CFI_cdesc_t * input, int * scount, int * stype_f, CFI_cdesc_t * output, int * rcount, int * rtype_f, int * root, int * comm_f, int * ierror)
{
    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr)) in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);

    // TODO optional count and datatype checking???

    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(output)) ) {
        *ierror = MPI_Gather(in_addr, *scount, stype, out_addr, *rcount, rtype, *root, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Allgather(const void * input, int * scount, int * stype_f, void * output, int * rcount, int * rtype_f, int * comm_f, int * ierror)
{
    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (C_IS_MPI_IN_PLACE(input)) input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Allgather(input, *scount, stype, output, *rcount, rtype, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Allgather(CFI_cdesc_t * input, int * scount, int * stype_f, CFI_cdesc_t * output, int * rcount, int * rtype_f, int * comm_f, int * ierror)
{
    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr)) in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);

    // TODO optional count and datatype checking???

    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(output)) ) {
        *ierror = MPI_Allgather(in_addr, *scount, stype, out_addr, *rcount, rtype, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Scatter(const void * input, int * scount, int * stype_f, void * output, int * rcount, int * rtype_f, int * root, int * comm_f, int * ierror)
{
    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (C_IS_MPI_IN_PLACE(input)) input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Scatter(input, *scount, stype, output, *rcount, rtype, *root, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Scatter(CFI_cdesc_t * input, int * scount, int * stype_f, CFI_cdesc_t * output, int * rcount, int * rtype_f, int * root, int * comm_f, int * ierror)
{
    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr)) in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);

    // TODO optional count and datatype checking???

    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(output)) ) {
        *ierror = MPI_Scatter(in_addr, *scount, stype, out_addr, *rcount, rtype, *root, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Alltoall(const void * input, int * scount, int * stype_f, void * output, int * rcount, int * rtype_f, int * comm_f, int * ierror)
{
    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (C_IS_MPI_IN_PLACE(input)) input  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(output)) output = MPI_IN_PLACE;
    *ierror = MPI_Alltoall(input, *scount, stype, output, *rcount, rtype, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Alltoall(CFI_cdesc_t * input, int * scount, int * stype_f, CFI_cdesc_t * output, int * rcount, int * rtype_f, int * comm_f, int * ierror)
{
    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (C_IS_MPI_IN_PLACE(in_addr)) in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);

    // TODO optional count and datatype checking???

    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(output)) ) {
        *ierror = MPI_Alltoall(in_addr, *scount, stype, out_addr, *rcount, rtype, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
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
    if (C_IS_MPI_IN_PLACE(input)) input  = MPI_IN_PLACE;
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
    if (C_IS_MPI_IN_PLACE(in_addr)) in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);

    // TODO optional count and datatype checking???

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
    if (C_IS_MPI_IN_PLACE(input)) input  = MPI_IN_PLACE;
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
    if (C_IS_MPI_IN_PLACE(in_addr)) in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);

    // TODO optional count and datatype checking???

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
    if (C_IS_MPI_IN_PLACE(input)) input  = MPI_IN_PLACE;
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

    // TODO optional count and datatype checking???

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
    if (C_IS_MPI_IN_PLACE(input)) input  = MPI_IN_PLACE;
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
    if (C_IS_MPI_IN_PLACE(in_addr)) in_addr  = MPI_IN_PLACE;
    if (C_IS_MPI_IN_PLACE(out_addr)) out_addr = MPI_IN_PLACE;

    MPI_Datatype stype = C_MPI_TYPE_F2C(*stype_f);
    MPI_Datatype rtype = C_MPI_TYPE_F2C(*rtype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);

    // TODO optional count and datatype checking???

    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(output)) ) {
        *ierror = MPI_Alltoallv(in_addr, scounts, sdisps, stype, out_addr, rcounts, rdisps, rtype, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif
