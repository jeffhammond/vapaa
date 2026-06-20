// SPDX-License-Identifier: MIT

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <limits.h>
#include <stdint.h>
#include <wchar.h>

#include <mpi.h>

#include "cfi_util.h"
#include "debug.h"
#include "detect_sentinels.h"

#define MAYBE_UNUSED __attribute__((unused))

#if defined(MPICH) && defined(MPICH_NUMVERSION) && (MPICH_NUMVERSION > 40200000)
#define VAPAA_HAVE_MPIX_IOV 1
#else
#define VAPAA_HAVE_MPIX_IOV 0
#endif

static bool VAPAA_CFI_IS_OPAQUE_STRUCT_DESC(const CFI_cdesc_t *desc)
{
#ifdef CFI_type_struct
    return desc != NULL && desc->type == CFI_type_struct;
#else
    (void) desc;
    return false;
#endif
}

static bool VAPAA_CFI_HAS_ELEMENT_METADATA(const CFI_cdesc_t *desc)
{
    if (desc == NULL || desc->elem_len == 0 || desc->type == 0) {
        return false;
    }
    if (VAPAA_CFI_IS_OPAQUE_STRUCT_DESC(desc)) {
        return false;
    }
#ifdef CFI_type_other
    if (desc->type == CFI_type_other) {
        return false;
    }
#endif
    return true;
}

static bool VAPAA_CFI_HAS_FORWARDED_ONE_LOWER_BOUNDS(const CFI_cdesc_t *desc)
{
    if (!VAPAA_CFI_IS_OPAQUE_STRUCT_DESC(desc) || desc->rank == 0) {
        return false;
    }

    for (CFI_rank_t i = 0; i < desc->rank; i++) {
        if (desc->dim[i].lower_bound != 1) {
            return false;
        }
    }

    return true;
}

static ssize_t VAPAA_CFI_GET_TOTAL_ELEMENTS(const CFI_cdesc_t * desc)
{
    const int rank = desc->rank;
    ssize_t total_elems = 1;
    for (CFI_rank_t i=0; i < rank; i++) {
        const ssize_t extent = desc->dim[i].extent;
        total_elems *= extent;
    }
    return total_elems;
}

static int VAPAA_CFI_ASSERT_ZERO_LOWER_BOUNDS(const CFI_cdesc_t *desc)
{
    if (VAPAA_CFI_HAS_FORWARDED_ONE_LOWER_BOUNDS(desc)) {
        return MPI_SUCCESS;
    }

    for (CFI_rank_t i = 0; i < desc->rank; i++) {
        if (desc->dim[i].lower_bound != 0) {
            VAPAA_Warning("non-zero CFI lower bound (%zd) in dimension %d is not supported.\n",
                          desc->dim[i].lower_bound, (int)i);
            VAPAA_Assert_msg(desc->dim[i].lower_bound == 0,
                             "non-zero CFI lower bounds are not supported");
            return MPI_ERR_ARG;
        }
    }
    return MPI_SUCCESS;
}

static bool VAPAA_MPI_DATATYPE_IS_BUILTIN(MPI_Datatype t)
{
    int ni, na, nd, c;
    int rc = PMPI_Type_get_envelope(t, &ni, &na, &nd, &c);
    VAPAA_Assert(rc == MPI_SUCCESS);
    return (c == MPI_COMBINER_NAMED);
}

static bool VAPAA_CFI_WARN_BUILTIN_DATATYPE_MISMATCH = true;
static bool VAPAA_CFI_CHECK_USER_DATATYPE_MISMATCH = false;
static int VAPAA_CFI_FORTRAN_LOGICAL_SIZE = sizeof(bool);
static int VAPAA_CFI_FORTRAN_INTEGER_SIZE = sizeof(int);
static int VAPAA_CFI_FORTRAN_REAL_SIZE = sizeof(float);
static int VAPAA_CFI_FORTRAN_DOUBLE_PRECISION_SIZE = sizeof(double);

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

    return default_value;
}

void VAPAA_CFI_DATATYPE_DIAGNOSTICS_INIT(void)
{
    VAPAA_CFI_WARN_BUILTIN_DATATYPE_MISMATCH =
        VAPAA_ENV_BOOL("VAPAA_WARN_CFI_DATATYPE_MISMATCH", true);
    VAPAA_CFI_CHECK_USER_DATATYPE_MISMATCH =
        VAPAA_ENV_BOOL("VAPAA_CHECK_CFI_USER_DATATYPE_MISMATCH", false);
}

void VAPAA_CFI_SET_FORTRAN_TYPE_SIZES(int logical_size, int integer_size,
                                      int real_size, int double_precision_size)
{
    if (logical_size > 0) {
        VAPAA_CFI_FORTRAN_LOGICAL_SIZE = logical_size;
    }
    if (integer_size > 0) {
        VAPAA_CFI_FORTRAN_INTEGER_SIZE = integer_size;
    }
    if (real_size > 0) {
        VAPAA_CFI_FORTRAN_REAL_SIZE = real_size;
    }
    if (double_precision_size > 0) {
        VAPAA_CFI_FORTRAN_DOUBLE_PRECISION_SIZE = double_precision_size;
    }
}

#if 0
static bool VAPAA_MPI_DATATYPE_IS_CONTIGUOUS(MPI_Datatype t)
{
    int rc, type_size;
    MPI_Aint lb, extent;
    rc = PMPI_Type_size(t, &type_size);
    VAPAA_Assert(rc == MPI_SUCCESS);
    rc = PMPI_Type_get_extent(t, &lb, &extent);
    VAPAA_Assert(rc == MPI_SUCCESS);
    return (type_size == extent);
}
#endif

typedef struct {
    VAPAA_Iov *iov;
    size_t len;
    size_t cap;
} VAPAA_Iov_list;

typedef struct {
    MPI_Count ni;
    MPI_Count na;
    MPI_Count nl;
    MPI_Count nd;
    int combiner;
    int *ints;
    MPI_Aint *addrs;
    MPI_Count *counts;
    MPI_Datatype *types;
} VAPAA_Datatype_contents;

static int VAPAA_COUNT_TO_SIZE(MPI_Count count, size_t *size)
{
    if (count < 0 || (uint64_t) count > (uint64_t) SIZE_MAX) {
        return MPI_ERR_COUNT;
    }
    *size = (size_t) count;
    return MPI_SUCCESS;
}

static int VAPAA_CALLOC_COUNT(MPI_Count count, size_t elem_size, void **ptr)
{
    size_t n = 0;
    int rc = VAPAA_COUNT_TO_SIZE(count, &n);
    if (rc != MPI_SUCCESS) {
        return rc;
    }
    if (n == 0) {
        *ptr = NULL;
        return MPI_SUCCESS;
    }
    if (n > SIZE_MAX / elem_size) {
        return MPI_ERR_NO_MEM;
    }
    *ptr = calloc(n, elem_size);
    return (*ptr == NULL) ? MPI_ERR_NO_MEM : MPI_SUCCESS;
}

static int VAPAA_IOV_RESERVE(VAPAA_Iov_list *list, size_t needed)
{
    if (needed <= list->cap) {
        return MPI_SUCCESS;
    }

    size_t cap = (list->cap == 0) ? 16 : list->cap;
    while (cap < needed) {
        if (cap > SIZE_MAX / 2) {
            return MPI_ERR_NO_MEM;
        }
        cap *= 2;
    }

    VAPAA_Iov *iov = realloc(list->iov, cap * sizeof(*iov));
    if (iov == NULL) {
        return MPI_ERR_NO_MEM;
    }
    list->iov = iov;
    list->cap = cap;
    return MPI_SUCCESS;
}

static int VAPAA_IOV_APPEND(VAPAA_Iov_list *list, MPI_Aint base, MPI_Aint len)
{
    if (len == 0) {
        return MPI_SUCCESS;
    }
    if (len < 0) {
        return MPI_ERR_ARG;
    }

    if (list->len > 0) {
        VAPAA_Iov *last = &list->iov[list->len - 1];
        if (last->iov_base + last->iov_len == base) {
            last->iov_len += len;
            return MPI_SUCCESS;
        }
    }

    int rc = VAPAA_IOV_RESERVE(list, list->len + 1);
    if (rc != MPI_SUCCESS) {
        return rc;
    }
    list->iov[list->len].iov_base = base;
    list->iov[list->len].iov_len = len;
    list->len++;
    return MPI_SUCCESS;
}

static int VAPAA_IOV_APPEND_SHIFTED(VAPAA_Iov_list *out, const VAPAA_Iov_list *in, MPI_Aint shift)
{
    for (size_t i = 0; i < in->len; i++) {
        int rc = VAPAA_IOV_APPEND(out, in->iov[i].iov_base + shift, in->iov[i].iov_len);
        if (rc != MPI_SUCCESS) {
            return rc;
        }
    }
    return MPI_SUCCESS;
}

static void VAPAA_IOV_FREE(VAPAA_Iov_list *list)
{
    free(list->iov);
    list->iov = NULL;
    list->len = 0;
    list->cap = 0;
}

static int VAPAA_CREATE_STANDARD_IOV(MPI_Datatype dt, VAPAA_Iov **iov,
                                     size_t *actual_iov_len, size_t *actual_iov_bytes);
int VAPAA_CREATE_DATATYPE_IOV(MPI_Datatype dt, VAPAA_Iov **iov,
                              size_t *actual_iov_len, size_t *actual_iov_bytes);

typedef enum {
    VAPAA_CFI_CATEGORY_UNKNOWN = 0,
    VAPAA_CFI_CATEGORY_INTEGER,
    VAPAA_CFI_CATEGORY_LOGICAL,
    VAPAA_CFI_CATEGORY_REAL,
    VAPAA_CFI_CATEGORY_COMPLEX,
    VAPAA_CFI_CATEGORY_CHARACTER,
    VAPAA_CFI_CATEGORY_INTEGER_OR_LOGICAL
} VAPAA_Cfi_category;

static bool VAPAA_CFI_TYPE_IS_FLAT_INTEGER(CFI_type_t type)
{
#ifdef CFI_type_signed_char
    if (type == CFI_type_signed_char) return true;
#endif
#ifdef CFI_type_short
    if (type == CFI_type_short) return true;
#endif
#ifdef CFI_type_int
    if (type == CFI_type_int) return true;
#endif
#ifdef CFI_type_long
    if (type == CFI_type_long) return true;
#endif
#ifdef CFI_type_long_long
    if (type == CFI_type_long_long) return true;
#endif
#ifdef CFI_type_size_t
    if (type == CFI_type_size_t) return true;
#endif
#ifdef CFI_type_int8_t
    if (type == CFI_type_int8_t) return true;
#endif
#ifdef CFI_type_int16_t
    if (type == CFI_type_int16_t) return true;
#endif
#ifdef CFI_type_int32_t
    if (type == CFI_type_int32_t) return true;
#endif
#ifdef CFI_type_int64_t
    if (type == CFI_type_int64_t) return true;
#endif
#ifdef CFI_type_int128_t
    if (type == CFI_type_int128_t) return true;
#endif
#ifdef CFI_type_int_least8_t
    if (type == CFI_type_int_least8_t) return true;
#endif
#ifdef CFI_type_int_least16_t
    if (type == CFI_type_int_least16_t) return true;
#endif
#ifdef CFI_type_int_least32_t
    if (type == CFI_type_int_least32_t) return true;
#endif
#ifdef CFI_type_int_least64_t
    if (type == CFI_type_int_least64_t) return true;
#endif
#ifdef CFI_type_int_least128_t
    if (type == CFI_type_int_least128_t) return true;
#endif
#ifdef CFI_type_int_fast8_t
    if (type == CFI_type_int_fast8_t) return true;
#endif
#ifdef CFI_type_int_fast16_t
    if (type == CFI_type_int_fast16_t) return true;
#endif
#ifdef CFI_type_int_fast32_t
    if (type == CFI_type_int_fast32_t) return true;
#endif
#ifdef CFI_type_int_fast64_t
    if (type == CFI_type_int_fast64_t) return true;
#endif
#ifdef CFI_type_int_fast128_t
    if (type == CFI_type_int_fast128_t) return true;
#endif
#ifdef CFI_type_intmax_t
    if (type == CFI_type_intmax_t) return true;
#endif
#ifdef CFI_type_intptr_t
    if (type == CFI_type_intptr_t) return true;
#endif
#ifdef CFI_type_ptrdiff_t
    if (type == CFI_type_ptrdiff_t) return true;
#endif
    return false;
}

