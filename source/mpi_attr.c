#include <string.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"

#define C_MPI_HANDLE_GET_NAME(Full,SHORT,Short)                                             \
void C_MPI_##Short##_get_name(int * handle_f, char ** pname, int * resultlen, int * ierror) \
{                                                                                           \
    MPI_##Full handle = C_MPI_##SHORT##_F2C(*handle_f);                                     \
    char * name = *pname;                                                                   \
    *ierror = MPI_##Short##_get_name(handle, name, resultlen);                              \
    C_MPI_RC_FIX(*ierror);                                                                  \
}

#define C_MPI_HANDLE_SET_NAME(Full,SHORT,Short)                                             \
void C_MPI_##Short##_set_name(int * handle_f, char ** pname, int * ierror)                  \
{                                                                                           \
    MPI_##Full handle = C_MPI_##SHORT##_F2C(*handle_f);                                     \
    char * name = *pname;                                                                   \
    *ierror = MPI_##Short##_set_name(handle, name);                                         \
    C_MPI_RC_FIX(*ierror);                                                                  \
}

C_MPI_HANDLE_GET_NAME(Comm,COMM,Comm)
C_MPI_HANDLE_SET_NAME(Comm,COMM,Comm)
C_MPI_HANDLE_GET_NAME(Datatype,TYPE,Type)
C_MPI_HANDLE_SET_NAME(Datatype,TYPE,Type)
C_MPI_HANDLE_GET_NAME(Win,WIN,Win)
C_MPI_HANDLE_SET_NAME(Win,WIN,Win)

static int C_MPI_TRANSLATE_WIN_ATTR(int f)
{
    if (f == VAPAA_MPI_WIN_BASE) {
        return MPI_WIN_BASE;
    } else if (f == VAPAA_MPI_WIN_SIZE) {
        return MPI_WIN_SIZE;
    } else if (f == VAPAA_MPI_WIN_DISP_UNIT) {
        return MPI_WIN_DISP_UNIT;
    } else if (f == VAPAA_MPI_WIN_CREATE_FLAVOR) {
        return MPI_WIN_CREATE_FLAVOR;
    } else if (f == VAPAA_MPI_WIN_MODEL) {
        return MPI_WIN_MODEL;
    } else {
        return f;
    }
}

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
