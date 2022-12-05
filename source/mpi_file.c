#include <stdio.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "mpi_detect_sentinels.h"
#include "mpi_handle_conversions.h"
#include "mpi_constant_conversions.h"

/*******************************
! MPI I/O file mode constants
integer, parameter :: MPI_MODE_APPEND           =   1
integer, parameter :: MPI_MODE_CREATE           =   2
integer, parameter :: MPI_MODE_DELETE_ON_CLOSE  =   4
integer, parameter :: MPI_MODE_EXCL             =   8
integer, parameter :: MPI_MODE_RDONLY           =  16
integer, parameter :: MPI_MODE_RDWR             =  32
integer, parameter :: MPI_MODE_SEQUENTIAL       =  64
integer, parameter :: MPI_MODE_UNIQUE_OPEN      = 128
integer, parameter :: MPI_MODE_WRONLY           = 256
*******************************/

static int C_MPI_TRANSLATE_AMODE(int f)
{
    int c = 0;
    if (f &   1) c |= MPI_MODE_APPEND;
    if (f &   2) c |= MPI_MODE_CREATE;
    if (f &   4) c |= MPI_MODE_DELETE_ON_CLOSE;
    if (f &   8) c |= MPI_MODE_EXCL;
    if (f &  16) c |= MPI_MODE_RDONLY;
    if (f &  32) c |= MPI_MODE_RDWR;
    if (f &  64) c |= MPI_MODE_SEQUENTIAL;
    if (f & 128) c |= MPI_MODE_UNIQUE_OPEN;
    if (f & 256) c |= MPI_MODE_WRONLY;
    return c;
}

void C_MPI_File_open(int * comm_f, CFI_cdesc_t * filename_d, int * amode_f, int * info_f, int * file_f, int * ierror)
{
    MPI_File file = MPI_FILE_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    MPI_Info info = C_MPI_INFO_F2C(*info_f);
    char * filename = filename_d -> base_addr;
    int amode = C_MPI_TRANSLATE_AMODE(*amode_f);
    *ierror = MPI_File_open(comm, filename, amode, info, &file);
    *file_f = MPI_File_c2f(file);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_File_close(int * file_f, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    *ierror = MPI_File_close(&file);
    *file_f = MPI_File_c2f(file);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_File_delete(CFI_cdesc_t * filename_d, int * info_f, int * ierror)
{
    MPI_Info info = C_MPI_INFO_F2C(*info_f);
    char * filename = filename_d -> base_addr;
    *ierror = MPI_File_delete(filename, info);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_File_set_size(int * file_f, intptr_t * size_f, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    MPI_Offset size = *size_f;
    *ierror = MPI_File_set_size(file, size);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_File_preallocate(int * file_f, intptr_t * size_f, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    MPI_Offset size = *size_f;
    *ierror = MPI_File_preallocate(file, size);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_File_get_size(int * file_f, intptr_t * size_f, int * ierror)
{
    MPI_Offset size = -1;
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    *ierror = MPI_File_get_size(file, &size);
    *size_f = size;
    C_MPI_RC_FIX(*ierror);
}

// THIS MAY NOT WORK
void C_MPI_File_set_view(int * file_f, intptr_t * disp_f, int * etype_f, int * filetype_f, char * datarep, int * info_f, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    MPI_Offset disp = *disp_f;
    MPI_Datatype etype = C_MPI_TYPE_F2C(*etype_f);
    MPI_Datatype filetype = C_MPI_TYPE_F2C(*filetype_f);
    MPI_Info info = C_MPI_INFO_F2C(*info_f);
    *ierror = MPI_File_set_view(file, disp, etype, filetype, datarep, info);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_set_view(int * file_f, intptr_t * disp_f, int * etype_f, int * filetype_f, CFI_cdesc_t * datarep_d, int * info_f, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    MPI_Offset disp = *disp_f;
    MPI_Datatype etype = C_MPI_TYPE_F2C(*etype_f);
    MPI_Datatype filetype = C_MPI_TYPE_F2C(*filetype_f);
    char * datarep = datarep_d -> base_addr;
    MPI_Info info = C_MPI_INFO_F2C(*info_f);
    *ierror = MPI_File_set_view(file, disp, etype, filetype, datarep, info);
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_read_at(int * file_f, intptr_t * offset_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    *ierror = MPI_File_read_at(file, offset, buffer, count, datatype,
                               C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_read_at(int * file_f, intptr_t * offset_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_File_read_at(file, offset, desc->base_addr, count, datatype,
                                   C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(MPI_COMM_SELF, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_read_at_all(int * file_f, intptr_t * offset_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    *ierror = MPI_File_read_at_all(file, offset, buffer, count, datatype,
                                   C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_read_at_all(int * file_f, intptr_t * offset_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_File_read_at_all(file, offset, desc->base_addr, count, datatype,
                                       C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(MPI_COMM_SELF, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_write_at(int * file_f, intptr_t * offset_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    *ierror = MPI_File_write_at(file, offset, buffer, count, datatype,
                                C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_write_at(int * file_f, intptr_t * offset_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_File_write_at(file, offset, desc->base_addr, count, datatype,
                                    C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(MPI_COMM_SELF, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_write_at_all(int * file_f, intptr_t * offset_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    *ierror = MPI_File_write_at_all(file, offset, buffer, count, datatype,
                                    C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_write_at_all(int * file_f, intptr_t * offset_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_File_write_at_all(file, offset, desc->base_addr, count, datatype,
                                        C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(MPI_COMM_SELF, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_read(int * file_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    *ierror = MPI_File_read(file, buffer, count, datatype,
                            C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_read(int * file_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_File_read(file, desc->base_addr, count, datatype,
                                C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(MPI_COMM_SELF, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_read_all(int * file_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    *ierror = MPI_File_read_all(file, buffer, count, datatype,
                                C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_read_all(int * file_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_File_read_all(file, desc->base_addr, count, datatype,
                                    C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(MPI_COMM_SELF, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_write(int * file_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    *ierror = MPI_File_write(file, buffer, count, datatype,
                             C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_write(int * file_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_File_write(file, desc->base_addr, count, datatype,
                                 C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(MPI_COMM_SELF, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_File_write_all(int * file_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    *ierror = MPI_File_write_all(file, buffer, count, datatype,
                                 C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_File_write_all(int * file_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = C_MPI_FILE_F2C(*file_f);
    int count = *count_f;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_File_write_all(file, desc->base_addr, count, datatype,
                                     C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(MPI_COMM_SELF, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif
