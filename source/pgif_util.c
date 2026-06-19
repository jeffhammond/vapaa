// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <limits.h>
#include <stdlib.h>

#include "cfi_util.h"
#include "debug.h"
#include "pgif_util.h"

static int VAPAA_PGIF_VALIDATE(const VAPAA_PGIF_Desc *desc)
{
    if (desc == NULL || desc->tag != VAPAA_PGIF_DESCRIPTOR_TAG ||
        desc->rank < 0 || desc->rank > VAPAA_PGIF_MAXDIMS || desc->len <= 0) {
        return MPI_ERR_ARG;
    }

    for (long long i = 0; i < desc->rank; i++) {
        if (desc->dim[i].extent < 0 || desc->dim[i].lstride <= 0) {
            return MPI_ERR_ARG;
        }
    }

    return MPI_SUCCESS;
}

int VAPAA_PGIF_is_valid(const VAPAA_PGIF_Desc *desc)
{
    return VAPAA_PGIF_VALIDATE(desc) == MPI_SUCCESS;
}

static int VAPAA_PGIF_TOTAL_ELEMENTS(const VAPAA_PGIF_Desc *desc, int *total)
{
    long long product = 1;

    for (long long i = 0; i < desc->rank; i++) {
        if (desc->dim[i].extent == 0) {
            *total = 0;
            return MPI_SUCCESS;
        }
        if (product > (long long) INT32_MAX / desc->dim[i].extent) {
            return MPI_ERR_COUNT;
        }
        product *= desc->dim[i].extent;
    }

    if (product > (long long) INT32_MAX) {
        return MPI_ERR_COUNT;
    }
    *total = (int) product;
    return MPI_SUCCESS;
}

int VAPAA_PGIF_is_contiguous(const VAPAA_PGIF_Desc *desc)
{
    if (VAPAA_PGIF_VALIDATE(desc) != MPI_SUCCESS) {
        return 0;
    }

    if (desc->rank == 0) {
        return 1;
    }

    long long expected_stride = 1;
    for (long long i = 0; i < desc->rank; i++) {
        const long long extent = desc->dim[i].extent;
        if (extent == 0) {
            return 1;
        }
        if (extent > 1 && desc->dim[i].lstride != expected_stride) {
            return 0;
        }
        expected_stride *= extent;
    }

    return 1;
}

static MPI_Aint VAPAA_PGIF_ELEMENT_DISPLACEMENT(const VAPAA_PGIF_Desc *desc, int linear_index)
{
    MPI_Aint displacement = 0;
    long long divisor = 1;

    for (long long i = 0; i < desc->rank; i++) {
        const long long extent = desc->dim[i].extent;
        const long long coord = (linear_index / divisor) % extent;
        displacement += (MPI_Aint) (coord * desc->dim[i].lstride * desc->len);
        divisor *= extent;
    }

    return displacement;
}

static int VAPAA_PGIF_APPEND_BLOCK(MPI_Aint **displacements, int **blocklengths,
                                   int *blocks, int *capacity,
                                   MPI_Aint displacement, MPI_Aint length)
{
    if (length == 0) {
        return MPI_SUCCESS;
    }
    if (length < 0 || length > INT_MAX) {
        return MPI_ERR_COUNT;
    }

    if (*blocks > 0 &&
        (*displacements)[*blocks - 1] + (*blocklengths)[*blocks - 1] ==
            displacement) {
        if ((*blocklengths)[*blocks - 1] > INT_MAX - (int) length) {
            return MPI_ERR_COUNT;
        }
        (*blocklengths)[*blocks - 1] += (int) length;
        return MPI_SUCCESS;
    }

    if (*blocks == *capacity) {
        int new_capacity = *capacity == 0 ? 16 : *capacity * 2;
        if (new_capacity < *capacity || new_capacity > INT_MAX / 2) {
            return MPI_ERR_COUNT;
        }
        MPI_Aint *new_displacements =
            realloc(*displacements, (size_t) new_capacity * sizeof(**displacements));
        if (new_displacements == NULL) {
            return MPI_ERR_NO_MEM;
        }
        int *new_blocklengths =
            realloc(*blocklengths, (size_t) new_capacity * sizeof(**blocklengths));
        if (new_blocklengths == NULL) {
            return MPI_ERR_NO_MEM;
        }
        *displacements = new_displacements;
        *blocklengths = new_blocklengths;
        *capacity = new_capacity;
    }

    (*displacements)[*blocks] = displacement;
    (*blocklengths)[*blocks] = (int) length;
    (*blocks)++;
    return MPI_SUCCESS;
}

