#include <stdio.h>
#include <stdlib.h>
#include "ISO_Fortran_binding.h"

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
    else                                          printf("type is %s\n", "unknown");
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
    printf("base_addr = %p = %ld\n", desc->base_addr, (long)desc->base_addr);
    printf("elem_len  = %zu\n", desc->elem_len);
    printf("rank      = %d\n", (int)desc->rank);
    print_type(desc->type);
    print_attribute(desc->attribute);

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
