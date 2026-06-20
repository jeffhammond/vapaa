// SPDX-License-Identifier: MIT

#define _POSIX_C_SOURCE 200112L

#include <complex.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wchar.h>

#include <mpi.h>

#include "ISO_Fortran_binding.h"
#include "cfi_util.h"

static int errors = 0;

static void fail(const char *label, int rc)
{
    fprintf(stderr, "FAIL: %s rc=%d\n", label, rc);
    errors++;
}

static void check_mpi(int rc, const char *label)
{
    if (rc != MPI_SUCCESS) {
        fail(label, rc);
    }
}

static void init_desc(CFI_cdesc_t *desc, size_t desc_size, void *base,
                      size_t elem_len, CFI_type_t type, CFI_rank_t rank,
                      const CFI_index_t extents[],
                      const CFI_index_t strides[])
{
    memset(desc, 0, desc_size);
    desc->base_addr = base;
    desc->elem_len = elem_len;
    desc->version = CFI_VERSION;
    desc->rank = rank;
    desc->attribute = CFI_attribute_other;
    desc->type = type;
    for (CFI_rank_t i = 0; i < rank; i++) {
        desc->dim[i].lower_bound = 0;
        desc->dim[i].extent = extents[i];
        desc->dim[i].sm = strides[i];
    }
}

static void init_1d(CFI_cdesc_t *desc, size_t desc_size, void *base,
                    size_t elem_len, CFI_type_t type, CFI_index_t extent,
                    CFI_index_t stride)
{
    CFI_index_t extents[1] = {extent};
    CFI_index_t strides[1] = {stride};

    init_desc(desc, desc_size, base, elem_len, type, 1, extents, strides);
}

static void check_iov(MPI_Datatype datatype, const char *label)
{
    VAPAA_Iov *iov = NULL;
    size_t iov_len = 0;
    size_t iov_bytes = 0;
    MPI_Count type_size = 0;
    int rc = MPI_Type_size_x(datatype, &type_size);

    check_mpi(rc, label);
    if (rc != MPI_SUCCESS) {
        return;
    }

    rc = VAPAA_CREATE_DATATYPE_IOV(datatype, &iov, &iov_len, &iov_bytes);
    check_mpi(rc, label);
    if (rc == MPI_SUCCESS && iov_bytes != (size_t)type_size) {
        fail(label, (int)iov_bytes);
    }
    free(iov);
}

static void commit_and_check(MPI_Datatype *datatype, const char *label)
{
    int rc = MPI_Type_commit(datatype);
    check_mpi(rc, label);
    if (rc == MPI_SUCCESS) {
        check_iov(*datatype, label);
        rc = MPI_Type_free(datatype);
        check_mpi(rc, label);
    }
}

static void create_cfi_type(CFI_cdesc_t *desc, int count,
                            MPI_Datatype input_datatype, const char *label)
{
    MPI_Datatype datatype = MPI_DATATYPE_NULL;
    int rc = VAPAA_CFI_CREATE_DATATYPE(desc, count, input_datatype,
                                       &datatype);

    check_mpi(rc, label);
    if (rc == MPI_SUCCESS) {
        rc = MPI_Type_commit(&datatype);
        check_mpi(rc, label);
        if (rc == MPI_SUCCESS) {
            int type_size = -1;
            rc = MPI_Type_size(datatype, &type_size);
            check_mpi(rc, label);
            if (type_size != count * (int)desc->elem_len) {
                fail(label, type_size);
            }
        }
        rc = MPI_Type_free(&datatype);
        check_mpi(rc, label);
    }
}

static void warn_desc(CFI_type_t type, size_t elem_len, MPI_Datatype datatype,
                      const char *label)
{
    unsigned char bytes[64] = {0};
    CFI_CDESC_T(1) storage;
    CFI_cdesc_t *desc = (CFI_cdesc_t *)&storage;

    if (elem_len > sizeof(bytes)) {
        elem_len = sizeof(bytes);
    }
    init_1d(desc, sizeof(storage), bytes, elem_len, type, 1,
            (CFI_index_t)elem_len);
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, datatype, label);
}