static bool VAPAA_CFI_TYPE_IS_FLAT_REAL(CFI_type_t type)
{
#ifdef CFI_type_half_float
    if (type == CFI_type_half_float) return true;
#endif
#ifdef CFI_type_bfloat
    if (type == CFI_type_bfloat) return true;
#endif
#ifdef CFI_type_float
    if (type == CFI_type_float) return true;
#endif
#ifdef CFI_type_double
    if (type == CFI_type_double) return true;
#endif
#ifdef CFI_type_extended_double
    if (type == CFI_type_extended_double) return true;
#endif
#ifdef CFI_type_long_double
    if (type == CFI_type_long_double) return true;
#endif
#ifdef CFI_type_float128
    if (type == CFI_type_float128) return true;
#endif
    return false;
}

static bool VAPAA_CFI_TYPE_IS_FLAT_COMPLEX(CFI_type_t type)
{
#ifdef CFI_type_half_float_Complex
    if (type == CFI_type_half_float_Complex) return true;
#endif
#ifdef CFI_type_bfloat_Complex
    if (type == CFI_type_bfloat_Complex) return true;
#endif
#ifdef CFI_type_float_Complex
    if (type == CFI_type_float_Complex) return true;
#endif
#ifdef CFI_type_double_Complex
    if (type == CFI_type_double_Complex) return true;
#endif
#ifdef CFI_type_extended_double_Complex
    if (type == CFI_type_extended_double_Complex) return true;
#endif
#ifdef CFI_type_long_double_Complex
    if (type == CFI_type_long_double_Complex) return true;
#endif
#ifdef CFI_type_float128_Complex
    if (type == CFI_type_float128_Complex) return true;
#endif
    return false;
}

static bool VAPAA_CFI_TYPE_IS_FLAT_CHARACTER(CFI_type_t type)
{
#ifdef CFI_type_char
    if (type == CFI_type_char) return true;
#endif
#ifdef CFI_type_ucs4_char
    if (type == CFI_type_ucs4_char) return true;
#endif
#ifdef CFI_type_char16_t
    if (type == CFI_type_char16_t) return true;
#endif
#ifdef CFI_type_char32_t
    if (type == CFI_type_char32_t) return true;
#endif
    return false;
}

static VAPAA_Cfi_category VAPAA_CFI_GET_CATEGORY(CFI_type_t type)
{
#if defined(CFI_type_mask) && defined(CFI_type_Integer) && \
    defined(CFI_type_Logical) && defined(CFI_type_Real) && \
    defined(CFI_type_Complex) && defined(CFI_type_Character)
    int category = (int)(type & CFI_type_mask);
    if (category == CFI_type_Integer) return VAPAA_CFI_CATEGORY_INTEGER;
    if (category == CFI_type_Logical) return VAPAA_CFI_CATEGORY_LOGICAL;
    if (category == CFI_type_Real) return VAPAA_CFI_CATEGORY_REAL;
    if (category == CFI_type_Complex) return VAPAA_CFI_CATEGORY_COMPLEX;
    if (category == CFI_type_Character) return VAPAA_CFI_CATEGORY_CHARACTER;
#endif

#ifdef CFI_type_Bool
    if (type == CFI_type_Bool) return VAPAA_CFI_CATEGORY_LOGICAL;
#endif
    if (VAPAA_CFI_TYPE_IS_FLAT_CHARACTER(type)) return VAPAA_CFI_CATEGORY_CHARACTER;
    if (VAPAA_CFI_TYPE_IS_FLAT_INTEGER(type)) return VAPAA_CFI_CATEGORY_INTEGER_OR_LOGICAL;
    if (VAPAA_CFI_TYPE_IS_FLAT_REAL(type)) return VAPAA_CFI_CATEGORY_REAL;
    if (VAPAA_CFI_TYPE_IS_FLAT_COMPLEX(type)) return VAPAA_CFI_CATEGORY_COMPLEX;
    return VAPAA_CFI_CATEGORY_UNKNOWN;
}

static bool VAPAA_CFI_CATEGORY_CAN_BE_INTEGER(VAPAA_Cfi_category category)
{
    return category == VAPAA_CFI_CATEGORY_INTEGER ||
           category == VAPAA_CFI_CATEGORY_INTEGER_OR_LOGICAL;
}

static bool VAPAA_CFI_CATEGORY_CAN_BE_LOGICAL(VAPAA_Cfi_category category)
{
    return category == VAPAA_CFI_CATEGORY_LOGICAL ||
           category == VAPAA_CFI_CATEGORY_INTEGER_OR_LOGICAL;
}

static void VAPAA_CFI_GET_TYPE_NAME(CFI_type_t type, char * name)
{
         if (type==CFI_type_signed_char)          snprintf(name,32,"%s", "signed char");
    else if (type==CFI_type_short)                snprintf(name,32,"%s", "short");
    else if (type==CFI_type_int)                  snprintf(name,32,"%s", "int");
    else if (type==CFI_type_long)                 snprintf(name,32,"%s", "long");
    else if (type==CFI_type_long_long)            snprintf(name,32,"%s", "long long");
    else if (type==CFI_type_size_t)               snprintf(name,32,"%s", "size_t");
    else if (type==CFI_type_int8_t)               snprintf(name,32,"%s", "int8_t");
    else if (type==CFI_type_int16_t)              snprintf(name,32,"%s", "int16_t");
    else if (type==CFI_type_int32_t)              snprintf(name,32,"%s", "int32_t");
    else if (type==CFI_type_int64_t)              snprintf(name,32,"%s", "int64_t");
#if 0
    // not supported by NAGFOR and probably unnecessary anyways
    else if (type==CFI_type_int_least8_t)         snprintf(name,32,"%s", "int_least8_t");
    else if (type==CFI_type_int_least16_t)        snprintf(name,32,"%s", "int_least16_t");
    else if (type==CFI_type_int_least32_t)        snprintf(name,32,"%s", "int_least32_t");
    else if (type==CFI_type_int_least64_t)        snprintf(name,32,"%s", "int_least64_t");
    else if (type==CFI_type_int_fast8_t)          snprintf(name,32,"%s", "int_fast8_t");
    else if (type==CFI_type_int_fast16_t)         snprintf(name,32,"%s", "int_fast16_t");
    else if (type==CFI_type_int_fast32_t)         snprintf(name,32,"%s", "int_fast32_t");
    else if (type==CFI_type_int_fast64_t)         snprintf(name,32,"%s", "int_fast64_t");
#endif
    else if (type==CFI_type_intmax_t)             snprintf(name,32,"%s", "intmax_t");
    else if (type==CFI_type_intptr_t)             snprintf(name,32,"%s", "intptr_t");
    else if (type==CFI_type_ptrdiff_t)            snprintf(name,32,"%s", "ptrdiff_t");
    else if (type==CFI_type_float)                snprintf(name,32,"%s", "float");
    else if (type==CFI_type_double)               snprintf(name,32,"%s", "double");
    else if (type==CFI_type_long_double)          snprintf(name,32,"%s", "long double");
    else if (type==CFI_type_float_Complex)        snprintf(name,32,"%s", "float _Complex");
    else if (type==CFI_type_double_Complex)       snprintf(name,32,"%s", "double _Complex");
    else if (type==CFI_type_long_double_Complex)  snprintf(name,32,"%s", "long double _Complex");
    else if (type==CFI_type_Bool)                 snprintf(name,32,"%s", "Bool");
    else if (type==CFI_type_char)                 snprintf(name,32,"%s", "char");
    else if (type==CFI_type_cptr)                 snprintf(name,32,"%s", "cptr");
#if 0
    // not in F2023
    else if (type==CFI_type_cfunptr)              snprintf(name,32,"%s", "cfunptr");
#endif
    else if (type==CFI_type_struct)               snprintf(name,32,"%s", "struct");
    else if (type==CFI_type_other)                snprintf(name,32,"%s", "other");
#if defined(CFI_type_mask) && defined(CFI_type_kind_shift) && \
    defined(CFI_type_Integer) && defined(CFI_type_Logical) && \
    defined(CFI_type_Real) && defined(CFI_type_Complex) && \
    defined(CFI_type_Character)
    else if ((type & CFI_type_mask)==CFI_type_Integer)
                                                       snprintf(name,32,"integer(kind=%d)", (int)(type >> CFI_type_kind_shift));
    else if ((type & CFI_type_mask)==CFI_type_Logical)
                                                       snprintf(name,32,"logical(kind=%d)", (int)(type >> CFI_type_kind_shift));
    else if ((type & CFI_type_mask)==CFI_type_Real)
                                                       snprintf(name,32,"real(kind=%d)", (int)(type >> CFI_type_kind_shift));
    else if ((type & CFI_type_mask)==CFI_type_Complex)
                                                       snprintf(name,32,"complex(kind=%d)", (int)(type >> CFI_type_kind_shift));
    else if ((type & CFI_type_mask)==CFI_type_Character)
                                                       snprintf(name,32,"character(kind=%d)", (int)(type >> CFI_type_kind_shift));
#endif
    else                                          snprintf(name,32,"unknown (%8d)", (int)type);
}

MAYBE_UNUSED
static int VAPAA_MPIDT_PRINT_INFO(MPI_Datatype dt)
{
    size_t actual_iov_len = 0;
    size_t total_bytes = 0;
    VAPAA_Iov *iov = NULL;
    int rc = VAPAA_CREATE_DATATYPE_IOV(dt, &iov, &actual_iov_len, &total_bytes);
    if (rc != MPI_SUCCESS) {
        return rc;
    }

    for (size_t i=0; i < actual_iov_len; i++) {
        printf("iov[%zu] = { .iov_base = %zd .iov_len = %zd }\n",
               i, (ptrdiff_t) iov[i].iov_base, (ptrdiff_t) iov[i].iov_len);
    }
    free(iov);

    return MPI_SUCCESS;
}

static MPI_Datatype VAPAA_CFI_TO_MPI_TYPE(CFI_type_t type)
{
         if (type==CFI_type_char)                 return MPI_CHAR;
    else if (type==CFI_type_signed_char)          return MPI_SIGNED_CHAR;
    else if (type==CFI_type_int8_t)               return MPI_INT8_T;
    else if (type==CFI_type_int16_t)              return MPI_INT16_T;
    else if (type==CFI_type_int32_t)              return MPI_INT32_T;
    else if (type==CFI_type_int64_t)              return MPI_INT64_T;
    else if (type==CFI_type_short)                return MPI_SHORT;
    else if (type==CFI_type_int)                  return MPI_INT;
    else if (type==CFI_type_long)                 return MPI_LONG;
    else if (type==CFI_type_long_long)            return MPI_LONG_LONG_INT;
    else if (type==CFI_type_Bool)                 return MPI_C_BOOL;
    else if (type==CFI_type_float)                return MPI_FLOAT;
    else if (type==CFI_type_double)               return MPI_DOUBLE;
    else if (type==CFI_type_long_double)          return MPI_LONG_DOUBLE;
    else if (type==CFI_type_float_Complex)        return MPI_C_FLOAT_COMPLEX;
    else if (type==CFI_type_double_Complex)       return MPI_C_DOUBLE_COMPLEX;
    else if (type==CFI_type_long_double_Complex)  return MPI_C_LONG_DOUBLE_COMPLEX;
    else {
        char name[33] = {0};
        VAPAA_CFI_GET_TYPE_NAME(type, name);
        VAPAA_Warning("Unknown CFI type = %s (%d)\n", name, type);
        return MPI_DATATYPE_NULL;
    }
}

static void VAPAA_CFI_GET_TYPE_ATTRIBUTE(CFI_attribute_t attribute, char * name)
{
         if (attribute==CFI_attribute_pointer)     snprintf(name,32,"%s", "data pointer");
    else if (attribute==CFI_attribute_allocatable) snprintf(name,32,"%s", "allocatable");
    else if (attribute==CFI_attribute_other)       snprintf(name,32,"%s", "nonallocatable nonpointer");
    else                                           snprintf(name,32,"%s", "unknown CFI type attribute");

}

static int VAPAA_MPI_COUNT_TO_AINT(MPI_Count in, MPI_Aint *out)
{
    MPI_Aint tmp = (MPI_Aint) in;
    if ((MPI_Count) tmp != in) {
        return MPI_ERR_COUNT;
    }
    *out = tmp;
    return MPI_SUCCESS;
}

static int VAPAA_DTYPE_GET_EXTENT(MPI_Datatype datatype, MPI_Aint *extent)
{
    MPI_Aint lb = 0;
    int rc = PMPI_Type_get_extent(datatype, &lb, extent);
    (void) lb;
    return rc;
}

