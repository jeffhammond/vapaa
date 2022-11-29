module mpi_op_f
    use iso_c_binding, only: c_int
    use mpi_handle_types, only: MPI_Op
    implicit none

    ! built-in ops
    type(MPI_Op), parameter :: MPI_MAX      = MPI_Op(MPI_VAL = -10001)
    type(MPI_Op), parameter :: MPI_MIN      = MPI_Op(MPI_VAL = -10002)
    type(MPI_Op), parameter :: MPI_SUM      = MPI_Op(MPI_VAL = -10003)
    type(MPI_Op), parameter :: MPI_PROD     = MPI_Op(MPI_VAL = -10004)
    type(MPI_Op), parameter :: MPI_MAXLOC   = MPI_Op(MPI_VAL = -10005)
    type(MPI_Op), parameter :: MPI_MINLOC   = MPI_Op(MPI_VAL = -10006)
    type(MPI_Op), parameter :: MPI_BAND     = MPI_Op(MPI_VAL = -10007)
    type(MPI_Op), parameter :: MPI_BOR      = MPI_Op(MPI_VAL = -10008)
    type(MPI_Op), parameter :: MPI_BXOR     = MPI_Op(MPI_VAL = -10009)
    type(MPI_Op), parameter :: MPI_LAND     = MPI_Op(MPI_VAL = -10010)
    type(MPI_Op), parameter :: MPI_LOR      = MPI_Op(MPI_VAL = -10011)
    type(MPI_Op), parameter :: MPI_LXOR     = MPI_Op(MPI_VAL = -10012)
    type(MPI_Op), parameter :: MPI_REPLACE  = MPI_Op(MPI_VAL = -10013)
    type(MPI_Op), parameter :: MPI_NO_OP    = MPI_Op(MPI_VAL = -10014)

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
