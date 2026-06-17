// SPDX-License-Identifier: MIT

#include <mpi.h>
#include "convert_handles.h"
#include "convert_constants.h"

void C_MPI_Status_get_source(struct F_MPI_Status * status_f, int * source, int * ierror)
{
#if MPI_VERSION >= 5
    MPI_Status status;
    C_MPI_STATUS_TO_C(status_f, &status);
    *ierror = MPI_Status_get_source(&status, source);
    C_MPI_RC_FIX(*ierror);
#else
    *source = status_f->MPI_SOURCE;
    *ierror = MPI_SUCCESS;
#endif
}

void C_MPI_Status_get_tag(struct F_MPI_Status * status_f, int * tag, int * ierror)
{
#if MPI_VERSION >= 5
    MPI_Status status;
    C_MPI_STATUS_TO_C(status_f, &status);
    *ierror = MPI_Status_get_tag(&status, tag);
    C_MPI_RC_FIX(*ierror);
#else
    *tag = status_f->MPI_TAG;
    *ierror = MPI_SUCCESS;
#endif
}

void C_MPI_Status_get_error(struct F_MPI_Status * status_f, int * error, int * ierror)
{
#if MPI_VERSION >= 5
    MPI_Status status;
    int error_c;
    C_MPI_STATUS_TO_C(status_f, &status);
    *ierror = MPI_Status_get_error(&status, &error_c);
    *error = C_MPI_ERROR_CODE_C2F(error_c);
    C_MPI_RC_FIX(*ierror);
#else
    *error = status_f->MPI_ERROR;
    *ierror = MPI_SUCCESS;
#endif
}

void C_MPI_Status_set_source(struct F_MPI_Status * status_f, int * source, int * ierror)
{
#if MPI_VERSION >= 5
    MPI_Status status;
    C_MPI_STATUS_TO_C(status_f, &status);
    *ierror = MPI_Status_set_source(&status, *source);
    C_MPI_STATUS_FROM_C(&status, status_f);
    C_MPI_RC_FIX(*ierror);
#else
    status_f->MPI_SOURCE = *source;
    *ierror = MPI_SUCCESS;
#endif
}

void C_MPI_Status_set_tag(struct F_MPI_Status * status_f, int * tag, int * ierror)
{
#if MPI_VERSION >= 5
    MPI_Status status;
    C_MPI_STATUS_TO_C(status_f, &status);
    *ierror = MPI_Status_set_tag(&status, *tag);
    C_MPI_STATUS_FROM_C(&status, status_f);
    C_MPI_RC_FIX(*ierror);
#else
    status_f->MPI_TAG = *tag;
    *ierror = MPI_SUCCESS;
#endif
}

void C_MPI_Status_set_error(struct F_MPI_Status * status_f, int * error, int * ierror)
{
#if MPI_VERSION >= 5
    MPI_Status status;
    int error_c = C_MPI_ERROR_CODE_F2C(*error);
    C_MPI_STATUS_TO_C(status_f, &status);
    *ierror = MPI_Status_set_error(&status, error_c);
    C_MPI_STATUS_FROM_C(&status, status_f);
    C_MPI_RC_FIX(*ierror);
#else
    status_f->MPI_ERROR = *error;
    *ierror = MPI_SUCCESS;
#endif
}

void C_MPI_Status_set_cancelled(struct F_MPI_Status * status_f, int * flag, int * ierror)
{
    MPI_Status status;
    C_MPI_STATUS_TO_C(status_f, &status);
    *ierror = MPI_Status_set_cancelled(&status, *flag);
    C_MPI_STATUS_FROM_C(&status, status_f);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Status_set_elements(struct F_MPI_Status * status_f, int datatype_f, int count, int * ierror)
{
    MPI_Status status;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(datatype_f);
    C_MPI_STATUS_TO_C(status_f, &status);
    *ierror = MPI_Status_set_elements(&status, datatype, count);
    C_MPI_STATUS_FROM_C(&status, status_f);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Status_set_elements_x(struct F_MPI_Status * status_f, int datatype_f, MPI_Count * count, int * ierror)
{
    MPI_Status status;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(datatype_f);
    C_MPI_STATUS_TO_C(status_f, &status);
    *ierror = MPI_Status_set_elements_x(&status, datatype, *count);
    C_MPI_STATUS_FROM_C(&status, status_f);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Test_cancelled(struct F_MPI_Status * status_f, int * flag, int * ierror)
{
    MPI_Status status;
    C_MPI_STATUS_TO_C(status_f, &status);
    *ierror = MPI_Test_cancelled(&status, flag);
    C_MPI_RC_FIX(*ierror);
}
