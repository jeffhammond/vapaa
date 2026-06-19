// SPDX-License-Identifier: MIT

#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

#include "convert_handles.h"
#include "detect_sentinels.h"
#include "vapaa_constants.h"

typedef void (*vapaa_c_funptr)(void);

void C_MPI_Init(int *ierror);
void C_MPI_Init_thread(int *required, int *provided, int *ierror);
void C_MPI_Finalize(int *ierror);
void C_MPI_Initialized(int *flag, int *ierror);
void C_MPI_Finalized(int *flag, int *ierror);
void C_MPI_Query_thread(int *provided, int *ierror);
void C_MPI_Is_thread_main(int *flag, int *ierror);
void C_MPI_Abort(int *comm, int *errorcode, int *ierror);
void C_MPI_Get_version(int *version, int *subversion, int *ierror);
void C_MPI_Get_library_version(char *version, int *resultlen, int *ierror);
void C_MPI_Get_processor_name(char *name, int *resultlen, int *ierror);
double C_MPI_Wtime(void);
double C_MPI_Wtick(void);

void C_MPI_Comm_rank(int *comm, int *rank, int *ierror);
void C_MPI_Comm_size(int *comm, int *size, int *ierror);
void C_MPI_Comm_dup(int *comm, int *newcomm, int *ierror);
void C_MPI_Comm_split(int *comm, int *color, int *key, int *newcomm, int *ierror);
void C_MPI_Comm_split_type(int *comm, int *type, int *key, int *info, int *newcomm, int *ierror);
void C_MPI_Comm_free(int *comm, int *ierror);
void C_MPI_Comm_group(int *comm, int *group, int *ierror);
void VAPAA_MPI_Comm_remote_size(int *comm, int *size, int *ierror);
void C_MPI_Comm_set_errhandler(int *comm, int *errhandler, int *ierror);
void C_MPI_Comm_get_errhandler(int *comm, int *errhandler, int *ierror);
void C_MPI_Comm_call_errhandler(int *comm, int *errorcode, int *ierror);
void C_MPI_Comm_get_name(int *comm, char *name, int *resultlen, int *ierror);
void C_MPI_Comm_set_name(int *comm, char *name, int *ierror);
void C_MPI_Dims_create(int *nnodes, int *ndims, int *dims, int *ierror);
void C_MPI_Cart_create(int *comm, int *ndims, int *dims, int *periods, int *reorder,
                       int *newcomm, int *ierror);
void C_MPI_Cart_get(int *comm, int *maxdims, int *dims, int *periods, int *coords, int *ierror);
void C_MPI_Cart_shift(int *comm, int *direction, int *disp, int *rank_source, int *rank_dest,
                      int *ierror);
void C_MPI_Dist_graph_create(int *comm_old, int *n, int *sources, int *degrees, int *destinations,
                             int *weights, int *info, int *reorder, int *comm_dist_graph,
                             int *ierror);
void C_MPI_Dist_graph_create_adjacent(int *comm_old, int *indegree, int *sources,
                                      int *sourceweights, int *outdegree, int *destinations,
                                      int *destweights, int *info, int *reorder,
                                      int *comm_dist_graph, int *ierror);
void C_MPI_Dist_graph_neighbors(int *comm, int *maxindegree, int *sources, int *sourceweights,
                                int *maxoutdegree, int *destinations, int *destweights,
                                int *ierror);
void C_MPI_Dist_graph_neighbors_count(int *comm, int *indegree, int *outdegree, int *weighted,
                                      int *ierror);
void C_MPI_Topo_test(int *comm, int *status, int *ierror);

void C_MPI_Group_free(int *group, int *ierror);
void C_MPI_Group_size(int *group, int *size, int *ierror);
void C_MPI_Group_rank(int *group, int *rank, int *ierror);
void C_MPI_Group_incl(int *group, int *n, int *ranks, int *newgroup, int *ierror);
void C_MPI_Group_compare(int *group1, int *group2, int *result, int *ierror);

void C_MPI_Barrier(int *comm, int *ierror);
void C_MPI_Bcast(void *buffer, int count, int datatype, int root, int comm, int *ierror);
void C_MPI_Gather(const void *input, int *scount, int *stype, void *output, int *rcount,
                  int *rtype, int *root, int *comm, int *ierror);
void C_MPI_Gatherv(const void *input, int *scount, int *stype, void *output, const int rcounts[],
                   const int rdisps[], int *rtype, int *root, int *comm, int *ierror);
void C_MPI_Scatter(const void *input, int *scount, int *stype, void *output, int *rcount,
                   int *rtype, int *root, int *comm, int *ierror);
void C_MPI_Scatterv(const void *input, const int scounts[], const int sdisps[], int *stype,
                    void *output, int *rcount, int *rtype, int *root, int *comm, int *ierror);
void C_MPI_Alltoall(const void *input, int *scount, int *stype, void *output, int *rcount,
                    int *rtype, int *comm, int *ierror);
void C_MPI_Alltoallv(const void *input, const int scounts[], const int sdisps[], int *stype,
                     void *output, const int rcounts[], const int rdisps[], int *rtype,
                     int *comm, int *ierror);
void C_MPI_Allreduce(const void *sendbuf, void *recvbuf, int *count, int *datatype, int *op,
                     int *comm, int *ierror);

void C_MPI_Send(void *buffer, int count, int datatype, int dest, int tag, int comm, int *ierror);
void C_MPI_Bsend(void *buffer, int count, int datatype, int dest, int tag, int comm, int *ierror);
void C_MPI_Ssend(void *buffer, int count, int datatype, int dest, int tag, int comm, int *ierror);
void C_MPI_Rsend(void *buffer, int count, int datatype, int dest, int tag, int comm, int *ierror);
void C_MPI_Isend(void *buffer, int count, int datatype, int dest, int tag, int comm,
                 int *request, int *ierror);
void C_MPI_Issend(void *buffer, int count, int datatype, int dest, int tag, int comm,
                  int *request, int *ierror);
void C_MPI_Irsend(void *buffer, int count, int datatype, int dest, int tag, int comm,
                  int *request, int *ierror);
void C_MPI_Recv(void *buffer, int count, int datatype, int source, int tag, int comm,
                struct F_MPI_Status *status, int *ierror);
void C_MPI_Irecv(void *buffer, int count, int datatype, int source, int tag, int comm,
                 int *request, int *ierror);
void C_MPI_Wait(int *request, struct F_MPI_Status *status, int *ierror);
void C_MPI_Waitall(int count, int requests[], struct F_MPI_Status statuses[], int *ierror);
void C_MPI_Test(int *request, int *flag, struct F_MPI_Status *status, int *ierror);
void C_MPI_Testall(int count, int requests[], int *flag, struct F_MPI_Status statuses[], int *ierror);
void C_MPI_Testsome(int incount, int requests[], int *outcount, int indices[],
                    struct F_MPI_Status statuses[], int *ierror);
void C_MPI_Testany(int count, int requests[], int *index, int *flag, struct F_MPI_Status *status,
                   int *ierror);
void C_MPI_Waitany(int count, int requests[], int *index, struct F_MPI_Status *status, int *ierror);
void C_MPI_Waitsome(int incount, int requests[], int *outcount, int indices[],
                    struct F_MPI_Status statuses[], int *ierror);
void C_MPI_Probe(int source, int tag, int comm, struct F_MPI_Status *status, int *ierror);
void C_MPI_Mprobe(int source, int tag, int comm, int *message, struct F_MPI_Status *status, int *ierror);
void C_MPI_Iprobe(int source, int tag, int comm, int *flag, struct F_MPI_Status *status, int *ierror);
void C_MPI_Improbe(int source, int tag, int comm, int *flag, int *message,
                   struct F_MPI_Status *status, int *ierror);
void VAPAA_MPI_Get_count(const struct F_MPI_Status *status, int *datatype, int *count, int *ierror);
void C_MPI_Status_set_cancelled(struct F_MPI_Status *status, int *flag, int *ierror);
void C_MPI_Status_set_elements(struct F_MPI_Status *status, int datatype, int count, int *ierror);
void C_MPI_Request_free(int *request, int *ierror);
void C_MPI_Cancel(const int *request, int *ierror);
void C_MPI_Start(int *request, int *ierror);
void C_MPI_Startall(int *count, int requests[], int *ierror);
void C_MPI_Send_init(void *buffer, int count, int datatype, int dest, int tag, int comm,
                     int *request, int *ierror);
void C_MPI_Bsend_init(void *buffer, int count, int datatype, int dest, int tag, int comm,
                      int *request, int *ierror);
void C_MPI_Ssend_init(void *buffer, int count, int datatype, int dest, int tag, int comm,
                      int *request, int *ierror);
void C_MPI_Rsend_init(void *buffer, int count, int datatype, int dest, int tag, int comm,
                      int *request, int *ierror);
void C_MPI_Recv_init(void *buffer, int count, int datatype, int source, int tag, int comm,
                     int *request, int *ierror);
void C_MPI_Sendrecv(void *sbuffer, int scount, int sdatatype, int dest, int stag,
                    void *rbuffer, int rcount, int rdatatype, int source, int rtag, int comm,
                    struct F_MPI_Status *status, int *ierror);
void C_MPI_Mrecv(void *buffer, int count, int datatype, int *message,
                 struct F_MPI_Status *status, int *ierror);
void C_MPI_Imrecv(void *buffer, int count, int datatype, int *message, int *request, int *ierror);
void C_MPI_Pack(void *inbuf, int incount, int datatype, void *outbuf, int outsize,
                int *position, int comm, int *ierror);
void C_MPI_Unpack(void *inbuf, int insize, int *position, void *outbuf, int outcount,
                  int datatype, int comm, int *ierror);
void VAPAA_MPI_Pack_size(int *incount, int *datatype, int *comm, int *size, int *ierror);

void C_MPI_Type_commit(int *datatype, int *ierror);
void C_MPI_Type_size(int *datatype, int *size, int *ierror);
void C_MPI_Type_dup(int *oldtype, int *newtype, int *ierror);
void C_MPI_Type_free(int *datatype, int *ierror);
void C_MPI_Type_vector(int *count, int *blocklength, int *stride, int *oldtype, int *newtype,
                       int *ierror);
void C_MPI_Type_contiguous(int *count, int *oldtype, int *newtype, int *ierror);
void C_MPI_Type_create_subarray(int *ndims, int *sizes, int *subsizes, int *starts, int *order,
                                int *oldtype, int *newtype, int *ierror);
void VAPAA_MPI_Type_create_resized(int *oldtype, intptr_t *lb, intptr_t *extent, int *newtype,
                                   int *ierror);
void VAPAA_MPI_Type_create_hvector(int *count, int *blocklength, intptr_t *stride, int *oldtype,
                                   int *newtype, int *ierror);
void VAPAA_MPI_Type_create_hindexed(int *count, int *blocklengths, intptr_t *displacements,
                                    int *oldtype, int *newtype, int *ierror);
