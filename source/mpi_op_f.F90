! SPDX-License-Identifier: MIT

#include "vapaa_constants.h"

module mpi_op_f
    use mpi_ierror_f, only: F_MPI_FINISH_IERROR
    use iso_c_binding, only: c_int, c_ptr, c_funptr, c_funloc, c_null_funptr
    use mpi_handle_types, only: MPI_Datatype, MPI_Op
    implicit none

    ! built-in ops
    type(MPI_Op), parameter :: MPI_MAX      = MPI_Op(MPI_VAL = VAPAA_MPI_MAX)
    type(MPI_Op), parameter :: MPI_MIN      = MPI_Op(MPI_VAL = VAPAA_MPI_MIN)
    type(MPI_Op), parameter :: MPI_SUM      = MPI_Op(MPI_VAL = VAPAA_MPI_SUM)
    type(MPI_Op), parameter :: MPI_PROD     = MPI_Op(MPI_VAL = VAPAA_MPI_PROD)
    type(MPI_Op), parameter :: MPI_MAXLOC   = MPI_Op(MPI_VAL = VAPAA_MPI_MAXLOC)
    type(MPI_Op), parameter :: MPI_MINLOC   = MPI_Op(MPI_VAL = VAPAA_MPI_MINLOC)
    type(MPI_Op), parameter :: MPI_BAND     = MPI_Op(MPI_VAL = VAPAA_MPI_BAND)
    type(MPI_Op), parameter :: MPI_BOR      = MPI_Op(MPI_VAL = VAPAA_MPI_BOR)
    type(MPI_Op), parameter :: MPI_BXOR     = MPI_Op(MPI_VAL = VAPAA_MPI_BXOR)
    type(MPI_Op), parameter :: MPI_LAND     = MPI_Op(MPI_VAL = VAPAA_MPI_LAND)
    type(MPI_Op), parameter :: MPI_LOR      = MPI_Op(MPI_VAL = VAPAA_MPI_LOR)
    type(MPI_Op), parameter :: MPI_LXOR     = MPI_Op(MPI_VAL = VAPAA_MPI_LXOR)
    type(MPI_Op), parameter :: MPI_REPLACE  = MPI_Op(MPI_VAL = VAPAA_MPI_REPLACE)
    type(MPI_Op), parameter :: MPI_NO_OP    = MPI_Op(MPI_VAL = VAPAA_MPI_NO_OP)

    abstract interface
        subroutine MPI_User_function(invec, inoutvec, len, datatype)
            use, intrinsic :: iso_c_binding, only: c_ptr
            use mpi_handle_types, only: MPI_Datatype
            type(c_ptr), value :: invec, inoutvec
            integer :: len
            type(MPI_Datatype) :: datatype
        end subroutine MPI_User_function
    end interface

    interface MPI_Op_create
        module procedure MPI_Op_create_f08
    end interface MPI_Op_create

    interface MPI_Op_free
        module procedure MPI_Op_free_f08
    end interface MPI_Op_free

    type f08_op_slot
        logical :: in_use = .false.
        integer(c_int) :: op = VAPAA_MPI_OP_NULL
        procedure(MPI_User_function), pointer, nopass :: fn => null()
    end type f08_op_slot

    integer, parameter :: VAPAA_F08_MAX_OPS = 64
    type(f08_op_slot), save :: f08_op_slots(0:VAPAA_F08_MAX_OPS - 1)

    contains

        integer function f08_op_alloc(user_fn) result(slot)
            procedure(MPI_User_function) :: user_fn
            integer :: i
            slot = -1
            do i = 0, VAPAA_F08_MAX_OPS - 1
                if (.not. f08_op_slots(i) % in_use) then
                    f08_op_slots(i) % in_use = .true.
                    f08_op_slots(i) % op = VAPAA_MPI_OP_NULL
                    f08_op_slots(i) % fn => user_fn
                    slot = i
                    return
                end if
            end do
        end function f08_op_alloc

        subroutine f08_op_release(slot)
            integer, intent(in) :: slot
            if (slot < 0 .or. slot >= VAPAA_F08_MAX_OPS) return
            f08_op_slots(slot) % in_use = .false.
            f08_op_slots(slot) % op = VAPAA_MPI_OP_NULL
            nullify(f08_op_slots(slot) % fn)
        end subroutine f08_op_release

        subroutine f08_op_clear(op)
            integer(c_int), intent(in) :: op
            integer :: i
            do i = 0, VAPAA_F08_MAX_OPS - 1
                if (f08_op_slots(i) % in_use .and. f08_op_slots(i) % op == op) then
                    call f08_op_release(i)
                    return
                end if
            end do
        end subroutine f08_op_clear

        subroutine f08_op_dispatch(slot, invec, inoutvec, len_c, datatype_f)
            integer, intent(in) :: slot
            type(c_ptr), value :: invec, inoutvec
            integer(c_int), intent(in) :: len_c, datatype_f
            integer :: len
            type(MPI_Datatype) :: datatype

            if (slot < 0 .or. slot >= VAPAA_F08_MAX_OPS) return
            if (.not. f08_op_slots(slot) % in_use) return
            if (.not. associated(f08_op_slots(slot) % fn)) return

            len = int(len_c)
            datatype % MPI_VAL = datatype_f
            call f08_op_slots(slot) % fn(invec, inoutvec, len, datatype)
        end subroutine f08_op_dispatch

