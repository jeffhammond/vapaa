// SPDX-License-Identifier: MIT

#include "vapaa_abi_handles.h"

#if MPI_VERSION < 5

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include "vapaa_constants.h"

#define DEFINE_HANDLE_TABLE(prefix, Type, first_dynamic) \
    typedef struct { int key; Type value; } prefix##_entry; \
    static prefix##_entry *prefix##_entries = NULL; \
    static size_t prefix##_count = 0; \
    static size_t prefix##_capacity = 0; \
    static int prefix##_next = first_dynamic; \
    static bool prefix##_lookup_key(int key, Type *value) \
    { \
        for (size_t i = 0; i < prefix##_count; ++i) { \
            if (prefix##_entries[i].key == key) { \
                *value = prefix##_entries[i].value; \
                return true; \
            } \
        } \
        return false; \
    } \
    static bool prefix##_lookup_value(Type value, int *key) \
    { \
        for (size_t i = 0; i < prefix##_count; ++i) { \
            if (prefix##_entries[i].value == value) { \
                *key = prefix##_entries[i].key; \
                return true; \
            } \
        } \
        return false; \
    } \
    static int prefix##_store(Type value) \
    { \
        int key; \
        if (prefix##_lookup_value(value, &key)) { \
            return key; \
        } \
        if (prefix##_count == prefix##_capacity) { \
            size_t new_capacity = prefix##_capacity ? 2 * prefix##_capacity : 16; \
            prefix##_entry *new_entries = realloc(prefix##_entries, new_capacity * sizeof(*new_entries)); \
            if (new_entries == NULL) { \
                perror("realloc"); \
                abort(); \
            } \
            prefix##_entries = new_entries; \
            prefix##_capacity = new_capacity; \
        } \
        prefix##_entries[prefix##_count].key = prefix##_next++; \
        prefix##_entries[prefix##_count].value = value; \
        return prefix##_entries[prefix##_count++].key; \
    }

DEFINE_HANDLE_TABLE(comm, MPI_Comm, 0x40010000)
DEFINE_HANDLE_TABLE(datatype, MPI_Datatype, 0x40020000)
DEFINE_HANDLE_TABLE(errhandler, MPI_Errhandler, 0x400a0000)
DEFINE_HANDLE_TABLE(file, MPI_File, 0x40030000)
DEFINE_HANDLE_TABLE(group, MPI_Group, 0x40040000)
DEFINE_HANDLE_TABLE(info, MPI_Info, 0x40050000)
DEFINE_HANDLE_TABLE(message, MPI_Message, 0x40060000)
DEFINE_HANDLE_TABLE(op, MPI_Op, 0x40070000)
DEFINE_HANDLE_TABLE(request, MPI_Request, 0x40080000)
#if MPI_VERSION >= 4
DEFINE_HANDLE_TABLE(session, MPI_Session, 0x400b0000)
#endif
DEFINE_HANDLE_TABLE(win, MPI_Win, 0x40090000)

static MPI_Datatype datatype_or_fallback(MPI_Datatype datatype, MPI_Datatype fallback)
{
    return (datatype == MPI_DATATYPE_NULL) ? fallback : datatype;
}

MPI_Comm VAPAA_MPI_Comm_fromint(int comm)
{
    MPI_Comm value;
    switch (comm) {
        case VAPAA_MPI_COMM_NULL:  return MPI_COMM_NULL;
        case VAPAA_MPI_COMM_WORLD: return MPI_COMM_WORLD;
        case VAPAA_MPI_COMM_SELF:  return MPI_COMM_SELF;
        default:
            if (comm_lookup_key(comm, &value)) {
                return value;
            }
            return MPI_Comm_f2c(comm);
    }
}

int VAPAA_MPI_Comm_toint(MPI_Comm comm)
{
    if (comm == MPI_COMM_NULL)  { return VAPAA_MPI_COMM_NULL; }
    if (comm == MPI_COMM_WORLD) { return VAPAA_MPI_COMM_WORLD; }
    if (comm == MPI_COMM_SELF)  { return VAPAA_MPI_COMM_SELF; }
    return comm_store(comm);
}

