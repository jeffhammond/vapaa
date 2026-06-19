// SPDX-License-Identifier: MIT

#include <stdio.h>
#include <stdlib.h> // NULL
#include <stdbool.h>
#include <string.h> // memset
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "cfi_util.h"

#ifndef VAPAA_GIT_HASH
#define VAPAA_GIT_HASH "unknown"
#endif

#ifndef VAPAA_GIT_DIRTY
#define VAPAA_GIT_DIRTY "unknown"
#endif

#ifndef VAPAA_MPI_VENDOR_LABEL
#define VAPAA_MPI_VENDOR_LABEL "unknown"
#endif

#ifndef __VERSION__
#define __VERSION__ "unknown"
#endif

// STANDARD STUFF

void VAPAA_MPI_F90_Datatype_finalize(void);

static bool VAPAA_VERBOSE_EMITTED = false;

static bool VAPAA_ENV_BOOL(const char *name, bool default_value)
{
    const char *value = getenv(name);
    if (value == NULL || value[0] == '\0') {
        return default_value;
    }

    if (strcmp(value, "0") == 0 ||
        strcmp(value, "false") == 0 || strcmp(value, "FALSE") == 0 ||
        strcmp(value, "no") == 0 || strcmp(value, "NO") == 0 ||
        strcmp(value, "off") == 0 || strcmp(value, "OFF") == 0) {
        return false;
    }

    if (strcmp(value, "1") == 0 ||
        strcmp(value, "true") == 0 || strcmp(value, "TRUE") == 0 ||
        strcmp(value, "yes") == 0 || strcmp(value, "YES") == 0 ||
        strcmp(value, "on") == 0 || strcmp(value, "ON") == 0) {
        return true;
    }

    return true;
}

static const char * C_MPI_RC_NAME(int rc)
{
    static char error_string[MPI_MAX_ERROR_STRING];
    int len = 0;

    if (rc == MPI_SUCCESS) return "MPI_SUCCESS";
    if (MPI_Error_string(rc, error_string, &len) == MPI_SUCCESS) {
        error_string[len] = '\0';
        return error_string;
    }
    return "unknown MPI error";
}

#if MPI_VERSION >= 5
static void C_MPI_Verbose_print_info(const char *label, MPI_Info info);
#endif

