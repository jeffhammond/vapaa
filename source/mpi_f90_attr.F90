! SPDX-License-Identifier: MIT

module mpi_f90_attr
    use iso_c_binding, only: c_funloc, c_int, c_intptr_t
    implicit none
    private

    public :: MPI_Keyval_create
    public :: MPI_Keyval_free
    public :: MPI_Attr_get
    public :: MPI_Attr_put
    public :: MPI_Comm_create_keyval
    public :: MPI_Type_create_keyval
    public :: MPI_Win_create_keyval

    interface MPI_Keyval_free
        module procedure MPI_Keyval_free_f90
    end interface
    interface MPI_Attr_get
        module procedure MPI_Attr_get_f90
    end interface
    interface MPI_Attr_put
        module procedure MPI_Attr_put_f90
    end interface

    abstract interface
        subroutine MPI_Copy_function_f90(oldcomm, comm_keyval, extra_state, &
                                         attribute_val_in, attribute_val_out, &
                                         flag, ierror)
            implicit none
            integer :: oldcomm, comm_keyval, extra_state
            integer :: attribute_val_in, attribute_val_out, ierror
            logical :: flag
        end subroutine MPI_Copy_function_f90

        subroutine MPI_Delete_function_f90(comm, comm_keyval, attribute_val, &
                                           extra_state, ierror)
            implicit none
            integer :: comm, comm_keyval, attribute_val, extra_state, ierror
        end subroutine MPI_Delete_function_f90

        subroutine MPI_Copy_attr_function_f90(handle, keyval, extra_state, &
                                              attribute_val_in, &
                                              attribute_val_out, flag, ierror)
            use mpi_f90_constants, only: MPI_ADDRESS_KIND
            implicit none
            integer :: handle, keyval, ierror
            integer(kind=MPI_ADDRESS_KIND) :: extra_state
            integer(kind=MPI_ADDRESS_KIND) :: attribute_val_in, attribute_val_out
            logical :: flag
        end subroutine MPI_Copy_attr_function_f90

        subroutine MPI_Delete_attr_function_f90(handle, keyval, attribute_val, &
                                                extra_state, ierror)
            use mpi_f90_constants, only: MPI_ADDRESS_KIND
            implicit none
            integer :: handle, keyval, ierror
            integer(kind=MPI_ADDRESS_KIND) :: attribute_val, extra_state
        end subroutine MPI_Delete_attr_function_f90
    end interface

contains

    subroutine MPI_Keyval_create(copy_fn, delete_fn, keyval, extra_state, ierror)
        use mpi_direct_callback_f, only: VAPAA_MPI_Keyval_create
        use mpi_f90_util, only: f90_finish_ierror
        procedure(MPI_Copy_function_f90) :: copy_fn
        procedure(MPI_Delete_function_f90) :: delete_fn
        integer, intent(out) :: keyval
        integer, intent(in) :: extra_state
        integer, optional, intent(out) :: ierror
        integer(c_int) :: keyval_c, ierror_c
        call VAPAA_MPI_Keyval_create(c_funloc(copy_fn), c_funloc(delete_fn), keyval_c, &
                                     int(extra_state,c_int), ierror_c)
        keyval = keyval_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Keyval_create

    subroutine MPI_Comm_create_keyval(copy_fn, delete_fn, keyval, extra_state, ierror)
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_direct_callback_f, only: VAPAA_MPI_Comm_create_keyval
        use mpi_f90_util, only: f90_finish_ierror
        procedure(MPI_Copy_attr_function_f90) :: copy_fn
        procedure(MPI_Delete_attr_function_f90) :: delete_fn
        integer, intent(out) :: keyval
        integer(kind=MPI_ADDRESS_KIND), intent(in) :: extra_state
        integer, optional, intent(out) :: ierror
        integer(c_int) :: keyval_c, ierror_c
        call VAPAA_MPI_Comm_create_keyval(c_funloc(copy_fn), c_funloc(delete_fn), keyval_c, &
                                          int(extra_state,c_intptr_t), ierror_c)
        keyval = keyval_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Comm_create_keyval

    subroutine MPI_Type_create_keyval(copy_fn, delete_fn, keyval, extra_state, ierror)
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_direct_callback_f, only: VAPAA_MPI_Type_create_keyval
        use mpi_f90_util, only: f90_finish_ierror
        procedure(MPI_Copy_attr_function_f90) :: copy_fn
        procedure(MPI_Delete_attr_function_f90) :: delete_fn
        integer, intent(out) :: keyval
        integer(kind=MPI_ADDRESS_KIND), intent(in) :: extra_state
        integer, optional, intent(out) :: ierror
        integer(c_int) :: keyval_c, ierror_c
        call VAPAA_MPI_Type_create_keyval(c_funloc(copy_fn), c_funloc(delete_fn), keyval_c, &
                                          int(extra_state,c_intptr_t), ierror_c)
        keyval = keyval_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_create_keyval

    subroutine MPI_Win_create_keyval(copy_fn, delete_fn, keyval, extra_state, ierror)
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_direct_callback_f, only: VAPAA_MPI_Win_create_keyval
        use mpi_f90_util, only: f90_finish_ierror
        procedure(MPI_Copy_attr_function_f90) :: copy_fn
        procedure(MPI_Delete_attr_function_f90) :: delete_fn
        integer, intent(out) :: keyval
        integer(kind=MPI_ADDRESS_KIND), intent(in) :: extra_state
        integer, optional, intent(out) :: ierror
        integer(c_int) :: keyval_c, ierror_c
        call VAPAA_MPI_Win_create_keyval(c_funloc(copy_fn), c_funloc(delete_fn), keyval_c, &
                                         int(extra_state,c_intptr_t), ierror_c)
        keyval = keyval_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Win_create_keyval

    subroutine MPI_Keyval_free_f90(keyval, ierror)
        use mpi_attr_c, only: VAPAA_MPI_Keyval_free
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(inout) :: keyval
        integer, optional, intent(out) :: ierror
        integer(c_int) :: keyval_c, ierror_c
        keyval_c = keyval
        call VAPAA_MPI_Keyval_free(keyval_c, ierror_c)
        keyval = keyval_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Keyval_free_f90

    subroutine MPI_Attr_get_f90(comm, keyval, attribute_val, flag, ierror)
        use mpi_attr_c, only: VAPAA_MPI_Attr_get
        use mpi_f90_util, only: f90_finish_ierror, f90_logical_from_c
        integer, intent(in) :: comm, keyval
        integer, intent(out) :: attribute_val
        logical, intent(out) :: flag
        integer, optional, intent(out) :: ierror
        integer(c_int) :: attr_c, flag_c, ierror_c
        call VAPAA_MPI_Attr_get(int(comm,c_int), int(keyval,c_int), attr_c, flag_c, ierror_c)
        attribute_val = attr_c
        flag = f90_logical_from_c(flag_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Attr_get_f90

    subroutine MPI_Attr_put_f90(comm, keyval, attribute_val, ierror)
        use mpi_attr_c, only: VAPAA_MPI_Attr_put
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: comm, keyval, attribute_val
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
        call VAPAA_MPI_Attr_put(int(comm,c_int), int(keyval,c_int), int(attribute_val,c_int), ierror_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Attr_put_f90

end module mpi_f90_attr
