// SPDX-License-Identifier: MIT

#include <mpi.h>
#include <string.h>
#include "convert_handles.h"
#include "convert_constants.h"

// User-defined ops are dynamic handles and still pass through Vapaa's handle
// conversion layer so MPI-5 ABI builds use fromint/toint.

typedef void (*vapaa_c_funptr)(void);
typedef void (*vapaa_f08_user_function)(void *, void *, int *, int *);

struct vapaa_f08_op_slot {
    int in_use;
    int op_f;
    vapaa_f08_user_function fn;
};

#define VAPAA_F08_MAX_OPS 64
static struct vapaa_f08_op_slot f08_op_slots[VAPAA_F08_MAX_OPS];

static void f08_op_dispatch(int slot, void *invec, void *inoutvec, int *len,
                            MPI_Datatype *datatype)
{
    struct vapaa_f08_op_slot *s = &f08_op_slots[slot];
    int datatype_f = C_MPI_TYPE_TOINT(*datatype);

    if (s->in_use && s->fn != NULL) {
        s->fn(invec, inoutvec, len, &datatype_f);
    }
}

#define VAPAA_F08_OP_TRAMPOLINE(n) \
static void f08_op_trampoline_##n(void *invec, void *inoutvec, int *len, MPI_Datatype *datatype) \
{ \
    f08_op_dispatch(n, invec, inoutvec, len, datatype); \
}
VAPAA_F08_OP_TRAMPOLINE(0)
VAPAA_F08_OP_TRAMPOLINE(1)
VAPAA_F08_OP_TRAMPOLINE(2)
VAPAA_F08_OP_TRAMPOLINE(3)
VAPAA_F08_OP_TRAMPOLINE(4)
VAPAA_F08_OP_TRAMPOLINE(5)
VAPAA_F08_OP_TRAMPOLINE(6)
VAPAA_F08_OP_TRAMPOLINE(7)
VAPAA_F08_OP_TRAMPOLINE(8)
VAPAA_F08_OP_TRAMPOLINE(9)
VAPAA_F08_OP_TRAMPOLINE(10)
VAPAA_F08_OP_TRAMPOLINE(11)
VAPAA_F08_OP_TRAMPOLINE(12)
VAPAA_F08_OP_TRAMPOLINE(13)
VAPAA_F08_OP_TRAMPOLINE(14)
VAPAA_F08_OP_TRAMPOLINE(15)
VAPAA_F08_OP_TRAMPOLINE(16)
VAPAA_F08_OP_TRAMPOLINE(17)
VAPAA_F08_OP_TRAMPOLINE(18)
VAPAA_F08_OP_TRAMPOLINE(19)
VAPAA_F08_OP_TRAMPOLINE(20)
VAPAA_F08_OP_TRAMPOLINE(21)
VAPAA_F08_OP_TRAMPOLINE(22)
VAPAA_F08_OP_TRAMPOLINE(23)
VAPAA_F08_OP_TRAMPOLINE(24)
VAPAA_F08_OP_TRAMPOLINE(25)
VAPAA_F08_OP_TRAMPOLINE(26)
VAPAA_F08_OP_TRAMPOLINE(27)
VAPAA_F08_OP_TRAMPOLINE(28)
VAPAA_F08_OP_TRAMPOLINE(29)
VAPAA_F08_OP_TRAMPOLINE(30)
VAPAA_F08_OP_TRAMPOLINE(31)
VAPAA_F08_OP_TRAMPOLINE(32)
VAPAA_F08_OP_TRAMPOLINE(33)
VAPAA_F08_OP_TRAMPOLINE(34)
VAPAA_F08_OP_TRAMPOLINE(35)
VAPAA_F08_OP_TRAMPOLINE(36)
VAPAA_F08_OP_TRAMPOLINE(37)
VAPAA_F08_OP_TRAMPOLINE(38)
VAPAA_F08_OP_TRAMPOLINE(39)
VAPAA_F08_OP_TRAMPOLINE(40)
VAPAA_F08_OP_TRAMPOLINE(41)
VAPAA_F08_OP_TRAMPOLINE(42)
VAPAA_F08_OP_TRAMPOLINE(43)
VAPAA_F08_OP_TRAMPOLINE(44)
VAPAA_F08_OP_TRAMPOLINE(45)
VAPAA_F08_OP_TRAMPOLINE(46)
VAPAA_F08_OP_TRAMPOLINE(47)
VAPAA_F08_OP_TRAMPOLINE(48)
VAPAA_F08_OP_TRAMPOLINE(49)
VAPAA_F08_OP_TRAMPOLINE(50)
VAPAA_F08_OP_TRAMPOLINE(51)
VAPAA_F08_OP_TRAMPOLINE(52)
VAPAA_F08_OP_TRAMPOLINE(53)
VAPAA_F08_OP_TRAMPOLINE(54)
VAPAA_F08_OP_TRAMPOLINE(55)
VAPAA_F08_OP_TRAMPOLINE(56)
VAPAA_F08_OP_TRAMPOLINE(57)
VAPAA_F08_OP_TRAMPOLINE(58)
VAPAA_F08_OP_TRAMPOLINE(59)
VAPAA_F08_OP_TRAMPOLINE(60)
VAPAA_F08_OP_TRAMPOLINE(61)
VAPAA_F08_OP_TRAMPOLINE(62)
VAPAA_F08_OP_TRAMPOLINE(63)

