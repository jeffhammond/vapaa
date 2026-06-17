#ifndef CONVERT_HANDLES_H
#define CONVERT_HANDLES_H

#include <stddef.h>
#include <mpi.h>
#include "vapaa_abi_handles.h"
#include "convert_constants.h"

// TODO: move all the constants into a header file and use case-switch.

#ifndef MAYBE_UNUSED
#define MAYBE_UNUSED __attribute__((unused))
#endif

struct F_MPI_Status
{
#if defined(MPI_ABI)
        int MPI_SOURCE;
        int MPI_TAG;
        int MPI_ERROR;
        int MPI_internal[5];
#else
        // MPICH
        int count_lo;
        int count_hi_and_cancelled;
        // public / standard
        int MPI_SOURCE;
        int MPI_TAG;
        int MPI_ERROR;
        // Open-MPI
        int cancelled;
        size_t ucount;
#endif
};

MAYBE_UNUSED
static void C_MPI_STATUS_TO_C(const struct F_MPI_Status * f, MPI_Status * c)
{
#if defined(MPI_ABI)
    c->MPI_SOURCE = C_MPI_SOURCE_F2C(f->MPI_SOURCE);
    c->MPI_TAG    = C_MPI_TAG_F2C(f->MPI_TAG);
    c->MPI_ERROR  = C_MPI_ERROR_CODE_F2C(f->MPI_ERROR);
    for (int i = 0; i < 5; ++i) {
        c->MPI_internal[i] = f->MPI_internal[i];
    }
#else
#if !(defined(MPICH) || defined(OPEN_MPI))
#error Need Status ABI support
#endif

#if defined(MPICH)
    c->count_lo               = f->count_lo;
    c->count_hi_and_cancelled = f->count_hi_and_cancelled;
#endif
    c->MPI_SOURCE = f->MPI_SOURCE;
    c->MPI_TAG    = f->MPI_TAG;
    c->MPI_ERROR  = f->MPI_ERROR;
#if defined(OPEN_MPI)
    c->_cancelled = f->cancelled;
    c->_ucount    = f->ucount;
#endif
#endif
}

MAYBE_UNUSED
static void C_MPI_STATUS_FROM_C(const MPI_Status * c, struct F_MPI_Status * f)
{
#if defined(MPI_ABI)
    f->MPI_SOURCE = C_MPI_SOURCE_C2F(c->MPI_SOURCE);
    f->MPI_TAG    = C_MPI_TAG_C2F(c->MPI_TAG);
    f->MPI_ERROR  = C_MPI_ERROR_CODE_C2F(c->MPI_ERROR);
    for (int i = 0; i < 5; ++i) {
        f->MPI_internal[i] = c->MPI_internal[i];
    }
#else
#if !(defined(MPICH) || defined(OPEN_MPI))
#error Need Status ABI support
#endif

#if defined(MPICH)
    f->count_lo               = c->count_lo;
    f->count_hi_and_cancelled = c->count_hi_and_cancelled;
#endif
    f->MPI_SOURCE = c->MPI_SOURCE;
    f->MPI_TAG    = c->MPI_TAG;
    f->MPI_ERROR  = c->MPI_ERROR;
#if defined(OPEN_MPI)
    f->cancelled = c->_cancelled;
    f->ucount    = c->_ucount;
#endif
#endif
}

MAYBE_UNUSED
static MPI_Comm C_MPI_COMM_FROMINT(int comm_f)
{
    return VAPAA_MPI_Comm_fromint(comm_f);
}

MAYBE_UNUSED
static int C_MPI_COMM_TOINT(MPI_Comm comm_c)
{
    return VAPAA_MPI_Comm_toint(comm_c);
}

MAYBE_UNUSED
static MPI_Datatype C_MPI_TYPE_FROMINT(int type_f)
{
    return VAPAA_MPI_Type_fromint(type_f);
}

MAYBE_UNUSED
static int C_MPI_TYPE_TOINT(MPI_Datatype type_c)
{
    return VAPAA_MPI_Type_toint(type_c);
}

MAYBE_UNUSED
static MPI_Errhandler C_MPI_ERRHANDLER_FROMINT(int errhandler_f)
{
    return VAPAA_MPI_Errhandler_fromint(errhandler_f);
}

MAYBE_UNUSED
static int C_MPI_ERRHANDLER_TOINT(MPI_Errhandler errhandler_c)
{
    return VAPAA_MPI_Errhandler_toint(errhandler_c);
}

MAYBE_UNUSED
static MPI_File C_MPI_FILE_FROMINT(int file_f)
{
    return VAPAA_MPI_File_fromint(file_f);
}

MAYBE_UNUSED
static int C_MPI_FILE_TOINT(MPI_File file_c)
{
    return VAPAA_MPI_File_toint(file_c);
}

MAYBE_UNUSED
static MPI_Group C_MPI_GROUP_FROMINT(int group_f)
{
    return VAPAA_MPI_Group_fromint(group_f);
}

MAYBE_UNUSED
static int C_MPI_GROUP_TOINT(MPI_Group group_c)
{
    return VAPAA_MPI_Group_toint(group_c);
}

MAYBE_UNUSED
static MPI_Info C_MPI_INFO_FROMINT(int info_f)
{
    return VAPAA_MPI_Info_fromint(info_f);
}

MAYBE_UNUSED
static int C_MPI_INFO_TOINT(MPI_Info info_c)
{
    return VAPAA_MPI_Info_toint(info_c);
}

MAYBE_UNUSED
static MPI_Message C_MPI_MESSAGE_FROMINT(int message_f)
{
    return VAPAA_MPI_Message_fromint(message_f);
}

MAYBE_UNUSED
static int C_MPI_MESSAGE_TOINT(MPI_Message message_c)
{
    return VAPAA_MPI_Message_toint(message_c);
}

MAYBE_UNUSED
static MPI_Op C_MPI_OP_FROMINT(int op_f)
{
    return VAPAA_MPI_Op_fromint(op_f);
}

MAYBE_UNUSED
static int C_MPI_OP_TOINT(MPI_Op op_c)
{
    return VAPAA_MPI_Op_toint(op_c);
}

MAYBE_UNUSED
static MPI_Request C_MPI_REQUEST_FROMINT(int request_f)
{
    return VAPAA_MPI_Request_fromint(request_f);
}

MAYBE_UNUSED
static int C_MPI_REQUEST_TOINT(MPI_Request request_c)
{
    return VAPAA_MPI_Request_toint(request_c);
}

#if MPI_VERSION >= 4
MAYBE_UNUSED
static MPI_Session C_MPI_SESSION_FROMINT(int session_f)
{
    return VAPAA_MPI_Session_fromint(session_f);
}

MAYBE_UNUSED
static int C_MPI_SESSION_TOINT(MPI_Session session_c)
{
    return VAPAA_MPI_Session_toint(session_c);
}
#endif

MAYBE_UNUSED
static MPI_Win C_MPI_WIN_FROMINT(int win_f)
{
    return VAPAA_MPI_Win_fromint(win_f);
}

MAYBE_UNUSED
static int C_MPI_WIN_TOINT(MPI_Win win_c)
{
    return VAPAA_MPI_Win_toint(win_c);
}

#endif // CONVERT_HANDLES_H
