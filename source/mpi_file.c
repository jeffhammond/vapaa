// SPDX-License-Identifier: MIT

#include <stdio.h>
#include <stdint.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "detect_sentinels.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "vapaa_constants.h"
#include "cfi_util.h"

static int C_MPI_TRANSLATE_AMODE(int f)
{
    // all of the VAPAA constants are powers of two, so that bit logic works
    int c = 0;
    if (f & VAPAA_MPI_MODE_APPEND         ) c |= MPI_MODE_APPEND;
    if (f & VAPAA_MPI_MODE_CREATE         ) c |= MPI_MODE_CREATE;
    if (f & VAPAA_MPI_MODE_DELETE_ON_CLOSE) c |= MPI_MODE_DELETE_ON_CLOSE;
    if (f & VAPAA_MPI_MODE_EXCL           ) c |= MPI_MODE_EXCL;
    if (f & VAPAA_MPI_MODE_RDONLY         ) c |= MPI_MODE_RDONLY;
    if (f & VAPAA_MPI_MODE_RDWR           ) c |= MPI_MODE_RDWR;
    if (f & VAPAA_MPI_MODE_SEQUENTIAL     ) c |= MPI_MODE_SEQUENTIAL;
    if (f & VAPAA_MPI_MODE_UNIQUE_OPEN    ) c |= MPI_MODE_UNIQUE_OPEN;
    if (f & VAPAA_MPI_MODE_WRONLY         ) c |= MPI_MODE_WRONLY;
    return c;
}

