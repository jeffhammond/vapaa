#include <stdio.h>
#include <limits.h>

#include "cfi_util.h"
#include "debug.h"

bool VAPAA_MPI_DATATYPE_IS_BUILTIN(MPI_Datatype t)
{
    int ni, na, nd, c;
    int rc = PMPI_Type_get_envelope(t, &ni, &na, &nd, &c);
    return (rc == MPI_SUCCESS && c == MPI_COMBINER_NAMED);
}

MPI_Datatype VAPAA_CFI_TO_MPI_TYPE(CFI_type_t type)
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

void VAPAA_CFI_GET_TYPE_ATTRIBUTE(CFI_attribute_t attribute, char * name)
{
         if (attribute==CFI_attribute_pointer)     snprintf(name,32,"%s", "data pointer");
    else if (attribute==CFI_attribute_allocatable) snprintf(name,32,"%s", "allocatable");
    else if (attribute==CFI_attribute_other)       snprintf(name,32,"%s", "nonallocatable nonpointer");
    else                                           snprintf(name,32,"%s", "unknown CFI type attribute");

}

void VAPAA_CFI_GET_TYPE_NAME(CFI_type_t type, char * name)
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

void VAPAA_CFI_PRINT_INFO(CFI_cdesc_t * desc)
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

// this function only handles the case where the datatype passed to the communication function
// is a named aka pre-defined aka built-in datatype, corresponding to the elements of the array.
int VAPAA_CFI_CREATE_DATATYPE(CFI_cdesc_t * desc, ssize_t count, MPI_Datatype input_datatype, 
                              MPI_Datatype * array_datatype)
{
    // this is the wrong place to check this, but it does not hurt here
    if (count > INT_MAX) {
#ifndef VAPAA_SUPPRESS_INTERNAL_MESSAGES
        fprintf(stderr, "MPI F08: count (%zd) > INT_MAX.\n", count);
#endif
        return MPI_ERR_COUNT;
    }

    if ( ! VAPAA_MPI_DATATYPE_IS_BUILTIN(input_datatype) ) {
#ifndef VAPAA_SUPPRESS_INTERNAL_MESSAGES
        fprintf(stderr, "MPI F08: input datatype is not a named datatype.\n");
#endif
        return MPI_ERR_ARG;
    }

    // this function is called after the descriptor is determined
    // to be non-contiguous, so we do not need to handle that case.

    const int     rank     = desc->rank;
    const ssize_t elem_len = desc->elem_len;

    int rc = MPI_SUCCESS;
    const MPI_Datatype element_datatype = VAPAA_CFI_TO_MPI_TYPE(desc->type);

    // count up the total number of elements in the CFI array
    ssize_t total_elems = 1;
    for (CFI_rank_t i=0; i < rank; i++) {
        const ssize_t extent = desc->dim[i].extent;
        total_elems *= extent;

        // detect large-count problems
        if (extent > INT_MAX) {
#ifndef VAPAA_SUPPRESS_INTERNAL_MESSAGES
            fprintf(stderr, "MPI F08: extent (%zd) > INT_MAX.\n", extent);
#endif
            return MPI_ERR_COUNT;
        }

        // detect large-count problems - test here so we catch cases where the last extent is -1
        if (total_elems > INT_MAX) {
    #ifndef VAPAA_SUPPRESS_INTERNAL_MESSAGES
            fprintf(stderr, "MPI F08: total_elems (%zd) > INT_MAX.\n", total_elems);
    #endif
            return MPI_ERR_COUNT;
        }
    }

    // detect invalid input that will cause buffer overrun
    if (count > total_elems) {
#ifndef VAPAA_SUPPRESS_INTERNAL_MESSAGES
        fprintf(stderr, "MPI F08: count (%zd) > total_elems (%zd).\n", count, total_elems);
#endif
        return MPI_ERR_ARG;
    }

    // "In a C descriptor of an assumed-size array, the extent member of the 
    //  last element of the dim member has the value −1."
    // Using extent[rank-1] is dangerous and we should never do it.

    switch (rank) {

        case 1:
        {
            // 1D array non-contiguous array can only be single elements, e.g.
            //    X(1:end:stride) where stride > 1
            const int      num_blocks = count;
            const MPI_Aint stride     = desc->dim[0].sm;
            rc = PMPI_Type_create_hvector(num_blocks, 1, stride, element_datatype, array_datatype);
            if (rc) return rc;
            break;
        }

        case 2:
        {
            // 2D array non-contiguous array will be a vector of blocks e.g.
            //    X(1:e0:s0,b1:e1:s1)
            // There are 2 cases to support:
            //    1: the count is an even multiple of extent[0], which is a vector or a vector of vectors
            //    2: the count is not an even multiple of extent[0], which is another type: struct or (h)indexed
            const int extent0 = desc->dim[0].extent;
            if (count % extent0 == 0) {
                const MPI_Aint stride0 = desc->dim[0].sm;
                // if the first dimension is contiguous, we only need one datatype
                if (stride0 == elem_len) {
                    const MPI_Aint stride1 = desc->dim[1].sm;
                    rc = PMPI_Type_create_hvector(count / extent0, extent0, stride1, element_datatype, array_datatype);
                    if (rc) return rc;
                }
                // if the first dimension is non-contiguous, create a temp for it,
                // then create a vector of those for the array
                else {
                    MPI_Datatype temp_datatype = MPI_DATATYPE_NULL;
                    rc = PMPI_Type_create_hvector(extent0, 1, stride0, element_datatype, &temp_datatype);
                    if (rc) return rc;

                    const MPI_Aint stride1 = desc->dim[0].sm;
                    rc = PMPI_Type_create_hvector(count / extent0, 1, stride1, temp_datatype, array_datatype);
                    if (rc) return rc;

                    rc = PMPI_Type_free(&temp_datatype);
                    if (rc) return rc;
                }
            } else {
#ifndef VAPAA_SUPPRESS_INTERNAL_MESSAGES
                fprintf(stderr, "MPI F08: 2D array case where count (%zd) is not cleanly divisible by extent[0] (%d)\n",
                                count, extent0);
#endif
                return MPI_ERR_ARG;
            }
            break;
        }

        default:
            return MPI_ERR_ARG;
            break;
    }

    // verify that the type we have created holds the correct number of elements
    {
        int type_size;
        PMPI_Type_size(*array_datatype, &type_size);
        if (type_size != count * elem_len) {
#ifndef VAPAA_SUPPRESS_INTERNAL_MESSAGES
            fprintf(stderr, "MPI F08: type_size (%d) != count (%zd) * elem_len (%zd).\n", type_size, count, elem_len);
#endif
            return MPI_ERR_INTERN;
        }   
    }
    return MPI_SUCCESS;
}
