#ifndef CFI_UTIL_H
#define CFI_UTIL_H

#include <mpi.h>
#include "ISO_Fortran_binding.h"

int VAPAA_CFI_CREATE_DATATYPE(const CFI_cdesc_t * desc, int count, MPI_Datatype input_datatype, 
                              MPI_Datatype * array_datatype);

#if 0
#include <stdbool.h>
#include <sys/types.h>

bool VAPAA_MPI_DATATYPE_IS_BUILTIN(MPI_Datatype t);
MPI_Datatype VAPAA_CFI_TO_MPI_TYPE(CFI_type_t type);
void VAPAA_CFI_GET_TYPE_NAME(CFI_type_t type, char * name);
void VAPAA_CFI_GET_TYPE_ATTRIBUTE(CFI_attribute_t attribute, char * name);
size_t VAPAA_CFI_GET_TOTAL_ELEMENTS(const CFI_cdesc_t * desc);
void VAPAA_CFI_PRINT_INFO(const CFI_cdesc_t * desc);
int VAPAA_MPIDT_PRINT_INFO(MPI_Datatype dt);

// these work
int VAPAA_CFI_SERIALIZE_SUBARRAY(const CFI_cdesc_t * desc, void * output);
int VAPAA_CFI_DESERIALIZE_SUBARRAY(const void * input, CFI_cdesc_t * desc);

// these do not work
int VAPAA_CFI_SERIALIZE_SUBARRAY_MPIDT_NONCONTIG(const CFI_cdesc_t * desc, void * output, size_t count, MPI_Datatype dt);
int VAPAA_CFI_DESERIALIZE_SUBARRAY_MPIDT_NONCONTIG(const void * input, CFI_cdesc_t * desc, size_t count, MPI_Datatype dt);

// IOV related
//struct iovec * VAPAA_CFI_CREATE_IOV_15D(const CFI_cdesc_t * desc);
//struct iovec * VAPAA_MPIDT_CREATE_IOV(const void * buffer, int count, MPI_Datatype dt);

const void ** VAPAA_CFI_CREATE_ELEMENT_ADDRESSES(const CFI_cdesc_t * desc);
const void ** VAPAA_CFI_CREATE_DATATYPE_ADDRESSES(const void * input[], int count, MPI_Datatype dt);
MPI_Datatype VAPAA_CFI_CREATE_INDEXED_FROM_CFI_AND_MPIDT(const void * input[], int count, MPI_Datatype dt, MPI_Datatype elem_dt);
#endif

#endif // CFI_UTIL_H