#include "mpi_op_trampoline_slots.inc"

        function f08_op_trampoline_funptr(slot) result(fn)
            integer, intent(in) :: slot
            type(c_funptr) :: fn
            fn = c_null_funptr
            select case(slot)
#if defined(HAVE_PGIF) || defined(__flang__)
#define VAPAA_F08_OP_TRAMPOLINE_CASE(N) case(N); fn = c_funloc(f08_op_t_##N)
#else
#define VAPAA_F08_OP_TRAMPOLINE_CASE(N) case(N); fn = c_funloc(f08_op_t_/**/N)
#endif
            VAPAA_F08_OP_TRAMPOLINE_CASE(0)
            VAPAA_F08_OP_TRAMPOLINE_CASE(1)
            VAPAA_F08_OP_TRAMPOLINE_CASE(2)
            VAPAA_F08_OP_TRAMPOLINE_CASE(3)
            VAPAA_F08_OP_TRAMPOLINE_CASE(4)
            VAPAA_F08_OP_TRAMPOLINE_CASE(5)
            VAPAA_F08_OP_TRAMPOLINE_CASE(6)
            VAPAA_F08_OP_TRAMPOLINE_CASE(7)
            VAPAA_F08_OP_TRAMPOLINE_CASE(8)
            VAPAA_F08_OP_TRAMPOLINE_CASE(9)
            VAPAA_F08_OP_TRAMPOLINE_CASE(10)
            VAPAA_F08_OP_TRAMPOLINE_CASE(11)
            VAPAA_F08_OP_TRAMPOLINE_CASE(12)
            VAPAA_F08_OP_TRAMPOLINE_CASE(13)
            VAPAA_F08_OP_TRAMPOLINE_CASE(14)
            VAPAA_F08_OP_TRAMPOLINE_CASE(15)
            VAPAA_F08_OP_TRAMPOLINE_CASE(16)
            VAPAA_F08_OP_TRAMPOLINE_CASE(17)
            VAPAA_F08_OP_TRAMPOLINE_CASE(18)
            VAPAA_F08_OP_TRAMPOLINE_CASE(19)
            VAPAA_F08_OP_TRAMPOLINE_CASE(20)
            VAPAA_F08_OP_TRAMPOLINE_CASE(21)
            VAPAA_F08_OP_TRAMPOLINE_CASE(22)
            VAPAA_F08_OP_TRAMPOLINE_CASE(23)
            VAPAA_F08_OP_TRAMPOLINE_CASE(24)
            VAPAA_F08_OP_TRAMPOLINE_CASE(25)
            VAPAA_F08_OP_TRAMPOLINE_CASE(26)
            VAPAA_F08_OP_TRAMPOLINE_CASE(27)
            VAPAA_F08_OP_TRAMPOLINE_CASE(28)
            VAPAA_F08_OP_TRAMPOLINE_CASE(29)
            VAPAA_F08_OP_TRAMPOLINE_CASE(30)
            VAPAA_F08_OP_TRAMPOLINE_CASE(31)
            VAPAA_F08_OP_TRAMPOLINE_CASE(32)
            VAPAA_F08_OP_TRAMPOLINE_CASE(33)
            VAPAA_F08_OP_TRAMPOLINE_CASE(34)
            VAPAA_F08_OP_TRAMPOLINE_CASE(35)
            VAPAA_F08_OP_TRAMPOLINE_CASE(36)
            VAPAA_F08_OP_TRAMPOLINE_CASE(37)
            VAPAA_F08_OP_TRAMPOLINE_CASE(38)
            VAPAA_F08_OP_TRAMPOLINE_CASE(39)
            VAPAA_F08_OP_TRAMPOLINE_CASE(40)
            VAPAA_F08_OP_TRAMPOLINE_CASE(41)
            VAPAA_F08_OP_TRAMPOLINE_CASE(42)
            VAPAA_F08_OP_TRAMPOLINE_CASE(43)
            VAPAA_F08_OP_TRAMPOLINE_CASE(44)
            VAPAA_F08_OP_TRAMPOLINE_CASE(45)
            VAPAA_F08_OP_TRAMPOLINE_CASE(46)
            VAPAA_F08_OP_TRAMPOLINE_CASE(47)
            VAPAA_F08_OP_TRAMPOLINE_CASE(48)
            VAPAA_F08_OP_TRAMPOLINE_CASE(49)
            VAPAA_F08_OP_TRAMPOLINE_CASE(50)
            VAPAA_F08_OP_TRAMPOLINE_CASE(51)
            VAPAA_F08_OP_TRAMPOLINE_CASE(52)
            VAPAA_F08_OP_TRAMPOLINE_CASE(53)
            VAPAA_F08_OP_TRAMPOLINE_CASE(54)
            VAPAA_F08_OP_TRAMPOLINE_CASE(55)
            VAPAA_F08_OP_TRAMPOLINE_CASE(56)
            VAPAA_F08_OP_TRAMPOLINE_CASE(57)
            VAPAA_F08_OP_TRAMPOLINE_CASE(58)
            VAPAA_F08_OP_TRAMPOLINE_CASE(59)
            VAPAA_F08_OP_TRAMPOLINE_CASE(60)
            VAPAA_F08_OP_TRAMPOLINE_CASE(61)
            VAPAA_F08_OP_TRAMPOLINE_CASE(62)
            VAPAA_F08_OP_TRAMPOLINE_CASE(63)
