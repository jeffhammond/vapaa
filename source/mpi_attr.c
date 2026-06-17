// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <string.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "mpi_attr_storage.h"
#include "vapaa_constants.h"

void VAPAA_MPI_Attr_delete(int *comm_f, int *keyval, int *ierror)
{
    void *attrval = NULL;
    int flag = 0;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    int keyval_c = C_MPI_COMM_ATTR_GLOBAL_F2C(*keyval);
    (void) MPI_Attr_get(comm, keyval_c, &attrval, &flag);
    *ierror = MPI_Attr_delete(comm, keyval_c);
    if (*ierror == MPI_SUCCESS && flag) {
        VAPAA_MPI_Attr_forget(attrval);
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Attr_get(int *comm_f, int *keyval, int *attrval_f, int *flag, int *ierror)
{
    void *attrval = NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const int keyval_c = C_MPI_COMM_ATTR_GLOBAL_F2C(*keyval);
    *ierror = MPI_Attr_get(comm, keyval_c, &attrval, flag);
    if (*ierror == MPI_SUCCESS && *flag && C_MPI_COMM_ATTR_GLOBAL_IS_PREDEFINED(keyval_c)) {
        *attrval_f = attrval == NULL ? 0 : C_MPI_COMM_ATTR_VALUE_C2F(keyval_c, *(int *)attrval);
    } else if (*ierror == MPI_SUCCESS && *flag && VAPAA_MPI_Attr_load_fint(attrval, attrval_f)) {
        /* Fortran-set attributes are stored as C-visible integer storage. */
    } else {
        *attrval_f = (int)(intptr_t)attrval;
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Attr_put(int *comm_f, int *keyval, int *attrval_f, int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Attr_put(comm, C_MPI_COMM_ATTR_GLOBAL_F2C(*keyval),
                           VAPAA_MPI_Attr_store_fint(*attrval_f));
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Keyval_free(int *keyval, int *ierror)
{
    *ierror = MPI_Keyval_free(keyval);
    C_MPI_RC_FIX(*ierror);
}

#define C_MPI_HANDLE_GET_NAME(Full,SHORT,Short)                                             \
void C_MPI_##Short##_get_name(int * handle_f, char * name, int * resultlen, int * ierror)   \
{                                                                                           \
    MPI_##Full handle = C_MPI_##SHORT##_FROMINT(*handle_f);                                 \
    *ierror = MPI_##Short##_get_name(handle, name, resultlen);                              \
    C_MPI_RC_FIX(*ierror);                                                                  \
}

#define C_MPI_HANDLE_SET_NAME(Full,SHORT,Short)                                             \
void C_MPI_##Short##_set_name(int * handle_f, char * name, int * ierror)                    \
{                                                                                           \
    MPI_##Full handle = C_MPI_##SHORT##_FROMINT(*handle_f);                                 \
    *ierror = MPI_##Short##_set_name(handle, name);                                         \
    C_MPI_RC_FIX(*ierror);                                                                  \
}

#define CFI_MPI_HANDLE_GET_NAME(Full,SHORT,Short)                                                       \
void CFI_MPI_##Short##_get_name(int * handle_f, CFI_cdesc_t * name_d, int * resultlen, int * ierror)    \
{                                                                                                       \
    MPI_##Full handle = C_MPI_##SHORT##_FROMINT(*handle_f);                                             \
    char * name = name_d -> base_addr;                                                                  \
    *ierror = MPI_##Short##_get_name(handle, name, resultlen);                                          \
    C_MPI_RC_FIX(*ierror);                                                                              \
}

#define CFI_MPI_HANDLE_SET_NAME(Full,SHORT,Short)                                                       \
void CFI_MPI_##Short##_set_name(int * handle_f, CFI_cdesc_t * name_d, int * ierror)                     \
{                                                                                                       \
    MPI_##Full handle = C_MPI_##SHORT##_FROMINT(*handle_f);                                             \
    char * name = name_d -> base_addr;                                                                  \
    *ierror = MPI_##Short##_set_name(handle, name);                                                     \
    C_MPI_RC_FIX(*ierror);                                                                              \
}

C_MPI_HANDLE_GET_NAME(Comm,COMM,Comm)
C_MPI_HANDLE_SET_NAME(Comm,COMM,Comm)
C_MPI_HANDLE_SET_NAME(Datatype,TYPE,Type)
C_MPI_HANDLE_GET_NAME(Win,WIN,Win)
C_MPI_HANDLE_SET_NAME(Win,WIN,Win)

static int C_MPI_Legacy_type_name(int type_f, char *name, int *resultlen)
{
    const char *legacy_name = NULL;
    if (type_f == VAPAA_MPI_LB) {
        legacy_name = "MPI_LB";
    } else if (type_f == VAPAA_MPI_UB) {
        legacy_name = "MPI_UB";
    } else {
        return 0;
    }

    strcpy(name, legacy_name);
    *resultlen = (int) strlen(legacy_name);
    return 1;
}

static int C_MPI_Fortran_type_name(int type_f, char *name, int *resultlen)
{
    const char *fortran_name = NULL;

    switch (type_f) {
        case VAPAA_MPI_LOGICAL:            fortran_name = "MPI_LOGICAL"; break;
        case VAPAA_MPI_INTEGER:            fortran_name = "MPI_INTEGER"; break;
        case VAPAA_MPI_REAL:               fortran_name = "MPI_REAL"; break;
        case VAPAA_MPI_COMPLEX:            fortran_name = "MPI_COMPLEX"; break;
        case VAPAA_MPI_DOUBLE_PRECISION:   fortran_name = "MPI_DOUBLE_PRECISION"; break;
        case VAPAA_MPI_DOUBLE_COMPLEX:     fortran_name = "MPI_DOUBLE_COMPLEX"; break;
        case VAPAA_MPI_CHARACTER:          fortran_name = "MPI_CHARACTER"; break;
        case VAPAA_MPI_2REAL:              fortran_name = "MPI_2REAL"; break;
        case VAPAA_MPI_2DOUBLE_PRECISION:  fortran_name = "MPI_2DOUBLE_PRECISION"; break;
        case VAPAA_MPI_2INTEGER:           fortran_name = "MPI_2INTEGER"; break;
        case VAPAA_MPI_INTEGER1:           fortran_name = "MPI_INTEGER1"; break;
        case VAPAA_MPI_INTEGER2:           fortran_name = "MPI_INTEGER2"; break;
        case VAPAA_MPI_REAL2:              fortran_name = "MPI_REAL2"; break;
        case VAPAA_MPI_INTEGER4:           fortran_name = "MPI_INTEGER4"; break;
        case VAPAA_MPI_REAL4:              fortran_name = "MPI_REAL4"; break;
        case VAPAA_MPI_COMPLEX4:           fortran_name = "MPI_COMPLEX4"; break;
        case VAPAA_MPI_INTEGER8:           fortran_name = "MPI_INTEGER8"; break;
        case VAPAA_MPI_REAL8:              fortran_name = "MPI_REAL8"; break;
        case VAPAA_MPI_COMPLEX8:           fortran_name = "MPI_COMPLEX8"; break;
        case VAPAA_MPI_INTEGER16:          fortran_name = "MPI_INTEGER16"; break;
        case VAPAA_MPI_REAL16:             fortran_name = "MPI_REAL16"; break;
        case VAPAA_MPI_COMPLEX16:          fortran_name = "MPI_COMPLEX16"; break;
        case VAPAA_MPI_COMPLEX32:          fortran_name = "MPI_COMPLEX32"; break;
        default:                           return 0;
    }

    strcpy(name, fortran_name);
    *resultlen = (int) strlen(fortran_name);
    return 1;
}

void C_MPI_Type_get_name(int *handle_f, char *name, int *resultlen, int *ierror)
{
    if (C_MPI_Legacy_type_name(*handle_f, name, resultlen)) {
        *ierror = MPI_SUCCESS;
        return;
    }
    if (C_MPI_Fortran_type_name(*handle_f, name, resultlen)) {
        *ierror = MPI_SUCCESS;
        return;
    }

    MPI_Datatype handle = C_MPI_TYPE_FROMINT(*handle_f);
    *ierror = MPI_Type_get_name(handle, name, resultlen);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
CFI_MPI_HANDLE_GET_NAME(Comm,COMM,Comm)
CFI_MPI_HANDLE_SET_NAME(Comm,COMM,Comm)
CFI_MPI_HANDLE_SET_NAME(Datatype,TYPE,Type)
CFI_MPI_HANDLE_GET_NAME(Win,WIN,Win)
CFI_MPI_HANDLE_SET_NAME(Win,WIN,Win)

void CFI_MPI_Type_get_name(int *handle_f, CFI_cdesc_t *name_d, int *resultlen, int *ierror)
{
    char *name = name_d -> base_addr;
    if (C_MPI_Legacy_type_name(*handle_f, name, resultlen)) {
        *ierror = MPI_SUCCESS;
        return;
    }
    if (C_MPI_Fortran_type_name(*handle_f, name, resultlen)) {
        *ierror = MPI_SUCCESS;
        return;
    }

    MPI_Datatype handle = C_MPI_TYPE_FROMINT(*handle_f);
    *ierror = MPI_Type_get_name(handle, name, resultlen);
    C_MPI_RC_FIX(*ierror);
}
#endif
