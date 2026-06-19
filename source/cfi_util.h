#ifndef CFI_UTIL_H
#define CFI_UTIL_H

#include <mpi.h>
#include "ISO_Fortran_binding.h"

static inline int VAPAA_CFI_is_contiguous(const CFI_cdesc_t *desc)
{
    if (desc == NULL) {
        return 0;
    }

    if (desc->rank == 0) {
        return 1;
    }

    CFI_index_t expected_stride = (CFI_index_t)desc->elem_len;
    for (CFI_rank_t i = 0; i < desc->rank; i++) {
        const CFI_index_t extent = desc->dim[i].extent;
        if (extent == 0) {
            return 1;
        }
        if (extent > 1 && desc->dim[i].sm != expected_stride) {
            return 0;
        }
        expected_stride *= extent;
    }

    return 1;
}

int VAPAA_CFI_CREATE_DATATYPE(const CFI_cdesc_t * desc, int count, MPI_Datatype input_datatype, 
                              MPI_Datatype * array_datatype);

void VAPAA_CFI_DATATYPE_DIAGNOSTICS_INIT(void);
void VAPAA_CFI_SET_FORTRAN_TYPE_SIZES(int logical_size, int integer_size,
                                      int real_size, int double_precision_size);
void VAPAA_CFI_WARN_DATATYPE_MISMATCH(const CFI_cdesc_t *desc, MPI_Datatype datatype,
                                      const char *mpi_function);
#define VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(desc, datatype) \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH((desc), (datatype), __func__)

#endif // CFI_UTIL_H
