! SPDX-License-Identifier: MIT

module mpi_f90_util
    use iso_c_binding, only: c_int
    implicit none
    private

    public :: f90_finish_ierror
    public :: f90_logical_from_c

contains

    subroutine f90_finish_ierror(ierror, ierror_c)
        integer, optional, intent(out) :: ierror
        integer(c_int), intent(in) :: ierror_c
        if (present(ierror)) ierror = ierror_c
    end subroutine f90_finish_ierror

    logical function f90_logical_from_c(flag_c)
        integer(c_int), intent(in) :: flag_c
        f90_logical_from_c = flag_c /= 0
    end function f90_logical_from_c

end module mpi_f90_util
