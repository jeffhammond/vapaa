// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "mpi_attr_storage.h"
#include "detect_sentinels.h"
#include "debug.h"

typedef void (*vapaa_comm_copy_fn)(int *, int *, intptr_t *, intptr_t *, intptr_t *, int *, int *);
typedef void (*vapaa_comm_delete_fn)(int *, int *, intptr_t *, intptr_t *, int *);
typedef void (*vapaa_keyval_copy_fn)(int *, int *, int *, int *, int *, int *, int *);
typedef void (*vapaa_keyval_delete_fn)(int *, int *, int *, int *, int *);
typedef void (*vapaa_type_copy_fn)(int *, int *, intptr_t *, intptr_t *, intptr_t *, int *, int *);
typedef void (*vapaa_type_delete_fn)(int *, int *, intptr_t *, intptr_t *, int *);
typedef void (*vapaa_win_copy_fn)(int *, int *, intptr_t *, intptr_t *, intptr_t *, int *, int *);
typedef void (*vapaa_win_delete_fn)(int *, int *, intptr_t *, intptr_t *, int *);

typedef void (*vapaa_greq_query_fn)(intptr_t *, MPI_Status *, int *);
typedef void (*vapaa_greq_free_fn)(intptr_t *, int *);
typedef void (*vapaa_greq_cancel_fn)(intptr_t *, int *, int *);

typedef void (*vapaa_datarep_fn)(void *, int *, int *, void *, int64_t *, intptr_t *, int *);
typedef void (*vapaa_datarep_c_fn)(void *, int *, int64_t *, void *, int64_t *, intptr_t *, int *);
typedef void (*vapaa_datarep_extent_fn)(int *, intptr_t *, intptr_t *, int *);

struct vapaa_comm_keyval_state { vapaa_comm_copy_fn copy; vapaa_comm_delete_fn del; intptr_t extra; };
struct vapaa_keyval_state { vapaa_keyval_copy_fn copy; vapaa_keyval_delete_fn del; int extra; };
struct vapaa_type_keyval_state { vapaa_type_copy_fn copy; vapaa_type_delete_fn del; intptr_t extra; };
struct vapaa_win_keyval_state { vapaa_win_copy_fn copy; vapaa_win_delete_fn del; intptr_t extra; };
struct vapaa_greq_state { vapaa_greq_query_fn query; vapaa_greq_free_fn free_fn; vapaa_greq_cancel_fn cancel; intptr_t *extra; };
struct vapaa_datarep_state { void *read_fn; void *write_fn; vapaa_datarep_extent_fn extent_fn; intptr_t extra; int use_count; };

static int comm_copy_trampoline(MPI_Comm comm, int keyval, void *extra_state, void *attr_in, void *attr_out, int *flag)
{
    struct vapaa_comm_keyval_state *s = extra_state;
    int comm_f = C_MPI_COMM_TOINT(comm), ierror = MPI_SUCCESS, flag_f = 0;
    intptr_t extra = s->extra, in = 0, out = 0;
    if (!VAPAA_MPI_Attr_load_aint(attr_in, &in)) {
        in = (intptr_t) attr_in;
    }
    s->copy(&comm_f, &keyval, &extra, &in, &out, &flag_f, &ierror);
    *flag = flag_f;
    if (flag_f) *(void **)attr_out = VAPAA_MPI_Attr_store_aint(out);
    return ierror;
}

static int comm_delete_trampoline(MPI_Comm comm, int keyval, void *attr, void *extra_state)
{
    struct vapaa_comm_keyval_state *s = extra_state;
    int comm_f = C_MPI_COMM_TOINT(comm), ierror = MPI_SUCCESS;
    intptr_t extra = s->extra, attr_f = 0;
    if (!VAPAA_MPI_Attr_load_aint(attr, &attr_f)) {
        attr_f = (intptr_t) attr;
    }
    s->del(&comm_f, &keyval, &attr_f, &extra, &ierror);
    VAPAA_MPI_Attr_forget(attr);
    return ierror;
}

