#include <mpi.h>

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// NOT STANDARD STUFF

void C_MPI_OP_NULL(int * op)
{
    *op = MPI_Op_c2f(MPI_OP_NULL);
}

void C_MPI_OP_BUILTINS( int * MAX, int * MIN,
                        int * SUM, int * PROD,
                        int * MAXLOC , int * MINLOC , 
                        int * BAND, int * BOR, int * BXOR, 
                        int * LAND, int * LOR, int * LXOR, 
                        int * REPLACE, int * NO_OP)
{
    *MAX     = MPI_Op_c2f(MPI_MAX);
    *MIN     = MPI_Op_c2f(MPI_MIN);
    *SUM     = MPI_Op_c2f(MPI_SUM);
    *PROD    = MPI_Op_c2f(MPI_PROD);
    *MAXLOC  = MPI_Op_c2f(MPI_MAXLOC);
    *MINLOC  = MPI_Op_c2f(MPI_MINLOC);
    *BAND    = MPI_Op_c2f(MPI_BAND);
    *BOR     = MPI_Op_c2f(MPI_BOR);
    *BXOR    = MPI_Op_c2f(MPI_BXOR);
    *LAND    = MPI_Op_c2f(MPI_LAND);
    *LOR     = MPI_Op_c2f(MPI_LOR);
    *LXOR    = MPI_Op_c2f(MPI_LXOR);
    *REPLACE = MPI_Op_c2f(MPI_REPLACE);
    *NO_OP   = MPI_Op_c2f(MPI_NO_OP);
}

// STANDARD STUFF

