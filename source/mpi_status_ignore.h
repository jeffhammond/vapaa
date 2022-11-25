#include <stdbool.h>
#include <mpi.h>

static inline bool C_MPI_IS_IGNORE(MPI_Status * input)
{
    return ((input->MPI_SOURCE == -9119) && (input->MPI_TAG == -9119) && (input->MPI_ERROR == -9119));
}
