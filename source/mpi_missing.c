// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdlib.h>
#include <limits.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "mpi_attr_storage.h"
#include "vapaa_constants.h"
#include "vapaa_error_handling.h"

static int VAPAA_MPI_ORDER_F2C(int f)
{
#if MPI_VERSION >= 5
    return f;
#else
    if (f == VAPAA_MPI_ORDER_C) {
        return MPI_ORDER_C;
    } else if (f == VAPAA_MPI_ORDER_FORTRAN) {
        return MPI_ORDER_FORTRAN;
    } else {
        MPI_Abort(MPI_COMM_SELF, f);
        return -1;
    }
#endif
}

static int VAPAA_MPI_DISTRIBUTE_F2C(int f)
{
#if MPI_VERSION >= 5
    return f;
#else
    if (f == VAPAA_MPI_DISTRIBUTE_NONE) {
        return MPI_DISTRIBUTE_NONE;
    } else if (f == VAPAA_MPI_DISTRIBUTE_BLOCK) {
        return MPI_DISTRIBUTE_BLOCK;
    } else if (f == VAPAA_MPI_DISTRIBUTE_CYCLIC) {
        return MPI_DISTRIBUTE_CYCLIC;
    } else if (f == VAPAA_MPI_DISTRIBUTE_DFLT_DARG) {
        return MPI_DISTRIBUTE_DFLT_DARG;
    } else {
        return f;
    }
#endif
}

static int VAPAA_MPI_TYPECLASS_F2C(int f)
{
#if MPI_VERSION >= 5
    return f;
#else
    if (f == VAPAA_MPI_TYPECLASS_INTEGER) {
        return MPI_TYPECLASS_INTEGER;
    } else if (f == VAPAA_MPI_TYPECLASS_REAL) {
        return MPI_TYPECLASS_REAL;
    } else if (f == VAPAA_MPI_TYPECLASS_COMPLEX) {
        return MPI_TYPECLASS_COMPLEX;
    } else {
        return f;
    }
#endif
}

static int VAPAA_MPI_COMBINER_C2F(int c)
{
#if MPI_VERSION >= 5
    return c;
#else
    if (c == MPI_COMBINER_NAMED) {
        return VAPAA_MPI_COMBINER_NAMED;
    } else if (c == MPI_COMBINER_DUP) {
        return VAPAA_MPI_COMBINER_DUP;
    } else if (c == MPI_COMBINER_CONTIGUOUS) {
        return VAPAA_MPI_COMBINER_CONTIGUOUS;
    } else if (c == MPI_COMBINER_VECTOR) {
        return VAPAA_MPI_COMBINER_VECTOR;
    } else if (c == MPI_COMBINER_HVECTOR) {
        return VAPAA_MPI_COMBINER_HVECTOR;
    } else if (c == MPI_COMBINER_INDEXED) {
        return VAPAA_MPI_COMBINER_INDEXED;
    } else if (c == MPI_COMBINER_HINDEXED) {
        return VAPAA_MPI_COMBINER_HINDEXED;
    } else if (c == MPI_COMBINER_INDEXED_BLOCK) {
        return VAPAA_MPI_COMBINER_INDEXED_BLOCK;
#ifdef MPI_COMBINER_HINDEXED_BLOCK
    } else if (c == MPI_COMBINER_HINDEXED_BLOCK) {
        return VAPAA_MPI_COMBINER_HINDEXED_BLOCK;
#endif
    } else if (c == MPI_COMBINER_STRUCT) {
        return VAPAA_MPI_COMBINER_STRUCT;
    } else if (c == MPI_COMBINER_SUBARRAY) {
        return VAPAA_MPI_COMBINER_SUBARRAY;
    } else if (c == MPI_COMBINER_DARRAY) {
        return VAPAA_MPI_COMBINER_DARRAY;
    } else if (c == MPI_COMBINER_F90_REAL) {
        return VAPAA_MPI_COMBINER_F90_REAL;
    } else if (c == MPI_COMBINER_F90_COMPLEX) {
        return VAPAA_MPI_COMBINER_F90_COMPLEX;
    } else if (c == MPI_COMBINER_F90_INTEGER) {
        return VAPAA_MPI_COMBINER_F90_INTEGER;
    } else if (c == MPI_COMBINER_RESIZED) {
        return VAPAA_MPI_COMBINER_RESIZED;
#ifdef MPI_COMBINER_VALUE_INDEX
    } else if (c == MPI_COMBINER_VALUE_INDEX) {
        return VAPAA_MPI_COMBINER_VALUE_INDEX;
#endif
#ifdef MPI_COMBINER_HVECTOR_INTEGER
    } else if (c == MPI_COMBINER_HVECTOR_INTEGER) {
        return VAPAA_MPI_COMBINER_HVECTOR;
#endif
#ifdef MPI_COMBINER_HINDEXED_INTEGER
    } else if (c == MPI_COMBINER_HINDEXED_INTEGER) {
        return VAPAA_MPI_COMBINER_HINDEXED;
#endif
#ifdef MPI_COMBINER_STRUCT_INTEGER
    } else if (c == MPI_COMBINER_STRUCT_INTEGER) {
        return VAPAA_MPI_COMBINER_STRUCT;
#endif
    } else {
        return c;
    }
#endif
}

