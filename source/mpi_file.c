#include <stdio.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "mpi_status_ignore.h"

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

// NOT STANDARD STUFF

void C_MPI_FILE_NULL(int * file)
{
    *file = MPI_File_c2f(MPI_FILE_NULL);
}

// STANDARD STUFF

void C_MPI_File_open(int * comm_f, CFI_cdesc_t * filename_d, int * amode_f, int * info_f, int * file_f, int * ierror)
{
    MPI_File file = MPI_FILE_NULL;
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    MPI_Info info = MPI_Info_f2c(*info_f);
    char * filename = filename_d -> base_addr;
    int amode = C_MPI_TRANSLATE_AMODE(*amode_f);
    *ierror = MPI_File_open(comm, filename, amode, info, &file);
    *file_f = MPI_File_c2f(file);
}

void C_MPI_File_close(int * file_f, int * ierror)
{
    MPI_File file = MPI_File_f2c(*file_f);
    *ierror = MPI_File_close(&file);
    *file_f = MPI_File_c2f(file);
}

void C_MPI_File_delete(CFI_cdesc_t * filename_d, int * info_f, int * ierror)
{
    MPI_Info info = MPI_Info_f2c(*info_f);
    char * filename = filename_d -> base_addr;
    *ierror = MPI_File_delete(filename, info);
}

void C_MPI_File_set_size(int * file_f, intptr_t * size_f, int * ierror)
{
    MPI_File file = MPI_File_f2c(*file_f);
    MPI_Offset size = *size_f;
    *ierror = MPI_File_set_size(file, size);
}

void C_MPI_File_preallocate(int * file_f, intptr_t * size_f, int * ierror)
{
    MPI_File file = MPI_File_f2c(*file_f);
    MPI_Offset size = *size_f;
    *ierror = MPI_File_preallocate(file, size);
}

void C_MPI_File_get_size(int * file_f, intptr_t * size_f, int * ierror)
{
    MPI_Offset size = -1;
    MPI_File file = MPI_File_f2c(*file_f);
    *ierror = MPI_File_get_size(file, &size);
    *size_f = size;
}

void C_MPI_File_read_at(int * file_f, intptr_t * offset_f, void * buffer, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = MPI_File_f2c(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    *ierror = MPI_File_read_at(file, offset, buffer, count, datatype,
                               C_MPI_IS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
}

#ifdef HAVE_CFI
void CFI_MPI_File_read_at(int * file_f, intptr_t * offset_f, CFI_cdesc_t * desc, int * count_f, int * datatype_f, MPI_Status * status, int * ierror)
{
    MPI_File file = MPI_File_f2c(*file_f);
    MPI_Offset offset = *offset_f;
    int count = *count_f;
    MPI_Datatype datatype = MPI_Type_f2c(*datatype_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_File_read_at(file, offset, desc->base_addr, count, datatype,
                                   C_MPI_IS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(MPI_COMM_SELF, 99);
    }
}
#endif

