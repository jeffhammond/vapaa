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