static int VAPAA_DTYPE_GET_SIZE(MPI_Datatype datatype, MPI_Aint *size)
{
#if MPI_VERSION >= 3
    MPI_Count count_size = 0;
    int rc = PMPI_Type_size_x(datatype, &count_size);
    if (rc != MPI_SUCCESS) {
        return rc;
    }
    return VAPAA_MPI_COUNT_TO_AINT(count_size, size);
#else
    int int_size = 0;
    int rc = PMPI_Type_size(datatype, &int_size);
    if (rc != MPI_SUCCESS) {
        return rc;
    }
    *size = int_size;
    return MPI_SUCCESS;
#endif
}

static int VAPAA_DTYPE_GET_CONTENTS(MPI_Datatype datatype, VAPAA_Datatype_contents *contents)
{
    memset(contents, 0, sizeof(*contents));

#if MPI_VERSION >= 4
    int rc = PMPI_Type_get_envelope_c(datatype, &contents->ni, &contents->na,
                                      &contents->nl, &contents->nd, &contents->combiner);
#else
    int ni = 0;
    int na = 0;
    int nd = 0;
    int rc = PMPI_Type_get_envelope(datatype, &ni, &na, &nd, &contents->combiner);
    contents->ni = ni;
    contents->na = na;
    contents->nd = nd;
#endif
    if (rc != MPI_SUCCESS || contents->combiner == MPI_COMBINER_NAMED) {
        return rc;
    }

    rc = VAPAA_CALLOC_COUNT(contents->ni, sizeof(*contents->ints), (void **) &contents->ints);
    if (rc != MPI_SUCCESS) {
        return rc;
    }
    rc = VAPAA_CALLOC_COUNT(contents->na, sizeof(*contents->addrs), (void **) &contents->addrs);
    if (rc != MPI_SUCCESS) {
        return rc;
    }
    rc = VAPAA_CALLOC_COUNT(contents->nl, sizeof(*contents->counts), (void **) &contents->counts);
    if (rc != MPI_SUCCESS) {
        return rc;
    }
    rc = VAPAA_CALLOC_COUNT(contents->nd, sizeof(*contents->types), (void **) &contents->types);
    if (rc != MPI_SUCCESS) {
        return rc;
    }

#if MPI_VERSION >= 4
    rc = PMPI_Type_get_contents_c(datatype, contents->ni, contents->na, contents->nl, contents->nd,
                                  contents->ints, contents->addrs, contents->counts, contents->types);
#else
    rc = PMPI_Type_get_contents(datatype, (int) contents->ni, (int) contents->na, (int) contents->nd,
                                contents->ints, contents->addrs, contents->types);
#endif
    return rc;
}

static void VAPAA_DTYPE_CONTENTS_RELEASE(VAPAA_Datatype_contents *contents)
{
    if (contents->types != NULL) {
        for (MPI_Count i = 0; i < contents->nd; i++) {
            if (contents->types[i] != MPI_DATATYPE_NULL &&
                !VAPAA_MPI_DATATYPE_IS_BUILTIN(contents->types[i])) {
                MPI_Datatype type = contents->types[i];
                int rc = PMPI_Type_free(&type);
                VAPAA_Assert(rc == MPI_SUCCESS);
            }
        }
    }
    free(contents->ints);
    free(contents->addrs);
    free(contents->counts);
    free(contents->types);
    memset(contents, 0, sizeof(*contents));
}

static bool VAPAA_CFI_MPI_TYPE_SIZE_MATCHES(MPI_Datatype datatype, size_t bytes)
{
    MPI_Aint datatype_size = 0;
    int rc = VAPAA_DTYPE_GET_SIZE(datatype, &datatype_size);
    return (rc == MPI_SUCCESS && datatype_size >= 0 && (size_t) datatype_size == bytes);
}

static bool VAPAA_CFI_DT_IS(MPI_Datatype datatype, MPI_Datatype candidate)
{
    return datatype == candidate;
}

