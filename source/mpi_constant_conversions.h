#include <mpi.h>

#define MAYBE_UNUSED __attribute__((unused))

// implemented in mpi_error.c
int C_MPI_ERROR_CODE_C2F(int error_c);

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

#define C_MPI_RC_FIX(rc) \
    do { \
        if ((rc) != MPI_SUCCESS) { (rc) = C_MPI_ERROR_CODE_C2F((rc)); } \
    } while (0) 
