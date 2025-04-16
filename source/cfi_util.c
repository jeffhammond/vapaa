// SPDX-License-Identifier: MIT

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <limits.h>

#include <mpi.h>

#include "cfi_util.h"
#include "debug.h"

#define MAYBE_UNUSED __attribute__((unused))

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

static bool VAPAA_MPI_DATATYPE_IS_BUILTIN(MPI_Datatype t)
{
    int ni, na, nd, c;
    int rc = PMPI_Type_get_envelope(t, &ni, &na, &nd, &c);
    VAPAA_Assert(rc == MPI_SUCCESS);
    return (c == MPI_COMBINER_NAMED);
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

// return void* so we do not have to define MPIX_Iov when this function does not work anyways
static void * VAPAA_CREATE_MPIX_IOV(MPI_Datatype dt, size_t * total_len, size_t * total_bytes)
{
#if defined(MPICH) && defined(MPICH_NUMVERSION) && (MPICH_NUMVERSION > 40200000)
    int rc;
    MPI_Count max_iov_bytes=INT_MAX;    // upper bound on the size of the returned iov array (arbitrary for VAPAA)
    MPI_Count iov_len;                  // how many MPIX_Iov fit into the above
    MPI_Count actual_iov_bytes;         // real size of the iov array to be returned
    rc = MPIX_Type_iov_len(dt, max_iov_bytes, &iov_len, &actual_iov_bytes);
    VAPAA_Assert(rc == MPI_SUCCESS);

    MPIX_Iov * iov = malloc(iov_len * sizeof(MPIX_Iov));
    VAPAA_Assert(iov != NULL);

    MPI_Count actual_iov_len;
    rc = MPIX_Type_iov(dt, 0, iov, iov_len, &actual_iov_len);
    VAPAA_Assert(rc == MPI_SUCCESS);

    *total_len   = (size_t)actual_iov_len;
    *total_bytes = (size_t)actual_iov_bytes;

#if 0
    printf("IOV: actual_iov_len=%zd actual_iov_bytes=%zd\n",
            (size_t)actual_iov_len, (size_t)actual_iov_bytes);
#endif

#if 0
    if (iov[0].iov_base != 0) {
        VAPAA_Warning("MPIX_Iov iov_base (%p) is not zero, which is not supported.\n", iov[0].iov_base);
        free(iov);
        return NULL;
    }
#endif

    return iov;
#else
    (void)dt;
    (void)total_len;
    (void)total_bytes;
    #ifdef MPICH_NUMVERSION
        #warning MPICH too old
        VAPAA_Warning("MPICH %s does not have MPIX_Iov support",MPICH_NUMVERSION);
    #else
        #warning Not MPICH
        VAPAA_Warning("Not MPICH so no MPIX_Iov support");
    #endif
    return NULL;
#endif
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
    else                                          snprintf(name,32,"unknown (%8d)", (int)type);
}

MAYBE_UNUSED
static int VAPAA_MPIDT_PRINT_INFO(MPI_Datatype dt)
{
#if defined(MPICH) && defined(MPICH_NUMVERSION) && (MPICH_NUMVERSION > 40200000)
    size_t actual_iov_len, total_bytes;
    MPIX_Iov * iov = VAPAA_CREATE_MPIX_IOV(dt, &actual_iov_len, &total_bytes);
    VAPAA_Assert(iov != NULL);

    for (size_t i=0; i < actual_iov_len; i++) {
        printf("iov[%zu] = { .iov_base = %p = %zd .iov_len = %zu }\n",
                i, iov[i].iov_base, (intptr_t)iov[i].iov_base, iov[i].iov_len );
    }
    free(iov);

    return MPI_SUCCESS;
#else
    (void)dt;
    #ifdef MPICH_NUMVERSION
        #warning MPICH too old
        VAPAA_Warning("MPICH %s does not have MPIX_Iov support",MPICH_NUMVERSION);
    #else
        #warning Not MPICH
        VAPAA_Warning("Not MPICH so no MPIX_Iov support");
    #endif
    return MPI_ERR_INTERN;
#endif
}

static MPI_Datatype VAPAA_CFI_TO_MPI_TYPE(CFI_type_t type)
{
         if (type==CFI_type_signed_char)          return MPI_CHAR;
    else if (type==CFI_type_char)                 return MPI_CHAR;
    else if (type==CFI_type_int8_t)               return MPI_INT8_T;
    else if (type==CFI_type_int16_t)              return MPI_INT16_T;
    else if (type==CFI_type_int32_t)              return MPI_INT32_T;
    else if (type==CFI_type_int64_t)              return MPI_INT64_T;
    else if (type==CFI_type_float)                return MPI_FLOAT;
    else if (type==CFI_type_double)               return MPI_DOUBLE;
    else if (type==CFI_type_float_Complex)        return MPI_C_FLOAT_COMPLEX;
    else if (type==CFI_type_double_Complex)       return MPI_C_DOUBLE_COMPLEX;
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

    const MPI_Datatype element_datatype = VAPAA_CFI_TO_MPI_TYPE(desc->type);
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
#if defined(MPICH) && defined(MPICH_NUMVERSION) && (MPICH_NUMVERSION > 40200000)
    int rc;

    const int elem_len = desc->elem_len;

    size_t actual_iov_len, total_bytes;
    MPIX_Iov * iov = VAPAA_CREATE_MPIX_IOV(input_datatype, &actual_iov_len, &total_bytes);
    VAPAA_Assert(iov != NULL);

    MPI_Aint lb, extent;
    rc = MPI_Type_get_extent(input_datatype, &lb, &extent);
    VAPAA_Assert(rc == MPI_SUCCESS);

#if 0
    rc = VAPAA_MPIDT_PRINT_INFO(input_datatype);
    VAPAA_Assert(rc == MPI_SUCCESS);
    fflush(0);
    usleep(1000);
#endif

    size_t iov_elements = total_bytes / elem_len;
    //printf("iov_elements = %zd\n", iov_elements);

    int * array_of_blocklengths = malloc(count * iov_elements * sizeof(int));
    VAPAA_Assert(array_of_blocklengths != NULL);

    MPI_Aint * array_of_displacements = malloc(count * iov_elements * sizeof(MPI_Aint));
    VAPAA_Assert(array_of_displacements != NULL);

    const void ** input = VAPAA_CFI_CREATE_ELEMENT_ADDRESSES(desc);

    //printf("input[0] = %p = %zd\n", input[0], (intptr_t)input[0]);
    size_t index = 0;
    for (int j=0; j < count; j++) {
        const ptrdiff_t type_displacement = j * extent;
        //printf("type_displacement = %zd\n", type_displacement);
        for (size_t i=0; i < actual_iov_len; i++) {
            const ptrdiff_t iov_displacement = (intptr_t)iov[i].iov_base / elem_len;
            //printf("iov_displacement = %zd\n", iov_displacement);
            for (size_t k=0; k < (size_t)iov[i].iov_len / elem_len; k++) {
                array_of_blocklengths[index] = 1;
                //printf("k = %zd ", k);
                const size_t offset = k + iov_displacement + type_displacement;
                //printf("offset = %zd ", offset);
                array_of_displacements[index] = (intptr_t)input[offset] - (intptr_t)input[0];
                //printf("input[offset] = %p = %zd ", input[offset], (intptr_t)input[offset]);
                //printf("buf = %d ", *(int*)(input[offset]));
                index++;
                //printf("\n");
            }
        }
    }
    free(iov);
    free(input);

    const size_t n = index;
    VAPAA_Assert(n < INT_MAX);

#if 0
    for (size_t i=0; i<n; i++) {
        printf("%zd: BL=%6d, DISP=%12zd\n", i, array_of_blocklengths[i], (ptrdiff_t)array_of_displacements[i]);
    }
#endif

    MPI_Datatype elem_dt = VAPAA_CFI_TO_MPI_TYPE(desc->type);
    rc = PMPI_Type_create_hindexed((int)n, array_of_blocklengths, array_of_displacements,
                                   elem_dt, array_datatype);
    VAPAA_Assert(rc == MPI_SUCCESS);

    free(array_of_blocklengths);
    free(array_of_displacements);

    return MPI_SUCCESS;
#else
    (void)desc;
    (void)count;
    (void)input_datatype;
    (void)array_datatype;
    #ifdef MPICH_NUMVERSION
        #warning MPICH too old
        VAPAA_Warning("MPICH %s does not have MPIX_Iov support",MPICH_NUMVERSION);
    #else
        #warning Not MPICH
        VAPAA_Warning("Not MPICH so no MPIX_Iov support");
    #endif
    return MPI_ERR_INTERN;
#endif
}

// This function does not commit datatypes.  That needs to happen elsewhere.
int VAPAA_CFI_CREATE_DATATYPE(const CFI_cdesc_t * desc, int count, MPI_Datatype input_datatype, 
                              MPI_Datatype * array_datatype)
{
    int rc;

    if ( VAPAA_MPI_DATATYPE_IS_BUILTIN(input_datatype) )
    {
        const int rank     = desc->rank;
        const int elem_len = desc->elem_len;

        const MPI_Datatype element_datatype = VAPAA_CFI_TO_MPI_TYPE(desc->type);

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

            // Check for non-zero lower-bounds, because I do not know how to handle this.
            // Fortunately, I have not found a scenario where this happens (maybe pointers?).
            for (int i=0; i < desc->rank; i++) {
                if (desc->dim[i].lower_bound != 0) {
                    VAPAA_Warning("non-zero lower-bounds (%zd) are not supported.\n", desc->dim[i].lower_bound);
                    //return MPI_ERR_BUFFER;
                }
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
