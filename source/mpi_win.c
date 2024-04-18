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

void C_MPI_Win_allocatee(MPI_Aint size, int disp_unit, int info_f, int comm_f, void ** baseptr, int * win_f, int * ierror)
{
    MPI_Win win = MPI_WIN_NULL;
    MPI_Info info = C_MPI_INFO_F2C(info_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    *ierror = MPI_Win_allocate(size, disp_unit, info, comm, baseptr, &win);
    *win_f = MPI_Win_c2f(win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_create(void * base, MPI_Aint size, int disp_unit, int info_f, int comm_f, int * win_f, int * ierror)
{
    MPI_Win win = MPI_WIN_NULL;
    MPI_Info info = C_MPI_INFO_F2C(info_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    *ierror = MPI_Win_create(base, size, disp_unit, info, comm, &win);
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

