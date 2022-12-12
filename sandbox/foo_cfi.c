#include <stdio.h>
#include <stdlib.h>
#include "ISO_Fortran_binding.h"

void print_string(const char ** ps, const int * n)
{
    const char * s = *ps;
    printf("chars=");
    for (int i=0; i<*n; i++) {
        printf("%c",s[i]);
    }
    printf("\n");
    printf("string=%s\n", s);
}

void print_type(CFI_type_t type) 
{
         if (type==CFI_type_signed_char)          printf("type is %s\n", "signed char");
    else if (type==CFI_type_short)                printf("type is %s\n", "short");
    else if (type==CFI_type_int)                  printf("type is %s\n", "int");
    else if (type==CFI_type_long)                 printf("type is %s\n", "long");
    else if (type==CFI_type_long_long)            printf("type is %s\n", "long long");
    else if (type==CFI_type_size_t)               printf("type is %s\n", "size_t");
    else if (type==CFI_type_int8_t)               printf("type is %s\n", "int8_t");
    else if (type==CFI_type_int16_t)              printf("type is %s\n", "int16_t");
    else if (type==CFI_type_int32_t)              printf("type is %s\n", "int32_t");
    else if (type==CFI_type_int64_t)              printf("type is %s\n", "int64_t");
    else if (type==CFI_type_int_least8_t)         printf("type is %s\n", "int_least8_t");
    else if (type==CFI_type_int_least16_t)        printf("type is %s\n", "int_least16_t");
    else if (type==CFI_type_int_least32_t)        printf("type is %s\n", "int_least32_t");
    else if (type==CFI_type_int_least64_t)        printf("type is %s\n", "int_least64_t");
    else if (type==CFI_type_int_fast8_t)          printf("type is %s\n", "int_fast8_t");
    else if (type==CFI_type_int_fast16_t)         printf("type is %s\n", "int_fast16_t");
    else if (type==CFI_type_int_fast32_t)         printf("type is %s\n", "int_fast32_t");
    else if (type==CFI_type_int_fast64_t)         printf("type is %s\n", "int_fast64_t");
    else if (type==CFI_type_intmax_t)             printf("type is %s\n", "intmax_t");
    else if (type==CFI_type_intptr_t)             printf("type is %s\n", "intptr_t");
    else if (type==CFI_type_ptrdiff_t)            printf("type is %s\n", "ptrdiff_t");
    else if (type==CFI_type_float)                printf("type is %s\n", "float");
    else if (type==CFI_type_double)               printf("type is %s\n", "double");
    else if (type==CFI_type_long_double)          printf("type is %s\n", "long double");
    else if (type==CFI_type_float_Complex)        printf("type is %s\n", "float _Complex");
    else if (type==CFI_type_double_Complex)       printf("type is %s\n", "double _Complex");
    else if (type==CFI_type_long_double_Complex)  printf("type is %s\n", "long double _Complex");
    else if (type==CFI_type_Bool)                 printf("type is %s\n", "Bool");
    else if (type==CFI_type_char)                 printf("type is %s\n", "char");
    else if (type==CFI_type_cptr)                 printf("type is %s\n", "cptr");
#if 1
    // not in F2023
    else if (type==CFI_type_cfunptr)              printf("type is %s\n", "cfunptr");
#endif
    else if (type==CFI_type_struct)               printf("type is %s\n", "struct");
    else if (type==CFI_type_other)                printf("type is %s\n", "other");
    else                                          printf("type is %s (%d)\n", "unknown", (int)type);
}

void print_attribute(CFI_attribute_t attribute)
{
         if (attribute==CFI_attribute_pointer)     printf("attribute is %s\n", "data pointer");
    else if (attribute==CFI_attribute_allocatable) printf("attribute is %s\n", "allocatable");
    else if (attribute==CFI_attribute_other)       printf("attribute is %s\n", "nonallocatable nonpointer");
    else                                           printf("attribute is %s\n", "unknown");

}

void foo(CFI_cdesc_t * desc)
{
    const void * ba = desc->base_addr;
    const size_t el = desc->elem_len;
    const int    rk = desc->rank;
    const int    ty = desc->type;
    printf("base_addr = %p = %ld\n", ba, (long)ba);
    printf("elem_len  = %zu\n", el);
    printf("rank      = %d\n", rk);
    print_type(ty);
    print_attribute(desc->attribute);

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
