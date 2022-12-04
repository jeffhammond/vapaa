#include <stdio.h>
#include <mpi.h>

#define MAYBE_UNUSED __attribute__((unused))

// implemented in mpi_error.c
int C_MPI_ERROR_CODE_C2F(int error_c);

#define C_MPI_RC_FIX(rc) \
    do { \
        if ((rc) != MPI_SUCCESS) { (rc) = C_MPI_ERROR_CODE_C2F((rc)); } \
    } while (0) 

// We use the same values as MPICH but cannot be sure every MPI will,
// so we convert them here.  See mpi_global_constants.F90 for our values.

MAYBE_UNUSED
static int C_MPI_THREAD_LEVEL_F2C(int level_f)
{
    if (level_f == 3) {
       return MPI_THREAD_MULTIPLE;
    } else if (level_f == 2) {
       return MPI_THREAD_SERIALIZED; 
    } else if (level_f == 1) {
       return MPI_THREAD_FUNNELED; 
    } else { //if (level_f == 0) {
       return MPI_THREAD_SINGLE; 
    }
}

MAYBE_UNUSED
static int C_MPI_THREAD_LEVEL_C2F(int level_c)
{
    if (level_c == MPI_THREAD_MULTIPLE) {
       return 3;
    } else if (level_c == MPI_THREAD_SERIALIZED) {
       return 2; 
    } else if (level_c == MPI_THREAD_FUNNELED) {
       return 1; 
    } else { //if (level_c == MPI_THREAD_SINGLE) {
       return 0; 
    }
}

MAYBE_UNUSED
static int C_MPI_COMPARE_RESULT_F2C(int level_f)
{
    if (level_f == 3) {
       return MPI_UNEQUAL;
    } else if (level_f == 2) {
       return MPI_SIMILAR;
    } else if (level_f == 1) {
       return MPI_CONGRUENT;
    } else if (level_f == 0) {
       return MPI_IDENT; 
    } else {
        fprintf(stderr,"invalid comparison result (%d)\n", level_f);
        MPI_Abort(MPI_COMM_SELF,level_f);
        return -1;
    }
}

MAYBE_UNUSED
static int C_MPI_COMPARE_RESULT_C2F(int level_c)
{
    if (level_c == MPI_UNEQUAL) {
       return 3;
    } else if (level_c == MPI_SIMILAR) {
       return 2; 
    } else if (level_c == MPI_CONGRUENT) {
       return 1; 
    } else if (level_c == MPI_IDENT) {
       return 0; 
    } else {
        fprintf(stderr,"invalid comparison result (%d)\n", level_c);
        MPI_Abort(MPI_COMM_SELF,level_c);
        return -1;
    }
}
