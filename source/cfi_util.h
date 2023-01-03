#ifndef CFI_UTIL_H
#define CFI_UTIL_H

#include "ISO_Fortran_binding.h"

#define MAYBE_UNUSED __attribute__((unused))

MAYBE_UNUSED
static MPI_Comm VAPAA_CFI_TO_MPI_TYPE(CFI_type_t type)
{
         if (type==CFI_type_signed_char)          return MPI_CHAR;
    else if (type==CFI_type_int8_t)               return MPI_INT8_T;
    else if (type==CFI_type_int16_t)              return MPI_INT16_T;
    else if (type==CFI_type_int32_t)              return MPI_INT32_T;
    else if (type==CFI_type_int64_t)              return MPI_INT64_T;
    else if (type==CFI_type_float)                return MPI_FLOAT;
    else if (type==CFI_type_double)               return MPI_DOUBLE;
    else if (type==CFI_type_float_Complex)        return MPI_C_FLOAT_COMPLEX;
    else if (type==CFI_type_double_Complex)       return MPI_C_DOUBLE_COMPLEX;
    else                                          return MPI_DATATYPE_NULL;
}

MAYBE_UNUSED
static void VAPAA_CFI_GET_TYPE_ATTRIBUTE(CFI_attribute_t attribute, char * name)
{
         if (attribute==CFI_attribute_pointer)     snprintf(name,32,"%s", "data pointer");
    else if (attribute==CFI_attribute_allocatable) snprintf(name,32,"%s", "allocatable");
    else if (attribute==CFI_attribute_other)       snprintf(name,32,"%s", "nonallocatable nonpointer");
    else                                           snprintf(name,32,"%s", "unknown CFI type attribute");

}

MAYBE_UNUSED
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
    else if (type==CFI_type_int_least8_t)         snprintf(name,32,"%s", "int_least8_t");
    else if (type==CFI_type_int_least16_t)        snprintf(name,32,"%s", "int_least16_t");
    else if (type==CFI_type_int_least32_t)        snprintf(name,32,"%s", "int_least32_t");
    else if (type==CFI_type_int_least64_t)        snprintf(name,32,"%s", "int_least64_t");
    else if (type==CFI_type_int_fast8_t)          snprintf(name,32,"%s", "int_fast8_t");
    else if (type==CFI_type_int_fast16_t)         snprintf(name,32,"%s", "int_fast16_t");
    else if (type==CFI_type_int_fast32_t)         snprintf(name,32,"%s", "int_fast32_t");
    else if (type==CFI_type_int_fast64_t)         snprintf(name,32,"%s", "int_fast64_t");
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
#if 1
    // not in F2023
    else if (type==CFI_type_cfunptr)              snprintf(name,32,"%s", "cfunptr");
#endif
    else if (type==CFI_type_struct)               snprintf(name,32,"%s", "struct");
    else if (type==CFI_type_other)                snprintf(name,32,"%s", "other");
    else                                          snprintf(name,32,"unknown (%8d)", (int)type);
}

MAYBE_UNUSED
static void VAPAA_CFI_PRINT_INFO(CFI_cdesc_t * desc)
{
    const void * ba = desc->base_addr;
    const size_t el = desc->elem_len;
    const int    rk = desc->rank;
    const int    ty = desc->type;
    printf("base_addr  = %p = %ld\n", ba, (long)ba);
    printf("elem_len   = %zu\n", el);
    printf("rank       = %d\n", rk);
    printf("contiguous = %s\n", CFI_is_contiguous(desc) ? "true" : "false" );
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
            printf("%d,",(int)desc->dim[i].lower_bound);
        }
        printf("\n");

        printf("dim.extent     = ");
        for (CFI_rank_t i=0; i<desc->rank; i++) {
            printf("%d,",(int)desc->dim[i].extent);
        }
        printf("\n");

        printf("dim.sm         = ");
        for (CFI_rank_t i=0; i<desc->rank; i++) {
            printf("%d,",(int)desc->dim[i].sm);
        }
        printf("\n");
    }
}

#endif // CFI_UTIL_H