void VAPAA_MPI_Type_create_hindexed_block(int *count, int *blocklength, intptr_t *displacements,
                                          int *oldtype, int *newtype, int *ierror);
void VAPAA_MPI_Type_create_indexed_block(int *count, int *blocklength, int *displacements,
                                         int *oldtype, int *newtype, int *ierror);
void VAPAA_MPI_Type_create_struct(int *count, int *blocklengths, intptr_t *displacements,
                                  int *datatypes, int *newtype, int *ierror);
void VAPAA_MPI_Type_get_envelope(int *datatype, int *nints, int *nadds, int *ntypes,
                                 int *combiner, int *ierror);
void VAPAA_MPI_Type_get_contents(int *datatype, int *maxints, int *maxadds, int *maxtypes,
                                 int *ints, intptr_t *adds, int *types, int *ierror);
void VAPAA_MPI_Type_get_extent(int *datatype, intptr_t *lb, intptr_t *extent, int *ierror);
void VAPAA_MPI_Type_get_true_extent(int *datatype, intptr_t *lb, intptr_t *extent, int *ierror);
void C_MPI_Type_get_name(int *datatype, char *name, int *resultlen, int *ierror);
void C_MPI_Type_set_name(int *datatype, char *name, int *ierror);

void C_MPI_Info_create(int *info, int *ierror);
void C_MPI_Info_create_env(int *info, int *ierror);
void C_MPI_Info_dup(int *info, int *newinfo, int *ierror);
void C_MPI_Info_free(int *info, int *ierror);
void C_MPI_Info_get_nkeys(int *info, int *nkeys, int *ierror);
void C_MPI_Info_get_nthkey(int *info, int *n, char *key, int *ierror);
void C_MPI_Info_get_string(int *info, char *key, int *buflen, char *value, int *flag, int *ierror);
void C_MPI_Info_get_valuelen(int *info, char *key, int *valuelen, int *flag, int *ierror);
void C_MPI_Info_set(int *info, char *key, char *value, int *ierror);
void C_MPI_Info_delete(int *info, char *key, int *ierror);

void C_MPI_Error_class(int *errorcode, int *errorclass, int *ierror);
void C_MPI_Error_string(int *errorcode, char *string, int *resultlen, int *ierror);
void C_MPI_Add_error_class(int *errorclass, int *ierror);
void C_MPI_Add_error_code(int *errorclass, int *errorcode, int *ierror);
void C_MPI_Add_error_string(int *errorcode, char *string, int *ierror);
void C_MPI_Errhandler_free(int *errhandler, int *ierror);
void C_MPI_Op_create(MPI_User_function *user_fn, int *commute, int *op, int *ierror);
void C_MPI_Op_free(int *op, int *ierror);

void VAPAA_MPI_Keyval_create(vapaa_c_funptr copy, vapaa_c_funptr del, int *keyval, int *extra,
                             int *ierror);
void VAPAA_MPI_Keyval_free(int *keyval, int *ierror);
void VAPAA_MPI_Attr_put(int *comm, int *keyval, int *attrval, int *ierror);
void VAPAA_MPI_Attr_get(int *comm, int *keyval, int *attrval, int *flag, int *ierror);
void VAPAA_MPI_Attr_delete(int *comm, int *keyval, int *ierror);
void VAPAA_MPI_Comm_create_keyval(vapaa_c_funptr copy, vapaa_c_funptr del, int *keyval, intptr_t *extra,
                                  int *ierror);
void VAPAA_MPI_Comm_delete_attr(int *comm, int *keyval, int *ierror);
void VAPAA_MPI_Comm_free_keyval(int *keyval, int *ierror);
void VAPAA_MPI_Comm_get_attr(int *comm, int *keyval, intptr_t *attrval, int *flag, int *ierror);
void VAPAA_MPI_Comm_set_attr(int *comm, int *keyval, intptr_t *attrval, int *ierror);
void VAPAA_MPI_Type_create_keyval(vapaa_c_funptr copy, vapaa_c_funptr del, int *keyval, intptr_t *extra,
                                  int *ierror);
void VAPAA_MPI_Type_delete_attr(int *datatype, int *keyval, int *ierror);
void VAPAA_MPI_Type_free_keyval(int *keyval, int *ierror);
void VAPAA_MPI_Type_get_attr(int *datatype, int *keyval, intptr_t *attrval, int *flag, int *ierror);
void VAPAA_MPI_Type_set_attr(int *datatype, int *keyval, intptr_t *attrval, int *ierror);
void VAPAA_MPIFH_Init_support(int *ierror);

typedef void (*vapaa_f77_greq_query_fn)(intptr_t *, int *, int *);
typedef void (*vapaa_f77_greq_free_fn)(intptr_t *, int *);
typedef void (*vapaa_f77_greq_cancel_fn)(intptr_t *, int *, int *);
typedef void (*vapaa_f77_comm_errhandler_fn)(int *, int *);
typedef void (*vapaa_f77_user_function)(void *, void *, int *, int *);

struct vapaa_f77_greq_state {
    vapaa_f77_greq_query_fn query;
    vapaa_f77_greq_free_fn free_fn;
    vapaa_f77_greq_cancel_fn cancel;
    intptr_t *extra;
};

struct vapaa_f77_comm_errhandler_slot {
    int in_use;
    int errhandler_f;
    vapaa_f77_comm_errhandler_fn fn;
};

struct vapaa_f77_op_slot {
    int in_use;
    int op_f;
    vapaa_f77_user_function fn;
};

#define VAPAA_F77_MAX_COMM_ERRHANDLERS 32
static struct vapaa_f77_comm_errhandler_slot f77_comm_errhandler_slots[VAPAA_F77_MAX_COMM_ERRHANDLERS];

#define VAPAA_F77_MAX_OPS 64
static struct vapaa_f77_op_slot f77_op_slots[VAPAA_F77_MAX_OPS];

static void f77_comm_errhandler_dispatch(int slot, MPI_Comm *comm, int *errorcode_c)
{
    struct vapaa_f77_comm_errhandler_slot *s = &f77_comm_errhandler_slots[slot];
    int comm_f = C_MPI_COMM_TOINT(*comm);
    int errorcode_f = C_MPI_ERROR_CODE_C2F(*errorcode_c);

    if (s->in_use && s->fn != NULL) {
        s->fn(&comm_f, &errorcode_f);
        *errorcode_c = C_MPI_ERROR_CODE_F2C(errorcode_f);
    }
}

#define VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(n) \
static void f77_comm_errhandler_trampoline_##n(MPI_Comm *comm, int *errorcode, ...) \
{ \
    f77_comm_errhandler_dispatch(n, comm, errorcode); \
}
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(0)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(1)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(2)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(3)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(4)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(5)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(6)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(7)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(8)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(9)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(10)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(11)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(12)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(13)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(14)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(15)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(16)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(17)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(18)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(19)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(20)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(21)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(22)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(23)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(24)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(25)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(26)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(27)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(28)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(29)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(30)
VAPAA_F77_COMM_ERRHANDLER_TRAMPOLINE(31)

static void (*f77_comm_errhandler_trampolines[VAPAA_F77_MAX_COMM_ERRHANDLERS])(MPI_Comm *, int *, ...) = {
    f77_comm_errhandler_trampoline_0,
    f77_comm_errhandler_trampoline_1,
    f77_comm_errhandler_trampoline_2,
    f77_comm_errhandler_trampoline_3,
    f77_comm_errhandler_trampoline_4,
    f77_comm_errhandler_trampoline_5,
    f77_comm_errhandler_trampoline_6,
    f77_comm_errhandler_trampoline_7,
    f77_comm_errhandler_trampoline_8,
    f77_comm_errhandler_trampoline_9,
    f77_comm_errhandler_trampoline_10,
    f77_comm_errhandler_trampoline_11,
    f77_comm_errhandler_trampoline_12,
    f77_comm_errhandler_trampoline_13,
    f77_comm_errhandler_trampoline_14,
    f77_comm_errhandler_trampoline_15,
    f77_comm_errhandler_trampoline_16,
    f77_comm_errhandler_trampoline_17,
    f77_comm_errhandler_trampoline_18,
    f77_comm_errhandler_trampoline_19,
    f77_comm_errhandler_trampoline_20,
    f77_comm_errhandler_trampoline_21,
    f77_comm_errhandler_trampoline_22,
    f77_comm_errhandler_trampoline_23,
    f77_comm_errhandler_trampoline_24,
    f77_comm_errhandler_trampoline_25,
    f77_comm_errhandler_trampoline_26,
    f77_comm_errhandler_trampoline_27,
    f77_comm_errhandler_trampoline_28,
    f77_comm_errhandler_trampoline_29,
    f77_comm_errhandler_trampoline_30,
    f77_comm_errhandler_trampoline_31
};

static int f77_comm_errhandler_alloc(vapaa_f77_comm_errhandler_fn fn)
{
    for (int i = 0; i < VAPAA_F77_MAX_COMM_ERRHANDLERS; i++) {
        if (!f77_comm_errhandler_slots[i].in_use) {
            f77_comm_errhandler_slots[i].in_use = 1;
            f77_comm_errhandler_slots[i].errhandler_f = VAPAA_MPI_ERRHANDLER_NULL;
            f77_comm_errhandler_slots[i].fn = fn;
            return i;
        }
    }
    return -1;
}

MAYBE_UNUSED static void f77_comm_errhandler_clear(int errhandler_f)
{
    for (int i = 0; i < VAPAA_F77_MAX_COMM_ERRHANDLERS; i++) {
        if (f77_comm_errhandler_slots[i].in_use &&
            f77_comm_errhandler_slots[i].errhandler_f == errhandler_f) {
            memset(&f77_comm_errhandler_slots[i], 0, sizeof(f77_comm_errhandler_slots[i]));
            return;
        }
    }
}

static int f77_datatype_for_callback(MPI_Datatype datatype)
{
    int datatype_f = C_MPI_TYPE_TOINT(datatype);

    if (datatype == VAPAA_MPI_Type_fromint(VAPAA_MPI_INTEGER)) {
        return VAPAA_MPI_INTEGER;
    }
    if (datatype == VAPAA_MPI_Type_fromint(VAPAA_MPI_LOGICAL)) {
        return VAPAA_MPI_LOGICAL;
    }
    if (datatype == VAPAA_MPI_Type_fromint(VAPAA_MPI_REAL)) {
        return VAPAA_MPI_REAL;
    }
    if (datatype == VAPAA_MPI_Type_fromint(VAPAA_MPI_DOUBLE_PRECISION)) {
        return VAPAA_MPI_DOUBLE_PRECISION;
    }
    return datatype_f;
}

static void f77_op_dispatch(int slot, void *invec, void *inoutvec, int *len, MPI_Datatype *datatype)
{
    struct vapaa_f77_op_slot *s = &f77_op_slots[slot];
    int datatype_f = f77_datatype_for_callback(*datatype);

    if (s->in_use && s->fn != NULL) {
        s->fn(invec, inoutvec, len, &datatype_f);
    }
}