static MPI_User_function *f08_op_trampolines[VAPAA_F08_MAX_OPS] = {
    f08_op_trampoline_0, f08_op_trampoline_1, f08_op_trampoline_2, f08_op_trampoline_3,
    f08_op_trampoline_4, f08_op_trampoline_5, f08_op_trampoline_6, f08_op_trampoline_7,
    f08_op_trampoline_8, f08_op_trampoline_9, f08_op_trampoline_10, f08_op_trampoline_11,
    f08_op_trampoline_12, f08_op_trampoline_13, f08_op_trampoline_14, f08_op_trampoline_15,
    f08_op_trampoline_16, f08_op_trampoline_17, f08_op_trampoline_18, f08_op_trampoline_19,
    f08_op_trampoline_20, f08_op_trampoline_21, f08_op_trampoline_22, f08_op_trampoline_23,
    f08_op_trampoline_24, f08_op_trampoline_25, f08_op_trampoline_26, f08_op_trampoline_27,
    f08_op_trampoline_28, f08_op_trampoline_29, f08_op_trampoline_30, f08_op_trampoline_31,
    f08_op_trampoline_32, f08_op_trampoline_33, f08_op_trampoline_34, f08_op_trampoline_35,
    f08_op_trampoline_36, f08_op_trampoline_37, f08_op_trampoline_38, f08_op_trampoline_39,
    f08_op_trampoline_40, f08_op_trampoline_41, f08_op_trampoline_42, f08_op_trampoline_43,
    f08_op_trampoline_44, f08_op_trampoline_45, f08_op_trampoline_46, f08_op_trampoline_47,
    f08_op_trampoline_48, f08_op_trampoline_49, f08_op_trampoline_50, f08_op_trampoline_51,
    f08_op_trampoline_52, f08_op_trampoline_53, f08_op_trampoline_54, f08_op_trampoline_55,
    f08_op_trampoline_56, f08_op_trampoline_57, f08_op_trampoline_58, f08_op_trampoline_59,
    f08_op_trampoline_60, f08_op_trampoline_61, f08_op_trampoline_62, f08_op_trampoline_63
};

static int f08_op_alloc(vapaa_f08_user_function fn)
{
    for (int i = 0; i < VAPAA_F08_MAX_OPS; i++) {
        if (!f08_op_slots[i].in_use) {
            f08_op_slots[i].in_use = 1;
            f08_op_slots[i].op_f = VAPAA_MPI_OP_NULL;
            f08_op_slots[i].fn = fn;
            return i;
        }
    }
    return -1;
}

static void f08_op_clear(int op_f)
{
    for (int i = 0; i < VAPAA_F08_MAX_OPS; i++) {
        if (f08_op_slots[i].in_use && f08_op_slots[i].op_f == op_f) {
            memset(&f08_op_slots[i], 0, sizeof(f08_op_slots[i]));
            return;
        }
    }
}

void C_MPI_Op_create(MPI_User_function *user_fn, int * commute_f, int * op_f, int * ierror)
{
    MPI_Op op = MPI_OP_NULL;
    *ierror = MPI_Op_create(user_fn, *commute_f, &op);
    *op_f = C_MPI_OP_TOINT(op);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Op_create_f08(vapaa_c_funptr user_fn, int * commute_f, int * op_f, int * ierror)
{
#if defined(MPI_ABI)
    C_MPI_Op_create((MPI_User_function *) user_fn, commute_f, op_f, ierror);
#else
    int slot = f08_op_alloc((vapaa_f08_user_function) user_fn);
    if (slot < 0) {
        *ierror = MPI_ERR_NO_MEM;
        C_MPI_RC_FIX(*ierror);
        return;
    }

    C_MPI_Op_create(f08_op_trampolines[slot], commute_f, op_f, ierror);
    if (*ierror == VAPAA_MPI_SUCCESS) {
        f08_op_slots[slot].op_f = *op_f;
    } else {
        memset(&f08_op_slots[slot], 0, sizeof(f08_op_slots[slot]));
    }
#endif
}

void C_MPI_Op_free(int * op_f, int * ierror)
{
    int old_op = *op_f;
    MPI_Op op = C_MPI_OP_FROMINT(*op_f);
    *ierror = MPI_Op_free(&op);
    *op_f = C_MPI_OP_TOINT(op);
    C_MPI_RC_FIX(*ierror);
    if (*ierror == VAPAA_MPI_SUCCESS) {
        f08_op_clear(old_op);
    }
}
