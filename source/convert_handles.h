#ifndef CONVERT_HANDLES_H
#define CONVERT_HANDLES_H

#include <stddef.h>
#include <mpi.h>
#include "vapaa_constants.h"

// TODO: move all the constants into a header file and use case-switch.

#define MAYBE_UNUSED __attribute__((unused))

struct F_MPI_Status
{
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
};

MAYBE_UNUSED
static void C_MPI_STATUS_F2C(const struct F_MPI_Status * f, MPI_Status * c)
{
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
    c->cancelled = f->cancelled;
    c->ucount    = f->ucount;
#endif
}

MAYBE_UNUSED
static void C_MPI_STATUS_C2F(const MPI_Status * c, struct F_MPI_Status * f)
{
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
    f->cancelled = c->cancelled;
    f->ucount    = c->ucount;
#endif
}

MAYBE_UNUSED
static MPI_Comm C_MPI_COMM_F2C(int comm_f)
{
    if (comm_f == VAPAA_MPI_COMM_WORLD) {
        return MPI_COMM_WORLD;
    } else if (comm_f == VAPAA_MPI_COMM_SELF) {
        return MPI_COMM_SELF;
    } else if (comm_f == VAPAA_MPI_COMM_NULL) {
        return MPI_COMM_NULL;
    } else {
        return MPI_Comm_f2c(comm_f);
    } 
}

// the numbers in this library are compile-time constants
// and can be used in a case-switch.  the MPI constants are
// guarenteed to be compile-time constants and need to use
// if-else logic. (see below)

#define DT_CASE(type) \
    case VAPAA_##type: { return type; }

MAYBE_UNUSED
static MPI_Datatype C_MPI_TYPE_F2C(int type_f)
{
    switch (type_f) {
        DT_CASE(MPI_DATATYPE_NULL               )
        DT_CASE(MPI_CHARACTER                   )
        DT_CASE(MPI_LOGICAL                     )
        DT_CASE(MPI_INTEGER                     )
        DT_CASE(MPI_REAL                        )
        DT_CASE(MPI_DOUBLE_PRECISION            )
        DT_CASE(MPI_COMPLEX                     )
        DT_CASE(MPI_DOUBLE_COMPLEX              )
        DT_CASE(MPI_INTEGER1                    )
        DT_CASE(MPI_INTEGER2                    )
        DT_CASE(MPI_INTEGER4                    )
        DT_CASE(MPI_INTEGER8                    )
#ifdef HAVE_MPI_INTEGER16
        DT_CASE(MPI_INTEGER16                   )
#endif
#ifdef HAVE_MPI_REAL2
        DT_CASE(MPI_REAL2                       )
#endif
        DT_CASE(MPI_REAL4                       )
        DT_CASE(MPI_REAL8                       )
#ifdef HAVE_MPI_REAL16
        DT_CASE(MPI_REAL16                      )
#endif
#ifdef HAVE_MPI_COMPLEX4
        DT_CASE(MPI_COMPLEX4                    )
#endif
        DT_CASE(MPI_COMPLEX8                    )
        DT_CASE(MPI_COMPLEX16                   )
#ifdef HAVE_MPI_COMPLEX32
        DT_CASE(MPI_COMPLEX32                   )
#endif
        DT_CASE(MPI_AINT                        )
        DT_CASE(MPI_COUNT                       )
        DT_CASE(MPI_OFFSET                      )
        DT_CASE(MPI_BYTE                        )
        DT_CASE(MPI_CHAR                        )
        DT_CASE(MPI_UNSIGNED_CHAR               )
        DT_CASE(MPI_SIGNED_CHAR                 )
        DT_CASE(MPI_WCHAR                       )
        DT_CASE(MPI_SHORT                       )
        DT_CASE(MPI_UNSIGNED_SHORT              )
        DT_CASE(MPI_INT                         )
        DT_CASE(MPI_LONG                        )
        DT_CASE(MPI_UNSIGNED                    )
        DT_CASE(MPI_UNSIGNED_LONG               )
        DT_CASE(MPI_LONG_LONG_INT               )
        DT_CASE(MPI_UNSIGNED_LONG_LONG          )
        DT_CASE(MPI_FLOAT                       )
        DT_CASE(MPI_DOUBLE                      )
        DT_CASE(MPI_LONG_DOUBLE                 )
        DT_CASE(MPI_C_BOOL                      )
        DT_CASE(MPI_INT8_T                      )
        DT_CASE(MPI_INT16_T                     )
        DT_CASE(MPI_INT32_T                     )
        DT_CASE(MPI_INT64_T                     )
        DT_CASE(MPI_UINT8_T                     )
        DT_CASE(MPI_UINT16_T                    )
        DT_CASE(MPI_UINT32_T                    )
        DT_CASE(MPI_UINT64_T                    )
        DT_CASE(MPI_C_COMPLEX                   )
        DT_CASE(MPI_C_FLOAT_COMPLEX             )
        DT_CASE(MPI_C_DOUBLE_COMPLEX            )
        DT_CASE(MPI_C_LONG_DOUBLE_COMPLEX       )
        DT_CASE(MPI_FLOAT_INT                   )
        DT_CASE(MPI_DOUBLE_INT                  )
        DT_CASE(MPI_LONG_INT                    )
        DT_CASE(MPI_2INT                        )
        DT_CASE(MPI_SHORT_INT                   )
        DT_CASE(MPI_LONG_DOUBLE_INT             )
        DT_CASE(MPI_2REAL                       )
        DT_CASE(MPI_2DOUBLE_PRECISION           )
        DT_CASE(MPI_2INTEGER                    )
        default: { return MPI_Type_f2c(type_f); }
    }
}