void C_MPI_Verbose_init(const char *binding, const char *compiler_version,
                        const char *compiler_options, const int *logical_size,
                        const int *integer_size, const int *real_size,
                        const int *double_precision_size)
{
    if (!VAPAA_ENV_BOOL("VAPAA_VERBOSE", false)) {
        return;
    }
    if (VAPAA_VERBOSE_EMITTED) {
        return;
    }
    VAPAA_VERBOSE_EMITTED = true;

    int rank = -1;
    int size = -1;
    int runtime_version = -1;
    int runtime_subversion = -1;
    int version_len = 0;
    int rc = MPI_SUCCESS;
    char library_version[MPI_MAX_LIBRARY_VERSION_STRING] = {0};

    (void) MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    (void) MPI_Comm_size(MPI_COMM_WORLD, &size);
    (void) MPI_Get_version(&runtime_version, &runtime_subversion);
    rc = MPI_Get_library_version(library_version, &version_len);
    if (rc != MPI_SUCCESS) {
        snprintf(library_version, sizeof(library_version),
                 "MPI_Get_library_version failed: %s", C_MPI_RC_NAME(rc));
        version_len = (int) strlen(library_version);
    }

    fprintf(stderr, "Vapaa verbose init begin\n");
    fprintf(stderr, "  binding: %s\n", binding);
    fprintf(stderr, "  process: rank %d of %d\n", rank, size);
    fprintf(stderr, "  Vapaa git hash: %s\n", VAPAA_GIT_HASH);
    fprintf(stderr, "  Vapaa git state at configure: %s\n", VAPAA_GIT_DIRTY);
    fprintf(stderr, "  Vapaa MPI vendor detection: %s\n", VAPAA_MPI_VENDOR_LABEL);
    fprintf(stderr, "  Vapaa C compile timestamp: %s %s\n", __DATE__, __TIME__);
    fprintf(stderr, "  C compiler: %s\n", __VERSION__);
    fprintf(stderr, "  Fortran compiler: %s\n", compiler_version);
    fprintf(stderr, "  Fortran compiler options: %s\n", compiler_options);
    fprintf(stderr, "  Fortran type sizes: LOGICAL=%d INTEGER=%d REAL=%d DOUBLE PRECISION=%d bytes\n",
            *logical_size, *integer_size, *real_size, *double_precision_size);
    fprintf(stderr, "  MPI header version: MPI_VERSION=%d MPI_SUBVERSION=%d\n",
            MPI_VERSION, MPI_SUBVERSION);
    fprintf(stderr, "  MPI runtime version: MPI_Get_version=%d.%d\n",
            runtime_version, runtime_subversion);
    fprintf(stderr, "  MPI_Get_library_version: %.*s\n", version_len, library_version);

#ifdef MPI_ABI
    fprintf(stderr, "  Vapaa compiled with MPI_ABI: yes\n");
#else
    fprintf(stderr, "  Vapaa compiled with MPI_ABI: no\n");
#endif

#ifdef MPI_ABI_VERSION
    fprintf(stderr, "  MPI ABI header version: MPI_ABI_VERSION=%d MPI_ABI_SUBVERSION=%d\n",
            MPI_ABI_VERSION, MPI_ABI_SUBVERSION);
#else
    fprintf(stderr, "  MPI ABI header version: unavailable\n");
#endif

#if MPI_VERSION >= 5
    int abi_major = -1;
    int abi_minor = -1;
    rc = MPI_Abi_get_version(&abi_major, &abi_minor);
    if (rc == MPI_SUCCESS) {
        fprintf(stderr, "  MPI_Abi_get_version: %d.%d\n", abi_major, abi_minor);
    } else {
        fprintf(stderr, "  MPI_Abi_get_version failed: %s\n", C_MPI_RC_NAME(rc));
    }

    MPI_Info abi_info = MPI_INFO_NULL;
    rc = MPI_Abi_get_info(&abi_info);
    if (rc == MPI_SUCCESS) {
        C_MPI_Verbose_print_info("MPI_Abi_get_info", abi_info);
        if (abi_info != MPI_INFO_NULL) (void) MPI_Info_free(&abi_info);
    } else {
        fprintf(stderr, "  MPI_Abi_get_info failed: %s\n", C_MPI_RC_NAME(rc));
    }

    MPI_Info fortran_info = MPI_INFO_NULL;
    rc = MPI_Abi_get_fortran_info(&fortran_info);
    if (rc == MPI_SUCCESS) {
        C_MPI_Verbose_print_info("MPI_Abi_get_fortran_info", fortran_info);
        if (fortran_info != MPI_INFO_NULL) (void) MPI_Info_free(&fortran_info);
    } else {
        fprintf(stderr, "  MPI_Abi_get_fortran_info failed: %s\n", C_MPI_RC_NAME(rc));
    }
#else
    fprintf(stderr, "  MPI ABI runtime APIs: unavailable before MPI-5\n");
#endif

    fprintf(stderr, "Vapaa verbose init end\n");
}