MPI_Errhandler VAPAA_MPI_Errhandler_fromint(int errhandler)
{
    MPI_Errhandler value;
    switch (errhandler) {
        case VAPAA_MPI_ERRHANDLER_NULL:  return MPI_ERRHANDLER_NULL;
        case VAPAA_MPI_ERRORS_ARE_FATAL: return MPI_ERRORS_ARE_FATAL;
#ifdef MPI_ERRORS_ABORT
        case VAPAA_MPI_ERRORS_ABORT:     return MPI_ERRORS_ABORT;
#endif
        case VAPAA_MPI_ERRORS_RETURN:    return MPI_ERRORS_RETURN;
        default:
            if (errhandler_lookup_key(errhandler, &value)) {
                return value;
            }
            return MPI_Errhandler_f2c(errhandler);
    }
}

int VAPAA_MPI_Errhandler_toint(MPI_Errhandler errhandler)
{
    if (errhandler == MPI_ERRHANDLER_NULL)  { return VAPAA_MPI_ERRHANDLER_NULL; }
    if (errhandler == MPI_ERRORS_ARE_FATAL) { return VAPAA_MPI_ERRORS_ARE_FATAL; }
#ifdef MPI_ERRORS_ABORT
    if (errhandler == MPI_ERRORS_ABORT)     { return VAPAA_MPI_ERRORS_ABORT; }
#endif
    if (errhandler == MPI_ERRORS_RETURN)    { return VAPAA_MPI_ERRORS_RETURN; }
    return errhandler_store(errhandler);
}

MPI_File VAPAA_MPI_File_fromint(int file)
{
    MPI_File value;
    if (file == VAPAA_MPI_FILE_NULL) {
        return MPI_FILE_NULL;
    }
    if (file_lookup_key(file, &value)) {
        return value;
    }
    return MPI_File_f2c(file);
}

int VAPAA_MPI_File_toint(MPI_File file)
{
    if (file == MPI_FILE_NULL) {
        return VAPAA_MPI_FILE_NULL;
    }
    return file_store(file);
}

MPI_Group VAPAA_MPI_Group_fromint(int group)
{
    MPI_Group value;
    switch (group) {
        case VAPAA_MPI_GROUP_NULL:  return MPI_GROUP_NULL;
        case VAPAA_MPI_GROUP_EMPTY: return MPI_GROUP_EMPTY;
        default:
            if (group_lookup_key(group, &value)) {
                return value;
            }
            return MPI_Group_f2c(group);
    }
}

int VAPAA_MPI_Group_toint(MPI_Group group)
{
    if (group == MPI_GROUP_NULL)  { return VAPAA_MPI_GROUP_NULL; }
    if (group == MPI_GROUP_EMPTY) { return VAPAA_MPI_GROUP_EMPTY; }
    return group_store(group);
}

MPI_Info VAPAA_MPI_Info_fromint(int info)
{
    MPI_Info value;
    switch (info) {
        case VAPAA_MPI_INFO_NULL: return MPI_INFO_NULL;
#ifdef MPI_INFO_ENV
        case VAPAA_MPI_INFO_ENV:  return MPI_INFO_ENV;
#endif
        default:
            if (info_lookup_key(info, &value)) {
                return value;
            }
            return MPI_Info_f2c(info);
    }
}

int VAPAA_MPI_Info_toint(MPI_Info info)
{
    if (info == MPI_INFO_NULL) { return VAPAA_MPI_INFO_NULL; }
#ifdef MPI_INFO_ENV
    if (info == MPI_INFO_ENV)  { return VAPAA_MPI_INFO_ENV; }
#endif
    return info_store(info);
}

