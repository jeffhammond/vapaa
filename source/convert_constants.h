#ifndef CONVERT_CONSTANTS_H
#define CONVERT_CONSTANTS_H

#include <stdio.h>
#include <mpi.h>
#include "vapaa_constants.h"

#define MAYBE_UNUSED __attribute__((unused))

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
MAYBE_UNUSED static inline int C_MPI_THREAD_LEVEL_F2C(int level) { return level; }
MAYBE_UNUSED static inline int C_MPI_THREAD_LEVEL_C2F(int level) { return level; }
MAYBE_UNUSED static inline int C_MPI_COMPARE_RESULT_F2C(int result) { return result; }
MAYBE_UNUSED static inline int C_MPI_COMPARE_RESULT_C2F(int result) { return result; }

#else

#define C_MPI_RC_FIX(rc) \
    do { \
        if ((rc) != MPI_SUCCESS) { (rc) = C_MPI_ERROR_CODE_C2F((rc)); } \
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
    } else {
       return f;
    }
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

#endif

#endif