#define VAPAA_F77_OP_TRAMPOLINE(n) \
static void f77_op_trampoline_##n(void *invec, void *inoutvec, int *len, MPI_Datatype *datatype) \
{ \
    f77_op_dispatch(n, invec, inoutvec, len, datatype); \
}
VAPAA_F77_OP_TRAMPOLINE(0)
VAPAA_F77_OP_TRAMPOLINE(1)
VAPAA_F77_OP_TRAMPOLINE(2)
VAPAA_F77_OP_TRAMPOLINE(3)
VAPAA_F77_OP_TRAMPOLINE(4)
VAPAA_F77_OP_TRAMPOLINE(5)
VAPAA_F77_OP_TRAMPOLINE(6)
VAPAA_F77_OP_TRAMPOLINE(7)
VAPAA_F77_OP_TRAMPOLINE(8)
VAPAA_F77_OP_TRAMPOLINE(9)
VAPAA_F77_OP_TRAMPOLINE(10)
VAPAA_F77_OP_TRAMPOLINE(11)
VAPAA_F77_OP_TRAMPOLINE(12)
VAPAA_F77_OP_TRAMPOLINE(13)
VAPAA_F77_OP_TRAMPOLINE(14)
VAPAA_F77_OP_TRAMPOLINE(15)
VAPAA_F77_OP_TRAMPOLINE(16)
VAPAA_F77_OP_TRAMPOLINE(17)
VAPAA_F77_OP_TRAMPOLINE(18)
VAPAA_F77_OP_TRAMPOLINE(19)
VAPAA_F77_OP_TRAMPOLINE(20)
VAPAA_F77_OP_TRAMPOLINE(21)
VAPAA_F77_OP_TRAMPOLINE(22)
VAPAA_F77_OP_TRAMPOLINE(23)
VAPAA_F77_OP_TRAMPOLINE(24)
VAPAA_F77_OP_TRAMPOLINE(25)
VAPAA_F77_OP_TRAMPOLINE(26)
VAPAA_F77_OP_TRAMPOLINE(27)
VAPAA_F77_OP_TRAMPOLINE(28)
VAPAA_F77_OP_TRAMPOLINE(29)
VAPAA_F77_OP_TRAMPOLINE(30)
VAPAA_F77_OP_TRAMPOLINE(31)
VAPAA_F77_OP_TRAMPOLINE(32)
VAPAA_F77_OP_TRAMPOLINE(33)
VAPAA_F77_OP_TRAMPOLINE(34)
VAPAA_F77_OP_TRAMPOLINE(35)
VAPAA_F77_OP_TRAMPOLINE(36)
VAPAA_F77_OP_TRAMPOLINE(37)
VAPAA_F77_OP_TRAMPOLINE(38)
VAPAA_F77_OP_TRAMPOLINE(39)
VAPAA_F77_OP_TRAMPOLINE(40)
VAPAA_F77_OP_TRAMPOLINE(41)
VAPAA_F77_OP_TRAMPOLINE(42)
VAPAA_F77_OP_TRAMPOLINE(43)
VAPAA_F77_OP_TRAMPOLINE(44)
VAPAA_F77_OP_TRAMPOLINE(45)
VAPAA_F77_OP_TRAMPOLINE(46)
VAPAA_F77_OP_TRAMPOLINE(47)
VAPAA_F77_OP_TRAMPOLINE(48)
VAPAA_F77_OP_TRAMPOLINE(49)
VAPAA_F77_OP_TRAMPOLINE(50)
VAPAA_F77_OP_TRAMPOLINE(51)
VAPAA_F77_OP_TRAMPOLINE(52)
VAPAA_F77_OP_TRAMPOLINE(53)
VAPAA_F77_OP_TRAMPOLINE(54)
VAPAA_F77_OP_TRAMPOLINE(55)
VAPAA_F77_OP_TRAMPOLINE(56)
VAPAA_F77_OP_TRAMPOLINE(57)
VAPAA_F77_OP_TRAMPOLINE(58)
VAPAA_F77_OP_TRAMPOLINE(59)
VAPAA_F77_OP_TRAMPOLINE(60)
VAPAA_F77_OP_TRAMPOLINE(61)
VAPAA_F77_OP_TRAMPOLINE(62)
VAPAA_F77_OP_TRAMPOLINE(63)

static MPI_User_function *f77_op_trampolines[VAPAA_F77_MAX_OPS] = {
    f77_op_trampoline_0, f77_op_trampoline_1, f77_op_trampoline_2, f77_op_trampoline_3,
    f77_op_trampoline_4, f77_op_trampoline_5, f77_op_trampoline_6, f77_op_trampoline_7,
    f77_op_trampoline_8, f77_op_trampoline_9, f77_op_trampoline_10, f77_op_trampoline_11,
    f77_op_trampoline_12, f77_op_trampoline_13, f77_op_trampoline_14, f77_op_trampoline_15,
    f77_op_trampoline_16, f77_op_trampoline_17, f77_op_trampoline_18, f77_op_trampoline_19,
    f77_op_trampoline_20, f77_op_trampoline_21, f77_op_trampoline_22, f77_op_trampoline_23,
    f77_op_trampoline_24, f77_op_trampoline_25, f77_op_trampoline_26, f77_op_trampoline_27,
    f77_op_trampoline_28, f77_op_trampoline_29, f77_op_trampoline_30, f77_op_trampoline_31,
    f77_op_trampoline_32, f77_op_trampoline_33, f77_op_trampoline_34, f77_op_trampoline_35,
    f77_op_trampoline_36, f77_op_trampoline_37, f77_op_trampoline_38, f77_op_trampoline_39,
    f77_op_trampoline_40, f77_op_trampoline_41, f77_op_trampoline_42, f77_op_trampoline_43,
    f77_op_trampoline_44, f77_op_trampoline_45, f77_op_trampoline_46, f77_op_trampoline_47,
    f77_op_trampoline_48, f77_op_trampoline_49, f77_op_trampoline_50, f77_op_trampoline_51,
    f77_op_trampoline_52, f77_op_trampoline_53, f77_op_trampoline_54, f77_op_trampoline_55,
    f77_op_trampoline_56, f77_op_trampoline_57, f77_op_trampoline_58, f77_op_trampoline_59,
    f77_op_trampoline_60, f77_op_trampoline_61, f77_op_trampoline_62, f77_op_trampoline_63
};

static int f77_op_alloc(vapaa_f77_user_function fn)
{
    for (int i = 0; i < VAPAA_F77_MAX_OPS; i++) {
        if (!f77_op_slots[i].in_use) {
            f77_op_slots[i].in_use = 1;
            f77_op_slots[i].op_f = VAPAA_MPI_OP_NULL;
            f77_op_slots[i].fn = fn;
            return i;
        }
    }
    return -1;
}

static void f77_op_clear(int op_f)
{
    for (int i = 0; i < VAPAA_F77_MAX_OPS; i++) {
        if (f77_op_slots[i].in_use && f77_op_slots[i].op_f == op_f) {
            memset(&f77_op_slots[i], 0, sizeof(f77_op_slots[i]));
            return;
        }
    }
}

static void f77_logical_store(int *flag, int value)
{
    *flag = value ? 1 : 0;
}

static char *f77_string_to_c(const char *src, size_t len)
{
    while (len > 0 && src[len - 1] == ' ') {
        --len;
    }
    char *dst = malloc(len + 1);
    if (dst == NULL) return NULL;
    memcpy(dst, src, len);
    dst[len] = '\0';
    return dst;
}

static char *f77_info_string_to_c(const char *src, size_t len)
{
    while (len > 0 && *src == ' ') {
        ++src;
        --len;
    }
    while (len > 0 && src[len - 1] == ' ') {
        --len;
    }
    char *dst = malloc(len + 1);
    if (dst == NULL) return NULL;
    memcpy(dst, src, len);
    dst[len] = '\0';
    return dst;
}

static void c_string_to_f77(char *dst, size_t dst_len, const char *src)
{
    size_t src_len = strlen(src);
    if (src_len > dst_len) src_len = dst_len;
    memcpy(dst, src, src_len);
    if (src_len < dst_len) memset(dst + src_len, ' ', dst_len - src_len);
}

static void c_string_to_f77_n(char *dst, size_t dst_len, const char *src, size_t max_chars)
{
    size_t src_len = strlen(src);
    if (src_len > max_chars) src_len = max_chars;
    if (src_len > dst_len) src_len = dst_len;
    memcpy(dst, src, src_len);
    if (src_len < dst_len) memset(dst + src_len, ' ', dst_len - src_len);
}

static int f77_info_get_string_buflen(int buflen, size_t value_len)
{
    size_t capped;

    if (buflen <= 0) {
        return 0;
    }
    capped = (size_t)buflen;
    if (capped > value_len) {
        capped = value_len;
    }
    return (int)capped + 1;
}

static MPI_Datatype *f77_datatypes_from_ints(int count, const int types_f[])
{
    MPI_Datatype *types = malloc((size_t)(count > 0 ? count : 1) * sizeof(*types));
    if (types == NULL) return NULL;
    for (int i = 0; i < count; i++) {
        types[i] = C_MPI_TYPE_FROMINT(types_f[i]);
    }
    return types;
}

static void f77_request_store(MPI_Request request, int *request_f)
{
    *request_f = C_MPI_REQUEST_TOINT(request);
}

enum {
    VAPAA_F77_MPI_STATUS_SIZE = 8,
    VAPAA_F77_MPI_SOURCE = 0,
    VAPAA_F77_MPI_TAG = 1,
    VAPAA_F77_MPI_ERROR = 2,
    VAPAA_F77_MPI_INTERNAL = 3
};

static void f77_status_to_struct(const int status_f77[], struct F_MPI_Status *status)
{
    memset(status, 0, sizeof(*status));
    status->MPI_SOURCE = status_f77[VAPAA_F77_MPI_SOURCE];
    status->MPI_TAG = status_f77[VAPAA_F77_MPI_TAG];
    status->MPI_ERROR = status_f77[VAPAA_F77_MPI_ERROR];
#if defined(MPI_ABI)
    for (int i = 0; i < 5; i++) {
        status->MPI_internal[i] = status_f77[VAPAA_F77_MPI_INTERNAL + i];
    }
#elif defined(MPICH)
    status->count_lo = status_f77[VAPAA_F77_MPI_INTERNAL];
    status->count_hi_and_cancelled = status_f77[VAPAA_F77_MPI_INTERNAL + 1];
#elif defined(OPEN_MPI)
    status->cancelled = status_f77[VAPAA_F77_MPI_INTERNAL];
    memcpy(&status->ucount, &status_f77[VAPAA_F77_MPI_INTERNAL + 1], sizeof(status->ucount));
#endif
}

