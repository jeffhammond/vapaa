// SPDX-License-Identifier: MIT

#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "vapaa_constants.h"

#if 0
static int C_MPI_TRANSLATE_WIN_ASSERT(int f)
{
    // all of the VAPAA constants are powers of two, to ensure bit logic works
    int c = 0;
    if (f & VAPAA_MPI_NOCHECK  ) c |= MPI_MODE_NOCHECK;
    if (f & VAPAA_MPI_NOSTORE  ) c |= MPI_MODE_NOSTORE;
    if (f & VAPAA_MPI_NOPUT    ) c |= MPI_MODE_NOPUT;
    if (f & VAPAA_MPI_NOPRECEDE) c |= MPI_MODE_NOPRECEDE;
    if (f & VAPAA_MPI_NOSUCCEED) c |= MPI_MODE_NOSUCCEED;
    return c;
}
#endif

void C_MPI_Win_allocate(size_t size, int disp_unit, int info_f, int comm_f, void ** baseptr, int * win_f, int * ierror)
{
    MPI_Win win = MPI_WIN_NULL;
    MPI_Info info = C_MPI_INFO_F2C(info_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    *ierror = MPI_Win_allocate(size, disp_unit, info, comm, baseptr, &win);
    *win_f = MPI_Win_c2f(win);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Win_allocate(size_t size, int disp_unit, int info_f, int comm_f, CFI_cdesc_t * desc, int * win_f, int * ierror)
{
    MPI_Win win = MPI_WIN_NULL;
    MPI_Info info = C_MPI_INFO_F2C(info_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Win_allocate(size, disp_unit, info, desc->base_addr, comm, &win);
    } else {
        VAPAA_Assert_msg(0,"The base argument to MPI_Win_allocate must be simply contiguous!");
    }
    *win_f = MPI_Win_c2f(win);
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Win_create(void * base, size_t size, int disp_unit, int info_f, int comm_f, int * win_f, int * ierror)
{
    MPI_Win win = MPI_WIN_NULL;
    MPI_Info info = C_MPI_INFO_F2C(info_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    *ierror = MPI_Win_create(base, size, disp_unit, info, comm, &win);
    *win_f = MPI_Win_c2f(win);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Win_create(CFI_cdesc_t * desc, size_t size, int disp_unit, int info_f, int comm_f, int * win_f, int * ierror)
{
    MPI_Win win = MPI_WIN_NULL;
    MPI_Info info = C_MPI_INFO_F2C(info_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Win_create(desc->base_addr, size, disp_unit, info, comm, &win);
    } else {
        VAPAA_Assert_msg(0,"The base argument to MPI_Win_create must be simply contiguous!");
    }
    *win_f = MPI_Win_c2f(win);
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Win_free(int * win_f, int * ierror)
{
    MPI_Win win = C_MPI_WIN_F2C(*win_f);
    *ierror = MPI_Win_free(&win);
    *win_f = MPI_Win_c2f(win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Alloc_mem(size_t size, int info_f, void ** baseptr, int * ierror)
{
    MPI_Info info = C_MPI_INFO_F2C(info_f);
    *ierror = MPI_Alloc_mem(size, info, baseptr);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Free_mem(void * baseptr, int * ierror)
{
    *ierror = MPI_Free_mem(baseptr);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Free_mem(CFI_cdesc_t * desc, int * ierror)
{
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Free_mem(desc->base_addr);
    } else {
        VAPAA_Assert_msg(0,"The base argument to MPI_Free_mem must be simply contiguous!");
    }
    C_MPI_RC_FIX(*ierror);
}
#endif