static int keyval_copy_trampoline(MPI_Comm comm, int keyval, void *extra_state,
                                  void *attr_in, void *attr_out, int *flag)
{
    struct vapaa_keyval_state *s = extra_state;
    int comm_f = C_MPI_COMM_TOINT(comm), ierror = MPI_SUCCESS, flag_f = 0;
    int extra = s->extra, in = 0, out = 0;
    if (!VAPAA_MPI_Attr_load_fint(attr_in, &in)) {
        in = (int)(intptr_t) attr_in;
    }
    s->copy(&comm_f, &keyval, &extra, &in, &out, &flag_f, &ierror);
    *flag = flag_f;
    if (flag_f) *(void **)attr_out = VAPAA_MPI_Attr_store_fint(out);
    return ierror;
}

static int keyval_delete_trampoline(MPI_Comm comm, int keyval, void *attr, void *extra_state)
{
    struct vapaa_keyval_state *s = extra_state;
    int comm_f = C_MPI_COMM_TOINT(comm), ierror = MPI_SUCCESS;
    int extra = s->extra, attr_f = 0;
    if (!VAPAA_MPI_Attr_load_fint(attr, &attr_f)) {
        attr_f = (int)(intptr_t) attr;
    }
    s->del(&comm_f, &keyval, &attr_f, &extra, &ierror);
    VAPAA_MPI_Attr_forget(attr);
    return ierror;
}

static int type_copy_trampoline(MPI_Datatype datatype, int keyval, void *extra_state, void *attr_in, void *attr_out, int *flag)
{
    struct vapaa_type_keyval_state *s = extra_state;
    int datatype_f = C_MPI_TYPE_TOINT(datatype), ierror = MPI_SUCCESS, flag_f = 0;
    intptr_t extra = s->extra, in = 0, out = 0;
    if (!VAPAA_MPI_Attr_load_aint(attr_in, &in)) {
        in = (intptr_t) attr_in;
    }
    s->copy(&datatype_f, &keyval, &extra, &in, &out, &flag_f, &ierror);
    *flag = flag_f;
    if (flag_f) *(void **)attr_out = VAPAA_MPI_Attr_store_aint(out);
    return ierror;
}

static int type_delete_trampoline(MPI_Datatype datatype, int keyval, void *attr, void *extra_state)
{
    struct vapaa_type_keyval_state *s = extra_state;
    int datatype_f = C_MPI_TYPE_TOINT(datatype), ierror = MPI_SUCCESS;
    intptr_t extra = s->extra, attr_f = 0;
    if (!VAPAA_MPI_Attr_load_aint(attr, &attr_f)) {
        attr_f = (intptr_t) attr;
    }
    s->del(&datatype_f, &keyval, &attr_f, &extra, &ierror);
    VAPAA_MPI_Attr_forget(attr);
    return ierror;
}

static int win_copy_trampoline(MPI_Win win, int keyval, void *extra_state, void *attr_in, void *attr_out, int *flag)
{
    struct vapaa_win_keyval_state *s = extra_state;
    int win_f = C_MPI_WIN_TOINT(win), ierror = MPI_SUCCESS, flag_f = 0;
    intptr_t extra = s->extra, in = 0, out = 0;
    if (!VAPAA_MPI_Attr_load_aint(attr_in, &in)) {
        in = (intptr_t) attr_in;
    }
    s->copy(&win_f, &keyval, &extra, &in, &out, &flag_f, &ierror);
    *flag = flag_f;
    if (flag_f) *(void **)attr_out = VAPAA_MPI_Attr_store_aint(out);
    return ierror;
}

static int win_delete_trampoline(MPI_Win win, int keyval, void *attr, void *extra_state)
{
    struct vapaa_win_keyval_state *s = extra_state;
    int win_f = C_MPI_WIN_TOINT(win), ierror = MPI_SUCCESS;
    intptr_t extra = s->extra, attr_f = 0;
    if (!VAPAA_MPI_Attr_load_aint(attr, &attr_f)) {
        attr_f = (intptr_t) attr;
    }
    s->del(&win_f, &keyval, &attr_f, &extra, &ierror);
    VAPAA_MPI_Attr_forget(attr);
    return ierror;
}

