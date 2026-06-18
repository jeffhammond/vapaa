#ifndef CONVERT_CONSTANTS_H
#define CONVERT_CONSTANTS_H

#include <stdio.h>
#include <mpi.h>
#include "vapaa_constants.h"

#define MAYBE_UNUSED __attribute__((unused))

#ifndef MPI_ERR_UNSUPPORTED_OPERATION
#define MPI_ERR_UNSUPPORTED_OPERATION MPI_ERR_OTHER
#endif

int C_MPI_ERROR_CODE_C2F(int error_c);
int C_MPI_ERROR_CODE_F2C(int error_f);

#if MPI_VERSION >= 5

#define C_MPI_RC_FIX(rc) do { (void)(rc); } while (0)

MAYBE_UNUSED static inline int C_MPI_SOURCE_F2C(int rank) { return rank; }
MAYBE_UNUSED static inline int C_MPI_SOURCE_C2F(int rank) { return rank; }
MAYBE_UNUSED static inline int C_MPI_DEST_F2C(int rank) { return rank; }
MAYBE_UNUSED static inline int C_MPI_TAG_F2C(int tag) { return tag; }
MAYBE_UNUSED static inline int C_MPI_TAG_C2F(int tag) { return tag; }
MAYBE_UNUSED static inline int C_MPI_ROOT_F2C(int root) { return root; }
MAYBE_UNUSED static inline int C_MPI_PROC_NULL_DETECTOR(int rank) { return rank; }
MAYBE_UNUSED static inline int C_MPI_COMM_ATTR_GLOBAL_F2C(int attr) { return attr; }
MAYBE_UNUSED static inline int C_MPI_WIN_ATTR_GLOBAL_F2C(int attr) { return attr; }
MAYBE_UNUSED static inline int C_MPI_COMM_ATTR_GLOBAL_IS_PREDEFINED(int attr)
{
    return attr == VAPAA_MPI_TAG_UB ||
           attr == VAPAA_MPI_IO ||
           attr == VAPAA_MPI_HOST ||
           attr == VAPAA_MPI_WTIME_IS_GLOBAL ||
           attr == VAPAA_MPI_APPNUM ||
           attr == VAPAA_MPI_LASTUSEDCODE ||
           attr == VAPAA_MPI_UNIVERSE_SIZE;
}
MAYBE_UNUSED static inline int C_MPI_COMM_ATTR_VALUE_C2F(int attr, int value)
{
    (void) attr;
    return value;
}
MAYBE_UNUSED static inline int C_MPI_WIN_ATTR_GLOBAL_IS_PREDEFINED_VALUE(int attr)
{
    return attr == VAPAA_MPI_WIN_DISP_UNIT ||
           attr == VAPAA_MPI_WIN_SIZE ||
           attr == VAPAA_MPI_WIN_CREATE_FLAVOR ||
           attr == VAPAA_MPI_WIN_MODEL;
}
MAYBE_UNUSED static inline int C_MPI_THREAD_LEVEL_F2C(int level) { return level; }
MAYBE_UNUSED static inline int C_MPI_THREAD_LEVEL_C2F(int level) { return level; }
MAYBE_UNUSED static inline int C_MPI_COMPARE_RESULT_F2C(int result) { return result; }
MAYBE_UNUSED static inline int C_MPI_COMPARE_RESULT_C2F(int result) { return result; }
MAYBE_UNUSED static inline int C_MPI_UNDEFINED_C2F(int value) { return value; }
MAYBE_UNUSED static inline int C_MPI_TOPOLOGY_C2F(int topology) { return topology; }

#else

MAYBE_UNUSED
static inline int C_MPI_CAN_TRANSLATE_ERROR_CODES(void)
{
    int initialized = 0;
    int finalized = 0;
    MPI_Initialized(&initialized);
    MPI_Finalized(&finalized);
    return initialized && !finalized;
}

#define C_MPI_RC_FIX(rc) \
    do { \
        if ((rc) != MPI_SUCCESS && C_MPI_CAN_TRANSLATE_ERROR_CODES()) { \
            (rc) = C_MPI_ERROR_CODE_C2F((rc)); \
        } \
    } while (0)