static void warn_type_name(CFI_type_t type, size_t elem_len,
                           const char *label)
{
    MPI_Datatype mismatch = (elem_len == sizeof(double)) ? MPI_INT
                                                        : MPI_DOUBLE;

    warn_desc(type, elem_len, mismatch, label);
}

static void run_warning_matrix(void)
{
    int i = 1;
    long l = 1;
    long long ll = 1;
    short s = 1;
    signed char sc = 1;
    int8_t i8 = 1;
    int16_t i16 = 1;
    int32_t i32 = 1;
    int64_t i64 = 1;
    intptr_t ip = 1;
    ptrdiff_t pd = 1;
    MPI_Aint aint_value = 1;
    MPI_Count count_value = 1;
    MPI_Offset offset_value = 1;
    float r = 1.0f;
    double d = 1.0;
    long double ld = 1.0L;
    _Bool b = 1;
    char c = 'x';
    wchar_t wc = L'x';
    float _Complex z = 1.0f + 2.0f * I;
    double _Complex zz = 1.0 + 2.0 * I;
    long double _Complex zld = 1.0L + 2.0L * I;
    CFI_CDESC_T(1) storage;
    CFI_cdesc_t *desc = (CFI_cdesc_t *)&storage;
    MPI_Datatype vector = MPI_DATATYPE_NULL;
    int blocklengths[2] = {1, 1};
    int rc;

    setenv("VAPAA_WARN_CFI_DATATYPE_MISMATCH", "off", 1);
    setenv("VAPAA_CHECK_CFI_USER_DATATYPE_MISMATCH", "off", 1);
    VAPAA_CFI_DATATYPE_DIAGNOSTICS_INIT();
    init_1d(desc, sizeof(storage), &i, sizeof(i), CFI_type_int, 1, sizeof(i));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_DOUBLE, "test-disabled");

    setenv("VAPAA_WARN_CFI_DATATYPE_MISMATCH", "surprising", 1);
    setenv("VAPAA_CHECK_CFI_USER_DATATYPE_MISMATCH", "surprising", 1);
    VAPAA_CFI_DATATYPE_DIAGNOSTICS_INIT();
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(NULL, MPI_INT, "test-null-desc");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_DATATYPE_NULL,
                                     "test-null-datatype");

    setenv("VAPAA_WARN_CFI_DATATYPE_MISMATCH", "1", 1);
    setenv("VAPAA_CHECK_CFI_USER_DATATYPE_MISMATCH", "1", 1);
    VAPAA_CFI_DATATYPE_DIAGNOSTICS_INIT();
    VAPAA_CFI_SET_FORTRAN_TYPE_SIZES((int)sizeof(_Bool), (int)sizeof(int),
                                     (int)sizeof(float), (int)sizeof(double));

    init_1d(desc, sizeof(storage), &i, 0, CFI_type_int, 1, sizeof(i));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INT, "test-no-elem-len");
    init_1d(desc, sizeof(storage), &i, sizeof(i), (CFI_type_t)0, 1,
            sizeof(i));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INT, "test-no-cfi-type");
#ifdef CFI_type_other
    init_1d(desc, sizeof(storage), &i, sizeof(i), CFI_type_other, 1,
            sizeof(i));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INT, "test-other-type");
#endif
#ifdef CFI_type_struct
    init_1d(desc, sizeof(storage), &i, sizeof(i), CFI_type_struct, 1,
            sizeof(i));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INT, "test-struct-type");
#endif

    init_1d(desc, sizeof(storage), &i, sizeof(i), CFI_type_int, 1, sizeof(i));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INT, "test-int");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INTEGER, "test-integer");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INTEGER4, "test-integer4");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INT32_T, "test-int32");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_LOGICAL, "test-logical");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_AINT, "test-aint");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_COUNT, "test-count");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_OFFSET, "test-offset");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_DOUBLE, "test-int-mismatch");

    init_1d(desc, sizeof(storage), &sc, sizeof(sc), CFI_type_signed_char, 1,
            sizeof(sc));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_SIGNED_CHAR,
                                     "test-signed-char");
    init_1d(desc, sizeof(storage), &s, sizeof(s), CFI_type_short, 1,
            sizeof(s));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_SHORT, "test-short");
    init_1d(desc, sizeof(storage), &ll, sizeof(ll), CFI_type_long_long, 1,
            sizeof(ll));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_LONG_LONG_INT,
                                     "test-long-long");