static MPI_Datatype *VAPAA_MPI_TYPES_FROMINT_ARRAY(int count, const int *types_f)
{
    MPI_Datatype *types = malloc((size_t) count * sizeof(*types));
    if (types == NULL) {
        return NULL;
    }
    for (int i = 0; i < count; ++i) {
        types[i] = C_MPI_TYPE_FROMINT(types_f[i]);
    }
    return types;
}

static void VAPAA_MPI_TYPES_TOINT_ARRAY(int count, const MPI_Datatype *types, int *types_f)
{
    for (int i = 0; i < count; ++i) {
        types_f[i] = C_MPI_TYPE_TOINT(types[i]);
    }
}

struct VAPAA_MPI_F90_Datatype {
    int handle;
    int combiner;
    int p;
    int r;
    MPI_Datatype datatype;
    struct VAPAA_MPI_F90_Datatype *next;
};

static struct VAPAA_MPI_F90_Datatype *vapaa_f90_datatypes = NULL;

static struct VAPAA_MPI_F90_Datatype *VAPAA_MPI_F90_DATATYPE_FIND_PARAMS(int combiner, int p, int r)
{
    for (struct VAPAA_MPI_F90_Datatype *e = vapaa_f90_datatypes; e != NULL; e = e->next) {
        if (e->combiner == combiner && e->p == p && e->r == r) {
            return e;
        }
    }
    return NULL;
}

static struct VAPAA_MPI_F90_Datatype *VAPAA_MPI_F90_DATATYPE_FIND_HANDLE(int handle)
{
    for (struct VAPAA_MPI_F90_Datatype *e = vapaa_f90_datatypes; e != NULL; e = e->next) {
        if (e->handle == handle) {
            return e;
        }
    }
    return NULL;
}

static MPI_Datatype VAPAA_MPI_F90_INTEGER_FALLBACK(int r)
{
    if (r <= 2) return MPI_INT8_T;
    if (r <= 4) return MPI_INT16_T;
    if (r <= 9) return MPI_INT32_T;
    return MPI_INT64_T;
}

static MPI_Datatype VAPAA_MPI_F90_REAL_FALLBACK(int p)
{
    if (p <= 6) return MPI_FLOAT;
    if (p <= 15) return MPI_DOUBLE;
    return MPI_LONG_DOUBLE;
}

static MPI_Datatype VAPAA_MPI_F90_COMPLEX_FALLBACK(int p)
{
    if (p <= 6) return MPI_C_FLOAT_COMPLEX;
    if (p <= 15) return MPI_C_DOUBLE_COMPLEX;
    return MPI_C_LONG_DOUBLE_COMPLEX;
}

static int VAPAA_MPI_F90_DATATYPE_CREATE(int combiner, int p, int r, MPI_Datatype fallback, int *newtype_f)
{
    struct VAPAA_MPI_F90_Datatype *existing = VAPAA_MPI_F90_DATATYPE_FIND_PARAMS(combiner, p, r);
    if (existing != NULL) {
        *newtype_f = existing->handle;
        return MPI_SUCCESS;
    }

    MPI_Datatype datatype = MPI_DATATYPE_NULL;
    int rc = MPI_Type_dup(fallback, &datatype);
    if (rc != MPI_SUCCESS) {
        return rc;
    }

    struct VAPAA_MPI_F90_Datatype *entry = malloc(sizeof(*entry));
    if (entry == NULL) {
        MPI_Type_free(&datatype);
        return MPI_ERR_NO_MEM;
    }
    entry->handle = C_MPI_TYPE_TOINT(datatype);
    entry->combiner = combiner;
    entry->p = p;
    entry->r = r;
    entry->datatype = datatype;
    entry->next = vapaa_f90_datatypes;
    vapaa_f90_datatypes = entry;
    *newtype_f = entry->handle;
    return MPI_SUCCESS;
}

void VAPAA_MPI_F90_Datatype_finalize(void)
{
    while (vapaa_f90_datatypes != NULL) {
        struct VAPAA_MPI_F90_Datatype *entry = vapaa_f90_datatypes;
        vapaa_f90_datatypes = entry->next;
        if (entry->datatype != MPI_DATATYPE_NULL) {
            (void) MPI_Type_free(&entry->datatype);
        }
        free(entry);
    }
}

MAYBE_UNUSED static int VAPAA_MPI_COUNT_TO_INT(int64_t value, int *out)
{
    if (value > INT_MAX || value < INT_MIN) {
        return MPI_ERR_ARG;
    }
    *out = (int)value;
    return MPI_SUCCESS;
}

MAYBE_UNUSED static int VAPAA_MPI_COUNTS_TO_INT_ARRAY(int count, const int64_t *values, int **out)
{
    *out = NULL;
    if (count <= 0) {
        return MPI_SUCCESS;
    }
    int *tmp = malloc((size_t)count * sizeof(*tmp));
    if (tmp == NULL) {
        return MPI_ERR_NO_MEM;
    }
    for (int i = 0; i < count; ++i) {
        int rc = VAPAA_MPI_COUNT_TO_INT(values[i], &tmp[i]);
        if (rc != MPI_SUCCESS) {
            free(tmp);
            return rc;
        }
    }
    *out = tmp;
    return MPI_SUCCESS;
}

MAYBE_UNUSED static MPI_Aint *VAPAA_MPI_COUNTS_TO_AINT_ARRAY(int count, const int64_t *values)
{
    if (count <= 0) {
        return NULL;
    }
    MPI_Aint *tmp = malloc((size_t)count * sizeof(*tmp));
    if (tmp == NULL) {
        return NULL;
    }
    for (int i = 0; i < count; ++i) {
        tmp[i] = (MPI_Aint)values[i];
    }
    return tmp;
}