MPI_Message VAPAA_MPI_Message_fromint(int message)
{
    MPI_Message value;
    switch (message) {
        case VAPAA_MPI_MESSAGE_NULL:    return MPI_MESSAGE_NULL;
        case VAPAA_MPI_MESSAGE_NO_PROC: return MPI_MESSAGE_NO_PROC;
        default:
            if (message_lookup_key(message, &value)) {
                return value;
            }
            return MPI_Message_f2c(message);
    }
}

int VAPAA_MPI_Message_toint(MPI_Message message)
{
    if (message == MPI_MESSAGE_NULL)    { return VAPAA_MPI_MESSAGE_NULL; }
    if (message == MPI_MESSAGE_NO_PROC) { return VAPAA_MPI_MESSAGE_NO_PROC; }
    return message_store(message);
}

MPI_Op VAPAA_MPI_Op_fromint(int op)
{
    MPI_Op value;
    switch (op) {
        case VAPAA_MPI_OP_NULL: return MPI_OP_NULL;
        case VAPAA_MPI_SUM:     return MPI_SUM;
        case VAPAA_MPI_MIN:     return MPI_MIN;
        case VAPAA_MPI_MAX:     return MPI_MAX;
        case VAPAA_MPI_PROD:    return MPI_PROD;
        case VAPAA_MPI_BAND:    return MPI_BAND;
        case VAPAA_MPI_BOR:     return MPI_BOR;
        case VAPAA_MPI_BXOR:    return MPI_BXOR;
        case VAPAA_MPI_LAND:    return MPI_LAND;
        case VAPAA_MPI_LOR:     return MPI_LOR;
        case VAPAA_MPI_LXOR:    return MPI_LXOR;
        case VAPAA_MPI_MINLOC:  return MPI_MINLOC;
        case VAPAA_MPI_MAXLOC:  return MPI_MAXLOC;
        case VAPAA_MPI_REPLACE: return MPI_REPLACE;
        case VAPAA_MPI_NO_OP:   return MPI_NO_OP;
        default:
            if (op_lookup_key(op, &value)) {
                return value;
            }
            return MPI_Op_f2c(op);
    }
}

int VAPAA_MPI_Op_toint(MPI_Op op)
{
    if (op == MPI_OP_NULL) { return VAPAA_MPI_OP_NULL; }
    if (op == MPI_SUM)     { return VAPAA_MPI_SUM; }
    if (op == MPI_MIN)     { return VAPAA_MPI_MIN; }
    if (op == MPI_MAX)     { return VAPAA_MPI_MAX; }
    if (op == MPI_PROD)    { return VAPAA_MPI_PROD; }
    if (op == MPI_BAND)    { return VAPAA_MPI_BAND; }
    if (op == MPI_BOR)     { return VAPAA_MPI_BOR; }
    if (op == MPI_BXOR)    { return VAPAA_MPI_BXOR; }
    if (op == MPI_LAND)    { return VAPAA_MPI_LAND; }
    if (op == MPI_LOR)     { return VAPAA_MPI_LOR; }
    if (op == MPI_LXOR)    { return VAPAA_MPI_LXOR; }
    if (op == MPI_MINLOC)  { return VAPAA_MPI_MINLOC; }
    if (op == MPI_MAXLOC)  { return VAPAA_MPI_MAXLOC; }
    if (op == MPI_REPLACE) { return VAPAA_MPI_REPLACE; }
    if (op == MPI_NO_OP)   { return VAPAA_MPI_NO_OP; }
    return op_store(op);
}

MPI_Request VAPAA_MPI_Request_fromint(int request)
{
    MPI_Request value;
    if (request == VAPAA_MPI_REQUEST_NULL) {
        return MPI_REQUEST_NULL;
    }
    if (request_lookup_key(request, &value)) {
        return value;
    }
    return MPI_Request_f2c(request);
}

int VAPAA_MPI_Request_toint(MPI_Request request)
{
    if (request == MPI_REQUEST_NULL) {
        return VAPAA_MPI_REQUEST_NULL;
    }
    return request_store(request);
}