static const char *VAPAA_CFI_MPI_DATATYPE_NAME(MPI_Datatype datatype)
{
#define VAPAA_CFI_DT_NAME(dt_) \
    if (datatype == (dt_)) { return #dt_; }

    VAPAA_CFI_DT_NAME(MPI_CHARACTER)
    VAPAA_CFI_DT_NAME(MPI_LOGICAL)
    VAPAA_CFI_DT_NAME(MPI_INTEGER)
    VAPAA_CFI_DT_NAME(MPI_REAL)
    VAPAA_CFI_DT_NAME(MPI_DOUBLE_PRECISION)
    VAPAA_CFI_DT_NAME(MPI_COMPLEX)
    VAPAA_CFI_DT_NAME(MPI_DOUBLE_COMPLEX)
    VAPAA_CFI_DT_NAME(MPI_INTEGER1)
    VAPAA_CFI_DT_NAME(MPI_INTEGER2)
    VAPAA_CFI_DT_NAME(MPI_INTEGER4)
    VAPAA_CFI_DT_NAME(MPI_INTEGER8)
#ifdef HAVE_MPI_INTEGER16
    VAPAA_CFI_DT_NAME(MPI_INTEGER16)
#endif
#ifdef HAVE_MPI_REAL2
    VAPAA_CFI_DT_NAME(MPI_REAL2)
#endif
    VAPAA_CFI_DT_NAME(MPI_REAL4)
    VAPAA_CFI_DT_NAME(MPI_REAL8)
#ifdef HAVE_MPI_REAL16
    VAPAA_CFI_DT_NAME(MPI_REAL16)
#endif
#ifdef HAVE_MPI_COMPLEX4
    VAPAA_CFI_DT_NAME(MPI_COMPLEX4)
#endif
    VAPAA_CFI_DT_NAME(MPI_COMPLEX8)
    VAPAA_CFI_DT_NAME(MPI_COMPLEX16)
#ifdef HAVE_MPI_COMPLEX32
    VAPAA_CFI_DT_NAME(MPI_COMPLEX32)
#endif
    VAPAA_CFI_DT_NAME(MPI_AINT)
    VAPAA_CFI_DT_NAME(MPI_COUNT)
    VAPAA_CFI_DT_NAME(MPI_OFFSET)
    VAPAA_CFI_DT_NAME(MPI_PACKED)
    VAPAA_CFI_DT_NAME(MPI_BYTE)
    VAPAA_CFI_DT_NAME(MPI_CHAR)
    VAPAA_CFI_DT_NAME(MPI_SIGNED_CHAR)
    VAPAA_CFI_DT_NAME(MPI_WCHAR)
    VAPAA_CFI_DT_NAME(MPI_SHORT)
    VAPAA_CFI_DT_NAME(MPI_INT)
    VAPAA_CFI_DT_NAME(MPI_LONG)
#ifdef MPI_LONG_LONG
    VAPAA_CFI_DT_NAME(MPI_LONG_LONG)
#endif
    VAPAA_CFI_DT_NAME(MPI_LONG_LONG_INT)
    VAPAA_CFI_DT_NAME(MPI_FLOAT)
    VAPAA_CFI_DT_NAME(MPI_DOUBLE)
    VAPAA_CFI_DT_NAME(MPI_LONG_DOUBLE)
    VAPAA_CFI_DT_NAME(MPI_C_BOOL)
    VAPAA_CFI_DT_NAME(MPI_INT8_T)
    VAPAA_CFI_DT_NAME(MPI_INT16_T)
    VAPAA_CFI_DT_NAME(MPI_INT32_T)
    VAPAA_CFI_DT_NAME(MPI_INT64_T)
    VAPAA_CFI_DT_NAME(MPI_C_COMPLEX)
    VAPAA_CFI_DT_NAME(MPI_C_FLOAT_COMPLEX)
    VAPAA_CFI_DT_NAME(MPI_C_DOUBLE_COMPLEX)
    VAPAA_CFI_DT_NAME(MPI_C_LONG_DOUBLE_COMPLEX)
    VAPAA_CFI_DT_NAME(MPI_FLOAT_INT)
    VAPAA_CFI_DT_NAME(MPI_DOUBLE_INT)
    VAPAA_CFI_DT_NAME(MPI_LONG_INT)
    VAPAA_CFI_DT_NAME(MPI_2INT)
    VAPAA_CFI_DT_NAME(MPI_SHORT_INT)
    VAPAA_CFI_DT_NAME(MPI_LONG_DOUBLE_INT)
    VAPAA_CFI_DT_NAME(MPI_2REAL)
    VAPAA_CFI_DT_NAME(MPI_2DOUBLE_PRECISION)
    VAPAA_CFI_DT_NAME(MPI_2INTEGER)

#undef VAPAA_CFI_DT_NAME

    return "named MPI datatype";
}

static bool VAPAA_CFI_MATCH_INTEGER_DATATYPE(MPI_Datatype datatype, size_t bytes)
{
    if (bytes == (size_t) VAPAA_CFI_FORTRAN_INTEGER_SIZE &&
        VAPAA_CFI_DT_IS(datatype, MPI_INTEGER)) {
        return true;
    }
    if (bytes == 1 && VAPAA_CFI_DT_IS(datatype, MPI_INTEGER1)) {
        return true;
    }
    if (bytes == 2 && VAPAA_CFI_DT_IS(datatype, MPI_INTEGER2)) {
        return true;
    }
    if (bytes == 4 && VAPAA_CFI_DT_IS(datatype, MPI_INTEGER4)) {
        return true;
    }
    if (bytes == 8 && VAPAA_CFI_DT_IS(datatype, MPI_INTEGER8)) {
        return true;
    }
#ifdef HAVE_MPI_INTEGER16
    if (bytes == 16 && VAPAA_CFI_DT_IS(datatype, MPI_INTEGER16)) {
        return true;
    }
#endif
    if (bytes == sizeof(signed char) && VAPAA_CFI_DT_IS(datatype, MPI_SIGNED_CHAR)) {
        return true;
    }
    if (bytes == sizeof(short) && VAPAA_CFI_DT_IS(datatype, MPI_SHORT)) {
        return true;
    }
    if (bytes == sizeof(int) && VAPAA_CFI_DT_IS(datatype, MPI_INT)) {
        return true;
    }
    if (bytes == sizeof(long) && VAPAA_CFI_DT_IS(datatype, MPI_LONG)) {
        return true;
    }
    if (bytes == sizeof(long long) && VAPAA_CFI_DT_IS(datatype, MPI_LONG_LONG_INT)) {
        return true;
    }
#ifdef MPI_LONG_LONG
    if (bytes == sizeof(long long) && VAPAA_CFI_DT_IS(datatype, MPI_LONG_LONG)) {
        return true;
    }
#endif
    if (bytes == sizeof(int8_t) && VAPAA_CFI_DT_IS(datatype, MPI_INT8_T)) {
        return true;
    }
    if (bytes == sizeof(int16_t) && VAPAA_CFI_DT_IS(datatype, MPI_INT16_T)) {
        return true;
    }
    if (bytes == sizeof(int32_t) && VAPAA_CFI_DT_IS(datatype, MPI_INT32_T)) {
        return true;
    }
    if (bytes == sizeof(int64_t) && VAPAA_CFI_DT_IS(datatype, MPI_INT64_T)) {
        return true;
    }
    if (bytes == sizeof(MPI_Aint) && VAPAA_CFI_DT_IS(datatype, MPI_AINT)) {
        return true;
    }
    if (bytes == sizeof(MPI_Count) && VAPAA_CFI_DT_IS(datatype, MPI_COUNT)) {
        return true;
    }
    if (bytes == sizeof(MPI_Offset) && VAPAA_CFI_DT_IS(datatype, MPI_OFFSET)) {
        return true;
    }
    return false;
}

static bool VAPAA_CFI_MATCH_LOGICAL_DATATYPE(const CFI_cdesc_t *desc, MPI_Datatype datatype, size_t bytes)
{
    if (bytes == (size_t) VAPAA_CFI_FORTRAN_LOGICAL_SIZE &&
        VAPAA_CFI_DT_IS(datatype, MPI_LOGICAL)) {
        return true;
    }
    if (desc->type == CFI_type_Bool && bytes == sizeof(bool) &&
        VAPAA_CFI_DT_IS(datatype, MPI_C_BOOL)) {
        return true;
    }
    return false;
}

static bool VAPAA_CFI_MATCH_REAL_DATATYPE(MPI_Datatype datatype, size_t bytes)
{
    if (bytes == (size_t) VAPAA_CFI_FORTRAN_REAL_SIZE &&
        VAPAA_CFI_DT_IS(datatype, MPI_REAL)) {
        return true;
    }
    if (bytes == (size_t) VAPAA_CFI_FORTRAN_DOUBLE_PRECISION_SIZE &&
        VAPAA_CFI_DT_IS(datatype, MPI_DOUBLE_PRECISION)) {
        return true;
    }
#ifdef HAVE_MPI_REAL2
    if (bytes == 2 && VAPAA_CFI_DT_IS(datatype, MPI_REAL2)) {
        return true;
    }
#endif
    if (bytes == 4 && VAPAA_CFI_DT_IS(datatype, MPI_REAL4)) {
        return true;
    }
    if (bytes == 8 && VAPAA_CFI_DT_IS(datatype, MPI_REAL8)) {
        return true;
    }
#ifdef HAVE_MPI_REAL16
    if (bytes == 16 && VAPAA_CFI_DT_IS(datatype, MPI_REAL16)) {
        return true;
    }
#endif
    if (bytes == sizeof(float) && VAPAA_CFI_DT_IS(datatype, MPI_FLOAT)) {
        return true;
    }
    if (bytes == sizeof(double) && VAPAA_CFI_DT_IS(datatype, MPI_DOUBLE)) {
        return true;
    }
    if (bytes == sizeof(long double) && VAPAA_CFI_DT_IS(datatype, MPI_LONG_DOUBLE)) {
        return true;
    }
    return false;
}

static bool VAPAA_CFI_MATCH_COMPLEX_DATATYPE(MPI_Datatype datatype, size_t bytes)
{
    if (bytes == (size_t) (2 * VAPAA_CFI_FORTRAN_REAL_SIZE) &&
        VAPAA_CFI_DT_IS(datatype, MPI_COMPLEX)) {
        return true;
    }
    if (bytes == (size_t) (2 * VAPAA_CFI_FORTRAN_DOUBLE_PRECISION_SIZE) &&
        VAPAA_CFI_DT_IS(datatype, MPI_DOUBLE_COMPLEX)) {
        return true;
    }
#ifdef HAVE_MPI_COMPLEX4
    if (bytes == 4 && VAPAA_CFI_DT_IS(datatype, MPI_COMPLEX4)) {
        return true;
    }
#endif
    if (bytes == 8 && VAPAA_CFI_DT_IS(datatype, MPI_COMPLEX8)) {
        return true;
    }
    if (bytes == 16 && VAPAA_CFI_DT_IS(datatype, MPI_COMPLEX16)) {
        return true;
    }
#ifdef HAVE_MPI_COMPLEX32
    if (bytes == 32 && VAPAA_CFI_DT_IS(datatype, MPI_COMPLEX32)) {
        return true;
    }
#endif
    if (bytes == sizeof(float _Complex) && VAPAA_CFI_DT_IS(datatype, MPI_C_COMPLEX)) {
        return true;
    }
    if (bytes == sizeof(float _Complex) && VAPAA_CFI_DT_IS(datatype, MPI_C_FLOAT_COMPLEX)) {
        return true;
    }
    if (bytes == sizeof(double _Complex) && VAPAA_CFI_DT_IS(datatype, MPI_C_DOUBLE_COMPLEX)) {
        return true;
    }
    if (bytes == sizeof(long double _Complex) &&
        VAPAA_CFI_DT_IS(datatype, MPI_C_LONG_DOUBLE_COMPLEX)) {
        return true;
    }
    return false;
}

static bool VAPAA_CFI_MATCH_CHARACTER_DATATYPE(const CFI_cdesc_t *desc, MPI_Datatype datatype, size_t bytes)
{
    VAPAA_Cfi_category category = VAPAA_CFI_GET_CATEGORY(desc->type);
    if (category == VAPAA_CFI_CATEGORY_CHARACTER) {
        if (bytes >= 1 && (VAPAA_CFI_DT_IS(datatype, MPI_CHARACTER) ||
                           VAPAA_CFI_DT_IS(datatype, MPI_CHAR))) {
            return true;
        }
#ifdef CFI_type_ucs4_char
        if (desc->type == CFI_type_ucs4_char && bytes >= sizeof(wchar_t) &&
            bytes % sizeof(wchar_t) == 0 && VAPAA_CFI_DT_IS(datatype, MPI_WCHAR)) {
            return true;
        }
#endif
    }
    return false;
}

static bool VAPAA_CFI_MATCH_PAIR_DATATYPE(const CFI_cdesc_t *desc, MPI_Datatype datatype, size_t bytes)
{
    VAPAA_Cfi_category category = VAPAA_CFI_GET_CATEGORY(desc->type);
    if (VAPAA_CFI_CATEGORY_CAN_BE_INTEGER(category)) {
        if (bytes == (size_t) VAPAA_CFI_FORTRAN_INTEGER_SIZE &&
            VAPAA_CFI_DT_IS(datatype, MPI_2INTEGER)) {
            return true;
        }
        if (bytes == sizeof(int) && VAPAA_CFI_DT_IS(datatype, MPI_2INT)) {
            return true;
        }
    } else if (category == VAPAA_CFI_CATEGORY_REAL) {
        if (bytes == (size_t) VAPAA_CFI_FORTRAN_REAL_SIZE &&
            VAPAA_CFI_DT_IS(datatype, MPI_2REAL)) {
            return true;
        }
        if (bytes == (size_t) VAPAA_CFI_FORTRAN_DOUBLE_PRECISION_SIZE &&
            VAPAA_CFI_DT_IS(datatype, MPI_2DOUBLE_PRECISION)) {
            return true;
        }
    }
    return false;
}

static bool VAPAA_CFI_BUILTIN_DATATYPE_COMPATIBLE(const CFI_cdesc_t *desc, MPI_Datatype datatype)
{
    size_t bytes = desc->elem_len;
    VAPAA_Cfi_category category = VAPAA_CFI_GET_CATEGORY(desc->type);
    if (VAPAA_CFI_DT_IS(datatype, MPI_PACKED)) {
        return true;
    }
    if (VAPAA_CFI_MATCH_PAIR_DATATYPE(desc, datatype, bytes)) {
        return true;
    }
    if (category == VAPAA_CFI_CATEGORY_CHARACTER) {
        return VAPAA_CFI_MATCH_CHARACTER_DATATYPE(desc, datatype, bytes);
    }
    if (!VAPAA_CFI_MPI_TYPE_SIZE_MATCHES(datatype, bytes)) {
        return false;
    }

    if (category == VAPAA_CFI_CATEGORY_INTEGER_OR_LOGICAL) {
        return VAPAA_CFI_MATCH_INTEGER_DATATYPE(datatype, bytes) ||
               VAPAA_CFI_MATCH_LOGICAL_DATATYPE(desc, datatype, bytes);
    } else if (category == VAPAA_CFI_CATEGORY_INTEGER) {
        return VAPAA_CFI_MATCH_INTEGER_DATATYPE(datatype, bytes);
    } else if (VAPAA_CFI_CATEGORY_CAN_BE_LOGICAL(category)) {
        return VAPAA_CFI_MATCH_LOGICAL_DATATYPE(desc, datatype, bytes);
    } else if (category == VAPAA_CFI_CATEGORY_REAL) {
        return VAPAA_CFI_MATCH_REAL_DATATYPE(datatype, bytes);
    } else if (category == VAPAA_CFI_CATEGORY_COMPLEX) {
        return VAPAA_CFI_MATCH_COMPLEX_DATATYPE(datatype, bytes);
    }

    return false;
}

static bool VAPAA_CFI_USER_DATATYPE_COMPATIBLE(const CFI_cdesc_t *desc, MPI_Datatype datatype, int depth)
{
    if (depth > 64) {
        return false;
    }

    if (datatype == MPI_DATATYPE_NULL) {
        return false;
    }

    if (VAPAA_MPI_DATATYPE_IS_BUILTIN(datatype)) {
        return VAPAA_CFI_BUILTIN_DATATYPE_COMPATIBLE(desc, datatype);
    }

    VAPAA_Datatype_contents contents;
    int rc = VAPAA_DTYPE_GET_CONTENTS(datatype, &contents);
    if (rc != MPI_SUCCESS) {
        return false;
    }

    if (contents.nd == 0) {
        bool compatible = VAPAA_CFI_MPI_TYPE_SIZE_MATCHES(datatype, desc->elem_len);
        VAPAA_DTYPE_CONTENTS_RELEASE(&contents);
        return compatible;
    }

    bool compatible = true;
    for (MPI_Count i = 0; i < contents.nd; i++) {
        if (!VAPAA_CFI_USER_DATATYPE_COMPATIBLE(desc, contents.types[i], depth + 1)) {
            compatible = false;
            break;
        }
    }
    VAPAA_DTYPE_CONTENTS_RELEASE(&contents);
    return compatible;
}

void VAPAA_CFI_WARN_DATATYPE_MISMATCH(const CFI_cdesc_t *desc, MPI_Datatype datatype,
                                      const char *mpi_function)
{
    if (desc == NULL || datatype == MPI_DATATYPE_NULL) {
        return;
    }
    if (!VAPAA_CFI_HAS_ELEMENT_METADATA(desc)) {
        return;
    }
    if (C_IS_MPI_IN_PLACE(desc->base_addr) || C_IS_MPI_BOTTOM(desc->base_addr)) {
        return;
    }

    bool datatype_is_builtin = VAPAA_MPI_DATATYPE_IS_BUILTIN(datatype);
    if (datatype_is_builtin && !VAPAA_CFI_WARN_BUILTIN_DATATYPE_MISMATCH) {
        return;
    }
    if (!datatype_is_builtin && !VAPAA_CFI_CHECK_USER_DATATYPE_MISMATCH) {
        return;
    }

    bool compatible = datatype_is_builtin ?
        VAPAA_CFI_BUILTIN_DATATYPE_COMPATIBLE(desc, datatype) :
        VAPAA_CFI_USER_DATATYPE_COMPATIBLE(desc, datatype, 0);
    if (compatible) {
        return;
    }

    char cfi_name[33] = {0};
    VAPAA_CFI_GET_TYPE_NAME(desc->type, cfi_name);

    char mpi_name[MPI_MAX_OBJECT_NAME] = {0};
    int mpi_name_len = 0;
    if (datatype_is_builtin) {
        snprintf(mpi_name, sizeof(mpi_name), "%s", VAPAA_CFI_MPI_DATATYPE_NAME(datatype));
    } else {
        int rc = PMPI_Type_get_name(datatype, mpi_name, &mpi_name_len);
        if (rc != MPI_SUCCESS || mpi_name_len == 0) {
            snprintf(mpi_name, sizeof(mpi_name), "%s", "user-defined MPI datatype");
        }
    }

    VAPAA_Warning("%s: CFI element type %s (%zu bytes) does not match MPI datatype %s.\n",
                  mpi_function, cfi_name, desc->elem_len, mpi_name);
}

static MPI_Count VAPAA_CONTENT_ARG(const VAPAA_Datatype_contents *contents, MPI_Count i)
{
    return (contents->nl > 0) ? contents->counts[i] : (MPI_Count) contents->ints[i];
}

static int VAPAA_DTYPE_APPEND_REPEATED(VAPAA_Iov_list *out, const VAPAA_Iov_list *child,
                                       MPI_Count count, MPI_Count blocklength,
                                       MPI_Aint stride, MPI_Aint old_extent, MPI_Aint base)
{
    if (count < 0 || blocklength < 0) {
        return MPI_ERR_COUNT;
    }

    for (MPI_Count i = 0; i < count; i++) {
        for (MPI_Count j = 0; j < blocklength; j++) {
            MPI_Aint shift = base + (MPI_Aint) i * stride + (MPI_Aint) j * old_extent;
            int rc = VAPAA_IOV_APPEND_SHIFTED(out, child, shift);
            if (rc != MPI_SUCCESS) {
                return rc;
            }
        }
    }
    return MPI_SUCCESS;
}

static int VAPAA_DTYPE_FLATTEN_RECURSE(MPI_Datatype datatype, VAPAA_Iov_list *out, int depth);

static int VAPAA_DTYPE_FLATTEN_CHILD(MPI_Datatype datatype, VAPAA_Iov_list *child, int depth)
{
    memset(child, 0, sizeof(*child));
    return VAPAA_DTYPE_FLATTEN_RECURSE(datatype, child, depth + 1);
}

static int VAPAA_DTYPE_FLATTEN_SUBARRAY(const VAPAA_Datatype_contents *contents,
                                        VAPAA_Iov_list *out, int depth)
{
    int ndims = contents->ints[0];
    if (ndims < 0) {
        return MPI_ERR_DIMS;
    }

    int order = (contents->nl > 0) ? contents->ints[1] : contents->ints[1 + 3 * ndims];
    if (order != MPI_ORDER_FORTRAN && order != MPI_ORDER_C) {
        return MPI_ERR_ARG;
    }

    MPI_Count *sizes = NULL;
    MPI_Count *subsizes = NULL;
    MPI_Count *starts = NULL;
    MPI_Count *strides = NULL;
    MPI_Count *coords = NULL;
    int rc = VAPAA_CALLOC_COUNT(ndims, sizeof(*sizes), (void **) &sizes);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }
    rc = VAPAA_CALLOC_COUNT(ndims, sizeof(*subsizes), (void **) &subsizes);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }
    rc = VAPAA_CALLOC_COUNT(ndims, sizeof(*starts), (void **) &starts);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }
    rc = VAPAA_CALLOC_COUNT(ndims, sizeof(*strides), (void **) &strides);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }
    rc = VAPAA_CALLOC_COUNT(ndims, sizeof(*coords), (void **) &coords);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }

    for (int i = 0; i < ndims; i++) {
        if (contents->nl > 0) {
            sizes[i] = contents->counts[i];
            subsizes[i] = contents->counts[ndims + i];
            starts[i] = contents->counts[2 * ndims + i];
        } else {
            sizes[i] = contents->ints[1 + i];
            subsizes[i] = contents->ints[1 + ndims + i];
            starts[i] = contents->ints[1 + 2 * ndims + i];
        }
        if (sizes[i] < 0 || subsizes[i] < 0 || starts[i] < 0) {
            rc = MPI_ERR_ARG;
            goto fn_exit;
        }
    }

    if (ndims > 0) {
        if (order == MPI_ORDER_FORTRAN) {
            strides[0] = 1;
            for (int i = 1; i < ndims; i++) {
                strides[i] = strides[i - 1] * sizes[i - 1];
            }
        } else {
            strides[ndims - 1] = 1;
            for (int i = ndims - 2; i >= 0; i--) {
                strides[i] = strides[i + 1] * sizes[i + 1];
            }
        }
    }

    VAPAA_Iov_list child = {0};
    rc = VAPAA_DTYPE_FLATTEN_CHILD(contents->types[0], &child, depth);
    if (rc != MPI_SUCCESS) {
        VAPAA_IOV_FREE(&child);
        goto fn_exit;
    }

    MPI_Aint old_extent = 0;
    rc = VAPAA_DTYPE_GET_EXTENT(contents->types[0], &old_extent);
    if (rc != MPI_SUCCESS) {
        VAPAA_IOV_FREE(&child);
        goto fn_exit;
    }

    MPI_Count total = 1;
    for (int i = 0; i < ndims; i++) {
        total *= subsizes[i];
    }

    for (MPI_Count n = 0; n < total; n++) {
        MPI_Count rem = n;
        if (order == MPI_ORDER_FORTRAN) {
            for (int i = 0; i < ndims; i++) {
                coords[i] = (subsizes[i] == 0) ? 0 : rem % subsizes[i];
                rem = (subsizes[i] == 0) ? 0 : rem / subsizes[i];
            }
        } else {
            for (int i = ndims - 1; i >= 0; i--) {
                coords[i] = (subsizes[i] == 0) ? 0 : rem % subsizes[i];
                rem = (subsizes[i] == 0) ? 0 : rem / subsizes[i];
            }
        }

        MPI_Count linear = 0;
        for (int i = 0; i < ndims; i++) {
            linear += (starts[i] + coords[i]) * strides[i];
        }

        MPI_Aint linear_aint = 0;
        rc = VAPAA_MPI_COUNT_TO_AINT(linear, &linear_aint);
        if (rc != MPI_SUCCESS) {
            VAPAA_IOV_FREE(&child);
            goto fn_exit;
        }
        rc = VAPAA_IOV_APPEND_SHIFTED(out, &child, linear_aint * old_extent);
        if (rc != MPI_SUCCESS) {
            VAPAA_IOV_FREE(&child);
            goto fn_exit;
        }
    }

    VAPAA_IOV_FREE(&child);

  fn_exit:
    free(sizes);
    free(subsizes);
    free(starts);
    free(strides);
    free(coords);
    return rc;
}

