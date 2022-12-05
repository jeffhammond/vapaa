#include <mpi.h>
#include "mpi_handle_conversions.h"
#include "mpi_constant_conversions.h"

/*******************************
! MPI subarray array major constants
integer, parameter :: MPI_ORDER_C       = 321
integer, parameter :: MPI_ORDER_FORTRAN = 123
*******************************/

static int C_MPI_TRANSLATE_MAJOR(int f)
{
    if (f == 321) {
        return MPI_ORDER_C;
    } else if (f == 123) {
        return MPI_ORDER_FORTRAN;
    } else {
        // impossible
        MPI_Abort(MPI_COMM_WORLD,f);
        return -1;
    }
}

// we use the F2C/C2F functions directly when arguments
// cannot be built-in datatype handles.

void C_MPI_Type_commit(int * type_f, int * ierror)
{
    MPI_Datatype type = MPI_Type_f2c(*type_f);
    *ierror = MPI_Type_commit(&type);
    *type_f = MPI_Type_c2f(type);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Type_size(int * type_f, int * size_f, int * ierror)
{
    int size = 0;
    MPI_Datatype type = MPI_Type_f2c(*type_f);
    *ierror = MPI_Type_size(type,&size);
    *size_f = size;
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Type_free(int * type_f, int * ierror)
{
    MPI_Datatype type = MPI_Type_f2c(*type_f);
    *ierror = MPI_Type_free(&type);
    *type_f = MPI_Type_c2f(type);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Type_contiguous(int * count, int * oldtype_f, int * newtype_f, int * ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_F2C(*oldtype_f);
    *ierror = MPI_Type_contiguous(*count, oldtype, &newtype);
    *newtype_f = MPI_Type_c2f(newtype);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Type_vector(int * count, int * blocklength, int * stride, int * oldtype_f, int * newtype_f, int * ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_F2C(*oldtype_f);
    *ierror = MPI_Type_vector(*count, *blocklength, *stride, oldtype, &newtype);
    *newtype_f = MPI_Type_c2f(newtype);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Type_create_subarray(int * ndims, int * array_of_sizes, int * array_of_subsizes, int * array_of_starts, int * order_f, int * oldtype_f, int * newtype_f, int * ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_F2C(*oldtype_f);
    int order = C_MPI_TRANSLATE_MAJOR(*order_f);
    *ierror = MPI_Type_create_subarray(*ndims, array_of_sizes, array_of_subsizes, array_of_starts, order, oldtype, &newtype);
    *newtype_f = MPI_Type_c2f(newtype);
    C_MPI_RC_FIX(*ierror);
}