#if MPI_VERSION >= 4
MPI_Session VAPAA_MPI_Session_fromint(int session)
{
    MPI_Session value;
    if (session == VAPAA_MPI_SESSION_NULL) {
        return MPI_SESSION_NULL;
    }
    if (session_lookup_key(session, &value)) {
        return value;
    }
    return MPI_Session_f2c(session);
}

int VAPAA_MPI_Session_toint(MPI_Session session)
{
    if (session == MPI_SESSION_NULL) {
        return VAPAA_MPI_SESSION_NULL;
    }
    return session_store(session);
}
#endif

MPI_Datatype VAPAA_MPI_Type_fromint(int datatype)
{
    MPI_Datatype value;
    switch (datatype) {
        case VAPAA_MPI_DATATYPE_NULL:             return MPI_DATATYPE_NULL;
        case VAPAA_MPI_AINT:                      return MPI_AINT;
        case VAPAA_MPI_COUNT:                     return MPI_COUNT;
        case VAPAA_MPI_OFFSET:                    return MPI_OFFSET;
#ifdef MPI_LB
        case VAPAA_MPI_LB:                        return MPI_LB;
#else
        case VAPAA_MPI_LB:                        return MPI_DATATYPE_NULL;
#endif
#ifdef MPI_UB
        case VAPAA_MPI_UB:                        return MPI_UB;
#else
        case VAPAA_MPI_UB:                        return MPI_DATATYPE_NULL;
#endif
        case VAPAA_MPI_PACKED:                    return MPI_PACKED;
        case VAPAA_MPI_SHORT:                     return MPI_SHORT;
        case VAPAA_MPI_INT:                       return MPI_INT;
        case VAPAA_MPI_LONG:                      return MPI_LONG;
        case VAPAA_MPI_LONG_LONG_INT:             return MPI_LONG_LONG_INT;
        case VAPAA_MPI_UNSIGNED_SHORT:            return MPI_UNSIGNED_SHORT;
        case VAPAA_MPI_UNSIGNED:                  return MPI_UNSIGNED;
        case VAPAA_MPI_UNSIGNED_LONG:             return MPI_UNSIGNED_LONG;
        case VAPAA_MPI_UNSIGNED_LONG_LONG:        return MPI_UNSIGNED_LONG_LONG;
        case VAPAA_MPI_FLOAT:                     return MPI_FLOAT;
        case VAPAA_MPI_C_FLOAT_COMPLEX:           return MPI_C_FLOAT_COMPLEX;
        case VAPAA_MPI_DOUBLE:                    return MPI_DOUBLE;
        case VAPAA_MPI_C_DOUBLE_COMPLEX:          return MPI_C_DOUBLE_COMPLEX;
        case VAPAA_MPI_LOGICAL:                   return datatype_or_fallback(MPI_LOGICAL, MPI_INT);
        case VAPAA_MPI_INTEGER:                   return datatype_or_fallback(MPI_INTEGER, MPI_INT);
        case VAPAA_MPI_REAL:                      return datatype_or_fallback(MPI_REAL, MPI_FLOAT);
        case VAPAA_MPI_COMPLEX:                   return datatype_or_fallback(MPI_COMPLEX, MPI_C_FLOAT_COMPLEX);
        case VAPAA_MPI_DOUBLE_PRECISION:          return datatype_or_fallback(MPI_DOUBLE_PRECISION, MPI_DOUBLE);
        case VAPAA_MPI_DOUBLE_COMPLEX:            return datatype_or_fallback(MPI_DOUBLE_COMPLEX, MPI_C_DOUBLE_COMPLEX);
        case VAPAA_MPI_CHARACTER:                 return datatype_or_fallback(MPI_CHARACTER, MPI_CHAR);
        case VAPAA_MPI_LONG_DOUBLE:               return MPI_LONG_DOUBLE;
        case VAPAA_MPI_C_LONG_DOUBLE_COMPLEX:     return MPI_C_LONG_DOUBLE_COMPLEX;
        case VAPAA_MPI_FLOAT_INT:                 return MPI_FLOAT_INT;
        case VAPAA_MPI_DOUBLE_INT:                return MPI_DOUBLE_INT;
        case VAPAA_MPI_LONG_INT:                  return MPI_LONG_INT;
        case VAPAA_MPI_2INT:                      return MPI_2INT;
        case VAPAA_MPI_SHORT_INT:                 return MPI_SHORT_INT;
        case VAPAA_MPI_LONG_DOUBLE_INT:           return MPI_LONG_DOUBLE_INT;
        case VAPAA_MPI_2REAL:                     return datatype_or_fallback(MPI_2REAL, MPI_FLOAT_INT);
        case VAPAA_MPI_2DOUBLE_PRECISION:         return datatype_or_fallback(MPI_2DOUBLE_PRECISION, MPI_DOUBLE_INT);
        case VAPAA_MPI_2INTEGER:                  return datatype_or_fallback(MPI_2INTEGER, MPI_2INT);
        case VAPAA_MPI_C_BOOL:                    return MPI_C_BOOL;
        case VAPAA_MPI_WCHAR:                     return MPI_WCHAR;
        case VAPAA_MPI_INT8_T:                    return MPI_INT8_T;
        case VAPAA_MPI_UINT8_T:                   return MPI_UINT8_T;
        case VAPAA_MPI_CHAR:                      return MPI_CHAR;
        case VAPAA_MPI_SIGNED_CHAR:               return MPI_SIGNED_CHAR;
        case VAPAA_MPI_UNSIGNED_CHAR:             return MPI_UNSIGNED_CHAR;
        case VAPAA_MPI_BYTE:                      return MPI_BYTE;
        case VAPAA_MPI_INT16_T:                   return MPI_INT16_T;
        case VAPAA_MPI_UINT16_T:                  return MPI_UINT16_T;
        case VAPAA_MPI_INT32_T:                   return MPI_INT32_T;
        case VAPAA_MPI_UINT32_T:                  return MPI_UINT32_T;
        case VAPAA_MPI_INT64_T:                   return MPI_INT64_T;
        case VAPAA_MPI_UINT64_T:                  return MPI_UINT64_T;
        case VAPAA_MPI_INTEGER1:                  return datatype_or_fallback(MPI_INTEGER1, MPI_INT8_T);
        case VAPAA_MPI_INTEGER2:                  return datatype_or_fallback(MPI_INTEGER2, MPI_INT16_T);
#ifdef HAVE_MPI_REAL2
        case VAPAA_MPI_REAL2:                     return MPI_REAL2;
#endif
        case VAPAA_MPI_INTEGER4:                  return datatype_or_fallback(MPI_INTEGER4, MPI_INT32_T);
        case VAPAA_MPI_REAL4:                     return datatype_or_fallback(MPI_REAL4, MPI_FLOAT);
#ifdef HAVE_MPI_COMPLEX4
        case VAPAA_MPI_COMPLEX4:                  return datatype_or_fallback(MPI_COMPLEX4, MPI_C_FLOAT_COMPLEX);
#endif
        case VAPAA_MPI_INTEGER8:                  return datatype_or_fallback(MPI_INTEGER8, MPI_INT64_T);
        case VAPAA_MPI_REAL8:                     return datatype_or_fallback(MPI_REAL8, MPI_DOUBLE);
        case VAPAA_MPI_COMPLEX8:                  return datatype_or_fallback(MPI_COMPLEX8, MPI_C_DOUBLE_COMPLEX);
#ifdef HAVE_MPI_INTEGER16
        case VAPAA_MPI_INTEGER16:                 return MPI_INTEGER16;
#endif
#ifdef HAVE_MPI_REAL16
        case VAPAA_MPI_REAL16:                    return MPI_REAL16;
#endif
        case VAPAA_MPI_COMPLEX16:                 return datatype_or_fallback(MPI_COMPLEX16, MPI_C_DOUBLE_COMPLEX);
#ifdef HAVE_MPI_COMPLEX32
        case VAPAA_MPI_COMPLEX32:                 return MPI_COMPLEX32;
#endif
        default:
            if (datatype_lookup_key(datatype, &value)) {
                return value;
            }
            return MPI_Type_f2c(datatype);
    }
}