MAYBE_UNUSED
static inline int C_MPI_SOURCE_F2C(int rank)
{
    if (rank == VAPAA_MPI_ANY_SOURCE) {
        return MPI_ANY_SOURCE;
    } else if (rank == VAPAA_MPI_PROC_NULL) {
        return MPI_PROC_NULL;
    } else {
        return rank;
    }
}

MAYBE_UNUSED
static inline int C_MPI_SOURCE_C2F(int rank)
{
    if (rank == MPI_PROC_NULL) {
        return VAPAA_MPI_PROC_NULL;
    } else {
        return rank;
    }
}

MAYBE_UNUSED
static inline int C_MPI_DEST_F2C(int rank)
{
    return rank == VAPAA_MPI_PROC_NULL ? MPI_PROC_NULL : rank;
}

MAYBE_UNUSED
static inline int C_MPI_TAG_F2C(int tag)
{
    return tag == VAPAA_MPI_ANY_TAG ? MPI_ANY_TAG : tag;
}

MAYBE_UNUSED
static inline int C_MPI_TAG_C2F(int tag)
{
    return tag == MPI_ANY_TAG ? VAPAA_MPI_ANY_TAG : tag;
}

MAYBE_UNUSED
static inline int C_MPI_ROOT_F2C(int root)
{
    if (root == VAPAA_MPI_ROOT) {
        return MPI_ROOT;
    } else if (root == VAPAA_MPI_PROC_NULL) {
        return MPI_PROC_NULL;
    } else {
        return root;
    }
}

MAYBE_UNUSED
static inline int C_MPI_PROC_NULL_DETECTOR(int rank)
{
    return C_MPI_SOURCE_F2C(rank);
}

MAYBE_UNUSED
static inline int C_MPI_COMM_ATTR_GLOBAL_F2C(int f)
{
    if (f == VAPAA_MPI_TAG_UB) {
       return MPI_TAG_UB;
    } else if (f == VAPAA_MPI_IO) {
       return MPI_IO;
    } else if (f == VAPAA_MPI_HOST) {
       return MPI_HOST;
    } else if (f == VAPAA_MPI_WTIME_IS_GLOBAL) {
       return MPI_WTIME_IS_GLOBAL;
    } else if (f == VAPAA_MPI_APPNUM) {
       return MPI_APPNUM;
    } else if (f == VAPAA_MPI_LASTUSEDCODE) {
       return MPI_LASTUSEDCODE;
    } else if (f == VAPAA_MPI_UNIVERSE_SIZE) {
       return MPI_UNIVERSE_SIZE;
    } else {
       return f;
    }
}

MAYBE_UNUSED
static inline int C_MPI_WIN_ATTR_GLOBAL_F2C(int f)
{
    if (f == VAPAA_MPI_WIN_BASE) {
       return MPI_WIN_BASE;
    } else if (f == VAPAA_MPI_WIN_DISP_UNIT) {
       return MPI_WIN_DISP_UNIT;
    } else if (f == VAPAA_MPI_WIN_SIZE) {
       return MPI_WIN_SIZE;
    } else if (f == VAPAA_MPI_WIN_CREATE_FLAVOR) {
       return MPI_WIN_CREATE_FLAVOR;
    } else if (f == VAPAA_MPI_WIN_MODEL) {
       return MPI_WIN_MODEL;
    } else {
       return f;
    }
}

MAYBE_UNUSED
static inline int C_MPI_COMM_ATTR_GLOBAL_IS_PREDEFINED(int f)
{
    return f == MPI_TAG_UB ||
           f == MPI_IO ||
           f == MPI_HOST ||
           f == MPI_WTIME_IS_GLOBAL ||
           f == MPI_APPNUM ||
           f == MPI_LASTUSEDCODE ||
           f == MPI_UNIVERSE_SIZE;
}

MAYBE_UNUSED
static inline int C_MPI_COMM_ATTR_VALUE_C2F(int attr, int value)
{
    if (attr == MPI_HOST) {
       return value == MPI_PROC_NULL ? VAPAA_MPI_PROC_NULL : value;
    } else if (attr == MPI_IO) {
       if (value == MPI_ANY_SOURCE) {
          return VAPAA_MPI_ANY_SOURCE;
       } else if (value == MPI_PROC_NULL) {
          return VAPAA_MPI_PROC_NULL;
       } else {
          return value;
       }
    } else if (attr == MPI_LASTUSEDCODE) {
       return value < VAPAA_MPI_ERR_LASTCODE ? VAPAA_MPI_ERR_LASTCODE : value;
    } else {
       return value;
    }
}

