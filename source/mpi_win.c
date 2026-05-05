// SPDX-License-Identifier: MIT

#include <stdint.h>
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

void C_MPI_Win_create(void * base, intptr_t size, int disp_unit, int info_f, int comm_f, int * win_f, int * ierror)
{
    MPI_Info info = C_MPI_INFO_F2C(info_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    MPI_Win win;
    *ierror = MPI_Win_create(base, (MPI_Aint)size, disp_unit, info, comm, &win);
    *win_f = MPI_Win_c2f(win);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Win_create(CFI_cdesc_t * desc, intptr_t size, int disp_unit, int info_f, int comm_f, int * win_f, int * ierror)
{
    MPI_Info info = C_MPI_INFO_F2C(info_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    MPI_Win win;
    *ierror = MPI_Win_create(desc->base_addr, (MPI_Aint)size, disp_unit, info, comm, &win);
    *win_f = MPI_Win_c2f(win);
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Win_create_dynamic(int info_f, int comm_f, int * win_f, int * ierror)
{
    MPI_Info info = C_MPI_INFO_F2C(info_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    MPI_Win win;
    *ierror = MPI_Win_create_dynamic(info, comm, &win);
    *win_f = MPI_Win_c2f(win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_allocate(intptr_t size, int disp_unit, int info_f, int comm_f, void ** baseptr, int * win_f, int * ierror)
{
    MPI_Info info = C_MPI_INFO_F2C(info_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    MPI_Win win;
    *ierror = MPI_Win_allocate((MPI_Aint)size, disp_unit, info, comm, baseptr, &win);
    *win_f = MPI_Win_c2f(win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_free(int * win_f, int * ierror)
{
    MPI_Win win = C_MPI_WIN_F2C(*win_f);
    *ierror = MPI_Win_free(&win);
    *win_f = MPI_Win_c2f(win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_fence(int assert, int win_f, int * ierror)
{
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Win_fence(assert, win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_lock(int lock_type, int rank, int assert, int win_f, int * ierror)
{
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    int lock_type_c;
    if (lock_type == VAPAA_MPI_LOCK_SHARED) {
        lock_type_c = MPI_LOCK_SHARED;
    } else if (lock_type == VAPAA_MPI_LOCK_EXCLUSIVE) {
        lock_type_c = MPI_LOCK_EXCLUSIVE;
    } else {
        lock_type_c = lock_type;
    }
    *ierror = MPI_Win_lock(lock_type_c, rank, assert, win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_unlock(int rank, int win_f, int * ierror)
{
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Win_unlock(rank, win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_lock_all(int assert, int win_f, int * ierror)
{
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Win_lock_all(assert, win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_unlock_all(int win_f, int * ierror)
{
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Win_unlock_all(win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_flush(int rank, int win_f, int * ierror)
{
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Win_flush(rank, win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_flush_all(int win_f, int * ierror)
{
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Win_flush_all(win);
    C_MPI_RC_FIX(*ierror);
}
