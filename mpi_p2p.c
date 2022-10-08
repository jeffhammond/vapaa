#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"

// We assume MPI_Fint is C int. This assumption should be verified somehow.

// NONSTANDARD STUFF

static inline bool C_MPI_IS_IGNORE(MPI_Status * input)
{
    return ((input->MPI_SOURCE == -9119) && (input->MPI_TAG == -9119) && (input->MPI_ERROR == -9119));
}

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

/* DESIGN NOTE
 * We do not need to convert the status object because we define it
 * such that no conversion should be necessary.
 */

void C_MPI_Recv(void * buffer, int * count, int * datatype_f, int * source, int *tag, int * comm_f, MPI_Status * status_f, int * ierror)
{
    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    *ierror = MPI_Recv(buffer, *count, datatype, *source, *tag, comm,
                       C_MPI_IS_IGNORE(status_f) ? MPI_STATUS_IGNORE : status_f);
}

void CFI_MPI_Recv(CFI_cdesc_t * desc, int * count, int * datatype_f, int * source, int * tag, int * comm_f, MPI_Status * status_f, int * ierror)
{
    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Recv(desc->base_addr, *count, datatype, *source, *tag, comm,
                           C_MPI_IS_IGNORE(status_f) ? MPI_STATUS_IGNORE : status_f);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
}