#undef DT_CASE

MAYBE_UNUSED
static MPI_File C_MPI_FILE_F2C(int file_f)
{
    if (file_f == VAPAA_MPI_FILE_NULL) {
        return MPI_FILE_NULL;
    } else {
        return MPI_File_f2c(file_f);
    } 
}

MAYBE_UNUSED
static MPI_Group C_MPI_GROUP_F2C(int group_f)
{
    if (group_f == VAPAA_MPI_GROUP_NULL) {
        return MPI_GROUP_NULL;
    } else {
        return MPI_Group_f2c(group_f);
    } 
}

MAYBE_UNUSED
static MPI_Info C_MPI_INFO_F2C(int info_f)
{
    if (info_f == VAPAA_MPI_INFO_NULL) {
        return MPI_INFO_NULL;
    } else {
        return MPI_Info_f2c(info_f);
    } 
}

MAYBE_UNUSED
static MPI_Message C_MPI_MESSAGE_F2C(int message_f)
{
    if (message_f == VAPAA_MPI_MESSAGE_NULL) {
        return MPI_MESSAGE_NULL;
    } else if (message_f == VAPAA_MPI_MESSAGE_NO_PROC) {
        return MPI_MESSAGE_NO_PROC;
    } else {
        return MPI_Message_f2c(message_f);
    } 
}

#define OP_CASE(op) \
    case VAPAA_##op: { return op; }

MAYBE_UNUSED
static MPI_Op C_MPI_OP_F2C(int op_f)
{
    switch (op_f) {
        OP_CASE(MPI_OP_NULL)
        OP_CASE(MPI_MAX    )
        OP_CASE(MPI_MIN    )
        OP_CASE(MPI_SUM    )
        OP_CASE(MPI_PROD   )
        OP_CASE(MPI_MAXLOC )
        OP_CASE(MPI_MINLOC )
        OP_CASE(MPI_BAND   )
        OP_CASE(MPI_BOR    )
        OP_CASE(MPI_BXOR   )
        OP_CASE(MPI_LAND   )
        OP_CASE(MPI_LOR    )
        OP_CASE(MPI_LXOR   )
        OP_CASE(MPI_REPLACE)
        OP_CASE(MPI_NO_OP  )
        default: { return MPI_Op_f2c(op_f); }
    } 
}

#undef OP_CASE

MAYBE_UNUSED
static MPI_Request C_MPI_REQUEST_F2C(int request_f)
{
    if (request_f == VAPAA_MPI_REQUEST_NULL) {
        return MPI_REQUEST_NULL;
    } else {
        return MPI_Request_f2c(request_f);
    } 
}

MAYBE_UNUSED
static MPI_Win C_MPI_WIN_F2C(int win_f)
{
    if (win_f == VAPAA_MPI_WIN_NULL) {
        return MPI_WIN_NULL;
    } else {
        return MPI_Win_f2c(win_f);
    } 
}

/*******************************************************/

/* TODO:
 * I do not know if C2F will ever return a built-in.
 * If not, we can eliminate a lot of branches...
 */

#define DT_ELIF(type) \
    else if (type_c == (type)) { \
        return VAPAA_##type; \
    }