static void f77_status_from_struct(const struct F_MPI_Status *status, int status_f77[])
{
    for (int i = 0; i < VAPAA_F77_MPI_STATUS_SIZE; i++) {
        status_f77[i] = 0;
    }
    status_f77[VAPAA_F77_MPI_SOURCE] = status->MPI_SOURCE;
    status_f77[VAPAA_F77_MPI_TAG] = status->MPI_TAG;
    status_f77[VAPAA_F77_MPI_ERROR] = status->MPI_ERROR;
#if defined(MPI_ABI)
    for (int i = 0; i < 5; i++) {
        status_f77[VAPAA_F77_MPI_INTERNAL + i] = status->MPI_internal[i];
    }
#elif defined(MPICH)
    status_f77[VAPAA_F77_MPI_INTERNAL] = status->count_lo;
    status_f77[VAPAA_F77_MPI_INTERNAL + 1] = status->count_hi_and_cancelled;
#elif defined(OPEN_MPI)
    status_f77[VAPAA_F77_MPI_INTERNAL] = status->cancelled;
    memcpy(&status_f77[VAPAA_F77_MPI_INTERNAL + 1], &status->ucount, sizeof(status->ucount));
#endif
}

static struct F_MPI_Status *f77_status_arg(int *status_f77, struct F_MPI_Status *status)
{
    if (C_IS_MPI_STATUS_IGNORE(status_f77)) {
        return (struct F_MPI_Status *)status_f77;
    }
    f77_status_to_struct(status_f77, status);
    return status;
}

static void f77_status_store(int *status_f77, const struct F_MPI_Status *status)
{
    if (!C_IS_MPI_STATUS_IGNORE(status_f77)) {
        f77_status_from_struct(status, status_f77);
    }
}

static struct F_MPI_Status *f77_statuses_arg(int count, int statuses_f77[], int *ierror)
{
    struct F_MPI_Status *statuses;

    if (C_IS_MPI_STATUSES_IGNORE(statuses_f77)) {
        return (struct F_MPI_Status *)statuses_f77;
    }
    statuses = calloc((size_t)(count > 0 ? count : 1), sizeof(*statuses));
    if (statuses == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return NULL;
    }
    for (int i = 0; i < count; i++) {
        f77_status_to_struct(&statuses_f77[i * VAPAA_F77_MPI_STATUS_SIZE], &statuses[i]);
    }
    return statuses;
}

static void f77_statuses_store_free(int count, int statuses_f77[], struct F_MPI_Status statuses[])
{
    if (!C_IS_MPI_STATUSES_IGNORE(statuses_f77)) {
        for (int i = 0; i < count; i++) {
            f77_status_from_struct(&statuses[i], &statuses_f77[i * VAPAA_F77_MPI_STATUS_SIZE]);
        }
        free(statuses);
    }
}

static int f77_grequest_query_trampoline(void *extra_state, MPI_Status *status)
{
    struct vapaa_f77_greq_state *s = extra_state;
    struct F_MPI_Status status_f;
    int status_f77[VAPAA_F77_MPI_STATUS_SIZE];
    int ierror = VAPAA_MPI_SUCCESS;

    C_MPI_STATUS_FROM_C(status, &status_f);
    f77_status_from_struct(&status_f, status_f77);
    s->query(s->extra, status_f77, &ierror);
    f77_status_to_struct(status_f77, &status_f);
    C_MPI_STATUS_TO_C(&status_f, status);
    return C_MPI_ERROR_CODE_F2C(ierror);
}

static int f77_grequest_free_trampoline(void *extra_state)
{
    struct vapaa_f77_greq_state *s = extra_state;
    int ierror = VAPAA_MPI_SUCCESS;

    s->free_fn(s->extra, &ierror);
    free(s);
    return C_MPI_ERROR_CODE_F2C(ierror);
}

static int f77_grequest_cancel_trampoline(void *extra_state, int complete)
{
    struct vapaa_f77_greq_state *s = extra_state;
    int complete_f = complete ? 1 : 0;
    int ierror = VAPAA_MPI_SUCCESS;

    s->cancel(s->extra, &complete_f, &ierror);
    return C_MPI_ERROR_CODE_F2C(ierror);
}

void mpi_init_(int *ierror)
{
    C_MPI_Init(ierror);
    VAPAA_MPIFH_Init_support(ierror);
}

void mpi_init_thread_(int *required, int *provided, int *ierror)
{
    C_MPI_Init_thread(required, provided, ierror);
    VAPAA_MPIFH_Init_support(ierror);
}

void mpi_finalize_(int *ierror) { C_MPI_Finalize(ierror); }
void mpi_initialized_(int *flag, int *ierror) { C_MPI_Initialized(flag, ierror); f77_logical_store(flag, *flag); }
void mpi_finalized_(int *flag, int *ierror) { C_MPI_Finalized(flag, ierror); f77_logical_store(flag, *flag); }
void mpi_query_thread_(int *provided, int *ierror) { C_MPI_Query_thread(provided, ierror); }
void mpi_is_thread_main_(int *flag, int *ierror) { C_MPI_Is_thread_main(flag, ierror); f77_logical_store(flag, *flag); }
void mpi_abort_(int *comm, int *errorcode, int *ierror) { C_MPI_Abort(comm, errorcode, ierror); }
void mpi_get_version_(int *version, int *subversion, int *ierror) { C_MPI_Get_version(version, subversion, ierror); }
double mpi_wtime_(void) { return C_MPI_Wtime(); }
double mpi_wtick_(void) { return C_MPI_Wtick(); }

void mpi_get_processor_name_(char *name, int *resultlen, int *ierror, size_t name_len)
{
    char tmp[VAPAA_MPI_MAX_PROCESSOR_NAME] = {0};
    C_MPI_Get_processor_name(tmp, resultlen, ierror);
    c_string_to_f77(name, name_len, tmp);
}

void mpi_get_library_version_(char *version, int *resultlen, int *ierror, size_t version_len)
{
    char tmp[VAPAA_MPI_MAX_LIBRARY_VERSION_STRING] = {0};
    C_MPI_Get_library_version(tmp, resultlen, ierror);
    c_string_to_f77(version, version_len, tmp);
}

void mpi_comm_rank_(int *comm, int *rank, int *ierror) { C_MPI_Comm_rank(comm, rank, ierror); }
void mpi_comm_size_(int *comm, int *size, int *ierror) { C_MPI_Comm_size(comm, size, ierror); }
void mpi_comm_dup_(int *comm, int *newcomm, int *ierror) { C_MPI_Comm_dup(comm, newcomm, ierror); }
void mpi_comm_split_(int *comm, int *color, int *key, int *newcomm, int *ierror) { C_MPI_Comm_split(comm, color, key, newcomm, ierror); }
void mpi_comm_split_type_(int *comm, int *type, int *key, int *info, int *newcomm, int *ierror) { C_MPI_Comm_split_type(comm, type, key, info, newcomm, ierror); }
void mpi_comm_free_(int *comm, int *ierror) { C_MPI_Comm_free(comm, ierror); }
void mpi_comm_group_(int *comm, int *group, int *ierror) { C_MPI_Comm_group(comm, group, ierror); }
void mpi_comm_remote_size_(int *comm, int *size, int *ierror) { VAPAA_MPI_Comm_remote_size(comm, size, ierror); }
void mpi_comm_set_errhandler_(int *comm, int *errhandler, int *ierror) { C_MPI_Comm_set_errhandler(comm, errhandler, ierror); }
void mpi_comm_get_errhandler_(int *comm, int *errhandler, int *ierror) { C_MPI_Comm_get_errhandler(comm, errhandler, ierror); }
void mpi_comm_call_errhandler_(int *comm, int *errorcode, int *ierror) { C_MPI_Comm_call_errhandler(comm, errorcode, ierror); }
void mpi_comm_create_errhandler_(vapaa_c_funptr fn, int *errhandler_f, int *ierror)
{
    int slot = f77_comm_errhandler_alloc((vapaa_f77_comm_errhandler_fn)fn);
    MPI_Errhandler errhandler = MPI_ERRHANDLER_NULL;

    if (slot < 0) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return;
    }
    *ierror = MPI_Comm_create_errhandler(f77_comm_errhandler_trampolines[slot], &errhandler);
    if (*ierror == MPI_SUCCESS) {
        *errhandler_f = C_MPI_ERRHANDLER_TOINT(errhandler);
        f77_comm_errhandler_slots[slot].errhandler_f = *errhandler_f;
    } else {
        memset(&f77_comm_errhandler_slots[slot], 0, sizeof(f77_comm_errhandler_slots[slot]));
        *errhandler_f = VAPAA_MPI_ERRHANDLER_NULL;
    }
    C_MPI_RC_FIX(*ierror);
}

void mpi_dims_create_(int *nnodes, int *ndims, int *dims, int *ierror)
{
    C_MPI_Dims_create(nnodes, ndims, dims, ierror);
}

void mpi_cart_create_(int *comm, int *ndims, int *dims, int *periods, int *reorder,
                      int *newcomm, int *ierror)
{
    int *periods_c = malloc((size_t)(*ndims > 0 ? *ndims : 1) * sizeof(*periods_c));
    int reorder_c = (*reorder != 0) ? 1 : 0;

    if (periods_c == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return;
    }
    for (int i = 0; i < *ndims; i++) {
        periods_c[i] = (periods[i] != 0) ? 1 : 0;
    }
    C_MPI_Cart_create(comm, ndims, dims, periods_c, &reorder_c, newcomm, ierror);
    free(periods_c);
}

void mpi_cart_get_(int *comm, int *maxdims, int *dims, int *periods, int *coords, int *ierror)
{
    int *periods_c = malloc((size_t)(*maxdims > 0 ? *maxdims : 1) * sizeof(*periods_c));

    if (periods_c == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return;
    }
    C_MPI_Cart_get(comm, maxdims, dims, periods_c, coords, ierror);
    if (*ierror == VAPAA_MPI_SUCCESS) {
        for (int i = 0; i < *maxdims; i++) {
            f77_logical_store(&periods[i], periods_c[i]);
        }
    }
    free(periods_c);
}

void mpi_cart_shift_(int *comm, int *direction, int *disp, int *rank_source, int *rank_dest, int *ierror)
{
    C_MPI_Cart_shift(comm, direction, disp, rank_source, rank_dest, ierror);
}

void mpi_topo_test_(int *comm, int *status, int *ierror)
{
    C_MPI_Topo_test(comm, status, ierror);
}

void mpi_dist_graph_neighbors_count_(int *comm, int *indegree, int *outdegree, int *weighted, int *ierror)
{
    C_MPI_Dist_graph_neighbors_count(comm, indegree, outdegree, weighted, ierror);
    f77_logical_store(weighted, *weighted);
}