#if MPI_VERSION >= 5
static void C_MPI_Verbose_print_info(const char *label, MPI_Info info)
{
    int rc = MPI_SUCCESS;
    int nkeys = 0;

    if (info == MPI_INFO_NULL) {
        fprintf(stderr, "  %s: MPI_INFO_NULL\n", label);
        return;
    }

    rc = MPI_Info_get_nkeys(info, &nkeys);
    if (rc != MPI_SUCCESS) {
        fprintf(stderr, "  %s: MPI_Info_get_nkeys failed: %s\n", label, C_MPI_RC_NAME(rc));
        return;
    }

    fprintf(stderr, "  %s: %d keys\n", label, nkeys);
    for (int i = 0; i < nkeys; i++) {
        char key[MPI_MAX_INFO_KEY + 1] = {0};
        int valuelen = 0;
        int flag = 0;

        rc = MPI_Info_get_nthkey(info, i, key);
        if (rc != MPI_SUCCESS) {
            fprintf(stderr, "    [%d]: MPI_Info_get_nthkey failed: %s\n", i, C_MPI_RC_NAME(rc));
            continue;
        }

        rc = MPI_Info_get_valuelen(info, key, &valuelen, &flag);
        if (rc != MPI_SUCCESS || !flag || valuelen < 0) {
            fprintf(stderr, "    %s=<unavailable>\n", key);
            continue;
        }

        char *value = calloc((size_t) valuelen + 1, sizeof(char));
        if (value == NULL) {
            fprintf(stderr, "    %s=<allocation failed>\n", key);
            continue;
        }

        rc = MPI_Info_get(info, key, valuelen + 1, value, &flag);
        if (rc == MPI_SUCCESS && flag) {
            fprintf(stderr, "    %s=%s\n", key, value);
        } else {
            fprintf(stderr, "    %s=<unavailable>\n", key);
        }
        free(value);
    }
}
#endif

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
    if (*ierror == MPI_SUCCESS) {
        VAPAA_CFI_DATATYPE_DIAGNOSTICS_INIT();
    }
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

void C_MPI_Set_fortran_type_sizes(int * logical_size, int * integer_size,
                                  int * real_size, int * double_precision_size,
                                  int * ierror)
{
    VAPAA_CFI_SET_FORTRAN_TYPE_SIZES(*logical_size, *integer_size,
                                     *real_size, *double_precision_size);
    *ierror = MPI_SUCCESS;
}

void C_MPI_Abi_init_fortran(int * logical_size, const void * logical_true, const void * logical_false,
                            int * integer_size, int * real_size, int * double_precision_size,
                            int * ierror)
{
    *ierror = MPI_SUCCESS;
    VAPAA_CFI_SET_FORTRAN_TYPE_SIZES(*logical_size, *integer_size,
                                     *real_size, *double_precision_size);
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
    VAPAA_MPI_F90_Datatype_finalize();
    *ierror = MPI_Finalize();
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Init_thread(int * required_f, int * provided_f, int * ierror)
{
    int required = -1, provided = -1;
    required = C_MPI_THREAD_LEVEL_F2C(*required_f);
    *ierror = MPI_Init_thread(NULL, NULL, required, &provided);
    if (*ierror == MPI_SUCCESS) {
        VAPAA_CFI_DATATYPE_DIAGNOSTICS_INIT();
    }
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

void C_MPI_Is_thread_main(int * flag, int * ierror)
{
    *ierror = MPI_Is_thread_main(flag);
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
    *version = 5;
    *subversion = 0;
    *ierror = MPI_SUCCESS;
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

void C_MPI_Get_processor_name(char * name, int * resultlen, int * ierror)
{
    if (VAPAA_MPI_MAX_PROCESSOR_NAME < MPI_MAX_PROCESSOR_NAME) {
        fprintf(stderr,"C_MPI_Get_processor_name: buffer is not large enough - "
                       "bad things are going to happen now!\n"
                       "VAPAA_MPI_MAX_PROCESSOR_NAME=%d, MPI_MAX_PROCESSOR_NAME=%d\n",
                       VAPAA_MPI_MAX_PROCESSOR_NAME, MPI_MAX_PROCESSOR_NAME);
    }
    memset(name,0,VAPAA_MPI_MAX_PROCESSOR_NAME);
    *ierror = MPI_Get_processor_name(name, resultlen);
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

void C_MPI_Pcontrol(int * level, int * ierror)
{
    *ierror = MPI_Pcontrol(*level);
    C_MPI_RC_FIX(*ierror);
}
