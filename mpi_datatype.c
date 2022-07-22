#include <mpi.h>

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// NOT STANDARD STUFF

void C_MPI_DATATYPE_NULL(int * datatype)
{
    *datatype = MPI_Type_c2f(MPI_DATATYPE_NULL);
}

void C_MPI_INTEGER(int * datatype)
{
    *datatype = MPI_Type_c2f(MPI_INTEGER);
}

void C_MPI_REAL(int * datatype)
{
    *datatype = MPI_Type_c2f(MPI_REAL);
}

void C_MPI_DOUBLE_PRECISION(int * datatype)
{
    *datatype = MPI_Type_c2f(MPI_DOUBLE_PRECISION);
}

void C_MPI_COMPLEX(int * datatype)
{
    *datatype = MPI_Type_c2f(MPI_COMPLEX);
}

void C_MPI_LOGICAL(int * datatype)
{
    *datatype = MPI_Type_c2f(MPI_LOGICAL);
}

void C_MPI_CHARACTER(int * datatype)
{
    *datatype = MPI_Type_c2f(MPI_CHARACTER);
}

void C_MPI_BYTE(int * datatype)
{
    *datatype = MPI_Type_c2f(MPI_BYTE);
}

// STANDARD STUFF