void mpi_dist_graph_create_(int *comm_old, int *n, int *sources, int *degrees, int *destinations,
                            int *weights, int *info, int *reorder, int *comm_dist_graph, int *ierror)
{
    int reorder_c = (*reorder != 0) ? 1 : 0;
    C_MPI_Dist_graph_create(comm_old, n, sources, degrees, destinations, weights, info, &reorder_c,
                            comm_dist_graph, ierror);
}

void mpi_dist_graph_create_adjacent_(int *comm_old, int *indegree, int *sources, int *sourceweights,
                                     int *outdegree, int *destinations, int *destweights,
                                     int *info, int *reorder, int *comm_dist_graph, int *ierror)
{
    int reorder_c = (*reorder != 0) ? 1 : 0;
    C_MPI_Dist_graph_create_adjacent(comm_old, indegree, sources, sourceweights, outdegree, destinations,
                                     destweights, info, &reorder_c, comm_dist_graph, ierror);
}

void mpi_dist_graph_neighbors_(int *comm, int *maxindegree, int *sources, int *sourceweights,
                               int *maxoutdegree, int *destinations, int *destweights, int *ierror)
{
    C_MPI_Dist_graph_neighbors(comm, maxindegree, sources, sourceweights, maxoutdegree, destinations,
                               destweights, ierror);
}

void mpi_comm_get_name_(int *comm, char *name, int *resultlen, int *ierror, size_t name_len)
{
    char tmp[VAPAA_MPI_MAX_OBJECT_NAME] = {0};
    C_MPI_Comm_get_name(comm, tmp, resultlen, ierror);
    c_string_to_f77(name, name_len, tmp);
}

void mpi_comm_set_name_(int *comm, char *name, int *ierror, size_t name_len)
{
    char *c_name = f77_string_to_c(name, name_len);
    if (c_name == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return;
    }
    C_MPI_Comm_set_name(comm, c_name, ierror);
    free(c_name);
}

void mpi_group_free_(int *group, int *ierror) { C_MPI_Group_free(group, ierror); }
void mpi_group_size_(int *group, int *size, int *ierror) { C_MPI_Group_size(group, size, ierror); }
void mpi_group_rank_(int *group, int *rank, int *ierror) { C_MPI_Group_rank(group, rank, ierror); }
void mpi_group_incl_(int *group, int *n, int *ranks, int *newgroup, int *ierror) { C_MPI_Group_incl(group, n, ranks, newgroup, ierror); }
void mpi_group_compare_(int *group1, int *group2, int *result, int *ierror) { C_MPI_Group_compare(group1, group2, result, ierror); }

void mpi_barrier_(int *comm, int *ierror) { C_MPI_Barrier(comm, ierror); }
void mpi_bcast_(void *buffer, int *count, int *datatype, int *root, int *comm, int *ierror) { C_MPI_Bcast(buffer, *count, *datatype, *root, *comm, ierror); }
void mpi_gather_(const void *sendbuf, int *sendcount, int *sendtype, void *recvbuf, int *recvcount, int *recvtype, int *root, int *comm, int *ierror) { C_MPI_Gather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm, ierror); }
void mpi_gatherv_(const void *sendbuf, int *sendcount, int *sendtype, void *recvbuf, const int recvcounts[], const int displs[], int *recvtype, int *root, int *comm, int *ierror) { C_MPI_Gatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, recvtype, root, comm, ierror); }
void mpi_scatter_(const void *sendbuf, int *sendcount, int *sendtype, void *recvbuf, int *recvcount, int *recvtype, int *root, int *comm, int *ierror) { C_MPI_Scatter(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm, ierror); }
void mpi_scatterv_(const void *sendbuf, const int sendcounts[], const int displs[], int *sendtype, void *recvbuf, int *recvcount, int *recvtype, int *root, int *comm, int *ierror) { C_MPI_Scatterv(sendbuf, sendcounts, displs, sendtype, recvbuf, recvcount, recvtype, root, comm, ierror); }
void mpi_alltoall_(const void *sendbuf, int *sendcount, int *sendtype, void *recvbuf, int *recvcount, int *recvtype, int *comm, int *ierror) { C_MPI_Alltoall(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, ierror); }
void mpi_alltoallv_(const void *sendbuf, const int sendcounts[], const int sdispls[], int *sendtype, void *recvbuf, const int recvcounts[], const int rdispls[], int *recvtype, int *comm, int *ierror) { C_MPI_Alltoallv(sendbuf, sendcounts, sdispls, sendtype, recvbuf, recvcounts, rdispls, recvtype, comm, ierror); }

