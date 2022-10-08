#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// STANDARD STUFF

void C_MPI_Send(void * buffer, int * count, int * datatype_f, int * dest, int *tag, int * comm_f, int * ierror)
{
    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    *ierror = MPI_Send(buffer, *count, datatype, *dest, *tag, comm);
}

void CFI_MPI_Send(CFI_cdesc_t * desc, int * count, int * datatype_f, int * dest, int * tag, int * comm_f, int * ierror)
{
    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Send(desc->base_addr, *count, datatype, *dest, *tag, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
}