static int VAPAA_PGIF_APPEND_LOGICAL_BYTES(const VAPAA_PGIF_Desc *desc,
                                           MPI_Aint logical_byte,
                                           MPI_Aint byte_count, int total,
                                           MPI_Aint **displacements,
                                           int **blocklengths, int *blocks,
                                           int *capacity)
{
    const MPI_Aint elem_len = (MPI_Aint) desc->len;

    while (byte_count > 0) {
        const MPI_Aint elem_index = logical_byte / elem_len;
        const MPI_Aint elem_offset = logical_byte % elem_len;
        if (elem_index < 0 || elem_index >= (MPI_Aint) total) {
            return MPI_ERR_ARG;
        }

        MPI_Aint chunk = elem_len - elem_offset;
        if (chunk > byte_count) {
            chunk = byte_count;
        }

        const MPI_Aint displacement =
            VAPAA_PGIF_ELEMENT_DISPLACEMENT(desc, (int) elem_index) + elem_offset;
        int rc = VAPAA_PGIF_APPEND_BLOCK(displacements, blocklengths, blocks,
                                         capacity, displacement, chunk);
        if (rc != MPI_SUCCESS) {
            return rc;
        }

        logical_byte += chunk;
        byte_count -= chunk;
    }

    return MPI_SUCCESS;
}

int VAPAA_PGIF_CREATE_DATATYPE(const VAPAA_PGIF_Desc *desc, int count,
                               MPI_Datatype input_datatype,
                               MPI_Datatype *array_datatype)
{
    VAPAA_Iov *iov = NULL;
    size_t actual_iov_len = 0;
    size_t total_bytes = 0;
    int *blocklengths = NULL;
    MPI_Aint *displacements = NULL;
    int capacity = 0;

    int rc = VAPAA_PGIF_VALIDATE(desc);
    if (rc != MPI_SUCCESS) {
        return rc;
    }
    if (count < 0) {
        return MPI_ERR_COUNT;
    }

    int total = 0;
    rc = VAPAA_PGIF_TOTAL_ELEMENTS(desc, &total);
    if (rc != MPI_SUCCESS) {
        return rc;
    }

    rc = VAPAA_CREATE_DATATYPE_IOV(input_datatype, &iov, &actual_iov_len,
                                   &total_bytes);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }

    MPI_Aint datatype_lb = 0;
    MPI_Aint datatype_extent = 0;
    rc = PMPI_Type_get_extent(input_datatype, &datatype_lb, &datatype_extent);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }
    (void) datatype_lb;

    const int elem_len = (int) desc->len;
    if (elem_len <= 0 || elem_len > INT_MAX) {
        rc = MPI_ERR_COUNT;
        goto fn_exit;
    }

    int blocks = 0;
    for (int j = 0; j < count; j++) {
        const MPI_Aint type_displacement = (MPI_Aint) j * datatype_extent;
        for (size_t i = 0; i < actual_iov_len; i++) {
            rc = VAPAA_PGIF_APPEND_LOGICAL_BYTES(
                desc, type_displacement + iov[i].iov_base, iov[i].iov_len,
                total, &displacements, &blocklengths, &blocks, &capacity);
            if (rc != MPI_SUCCESS) {
                goto fn_exit;
            }
        }
    }

    if (blocks == 0) {
        rc = PMPI_Type_contiguous(0, MPI_BYTE, array_datatype);
    } else {
        rc = PMPI_Type_create_hindexed(blocks, blocklengths, displacements,
                                       MPI_BYTE, array_datatype);
    }

  fn_exit:
    free(iov);
    free(blocklengths);
    free(displacements);
    return rc;
}
