// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <limits.h>
#include <stdlib.h>

#include "cfi_util.h"
#include "debug.h"
#include "detect_sentinels.h"
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

int VAPAA_PGIF_buffer_is_contiguous(const VAPAA_PGIF_Desc *desc)
{
    return !VAPAA_PGIF_is_valid(desc) || VAPAA_PGIF_is_contiguous(desc) == 1;
}

void *VAPAA_PGIF_ADDR(void *base)
{
    return C_IS_MPI_BOTTOM(base) ? MPI_BOTTOM : base;
}

void *VAPAA_PGIF_IN_ADDR(void *base)
{
    return C_IS_MPI_IN_PLACE(base) ? MPI_IN_PLACE : VAPAA_PGIF_ADDR(base);
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

static int VAPAA_PGIF_LOGICAL_BYTE_DISPLACEMENT(const VAPAA_PGIF_Desc *desc,
                                                MPI_Aint logical_byte,
                                                int total,
                                                MPI_Aint *displacement)
{
    const MPI_Aint elem_len = (MPI_Aint) desc->len;
    const MPI_Aint total_bytes = (MPI_Aint) total * elem_len;

    if (logical_byte < 0 || logical_byte > total_bytes) {
        return MPI_ERR_ARG;
    }
    if (logical_byte == 0 || total == 0) {
        *displacement = 0;
        return MPI_SUCCESS;
    }
    if (logical_byte == total_bytes) {
        *displacement = VAPAA_PGIF_ELEMENT_DISPLACEMENT(desc, total - 1) +
                        elem_len;
        return MPI_SUCCESS;
    }

    const MPI_Aint elem_index = logical_byte / elem_len;
    const MPI_Aint elem_offset = logical_byte % elem_len;
    *displacement =
        VAPAA_PGIF_ELEMENT_DISPLACEMENT(desc, (int) elem_index) + elem_offset;
    return MPI_SUCCESS;
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
    int total = 0;
    MPI_Aint datatype_lb = 0;
    MPI_Aint datatype_extent = 0;
    int elem_len = 0;
    int blocks = 0;

    int rc = VAPAA_PGIF_VALIDATE(desc);
    if (rc != MPI_SUCCESS) {
        return rc;
    }
    if (count < 0) {
        return MPI_ERR_COUNT;
    }

    rc = VAPAA_PGIF_TOTAL_ELEMENTS(desc, &total);
    if (rc != MPI_SUCCESS) {
        return rc;
    }

    rc = VAPAA_CREATE_DATATYPE_IOV(input_datatype, &iov, &actual_iov_len,
                                   &total_bytes);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }

    rc = PMPI_Type_get_extent(input_datatype, &datatype_lb, &datatype_extent);
    if (rc != MPI_SUCCESS) {
        goto fn_exit;
    }
    (void) datatype_lb;

    elem_len = (int) desc->len;
    if (elem_len <= 0 || elem_len > INT_MAX) {
        rc = MPI_ERR_COUNT;
        goto fn_exit;
    }

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
        MPI_Datatype hindexed = MPI_DATATYPE_NULL;
        MPI_Aint type_extent_bytes = (MPI_Aint) count * datatype_extent;
        MPI_Aint resized_extent = 0;

        rc = VAPAA_PGIF_LOGICAL_BYTE_DISPLACEMENT(desc, type_extent_bytes,
                                                  total, &resized_extent);
        if (rc != MPI_SUCCESS) {
            goto fn_exit;
        }
        if (resized_extent <= 0) {
            rc = MPI_ERR_ARG;
            goto fn_exit;
        }

        rc = PMPI_Type_create_hindexed(blocks, blocklengths, displacements,
                                       MPI_BYTE, &hindexed);
        if (rc != MPI_SUCCESS) {
            goto fn_exit;
        }
        rc = PMPI_Type_create_resized(hindexed, 0, resized_extent,
                                      array_datatype);
        int free_rc = PMPI_Type_free(&hindexed);
        if (rc == MPI_SUCCESS) {
            rc = free_rc;
        }
    }

  fn_exit:
    free(iov);
    free(blocklengths);
    free(displacements);
    return rc;
}

int VAPAA_PGIF_PREPARE_BUFFER(void *base, const VAPAA_PGIF_Desc *desc,
                              int count, MPI_Datatype datatype,
                              bool in_place_allowed,
                              VAPAA_PGIF_Buffer *buffer)
{
    buffer->addr = in_place_allowed ? VAPAA_PGIF_IN_ADDR(base) :
                                      VAPAA_PGIF_ADDR(base);
    buffer->count = count;
    buffer->datatype = datatype;
    buffer->owned_datatype = MPI_DATATYPE_NULL;

    if (buffer->addr == MPI_IN_PLACE || buffer->addr == MPI_BOTTOM ||
        VAPAA_PGIF_buffer_is_contiguous(desc)) {
        return MPI_SUCCESS;
    }

    int rc = VAPAA_PGIF_CREATE_DATATYPE(desc, count, datatype,
                                        &buffer->owned_datatype);
    if (rc != MPI_SUCCESS) {
        return rc;
    }
    rc = PMPI_Type_commit(&buffer->owned_datatype);
    if (rc != MPI_SUCCESS) {
        (void) PMPI_Type_free(&buffer->owned_datatype);
        buffer->owned_datatype = MPI_DATATYPE_NULL;
        return rc;
    }

    buffer->count = 1;
    buffer->datatype = buffer->owned_datatype;
    return MPI_SUCCESS;
}

int VAPAA_PGIF_RELEASE_BUFFER(VAPAA_PGIF_Buffer *buffer)
{
    if (buffer->owned_datatype == MPI_DATATYPE_NULL) {
        return MPI_SUCCESS;
    }

    int rc = PMPI_Type_free(&buffer->owned_datatype);
    buffer->owned_datatype = MPI_DATATYPE_NULL;
    return rc;
}