static int VAPAA_DTYPE_FLATTEN_RECURSE(MPI_Datatype datatype, VAPAA_Iov_list *out, int depth)
{
    if (depth > 64) {
        return MPI_ERR_INTERN;
    }

    VAPAA_Datatype_contents contents;
    int rc = VAPAA_DTYPE_GET_CONTENTS(datatype, &contents);
    if (rc != MPI_SUCCESS) {
        VAPAA_DTYPE_CONTENTS_RELEASE(&contents);
        return rc;
    }

    if (contents.combiner == MPI_COMBINER_NAMED) {
        MPI_Aint size = 0;
        rc = VAPAA_DTYPE_GET_SIZE(datatype, &size);
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_IOV_APPEND(out, 0, size);
        }
    } else if (contents.combiner == MPI_COMBINER_DUP ||
               contents.combiner == MPI_COMBINER_RESIZED) {
        rc = VAPAA_DTYPE_FLATTEN_RECURSE(contents.types[0], out, depth + 1);
    } else if (contents.combiner == MPI_COMBINER_CONTIGUOUS) {
        MPI_Count count = VAPAA_CONTENT_ARG(&contents, 0);
        MPI_Aint old_extent = 0;
        VAPAA_Iov_list child = {0};
        rc = VAPAA_DTYPE_GET_EXTENT(contents.types[0], &old_extent);
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_DTYPE_FLATTEN_CHILD(contents.types[0], &child, depth);
        }
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_DTYPE_APPEND_REPEATED(out, &child, count, 1, old_extent, old_extent, 0);
        }
        VAPAA_IOV_FREE(&child);
    } else if (contents.combiner == MPI_COMBINER_VECTOR) {
        MPI_Count count = VAPAA_CONTENT_ARG(&contents, 0);
        MPI_Count blocklength = VAPAA_CONTENT_ARG(&contents, 1);
        MPI_Count stride_count = VAPAA_CONTENT_ARG(&contents, 2);
        MPI_Aint old_extent = 0;
        MPI_Aint stride = 0;
        VAPAA_Iov_list child = {0};
        rc = VAPAA_DTYPE_GET_EXTENT(contents.types[0], &old_extent);
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_MPI_COUNT_TO_AINT(stride_count, &stride);
        }
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_DTYPE_FLATTEN_CHILD(contents.types[0], &child, depth);
        }
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_DTYPE_APPEND_REPEATED(out, &child, count, blocklength,
                                             stride * old_extent, old_extent, 0);
        }
        VAPAA_IOV_FREE(&child);
    } else if (contents.combiner == MPI_COMBINER_HVECTOR) {
        MPI_Count count = VAPAA_CONTENT_ARG(&contents, 0);
        MPI_Count blocklength = VAPAA_CONTENT_ARG(&contents, 1);
        MPI_Count stride_count = (contents.nl > 0) ? contents.counts[2] : 0;
        MPI_Aint old_extent = 0;
        MPI_Aint stride = 0;
        VAPAA_Iov_list child = {0};
        rc = VAPAA_DTYPE_GET_EXTENT(contents.types[0], &old_extent);
        if (rc == MPI_SUCCESS) {
            rc = (contents.nl > 0) ? VAPAA_MPI_COUNT_TO_AINT(stride_count, &stride) :
                 ((stride = contents.addrs[0]), MPI_SUCCESS);
        }
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_DTYPE_FLATTEN_CHILD(contents.types[0], &child, depth);
        }
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_DTYPE_APPEND_REPEATED(out, &child, count, blocklength, stride, old_extent, 0);
        }
        VAPAA_IOV_FREE(&child);
    } else if (contents.combiner == MPI_COMBINER_INDEXED) {
        MPI_Count count = VAPAA_CONTENT_ARG(&contents, 0);
        MPI_Aint old_extent = 0;
        VAPAA_Iov_list child = {0};
        rc = VAPAA_DTYPE_GET_EXTENT(contents.types[0], &old_extent);
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_DTYPE_FLATTEN_CHILD(contents.types[0], &child, depth);
        }
        for (MPI_Count i = 0; rc == MPI_SUCCESS && i < count; i++) {
            MPI_Count blocklength = VAPAA_CONTENT_ARG(&contents, 1 + i);
            MPI_Count disp_count = VAPAA_CONTENT_ARG(&contents, 1 + count + i);
            MPI_Aint disp = 0;
            rc = VAPAA_MPI_COUNT_TO_AINT(disp_count, &disp);
            if (rc == MPI_SUCCESS) {
                rc = VAPAA_DTYPE_APPEND_REPEATED(out, &child, 1, blocklength,
                                                 old_extent, old_extent, disp * old_extent);
            }
        }
        VAPAA_IOV_FREE(&child);
    } else if (contents.combiner == MPI_COMBINER_HINDEXED) {
        MPI_Count count = VAPAA_CONTENT_ARG(&contents, 0);
        MPI_Aint old_extent = 0;
        VAPAA_Iov_list child = {0};
        rc = VAPAA_DTYPE_GET_EXTENT(contents.types[0], &old_extent);
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_DTYPE_FLATTEN_CHILD(contents.types[0], &child, depth);
        }
        for (MPI_Count i = 0; rc == MPI_SUCCESS && i < count; i++) {
            MPI_Count blocklength = VAPAA_CONTENT_ARG(&contents, 1 + i);
            MPI_Aint disp = 0;
            if (contents.nl > 0) {
                rc = VAPAA_MPI_COUNT_TO_AINT(contents.counts[1 + count + i], &disp);
            } else {
                disp = contents.addrs[i];
            }
            if (rc == MPI_SUCCESS) {
                rc = VAPAA_DTYPE_APPEND_REPEATED(out, &child, 1, blocklength, old_extent, old_extent, disp);
            }
        }
        VAPAA_IOV_FREE(&child);
    } else if (contents.combiner == MPI_COMBINER_INDEXED_BLOCK) {
        MPI_Count count = VAPAA_CONTENT_ARG(&contents, 0);
        MPI_Count blocklength = VAPAA_CONTENT_ARG(&contents, 1);
        MPI_Aint old_extent = 0;
        VAPAA_Iov_list child = {0};
        rc = VAPAA_DTYPE_GET_EXTENT(contents.types[0], &old_extent);
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_DTYPE_FLATTEN_CHILD(contents.types[0], &child, depth);
        }
        for (MPI_Count i = 0; rc == MPI_SUCCESS && i < count; i++) {
            MPI_Count disp_count = VAPAA_CONTENT_ARG(&contents, 2 + i);
            MPI_Aint disp = 0;
            rc = VAPAA_MPI_COUNT_TO_AINT(disp_count, &disp);
            if (rc == MPI_SUCCESS) {
                rc = VAPAA_DTYPE_APPEND_REPEATED(out, &child, 1, blocklength,
                                                 old_extent, old_extent, disp * old_extent);
            }
        }
        VAPAA_IOV_FREE(&child);
#if defined(MPI_COMBINER_HINDEXED_BLOCK) || MPI_VERSION >= 3
    } else if (contents.combiner == MPI_COMBINER_HINDEXED_BLOCK) {
        MPI_Count count = VAPAA_CONTENT_ARG(&contents, 0);
        MPI_Count blocklength = VAPAA_CONTENT_ARG(&contents, 1);
        MPI_Aint old_extent = 0;
        VAPAA_Iov_list child = {0};
        rc = VAPAA_DTYPE_GET_EXTENT(contents.types[0], &old_extent);
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_DTYPE_FLATTEN_CHILD(contents.types[0], &child, depth);
        }
        for (MPI_Count i = 0; rc == MPI_SUCCESS && i < count; i++) {
            MPI_Aint disp = 0;
            if (contents.nl > 0) {
                rc = VAPAA_MPI_COUNT_TO_AINT(contents.counts[2 + i], &disp);
            } else {
                disp = contents.addrs[i];
            }
            if (rc == MPI_SUCCESS) {
                rc = VAPAA_DTYPE_APPEND_REPEATED(out, &child, 1, blocklength, old_extent, old_extent, disp);
            }
        }
        VAPAA_IOV_FREE(&child);
