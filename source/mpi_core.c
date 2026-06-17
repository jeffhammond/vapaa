// SPDX-License-Identifier: MIT

#include <stdio.h>
#include <stdlib.h> // NULL
#include <stdbool.h>
#include <string.h> // memset
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"

// STANDARD STUFF

#if MPI_VERSION >= 5
static int C_MPI_Info_set_int(MPI_Info info, const char *key, int value)
{
    char value_string[32];
    snprintf(value_string, sizeof(value_string), "%d", value);
    return MPI_Info_set(info, key, value_string);
}

static int C_MPI_Info_set_bool(MPI_Info info, const char *key, bool value)
{
    return MPI_Info_set(info, key, value ? "true" : "false");
}

static bool C_MPI_ABI_ALREADY_SET(int rc)
{
    if (rc == MPI_ERR_ABI) return true;

    int error_class = MPI_SUCCESS;
    int class_rc = MPI_Error_class(rc, &error_class);
    return class_rc == MPI_SUCCESS && error_class == MPI_ERR_ABI;
}
#endif

void C_MPI_Init(int * ierror)
{
    *ierror = MPI_Init(NULL, NULL);
#if MPI_VERSION < 5
    // it is not clear if we need this - do we rely on MPI_Fint anywhere?
    if (sizeof(MPI_Fint) != sizeof(int)) {
        fprintf(stderr, "MPI_Fint is wider than C int, which violates our design assumptions.\n");
    }
#endif
    C_MPI_RC_FIX(*ierror);

    // DEBUG
    MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN);
    MPI_Comm_set_errhandler(MPI_COMM_SELF, MPI_ERRORS_RETURN);
}

void C_MPI_Abi_init_fortran(int * logical_size, const void * logical_true, const void * logical_false,
                            int * integer_size, int * real_size, int * double_precision_size,
                            int * ierror)
{
    *ierror = MPI_SUCCESS;
#if MPI_VERSION >= 5
    MPI_Info existing_info = MPI_INFO_NULL;
    int rc = MPI_Abi_get_fortran_info(&existing_info);
    if (rc == MPI_SUCCESS && existing_info != MPI_INFO_NULL) {
        (void) MPI_Info_free(&existing_info);
        return;
    } else if (rc != MPI_SUCCESS && !C_MPI_ABI_ALREADY_SET(rc)) {
        *ierror = rc;
        return;
    }

    rc = MPI_Abi_set_fortran_booleans(*logical_size, (void *) logical_true, (void *) logical_false);
    if (rc != MPI_SUCCESS && !C_MPI_ABI_ALREADY_SET(rc)) {
        *ierror = rc;
        return;
    }

    MPI_Info info = MPI_INFO_NULL;
    rc = MPI_Info_create(&info);
    if (rc != MPI_SUCCESS) {
        *ierror = rc;
        return;
    }

    rc = C_MPI_Info_set_int(info, "mpi_logical_size", *logical_size);
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_int(info, "mpi_integer_size", *integer_size);
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_int(info, "mpi_real_size", *real_size);
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_int(info, "mpi_double_precision_size", *double_precision_size);

    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_logical1_supported", false);
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_logical2_supported", false);
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_logical4_supported", false);
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_logical8_supported", false);
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_logical16_supported", false);
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_integer1_supported", true);
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_integer2_supported", true);
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_integer4_supported", true);
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_integer8_supported", true);
#ifdef HAVE_MPI_INTEGER16
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_integer16_supported", true);
#else
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_integer16_supported", false);
#endif
#ifdef HAVE_MPI_REAL2
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_real2_supported", true);
#else
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_real2_supported", false);
#endif
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_real4_supported", true);
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_real8_supported", true);
#ifdef HAVE_MPI_REAL16
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_real16_supported", true);
#else
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_real16_supported", false);
#endif
#ifdef HAVE_MPI_COMPLEX4
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_complex4_supported", true);
#else
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_complex4_supported", false);
#endif
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_complex8_supported", true);
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_complex16_supported", true);
#ifdef HAVE_MPI_COMPLEX32
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_complex32_supported", true);
#else
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_complex32_supported", false);
#endif
    if (rc == MPI_SUCCESS) rc = C_MPI_Info_set_bool(info, "mpi_double_complex_supported", true);

    if (rc == MPI_SUCCESS) rc = MPI_Abi_set_fortran_info(info);
    (void) MPI_Info_free(&info);

    if (rc != MPI_SUCCESS && !C_MPI_ABI_ALREADY_SET(rc)) {
        *ierror = rc;
    }
#else
    (void) logical_size;
    (void) logical_true;
    (void) logical_false;
    (void) integer_size;
    (void) real_size;
    (void) double_precision_size;
#endif
}