#ifdef MPI_LONG_LONG
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_LONG_LONG,
                                     "test-mpi-long-long");
#endif

    init_1d(desc, sizeof(storage), &l, sizeof(l), CFI_type_long, 1, sizeof(l));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_LONG, "test-long");

    init_1d(desc, sizeof(storage), &i8, sizeof(i8), CFI_type_int8_t, 1,
            sizeof(i8));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INT8_T, "test-int8");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INTEGER1, "test-integer1");
    init_1d(desc, sizeof(storage), &i16, sizeof(i16), CFI_type_int16_t, 1,
            sizeof(i16));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INT16_T, "test-int16");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INTEGER2, "test-integer2");
    init_1d(desc, sizeof(storage), &i32, sizeof(i32), CFI_type_int32_t, 1,
            sizeof(i32));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INT32_T, "test-int32-exact");
    init_1d(desc, sizeof(storage), &i64, sizeof(i64), CFI_type_int64_t, 1,
            sizeof(i64));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INT64_T, "test-int64");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_INTEGER8, "test-integer8");
#ifdef CFI_type_intptr_t
    init_1d(desc, sizeof(storage), &ip, sizeof(ip), CFI_type_intptr_t, 1,
            sizeof(ip));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_AINT, "test-intptr-aint");
#endif
#ifdef CFI_type_ptrdiff_t
    init_1d(desc, sizeof(storage), &pd, sizeof(pd), CFI_type_ptrdiff_t, 1,
            sizeof(pd));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_COUNT, "test-ptrdiff-count");
#endif

    init_1d(desc, sizeof(storage), &aint_value, sizeof(aint_value),
            CFI_type_long, 1, sizeof(aint_value));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_AINT, "test-mpi-aint");
    init_1d(desc, sizeof(storage), &count_value, sizeof(count_value),
            CFI_type_long_long, 1, sizeof(count_value));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_COUNT, "test-mpi-count");
    init_1d(desc, sizeof(storage), &offset_value, sizeof(offset_value),
            CFI_type_long_long, 1, sizeof(offset_value));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_OFFSET, "test-mpi-offset");

    init_1d(desc, sizeof(storage), &b, sizeof(b), CFI_type_Bool, 1, sizeof(b));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_C_BOOL, "test-bool");

    init_1d(desc, sizeof(storage), &r, sizeof(r), CFI_type_float, 1, sizeof(r));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_FLOAT, "test-float");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_REAL, "test-real");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_REAL4, "test-real4");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_2REAL, "test-2real");

    init_1d(desc, sizeof(storage), &d, sizeof(d), CFI_type_double, 1,
            sizeof(d));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_DOUBLE, "test-double");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_DOUBLE_PRECISION,
                                     "test-double-precision");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_REAL8, "test-real8");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_2DOUBLE_PRECISION,
                                     "test-2double-precision");

    init_1d(desc, sizeof(storage), &ld, sizeof(ld), CFI_type_long_double, 1,
            sizeof(ld));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_LONG_DOUBLE,
                                     "test-long-double");

    init_1d(desc, sizeof(storage), &z, sizeof(z), CFI_type_float_Complex, 1,
            sizeof(z));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_COMPLEX, "test-complex");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_C_COMPLEX,
                                     "test-c-complex");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_C_FLOAT_COMPLEX,
                                     "test-c-float-complex");

    init_1d(desc, sizeof(storage), &zz, sizeof(zz), CFI_type_double_Complex, 1,
            sizeof(zz));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_DOUBLE_COMPLEX,
                                     "test-double-complex");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_COMPLEX16,
                                     "test-complex16");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_C_DOUBLE_COMPLEX,
                                     "test-c-double-complex");

    init_1d(desc, sizeof(storage), &zld, sizeof(zld),
            CFI_type_long_double_Complex, 1, sizeof(zld));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_C_LONG_DOUBLE_COMPLEX,
                                     "test-c-long-double-complex");

    init_1d(desc, sizeof(storage), &c, sizeof(c), CFI_type_char, 1, sizeof(c));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_CHAR, "test-char");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_CHARACTER, "test-character");