#undef VAPAA_F08_OP_TRAMPOLINE_CASE
            end select
        end function f08_op_trampoline_funptr

        subroutine MPI_Op_create_f08(user_fn, commute, op, ierror)
            use mpi_handle_types, only: MPI_Op
            use mpi_op_c, only: C_MPI_Op_create_f08
            procedure(MPI_User_function) :: user_fn
            logical, intent(in) :: commute
            type(MPI_Op), intent(out) :: op
            integer, optional, intent(out) :: ierror
            type(c_funptr) :: user_fn_c
            integer :: slot
            integer(kind=c_int) :: commute_c, ierror_c
            if (commute) then
                commute_c = 1
            else
                commute_c = 0
            end if
            slot = f08_op_alloc(user_fn)
            if (slot < 0) then
                op % MPI_VAL = VAPAA_MPI_OP_NULL
                ierror_c = VAPAA_MPI_ERR_NO_MEM
            else
                user_fn_c = f08_op_trampoline_funptr(slot)
                call C_MPI_Op_create_f08(user_fn_c, commute_c, op % MPI_VAL, ierror_c)
                if (ierror_c == VAPAA_MPI_SUCCESS) then
                    f08_op_slots(slot) % op = op % MPI_VAL
                else
                    call f08_op_release(slot)
                end if
            end if
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Op_create_f08

        subroutine MPI_Op_free_f08(op, ierror)
            use iso_c_binding, only: c_int
            use mpi_op_c, only: C_MPI_Op_free
            type(MPI_Op), intent(inout) :: op
            integer, optional, intent(out) :: ierror
            integer(c_int) :: old_op
            integer(kind=c_int) :: ierror_c
            old_op = op % MPI_VAL
            call C_MPI_Op_free(op % MPI_VAL, ierror_c)
            if (ierror_c == VAPAA_MPI_SUCCESS) call f08_op_clear(old_op)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Op_free_f08

end module mpi_op_f