void C_MPI_Finalize(int * ierror)
{
    *ierror = MPI_Finalize();
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Init_thread(int * required_f, int * provided_f, int * ierror)
{
    int required = -1, provided = -1;
    required = C_MPI_THREAD_LEVEL_F2C(*required_f);
    *ierror = MPI_Init_thread(NULL, NULL, required, &provided);
    *provided_f = C_MPI_THREAD_LEVEL_C2F(provided);
#if MPI_VERSION < 5
    // it is not clear if we need this - do we rely on MPI_Fint anywhere?
    if (sizeof(MPI_Fint) != sizeof(int)) {
        fprintf(stderr, "MPI_Fint is wider than C int, which violates our design assumptions.\n");
    }
#endif
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Initialized(int * flag, int * ierror)
{
    *ierror = MPI_Initialized(flag);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Finalized(int * flag, int * ierror)
{
    *ierror = MPI_Finalized(flag);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Query_thread(int * provided_f, int * ierror)
{
    int provided = -1;
    *ierror = MPI_Query_thread(&provided);
    *provided_f = C_MPI_THREAD_LEVEL_C2F(provided);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Abort(int * comm_f, int * errorcode, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Abort(comm, *errorcode);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Get_version(int * version, int * subversion, int * ierror)
{
    *ierror = MPI_Get_version(version, subversion);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Get_library_version(char * version, int * resultlen, int * ierror)
{
    // we can fix this with malloc...
    if (VAPAA_MPI_MAX_LIBRARY_VERSION_STRING < MPI_MAX_LIBRARY_VERSION_STRING) {
        fprintf(stderr,"C_MPI_Get_library_version: buffer is not large enough - "
                       "bad things are going to happen now!\n"
                       "VAPAA_MPI_MAX_LIBRARY_VERSION_STRING=%d, MPI_MAX_LIBRARY_VERSION_STRING=%d\n",
                       VAPAA_MPI_MAX_LIBRARY_VERSION_STRING, MPI_MAX_LIBRARY_VERSION_STRING);
    }
    memset(version,0,VAPAA_MPI_MAX_LIBRARY_VERSION_STRING);
    *ierror = MPI_Get_library_version(version, resultlen);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Get_library_version(CFI_cdesc_t * version_d, int * resultlen, int * ierror)
{
    // we can fix this with malloc...
    if (VAPAA_MPI_MAX_LIBRARY_VERSION_STRING < MPI_MAX_LIBRARY_VERSION_STRING) {
        fprintf(stderr,"C_MPI_Get_library_version: buffer is not large enough - "
                       "bad things are going to happen now!\n"
                       "VAPAA_MPI_MAX_LIBRARY_VERSION_STRING=%d, MPI_MAX_LIBRARY_VERSION_STRING=%d\n",
                       VAPAA_MPI_MAX_LIBRARY_VERSION_STRING, MPI_MAX_LIBRARY_VERSION_STRING);
    }
    char * version = version_d -> base_addr;
    memset(version,0,VAPAA_MPI_MAX_LIBRARY_VERSION_STRING);
    *ierror = MPI_Get_library_version(version, resultlen);
    C_MPI_RC_FIX(*ierror);
}
#endif

double C_MPI_Wtime(void)
{
    return MPI_Wtime();
}

double C_MPI_Wtick(void)
{
    return MPI_Wtick();
}
