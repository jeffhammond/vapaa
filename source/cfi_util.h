#include "ISO_Fortran_binding.h"

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

