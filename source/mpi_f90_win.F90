! SPDX-License-Identifier: MIT

module mpi_f90_win
    use iso_c_binding, only: c_int
    implicit none
    private

    public :: MPI_Win_create
    public :: MPI_Win_free
    public :: MPI_Win_get_attr
    public :: MPI_Win_set_attr
    public :: MPI_Win_free_keyval

    interface MPI_Win_create
        module procedure MPI_Win_create_f90
    end interface
    interface MPI_Win_free
        module procedure MPI_Win_free_f90
    end interface
    interface MPI_Win_get_attr
        module procedure MPI_Win_get_attr_aint_f90
    end interface
    interface MPI_Win_set_attr
        module procedure MPI_Win_set_attr_aint_f90
    end interface
    interface MPI_Win_free_keyval
        module procedure MPI_Win_free_keyval_f90
    end interface

contains

    subroutine MPI_Win_create_f90(base, size, disp_unit, info, comm, win, ierror)
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_direct_win_c, only: VAPAA_MPI_Win_create
        use mpi_f90_util, only: f90_finish_ierror
        type(*), dimension(..), asynchronous :: base
        integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
        integer, intent(in) :: disp_unit, info, comm
        integer, intent(out) :: win
        integer, optional, intent(out) :: ierror
        integer(c_int) :: win_c, ierror_c
        call VAPAA_MPI_Win_create(base, size, int(disp_unit,c_int), int(info,c_int), &
                                  int(comm,c_int), win_c, ierror_c)
        win = win_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Win_create_f90

    subroutine MPI_Win_free_f90(win, ierror)
        use mpi_direct_win_c, only: VAPAA_MPI_Win_free
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(inout) :: win
        integer, optional, intent(out) :: ierror
        integer(c_int) :: win_c, ierror_c
        win_c = win
        call VAPAA_MPI_Win_free(win_c, ierror_c)
        win = win_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Win_free_f90

    subroutine MPI_Win_get_attr_aint_f90(win, win_keyval, attribute_val, flag, ierror)
        use iso_c_binding, only: c_intptr_t
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_direct_win_c, only: VAPAA_MPI_Win_get_attr
        use mpi_f90_util, only: f90_finish_ierror, f90_logical_from_c
        integer, intent(in) :: win, win_keyval
        integer(kind=MPI_ADDRESS_KIND), intent(out) :: attribute_val
        logical, intent(out) :: flag
        integer, optional, intent(out) :: ierror
        integer(c_intptr_t) :: attribute_val_c
        integer(c_int) :: flag_c, ierror_c
        call VAPAA_MPI_Win_get_attr(int(win,c_int), int(win_keyval,c_int), attribute_val_c, flag_c, ierror_c)
        attribute_val = attribute_val_c
        flag = f90_logical_from_c(flag_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Win_get_attr_aint_f90

    subroutine MPI_Win_set_attr_aint_f90(win, win_keyval, attribute_val, ierror)
        use iso_c_binding, only: c_intptr_t
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_direct_win_c, only: VAPAA_MPI_Win_set_attr
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: win, win_keyval
        integer(kind=MPI_ADDRESS_KIND), intent(in) :: attribute_val
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
        call VAPAA_MPI_Win_set_attr(int(win,c_int), int(win_keyval,c_int), int(attribute_val,c_intptr_t), ierror_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Win_set_attr_aint_f90

    subroutine MPI_Win_free_keyval_f90(win_keyval, ierror)
        use mpi_direct_win_c, only: VAPAA_MPI_Win_free_keyval
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(inout) :: win_keyval
        integer, optional, intent(out) :: ierror
        integer(c_int) :: keyval_c, ierror_c
        keyval_c = win_keyval
        call VAPAA_MPI_Win_free_keyval(keyval_c, ierror_c)
        win_keyval = keyval_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Win_free_keyval_f90

end module mpi_f90_win