MAYBE_UNUSED
static inline int C_MPI_WIN_ATTR_GLOBAL_IS_PREDEFINED_VALUE(int f)
{
    return f == MPI_WIN_DISP_UNIT ||
           f == MPI_WIN_SIZE ||
           f == MPI_WIN_CREATE_FLAVOR ||
           f == MPI_WIN_MODEL;
}

MAYBE_UNUSED
static int C_MPI_THREAD_LEVEL_F2C(int level_f)
{
    if (level_f == VAPAA_MPI_THREAD_MULTIPLE) {
       return MPI_THREAD_MULTIPLE;
    } else if (level_f == VAPAA_MPI_THREAD_SERIALIZED) {
       return MPI_THREAD_SERIALIZED;
    } else if (level_f == VAPAA_MPI_THREAD_FUNNELED) {
       return MPI_THREAD_FUNNELED;
    } else {
       return MPI_THREAD_SINGLE;
    }
}

MAYBE_UNUSED
static int C_MPI_THREAD_LEVEL_C2F(int level_c)
{
    if (level_c == MPI_THREAD_MULTIPLE) {
       return VAPAA_MPI_THREAD_MULTIPLE;
    } else if (level_c == MPI_THREAD_SERIALIZED) {
       return VAPAA_MPI_THREAD_SERIALIZED;
    } else if (level_c == MPI_THREAD_FUNNELED) {
       return VAPAA_MPI_THREAD_FUNNELED;
    } else {
       return VAPAA_MPI_THREAD_SINGLE;
    }
}

MAYBE_UNUSED
static int C_MPI_COMPARE_RESULT_F2C(int result_f)
{
    if (result_f == VAPAA_MPI_UNEQUAL) {
       return MPI_UNEQUAL;
    } else if (result_f == VAPAA_MPI_SIMILAR) {
       return MPI_SIMILAR;
    } else if (result_f == VAPAA_MPI_CONGRUENT) {
       return MPI_CONGRUENT;
    } else if (result_f == VAPAA_MPI_IDENT) {
       return MPI_IDENT;
    } else {
        fprintf(stderr, "invalid comparison result (%d)\n", result_f);
        MPI_Abort(MPI_COMM_SELF, result_f);
        return -1;
    }
}

MAYBE_UNUSED
static int C_MPI_COMPARE_RESULT_C2F(int result_c)
{
    if (result_c == MPI_UNEQUAL) {
       return VAPAA_MPI_UNEQUAL;
    } else if (result_c == MPI_SIMILAR) {
       return VAPAA_MPI_SIMILAR;
    } else if (result_c == MPI_CONGRUENT) {
       return VAPAA_MPI_CONGRUENT;
    } else if (result_c == MPI_IDENT) {
       return VAPAA_MPI_IDENT;
    } else {
        fprintf(stderr, "invalid comparison result (%d)\n", result_c);
        MPI_Abort(MPI_COMM_SELF, result_c);
        return -1;
    }
}

MAYBE_UNUSED
static inline int C_MPI_UNDEFINED_C2F(int value)
{
    return value == MPI_UNDEFINED ? VAPAA_MPI_UNDEFINED : value;
}

MAYBE_UNUSED
static int C_MPI_TOPOLOGY_C2F(int topology_c)
{
    if (topology_c == MPI_UNDEFINED) {
       return VAPAA_MPI_UNDEFINED;
    } else if (topology_c == MPI_CART) {
       return VAPAA_MPI_CART;
    } else if (topology_c == MPI_GRAPH) {
       return VAPAA_MPI_GRAPH;
#if MPI_VERSION >= 3
    } else if (topology_c == MPI_DIST_GRAPH) {
       return VAPAA_MPI_DIST_GRAPH;
#endif
    } else {
        fprintf(stderr, "invalid topology (%d)\n", topology_c);
        MPI_Abort(MPI_COMM_SELF, topology_c);
        return -1;
    }
}

#endif

#endif