#endif
    } else if (contents.combiner == MPI_COMBINER_STRUCT) {
        MPI_Count count = VAPAA_CONTENT_ARG(&contents, 0);
        for (MPI_Count i = 0; rc == MPI_SUCCESS && i < count; i++) {
            MPI_Count blocklength = VAPAA_CONTENT_ARG(&contents, 1 + i);
            MPI_Aint disp = 0;
            if (contents.nl > 0) {
                rc = VAPAA_MPI_COUNT_TO_AINT(contents.counts[1 + count + i], &disp);
            } else {
                disp = contents.addrs[i];
            }
            MPI_Aint old_extent = 0;
            VAPAA_Iov_list child = {0};
            if (rc == MPI_SUCCESS) {
                rc = VAPAA_DTYPE_GET_EXTENT(contents.types[i], &old_extent);
            }
            if (rc == MPI_SUCCESS) {
                rc = VAPAA_DTYPE_FLATTEN_CHILD(contents.types[i], &child, depth);
            }
            if (rc == MPI_SUCCESS) {
                rc = VAPAA_DTYPE_APPEND_REPEATED(out, &child, 1, blocklength, old_extent, old_extent, disp);
            }
            VAPAA_IOV_FREE(&child);
        }
    } else if (contents.combiner == MPI_COMBINER_SUBARRAY) {
        rc = VAPAA_DTYPE_FLATTEN_SUBARRAY(&contents, out, depth);
#if defined(MPICH) && defined(MPI_COMBINER_HVECTOR_INTEGER)
    } else if (contents.combiner == MPI_COMBINER_HVECTOR_INTEGER) {
        MPI_Count count = contents.ints[0];
        MPI_Count blocklength = contents.ints[1];
        MPI_Aint stride = contents.ints[2];
        MPI_Aint old_extent = 0;
        VAPAA_Iov_list child = {0};
        rc = VAPAA_DTYPE_GET_EXTENT(contents.types[0], &old_extent);
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_DTYPE_FLATTEN_CHILD(contents.types[0], &child, depth);
        }
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_DTYPE_APPEND_REPEATED(out, &child, count, blocklength, stride, old_extent, 0);
        }
        VAPAA_IOV_FREE(&child);
#endif
#if defined(MPICH) && defined(MPI_COMBINER_HINDEXED_INTEGER)
    } else if (contents.combiner == MPI_COMBINER_HINDEXED_INTEGER) {
        MPI_Count count = contents.ints[0];
        MPI_Aint old_extent = 0;
        VAPAA_Iov_list child = {0};
        rc = VAPAA_DTYPE_GET_EXTENT(contents.types[0], &old_extent);
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_DTYPE_FLATTEN_CHILD(contents.types[0], &child, depth);
        }
        for (MPI_Count i = 0; rc == MPI_SUCCESS && i < count; i++) {
            MPI_Count blocklength = contents.ints[1 + i];
            MPI_Aint disp = contents.ints[1 + count + i];
            rc = VAPAA_DTYPE_APPEND_REPEATED(out, &child, 1, blocklength, old_extent, old_extent, disp);
        }
        VAPAA_IOV_FREE(&child);
#endif
#if defined(MPICH) && defined(MPI_COMBINER_STRUCT_INTEGER)
    } else if (contents.combiner == MPI_COMBINER_STRUCT_INTEGER) {
        MPI_Count count = contents.ints[0];
        for (MPI_Count i = 0; rc == MPI_SUCCESS && i < count; i++) {
            MPI_Count blocklength = contents.ints[1 + i];
            MPI_Aint disp = contents.ints[1 + count + i];
            MPI_Aint old_extent = 0;
            VAPAA_Iov_list child = {0};
            rc = VAPAA_DTYPE_GET_EXTENT(contents.types[i], &old_extent);
            if (rc == MPI_SUCCESS) {
                rc = VAPAA_DTYPE_FLATTEN_CHILD(contents.types[i], &child, depth);
            }
            if (rc == MPI_SUCCESS) {
                rc = VAPAA_DTYPE_APPEND_REPEATED(out, &child, 1, blocklength, old_extent, old_extent, disp);
            }
            VAPAA_IOV_FREE(&child);
        }
#endif
    } else if (contents.combiner == MPI_COMBINER_F90_REAL ||
               contents.combiner == MPI_COMBINER_F90_COMPLEX ||
               contents.combiner == MPI_COMBINER_F90_INTEGER
#ifdef MPI_COMBINER_VALUE_INDEX
               || contents.combiner == MPI_COMBINER_VALUE_INDEX
#endif
              ) {
        MPI_Aint size = 0;
        rc = VAPAA_DTYPE_GET_SIZE(datatype, &size);
        if (rc == MPI_SUCCESS) {
            rc = VAPAA_IOV_APPEND(out, 0, size);
        }
    } else {
        VAPAA_Warning("Unsupported datatype combiner in standard IOV decoder: %d\n",
                      contents.combiner);
        rc = MPI_ERR_TYPE;
    }

    VAPAA_DTYPE_CONTENTS_RELEASE(&contents);
    return rc;
}

static int VAPAA_CREATE_STANDARD_IOV(MPI_Datatype dt, VAPAA_Iov **iov,
                                     size_t *actual_iov_len, size_t *actual_iov_bytes)
{
    VAPAA_Iov_list list = {0};
    int rc = VAPAA_DTYPE_FLATTEN_RECURSE(dt, &list, 0);
    if (rc != MPI_SUCCESS) {
        VAPAA_IOV_FREE(&list);
        return rc;
    }

    size_t total_bytes = 0;
    for (size_t i = 0; i < list.len; i++) {
        if ((uint64_t) list.iov[i].iov_len > (uint64_t) (SIZE_MAX - total_bytes)) {
            VAPAA_IOV_FREE(&list);
            return MPI_ERR_COUNT;
        }
        total_bytes += (size_t) list.iov[i].iov_len;
    }

    *iov = list.iov;
    *actual_iov_len = list.len;
    *actual_iov_bytes = total_bytes;
    return MPI_SUCCESS;
}

MAYBE_UNUSED
static bool VAPAA_ENV_IS_ENABLED(const char *name)
{
    const char *value = getenv(name);
    return value != NULL && value[0] != '\0' && strcmp(value, "0") != 0;
}

MAYBE_UNUSED
static int VAPAA_COMPARE_IOV(const char *left_name, const VAPAA_Iov *left_iov,
                             size_t left_iov_len, size_t left_iov_bytes,
                             const char *right_name, const VAPAA_Iov *right_iov,
                             size_t right_iov_len, size_t right_iov_bytes)
{
    if (left_iov_len != right_iov_len || left_iov_bytes != right_iov_bytes) {
        VAPAA_Warning("%s/%s IOV length/bytes mismatch: %s=(%zu,%zu) %s=(%zu,%zu)\n",
                      left_name, right_name, left_name, left_iov_len, left_iov_bytes,
                      right_name, right_iov_len, right_iov_bytes);
        return MPI_ERR_INTERN;
    }

    for (size_t i = 0; i < left_iov_len; i++) {
        if (left_iov[i].iov_base != right_iov[i].iov_base ||
            left_iov[i].iov_len != right_iov[i].iov_len) {
            VAPAA_Warning("%s/%s IOV mismatch at %zu: %s=(%zd,%zd) %s=(%zd,%zd)\n",
                          left_name, right_name, i,
                          left_name, (ptrdiff_t) left_iov[i].iov_base,
                          (ptrdiff_t) left_iov[i].iov_len,
                          right_name, (ptrdiff_t) right_iov[i].iov_base,
                          (ptrdiff_t) right_iov[i].iov_len);
            return MPI_ERR_INTERN;
        }
    }

    return MPI_SUCCESS;
}

#if VAPAA_HAVE_MPIX_IOV
static int VAPAA_CREATE_MPIX_IOV(MPI_Datatype dt, VAPAA_Iov **iov,
                                 size_t *actual_iov_len, size_t *actual_iov_bytes)
{
    MPI_Count type_size = 0;
    int rc = PMPI_Type_size_x(dt, &type_size);
    if (rc != MPI_SUCCESS) {
        return rc;
    }

    MPI_Count mpich_iov_len = 0;
    MPI_Count mpich_iov_bytes = 0;
    rc = MPIX_Type_iov_len(dt, type_size, &mpich_iov_len, &mpich_iov_bytes);
    if (rc != MPI_SUCCESS) {
        return rc;
    }
    if (mpich_iov_bytes != type_size) {
        return MPI_ERR_COUNT;
    }

    size_t mpich_len = 0;
    rc = VAPAA_COUNT_TO_SIZE(mpich_iov_len, &mpich_len);
    if (rc != MPI_SUCCESS) {
        return rc;
    }

    MPIX_Iov *mpich_iov = NULL;
    if (mpich_len > 0) {
        mpich_iov = calloc(mpich_len, sizeof(*mpich_iov));
        if (mpich_iov == NULL) {
            return MPI_ERR_NO_MEM;
        }
    }

    MPI_Count returned_iov_len = 0;
    if (mpich_len > 0) {
        rc = MPIX_Type_iov(dt, 0, mpich_iov, mpich_iov_len, &returned_iov_len);
        if (rc != MPI_SUCCESS) {
            free(mpich_iov);
            return rc;
        }
    }
    if (returned_iov_len != mpich_iov_len) {
        free(mpich_iov);
        return MPI_ERR_INTERN;
    }

    VAPAA_Iov *out_iov = NULL;
    if (mpich_len > 0) {
        out_iov = calloc(mpich_len, sizeof(*out_iov));
        if (out_iov == NULL) {
            free(mpich_iov);
            return MPI_ERR_NO_MEM;
        }
    }

    for (size_t i = 0; i < mpich_len; i++) {
        out_iov[i].iov_base = (MPI_Aint) (intptr_t) mpich_iov[i].iov_base;
        out_iov[i].iov_len = mpich_iov[i].iov_len;
    }

    free(mpich_iov);

    size_t total_bytes = 0;
    rc = VAPAA_COUNT_TO_SIZE(mpich_iov_bytes, &total_bytes);
    if (rc != MPI_SUCCESS) {
        free(out_iov);
        return rc;
    }

    *iov = out_iov;
    *actual_iov_len = mpich_len;
    *actual_iov_bytes = total_bytes;
    return MPI_SUCCESS;
}
#endif

int VAPAA_CREATE_DATATYPE_IOV(MPI_Datatype dt, VAPAA_Iov **iov,
                              size_t *actual_iov_len, size_t *actual_iov_bytes)
{
#if VAPAA_HAVE_MPIX_IOV
    /* Native MPICH keeps the MPIX fast path unless debugging asks otherwise. */
    const bool force_standard = VAPAA_ENV_IS_ENABLED("VAPAA_FORCE_STANDARD_IOV");
    const bool compare_iov = VAPAA_ENV_IS_ENABLED("VAPAA_COMPARE_MPIX_IOV");

    if (!compare_iov) {
        if (force_standard) {
            return VAPAA_CREATE_STANDARD_IOV(dt, iov, actual_iov_len, actual_iov_bytes);
        } else {
            return VAPAA_CREATE_MPIX_IOV(dt, iov, actual_iov_len, actual_iov_bytes);
        }
    }

    VAPAA_Iov *mpix_iov = NULL;
    VAPAA_Iov *standard_iov = NULL;
    size_t mpix_iov_len = 0;
    size_t mpix_iov_bytes = 0;
    size_t standard_iov_len = 0;
    size_t standard_iov_bytes = 0;

    int rc = VAPAA_CREATE_MPIX_IOV(dt, &mpix_iov, &mpix_iov_len, &mpix_iov_bytes);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }

    rc = VAPAA_CREATE_STANDARD_IOV(dt, &standard_iov, &standard_iov_len, &standard_iov_bytes);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }

    rc = VAPAA_COMPARE_IOV("MPIX", mpix_iov, mpix_iov_len, mpix_iov_bytes,
                           "standard", standard_iov, standard_iov_len, standard_iov_bytes);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }

    if (force_standard) {
        *iov = standard_iov;
        *actual_iov_len = standard_iov_len;
        *actual_iov_bytes = standard_iov_bytes;
        standard_iov = NULL;
    } else {
        *iov = mpix_iov;
        *actual_iov_len = mpix_iov_len;
        *actual_iov_bytes = mpix_iov_bytes;
        mpix_iov = NULL;
    }

  fn_exit:
    free(mpix_iov);
    free(standard_iov);
    return rc;
#else
    return VAPAA_CREATE_STANDARD_IOV(dt, iov, actual_iov_len, actual_iov_bytes);