#ifdef CFI_type_ucs4_char
    init_1d(desc, sizeof(storage), &wc, sizeof(wc), CFI_type_ucs4_char, 1,
            sizeof(wc));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_WCHAR, "test-wchar");
#endif

    init_1d(desc, sizeof(storage), &i, sizeof(i), CFI_type_int, 1, sizeof(i));
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_PACKED, "test-packed");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_2INTEGER, "test-2integer");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_2INT, "test-2int");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_BYTE, "test-byte-name");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_FLOAT_INT,
                                     "test-float-int-name");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_DOUBLE_INT,
                                     "test-double-int-name");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_LONG_INT,
                                     "test-long-int-name");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_SHORT_INT,
                                     "test-short-int-name");
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, MPI_LONG_DOUBLE_INT,
                                     "test-long-double-int-name");

    warn_type_name(CFI_type_signed_char, sizeof(signed char),
                   "name-signed-char");
    warn_type_name(CFI_type_short, sizeof(short), "name-short");
    warn_type_name(CFI_type_int, sizeof(int), "name-int");
    warn_type_name(CFI_type_long, sizeof(long), "name-long");
    warn_type_name(CFI_type_long_long, sizeof(long long), "name-long-long");
    warn_type_name(CFI_type_size_t, sizeof(size_t), "name-size-t");
    warn_type_name(CFI_type_int8_t, sizeof(int8_t), "name-int8");
    warn_type_name(CFI_type_int16_t, sizeof(int16_t), "name-int16");
    warn_type_name(CFI_type_int32_t, sizeof(int32_t), "name-int32");
    warn_type_name(CFI_type_int64_t, sizeof(int64_t), "name-int64");
    warn_type_name(CFI_type_intmax_t, sizeof(intmax_t), "name-intmax");
#ifdef CFI_type_intptr_t
    warn_type_name(CFI_type_intptr_t, sizeof(intptr_t), "name-intptr");
#endif
#ifdef CFI_type_ptrdiff_t
    warn_type_name(CFI_type_ptrdiff_t, sizeof(ptrdiff_t), "name-ptrdiff");
#endif
    warn_type_name(CFI_type_float, sizeof(float), "name-float");
    warn_type_name(CFI_type_double, sizeof(double), "name-double");
    warn_type_name(CFI_type_long_double, sizeof(long double),
                   "name-long-double");
    warn_type_name(CFI_type_float_Complex, sizeof(float _Complex),
                   "name-float-complex");
    warn_type_name(CFI_type_double_Complex, sizeof(double _Complex),
                   "name-double-complex");
    warn_type_name(CFI_type_long_double_Complex,
                   sizeof(long double _Complex),
                   "name-long-double-complex");
    warn_type_name(CFI_type_Bool, sizeof(_Bool), "name-bool");
    warn_type_name(CFI_type_char, sizeof(char), "name-char");
    warn_type_name(CFI_type_cptr, sizeof(void *), "name-cptr");
    warn_desc((CFI_type_t)999999, sizeof(int), MPI_DOUBLE, "name-unknown");

    init_1d(desc, sizeof(storage), &i, sizeof(i), CFI_type_int, 1, sizeof(i));
    rc = MPI_Type_indexed(2, blocklengths, blocklengths, MPI_INT, &vector);
    check_mpi(rc, "MPI_Type_indexed warning vector");
    if (rc == MPI_SUCCESS) {
        rc = MPI_Type_commit(&vector);
        check_mpi(rc, "MPI_Type_commit warning vector");
        VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, vector, "test-user-vector");
        rc = MPI_Type_free(&vector);
        check_mpi(rc, "MPI_Type_free warning vector");
    }
}