static int greq_query_trampoline(void *extra_state, MPI_Status *status)
{
    struct vapaa_greq_state *s = extra_state;
    int ierror = MPI_SUCCESS;
    s->query(s->extra, status, &ierror);
    return ierror;
}

static int greq_free_trampoline(void *extra_state)
{
    struct vapaa_greq_state *s = extra_state;
    int ierror = MPI_SUCCESS;
    s->free_fn(s->extra, &ierror);
    free(s);
    return ierror;
}

static int greq_cancel_trampoline(void *extra_state, int complete)
{
    struct vapaa_greq_state *s = extra_state;
    int ierror = MPI_SUCCESS, complete_f = complete;
    s->cancel(s->extra, &complete_f, &ierror);
    return ierror;
}

static int datarep_read_trampoline(void *userbuf, MPI_Datatype datatype, int count, void *filebuf, MPI_Offset position, void *extra_state)
{
    struct vapaa_datarep_state *s = extra_state;
    int datatype_f = C_MPI_TYPE_TOINT(datatype), ierror = MPI_SUCCESS, count_f = count;
    int64_t position_f = (int64_t)position;
    intptr_t extra = s->extra;
    ((vapaa_datarep_fn)s->read_fn)(userbuf, &datatype_f, &count_f, filebuf, &position_f, &extra, &ierror);
    return ierror;
}

static int datarep_write_trampoline(void *userbuf, MPI_Datatype datatype, int count, void *filebuf, MPI_Offset position, void *extra_state)
{
    struct vapaa_datarep_state *s = extra_state;
    int datatype_f = C_MPI_TYPE_TOINT(datatype), ierror = MPI_SUCCESS, count_f = count;
    int64_t position_f = (int64_t)position;
    intptr_t extra = s->extra;
    ((vapaa_datarep_fn)s->write_fn)(userbuf, &datatype_f, &count_f, filebuf, &position_f, &extra, &ierror);
    return ierror;
}

MAYBE_UNUSED static int datarep_read_c_trampoline(void *userbuf, MPI_Datatype datatype, MPI_Count count,
                                                  void *filebuf, MPI_Offset position, void *extra_state)
{
    struct vapaa_datarep_state *s = extra_state;
    int datatype_f = C_MPI_TYPE_TOINT(datatype), ierror = MPI_SUCCESS;
    int64_t count_f = (int64_t)count, position_f = (int64_t)position;
    intptr_t extra = s->extra;
    ((vapaa_datarep_c_fn)s->read_fn)(userbuf, &datatype_f, &count_f, filebuf, &position_f, &extra, &ierror);
    return ierror;
}

MAYBE_UNUSED static int datarep_write_c_trampoline(void *userbuf, MPI_Datatype datatype, MPI_Count count,
                                                   void *filebuf, MPI_Offset position, void *extra_state)
{
    struct vapaa_datarep_state *s = extra_state;
    int datatype_f = C_MPI_TYPE_TOINT(datatype), ierror = MPI_SUCCESS;
    int64_t count_f = (int64_t)count, position_f = (int64_t)position;
    intptr_t extra = s->extra;
    ((vapaa_datarep_c_fn)s->write_fn)(userbuf, &datatype_f, &count_f, filebuf, &position_f, &extra, &ierror);
    return ierror;
}

static int datarep_extent_trampoline(MPI_Datatype datatype, MPI_Aint *extent, void *extra_state)
{
    struct vapaa_datarep_state *s = extra_state;
    int datatype_f = C_MPI_TYPE_TOINT(datatype), ierror = MPI_SUCCESS;
    intptr_t extra = s->extra, extent_f = 0;
    s->extent_fn(&datatype_f, &extent_f, &extra, &ierror);
    *extent = (MPI_Aint)extent_f;
    return ierror;
}

