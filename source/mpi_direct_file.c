// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "vapaa_constants.h"

static int VAPAA_MPI_AMODE_C2F(int c)
{
#if MPI_VERSION >= 5
    return c;
#else
    int f = 0;
    if (c & MPI_MODE_APPEND) f |= VAPAA_MPI_MODE_APPEND;
    if (c & MPI_MODE_CREATE) f |= VAPAA_MPI_MODE_CREATE;
    if (c & MPI_MODE_DELETE_ON_CLOSE) f |= VAPAA_MPI_MODE_DELETE_ON_CLOSE;
    if (c & MPI_MODE_EXCL) f |= VAPAA_MPI_MODE_EXCL;
    if (c & MPI_MODE_RDONLY) f |= VAPAA_MPI_MODE_RDONLY;
    if (c & MPI_MODE_RDWR) f |= VAPAA_MPI_MODE_RDWR;
    if (c & MPI_MODE_SEQUENTIAL) f |= VAPAA_MPI_MODE_SEQUENTIAL;
    if (c & MPI_MODE_UNIQUE_OPEN) f |= VAPAA_MPI_MODE_UNIQUE_OPEN;
    if (c & MPI_MODE_WRONLY) f |= VAPAA_MPI_MODE_WRONLY;
    return f;
#endif
}

static int VAPAA_MPI_SEEK_F2C(int f)
{
#if MPI_VERSION >= 5
    return f;
#else
    switch (f) {
    case VAPAA_MPI_SEEK_CUR:
        return MPI_SEEK_CUR;
    case VAPAA_MPI_SEEK_END:
        return MPI_SEEK_END;
    case VAPAA_MPI_SEEK_SET:
        return MPI_SEEK_SET;
    default:
        return f;
    }
#endif
}

void VAPAA_MPI_File_get_amode(int *fh_f, int *amode_f, int *ierror)
{
    int amode = 0;
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    *ierror = MPI_File_get_amode(fh, &amode);
    *amode_f = VAPAA_MPI_AMODE_C2F(amode);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_File_get_atomicity(int *fh_f, int *flag, int *ierror)
{
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    *ierror = MPI_File_get_atomicity(fh, flag);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_File_set_atomicity(int *fh_f, int *flag, int *ierror)
{
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    *ierror = MPI_File_set_atomicity(fh, *flag);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_File_get_byte_offset(int *fh_f, int64_t *offset_f, int64_t *disp_f, int *ierror)
{
    MPI_Offset disp = 0;
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    *ierror = MPI_File_get_byte_offset(fh, (MPI_Offset) *offset_f, &disp);
    *disp_f = (int64_t) disp;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_File_get_group(int *fh_f, int *group_f, int *ierror)
{
    MPI_Group group = MPI_GROUP_NULL;
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    *ierror = MPI_File_get_group(fh, &group);
    *group_f = C_MPI_GROUP_TOINT(group);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_File_get_info(int *fh_f, int *info_f, int *ierror)
{
    MPI_Info info = MPI_INFO_NULL;
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    *ierror = MPI_File_get_info(fh, &info);
    *info_f = C_MPI_INFO_TOINT(info);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_File_set_info(int *fh_f, int *info_f, int *ierror)
{
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_File_set_info(fh, info);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_File_get_position(int *fh_f, int64_t *offset_f, int *ierror)
{
    MPI_Offset offset = 0;
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    *ierror = MPI_File_get_position(fh, &offset);
    *offset_f = (int64_t) offset;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_File_get_position_shared(int *fh_f, int64_t *offset_f, int *ierror)
{
    MPI_Offset offset = 0;
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    *ierror = MPI_File_get_position_shared(fh, &offset);
    *offset_f = (int64_t) offset;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_File_get_type_extent(int *fh_f, int *datatype_f, intptr_t *extent_f, int *ierror)
{
    MPI_Aint extent = 0;
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    *ierror = MPI_File_get_type_extent(fh, datatype, &extent);
    *extent_f = (intptr_t) extent;
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void VAPAA_MPI_File_get_view(int *fh_f, int64_t *disp_f, int *etype_f, int *filetype_f,
                             CFI_cdesc_t *datarep_d, int *ierror)
{
    MPI_Offset disp = 0;
    MPI_Datatype etype = MPI_DATATYPE_NULL;
    MPI_Datatype filetype = MPI_DATATYPE_NULL;
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    char *datarep = (char *) datarep_d->base_addr;
    *ierror = MPI_File_get_view(fh, &disp, &etype, &filetype, datarep);
    *disp_f = (int64_t) disp;
    *etype_f = C_MPI_TYPE_TOINT(etype);
    *filetype_f = C_MPI_TYPE_TOINT(filetype);
    C_MPI_RC_FIX(*ierror);
}
#endif

void VAPAA_MPI_File_seek(int *fh_f, int64_t *offset_f, int *whence, int *ierror)
{
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    *ierror = MPI_File_seek(fh, (MPI_Offset) *offset_f, VAPAA_MPI_SEEK_F2C(*whence));
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_File_seek_shared(int *fh_f, int64_t *offset_f, int *whence, int *ierror)
{
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    *ierror = MPI_File_seek_shared(fh, (MPI_Offset) *offset_f, VAPAA_MPI_SEEK_F2C(*whence));
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_File_sync(int *fh_f, int *ierror)
{
    MPI_File fh = C_MPI_FILE_FROMINT(*fh_f);
    *ierror = MPI_File_sync(fh);
    C_MPI_RC_FIX(*ierror);
}