static void run_iov_combiner_matrix(void)
{
    MPI_Datatype dt = MPI_DATATYPE_NULL;
    MPI_Datatype dup = MPI_DATATYPE_NULL;
    MPI_Datatype resized = MPI_DATATYPE_NULL;
    int blocklengths[3] = {1, 2, 1};
    int displs[3] = {0, 3, 7};
    MPI_Aint adispls[3] = {0, 12, 32};
    MPI_Datatype types[3] = {MPI_INT, MPI_DOUBLE, MPI_CHAR};
    int sizes[2] = {5, 6};
    int subsizes[2] = {2, 3};
    int starts[2] = {1, 2};
    int rc;

    check_iov(MPI_INT, "iov named");

    rc = MPI_Type_dup(MPI_INT, &dup);
    check_mpi(rc, "MPI_Type_dup");
    if (rc == MPI_SUCCESS) {
        commit_and_check(&dup, "iov dup");
    }

    rc = MPI_Type_contiguous(4, MPI_INT, &dt);
    check_mpi(rc, "MPI_Type_contiguous");
    if (rc == MPI_SUCCESS) {
        commit_and_check(&dt, "iov contiguous");
    }

    rc = MPI_Type_vector(3, 2, 5, MPI_INT, &dt);
    check_mpi(rc, "MPI_Type_vector");
    if (rc == MPI_SUCCESS) {
        commit_and_check(&dt, "iov vector");
    }

    rc = MPI_Type_create_hvector(3, 2, 20, MPI_INT, &dt);
    check_mpi(rc, "MPI_Type_create_hvector");
    if (rc == MPI_SUCCESS) {
        commit_and_check(&dt, "iov hvector");
    }

    rc = MPI_Type_indexed(3, blocklengths, displs, MPI_INT, &dt);
    check_mpi(rc, "MPI_Type_indexed");
    if (rc == MPI_SUCCESS) {
        commit_and_check(&dt, "iov indexed");
    }

    rc = MPI_Type_create_hindexed(3, blocklengths, adispls, MPI_INT, &dt);
    check_mpi(rc, "MPI_Type_create_hindexed");
    if (rc == MPI_SUCCESS) {
        commit_and_check(&dt, "iov hindexed");
    }

    rc = MPI_Type_create_indexed_block(3, 2, displs, MPI_INT, &dt);
    check_mpi(rc, "MPI_Type_create_indexed_block");
    if (rc == MPI_SUCCESS) {
        commit_and_check(&dt, "iov indexed block");
    }

    rc = MPI_Type_create_hindexed_block(3, 2, adispls, MPI_INT, &dt);
    check_mpi(rc, "MPI_Type_create_hindexed_block");
    if (rc == MPI_SUCCESS) {
        commit_and_check(&dt, "iov hindexed block");
    }

    rc = MPI_Type_create_struct(3, blocklengths, adispls, types, &dt);
    check_mpi(rc, "MPI_Type_create_struct");
    if (rc == MPI_SUCCESS) {
        commit_and_check(&dt, "iov struct");
    }

    rc = MPI_Type_create_subarray(2, sizes, subsizes, starts, MPI_ORDER_C,
                                  MPI_INT, &dt);
    check_mpi(rc, "MPI_Type_create_subarray C");
    if (rc == MPI_SUCCESS) {
        commit_and_check(&dt, "iov subarray C");
    }

    rc = MPI_Type_create_subarray(2, sizes, subsizes, starts,
                                  MPI_ORDER_FORTRAN, MPI_INT, &dt);
    check_mpi(rc, "MPI_Type_create_subarray Fortran");
    if (rc == MPI_SUCCESS) {
        commit_and_check(&dt, "iov subarray Fortran");
    }

    rc = MPI_Type_contiguous(2, MPI_INT, &dt);
    check_mpi(rc, "MPI_Type_contiguous for resized");
    if (rc == MPI_SUCCESS) {
        rc = MPI_Type_create_resized(dt, 4, 128, &resized);
        check_mpi(rc, "MPI_Type_create_resized");
        rc = MPI_Type_free(&dt);
        check_mpi(rc, "MPI_Type_free resized child");
        if (resized != MPI_DATATYPE_NULL) {
            commit_and_check(&resized, "iov resized");
        }
    }

}