void C_MPI_File_open(int * comm_f, char * filename, int * amode_f, int * info_f, int * file_f, int * ierror)
{
    MPI_File file = MPI_FILE_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    int amode = C_MPI_TRANSLATE_AMODE(*amode_f);
    *ierror = MPI_File_open(comm, filename, amode, info, &file);
    *file_f = C_MPI_FILE_TOINT(file);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
static int CFI_MPI_File_prepare_memory(CFI_cdesc_t *desc, int count,
                                       MPI_Datatype datatype, int *memcount,
                                       MPI_Datatype *memtype)
{
    int rc;
    *memcount = count;
    *memtype = datatype;
    if (1 == VAPAA_CFI_is_contiguous(desc)) {
        return MPI_SUCCESS;
    }
    *memcount = 1;
    rc = VAPAA_CFI_CREATE_DATATYPE(desc, count, datatype, memtype);
    if (rc != MPI_SUCCESS) return rc;
    rc = PMPI_Type_commit(memtype);
    if (rc != MPI_SUCCESS) {
        int free_rc = PMPI_Type_free(memtype);
        (void)free_rc;
    }
    return rc;
}

static int CFI_MPI_File_release_memory(MPI_Datatype datatype,
                                       MPI_Datatype *memtype)
{
    if (*memtype == datatype) {
        return MPI_SUCCESS;
    }
    return PMPI_Type_free(memtype);
}

void CFI_MPI_File_open(int * comm_f, CFI_cdesc_t * filename_d, int * amode_f, int * info_f, int * file_f, int * ierror)
{
    MPI_File file = MPI_FILE_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    char * filename = filename_d -> base_addr;
    int amode = C_MPI_TRANSLATE_AMODE(*amode_f);
    *ierror = MPI_File_open(comm, filename, amode, info, &file);
    *file_f = C_MPI_FILE_TOINT(file);
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_close(int * file_f, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    *ierror = MPI_File_close(&file);
    *file_f = C_MPI_FILE_TOINT(file);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_File_delete(char * filename, int * info_f, int * ierror)
{
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_File_delete(filename, info);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_delete(CFI_cdesc_t * filename_d, int * info_f, int * ierror)
{
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    char * filename = filename_d -> base_addr;
    *ierror = MPI_File_delete(filename, info);
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_set_size(int * file_f, size_t * size_f, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset size = *size_f;
    *ierror = MPI_File_set_size(file, size);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_File_preallocate(int * file_f, size_t * size_f, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset size = *size_f;
    *ierror = MPI_File_preallocate(file, size);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_File_get_size(int * file_f, size_t * size_f, int * ierror)
{
    MPI_Offset size = -1;
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    *ierror = MPI_File_get_size(file, &size);
    *size_f = size;
    C_MPI_RC_FIX(*ierror);
}

static MPI_Offset C_MPI_OFFSET_F2C(int64_t offset_f)
{
    return offset_f == VAPAA_MPI_DISPLACEMENT_CURRENT ? MPI_DISPLACEMENT_CURRENT : (MPI_Offset) offset_f;
}

void C_MPI_File_set_view(int * file_f, int64_t * disp_f, int * etype_f, int * filetype_f, char * datarep, int * info_f, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset disp = C_MPI_OFFSET_F2C(*disp_f);
    MPI_Datatype etype = C_MPI_TYPE_FROMINT(*etype_f);
    MPI_Datatype filetype = C_MPI_TYPE_FROMINT(*filetype_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_File_set_view(file, disp, etype, filetype, datarep, info);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_set_view(int * file_f, int64_t * disp_f, int * etype_f, int * filetype_f, CFI_cdesc_t * datarep_d, int * info_f, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset disp = C_MPI_OFFSET_F2C(*disp_f);
    MPI_Datatype etype = C_MPI_TYPE_FROMINT(*etype_f);
    MPI_Datatype filetype = C_MPI_TYPE_FROMINT(*filetype_f);
    char * datarep = datarep_d -> base_addr;
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_File_set_view(file, disp, etype, filetype, datarep, info);
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_read_at(int * file_f, size_t * offset_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_read_at(file, offset, buffer, count, datatype,
                               C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_read_at(int * file_f, size_t * offset_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    int memcount;
    MPI_Datatype memtype;
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, datatype, "MPI_File_read_at");
    *ierror = CFI_MPI_File_prepare_memory(desc, count, datatype, &memcount,
                                          &memtype);
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_File_read_at(file, offset, desc->base_addr, memcount, memtype,
                                   C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
        if (*ierror == MPI_SUCCESS) {
            *ierror = CFI_MPI_File_release_memory(datatype, &memtype);
        } else {
            (void)CFI_MPI_File_release_memory(datatype, &memtype);
        }
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_read_at_all(int * file_f, size_t * offset_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_read_at_all(file, offset, buffer, count, datatype,
                                   C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_read_at_all(int * file_f, size_t * offset_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    int memcount;
    MPI_Datatype memtype;
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, datatype, "MPI_File_read_at_all");
    *ierror = CFI_MPI_File_prepare_memory(desc, count, datatype, &memcount,
                                          &memtype);
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_File_read_at_all(file, offset, desc->base_addr, memcount, memtype,
                                       C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
        if (*ierror == MPI_SUCCESS) {
            *ierror = CFI_MPI_File_release_memory(datatype, &memtype);
        } else {
            (void)CFI_MPI_File_release_memory(datatype, &memtype);
        }
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_write_at(int * file_f, size_t * offset_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_write_at(file, offset, buffer, count, datatype,
                                C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_write_at(int * file_f, size_t * offset_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    int memcount;
    MPI_Datatype memtype;
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, datatype, "MPI_File_write_at");
    *ierror = CFI_MPI_File_prepare_memory(desc, count, datatype, &memcount,
                                          &memtype);
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_File_write_at(file, offset, desc->base_addr, memcount, memtype,
                                    C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
        if (*ierror == MPI_SUCCESS) {
            *ierror = CFI_MPI_File_release_memory(datatype, &memtype);
        } else {
            (void)CFI_MPI_File_release_memory(datatype, &memtype);
        }
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_write_at_all(int * file_f, size_t * offset_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_write_at_all(file, offset, buffer, count, datatype,
                                    C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_write_at_all(int * file_f, size_t * offset_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    int memcount;
    MPI_Datatype memtype;
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, datatype, "MPI_File_write_at_all");
    *ierror = CFI_MPI_File_prepare_memory(desc, count, datatype, &memcount,
                                          &memtype);
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_File_write_at_all(file, offset, desc->base_addr, memcount, memtype,
                                        C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
        if (*ierror == MPI_SUCCESS) {
            *ierror = CFI_MPI_File_release_memory(datatype, &memtype);
        } else {
            (void)CFI_MPI_File_release_memory(datatype, &memtype);
        }
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_read(int * file_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_read(file, buffer, count, datatype,
                            C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_read(int * file_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    int memcount;
    MPI_Datatype memtype;
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, datatype, "MPI_File_read");
    *ierror = CFI_MPI_File_prepare_memory(desc, count, datatype, &memcount,
                                          &memtype);
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_File_read(file, desc->base_addr, memcount, memtype,
                                C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
        if (*ierror == MPI_SUCCESS) {
            *ierror = CFI_MPI_File_release_memory(datatype, &memtype);
        } else {
            (void)CFI_MPI_File_release_memory(datatype, &memtype);
        }
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_read_all(int * file_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_read_all(file, buffer, count, datatype,
                                C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_read_all(int * file_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    int memcount;
    MPI_Datatype memtype;
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, datatype, "MPI_File_read_all");
    *ierror = CFI_MPI_File_prepare_memory(desc, count, datatype, &memcount,
                                          &memtype);
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_File_read_all(file, desc->base_addr, memcount, memtype,
                                    C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
        if (*ierror == MPI_SUCCESS) {
            *ierror = CFI_MPI_File_release_memory(datatype, &memtype);
        } else {
            (void)CFI_MPI_File_release_memory(datatype, &memtype);
        }
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_write(int * file_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_write(file, buffer, count, datatype,
                             C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_write(int * file_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    int memcount;
    MPI_Datatype memtype;
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, datatype, "MPI_File_write");
    *ierror = CFI_MPI_File_prepare_memory(desc, count, datatype, &memcount,
                                          &memtype);
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_File_write(file, desc->base_addr, memcount, memtype,
                                 C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
        if (*ierror == MPI_SUCCESS) {
            *ierror = CFI_MPI_File_release_memory(datatype, &memtype);
        } else {
            (void)CFI_MPI_File_release_memory(datatype, &memtype);
        }
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_write_all(int * file_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_write_all(file, buffer, count, datatype,
                                 C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_write_all(int * file_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_FROMINT(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    int memcount;
    MPI_Datatype memtype;
    VAPAA_CFI_WARN_DATATYPE_MISMATCH(desc, datatype, "MPI_File_write_all");
    *ierror = CFI_MPI_File_prepare_memory(desc, count, datatype, &memcount,
                                          &memtype);
    if (*ierror == MPI_SUCCESS) {
        *ierror = MPI_File_write_all(file, desc->base_addr, memcount, memtype,
                                     C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
        if (*ierror == MPI_SUCCESS) {
            *ierror = CFI_MPI_File_release_memory(datatype, &memtype);
        } else {
            (void)CFI_MPI_File_release_memory(datatype, &memtype);
        }
    }
    C_MPI_RC_FIX(*ierror);
}
#endif
