// SPDX-License-Identifier: MIT

#include <mpi.h>
#include "convert_handles.h"
#include "convert_constants.h"
#include "vapaa_error_handling.h"

#if MPI_VERSION >= 5
void C_MPI_Abi_get_fortran_booleans(int * logical_size, void * logical_true,
                                    void * logical_false, int * is_set, int * ierror)
{
    *ierror = MPI_Abi_get_fortran_booleans(*logical_size, logical_true, logical_false, is_set);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Abi_get_fortran_info(int * info_f, int * ierror)
{
    MPI_Info info = MPI_INFO_NULL;
    *ierror = MPI_Abi_get_fortran_info(&info);
    *info_f = C_MPI_INFO_TOINT(info);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Abi_get_info(int * info_f, int * ierror)
{
    MPI_Info info = MPI_INFO_NULL;
    *ierror = MPI_Abi_get_info(&info);
    *info_f = C_MPI_INFO_TOINT(info);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Abi_get_version(int * abi_major, int * abi_minor, int * ierror)
{
    *ierror = MPI_Abi_get_version(abi_major, abi_minor);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Abi_set_fortran_booleans(int * logical_size, void * logical_true,
                                    void * logical_false, int * ierror)
{
    *ierror = MPI_Abi_set_fortran_booleans(*logical_size, logical_true, logical_false);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Abi_set_fortran_info(int * info_f, int * ierror)
{
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Abi_set_fortran_info(info);
    C_MPI_RC_FIX(*ierror);
}
#else
void C_MPI_Abi_get_fortran_booleans(int * logical_size, void * logical_true,
                                    void * logical_false, int * is_set, int * ierror)
{
    (void) logical_size;
    (void) logical_true;
    (void) logical_false;
    *is_set = 0;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    VAPAA_MPI_handle_synthetic_error_no_object(ierror);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Abi_get_fortran_info(int * info_f, int * ierror)
{
    *info_f = VAPAA_MPI_INFO_NULL;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    VAPAA_MPI_handle_synthetic_error_no_object(ierror);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Abi_get_info(int * info_f, int * ierror)
{
    *info_f = VAPAA_MPI_INFO_NULL;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    VAPAA_MPI_handle_synthetic_error_no_object(ierror);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Abi_get_version(int * abi_major, int * abi_minor, int * ierror)
{
    *abi_major = 0;
    *abi_minor = 0;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    VAPAA_MPI_handle_synthetic_error_no_object(ierror);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Abi_set_fortran_booleans(int * logical_size, void * logical_true,
                                    void * logical_false, int * ierror)
{
    (void) logical_size;
    (void) logical_true;
    (void) logical_false;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    VAPAA_MPI_handle_synthetic_error_no_object(ierror);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Abi_set_fortran_info(int * info_f, int * ierror)
{
    (void) info_f;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    VAPAA_MPI_handle_synthetic_error_no_object(ierror);
    C_MPI_RC_FIX(*ierror);
}
#endif
