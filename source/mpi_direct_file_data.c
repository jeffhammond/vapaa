// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "detect_sentinels.h"
#include "cfi_util.h"
#include "debug.h"

static void *VAPAA_FILE_ADDR(CFI_cdesc_t *desc)
{
    return C_IS_MPI_BOTTOM(desc->base_addr) ? MPI_BOTTOM : desc->base_addr;
}

static int VAPAA_FILE_REQUIRE_CONTIG(CFI_cdesc_t *desc)
{
    if (VAPAA_CFI_is_contiguous(desc) == 1) {
        return 1;
    }
    VAPAA_Warning("this MPI-IO wrapper requires a contiguous buffer.\n");
    MPI_Abort(MPI_COMM_SELF, 99);
    return 0;
}

static void VAPAA_FILE_FINISH_REQUEST(MPI_Request request, int *request_f, int *ierror)
{
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}

#define FILE_IREADLIKE(name, mpi_fn) \
void name(int *file_f, CFI_cdesc_t *buf, int *count, int *datatype_f, int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_File file = C_MPI_FILE_FROMINT(*file_f); \
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(buf, datatype); \
    if (VAPAA_FILE_REQUIRE_CONTIG(buf)) { \
        *ierror = mpi_fn(file, VAPAA_FILE_ADDR(buf), *count, datatype, &request); \
    } \
    VAPAA_FILE_FINISH_REQUEST(request, request_f, ierror); \
}

#define FILE_IREADLIKE_AT(name, mpi_fn) \
void name(int *file_f, int64_t *offset_f, CFI_cdesc_t *buf, int *count, int *datatype_f, int *request_f, int *ierror) \
{ \
    MPI_Request request = MPI_REQUEST_NULL; \
    MPI_File file = C_MPI_FILE_FROMINT(*file_f); \
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(buf, datatype); \
    if (VAPAA_FILE_REQUIRE_CONTIG(buf)) { \
        *ierror = mpi_fn(file, (MPI_Offset)*offset_f, VAPAA_FILE_ADDR(buf), *count, datatype, &request); \
    } \
    VAPAA_FILE_FINISH_REQUEST(request, request_f, ierror); \
}

FILE_IREADLIKE(VAPAA_MPI_File_iread, MPI_File_iread)
FILE_IREADLIKE(VAPAA_MPI_File_iread_all, MPI_File_iread_all)
FILE_IREADLIKE(VAPAA_MPI_File_iread_shared, MPI_File_iread_shared)
FILE_IREADLIKE(VAPAA_MPI_File_iwrite, MPI_File_iwrite)
FILE_IREADLIKE(VAPAA_MPI_File_iwrite_all, MPI_File_iwrite_all)
FILE_IREADLIKE(VAPAA_MPI_File_iwrite_shared, MPI_File_iwrite_shared)
FILE_IREADLIKE_AT(VAPAA_MPI_File_iread_at, MPI_File_iread_at)
FILE_IREADLIKE_AT(VAPAA_MPI_File_iread_at_all, MPI_File_iread_at_all)
FILE_IREADLIKE_AT(VAPAA_MPI_File_iwrite_at, MPI_File_iwrite_at)
FILE_IREADLIKE_AT(VAPAA_MPI_File_iwrite_at_all, MPI_File_iwrite_at_all)

#define FILE_STATUSLIKE(name, mpi_fn) \
void name(int *file_f, CFI_cdesc_t *buf, int *count, int *datatype_f, MPI_Status *status, int *ierror) \
{ \
    MPI_File file = C_MPI_FILE_FROMINT(*file_f); \
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(buf, datatype); \
    if (VAPAA_FILE_REQUIRE_CONTIG(buf)) { \
        *ierror = mpi_fn(file, VAPAA_FILE_ADDR(buf), *count, datatype, \
                         C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status); \
    } \
    C_MPI_RC_FIX(*ierror); \
}

FILE_STATUSLIKE(VAPAA_MPI_File_read_ordered, MPI_File_read_ordered)
FILE_STATUSLIKE(VAPAA_MPI_File_read_shared, MPI_File_read_shared)
FILE_STATUSLIKE(VAPAA_MPI_File_write_ordered, MPI_File_write_ordered)
FILE_STATUSLIKE(VAPAA_MPI_File_write_shared, MPI_File_write_shared)

#define FILE_BEGINLIKE(name, mpi_fn) \
void name(int *file_f, CFI_cdesc_t *buf, int *count, int *datatype_f, int *ierror) \
{ \
    MPI_File file = C_MPI_FILE_FROMINT(*file_f); \
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(buf, datatype); \
    if (VAPAA_FILE_REQUIRE_CONTIG(buf)) { \
        *ierror = mpi_fn(file, VAPAA_FILE_ADDR(buf), *count, datatype); \
    } \
    C_MPI_RC_FIX(*ierror); \
}

#define FILE_BEGINLIKE_AT(name, mpi_fn) \
void name(int *file_f, int64_t *offset_f, CFI_cdesc_t *buf, int *count, int *datatype_f, int *ierror) \
{ \
    MPI_File file = C_MPI_FILE_FROMINT(*file_f); \
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f); \
    VAPAA_CFI_WARN_DATATYPE_MISMATCH_FUNC(buf, datatype); \
    if (VAPAA_FILE_REQUIRE_CONTIG(buf)) { \
        *ierror = mpi_fn(file, (MPI_Offset)*offset_f, VAPAA_FILE_ADDR(buf), *count, datatype); \
    } \
    C_MPI_RC_FIX(*ierror); \
}

#define FILE_ENDLIKE(name, mpi_fn) \
void name(int *file_f, CFI_cdesc_t *buf, MPI_Status *status, int *ierror) \
{ \
    MPI_File file = C_MPI_FILE_FROMINT(*file_f); \
    if (VAPAA_FILE_REQUIRE_CONTIG(buf)) { \
        *ierror = mpi_fn(file, VAPAA_FILE_ADDR(buf), C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status); \
    } \
    C_MPI_RC_FIX(*ierror); \
}

FILE_BEGINLIKE(VAPAA_MPI_File_read_all_begin, MPI_File_read_all_begin)
FILE_BEGINLIKE(VAPAA_MPI_File_read_ordered_begin, MPI_File_read_ordered_begin)
FILE_BEGINLIKE(VAPAA_MPI_File_write_all_begin, MPI_File_write_all_begin)
FILE_BEGINLIKE(VAPAA_MPI_File_write_ordered_begin, MPI_File_write_ordered_begin)
FILE_BEGINLIKE_AT(VAPAA_MPI_File_read_at_all_begin, MPI_File_read_at_all_begin)
FILE_BEGINLIKE_AT(VAPAA_MPI_File_write_at_all_begin, MPI_File_write_at_all_begin)
FILE_ENDLIKE(VAPAA_MPI_File_read_all_end, MPI_File_read_all_end)
FILE_ENDLIKE(VAPAA_MPI_File_read_at_all_end, MPI_File_read_at_all_end)
FILE_ENDLIKE(VAPAA_MPI_File_read_ordered_end, MPI_File_read_ordered_end)
FILE_ENDLIKE(VAPAA_MPI_File_write_all_end, MPI_File_write_all_end)
FILE_ENDLIKE(VAPAA_MPI_File_write_at_all_end, MPI_File_write_at_all_end)
FILE_ENDLIKE(VAPAA_MPI_File_write_ordered_end, MPI_File_write_ordered_end)
