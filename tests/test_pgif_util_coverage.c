// SPDX-License-Identifier: MIT

#include <stdio.h>
#include <string.h>

#include "pgif_util.h"

static int fail(const char *label, int rc)
{
    fprintf(stderr, "FAIL: %s rc=%d\n", label, rc);
    return 1;
}

static void init_desc(VAPAA_PGIF_Desc *desc, long long len)
{
    memset(desc, 0, sizeof(*desc));
    desc->tag = VAPAA_PGIF_DESCRIPTOR_TAG;
    desc->rank = 2;
    desc->len = len;
    desc->dim[0].extent = 3;
    desc->dim[0].lstride = 1;
    desc->dim[1].extent = 4;
    desc->dim[1].lstride = 3;
}

static int check_size(MPI_Datatype datatype, int expected_size,
                      const char *label)
{
    int actual_size = -1;
    int rc = MPI_Type_size(datatype, &actual_size);
    if (rc != MPI_SUCCESS) return fail(label, rc);
    if (actual_size != expected_size) return fail(label, actual_size);
    return 0;
}

void pgif_util_coverage(int *ierror)
{
    VAPAA_PGIF_Desc desc;
    VAPAA_PGIF_Desc bad;
    VAPAA_PGIF_Buffer buffer;
    MPI_Datatype datatype = MPI_DATATYPE_NULL;
    int data[64] = {0};
    int rc;

    *ierror = 0;
    init_desc(&desc, (long long) sizeof(int));

    if (!VAPAA_PGIF_is_valid(&desc)) {
        *ierror = fail("valid descriptor", 0);
        return;
    }
    if (!VAPAA_PGIF_is_contiguous(&desc)) {
        *ierror = fail("contiguous descriptor", 0);
        return;
    }
    if (!VAPAA_PGIF_buffer_is_contiguous(&desc)) {
        *ierror = fail("buffer contiguous descriptor", 0);
        return;
    }
    if (VAPAA_PGIF_ADDR(data) != data || VAPAA_PGIF_IN_ADDR(data) != data) {
        *ierror = fail("descriptor address helpers", 0);
        return;
    }

    bad = desc;
    bad.tag = 0;
    if (VAPAA_PGIF_is_valid(&bad)) {
        *ierror = fail("bad tag validation", 0);
        return;
    }
    if (!VAPAA_PGIF_buffer_is_contiguous(&bad)) {
        *ierror = fail("invalid descriptor treated as contiguous", 0);
        return;
    }
    bad = desc;
    bad.rank = VAPAA_PGIF_MAXDIMS + 1;
    if (VAPAA_PGIF_is_valid(&bad)) {
        *ierror = fail("bad rank validation", 0);
        return;
    }
    bad = desc;
    bad.len = 0;
    if (VAPAA_PGIF_is_valid(&bad)) {
        *ierror = fail("bad element length validation", 0);
        return;
    }
    bad = desc;
    bad.dim[0].extent = -1;
    if (VAPAA_PGIF_is_valid(&bad)) {
        *ierror = fail("bad extent validation", 0);
        return;
    }
    bad = desc;
    bad.dim[0].lstride = 0;
    if (VAPAA_PGIF_is_valid(&bad)) {
        *ierror = fail("bad stride validation", 0);
        return;
    }

    rc = VAPAA_PGIF_PREPARE_BUFFER(data, &desc, 12, MPI_INT, false, &buffer);
    if (rc != MPI_SUCCESS) {
        *ierror = fail("prepare contiguous", rc);
        return;
    }
    if (buffer.addr != data || buffer.count != 12 ||
        buffer.datatype != MPI_INT ||
        buffer.owned_datatype != MPI_DATATYPE_NULL) {
        *ierror = fail("prepare contiguous payload", 0);
        return;
    }
    rc = VAPAA_PGIF_RELEASE_BUFFER(&buffer);
    if (rc != MPI_SUCCESS) {
        *ierror = fail("release contiguous", rc);
        return;
    }

    desc.dim[0].extent = 2;
    desc.dim[0].lstride = 2;
    desc.dim[1].extent = 2;
    desc.dim[1].lstride = 8;
    if (VAPAA_PGIF_is_contiguous(&desc)) {
        *ierror = fail("noncontiguous descriptor", 0);
        return;
    }
    rc = VAPAA_PGIF_CREATE_DATATYPE(&desc, 4, MPI_INT, &datatype);
    if (rc != MPI_SUCCESS) {
        *ierror = fail("create noncontiguous datatype", rc);
        return;
    }
    rc = MPI_Type_commit(&datatype);
    if (rc != MPI_SUCCESS) {
        *ierror = fail("commit noncontiguous datatype", rc);
        return;
    }
    if (check_size(datatype, 4 * (int) sizeof(int),
                   "noncontiguous datatype size")) {
        *ierror = 1;
        return;
    }
    rc = MPI_Type_free(&datatype);
    if (rc != MPI_SUCCESS) {
        *ierror = fail("free noncontiguous datatype", rc);
        return;
    }

    rc = VAPAA_PGIF_PREPARE_BUFFER(data, &desc, 4, MPI_INT, false, &buffer);
    if (rc != MPI_SUCCESS) {
        *ierror = fail("prepare noncontiguous", rc);
        return;
    }
    if (buffer.addr != data || buffer.count != 1 ||
        buffer.owned_datatype == MPI_DATATYPE_NULL) {
        *ierror = fail("prepare noncontiguous payload", 0);
        return;
    }
    if (check_size(buffer.datatype, 4 * (int) sizeof(int),
                   "prepared datatype size")) {
        *ierror = 1;
        return;
    }
    rc = VAPAA_PGIF_RELEASE_BUFFER(&buffer);
    if (rc != MPI_SUCCESS) {
        *ierror = fail("release noncontiguous", rc);
        return;
    }

    rc = VAPAA_PGIF_CREATE_DATATYPE(&desc, 0, MPI_INT, &datatype);
    if (rc != MPI_SUCCESS) {
        *ierror = fail("create zero-count datatype", rc);
        return;
    }
    if (check_size(datatype, 0, "zero-count datatype size")) {
        *ierror = 1;
        return;
    }
    rc = MPI_Type_free(&datatype);
    if (rc != MPI_SUCCESS) {
        *ierror = fail("free zero-count datatype", rc);
        return;
    }

    rc = VAPAA_PGIF_CREATE_DATATYPE(&desc, -1, MPI_INT, &datatype);
    if (rc != MPI_ERR_COUNT) {
        *ierror = fail("negative-count datatype", rc);
        return;
    }

    bad = desc;
    bad.tag = 0;
    rc = VAPAA_PGIF_CREATE_DATATYPE(&bad, 1, MPI_INT, &datatype);
    if (rc != MPI_ERR_ARG) {
        *ierror = fail("invalid descriptor datatype", rc);
        return;
    }
}