MAYBE_UNUSED static int VAPAA_MPI_COUNT_TO_INT64(MPI_Count value, int64_t *out)
{
    int64_t tmp = (int64_t)value;
    if ((MPI_Count)tmp != value) {
        return MPI_ERR_ARG;
    }
    *out = tmp;
    return MPI_SUCCESS;
}

MAYBE_UNUSED static void VAPAA_MPI_DATATYPE_ARRAY_FILL_NULL(int count, int *types_f)
{
    for (int i = 0; i < count; ++i) {
        types_f[i] = VAPAA_MPI_DATATYPE_NULL;
    }
}

intptr_t VAPAA_MPI_Aint_add(intptr_t base, intptr_t disp)
{
    return (intptr_t) MPI_Aint_add((MPI_Aint) base, (MPI_Aint) disp);
}

intptr_t VAPAA_MPI_Aint_diff(intptr_t addr1, intptr_t addr2)
{
    return (intptr_t) MPI_Aint_diff((MPI_Aint) addr1, (MPI_Aint) addr2);
}

#ifdef HAVE_CFI
void VAPAA_MPI_Get_address(CFI_cdesc_t *location, intptr_t *address_f, int *ierror)
{
    MPI_Aint address = 0;
    *ierror = MPI_Get_address(location->base_addr, &address);
    *address_f = (intptr_t) address;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Free_mem(CFI_cdesc_t *base, int *ierror)
{
    *ierror = MPI_Free_mem(base->base_addr);
    C_MPI_RC_FIX(*ierror);
}
#endif

void VAPAA_MPI_Get_address_nocfi(void *location, intptr_t *address_f, int *ierror)
{
    MPI_Aint address = 0;
    *ierror = MPI_Get_address(location, &address);
    *address_f = (intptr_t) address;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Free_mem_nocfi(void *base, int *ierror)
{
    *ierror = MPI_Free_mem(base);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Alloc_mem(intptr_t *size_f, int *info_f, void **baseptr, int *ierror)
{
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Alloc_mem((MPI_Aint) *size_f, info, baseptr);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Get_count(const struct F_MPI_Status *status_f, int *datatype_f, int *count, int *ierror)
{
    MPI_Status status;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    C_MPI_STATUS_TO_C(status_f, &status);
    *ierror = MPI_Get_count(&status, datatype, count);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Get_count_c(const struct F_MPI_Status *status_f, int *datatype_f, int64_t *count_f, int *ierror)
{
    MPI_Status status;
    MPI_Count count = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    C_MPI_STATUS_TO_C(status_f, &status);
#if MPI_VERSION >= 4
    *ierror = MPI_Get_count_c(&status, datatype, &count);
#else
    int count_i = 0;
    *ierror = MPI_Get_count(&status, datatype, &count_i);
    count = (MPI_Count)count_i;
#endif
    *count_f = (int64_t) count;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Get_elements(const struct F_MPI_Status *status_f, int *datatype_f, int *count, int *ierror)
{
    MPI_Status status;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    C_MPI_STATUS_TO_C(status_f, &status);
    *ierror = MPI_Get_elements(&status, datatype, count);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Get_elements_c(const struct F_MPI_Status *status_f, int *datatype_f, int64_t *count_f, int *ierror)
{
    MPI_Status status;
    MPI_Count count = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    C_MPI_STATUS_TO_C(status_f, &status);
#if MPI_VERSION >= 4
    *ierror = MPI_Get_elements_c(&status, datatype, &count);
#else
    *ierror = MPI_Get_elements_x(&status, datatype, &count);
#endif
    *count_f = (int64_t) count;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Get_elements_x(const struct F_MPI_Status *status_f, int *datatype_f, int64_t *count_f, int *ierror)
{
    MPI_Status status;
    MPI_Count count = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    C_MPI_STATUS_TO_C(status_f, &status);
    *ierror = MPI_Get_elements_x(&status, datatype, &count);
    *count_f = (int64_t) count;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_size_x(int *datatype_f, int64_t *size_f, int *ierror)
{
    MPI_Count size = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_Type_size_x(datatype, &size);
    *size_f = (int64_t) size;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_extent(int *datatype_f, intptr_t *lb_f, intptr_t *extent_f, int *ierror)
{
    MPI_Aint lb = 0, extent = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_Type_get_extent(datatype, &lb, &extent);
    *lb_f = (intptr_t) lb;
    *extent_f = (intptr_t) extent;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_extent_x(int *datatype_f, int64_t *lb_f, int64_t *extent_f, int *ierror)
{
    MPI_Count lb = 0, extent = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_Type_get_extent_x(datatype, &lb, &extent);
    *lb_f = (int64_t) lb;
    *extent_f = (int64_t) extent;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_true_extent(int *datatype_f, intptr_t *lb_f, intptr_t *extent_f, int *ierror)
{
    MPI_Aint lb = 0, extent = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_Type_get_true_extent(datatype, &lb, &extent);
    *lb_f = (intptr_t) lb;
    *extent_f = (intptr_t) extent;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_true_extent_x(int *datatype_f, int64_t *lb_f, int64_t *extent_f, int *ierror)
{
    MPI_Count lb = 0, extent = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_Type_get_true_extent_x(datatype, &lb, &extent);
    *lb_f = (int64_t) lb;
    *extent_f = (int64_t) extent;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_resized(int *oldtype_f, intptr_t *lb_f, intptr_t *extent_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_FROMINT(*oldtype_f);
    *ierror = MPI_Type_create_resized(oldtype, (MPI_Aint) *lb_f, (MPI_Aint) *extent_f, &newtype);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_hvector(int *count, int *blocklength, intptr_t *stride_f, int *oldtype_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_FROMINT(*oldtype_f);
    *ierror = MPI_Type_create_hvector(*count, *blocklength, (MPI_Aint) *stride_f, oldtype, &newtype);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_hvector_c(int64_t *count, int64_t *blocklength, int64_t *stride, int *oldtype_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_FROMINT(*oldtype_f);
#if MPI_VERSION >= 4
    *ierror = MPI_Type_create_hvector_c((MPI_Count) *count, (MPI_Count) *blocklength, (MPI_Count) *stride, oldtype, &newtype);
#else
    int count_i = 0, blocklength_i = 0;
    *ierror = VAPAA_MPI_COUNT_TO_INT(*count, &count_i);
    if (*ierror == MPI_SUCCESS) {
        *ierror = VAPAA_MPI_COUNT_TO_INT(*blocklength, &blocklength_i);
    }
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_Type_create_hvector(count_i, blocklength_i, (MPI_Aint)*stride, oldtype, &newtype);
    }
#endif
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_hindexed(int *count, int *blocklengths, intptr_t *displacements_f, int *oldtype_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_FROMINT(*oldtype_f);
    *ierror = MPI_Type_create_hindexed(*count, blocklengths, (const MPI_Aint *) displacements_f, oldtype, &newtype);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_hindexed_c(int64_t *count, int64_t *blocklengths, int64_t *displacements, int *oldtype_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_FROMINT(*oldtype_f);
#if MPI_VERSION >= 4
    *ierror = MPI_Type_create_hindexed_c((MPI_Count) *count, (const MPI_Count *) blocklengths,
                                         (const MPI_Count *) displacements, oldtype, &newtype);
#else
    int count_i = 0, *blocklengths_i = NULL;
    MPI_Aint *displacements_a = NULL;
    *ierror = VAPAA_MPI_COUNT_TO_INT(*count, &count_i);
    if (*ierror == MPI_SUCCESS) {
        *ierror = VAPAA_MPI_COUNTS_TO_INT_ARRAY(count_i, blocklengths, &blocklengths_i);
    }
    if (*ierror == MPI_SUCCESS) {
        displacements_a = VAPAA_MPI_COUNTS_TO_AINT_ARRAY(count_i, displacements);
        if (count_i > 0 && displacements_a == NULL) {
            *ierror = MPI_ERR_NO_MEM;
        }
    }
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_Type_create_hindexed(count_i, blocklengths_i, displacements_a, oldtype, &newtype);
    }
    free(blocklengths_i);
    free(displacements_a);
#endif
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_hindexed_block(int *count, int *blocklength, intptr_t *displacements_f, int *oldtype_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_FROMINT(*oldtype_f);
    *ierror = MPI_Type_create_hindexed_block(*count, *blocklength, (const MPI_Aint *) displacements_f, oldtype, &newtype);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_hindexed_block_c(int64_t *count, int64_t *blocklength, int64_t *displacements, int *oldtype_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_FROMINT(*oldtype_f);
#if MPI_VERSION >= 4
    *ierror = MPI_Type_create_hindexed_block_c((MPI_Count) *count, (MPI_Count) *blocklength,
                                               (const MPI_Count *) displacements, oldtype, &newtype);
#else
    int count_i = 0, blocklength_i = 0;
    MPI_Aint *displacements_a = NULL;
    *ierror = VAPAA_MPI_COUNT_TO_INT(*count, &count_i);
    if (*ierror == MPI_SUCCESS) {
        *ierror = VAPAA_MPI_COUNT_TO_INT(*blocklength, &blocklength_i);
    }
    if (*ierror == MPI_SUCCESS) {
        displacements_a = VAPAA_MPI_COUNTS_TO_AINT_ARRAY(count_i, displacements);
        if (count_i > 0 && displacements_a == NULL) {
            *ierror = MPI_ERR_NO_MEM;
        }
    }
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_Type_create_hindexed_block(count_i, blocklength_i, displacements_a, oldtype, &newtype);
    }
    free(displacements_a);
#endif
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_indexed_block(int *count, int *blocklength, int *displacements, int *oldtype_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_FROMINT(*oldtype_f);
    *ierror = MPI_Type_create_indexed_block(*count, *blocklength, displacements, oldtype, &newtype);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_indexed_block_c(int64_t *count, int64_t *blocklength, int64_t *displacements, int *oldtype_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_FROMINT(*oldtype_f);
#if MPI_VERSION >= 4
    *ierror = MPI_Type_create_indexed_block_c((MPI_Count) *count, (MPI_Count) *blocklength,
                                              (const MPI_Count *) displacements, oldtype, &newtype);
#else
    int count_i = 0, blocklength_i = 0, *displacements_i = NULL;
    *ierror = VAPAA_MPI_COUNT_TO_INT(*count, &count_i);
    if (*ierror == MPI_SUCCESS) {
        *ierror = VAPAA_MPI_COUNT_TO_INT(*blocklength, &blocklength_i);
    }
    if (*ierror == MPI_SUCCESS) {
        *ierror = VAPAA_MPI_COUNTS_TO_INT_ARRAY(count_i, displacements, &displacements_i);
    }
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_Type_create_indexed_block(count_i, blocklength_i, displacements_i, oldtype, &newtype);
    }
    free(displacements_i);
#endif
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_indexed(int *count, int *blocklengths, int *displacements, int *oldtype_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_FROMINT(*oldtype_f);
    *ierror = MPI_Type_indexed(*count, blocklengths, displacements, oldtype, &newtype);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_indexed_c(int64_t *count, int64_t *blocklengths, int64_t *displacements, int *oldtype_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_FROMINT(*oldtype_f);
#if MPI_VERSION >= 4
    *ierror = MPI_Type_indexed_c((MPI_Count) *count, (const MPI_Count *) blocklengths,
                                 (const MPI_Count *) displacements, oldtype, &newtype);
#else
    int count_i = 0, *blocklengths_i = NULL, *displacements_i = NULL;
    *ierror = VAPAA_MPI_COUNT_TO_INT(*count, &count_i);
    if (*ierror == MPI_SUCCESS) {
        *ierror = VAPAA_MPI_COUNTS_TO_INT_ARRAY(count_i, blocklengths, &blocklengths_i);
    }
    if (*ierror == MPI_SUCCESS) {
        *ierror = VAPAA_MPI_COUNTS_TO_INT_ARRAY(count_i, displacements, &displacements_i);
    }
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_Type_indexed(count_i, blocklengths_i, displacements_i, oldtype, &newtype);
    }
    free(blocklengths_i);
    free(displacements_i);
#endif
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_struct(int *count, int *blocklengths, intptr_t *displacements_f, int *datatypes_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype *datatypes = VAPAA_MPI_TYPES_FROMINT_ARRAY(*count, datatypes_f);
    if (datatypes == NULL) {
        *ierror = C_MPI_ERROR_CODE_C2F(MPI_ERR_NO_MEM);
        return;
    }
    *ierror = MPI_Type_create_struct(*count, blocklengths, (const MPI_Aint *) displacements_f, datatypes, &newtype);
    free(datatypes);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_struct_c(int64_t *count_f, int64_t *blocklengths, int64_t *displacements, int *datatypes_f, int *newtype_f, int *ierror)
{
    int count = 0;
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    *ierror = VAPAA_MPI_COUNT_TO_INT(*count_f, &count);
    if (*ierror != MPI_SUCCESS) {
        *newtype_f = C_MPI_TYPE_TOINT(newtype);
        C_MPI_RC_FIX(*ierror);
        return;
    }
    MPI_Datatype *datatypes = VAPAA_MPI_TYPES_FROMINT_ARRAY(count, datatypes_f);
    if (datatypes == NULL) {
        *ierror = MPI_ERR_NO_MEM;
        *newtype_f = C_MPI_TYPE_TOINT(newtype);
        C_MPI_RC_FIX(*ierror);
        return;
    }
#if MPI_VERSION >= 4
    *ierror = MPI_Type_create_struct_c((MPI_Count) *count_f, (const MPI_Count *) blocklengths,
                                       (const MPI_Count *) displacements, datatypes, &newtype);
#else
    int *blocklengths_i = NULL;
    MPI_Aint *displacements_a = NULL;
    *ierror = VAPAA_MPI_COUNTS_TO_INT_ARRAY(count, blocklengths, &blocklengths_i);
    if (*ierror == MPI_SUCCESS) {
        displacements_a = VAPAA_MPI_COUNTS_TO_AINT_ARRAY(count, displacements);
        if (count > 0 && displacements_a == NULL) {
            *ierror = MPI_ERR_NO_MEM;
        }
    }
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_Type_create_struct(count, blocklengths_i, displacements_a, datatypes, &newtype);
    }
    free(blocklengths_i);
    free(displacements_a);
#endif
    free(datatypes);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_darray(int *size, int *rank, int *ndims, int *gsizes, int *distribs_f, int *dargs_f,
                                  int *psizes, int *order_f, int *oldtype_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_FROMINT(*oldtype_f);
    int *distribs = malloc((size_t) *ndims * sizeof(*distribs));
    int *dargs = malloc((size_t) *ndims * sizeof(*dargs));
    if (distribs == NULL || dargs == NULL) {
        free(distribs);
        free(dargs);
        *ierror = C_MPI_ERROR_CODE_C2F(MPI_ERR_NO_MEM);
        return;
    }
    for (int i = 0; i < *ndims; ++i) {
        distribs[i] = VAPAA_MPI_DISTRIBUTE_F2C(distribs_f[i]);
        dargs[i] = VAPAA_MPI_DISTRIBUTE_F2C(dargs_f[i]);
    }
    *ierror = MPI_Type_create_darray(*size, *rank, *ndims, gsizes, distribs, dargs, psizes,
                                     VAPAA_MPI_ORDER_F2C(*order_f), oldtype, &newtype);
    free(distribs);
    free(dargs);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_darray_c(int *size, int *rank, int *ndims, int64_t *gsizes, int *distribs_f, int *dargs_f,
                                    int *psizes, int *order_f, int *oldtype_f, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype oldtype = C_MPI_TYPE_FROMINT(*oldtype_f);
    int *distribs = malloc((size_t) *ndims * sizeof(*distribs));
    int *dargs = malloc((size_t) *ndims * sizeof(*dargs));
    if (distribs == NULL || dargs == NULL) {
        free(distribs);
        free(dargs);
        *ierror = C_MPI_ERROR_CODE_C2F(MPI_ERR_NO_MEM);
        return;
    }
    for (int i = 0; i < *ndims; ++i) {
        distribs[i] = VAPAA_MPI_DISTRIBUTE_F2C(distribs_f[i]);
        dargs[i] = VAPAA_MPI_DISTRIBUTE_F2C(dargs_f[i]);
    }
#if MPI_VERSION >= 4
    *ierror = MPI_Type_create_darray_c(*size, *rank, *ndims, (const MPI_Count *) gsizes, distribs, dargs, psizes,
                                       VAPAA_MPI_ORDER_F2C(*order_f), oldtype, &newtype);
#else
    int *gsizes_i = NULL;
    *ierror = VAPAA_MPI_COUNTS_TO_INT_ARRAY(*ndims, gsizes, &gsizes_i);
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_Type_create_darray(*size, *rank, *ndims, gsizes_i, distribs, dargs, psizes,
                                         VAPAA_MPI_ORDER_F2C(*order_f), oldtype, &newtype);
    }
    free(gsizes_i);
#endif
    free(distribs);
    free(dargs);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_f90_integer(int *r, int *newtype_f, int *ierror)
{
    *ierror = VAPAA_MPI_F90_DATATYPE_CREATE(VAPAA_MPI_COMBINER_F90_INTEGER, 0, *r,
                                            VAPAA_MPI_F90_INTEGER_FALLBACK(*r), newtype_f);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_f90_real(int *p, int *r, int *newtype_f, int *ierror)
{
    *ierror = VAPAA_MPI_F90_DATATYPE_CREATE(VAPAA_MPI_COMBINER_F90_REAL, *p, *r,
                                            VAPAA_MPI_F90_REAL_FALLBACK(*p), newtype_f);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_f90_complex(int *p, int *r, int *newtype_f, int *ierror)
{
    *ierror = VAPAA_MPI_F90_DATATYPE_CREATE(VAPAA_MPI_COMBINER_F90_COMPLEX, *p, *r,
                                            VAPAA_MPI_F90_COMPLEX_FALLBACK(*p), newtype_f);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_envelope(int *datatype_f, int *ni, int *na, int *nd, int *combiner_f, int *ierror)
{
    *ni = 0;
    *na = 0;
    *nd = 0;
    *combiner_f = 0;

    struct VAPAA_MPI_F90_Datatype *f90 = VAPAA_MPI_F90_DATATYPE_FIND_HANDLE(*datatype_f);
    if (f90 != NULL) {
        *ni = (f90->combiner == VAPAA_MPI_COMBINER_F90_INTEGER) ? 1 : 2;
        *na = 0;
        *nd = 0;
        *combiner_f = f90->combiner;
        *ierror = MPI_SUCCESS;
        return;
    }

    int combiner = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_Type_get_envelope(datatype, ni, na, nd, &combiner);
    *combiner_f = VAPAA_MPI_COMBINER_C2F(combiner);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_envelope_c(int *datatype_f, int64_t *ni_f, int64_t *na_f, int64_t *nl_f, int64_t *nd_f, int *combiner_f, int *ierror)
{
    *ni_f = 0;
    *na_f = 0;
    *nl_f = 0;
    *nd_f = 0;
    *combiner_f = 0;

    struct VAPAA_MPI_F90_Datatype *f90 = VAPAA_MPI_F90_DATATYPE_FIND_HANDLE(*datatype_f);
    if (f90 != NULL) {
        *ni_f = (f90->combiner == VAPAA_MPI_COMBINER_F90_INTEGER) ? 1 : 2;
        *na_f = 0;
        *nl_f = 0;
        *nd_f = 0;
        *combiner_f = f90->combiner;
        *ierror = MPI_SUCCESS;
        return;
    }

    MPI_Count ni = 0, na = 0, nl = 0, nd = 0;
    int combiner = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
#if MPI_VERSION >= 4
    *ierror = MPI_Type_get_envelope_c(datatype, &ni, &na, &nl, &nd, &combiner);
#else
    int ni_i = 0, na_i = 0, nd_i = 0;
    *ierror = MPI_Type_get_envelope(datatype, &ni_i, &na_i, &nd_i, &combiner);
    ni = ni_i;
    na = na_i;
    nd = nd_i;
#endif
    *ni_f = (int64_t) ni;
    *na_f = (int64_t) na;
    *nl_f = (int64_t) nl;
    *nd_f = (int64_t) nd;
    *combiner_f = VAPAA_MPI_COMBINER_C2F(combiner);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_contents(int *datatype_f, int *mi, int *ma, int *md, int *ints, intptr_t *addrs_f, int *types_f, int *ierror)
{
    if (*md > 0) {
        VAPAA_MPI_DATATYPE_ARRAY_FILL_NULL(*md, types_f);
    }

    struct VAPAA_MPI_F90_Datatype *f90 = VAPAA_MPI_F90_DATATYPE_FIND_HANDLE(*datatype_f);
    if (f90 != NULL) {
        int needed = (f90->combiner == VAPAA_MPI_COMBINER_F90_INTEGER) ? 1 : 2;
        if (*mi < needed || *ma != 0 || *md != 0) {
            *ierror = C_MPI_ERROR_CODE_C2F(MPI_ERR_ARG);
            return;
        }
        ints[0] = (f90->combiner == VAPAA_MPI_COMBINER_F90_INTEGER) ? f90->r : f90->p;
        if (needed == 2) ints[1] = f90->r;
        *ierror = MPI_SUCCESS;
        return;
    }

    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);

    int ni = 0, na = 0, nd = 0, combiner = 0;
    *ierror = MPI_Type_get_envelope(datatype, &ni, &na, &nd, &combiner);
    if (*ierror != MPI_SUCCESS) {
        C_MPI_RC_FIX(*ierror);
        return;
    }
    if (*mi < ni || *ma < na || *md < nd) {
        *ierror = C_MPI_ERROR_CODE_C2F(MPI_ERR_ARG);
        return;
    }

    MPI_Aint dummy_addr = 0;
    MPI_Aint *addrs = &dummy_addr;
    if (na > 0) {
        addrs = malloc((size_t) na * sizeof(*addrs));
    }
    if (na > 0 && addrs == NULL) {
        *ierror = C_MPI_ERROR_CODE_C2F(MPI_ERR_NO_MEM);
        return;
    }

    MPI_Datatype dummy_type = MPI_DATATYPE_NULL;
    MPI_Datatype *types = &dummy_type;
    if (nd > 0) {
        types = malloc((size_t) nd * sizeof(*types));
    }
    if (nd > 0 && types == NULL) {
        if (na > 0) {
            free(addrs);
        }
        *ierror = C_MPI_ERROR_CODE_C2F(MPI_ERR_NO_MEM);
        return;
    }

    for (int i = 0; i < nd; ++i) {
        types[i] = MPI_DATATYPE_NULL;
    }
    *ierror = MPI_Type_get_contents(datatype, ni, na, nd, ints, addrs, types);
    if (*ierror == MPI_SUCCESS) {
        for (int i = 0; i < na; ++i) {
            addrs_f[i] = (intptr_t)addrs[i];
        }
        VAPAA_MPI_TYPES_TOINT_ARRAY(nd, types, types_f);
    }
    if (types != &dummy_type) {
        free(types);
    }
    if (addrs != &dummy_addr) {
        free(addrs);
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_contents_c(int *datatype_f, int64_t *mi_f, int64_t *ma_f, int64_t *ml_f, int64_t *md_f,
                                   int *ints, intptr_t *addrs_f, int64_t *counts_f, int *types_f, int *ierror)
{
    int md = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = VAPAA_MPI_COUNT_TO_INT(*md_f, &md);
    if (*ierror != MPI_SUCCESS) {
        C_MPI_RC_FIX(*ierror);
        return;
    }
    if (md > 0) {
        VAPAA_MPI_DATATYPE_ARRAY_FILL_NULL(md, types_f);
    }

    struct VAPAA_MPI_F90_Datatype *f90 = VAPAA_MPI_F90_DATATYPE_FIND_HANDLE(*datatype_f);
    if (f90 != NULL) {
        int64_t needed = (f90->combiner == VAPAA_MPI_COMBINER_F90_INTEGER) ? 1 : 2;
        if (*mi_f < needed || *ma_f != 0 || *ml_f != 0 || *md_f != 0) {
            *ierror = C_MPI_ERROR_CODE_C2F(MPI_ERR_ARG);
            return;
        }
        ints[0] = (f90->combiner == VAPAA_MPI_COMBINER_F90_INTEGER) ? f90->r : f90->p;
        if (needed == 2) ints[1] = f90->r;
        *ierror = MPI_SUCCESS;
        return;
    }
#if MPI_VERSION >= 4
    MPI_Count ni = 0, na = 0, nl = 0, nd = 0;
    int combiner = 0, na_i = 0, nl_i = 0, nd_i = 0;
    *ierror = MPI_Type_get_envelope_c(datatype, &ni, &na, &nl, &nd, &combiner);
    if (*ierror == MPI_SUCCESS && (*mi_f < (int64_t) ni || *ma_f < (int64_t) na ||
                                   *ml_f < (int64_t) nl || *md_f < (int64_t) nd)) {
        *ierror = MPI_ERR_ARG;
    }
    if (*ierror == MPI_SUCCESS) {
        *ierror = VAPAA_MPI_COUNT_TO_INT((int64_t) na, &na_i);
    }
    if (*ierror == MPI_SUCCESS) {
        *ierror = VAPAA_MPI_COUNT_TO_INT((int64_t) nl, &nl_i);
    }
    if (*ierror == MPI_SUCCESS) {
        *ierror = VAPAA_MPI_COUNT_TO_INT((int64_t) nd, &nd_i);
    }

    MPI_Aint dummy_addr = 0;
    MPI_Aint *addrs = &dummy_addr;
    if (*ierror == MPI_SUCCESS && na_i > 0) {
        addrs = malloc((size_t) na_i * sizeof(*addrs));
        if (addrs == NULL) {
            *ierror = MPI_ERR_NO_MEM;
        }
    }

    MPI_Count dummy_count = 0;
    MPI_Count *counts = &dummy_count;
    if (*ierror == MPI_SUCCESS && nl_i > 0) {
        counts = malloc((size_t) nl_i * sizeof(*counts));
        if (counts == NULL) {
            *ierror = MPI_ERR_NO_MEM;
        }
    }

    MPI_Datatype dummy_type = MPI_DATATYPE_NULL;
    MPI_Datatype *types = NULL;
    types = &dummy_type;
    if (*ierror == MPI_SUCCESS) {
        if (nd_i > 0) {
            types = malloc((size_t) nd_i * sizeof(*types));
            if (types == NULL) {
                *ierror = MPI_ERR_NO_MEM;
            }
        }
    }
    if (*ierror == MPI_SUCCESS) {
        for (int i = 0; i < nd_i; ++i) {
            types[i] = MPI_DATATYPE_NULL;
        }
        *ierror = MPI_Type_get_contents_c(datatype, ni, na, nl, nd,
                                          ints, addrs, counts, types);
    }
    if (*ierror == MPI_SUCCESS) {
        for (int i = 0; i < na_i; ++i) {
            addrs_f[i] = (intptr_t)addrs[i];
        }
        for (int i = 0; *ierror == MPI_SUCCESS && i < nl_i; ++i) {
            *ierror = VAPAA_MPI_COUNT_TO_INT64(counts[i], &counts_f[i]);
        }
        if (*ierror == MPI_SUCCESS) {
            VAPAA_MPI_TYPES_TOINT_ARRAY(nd_i, types, types_f);
        }
    }
    if (types != &dummy_type) {
        free(types);
    }
    if (counts != &dummy_count) {
        free(counts);
    }
    if (addrs != &dummy_addr) {
        free(addrs);
    }
#else
    int mi = 0, ma = 0;
    MPI_Aint dummy_addr = 0;
    MPI_Aint *addrs = &dummy_addr;
    MPI_Datatype dummy_type = MPI_DATATYPE_NULL;
    MPI_Datatype *types = &dummy_type;
    (void) counts_f;
    *ierror = VAPAA_MPI_COUNT_TO_INT(*mi_f, &mi);
    if (*ierror == MPI_SUCCESS) {
        *ierror = VAPAA_MPI_COUNT_TO_INT(*ma_f, &ma);
    }
    if (*ierror == MPI_SUCCESS && *ml_f != 0) {
        *ierror = MPI_ERR_ARG;
    }
    if (*ierror == MPI_SUCCESS && ma > 0) {
        addrs = malloc((size_t) ma * sizeof(*addrs));
        if (addrs == NULL) {
            *ierror = MPI_ERR_NO_MEM;
        }
    }
    if (*ierror == MPI_SUCCESS) {
        if (md > 0) {
            types = malloc((size_t) md * sizeof(*types));
            if (types == NULL) {
                *ierror = MPI_ERR_NO_MEM;
            }
        }
    }
    if (*ierror == MPI_SUCCESS) {
        for (int i = 0; i < md; ++i) {
            types[i] = MPI_DATATYPE_NULL;
        }
        *ierror = MPI_Type_get_contents(datatype, mi, ma, md, ints, addrs, types);
    }
    if (*ierror == MPI_SUCCESS) {
        for (int i = 0; i < ma; ++i) {
            addrs_f[i] = (intptr_t)addrs[i];
        }
        VAPAA_MPI_TYPES_TOINT_ARRAY(md, types, types_f);
    }
    if (types != &dummy_type) {
        free(types);
    }
    if (addrs != &dummy_addr) {
        free(addrs);
    }
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_match_size(int *typeclass_f, int *size, int *datatype_f, int *ierror)
{
    MPI_Datatype datatype = MPI_DATATYPE_NULL;
    *ierror = MPI_Type_match_size(VAPAA_MPI_TYPECLASS_F2C(*typeclass_f), *size, &datatype);
    *datatype_f = C_MPI_TYPE_TOINT(datatype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_value_index(int *value_type_f, int *index_type_f, int *pair_type_f, int *ierror)
{
    MPI_Datatype pair_type = MPI_DATATYPE_NULL;
    MPI_Datatype value_type = C_MPI_TYPE_FROMINT(*value_type_f);
    MPI_Datatype index_type = C_MPI_TYPE_FROMINT(*index_type_f);
#if MPI_VERSION >= 4
    *ierror = MPI_Type_get_value_index(value_type, index_type, &pair_type);
#else
    (void) value_type;
    (void) index_type;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    VAPAA_MPI_handle_synthetic_error_no_object(ierror);
#endif
    *pair_type_f = C_MPI_TYPE_TOINT(pair_type);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_delete_attr(int *datatype_f, int *keyval, int *ierror)
{
    void *attrval = NULL;
    int flag = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    (void) MPI_Type_get_attr(datatype, *keyval, &attrval, &flag);
    *ierror = MPI_Type_delete_attr(datatype, *keyval);
    if (*ierror == MPI_SUCCESS && flag) {
        VAPAA_MPI_Attr_forget(attrval);
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_free_keyval(int *keyval, int *ierror)
{
    *ierror = MPI_Type_free_keyval(keyval);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_attr(int *datatype_f, int *keyval, intptr_t *attrval_f, int *flag, int *ierror)
{
    void *attrval = NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_Type_get_attr(datatype, *keyval, &attrval, flag);
    if (*ierror == MPI_SUCCESS && *flag && VAPAA_MPI_Attr_load_aint(attrval, attrval_f)) {
        /* Fortran-set attributes are stored as C-visible integer storage. */
    } else {
        *attrval_f = (intptr_t) attrval;
    }
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_set_attr(int *datatype_f, int *keyval, intptr_t *attrval_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_Type_set_attr(datatype, *keyval, VAPAA_MPI_Attr_store_aint(*attrval_f));
    C_MPI_RC_FIX(*ierror);
}
