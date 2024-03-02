! SPDX-License-Identifier: MIT

#include "vapaa_constants.h"

module mpi_op_f
    use iso_c_binding, only: c_int
    use mpi_handle_types, only: MPI_Op
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

    contains

        subroutine MPI_Op_create_f08(user_fn, commute, op, ierror)
            use iso_c_binding, only: c_int, c_funptr, c_funloc
            use mpi_handle_types, only: MPI_Op
            use mpi_op_c, only: C_MPI_Op_create
            procedure(MPI_User_function) :: user_fn
            logical, intent(in) :: commute
            type(MPI_Op), intent(out) :: op
            integer, optional, intent(out) :: ierror
            type(c_funptr) :: user_fn_c
            integer(kind=c_int) :: commute_c, ierror_c
            if (commute) then
                commute_c = 1
            else
                commute_c = 0
            end if
            user_fn_c = c_funloc(user_fn)
            call C_MPI_Op_create(user_fn_c, commute_c, op % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Op_create_f08

        subroutine MPI_Op_free_f08(op, ierror)
            use iso_c_binding, only: c_int
            use mpi_op_c, only: C_MPI_Op_free
            type(MPI_Op), intent(inout) :: op
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Op_free(op % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Op_free_f08

end module mpi_op_f
