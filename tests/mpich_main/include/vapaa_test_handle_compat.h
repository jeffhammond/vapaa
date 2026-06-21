// SPDX-License-Identifier: MIT

#ifndef VAPAA_TEST_HANDLE_COMPAT_H
#define VAPAA_TEST_HANDLE_COMPAT_H

#define VAPAA_TEST_HANDLE_COMPAT 1

#include <mpi.h>
#include "vapaa_abi_handles.h"
#include "vapaa_constants.h"

#if defined(MPI_ABI_VERSION) && !defined(MPI_Fint)
typedef int MPI_Fint;
#endif

#ifdef MPI_Comm_f2c
#undef MPI_Comm_f2c
#endif
#ifdef MPI_Comm_c2f
#undef MPI_Comm_c2f
#endif
#define MPI_Comm_f2c(comm) VAPAA_MPI_Comm_fromint((int)(comm))
#define MPI_Comm_c2f(comm) ((MPI_Fint) VAPAA_MPI_Comm_toint((comm)))

#ifdef MPI_Datatype_f2c
#undef MPI_Datatype_f2c
#endif
#ifdef MPI_Datatype_c2f
#undef MPI_Datatype_c2f
#endif
#define MPI_Datatype_f2c(datatype) VAPAA_MPI_Type_fromint((int)(datatype))
#define MPI_Datatype_c2f(datatype) ((MPI_Fint) VAPAA_MPI_Type_toint((datatype)))

#ifdef MPI_Type_f2c
#undef MPI_Type_f2c
#endif
#ifdef MPI_Type_c2f
#undef MPI_Type_c2f
#endif
static inline MPI_Fint VAPAA_TEST_MPI_Type_c2f(MPI_Datatype datatype)
{
    if (datatype == MPI_LOGICAL)          { return (MPI_Fint) VAPAA_MPI_LOGICAL; }
    if (datatype == MPI_INTEGER)          { return (MPI_Fint) VAPAA_MPI_INTEGER; }
    if (datatype == MPI_REAL)             { return (MPI_Fint) VAPAA_MPI_REAL; }
    if (datatype == MPI_COMPLEX)          { return (MPI_Fint) VAPAA_MPI_COMPLEX; }
    if (datatype == MPI_DOUBLE_PRECISION) { return (MPI_Fint) VAPAA_MPI_DOUBLE_PRECISION; }
    if (datatype == MPI_DOUBLE_COMPLEX)   { return (MPI_Fint) VAPAA_MPI_DOUBLE_COMPLEX; }
    if (datatype == MPI_CHARACTER)        { return (MPI_Fint) VAPAA_MPI_CHARACTER; }
#ifdef MPI_2REAL
    if (datatype == MPI_2REAL)            { return (MPI_Fint) VAPAA_MPI_2REAL; }
#endif
#ifdef MPI_2DOUBLE_PRECISION
    if (datatype == MPI_2DOUBLE_PRECISION){ return (MPI_Fint) VAPAA_MPI_2DOUBLE_PRECISION; }
#endif
#ifdef MPI_2INTEGER
    if (datatype == MPI_2INTEGER)         { return (MPI_Fint) VAPAA_MPI_2INTEGER; }
#endif
#ifdef MPI_INTEGER1
    if (datatype == MPI_INTEGER1)         { return (MPI_Fint) VAPAA_MPI_INTEGER1; }
#endif
#ifdef MPI_INTEGER2
    if (datatype == MPI_INTEGER2)         { return (MPI_Fint) VAPAA_MPI_INTEGER2; }
#endif
#ifdef MPI_INTEGER4
    if (datatype == MPI_INTEGER4)         { return (MPI_Fint) VAPAA_MPI_INTEGER4; }
#endif
#ifdef MPI_INTEGER8
    if (datatype == MPI_INTEGER8)         { return (MPI_Fint) VAPAA_MPI_INTEGER8; }
#endif
    return (MPI_Fint) VAPAA_MPI_Type_toint(datatype);
}
#define MPI_Type_f2c(datatype) VAPAA_MPI_Type_fromint((int)(datatype))
#define MPI_Type_c2f(datatype) VAPAA_TEST_MPI_Type_c2f((datatype))

