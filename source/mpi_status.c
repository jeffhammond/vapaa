#include <mpi.h>

// NOT STANDARD STUFF

// STANDARD STUFF

void C_MPI_Status_set_elements(MPI_Status status, const int * datatype_f, int * count, int * ierror)
{
    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    *ierror = MPI_Status_set_elements(&status, datatype, *count);
}
