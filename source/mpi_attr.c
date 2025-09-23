// SPDX-License-Identifier: MIT

#include <string.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"

#define C_MPI_HANDLE_GET_NAME(Full,SHORT,Short)                                             \
void C_MPI_##Short##_get_name(int * handle_f, char * name, int * resultlen, int * ierror)   \
{                                                                                           \
    MPI_##Full handle = C_MPI_##SHORT##_F2C(*handle_f);                                     \
    *ierror = MPI_##Short##_get_name(handle, name, resultlen);                              \
    C_MPI_RC_FIX(*ierror);                                                                  \
}

#define C_MPI_HANDLE_SET_NAME(Full,SHORT,Short)                                             \
void C_MPI_##Short##_set_name(int * handle_f, char * name, int * ierror)                    \
{                                                                                           \
    MPI_##Full handle = C_MPI_##SHORT##_F2C(*handle_f);                                     \
    *ierror = MPI_##Short##_set_name(handle, name);                                         \
    C_MPI_RC_FIX(*ierror);                                                                  \
}

C_MPI_HANDLE_GET_NAME(Comm,COMM,Comm)
C_MPI_HANDLE_SET_NAME(Comm,COMM,Comm)
C_MPI_HANDLE_GET_NAME(Datatype,TYPE,Type)
C_MPI_HANDLE_SET_NAME(Datatype,TYPE,Type)
C_MPI_HANDLE_GET_NAME(Win,WIN,Win)
C_MPI_HANDLE_SET_NAME(Win,WIN,Win)

void C_MPI_Win_set_attr(int win, int win_keyval, void *attribute_val, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);

    *ierror = MPI_Win_set_attr(c_win, C_MPI_TRANSLATE_WIN_ATTR(win_keyval), attribute_val);

    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Win_get_attr(int win, int win_keyval, void *attribute_val, int *ierror)
{
    MPI_Win c_win = C_MPI_WIN_F2C(win);

    *ierror = MPI_Win_get_attr(c_win, C_MPI_TRANSLATE_WIN_ATTR(win_keyval), attribute_val);

    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_set_attr(int comm, int comm_keyval, void *attribute_val, int *ierror)
{
    MPI_Comm c_comm = C_MPI_COMM_F2C(comm);

    *ierror = MPI_Comm_set_attr(c_comm, C_MPI_TRANSLATE_COMM_ATTR(comm_keyval), attribute_val);

    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_get_attr(int comm, int comm_keyval, void *attribute_val, int *flag, int *ierror)
{
    MPI_Comm c_comm = C_MPI_COMM_F2C(comm);

    *ierror = MPI_Comm_get_attr(c_comm, C_MPI_TRANSLATE_COMM_ATTR(comm_keyval), attribute_val, flag);

    C_MPI_RC_FIX(*ierror);
}