MAYBE_UNUSED
static int C_MPI_TYPE_C2F(MPI_Datatype type_c)
{
    if (type_c == MPI_DATATYPE_NULL) {
        return VAPAA_MPI_DATATYPE_NULL;
    }
    DT_ELIF(MPI_CHARACTER                   )
    DT_ELIF(MPI_LOGICAL                     )
    DT_ELIF(MPI_INTEGER                     )
    DT_ELIF(MPI_REAL                        )
    DT_ELIF(MPI_DOUBLE_PRECISION            )
    DT_ELIF(MPI_COMPLEX                     )
    DT_ELIF(MPI_DOUBLE_COMPLEX              )
    DT_ELIF(MPI_INTEGER1                    )
    DT_ELIF(MPI_INTEGER2                    )
    DT_ELIF(MPI_INTEGER4                    )
    DT_ELIF(MPI_INTEGER8                    )
#ifdef HAVE_MPI_INTEGER16
    DT_ELIF(MPI_INTEGER16                   )
#endif
#ifdef HAVE_MPI_REAL2
    DT_ELIF(MPI_REAL2                       )
#endif
    DT_ELIF(MPI_REAL4                       )
    DT_ELIF(MPI_REAL8                       )
#ifdef HAVE_MPI_REAL16
    DT_ELIF(MPI_REAL16                      )
#endif
#ifdef HAVE_MPI_COMPLEX4
    DT_ELIF(MPI_COMPLEX4                    )
#endif
    DT_ELIF(MPI_COMPLEX8                    )
    DT_ELIF(MPI_COMPLEX16                   )
#ifdef HAVE_MPI_COMPLEX32
    DT_ELIF(MPI_COMPLEX32                   )
#endif
    DT_ELIF(MPI_AINT                        )
    DT_ELIF(MPI_COUNT                       )
    DT_ELIF(MPI_OFFSET                      )
    DT_ELIF(MPI_BYTE                        )
    DT_ELIF(MPI_CHAR                        )
    DT_ELIF(MPI_UNSIGNED_CHAR               )
    DT_ELIF(MPI_SIGNED_CHAR                 )
    DT_ELIF(MPI_WCHAR                       )
    DT_ELIF(MPI_SHORT                       )
    DT_ELIF(MPI_UNSIGNED_SHORT              )
    DT_ELIF(MPI_INT                         )
    DT_ELIF(MPI_LONG                        )
    DT_ELIF(MPI_UNSIGNED                    )
    DT_ELIF(MPI_UNSIGNED_LONG               )
    DT_ELIF(MPI_LONG_LONG_INT               )
    DT_ELIF(MPI_UNSIGNED_LONG_LONG          )
    DT_ELIF(MPI_FLOAT                       )
    DT_ELIF(MPI_DOUBLE                      )
    DT_ELIF(MPI_LONG_DOUBLE                 )
    DT_ELIF(MPI_C_BOOL                      )
    DT_ELIF(MPI_INT8_T                      )
    DT_ELIF(MPI_INT16_T                     )
    DT_ELIF(MPI_INT32_T                     )
    DT_ELIF(MPI_INT64_T                     )
    DT_ELIF(MPI_UINT8_T                     )
    DT_ELIF(MPI_UINT16_T                    )
    DT_ELIF(MPI_UINT32_T                    )
    DT_ELIF(MPI_UINT64_T                    )
    DT_ELIF(MPI_C_COMPLEX                   )
    DT_ELIF(MPI_C_FLOAT_COMPLEX             )
    DT_ELIF(MPI_C_DOUBLE_COMPLEX            )
    DT_ELIF(MPI_C_LONG_DOUBLE_COMPLEX       )
    DT_ELIF(MPI_FLOAT_INT                   )
    DT_ELIF(MPI_DOUBLE_INT                  )
    DT_ELIF(MPI_LONG_INT                    )
    DT_ELIF(MPI_2INT                        )
    DT_ELIF(MPI_SHORT_INT                   )
    DT_ELIF(MPI_LONG_DOUBLE_INT             )
    DT_ELIF(MPI_2REAL                       )
    DT_ELIF(MPI_2DOUBLE_PRECISION           )
    DT_ELIF(MPI_2INTEGER                    )
    else {
        return MPI_Type_c2f(type_c);
    } 
}

#undef DT_ELIF

MAYBE_UNUSED
static int C_MPI_REQUEST_C2F(MPI_Request request_c)
{
    if (request_c == MPI_REQUEST_NULL) {
        return VAPAA_MPI_REQUEST_NULL;
    }
    else {
        return MPI_Request_c2f(request_c);
    } 
}

#endif // CONVERT_HANDLES_H
