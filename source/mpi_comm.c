#include <mpi.h>
#include "convert_handles.h"
#include "convert_constants.h"
#include "vapaa_constants.h"

static int C_MPI_TRANSLATE_SPLIT_TYPE(int f)
{
    if (f == VAPAA_MPI_COMM_TYPE_SHARED) {
        return MPI_COMM_TYPE_SHARED;
    } else if (f == VAPAA_MPI_COMM_TYPE_HW_UNGUIDED) {
        return MPI_COMM_TYPE_HW_UNGUIDED;
    } else if (f == VAPAA_MPI_COMM_TYPE_HW_GUIDED) {
        return MPI_COMM_TYPE_HW_GUIDED;
    } else {
        // impossible
        MPI_Abort(MPI_COMM_WORLD,f);
        return -1;
    }
}

void C_MPI_Comm_rank(int * comm_f, int * rank, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Comm_rank(comm, rank);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_size(int * comm_f, int * size, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Comm_size(comm, size);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_compare(int * comm1_f, int * comm2_f, int * result_f, int * ierror)
{
    MPI_Comm comm1 = C_MPI_COMM_F2C(*comm1_f);
    MPI_Comm comm2 = C_MPI_COMM_F2C(*comm2_f);
    int result;
    *ierror = MPI_Comm_compare(comm1, comm2, &result);
    *result_f = C_MPI_COMPARE_RESULT_C2F(result);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_dup(int * comm_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Comm_dup(comm, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_dup_with_info(int * comm_f, int * info_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    MPI_Info info = C_MPI_INFO_F2C(*info_f);
    *ierror = MPI_Comm_dup_with_info(comm, info, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_idup(int * comm_f, int * newcomm_f, int * request_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_Comm_idup(comm, &newcomm, &request);
    *newcomm_f = MPI_Comm_c2f(newcomm);
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
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
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Comm_create(int * comm_f, int * group_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    MPI_Group group = C_MPI_GROUP_F2C(*group_f);
    *ierror = MPI_Comm_create(comm, group, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_create_group(int * comm_f, int * group_f, int * tag_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    MPI_Group group = C_MPI_GROUP_F2C(*group_f);
    *ierror = MPI_Comm_create_group(comm, group, *tag_f, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_split(int * comm_f, int * color_f, int * key_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Comm_split(comm, *color_f, *key_f, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_split_type(int * comm_f, int * type_f, int * key_f, int * info_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    MPI_Info info = C_MPI_INFO_F2C(*info_f);
    int type = C_MPI_TRANSLATE_SPLIT_TYPE(*type_f);
    *ierror = MPI_Comm_split_type(comm, type, *key_f, info, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_free(int * comm_f, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Comm_free(&comm);
    *comm_f = MPI_Comm_c2f(comm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Cart_create(int * comm_f, int * ndims, int * dims, int * periods, int * reorder, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Cart_create(comm, *ndims, dims, periods, *reorder, &newcomm);
    *newcomm_f = MPI_Comm_c2f(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Dims_create(int * nnodes, int * ndims, int * dims, int * ierror)
{
    *ierror = MPI_Dims_create(*nnodes, *ndims, dims);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Cart_coords(int * comm_f, int * rank, int * maxdims, int * coords, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Cart_coords(comm, *rank, *maxdims, coords);
    C_MPI_RC_FIX(*ierror);
}