#endif
}

MAYBE_UNUSED
static void VAPAA_CFI_PRINT_INFO(const CFI_cdesc_t * desc)
{
    const void * ba = desc->base_addr;
    const size_t el = desc->elem_len;
    const int    rk = desc->rank;
    const int    ty = desc->type;
    printf("base_addr  = %p = %ld\n", ba, (long)ba);
    printf("elem_len   = %zu\n", el);
    printf("rank       = %d\n", rk);
    printf("contiguous = %s\n", VAPAA_CFI_is_contiguous(desc) ? "true" : "false" );
    {
        char name[32] = {0};
        VAPAA_CFI_GET_TYPE_NAME(ty,name);
        printf("type is %s\n",name);
    }
    {
        char name[32] = {0};
        VAPAA_CFI_GET_TYPE_ATTRIBUTE(desc->attribute,name);
        printf("attribute is %s\n",name);
    }

    if (rk > 0) {
        printf("dim.lowerbound = ");
        for (CFI_rank_t i=0; i<desc->rank; i++) {
            printf("%zd,",desc->dim[i].lower_bound);
        }
        printf("\n");

        printf("dim.extent     = ");
        for (CFI_rank_t i=0; i<desc->rank; i++) {
            printf("%zd,",desc->dim[i].extent);
        }
        printf("\n");

        printf("dim.sm         = ");
        for (CFI_rank_t i=0; i<desc->rank; i++) {
            printf("%zd,",desc->dim[i].sm);
        }
        printf("\n");
    }
}

static int VAPAA_CFI_CREATE_DATATYPE_15D(const CFI_cdesc_t * desc, ssize_t count, MPI_Datatype input_datatype,
                                         MPI_Datatype * array_datatype)
{
    if ( ! VAPAA_MPI_DATATYPE_IS_BUILTIN(input_datatype) ) {
        VAPAA_Warning("input datatype is not a named datatype.\n");
        return MPI_ERR_ARG;
    }

    const int rank     = desc->rank;
    const int extent0  = (rank >  0) ? desc->dim[0].extent : 1;
    const int extent1  = (rank >  1) ? desc->dim[1].extent : 1;
    const int extent2  = (rank >  2) ? desc->dim[ 2].extent : 1;
    const int extent3  = (rank >  3) ? desc->dim[ 3].extent : 1;
    const int extent4  = (rank >  4) ? desc->dim[ 4].extent : 1;
    const int extent5  = (rank >  5) ? desc->dim[ 5].extent : 1;
    const int extent6  = (rank >  6) ? desc->dim[ 6].extent : 1;
    const int extent7  = (rank >  7) ? desc->dim[ 7].extent : 1;
    const int extent8  = (rank >  8) ? desc->dim[ 8].extent : 1;
    const int extent9  = (rank >  9) ? desc->dim[ 9].extent : 1;
    const int extent10 = (rank > 10) ? desc->dim[10].extent : 1;
    const int extent11 = (rank > 11) ? desc->dim[11].extent : 1;
    const int extent12 = (rank > 12) ? desc->dim[12].extent : 1;
    const int extent13 = (rank > 13) ? desc->dim[13].extent : 1;
    const int extent14 = (rank > 14) ? desc->dim[14].extent : 1;

    // this is not optimal.

    int * array_of_blocklengths = malloc(count * sizeof(int));
    VAPAA_Assert(array_of_blocklengths != NULL);
    for (ssize_t i=0; i < count; i++) {
        array_of_blocklengths[i] = 1;
    }

    MPI_Aint * array_of_displacements = malloc(count * sizeof(MPI_Aint));
    VAPAA_Assert(array_of_displacements != NULL);
    ssize_t offset = 0;
    for (int i14 = 0; i14 < extent14; i14++) {
     const MPI_Aint stride14 = (rank > 14) ? desc->dim[14].sm : 0;
     for (int i13 = 0; i13 < extent13; i13++) {
      const MPI_Aint stride13 = (rank > 13) ? desc->dim[13].sm : 0;
      for (int i12 = 0; i12 < extent12; i12++) {
       const MPI_Aint stride12 = (rank > 12) ? desc->dim[12].sm : 0;
       for (int i11 = 0; i11 < extent11; i11++) {
        const MPI_Aint stride11 = (rank > 11) ? desc->dim[11].sm : 0;
        for (int i10 = 0; i10 < extent10; i10++) {
         const MPI_Aint stride10 = (rank > 10) ? desc->dim[10].sm : 0;
         for (int i9 = 0; i9 < extent9; i9++) {
          const MPI_Aint stride9 = (rank > 9) ? desc->dim[9].sm : 0;
          for (int i8 = 0; i8 < extent8; i8++) {
           const MPI_Aint stride8 = (rank > 8) ? desc->dim[8].sm : 0;
           for (int i7 = 0; i7 < extent7; i7++) {
            const MPI_Aint stride7 = (rank > 7) ? desc->dim[7].sm : 0;
            for (int i6 = 0; i6 < extent6; i6++) {
             const MPI_Aint stride6 = (rank > 6) ? desc->dim[6].sm : 0;
             for (int i5 = 0; i5 < extent5; i5++) {
              const MPI_Aint stride5 = (rank > 5) ? desc->dim[5].sm : 0;
              for (int i4 = 0; i4 < extent4; i4++) {
               const MPI_Aint stride4 = (rank > 4) ? desc->dim[4].sm : 0;
               for (int i3 = 0; i3 < extent3; i3++) {
                const MPI_Aint stride3 = (rank > 3) ? desc->dim[3].sm : 0;
                for (int i2 = 0; i2 < extent2; i2++) {
                 const MPI_Aint stride2 = (rank > 2) ? desc->dim[2].sm : 0;
                 for (int i1 = 0; i1 < extent1; i1++) {
                  const MPI_Aint stride1 = (rank > 1) ? desc->dim[1].sm : 0;
                  for (int i0 = 0; i0 < extent0; i0++) {
                   const MPI_Aint stride0 = (rank > 0) ? desc->dim[0].sm : 0;
                   array_of_displacements[offset] = stride0  * i0
                                                  + stride1  * i1
                                                  + stride2  * i2
                                                  + stride3  * i3
                                                  + stride4  * i4
                                                  + stride5  * i5
                                                  + stride6  * i6
                                                  + stride7  * i7
                                                  + stride8  * i8
                                                  + stride9  * i9
                                                  + stride10 * i10
                                                  + stride11 * i11
                                                  + stride12 * i12
                                                  + stride13 * i13
                                                  + stride14 * i14;
                   offset++;
                   if (offset == count) goto done15d;
                  }
                 }
                }
               }
              }
             }
            }
           }
          }
         }
        }
       }
      }
     }
    }
    done15d:

    { /* this prevents the compiler error:
       *    cfi_util.c:240:5: error: expected expression
       *    const MPI_Datatype element_datatype = VAPAA_CFI_TO_MPI_TYPE(desc->type);
       */ }

    const MPI_Datatype element_datatype = input_datatype;
    int rc = PMPI_Type_create_hindexed(count, array_of_blocklengths, array_of_displacements,
                                       element_datatype, array_datatype);
    VAPAA_Assert(rc == MPI_SUCCESS);

    free(array_of_blocklengths);
    free(array_of_displacements);

    return MPI_SUCCESS;
}

// This is a completely generic implementation of CFI -> IOV that takes
// no advantage of contiguous multi-element chunks.
// We actually just return a vector of addresses since the chunks are all elem_len
static const void ** VAPAA_CFI_CREATE_ELEMENT_ADDRESSES(const CFI_cdesc_t * desc)
{
    const ssize_t num_elem = VAPAA_CFI_GET_TOTAL_ELEMENTS(desc);

    const void ** addresses = malloc( num_elem * sizeof(void*) );
    VAPAA_Assert(addresses != NULL);

    const void * base  = desc->base_addr;
    //const int elem_len = desc->elem_len;
    const int rank     = desc->rank;
    const int extent0  = (rank >  0) ? desc->dim[ 0].extent : 1;
    const int extent1  = (rank >  1) ? desc->dim[ 1].extent : 1;
    const int extent2  = (rank >  2) ? desc->dim[ 2].extent : 1;
    const int extent3  = (rank >  3) ? desc->dim[ 3].extent : 1;
    const int extent4  = (rank >  4) ? desc->dim[ 4].extent : 1;
    const int extent5  = (rank >  5) ? desc->dim[ 5].extent : 1;
    const int extent6  = (rank >  6) ? desc->dim[ 6].extent : 1;
    const int extent7  = (rank >  7) ? desc->dim[ 7].extent : 1;
    const int extent8  = (rank >  8) ? desc->dim[ 8].extent : 1;
    const int extent9  = (rank >  9) ? desc->dim[ 9].extent : 1;
    const int extent10 = (rank > 10) ? desc->dim[10].extent : 1;
    const int extent11 = (rank > 11) ? desc->dim[11].extent : 1;
    const int extent12 = (rank > 12) ? desc->dim[12].extent : 1;
    const int extent13 = (rank > 13) ? desc->dim[13].extent : 1;
    const int extent14 = (rank > 14) ? desc->dim[14].extent : 1;

    ssize_t index = 0;
    for (int i14 = 0; i14 < extent14; i14++) {
     const ptrdiff_t stride14 = (rank > 14) ? desc->dim[14].sm : 0;
     for (int i13 = 0; i13 < extent13; i13++) {
      const ptrdiff_t stride13 = (rank > 13) ? desc->dim[13].sm : 0;
      for (int i12 = 0; i12 < extent12; i12++) {
       const ptrdiff_t stride12 = (rank > 12) ? desc->dim[12].sm : 0;
       for (int i11 = 0; i11 < extent11; i11++) {
        const ptrdiff_t stride11 = (rank > 11) ? desc->dim[11].sm : 0;
        for (int i10 = 0; i10 < extent10; i10++) {
         const ptrdiff_t stride10 = (rank > 10) ? desc->dim[10].sm : 0;
         for (int i9 = 0; i9 < extent9; i9++) {
          const ptrdiff_t stride9 = (rank > 9) ? desc->dim[9].sm : 0;
          for (int i8 = 0; i8 < extent8; i8++) {
           const ptrdiff_t stride8 = (rank > 8) ? desc->dim[8].sm : 0;
           for (int i7 = 0; i7 < extent7; i7++) {
            const ptrdiff_t stride7 = (rank > 7) ? desc->dim[7].sm : 0;
            for (int i6 = 0; i6 < extent6; i6++) {
             const ptrdiff_t stride6 = (rank > 6) ? desc->dim[6].sm : 0;
             for (int i5 = 0; i5 < extent5; i5++) {
              const ptrdiff_t stride5 = (rank > 5) ? desc->dim[5].sm : 0;
              for (int i4 = 0; i4 < extent4; i4++) {
               const ptrdiff_t stride4 = (rank > 4) ? desc->dim[4].sm : 0;
               for (int i3 = 0; i3 < extent3; i3++) {
                const ptrdiff_t stride3 = (rank > 3) ? desc->dim[3].sm : 0;
                for (int i2 = 0; i2 < extent2; i2++) {
                 const ptrdiff_t stride2 = (rank > 2) ? desc->dim[2].sm : 0;
                 for (int i1 = 0; i1 < extent1; i1++) {
                  const ptrdiff_t stride1 = (rank > 1) ? desc->dim[1].sm : 0;
                  for (int i0 = 0; i0 < extent0; i0++) {
                   const ptrdiff_t stride0 = (rank > 0) ? desc->dim[0].sm : 0;
                   ptrdiff_t displacement = stride0  * i0
                                          + stride1  * i1
                                          + stride2  * i2
                                          + stride3  * i3
                                          + stride4  * i4
                                          + stride5  * i5
                                          + stride6  * i6
                                          + stride7  * i7
                                          + stride8  * i8
                                          + stride9  * i9
                                          + stride10 * i10
                                          + stride11 * i11
                                          + stride12 * i12
                                          + stride13 * i13
                                          + stride14 * i14;
                   addresses[index] = (void*)((intptr_t)base + displacement);
#if 0
                   printf("CFI addresses[%zu] = %p (%zd)\n", index, addresses[index],
                           (addresses[index] - addresses[0]) / elem_len);
#endif
                   index++;
                  }
                 }
                }
               }
              }
             }
            }
           }
          }
         }
        }
       }
      }
     }
    }
    return addresses;
}