void mpi_alltoallw_(const void *sendbuf, const int sendcounts[], const int sdispls[], const int sendtypes_f[],
                    void *recvbuf, const int recvcounts[], const int rdispls[], const int recvtypes_f[],
                    int *comm_f, int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    int comm_size = 0;
    *ierror = MPI_Comm_size(comm, &comm_size);
    if (*ierror != MPI_SUCCESS) {
        C_MPI_RC_FIX(*ierror);
        return;
    }
    MPI_Datatype *sendtypes = f77_datatypes_from_ints(comm_size, sendtypes_f);
    MPI_Datatype *recvtypes = f77_datatypes_from_ints(comm_size, recvtypes_f);
    if (sendtypes == NULL || recvtypes == NULL) {
        free(sendtypes);
        free(recvtypes);
        *ierror = MPI_ERR_OTHER;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Alltoallw(send_addr, sendcounts, sdispls, sendtypes,
                            recvbuf, recvcounts, rdispls, recvtypes, comm);
    free(sendtypes);
    free(recvtypes);
    C_MPI_RC_FIX(*ierror);
}

void mpi_allreduce_(const void *sendbuf, void *recvbuf, int *count, int *datatype, int *op, int *comm, int *ierror) { C_MPI_Allreduce(sendbuf, recvbuf, count, datatype, op, comm, ierror); }
void mpi_reduce_(const void *sendbuf, void *recvbuf, int *count, int *datatype_f, int *op_f, int *root, int *comm_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Reduce(send_addr, recvbuf, *count, datatype, op, C_MPI_ROOT_F2C(*root), comm);
    C_MPI_RC_FIX(*ierror);
}

void mpi_exscan_(const void *sendbuf, void *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Exscan(send_addr, recvbuf, *count, datatype, op, comm);
    C_MPI_RC_FIX(*ierror);
}

void mpi_scan_(const void *sendbuf, void *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Scan(send_addr, recvbuf, *count, datatype, op, comm);
    C_MPI_RC_FIX(*ierror);
}

void mpi_reduce_scatter_(const void *sendbuf, void *recvbuf, const int recvcounts[], int *datatype_f, int *op_f, int *comm_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Reduce_scatter(send_addr, recvbuf, recvcounts, datatype, op, comm);
    C_MPI_RC_FIX(*ierror);
}

void mpi_reduce_scatter_block_(const void *sendbuf, void *recvbuf, int *recvcount, int *datatype_f, int *op_f, int *comm_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Reduce_scatter_block(send_addr, recvbuf, *recvcount, datatype, op, comm);
    C_MPI_RC_FIX(*ierror);
}

void mpi_reduce_local_(void *inbuf, void *inoutbuf, int *count, int *datatype_f, int *op_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    *ierror = MPI_Reduce_local(inbuf, inoutbuf, *count, datatype, op);
    C_MPI_RC_FIX(*ierror);
}

void mpi_ibarrier_(int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Ibarrier(comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_ibcast_(void *buffer, int *count, int *datatype_f, int *root, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Ibcast(buffer, *count, datatype, C_MPI_ROOT_F2C(*root), comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_iallreduce_(const void *sendbuf, void *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Iallreduce(send_addr, recvbuf, *count, datatype, op, comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_ireduce_(const void *sendbuf, void *recvbuf, int *count, int *datatype_f, int *op_f, int *root, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Ireduce(send_addr, recvbuf, *count, datatype, op, C_MPI_ROOT_F2C(*root), comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_iexscan_(const void *sendbuf, void *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Iexscan(send_addr, recvbuf, *count, datatype, op, comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_iscan_(const void *sendbuf, void *recvbuf, int *count, int *datatype_f, int *op_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Iscan(send_addr, recvbuf, *count, datatype, op, comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_igather_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf, int *recvcount,
                  int *recvtype_f, int *root, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Igather(send_addr, *sendcount, sendtype, recvbuf, *recvcount, recvtype,
                          C_MPI_ROOT_F2C(*root), comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_igatherv_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,
                   const int recvcounts[], const int displs[], int *recvtype_f, int *root,
                   int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Igatherv(send_addr, *sendcount, sendtype, recvbuf, recvcounts, displs, recvtype,
                           C_MPI_ROOT_F2C(*root), comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_ialltoall_(const void *sendbuf, int *sendcount, int *sendtype_f, void *recvbuf,
                    int *recvcount, int *recvtype_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Ialltoall(send_addr, *sendcount, sendtype, recvbuf, *recvcount, recvtype, comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_ialltoallv_(const void *sendbuf, const int sendcounts[], const int sdispls[], int *sendtype_f,
                     void *recvbuf, const int recvcounts[], const int rdispls[], int *recvtype_f,
                     int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype sendtype = C_MPI_TYPE_FROMINT(*sendtype_f);
    MPI_Datatype recvtype = C_MPI_TYPE_FROMINT(*recvtype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Ialltoallv(send_addr, sendcounts, sdispls, sendtype,
                             recvbuf, recvcounts, rdispls, recvtype, comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_ialltoallw_(const void *sendbuf, const int sendcounts[], const int sdispls[], const int sendtypes_f[],
                     void *recvbuf, const int recvcounts[], const int rdispls[], const int recvtypes_f[],
                     int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    int comm_size = 0;
    *ierror = MPI_Comm_size(comm, &comm_size);
    if (*ierror != MPI_SUCCESS) {
        C_MPI_RC_FIX(*ierror);
        return;
    }
    MPI_Datatype *sendtypes = f77_datatypes_from_ints(comm_size, sendtypes_f);
    MPI_Datatype *recvtypes = f77_datatypes_from_ints(comm_size, recvtypes_f);
    if (sendtypes == NULL || recvtypes == NULL) {
        free(sendtypes);
        free(recvtypes);
        *ierror = MPI_ERR_OTHER;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Ialltoallw(send_addr, sendcounts, sdispls, sendtypes,
                             recvbuf, recvcounts, rdispls, recvtypes, comm, &request);
    free(sendtypes);
    free(recvtypes);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_ireduce_scatter_(const void *sendbuf, void *recvbuf, const int recvcounts[],
                          int *datatype_f, int *op_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Ireduce_scatter(send_addr, recvbuf, recvcounts, datatype, op, comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_ireduce_scatter_block_(const void *sendbuf, void *recvbuf, int *recvcount,
                                int *datatype_f, int *op_f, int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    const void *send_addr = C_IS_MPI_IN_PLACE(sendbuf) ? MPI_IN_PLACE : sendbuf;
    *ierror = MPI_Ireduce_scatter_block(send_addr, recvbuf, *recvcount, datatype, op, comm, &request);
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}

void mpi_send_(void *buffer, int *count, int *datatype, int *dest, int *tag, int *comm, int *ierror) { C_MPI_Send(buffer, *count, *datatype, *dest, *tag, *comm, ierror); }
void mpi_bsend_(void *buffer, int *count, int *datatype, int *dest, int *tag, int *comm, int *ierror) { C_MPI_Bsend(buffer, *count, *datatype, *dest, *tag, *comm, ierror); }
void mpi_ssend_(void *buffer, int *count, int *datatype, int *dest, int *tag, int *comm, int *ierror) { C_MPI_Ssend(buffer, *count, *datatype, *dest, *tag, *comm, ierror); }
void mpi_rsend_(void *buffer, int *count, int *datatype, int *dest, int *tag, int *comm, int *ierror) { C_MPI_Rsend(buffer, *count, *datatype, *dest, *tag, *comm, ierror); }
void mpi_isend_(void *buffer, int *count, int *datatype, int *dest, int *tag, int *comm, int *request, int *ierror) { C_MPI_Isend(buffer, *count, *datatype, *dest, *tag, *comm, request, ierror); }
void mpi_issend_(void *buffer, int *count, int *datatype, int *dest, int *tag, int *comm, int *request, int *ierror) { C_MPI_Issend(buffer, *count, *datatype, *dest, *tag, *comm, request, ierror); }
void mpi_irsend_(void *buffer, int *count, int *datatype, int *dest, int *tag, int *comm, int *request, int *ierror) { C_MPI_Irsend(buffer, *count, *datatype, *dest, *tag, *comm, request, ierror); }
void mpi_recv_(void *buffer, int *count, int *datatype, int *source, int *tag, int *comm, int *status, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Recv(buffer, *count, *datatype, *source, *tag, *comm,
               f77_status_arg(status, &status_arg), ierror);
    f77_status_store(status, &status_arg);
}
void mpi_irecv_(void *buffer, int *count, int *datatype, int *source, int *tag, int *comm, int *request, int *ierror) { C_MPI_Irecv(buffer, *count, *datatype, *source, *tag, *comm, request, ierror); }
void mpi_wait_(int *request, int *status, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Wait(request, f77_status_arg(status, &status_arg), ierror);
    f77_status_store(status, &status_arg);
}
void mpi_waitall_(int *count, int requests[], int statuses[], int *ierror)
{
    struct F_MPI_Status *statuses_arg = f77_statuses_arg(*count, statuses, ierror);
    if (statuses_arg == NULL && !C_IS_MPI_STATUSES_IGNORE(statuses)) return;
    C_MPI_Waitall(*count, requests, statuses_arg, ierror);
    f77_statuses_store_free(*count, statuses, statuses_arg);
}
void mpi_waitsome_(int *incount, int requests[], int *outcount, int indices[], int statuses[], int *ierror)
{
    struct F_MPI_Status *statuses_arg = f77_statuses_arg(*incount, statuses, ierror);
    if (statuses_arg == NULL && !C_IS_MPI_STATUSES_IGNORE(statuses)) return;
    C_MPI_Waitsome(*incount, requests, outcount, indices, statuses_arg, ierror);
    if (*outcount > 0) {
        f77_statuses_store_free(*outcount, statuses, statuses_arg);
    } else if (!C_IS_MPI_STATUSES_IGNORE(statuses)) {
        free(statuses_arg);
    }
}
void mpi_test_(int *request, int *flag, int *status, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Test(request, flag, f77_status_arg(status, &status_arg), ierror);
    if (*flag) f77_status_store(status, &status_arg);
    f77_logical_store(flag, *flag);
}
void mpi_testall_(int *count, int requests[], int *flag, int statuses[], int *ierror)
{
    struct F_MPI_Status *statuses_arg = f77_statuses_arg(*count, statuses, ierror);
    if (statuses_arg == NULL && !C_IS_MPI_STATUSES_IGNORE(statuses)) return;
    C_MPI_Testall(*count, requests, flag, statuses_arg, ierror);
    if (*flag) {
        f77_statuses_store_free(*count, statuses, statuses_arg);
    } else if (!C_IS_MPI_STATUSES_IGNORE(statuses)) {
        free(statuses_arg);
    }
    f77_logical_store(flag, *flag);
}
void mpi_testsome_(int *incount, int requests[], int *outcount, int indices[], int statuses[], int *ierror)
{
    struct F_MPI_Status *statuses_arg = f77_statuses_arg(*incount, statuses, ierror);
    if (statuses_arg == NULL && !C_IS_MPI_STATUSES_IGNORE(statuses)) return;
    C_MPI_Testsome(*incount, requests, outcount, indices, statuses_arg, ierror);
    if (*outcount > 0) {
        f77_statuses_store_free(*outcount, statuses, statuses_arg);
    } else if (!C_IS_MPI_STATUSES_IGNORE(statuses)) {
        free(statuses_arg);
    }
}
void mpi_testany_(int *count, int requests[], int *index, int *flag, int *status, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Testany(*count, requests, index, flag, f77_status_arg(status, &status_arg), ierror);
    if (*flag && *index != MPI_UNDEFINED) {
        f77_status_store(status, &status_arg);
        *index += 1;
    } else if (*index == MPI_UNDEFINED) {
        *index = C_MPI_UNDEFINED_C2F(*index);
    }
    f77_logical_store(flag, *flag);
}
void mpi_waitany_(int *count, int requests[], int *index, int *status, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Waitany(*count, requests, index, f77_status_arg(status, &status_arg), ierror);
    if (*index != MPI_UNDEFINED) {
        f77_status_store(status, &status_arg);
        *index += 1;
    } else {
        *index = C_MPI_UNDEFINED_C2F(*index);
    }
}
void mpi_probe_(int *source, int *tag, int *comm, int *status, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Probe(*source, *tag, *comm, f77_status_arg(status, &status_arg), ierror);
    f77_status_store(status, &status_arg);
}
void mpi_mprobe_(int *source, int *tag, int *comm, int *message, int *status, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Mprobe(*source, *tag, *comm, message, f77_status_arg(status, &status_arg), ierror);
    f77_status_store(status, &status_arg);
}
void mpi_iprobe_(int *source, int *tag, int *comm, int *flag, int *status, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Iprobe(*source, *tag, *comm, flag, f77_status_arg(status, &status_arg), ierror);
    if (*flag) f77_status_store(status, &status_arg);
    f77_logical_store(flag, *flag);
}
void mpi_improbe_(int *source, int *tag, int *comm, int *flag, int *message, int *status, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Improbe(*source, *tag, *comm, flag, message, f77_status_arg(status, &status_arg), ierror);
    if (*flag) f77_status_store(status, &status_arg);
    f77_logical_store(flag, *flag);
}
void mpi_get_count_(int *status, int *datatype, int *count, int *ierror)
{
    struct F_MPI_Status status_arg;
    VAPAA_MPI_Get_count(f77_status_arg(status, &status_arg), datatype, count, ierror);
}
void mpi_status_set_cancelled_(int *status, int *flag, int *ierror)
{
    int flag_c = (*flag != 0) ? 1 : 0;
    struct F_MPI_Status status_arg;
    C_MPI_Status_set_cancelled(f77_status_arg(status, &status_arg), &flag_c, ierror);
    f77_status_store(status, &status_arg);
}
void mpi_status_set_elements_(int *status, int *datatype, int *count, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Status_set_elements(f77_status_arg(status, &status_arg), *datatype, *count, ierror);
    f77_status_store(status, &status_arg);
}
void mpi_request_free_(int *request, int *ierror) { C_MPI_Request_free(request, ierror); }
void mpi_cancel_(int *request, int *ierror) { C_MPI_Cancel(request, ierror); }
void mpi_start_(int *request, int *ierror) { C_MPI_Start(request, ierror); }
void mpi_startall_(int *count, int requests[], int *ierror) { C_MPI_Startall(count, requests, ierror); }
void mpi_send_init_(void *buffer, int *count, int *datatype, int *dest, int *tag, int *comm, int *request, int *ierror) { C_MPI_Send_init(buffer, *count, *datatype, *dest, *tag, *comm, request, ierror); }
void mpi_bsend_init_(void *buffer, int *count, int *datatype, int *dest, int *tag, int *comm, int *request, int *ierror) { C_MPI_Bsend_init(buffer, *count, *datatype, *dest, *tag, *comm, request, ierror); }
void mpi_ssend_init_(void *buffer, int *count, int *datatype, int *dest, int *tag, int *comm, int *request, int *ierror) { C_MPI_Ssend_init(buffer, *count, *datatype, *dest, *tag, *comm, request, ierror); }
void mpi_rsend_init_(void *buffer, int *count, int *datatype, int *dest, int *tag, int *comm, int *request, int *ierror) { C_MPI_Rsend_init(buffer, *count, *datatype, *dest, *tag, *comm, request, ierror); }
void mpi_recv_init_(void *buffer, int *count, int *datatype, int *source, int *tag, int *comm, int *request, int *ierror) { C_MPI_Recv_init(buffer, *count, *datatype, *source, *tag, *comm, request, ierror); }
void mpi_sendrecv_(void *sbuf, int *scount, int *stype, int *dest, int *stag, void *rbuf, int *rcount, int *rtype, int *source, int *rtag, int *comm, int *status, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Sendrecv(sbuf, *scount, *stype, *dest, *stag, rbuf, *rcount, *rtype, *source, *rtag,
                   *comm, f77_status_arg(status, &status_arg), ierror);
    f77_status_store(status, &status_arg);
}
void mpi_sendrecv_replace_(void *buf, int *count, int *datatype_f, int *dest, int *sendtag,
                           int *source, int *recvtag, int *comm_f, int *status, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Status status_c;
    MPI_Status *status_arg = MPI_STATUS_IGNORE;
    void *addr = C_IS_MPI_BOTTOM(buf) ? MPI_BOTTOM : buf;

    struct F_MPI_Status status_f;

    if (!C_IS_MPI_STATUS_IGNORE(status)) {
        f77_status_to_struct(status, &status_f);
        C_MPI_STATUS_TO_C(&status_f, &status_c);
        status_arg = &status_c;
    }
    *ierror = MPI_Sendrecv_replace(addr, *count, datatype, C_MPI_DEST_F2C(*dest),
                                   C_MPI_TAG_F2C(*sendtag), C_MPI_SOURCE_F2C(*source),
                                   C_MPI_TAG_F2C(*recvtag), comm, status_arg);
    if (!C_IS_MPI_STATUS_IGNORE(status)) {
        C_MPI_STATUS_FROM_C(&status_c, &status_f);
        f77_status_from_struct(&status_f, status);
    }
    C_MPI_RC_FIX(*ierror);
}
void mpi_mrecv_(void *buffer, int *count, int *datatype, int *message, int *status, int *ierror)
{
    struct F_MPI_Status status_arg;
    C_MPI_Mrecv(buffer, *count, *datatype, message, f77_status_arg(status, &status_arg), ierror);
    f77_status_store(status, &status_arg);
}
void mpi_imrecv_(void *buffer, int *count, int *datatype, int *message, int *request, int *ierror)
{
    C_MPI_Imrecv(buffer, *count, *datatype, message, request, ierror);
}
void mpi_pack_(void *inbuf, int *incount, int *datatype, void *outbuf, int *outsize, int *position, int *comm, int *ierror) { C_MPI_Pack(inbuf, *incount, *datatype, outbuf, *outsize, position, *comm, ierror); }
void mpi_unpack_(void *inbuf, int *insize, int *position, void *outbuf, int *outcount, int *datatype, int *comm, int *ierror) { C_MPI_Unpack(inbuf, *insize, position, outbuf, *outcount, *datatype, *comm, ierror); }
void mpi_pack_size_(int *incount, int *datatype, int *comm, int *size, int *ierror) { VAPAA_MPI_Pack_size(incount, datatype, comm, size, ierror); }
void mpi_buffer_attach_(void *buffer, int *size, int *ierror)
{
    *ierror = MPI_Buffer_attach(C_IS_MPI_BOTTOM(buffer) ? MPI_BOTTOM : buffer, *size);
    C_MPI_RC_FIX(*ierror);
}
void mpi_buffer_detach_(void *buffer, int *size, int *ierror)
{
    void *detached = NULL;

    (void)buffer;
    *ierror = MPI_Buffer_detach(&detached, size);
    C_MPI_RC_FIX(*ierror);
}
void mpi_pack_external_size_(char *datarep, int *incount, int *datatype_f, intptr_t *size_f,
                             int *ierror, size_t datarep_len)
{
    char *datarep_c = f77_string_to_c(datarep, datarep_len);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Aint size = 0;

    if (datarep_c == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return;
    }
    *ierror = MPI_Pack_external_size(datarep_c, *incount, datatype, &size);
    *size_f = (intptr_t)size;
    free(datarep_c);
    C_MPI_RC_FIX(*ierror);
}
void mpi_pack_external_(char *datarep, void *inbuf, int *incount, int *datatype_f, void *outbuf,
                        intptr_t *outsize, intptr_t *position, int *ierror, size_t datarep_len)
{
    char *datarep_c = f77_string_to_c(datarep, datarep_len);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Aint pos = (MPI_Aint)*position;
    const void *in_addr = C_IS_MPI_BOTTOM(inbuf) ? MPI_BOTTOM : inbuf;
    void *out_addr = C_IS_MPI_BOTTOM(outbuf) ? MPI_BOTTOM : outbuf;

    if (datarep_c == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return;
    }
    *ierror = MPI_Pack_external(datarep_c, in_addr, *incount, datatype, out_addr,
                                (MPI_Aint)*outsize, &pos);
    *position = (intptr_t)pos;
    free(datarep_c);
    C_MPI_RC_FIX(*ierror);
}
void mpi_unpack_external_(char *datarep, void *inbuf, intptr_t *insize, intptr_t *position,
                          void *outbuf, int *outcount, int *datatype_f, int *ierror,
                          size_t datarep_len)
{
    char *datarep_c = f77_string_to_c(datarep, datarep_len);
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(*datatype_f);
    MPI_Aint pos = (MPI_Aint)*position;
    const void *in_addr = C_IS_MPI_BOTTOM(inbuf) ? MPI_BOTTOM : inbuf;
    void *out_addr = C_IS_MPI_BOTTOM(outbuf) ? MPI_BOTTOM : outbuf;

    if (datarep_c == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return;
    }
    *ierror = MPI_Unpack_external(datarep_c, in_addr, (MPI_Aint)*insize, &pos,
                                  out_addr, *outcount, datatype);
    *position = (intptr_t)pos;
    free(datarep_c);
    C_MPI_RC_FIX(*ierror);
}
void mpi_grequest_start_(vapaa_c_funptr query_fn, vapaa_c_funptr free_fn, vapaa_c_funptr cancel_fn,
                         intptr_t *extra, int *request_f, int *ierror)
{
    struct vapaa_f77_greq_state *s = malloc(sizeof(*s));
    MPI_Request request = MPI_REQUEST_NULL;

    if (s == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return;
    }
    s->query = (vapaa_f77_greq_query_fn)query_fn;
    s->free_fn = (vapaa_f77_greq_free_fn)free_fn;
    s->cancel = (vapaa_f77_greq_cancel_fn)cancel_fn;
    s->extra = extra;

    *ierror = MPI_Grequest_start(f77_grequest_query_trampoline,
                                 f77_grequest_free_trampoline,
                                 f77_grequest_cancel_trampoline,
                                 s, &request);
    if (*ierror != MPI_SUCCESS) {
        free(s);
    }
    f77_request_store(request, request_f);
    C_MPI_RC_FIX(*ierror);
}
void mpi_grequest_complete_(int *request_f, int *ierror)
{
    MPI_Request request = C_MPI_REQUEST_FROMINT(*request_f);
    *ierror = MPI_Grequest_complete(request);
    C_MPI_RC_FIX(*ierror);
}

void mpi_type_commit_(int *datatype, int *ierror) { C_MPI_Type_commit(datatype, ierror); }
void mpi_type_size_(int *datatype, int *size, int *ierror) { C_MPI_Type_size(datatype, size, ierror); }
void mpi_type_dup_(int *oldtype, int *newtype, int *ierror) { C_MPI_Type_dup(oldtype, newtype, ierror); }
void mpi_type_free_(int *datatype, int *ierror) { C_MPI_Type_free(datatype, ierror); }
void mpi_type_vector_(int *count, int *blocklength, int *stride, int *oldtype, int *newtype, int *ierror) { C_MPI_Type_vector(count, blocklength, stride, oldtype, newtype, ierror); }
void mpi_type_contiguous_(int *count, int *oldtype, int *newtype, int *ierror) { C_MPI_Type_contiguous(count, oldtype, newtype, ierror); }
void mpi_type_create_subarray_(int *ndims, int *sizes, int *subsizes, int *starts, int *order, int *oldtype, int *newtype, int *ierror) { C_MPI_Type_create_subarray(ndims, sizes, subsizes, starts, order, oldtype, newtype, ierror); }
void mpi_type_create_resized_(int *oldtype, intptr_t *lb, intptr_t *extent, int *newtype, int *ierror) { VAPAA_MPI_Type_create_resized(oldtype, lb, extent, newtype, ierror); }
void mpi_type_create_hvector_(int *count, int *blocklength, intptr_t *stride, int *oldtype, int *newtype, int *ierror) { VAPAA_MPI_Type_create_hvector(count, blocklength, stride, oldtype, newtype, ierror); }
void mpi_type_create_hindexed_(int *count, int *blocklengths, intptr_t *displacements, int *oldtype, int *newtype, int *ierror) { VAPAA_MPI_Type_create_hindexed(count, blocklengths, displacements, oldtype, newtype, ierror); }
void mpi_type_hindexed_(int *count, int *blocklengths, int *displacements, int *oldtype, int *newtype, int *ierror)
{
    intptr_t *displacements_a = NULL;
    if (*count > 0) {
        displacements_a = malloc((size_t)*count * sizeof(*displacements_a));
        if (displacements_a == NULL) {
            *ierror = VAPAA_MPI_ERR_NO_MEM;
            return;
        }
        for (int i = 0; i < *count; i++) {
            displacements_a[i] = (intptr_t)displacements[i];
        }
    }
    VAPAA_MPI_Type_create_hindexed(count, blocklengths, displacements_a, oldtype, newtype, ierror);
    free(displacements_a);
}
void mpi_type_create_hindexed_block_(int *count, int *blocklength, intptr_t *displacements, int *oldtype, int *newtype, int *ierror) { VAPAA_MPI_Type_create_hindexed_block(count, blocklength, displacements, oldtype, newtype, ierror); }
void mpi_type_create_indexed_block_(int *count, int *blocklength, int *displacements, int *oldtype, int *newtype, int *ierror) { VAPAA_MPI_Type_create_indexed_block(count, blocklength, displacements, oldtype, newtype, ierror); }
void mpi_type_create_struct_(int *count, int *blocklengths, intptr_t *displacements, int *datatypes, int *newtype, int *ierror) { VAPAA_MPI_Type_create_struct(count, blocklengths, displacements, datatypes, newtype, ierror); }
void mpi_type_get_envelope_(int *datatype, int *nints, int *nadds, int *ntypes, int *combiner, int *ierror) { VAPAA_MPI_Type_get_envelope(datatype, nints, nadds, ntypes, combiner, ierror); }
void mpi_type_get_contents_(int *datatype, int *maxints, int *maxadds, int *maxtypes, int *ints, intptr_t *adds, int *types, int *ierror) { VAPAA_MPI_Type_get_contents(datatype, maxints, maxadds, maxtypes, ints, adds, types, ierror); }
void mpi_type_get_extent_(int *datatype, intptr_t *lb, intptr_t *extent, int *ierror) { VAPAA_MPI_Type_get_extent(datatype, lb, extent, ierror); }
void mpi_type_get_true_extent_(int *datatype, intptr_t *lb, intptr_t *extent, int *ierror) { VAPAA_MPI_Type_get_true_extent(datatype, lb, extent, ierror); }

void mpi_type_get_name_(int *datatype, char *name, int *resultlen, int *ierror, size_t name_len)
{
    char tmp[VAPAA_MPI_MAX_OBJECT_NAME] = {0};
    C_MPI_Type_get_name(datatype, tmp, resultlen, ierror);
    c_string_to_f77(name, name_len, tmp);
}

void mpi_type_set_name_(int *datatype, char *name, int *ierror, size_t name_len)
{
    char *c_name = f77_string_to_c(name, name_len);
    if (c_name == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return;
    }
    C_MPI_Type_set_name(datatype, c_name, ierror);
    free(c_name);
}

void mpi_get_address_(void *location, intptr_t *address, int *ierror)
{
    MPI_Aint address_c = 0;
    *ierror = MPI_Get_address(location, &address_c);
    *address = (intptr_t)address_c;
    C_MPI_RC_FIX(*ierror);
}

void mpi_address_(void *location, intptr_t *address, int *ierror)
{
    mpi_get_address_(location, address, ierror);
}

void mpi_info_create_(int *info, int *ierror) { C_MPI_Info_create(info, ierror); }
void mpi_info_create_env_(int *info, int *ierror) { C_MPI_Info_create_env(info, ierror); }
void mpi_info_dup_(int *info, int *newinfo, int *ierror) { C_MPI_Info_dup(info, newinfo, ierror); }
void mpi_info_free_(int *info, int *ierror) { C_MPI_Info_free(info, ierror); }
void mpi_info_get_nkeys_(int *info, int *nkeys, int *ierror) { C_MPI_Info_get_nkeys(info, nkeys, ierror); }

void mpi_info_get_nthkey_(int *info, int *n, char *key, int *ierror, size_t key_len)
{
    char tmp[VAPAA_MPI_MAX_INFO_KEY + 1] = {0};
    C_MPI_Info_get_nthkey(info, n, tmp, ierror);
    c_string_to_f77(key, key_len, tmp);
}

void mpi_info_set_(int *info, char *key, char *value, int *ierror, size_t key_len, size_t value_len)
{
    char *c_key = f77_info_string_to_c(key, key_len);
    char *c_value = f77_info_string_to_c(value, value_len);
    if (c_key == NULL || c_value == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
    } else {
        C_MPI_Info_set(info, c_key, c_value, ierror);
    }
    free(c_key);
    free(c_value);
}

void mpi_info_delete_(int *info, char *key, int *ierror, size_t key_len)
{
    char *c_key = f77_info_string_to_c(key, key_len);
    if (c_key == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return;
    }
    C_MPI_Info_delete(info, c_key, ierror);
    free(c_key);
}

void mpi_info_get_valuelen_(int *info, char *key, int *valuelen, int *flag, int *ierror, size_t key_len)
{
    char *c_key = f77_info_string_to_c(key, key_len);
    if (c_key == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return;
    }
    C_MPI_Info_get_valuelen(info, c_key, valuelen, flag, ierror);
    f77_logical_store(flag, *flag);
    free(c_key);
}

void mpi_info_get_(int *info, char *key, int *buflen, char *value, int *flag, int *ierror,
                   size_t key_len, size_t value_len)
{
    char *c_key = f77_info_string_to_c(key, key_len);
    int copy_len = *buflen;
    int buflen_c;
    char *c_value;

    if (copy_len < 0) copy_len = 0;
    if ((size_t)copy_len > value_len) copy_len = (int)value_len;
    buflen_c = copy_len > 0 ? copy_len + 1 : 0;
    c_value = calloc((size_t)(buflen_c > 0 ? buflen_c : 1), 1);
    if (c_key == NULL || c_value == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
    } else {
        C_MPI_Info_get_string(info, c_key, &buflen_c, c_value, flag, ierror);
        if (*flag && copy_len > 0) {
            c_string_to_f77_n(value, value_len, c_value, (size_t)copy_len);
        }
        f77_logical_store(flag, *flag);
    }
    free(c_key);
    free(c_value);
}

void mpi_info_get_string_(int *info, char *key, int *buflen, char *value, int *flag, int *ierror,
                          size_t key_len, size_t value_len)
{
    char *c_key = f77_info_string_to_c(key, key_len);
    int buflen_in = *buflen;
    int buflen_c = f77_info_get_string_buflen(buflen_in, value_len);
    char *c_value = calloc((size_t)(buflen_c > 0 ? buflen_c : 1), 1);

    if (c_key == NULL || c_value == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
    } else {
        C_MPI_Info_get_string(info, c_key, &buflen_c, c_value, flag, ierror);
        *buflen = buflen_c > 0 ? buflen_c - 1 : 0;
        if (*flag && buflen_in > 0) {
            size_t copy_len = (size_t)buflen_in;
            if (copy_len > value_len) copy_len = value_len;
            c_string_to_f77_n(value, value_len, c_value, copy_len);
        }
        f77_logical_store(flag, *flag);
    }
    free(c_key);
    free(c_value);
}

void mpi_error_class_(int *errorcode, int *errorclass, int *ierror) { C_MPI_Error_class(errorcode, errorclass, ierror); }

void mpi_error_string_(int *errorcode, char *string, int *resultlen, int *ierror, size_t string_len)
{
    char tmp[VAPAA_MPI_MAX_ERROR_STRING] = {0};
    C_MPI_Error_string(errorcode, tmp, resultlen, ierror);
    c_string_to_f77(string, string_len, tmp);
}

void mpi_add_error_class_(int *errorclass, int *ierror) { C_MPI_Add_error_class(errorclass, ierror); }
void mpi_add_error_code_(int *errorclass, int *errorcode, int *ierror) { C_MPI_Add_error_code(errorclass, errorcode, ierror); }

void mpi_add_error_string_(int *errorcode, char *string, int *ierror, size_t string_len)
{
    char *c_string = f77_string_to_c(string, string_len);
    if (c_string == NULL) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return;
    }
    C_MPI_Add_error_string(errorcode, c_string, ierror);
    free(c_string);
}

void mpi_errhandler_free_(int *errhandler, int *ierror)
{
    C_MPI_Errhandler_free(errhandler, ierror);
}
void mpi_op_create_(vapaa_c_funptr user_fn, int *commute, int *op, int *ierror)
{
    int commute_c = (*commute != 0) ? 1 : 0;
    int slot = f77_op_alloc((vapaa_f77_user_function)user_fn);
    if (slot < 0) {
        *ierror = VAPAA_MPI_ERR_NO_MEM;
        return;
    }
    C_MPI_Op_create(f77_op_trampolines[slot], &commute_c, op, ierror);
    if (*ierror == VAPAA_MPI_SUCCESS) {
        f77_op_slots[slot].op_f = *op;
    } else {
        memset(&f77_op_slots[slot], 0, sizeof(f77_op_slots[slot]));
    }
}
void mpi_op_free_(int *op, int *ierror)
{
    int old_op = *op;
    C_MPI_Op_free(op, ierror);
    if (*ierror == VAPAA_MPI_SUCCESS) {
        f77_op_clear(old_op);
    }
}

void mpi_keyval_create_(vapaa_c_funptr copy, vapaa_c_funptr del, int *keyval, int *extra, int *ierror)
{
    VAPAA_MPI_Keyval_create(copy, del, keyval, extra, ierror);
}
void mpi_keyval_free_(int *keyval, int *ierror) { VAPAA_MPI_Keyval_free(keyval, ierror); }
void mpi_attr_put_(int *comm, int *keyval, int *attrval, int *ierror) { VAPAA_MPI_Attr_put(comm, keyval, attrval, ierror); }
void mpi_attr_get_(int *comm, int *keyval, int *attrval, int *flag, int *ierror) { VAPAA_MPI_Attr_get(comm, keyval, attrval, flag, ierror); f77_logical_store(flag, *flag); }
void mpi_attr_delete_(int *comm, int *keyval, int *ierror) { VAPAA_MPI_Attr_delete(comm, keyval, ierror); }
void mpi_comm_create_keyval_(vapaa_c_funptr copy, vapaa_c_funptr del, int *keyval, intptr_t *extra, int *ierror)
{
    VAPAA_MPI_Comm_create_keyval(copy, del, keyval, extra, ierror);
}
void mpi_comm_delete_attr_(int *comm, int *keyval, int *ierror) { VAPAA_MPI_Comm_delete_attr(comm, keyval, ierror); }
void mpi_comm_free_keyval_(int *keyval, int *ierror) { VAPAA_MPI_Comm_free_keyval(keyval, ierror); }
void mpi_comm_get_attr_(int *comm, int *keyval, intptr_t *attrval, int *flag, int *ierror) { VAPAA_MPI_Comm_get_attr(comm, keyval, attrval, flag, ierror); f77_logical_store(flag, *flag); }
void mpi_comm_set_attr_(int *comm, int *keyval, intptr_t *attrval, int *ierror) { VAPAA_MPI_Comm_set_attr(comm, keyval, attrval, ierror); }
void mpi_type_create_keyval_(vapaa_c_funptr copy, vapaa_c_funptr del, int *keyval, intptr_t *extra, int *ierror)
{
    VAPAA_MPI_Type_create_keyval(copy, del, keyval, extra, ierror);
}
void mpi_type_delete_attr_(int *datatype, int *keyval, int *ierror) { VAPAA_MPI_Type_delete_attr(datatype, keyval, ierror); }
void mpi_type_free_keyval_(int *keyval, int *ierror) { VAPAA_MPI_Type_free_keyval(keyval, ierror); }
void mpi_type_get_attr_(int *datatype, int *keyval, intptr_t *attrval, int *flag, int *ierror) { VAPAA_MPI_Type_get_attr(datatype, keyval, attrval, flag, ierror); f77_logical_store(flag, *flag); }
void mpi_type_set_attr_(int *datatype, int *keyval, intptr_t *attrval, int *ierror) { VAPAA_MPI_Type_set_attr(datatype, keyval, attrval, ierror); }

void mpi_null_copy_fn_(int *oldcomm, int *keyval, int *extra, int *attr_in, int *attr_out, int *flag, int *ierror)
{
    (void)oldcomm; (void)keyval; (void)extra; (void)attr_in;
    *attr_out = 0;
    f77_logical_store(flag, 0);
    *ierror = VAPAA_MPI_SUCCESS;
}

void mpi_null_delete_fn_(int *comm, int *keyval, int *attr, int *extra, int *ierror)
{
    (void)comm; (void)keyval; (void)attr; (void)extra;
    *ierror = VAPAA_MPI_SUCCESS;
}

void mpi_comm_null_copy_fn_(int *oldcomm, int *keyval, intptr_t *extra, intptr_t *attr_in,
                            intptr_t *attr_out, int *flag, int *ierror)
{
    (void)oldcomm; (void)keyval; (void)extra; (void)attr_in;
    *attr_out = 0;
    f77_logical_store(flag, 0);
    *ierror = VAPAA_MPI_SUCCESS;
}

void mpi_comm_null_delete_fn_(int *comm, int *keyval, intptr_t *attr, intptr_t *extra, int *ierror)
{
    (void)comm; (void)keyval; (void)attr; (void)extra;
    *ierror = VAPAA_MPI_SUCCESS;
}

void mpi_comm_dup_fn_(int *oldcomm, int *keyval, intptr_t *extra, intptr_t *attr_in,
                      intptr_t *attr_out, int *flag, int *ierror)
{
    (void)oldcomm; (void)keyval; (void)extra;
    *attr_out = *attr_in;
    f77_logical_store(flag, 1);
    *ierror = VAPAA_MPI_SUCCESS;
}

void mpi_type_null_copy_fn_(int *oldtype, int *keyval, intptr_t *extra, intptr_t *attr_in,
                            intptr_t *attr_out, int *flag, int *ierror)
{
    mpi_comm_null_copy_fn_(oldtype, keyval, extra, attr_in, attr_out, flag, ierror);
}

void mpi_type_null_delete_fn_(int *datatype, int *keyval, intptr_t *attr, intptr_t *extra, int *ierror)
{
    mpi_comm_null_delete_fn_(datatype, keyval, attr, extra, ierror);
}

void mpi_type_dup_fn_(int *oldtype, int *keyval, intptr_t *extra, intptr_t *attr_in,
                      intptr_t *attr_out, int *flag, int *ierror)
{
    mpi_comm_dup_fn_(oldtype, keyval, extra, attr_in, attr_out, flag, ierror);
}
