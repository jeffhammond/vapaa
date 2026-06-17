// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdlib.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "vapaa_constants.h"

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
    *ierror = MPI_Get_count_c(&status, datatype, &count);
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
    *ierror = MPI_Get_elements_c(&status, datatype, &count);
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
    *ierror = MPI_Type_create_hvector_c((MPI_Count) *count, (MPI_Count) *blocklength, (MPI_Count) *stride, oldtype, &newtype);
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
    *ierror = MPI_Type_create_hindexed_c((MPI_Count) *count, (const MPI_Count *) blocklengths,
                                         (const MPI_Count *) displacements, oldtype, &newtype);
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
    *ierror = MPI_Type_create_hindexed_block_c((MPI_Count) *count, (MPI_Count) *blocklength,
                                               (const MPI_Count *) displacements, oldtype, &newtype);
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
    *ierror = MPI_Type_create_indexed_block_c((MPI_Count) *count, (MPI_Count) *blocklength,
                                              (const MPI_Count *) displacements, oldtype, &newtype);
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
    *ierror = MPI_Type_indexed_c((MPI_Count) *count, (const MPI_Count *) blocklengths,
                                 (const MPI_Count *) displacements, oldtype, &newtype);
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
    int count = (int) *count_f;
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    MPI_Datatype *datatypes = VAPAA_MPI_TYPES_FROMINT_ARRAY(count, datatypes_f);
    if (datatypes == NULL) {
        *ierror = C_MPI_ERROR_CODE_C2F(MPI_ERR_NO_MEM);
        return;
    }
    *ierror = MPI_Type_create_struct_c((MPI_Count) *count_f, (const MPI_Count *) blocklengths,
                                       (const MPI_Count *) displacements, datatypes, &newtype);
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
    *ierror = MPI_Type_create_darray_c(*size, *rank, *ndims, (const MPI_Count *) gsizes, distribs, dargs, psizes,
                                       VAPAA_MPI_ORDER_F2C(*order_f), oldtype, &newtype);
    free(distribs);
    free(dargs);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_f90_integer(int *r, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    *ierror = MPI_Type_create_f90_integer(*r, &newtype);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_f90_real(int *p, int *r, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    *ierror = MPI_Type_create_f90_real(*p, *r, &newtype);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_f90_complex(int *p, int *r, int *newtype_f, int *ierror)
{
    MPI_Datatype newtype = MPI_DATATYPE_NULL;
    *ierror = MPI_Type_create_f90_complex(*p, *r, &newtype);
    *newtype_f = C_MPI_TYPE_TOINT(newtype);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_envelope(int *datatype_f, int *ni, int *na, int *nd, int *combiner_f, int *ierror)
{
    int combiner = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_Type_get_envelope(datatype, ni, na, nd, &combiner);
    *combiner_f = VAPAA_MPI_COMBINER_C2F(combiner);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_envelope_c(int *datatype_f, int64_t *ni_f, int64_t *na_f, int64_t *nl_f, int64_t *nd_f, int *combiner_f, int *ierror)
{
    MPI_Count ni = 0, na = 0, nl = 0, nd = 0;
    int combiner = 0;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_Type_get_envelope_c(datatype, &ni, &na, &nl, &nd, &combiner);
    *ni_f = (int64_t) ni;
    *na_f = (int64_t) na;
    *nl_f = (int64_t) nl;
    *nd_f = (int64_t) nd;
    *combiner_f = VAPAA_MPI_COMBINER_C2F(combiner);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_contents(int *datatype_f, int *mi, int *ma, int *md, int *ints, intptr_t *addrs_f, int *types_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Datatype *types = malloc((size_t) *md * sizeof(*types));
    if (*md > 0 && types == NULL) {
        *ierror = C_MPI_ERROR_CODE_C2F(MPI_ERR_NO_MEM);
        return;
    }
    *ierror = MPI_Type_get_contents(datatype, *mi, *ma, *md, ints, (MPI_Aint *) addrs_f, types);
    VAPAA_MPI_TYPES_TOINT_ARRAY(*md, types, types_f);
    free(types);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_get_contents_c(int *datatype_f, int64_t *mi_f, int64_t *ma_f, int64_t *ml_f, int64_t *md_f,
                                   int *ints, intptr_t *addrs_f, int64_t *counts_f, int *types_f, int *ierror)
{
    int md = (int) *md_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Datatype *types = malloc((size_t) md * sizeof(*types));
    if (md > 0 && types == NULL) {
        *ierror = C_MPI_ERROR_CODE_C2F(MPI_ERR_NO_MEM);
        return;
    }
    *ierror = MPI_Type_get_contents_c(datatype, (MPI_Count) *mi_f, (MPI_Count) *ma_f, (MPI_Count) *ml_f, (MPI_Count) *md_f,
                                      ints, (MPI_Aint *) addrs_f, (MPI_Count *) counts_f, types);
    VAPAA_MPI_TYPES_TOINT_ARRAY(md, types, types_f);
    free(types);
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
    *ierror = MPI_Type_get_value_index(value_type, index_type, &pair_type);
    *pair_type_f = C_MPI_TYPE_TOINT(pair_type);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_delete_attr(int *datatype_f, int *keyval, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_Type_delete_attr(datatype, *keyval);
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
    *attrval_f = (intptr_t) attrval;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_set_attr(int *datatype_f, int *keyval, intptr_t *attrval_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_Type_set_attr(datatype, *keyval, (void *) *attrval_f);
    C_MPI_RC_FIX(*ierror);
}
