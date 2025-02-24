#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "detect_sentinels.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "cfi_util.h"
#include "debug.h"

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

void C_MPI_Win_fence(int assert, int win, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_fence(assert, c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_post(int group, int assert, int win, int *ierror)
{
    MPI_Group c_group = C_MPI_GROUP_F2C(group);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_post(c_group, assert, c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_start(int group, int assert, int win, int *ierror)
{
    MPI_Group c_group = C_MPI_GROUP_F2C(group);
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_start(c_group, assert, c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_complete(int win, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_complete(c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_wait(int win, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_wait(c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_test(int win, int *flag, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_test(c_win, flag);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_lock(int lock_type, int rank, int assert, int win, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_lock(lock_type, rank, assert, c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_unlock(int rank, int win, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_unlock(rank, c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_lock_all(int assert, int win, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_lock_all(assert, c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_unlock_all(int win, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_unlock_all(c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_flush(int rank, int win, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_flush(rank, c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_flush_all(int win, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_flush_all(c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_flush_local(int rank, int win, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_flush_local(rank, c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_flush_local_all(int win, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_flush_local_all(c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_sync(int win, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_sync(c_win);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_create(void *base, MPI_Aint size, int disp_unit,
                      int info, int comm, int *win, int *ierror)
{
    MPI_Info c_info = C_MPI_INFO_F2C(info);
    MPI_Comm c_comm = C_MPI_COMM_F2C(comm);
    MPI_Win c_win;
    
    *ierror = MPI_Win_create(base, size, disp_unit, c_info, c_comm, &c_win);
    
    if (*ierror == MPI_SUCCESS) {
        *win = C_MPI_WIN_C2F(c_win);
    }
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Win_create(CFI_cdesc_t *desc, MPI_Aint size, int disp_unit,
                        int info, int comm, int *win, int *ierror)
{
    MPI_Info c_info = C_MPI_INFO_F2C(info);
    MPI_Comm c_comm = C_MPI_COMM_F2C(comm);
    MPI_Win c_win;
    
    *ierror = MPI_Win_create(desc->base_addr, size, disp_unit, c_info, c_comm, &c_win);
    
    if (*ierror == MPI_SUCCESS) {
        *win = C_MPI_WIN_C2F(c_win);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Win_allocate(MPI_Aint size, int disp_unit, int info,
                        int comm, void *baseptr, int *win, int *ierror)
{
    MPI_Info c_info = C_MPI_INFO_F2C(info);
    MPI_Comm c_comm = C_MPI_COMM_F2C(comm);
    MPI_Win c_win;
    
    *ierror = MPI_Win_allocate(size, disp_unit, c_info, c_comm, baseptr, &c_win);
    
    if (*ierror == MPI_SUCCESS) {
        *win = C_MPI_WIN_C2F(c_win);
    }
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_allocate_shared(MPI_Aint size, int disp_unit, int info,
                              int comm, void *baseptr, int *win, int *ierror)
{
    MPI_Info c_info = C_MPI_INFO_F2C(info);
    MPI_Comm c_comm = C_MPI_COMM_F2C(comm);
    MPI_Win c_win;
    
    *ierror = MPI_Win_allocate_shared(size, disp_unit, c_info, c_comm, baseptr, &c_win);
    
    if (*ierror == MPI_SUCCESS) {
        *win = C_MPI_WIN_C2F(c_win);
    }
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_shared_query(int win, int rank, MPI_Aint *size,
                           int *disp_unit, void *baseptr, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_shared_query(c_win, rank, size, disp_unit, baseptr);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_create_dynamic(int info, int comm, int *win, int *ierror)
{
    MPI_Info c_info = C_MPI_INFO_F2C(info);
    MPI_Comm c_comm = C_MPI_COMM_F2C(comm);
    MPI_Win c_win;
    
    *ierror = MPI_Win_create_dynamic(c_info, c_comm, &c_win);
    
    if (*ierror == MPI_SUCCESS) {
        *win = C_MPI_WIN_C2F(c_win);
    }
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_attach(int win, void *base, MPI_Aint size, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_attach(c_win, base, size);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_detach(int win, void *base, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    
    *ierror = MPI_Win_detach(c_win, base);
    
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_free(int *win, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(*win);
    
    *ierror = MPI_Win_free(&c_win);
    
    if (*ierror == MPI_SUCCESS) {
        *win = C_MPI_WIN_C2F(c_win);
    }
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_get_group(int win, int *group, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);
    MPI_Group c_group;
    
    *ierror = MPI_Win_get_group(c_win, &c_group);
    
    if (*ierror == MPI_SUCCESS) {
        *group = C_MPI_GROUP_C2F(c_group);
    }
    C_MPI_RC_FIX(*ierror);
}