static void run_cfi_create_matrix(void)
{
    int data[512] = {0};
    CFI_CDESC_T(1) d1_storage;
    CFI_CDESC_T(2) d2_storage;
    CFI_CDESC_T(3) d3_storage;
    CFI_CDESC_T(4) d4_storage;
    CFI_CDESC_T(14) d14_storage;
#if CFI_MAX_RANK >= 15
    CFI_CDESC_T(15) d15_storage;
#endif
    CFI_cdesc_t *d1 = (CFI_cdesc_t *)&d1_storage;
    CFI_cdesc_t *d2 = (CFI_cdesc_t *)&d2_storage;
    CFI_cdesc_t *d3 = (CFI_cdesc_t *)&d3_storage;
    CFI_cdesc_t *d4 = (CFI_cdesc_t *)&d4_storage;
    CFI_cdesc_t *d14 = (CFI_cdesc_t *)&d14_storage;
#if CFI_MAX_RANK >= 15
    CFI_cdesc_t *d15 = (CFI_cdesc_t *)&d15_storage;
#endif
    CFI_index_t e1[1] = {5};
    CFI_index_t s1[1] = {2 * (CFI_index_t)sizeof(int)};
    CFI_index_t e2[2] = {3, 4};
    CFI_index_t s2_contig_first[2] = {sizeof(int), 8 * (CFI_index_t)sizeof(int)};
    CFI_index_t s2_strided_first[2] = {2 * (CFI_index_t)sizeof(int),
                                       16 * (CFI_index_t)sizeof(int)};
    CFI_index_t e3[3] = {2, 3, 2};
    CFI_index_t s3[3] = {sizeof(int), 4 * (CFI_index_t)sizeof(int),
                         16 * (CFI_index_t)sizeof(int)};
    CFI_index_t e4[4] = {2, 2, 2, 2};
    CFI_index_t s4[4] = {sizeof(int), 4 * (CFI_index_t)sizeof(int),
                         16 * (CFI_index_t)sizeof(int),
                         64 * (CFI_index_t)sizeof(int)};
    CFI_index_t e14[14];
    CFI_index_t s14[14];
    MPI_Datatype user_dt = MPI_DATATYPE_NULL;
    int rc;

    init_desc(d1, sizeof(d1_storage), data, sizeof(int), CFI_type_int, 1,
              e1, s1);
    create_cfi_type(d1, 5, MPI_INT, "cfi create 1d strided");

    init_desc(d2, sizeof(d2_storage), data, sizeof(int), CFI_type_int, 2,
              e2, s2_contig_first);
    create_cfi_type(d2, 6, MPI_INT, "cfi create 2d block vector");
    create_cfi_type(d2, 5, MPI_INT, "cfi create 2d odd indexed");

    init_desc(d2, sizeof(d2_storage), data, sizeof(int), CFI_type_int, 2,
              e2, s2_strided_first);
    create_cfi_type(d2, 6, MPI_INT, "cfi create 2d nested vector");

    init_desc(d3, sizeof(d3_storage), data, sizeof(int), CFI_type_int, 3,
              e3, s3);
    create_cfi_type(d3, 12, MPI_INT, "cfi create 3d indexed");

    init_desc(d4, sizeof(d4_storage), data, sizeof(int), CFI_type_int, 4,
              e4, s4);
    create_cfi_type(d4, 16, MPI_INT, "cfi create 4d indexed");

    for (int i = 0; i < 14; i++) {
        e14[i] = 1;
        s14[i] = (CFI_index_t)sizeof(int);
    }
    e14[0] = 2;
    e14[1] = 2;
    e14[2] = 2;
    init_desc(d14, sizeof(d14_storage), data, sizeof(int), CFI_type_int, 14,
              e14, s14);
    create_cfi_type(d14, 8, MPI_INT, "cfi create 14d builtin");

#if CFI_MAX_RANK >= 15
    {
        CFI_index_t e15[15];
        CFI_index_t s15[15];
        MPI_Datatype cfi_dt = MPI_DATATYPE_NULL;

        for (int i = 0; i < 15; i++) {
            e15[i] = 1;
            s15[i] = (CFI_index_t)sizeof(int);
        }
        e15[2] = 2;
        init_desc(d15, sizeof(d15_storage), data, sizeof(int), CFI_type_int,
                  15, e15, s15);
        rc = VAPAA_CFI_CREATE_DATATYPE(d15, 2, MPI_INT, &cfi_dt);
        if (rc != MPI_ERR_ARG) {
            fail("cfi rank 15 unsupported", rc);
        }
    }
#endif

    rc = MPI_Type_vector(2, 1, 3, MPI_INT, &user_dt);
    check_mpi(rc, "MPI_Type_vector user input");
    if (rc == MPI_SUCCESS) {
        rc = MPI_Type_commit(&user_dt);
        check_mpi(rc, "MPI_Type_commit user input");
        init_desc(d2, sizeof(d2_storage), data, sizeof(int), CFI_type_int, 2,
                  e2, s2_contig_first);
        {
            MPI_Datatype cfi_dt = MPI_DATATYPE_NULL;
            rc = VAPAA_CFI_CREATE_DATATYPE(d2, 1, user_dt, &cfi_dt);
            if (rc == MPI_SUCCESS) {
                rc = MPI_Type_commit(&cfi_dt);
                check_mpi(rc, "MPI_Type_commit cfi user datatype");
                rc = MPI_Type_free(&cfi_dt);
                check_mpi(rc, "MPI_Type_free cfi user datatype");
            }
        }
        init_desc(d14, sizeof(d14_storage), data, sizeof(int), CFI_type_int,
                  14, e14, s14);
        {
            MPI_Datatype cfi_dt = MPI_DATATYPE_NULL;
            rc = VAPAA_CFI_CREATE_DATATYPE(d14, 1, user_dt, &cfi_dt);
            if (rc == MPI_SUCCESS) {
                rc = MPI_Type_commit(&cfi_dt);
                check_mpi(rc, "MPI_Type_commit cfi user datatype 14d");
                rc = MPI_Type_free(&cfi_dt);
                check_mpi(rc, "MPI_Type_free cfi user datatype 14d");
            }
        }
#ifdef CFI_type_struct
        init_desc(d1, sizeof(d1_storage), data, sizeof(int), CFI_type_struct,
                  1, e1, s1);
        {
            MPI_Datatype cfi_dt = MPI_DATATYPE_NULL;
            rc = VAPAA_CFI_CREATE_DATATYPE(d1, 1, user_dt, &cfi_dt);
            if (rc == MPI_SUCCESS) {
                rc = MPI_Type_commit(&cfi_dt);
                check_mpi(rc, "MPI_Type_commit cfi struct user datatype");
                rc = MPI_Type_free(&cfi_dt);
                check_mpi(rc, "MPI_Type_free cfi struct user datatype");
            }
        }
#endif
        rc = MPI_Type_free(&user_dt);
        check_mpi(rc, "MPI_Type_free user input");
    }

    init_desc(d2, sizeof(d2_storage), data, sizeof(int), CFI_type_int, 2,
              e2, s2_contig_first);
    rc = VAPAA_CFI_CREATE_DATATYPE(d2, 99, MPI_INT, &user_dt);
    if (rc != MPI_ERR_ARG) {
        fail("cfi count beyond descriptor", rc);
    }
}

int main(void)
{
    int rank = 0;
    int rc = MPI_Init(NULL, NULL);
    check_mpi(rc, "MPI_Init");
    MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    run_warning_matrix();
    run_iov_combiner_matrix();
    run_cfi_create_matrix();

    rc = MPI_Finalize();
    check_mpi(rc, "MPI_Finalize");

    if (errors == 0) {
        if (rank == 0) {
            printf("Test passed\n");
        }
        return 0;
    }
    fprintf(stderr, "Test failed with %d errors\n", errors);
    return 1;
}
