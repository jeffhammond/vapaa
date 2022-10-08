#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"

void * f08_mpi_in_place_address = {0};

// STANDARD STUFF

void C_MPI_Barrier(int * comm_f, int * ierror)
{
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    *ierror = MPI_Barrier(comm);
}

void C_MPI_Bcast(void * buffer, int * count, int * datatype_f, int * root, int * comm_f, int * ierror)
{
    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    *ierror = MPI_Bcast(buffer, *count, datatype, *root, comm);
}

void CFI_MPI_Bcast(CFI_cdesc_t * desc, int * count, int * datatype_f, int * root, int * comm_f, int * ierror)
{
    //void * buffer   = desc->base_addr;
    //CFI_type_t type = desc->type;
    //CFI_rank_t rank = desc->rank;
    //CFI_dim_t  dim[CFI_MAX_RANK] = desc->dim;

    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Bcast(desc->base_addr, *count, datatype, *root, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
}

void C_MPI_Reduce(const void * input, void * output, int * count, int * datatype_f, int * op_f, int * root,  int * comm_f, int * ierror)
{
    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    MPI_Op op = MPI_Op_f2c(*op_f);
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    if (input  == f08_mpi_in_place_address) input  = MPI_IN_PLACE;
    if (output == f08_mpi_in_place_address) output = MPI_IN_PLACE;
    *ierror = MPI_Reduce(input, output, *count, datatype, op, *root, comm);
}

void CFI_MPI_Reduce(CFI_cdesc_t * input, CFI_cdesc_t * output, int * count, int * datatype_f, int * op_f, int * root, int * comm_f, int * ierror)
{
    //void * buffer   = desc->base_addr;
    //CFI_type_t type = desc->type;
    //CFI_rank_t rank = desc->rank;
    //CFI_dim_t  dim[CFI_MAX_RANK] = desc->dim;

    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (in_addr  == f08_mpi_in_place_address) in_addr  = MPI_IN_PLACE;
    if (out_addr == f08_mpi_in_place_address) out_addr = MPI_IN_PLACE;

    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    MPI_Op op = MPI_Op_f2c(*op_f);
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(input)) ) {
        *ierror = MPI_Reduce(in_addr, out_addr, *count, datatype, op, *root, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
}

void C_MPI_Allreduce(const void * input, void * output, int * count, int * datatype_f, int * op_f, int * comm_f, int * ierror)
{
    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    MPI_Op op = MPI_Op_f2c(*op_f);
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    if (input  == f08_mpi_in_place_address) input  = MPI_IN_PLACE;
    if (output == f08_mpi_in_place_address) output = MPI_IN_PLACE;
    *ierror = MPI_Allreduce(input, output, *count, datatype, op, comm);
}

void CFI_MPI_Allreduce(CFI_cdesc_t * input, CFI_cdesc_t * output, int * count, int * datatype_f, int * op_f, int * comm_f, int * ierror)
{
    //void * buffer   = desc->base_addr;
    //CFI_type_t type = desc->type;
    //CFI_rank_t rank = desc->rank;
    //CFI_dim_t  dim[CFI_MAX_RANK] = desc->dim;

    void * in_addr  = input->base_addr;
    void * out_addr = output->base_addr;
    if (in_addr  == f08_mpi_in_place_address) in_addr  = MPI_IN_PLACE;
    if (out_addr == f08_mpi_in_place_address) out_addr = MPI_IN_PLACE;

    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    MPI_Op op = MPI_Op_f2c(*op_f);
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);

    // TODO optional count and datatype checking???

    if ( (1 == CFI_is_contiguous(input)) && (1 == CFI_is_contiguous(input)) ) {
        *ierror = MPI_Allreduce(in_addr, out_addr, *count, datatype, op, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
}