#ifdef MPI_Errhandler_f2c
#undef MPI_Errhandler_f2c
#endif
#ifdef MPI_Errhandler_c2f
#undef MPI_Errhandler_c2f
#endif
#define MPI_Errhandler_f2c(errhandler) VAPAA_MPI_Errhandler_fromint((int)(errhandler))
#define MPI_Errhandler_c2f(errhandler) ((MPI_Fint) VAPAA_MPI_Errhandler_toint((errhandler)))

#ifdef MPI_File_f2c
#undef MPI_File_f2c
#endif
#ifdef MPI_File_c2f
#undef MPI_File_c2f
#endif
#define MPI_File_f2c(file) VAPAA_MPI_File_fromint((int)(file))
#define MPI_File_c2f(file) ((MPI_Fint) VAPAA_MPI_File_toint((file)))

#ifdef MPI_Group_f2c
#undef MPI_Group_f2c
#endif
#ifdef MPI_Group_c2f
#undef MPI_Group_c2f
#endif
#define MPI_Group_f2c(group) VAPAA_MPI_Group_fromint((int)(group))
#define MPI_Group_c2f(group) ((MPI_Fint) VAPAA_MPI_Group_toint((group)))

#ifdef MPI_Info_f2c
#undef MPI_Info_f2c
#endif
#ifdef MPI_Info_c2f
#undef MPI_Info_c2f
#endif
#define MPI_Info_f2c(info) VAPAA_MPI_Info_fromint((int)(info))
#define MPI_Info_c2f(info) ((MPI_Fint) VAPAA_MPI_Info_toint((info)))

#ifdef MPI_Message_f2c
#undef MPI_Message_f2c
#endif
#ifdef MPI_Message_c2f
#undef MPI_Message_c2f
#endif
#define MPI_Message_f2c(message) VAPAA_MPI_Message_fromint((int)(message))
#define MPI_Message_c2f(message) ((MPI_Fint) VAPAA_MPI_Message_toint((message)))

#ifdef MPI_Op_f2c
#undef MPI_Op_f2c
#endif
#ifdef MPI_Op_c2f
#undef MPI_Op_c2f
#endif
#define MPI_Op_f2c(op) VAPAA_MPI_Op_fromint((int)(op))
#define MPI_Op_c2f(op) ((MPI_Fint) VAPAA_MPI_Op_toint((op)))

#ifdef MPI_Request_f2c
#undef MPI_Request_f2c
#endif
#ifdef MPI_Request_c2f
#undef MPI_Request_c2f
#endif
#define MPI_Request_f2c(request) VAPAA_MPI_Request_fromint((int)(request))
#define MPI_Request_c2f(request) ((MPI_Fint) VAPAA_MPI_Request_toint((request)))

#ifdef MPI_Win_f2c
#undef MPI_Win_f2c
#endif
#ifdef MPI_Win_c2f
#undef MPI_Win_c2f
#endif
#define MPI_Win_f2c(win) VAPAA_MPI_Win_fromint((int)(win))
#define MPI_Win_c2f(win) ((MPI_Fint) VAPAA_MPI_Win_toint((win)))

#if MPI_VERSION >= 4
#ifdef MPI_Session_f2c
#undef MPI_Session_f2c
#endif
#ifdef MPI_Session_c2f
#undef MPI_Session_c2f
#endif
#define MPI_Session_f2c(session) VAPAA_MPI_Session_fromint((int)(session))
#define MPI_Session_c2f(session) ((MPI_Fint) VAPAA_MPI_Session_toint((session)))
#endif

#endif
