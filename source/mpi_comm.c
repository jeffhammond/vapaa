#include <mpi.h>
#include "mpi_handle_conversions.h"

void C_MPI_Comm_rank(int * comm_f, int * rank, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Comm_rank(comm, rank);
}

void C_MPI_Comm_size(int * comm_f, int * size, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Comm_size(comm, size);
}

void C_MPI_Comm_compare(int * comm1_f, int * comm2_f, int * result_f, int * ierror)
{
    MPI_Comm comm1 = C_MPI_COMM_F2C(*comm1_f);
    MPI_Comm comm2 = C_MPI_COMM_F2C(*comm2_f);
    int result;
    *ierror = MPI_Comm_compare(comm1, comm2, &result);
    // translate from the values in the C library
    // to the ones we use (mpi_global_constants.F90)
    if (result == MPI_IDENT) {
        *result_f = 0;
    } else
    if (result == MPI_CONGRUENT) {
        *result_f = 1;
    } else
    if (result == MPI_SIMILAR) {
        *result_f = 2;
    } else
    if (result == MPI_UNEQUAL) {
        *result_f = 3;
    }
}

void C_MPI_Comm_dup(int * comm_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Comm_dup(comm, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
}

void C_MPI_Comm_dup_with_info(int * comm_f, int * info_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    MPI_Info info = C_MPI_INFO_F2C(*info_f);
    *ierror = MPI_Comm_dup_with_info(comm, info, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
}

void C_MPI_Comm_idup(int * comm_f, int * newcomm_f, int * request_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_Comm_idup(comm, &newcomm, &request);
    *newcomm_f = MPI_Comm_c2f(newcomm);
    *request_f = MPI_Request_c2f(request);
}

#if MPI_VERSION >= 4
void C_MPI_Comm_idup_with_info(int * comm_f, int * info_f, int * newcomm_f, int * request_f, int * ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    MPI_Info info = C_MPI_INFO_F2C(*info_f);
    *ierror = MPI_Comm_idup_with_info(comm, info, &newcomm, &request);
    *newcomm_f = MPI_Comm_c2f(newcomm);
    *request_f = MPI_Request_c2f(request);
}
#endif

void C_MPI_Comm_create(int * comm_f, int * group_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    MPI_Group group = C_MPI_GROUP_F2C(*group_f);
    *ierror = MPI_Comm_create(comm, group, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
}

void C_MPI_Comm_create_group(int * comm_f, int * group_f, int * tag_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    MPI_Group group = C_MPI_GROUP_F2C(*group_f);
    *ierror = MPI_Comm_create_group(comm, group, *tag_f, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
}

void C_MPI_Comm_split(int * comm_f, int * color_f, int * key_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Comm_split(comm, *color_f, *key_f, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
}

void C_MPI_Comm_split_type(int * comm_f, int * type_f, int * key_f, int * info_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    MPI_Info info = C_MPI_INFO_F2C(*info_f);
    *ierror = MPI_Comm_split_type(comm, *type_f, *key_f, info, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
}

void C_MPI_Comm_free(int * comm_f, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Comm_free(&comm);
    *comm_f = MPI_Comm_c2f(comm);
}

void C_MPI_Cart_create(int * comm_f, int * ndims, int * dims, int * periods, int * reorder, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Cart_create(comm, *ndims, dims, periods, *reorder, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
}

void C_MPI_Dims_create(int * nnodes, int * ndims, int * dims, int * ierror)
{
    *ierror = MPI_Dims_create(*nnodes, *ndims, dims);
}

void C_MPI_Cart_coords(int * comm_f, int * rank, int * maxdims, int * coords, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Cart_coords(comm, *rank, *maxdims, coords);
}