int VAPAA_MPI_Type_toint(MPI_Datatype datatype)
{
    if (datatype == MPI_DATATYPE_NULL)          { return VAPAA_MPI_DATATYPE_NULL; }
    if (datatype == MPI_AINT)                   { return VAPAA_MPI_AINT; }
    if (datatype == MPI_COUNT)                  { return VAPAA_MPI_COUNT; }
    if (datatype == MPI_OFFSET)                 { return VAPAA_MPI_OFFSET; }
#ifdef MPI_LB
    if (datatype == MPI_LB)                     { return VAPAA_MPI_LB; }
#endif
#ifdef MPI_UB
    if (datatype == MPI_UB)                     { return VAPAA_MPI_UB; }
#endif
    if (datatype == MPI_PACKED)                 { return VAPAA_MPI_PACKED; }
    if (datatype == MPI_SHORT)                  { return VAPAA_MPI_SHORT; }
    if (datatype == MPI_INT)                    { return VAPAA_MPI_INT; }
    if (datatype == MPI_LONG)                   { return VAPAA_MPI_LONG; }
    if (datatype == MPI_LONG_LONG_INT)          { return VAPAA_MPI_LONG_LONG_INT; }
    if (datatype == MPI_UNSIGNED_SHORT)         { return VAPAA_MPI_UNSIGNED_SHORT; }
    if (datatype == MPI_UNSIGNED)               { return VAPAA_MPI_UNSIGNED; }
    if (datatype == MPI_UNSIGNED_LONG)          { return VAPAA_MPI_UNSIGNED_LONG; }
    if (datatype == MPI_UNSIGNED_LONG_LONG)     { return VAPAA_MPI_UNSIGNED_LONG_LONG; }
    if (datatype == MPI_FLOAT)                  { return VAPAA_MPI_FLOAT; }
    if (datatype == MPI_C_FLOAT_COMPLEX)        { return VAPAA_MPI_C_FLOAT_COMPLEX; }
    if (datatype == MPI_DOUBLE)                 { return VAPAA_MPI_DOUBLE; }
    if (datatype == MPI_C_DOUBLE_COMPLEX)       { return VAPAA_MPI_C_DOUBLE_COMPLEX; }
    if (datatype == MPI_LOGICAL)                { return VAPAA_MPI_LOGICAL; }
    if (datatype == MPI_INTEGER)                { return VAPAA_MPI_INTEGER; }
    if (datatype == MPI_REAL)                   { return VAPAA_MPI_REAL; }
    if (datatype == MPI_COMPLEX)                { return VAPAA_MPI_COMPLEX; }
    if (datatype == MPI_DOUBLE_PRECISION)       { return VAPAA_MPI_DOUBLE_PRECISION; }
    if (datatype == MPI_DOUBLE_COMPLEX)         { return VAPAA_MPI_DOUBLE_COMPLEX; }
    if (datatype == MPI_CHARACTER)              { return VAPAA_MPI_CHARACTER; }
    if (datatype == MPI_LONG_DOUBLE)            { return VAPAA_MPI_LONG_DOUBLE; }
    if (datatype == MPI_C_LONG_DOUBLE_COMPLEX)  { return VAPAA_MPI_C_LONG_DOUBLE_COMPLEX; }
    if (datatype == MPI_FLOAT_INT)              { return VAPAA_MPI_FLOAT_INT; }
    if (datatype == MPI_DOUBLE_INT)             { return VAPAA_MPI_DOUBLE_INT; }
    if (datatype == MPI_LONG_INT)               { return VAPAA_MPI_LONG_INT; }
    if (datatype == MPI_2INT)                   { return VAPAA_MPI_2INT; }
    if (datatype == MPI_SHORT_INT)              { return VAPAA_MPI_SHORT_INT; }
    if (datatype == MPI_LONG_DOUBLE_INT)        { return VAPAA_MPI_LONG_DOUBLE_INT; }
    if (datatype == MPI_2REAL)                  { return VAPAA_MPI_2REAL; }
    if (datatype == MPI_2DOUBLE_PRECISION)      { return VAPAA_MPI_2DOUBLE_PRECISION; }
    if (datatype == MPI_2INTEGER)               { return VAPAA_MPI_2INTEGER; }
    if (datatype == MPI_C_BOOL)                 { return VAPAA_MPI_C_BOOL; }
    if (datatype == MPI_WCHAR)                  { return VAPAA_MPI_WCHAR; }
    if (datatype == MPI_INT8_T)                 { return VAPAA_MPI_INT8_T; }
    if (datatype == MPI_UINT8_T)                { return VAPAA_MPI_UINT8_T; }
    if (datatype == MPI_CHAR)                   { return VAPAA_MPI_CHAR; }
    if (datatype == MPI_SIGNED_CHAR)            { return VAPAA_MPI_SIGNED_CHAR; }
    if (datatype == MPI_UNSIGNED_CHAR)          { return VAPAA_MPI_UNSIGNED_CHAR; }
    if (datatype == MPI_BYTE)                   { return VAPAA_MPI_BYTE; }
    if (datatype == MPI_INT16_T)                { return VAPAA_MPI_INT16_T; }
    if (datatype == MPI_UINT16_T)               { return VAPAA_MPI_UINT16_T; }
    if (datatype == MPI_INT32_T)                { return VAPAA_MPI_INT32_T; }
    if (datatype == MPI_UINT32_T)               { return VAPAA_MPI_UINT32_T; }
    if (datatype == MPI_INT64_T)                { return VAPAA_MPI_INT64_T; }
    if (datatype == MPI_UINT64_T)               { return VAPAA_MPI_UINT64_T; }
    if (datatype == MPI_INTEGER1)               { return VAPAA_MPI_INTEGER1; }
    if (datatype == MPI_INTEGER2)               { return VAPAA_MPI_INTEGER2; }
#ifdef HAVE_MPI_REAL2
    if (datatype == MPI_REAL2)                  { return VAPAA_MPI_REAL2; }
#endif
    if (datatype == MPI_INTEGER4)               { return VAPAA_MPI_INTEGER4; }
    if (datatype == MPI_REAL4)                  { return VAPAA_MPI_REAL4; }
#ifdef HAVE_MPI_COMPLEX4
    if (datatype == MPI_COMPLEX4)               { return VAPAA_MPI_COMPLEX4; }
#endif
    if (datatype == MPI_INTEGER8)               { return VAPAA_MPI_INTEGER8; }
    if (datatype == MPI_REAL8)                  { return VAPAA_MPI_REAL8; }
    if (datatype == MPI_COMPLEX8)               { return VAPAA_MPI_COMPLEX8; }
#ifdef HAVE_MPI_INTEGER16
    if (datatype == MPI_INTEGER16)              { return VAPAA_MPI_INTEGER16; }
#endif
#ifdef HAVE_MPI_REAL16
    if (datatype == MPI_REAL16)                 { return VAPAA_MPI_REAL16; }
#endif
    if (datatype == MPI_COMPLEX16)              { return VAPAA_MPI_COMPLEX16; }
#ifdef HAVE_MPI_COMPLEX32
    if (datatype == MPI_COMPLEX32)              { return VAPAA_MPI_COMPLEX32; }
#endif
    return datatype_store(datatype);
}

MPI_Win VAPAA_MPI_Win_fromint(int win)
{
    MPI_Win value;
    if (win == VAPAA_MPI_WIN_NULL) {
        return MPI_WIN_NULL;
    }
    if (win_lookup_key(win, &value)) {
        return value;
    }
    return MPI_Win_f2c(win);
}

int VAPAA_MPI_Win_toint(MPI_Win win)
{
    if (win == MPI_WIN_NULL) {
        return VAPAA_MPI_WIN_NULL;
    }
    return win_store(win);
}

#endif