void VAPAA_MPI_Comm_create_errhandler(void *fn, int *errhandler_f, int *ierror)
{
    MPI_Errhandler errhandler = MPI_ERRHANDLER_NULL;
    *ierror = MPI_Comm_create_errhandler((MPI_Comm_errhandler_function *)fn, &errhandler);
    *errhandler_f = C_MPI_ERRHANDLER_TOINT(errhandler);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_File_create_errhandler(void *fn, int *errhandler_f, int *ierror)
{
    MPI_Errhandler errhandler = MPI_ERRHANDLER_NULL;
    *ierror = MPI_File_create_errhandler((MPI_File_errhandler_function *)fn, &errhandler);
    *errhandler_f = C_MPI_ERRHANDLER_TOINT(errhandler);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_create_errhandler(void *fn, int *errhandler_f, int *ierror)
{
    MPI_Errhandler errhandler = MPI_ERRHANDLER_NULL;
    *ierror = MPI_Win_create_errhandler((MPI_Win_errhandler_function *)fn, &errhandler);
    *errhandler_f = C_MPI_ERRHANDLER_TOINT(errhandler);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Session_create_errhandler(void *fn, int *errhandler_f, int *ierror)
{
    MPI_Errhandler errhandler = MPI_ERRHANDLER_NULL;
#if MPI_VERSION >= 4
    *ierror = MPI_Session_create_errhandler((MPI_Session_errhandler_function *)fn, &errhandler);
#else
    (void) fn;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    *errhandler_f = C_MPI_ERRHANDLER_TOINT(errhandler);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_create_keyval(void *copy, void *del, int *keyval, intptr_t *extra, int *ierror)
{
    struct vapaa_comm_keyval_state *s = malloc(sizeof(*s));
    VAPAA_Assert(s != NULL);
    s->copy = (vapaa_comm_copy_fn)copy; s->del = (vapaa_comm_delete_fn)del; s->extra = *extra;
    *ierror = MPI_Comm_create_keyval(comm_copy_trampoline, comm_delete_trampoline, keyval, s);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Type_create_keyval(void *copy, void *del, int *keyval, intptr_t *extra, int *ierror)
{
    struct vapaa_type_keyval_state *s = malloc(sizeof(*s));
    VAPAA_Assert(s != NULL);
    s->copy = (vapaa_type_copy_fn)copy; s->del = (vapaa_type_delete_fn)del; s->extra = *extra;
    *ierror = MPI_Type_create_keyval(type_copy_trampoline, type_delete_trampoline, keyval, s);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Win_create_keyval(void *copy, void *del, int *keyval, intptr_t *extra, int *ierror)
{
    struct vapaa_win_keyval_state *s = malloc(sizeof(*s));
    VAPAA_Assert(s != NULL);
    s->copy = (vapaa_win_copy_fn)copy; s->del = (vapaa_win_delete_fn)del; s->extra = *extra;
    *ierror = MPI_Win_create_keyval(win_copy_trampoline, win_delete_trampoline, keyval, s);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Keyval_create(void *copy, void *del, int *keyval, int *extra, int *ierror)
{
    struct vapaa_keyval_state *s = malloc(sizeof(*s));
    VAPAA_Assert(s != NULL);
    s->copy = (vapaa_keyval_copy_fn)copy;
    s->del = (vapaa_keyval_delete_fn)del;
    s->extra = *extra;
    *ierror = MPI_Keyval_create(keyval_copy_trampoline, keyval_delete_trampoline, keyval, s);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Grequest_start(void *query, void *free_fn, void *cancel, intptr_t *extra, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    struct vapaa_greq_state *s = malloc(sizeof(*s));
    VAPAA_Assert(s != NULL);
    s->query = (vapaa_greq_query_fn)query; s->free_fn = (vapaa_greq_free_fn)free_fn;
    s->cancel = (vapaa_greq_cancel_fn)cancel; s->extra = extra;
    *ierror = MPI_Grequest_start(greq_query_trampoline, greq_free_trampoline, greq_cancel_trampoline, s, &request);
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Grequest_complete(int *request_f, int *ierror)
{
    MPI_Request request = C_MPI_REQUEST_FROMINT(*request_f);
    *ierror = MPI_Grequest_complete(request);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Op_create_c(void *fn, int *commute, int *op_f, int *ierror)
{
    MPI_Op op = MPI_OP_NULL;
#if MPI_VERSION >= 4
    *ierror = MPI_Op_create_c((MPI_User_function_c *)fn, *commute, &op);
#else
    (void) fn;
    (void) commute;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    *op_f = C_MPI_OP_TOINT(op);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Register_datarep(const char datarep[], void *read_fn, void *write_fn, void *extent_fn,
                                intptr_t *extra, int *ierror)
{
    struct vapaa_datarep_state *s = malloc(sizeof(*s));
    VAPAA_Assert(s != NULL);
    s->read_fn = read_fn; s->write_fn = write_fn; s->extent_fn = (vapaa_datarep_extent_fn)extent_fn;
    s->extra = *extra; s->use_count = 0;
    *ierror = MPI_Register_datarep(datarep, datarep_read_trampoline, datarep_write_trampoline,
                                   datarep_extent_trampoline, s);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Register_datarep_c(const char datarep[], void *read_fn, void *write_fn, void *extent_fn,
                                  intptr_t *extra, int *ierror)
{
#if MPI_VERSION >= 4
    struct vapaa_datarep_state *s = malloc(sizeof(*s));
    VAPAA_Assert(s != NULL);
    s->read_fn = read_fn; s->write_fn = write_fn; s->extent_fn = (vapaa_datarep_extent_fn)extent_fn;
    s->extra = *extra; s->use_count = 1;
    *ierror = MPI_Register_datarep_c(datarep, datarep_read_c_trampoline, datarep_write_c_trampoline,
                                     datarep_extent_trampoline, s);
#else
    (void) datarep;
    (void) read_fn;
    (void) write_fn;
    (void) extent_fn;
    (void) extra;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_spawn(const char command[], int *maxprocs, int *info_f, int *root, int *comm_f,
                          int *intercomm_f, int errcodes_f[], int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Comm intercomm = MPI_COMM_NULL;
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    int *errcodes = C_IS_MPI_ERRCODES_IGNORE(errcodes_f) ? MPI_ERRCODES_IGNORE : errcodes_f;
    *ierror = MPI_Comm_spawn(command, MPI_ARGV_NULL, *maxprocs, info, C_MPI_ROOT_F2C(*root), comm, &intercomm, errcodes);
    *intercomm_f = C_MPI_COMM_TOINT(intercomm);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_spawn_multiple(int *count, const char commands[], int *command_len, const int maxprocs[],
                                   const int info_f[], int *root, int *comm_f, int *intercomm_f,
                                   int errcodes_f[], int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Comm intercomm = MPI_COMM_NULL;
    MPI_Info *infos = malloc((size_t)*count * sizeof(*infos));
    char **cmds = malloc((size_t)*count * sizeof(*cmds));
    VAPAA_Assert(infos != NULL && cmds != NULL);
    for (int i = 0; i < *count; ++i) {
        infos[i] = C_MPI_INFO_FROMINT(info_f[i]);
        cmds[i] = (char *)&commands[i * (*command_len)];
    }
    int *errcodes = C_IS_MPI_ERRCODES_IGNORE(errcodes_f) ? MPI_ERRCODES_IGNORE : errcodes_f;
    *ierror = MPI_Comm_spawn_multiple(*count, cmds, MPI_ARGVS_NULL, maxprocs, infos, C_MPI_ROOT_F2C(*root),
                                      comm, &intercomm, errcodes);
    *intercomm_f = C_MPI_COMM_TOINT(intercomm);
    free(infos);
    free(cmds);
    C_MPI_RC_FIX(*ierror);
}