// Takes the result of VAPAA_CFI_CREATE_ELEMENT_ADDRESSES, which is
// a vector of all of the element addresses in a subarray, and returns
// the MPI indexed type associated with the vector of addresses
// representing the subset of those that are contained in an MPI datatype
static int VAPAA_CFI_CREATE_INDEXED(const CFI_cdesc_t * desc, int count, MPI_Datatype input_datatype, 
                                    MPI_Datatype * array_datatype)
{
    const int elem_len = desc->elem_len;
    if (elem_len <= 0 || count < 0) {
        return MPI_ERR_ARG;
    }

    int rc;
    VAPAA_Iov *iov = NULL;
    size_t actual_iov_len = 0;
    size_t total_bytes = 0;
    int *array_of_blocklengths = NULL;
    MPI_Aint *array_of_displacements = NULL;
    const void **input = NULL;

    rc = VAPAA_CREATE_DATATYPE_IOV(input_datatype, &iov, &actual_iov_len, &total_bytes);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }

    MPI_Aint extent = 0;
    rc = VAPAA_DTYPE_GET_EXTENT(input_datatype, &extent);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }
    if (total_bytes % (size_t) elem_len != 0 || extent % elem_len != 0) {
        rc = MPI_ERR_TYPE;
        goto fn_exit;
    }

#if 0
    rc = VAPAA_MPIDT_PRINT_INFO(input_datatype);
    VAPAA_Assert(rc == MPI_SUCCESS);
    fflush(0);
    usleep(1000);
#endif

    const bool use_byte_elements = VAPAA_CFI_IS_OPAQUE_STRUCT_DESC(desc);
    if (use_byte_elements && (size_t) elem_len > (size_t) INT_MAX) {
        rc = MPI_ERR_COUNT;
        goto fn_exit;
    }

    size_t iov_elements = total_bytes / elem_len;
    if ((size_t) count > 0 && iov_elements > SIZE_MAX / (size_t) count) {
        rc = MPI_ERR_NO_MEM;
        goto fn_exit;
    }
    const size_t nalloc = (size_t) count * iov_elements;
    if (nalloc > (size_t) INT_MAX) {
        rc = MPI_ERR_COUNT;
        goto fn_exit;
    }

    if (nalloc > 0) {
        array_of_blocklengths = malloc(nalloc * sizeof(*array_of_blocklengths));
        if (array_of_blocklengths == NULL) {
            rc = MPI_ERR_NO_MEM;
            goto fn_exit;
        }

        array_of_displacements = malloc(nalloc * sizeof(*array_of_displacements));
        if (array_of_displacements == NULL) {
            rc = MPI_ERR_NO_MEM;
            goto fn_exit;
        }
    }

    input = VAPAA_CFI_CREATE_ELEMENT_ADDRESSES(desc);
    const ssize_t total_cfi_elements = VAPAA_CFI_GET_TOTAL_ELEMENTS(desc);
    const MPI_Aint type_extent_elements = extent / elem_len;
    size_t index = 0;
    for (int j=0; j < count; j++) {
        const MPI_Aint type_displacement = (MPI_Aint) j * type_extent_elements;
        for (size_t i=0; i < actual_iov_len; i++) {
            if (iov[i].iov_base % elem_len != 0 || iov[i].iov_len % elem_len != 0) {
                rc = MPI_ERR_TYPE;
                goto fn_exit;
            }
            const MPI_Aint iov_displacement = iov[i].iov_base / elem_len;
            const MPI_Aint iov_length = iov[i].iov_len / elem_len;
            for (MPI_Aint k=0; k < iov_length; k++) {
                array_of_blocklengths[index] = use_byte_elements ? elem_len : 1;
                const MPI_Aint offset = k + iov_displacement + type_displacement;
                if (offset < 0 || offset >= (MPI_Aint) total_cfi_elements) {
                    rc = MPI_ERR_ARG;
                    goto fn_exit;
                }
                array_of_displacements[index] =
                    (MPI_Aint) ((intptr_t) input[offset] - (intptr_t) input[0]);
                index++;
            }
        }
    }

    const size_t n = index;
    VAPAA_Assert(n < INT_MAX);

#if 0
    for (size_t i=0; i<n; i++) {
        printf("%zd: BL=%6d, DISP=%12zd\n", i, array_of_blocklengths[i], (ptrdiff_t)array_of_displacements[i]);
    }
#endif

    MPI_Datatype elem_dt = use_byte_elements ? MPI_BYTE : VAPAA_CFI_TO_MPI_TYPE(desc->type);
    if (elem_dt == MPI_DATATYPE_NULL) {
        rc = MPI_ERR_TYPE;
        goto fn_exit;
    }
    rc = PMPI_Type_create_hindexed((int)n, array_of_blocklengths, array_of_displacements,
                                   elem_dt, array_datatype);
    VAPAA_Assert(rc == MPI_SUCCESS);

  fn_exit:
    free(iov);
    free(input);
    free(array_of_blocklengths);
    free(array_of_displacements);

    return rc;
}

// This function does not commit datatypes.  That needs to happen elsewhere.
int VAPAA_CFI_CREATE_DATATYPE(const CFI_cdesc_t * desc, int count, MPI_Datatype input_datatype, 
                              MPI_Datatype * array_datatype)
{
    int rc;

    rc = VAPAA_CFI_ASSERT_ZERO_LOWER_BOUNDS(desc);
    if (rc != MPI_SUCCESS) {
        return rc;
    }

    if ( VAPAA_MPI_DATATYPE_IS_BUILTIN(input_datatype) )
    {
        const int rank     = desc->rank;
        const int elem_len = desc->elem_len;

        const MPI_Datatype element_datatype = input_datatype;

        // count up the total number of elements in the CFI array
        ssize_t total_elems = 1;
        for (CFI_rank_t i=0; i < rank; i++) {
            const ssize_t extent = desc->dim[i].extent;
            total_elems *= extent;

            // detect large-count problems
            if (extent > INT_MAX) {
                VAPAA_Warning("extent (%zd) > INT_MAX.\n", extent);
                return MPI_ERR_COUNT;
            }

            // detect large-count problems - test here so we catch cases where the last extent is -1
            if (total_elems > INT_MAX) {
                VAPAA_Warning("total_elems (%zd) > INT_MAX.\n", total_elems);
                return MPI_ERR_COUNT;
            }
        }

        // detect invalid input that will cause buffer overrun
        if (count > total_elems) {
            VAPAA_Warning("count (%zd) > total_elems (%zd).\n", count, total_elems);
            return MPI_ERR_ARG;
        }

        // "In a C descriptor of an assumed-size array, the extent member of the 
        //  last element of the dim member has the value −1."
        // Using extent[rank-1] is dangerous and we should never do it.

        const int extent0 = desc->dim[0].extent;
        const int extent1 = desc->dim[1].extent;

        if (rank == 1 || count <= extent0)
        {
            // 1D array non-contiguous array can only be single elements, e.g.
            //    X(1:end:stride) where stride > 1
            // If we land here because of the second conditional, we may create an hvector when
            // contiguous would suffice, but that is an unlikely use case that does not warrant specialization.
            const int      num_blocks = count;
            const MPI_Aint stride     = desc->dim[0].sm;
            rc = PMPI_Type_create_hvector(num_blocks, 1, stride, element_datatype, array_datatype);
            VAPAA_Assert(rc == MPI_SUCCESS);
        }
        else if (rank == 2 || count <= extent0*extent1)
        {
            // 2D array non-contiguous array will be a vector of blocks e.g.
            //    X(1:e0:s0,b1:e1:s1)
            // There are a few cases to support:
            //    1: count is an even multiple of extent[0], which is a vector or a vector of vectors
            //    2: count is not an even multiple of extent[0], which is another type: struct or (h)indexed
            if (count % extent0 == 0)
            {
                const MPI_Aint stride0 = desc->dim[0].sm;
                // if the first dimension is contiguous, we only need one datatype
                if (stride0 == elem_len) {
                    const MPI_Aint stride1 = desc->dim[1].sm;
                    rc = PMPI_Type_create_hvector(count / extent0, extent0, stride1, element_datatype, array_datatype);
                    VAPAA_Assert(rc == MPI_SUCCESS);
                }
                // if the first dimension is non-contiguous, create a temp for it,
                // then create a vector of those for the array
                else
                {
                    MPI_Datatype temp_datatype = MPI_DATATYPE_NULL;
                    rc = PMPI_Type_create_hvector(extent0, 1, stride0, element_datatype, &temp_datatype);
                    VAPAA_Assert(rc == MPI_SUCCESS);

                    const MPI_Aint stride1 = desc->dim[1].sm;
                    rc = PMPI_Type_create_hvector(count / extent0, 1, stride1, temp_datatype, array_datatype);
                    VAPAA_Assert(rc == MPI_SUCCESS);

                    rc = PMPI_Type_free(&temp_datatype);
                    VAPAA_Assert(rc == MPI_SUCCESS);
                }
            }
            else // weird case where the count does not lead to a cartesian subarray
            {
                // this is not optimal.
                // we enumerate every element instead of generating one type for the cartesian part
                // and a second type for the remainer.

                int * array_of_blocklengths = malloc(count * sizeof(int));
                VAPAA_Assert(array_of_blocklengths != NULL);
                for (ssize_t i=0; i < count; i++) {
                    array_of_blocklengths[i] = 1;
                }

                MPI_Aint * array_of_displacements = malloc(count * sizeof(MPI_Aint));
                VAPAA_Assert(array_of_displacements != NULL);
                ssize_t offset = 0;
                for (int i1 = 0; i1 < extent1; i1++) {
                    const MPI_Aint stride1 = desc->dim[1].sm;
                    for (int i0 = 0; i0 < extent0; i0++) {
                        const MPI_Aint stride0 = desc->dim[0].sm;
                        array_of_displacements[offset] = stride0 * i0 + stride1 * i1;
                        offset++;
                        if (offset == count) goto done2d;
                    }
                }
                done2d:

                rc = PMPI_Type_create_hindexed(count, array_of_blocklengths, array_of_displacements,
                                               element_datatype, array_datatype);
                VAPAA_Assert(rc == MPI_SUCCESS);

                free(array_of_blocklengths);
                free(array_of_displacements);
            }
        }
        else if (rank == 3)
        {
            const int extent2 = desc->dim[2].extent;

            // this is not optimal.  we can add the equivalent of the 2D specializations if necessary.

            int * array_of_blocklengths = malloc(count * sizeof(int));
            VAPAA_Assert(array_of_blocklengths != NULL);
            for (ssize_t i=0; i < count; i++) {
                array_of_blocklengths[i] = 1;
            }

            MPI_Aint * array_of_displacements = malloc(count * sizeof(MPI_Aint));
            VAPAA_Assert(array_of_displacements != NULL);
            ssize_t offset = 0;
            for (int i2 = 0; i2 < extent2; i2++) {
                const MPI_Aint stride2 = desc->dim[2].sm;
                for (int i1 = 0; i1 < extent1; i1++) {
                    const MPI_Aint stride1 = desc->dim[1].sm;
                    for (int i0 = 0; i0 < extent0; i0++) {
                        const MPI_Aint stride0 = desc->dim[0].sm;
                        array_of_displacements[offset] = stride0 * i0 + stride1 * i1 + stride2 * i2;
                        offset++;
                        if (offset == count) goto done3d;
                    }
                }
            }
            done3d:

            rc = PMPI_Type_create_hindexed(count, array_of_blocklengths, array_of_displacements,
                                           element_datatype, array_datatype);
            VAPAA_Assert(rc == MPI_SUCCESS);

            free(array_of_blocklengths);
            free(array_of_displacements);
        }
        else if (rank < 15) {
            rc = VAPAA_CFI_CREATE_DATATYPE_15D(desc, count, input_datatype, array_datatype);
            VAPAA_Assert(rc == MPI_SUCCESS);
        }
        else
        {
            VAPAA_Warning("Unsupported dimension (%d).\n", rank);
            return MPI_ERR_ARG;
        }

        // verify that the type we have created holds the correct number of elements
        {
            int type_size;
            PMPI_Type_size(*array_datatype, &type_size);
            if (type_size != count * elem_len) {
                VAPAA_Warning("type_size (%d) != count (%zd) * elem_len (%zd).\n", type_size, count, elem_len);
                return MPI_ERR_INTERN;
            }   
        }
    }
    // MPI user-defined datatype
    else
    {
        rc = VAPAA_CFI_CREATE_INDEXED(desc, count, input_datatype, array_datatype);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    return MPI_SUCCESS;
}
