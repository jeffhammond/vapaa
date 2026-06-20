! SPDX-License-Identifier: MIT

module mpi_ierror_f
    use iso_c_binding, only: c_int
    implicit none
    private
    public :: F_MPI_FINISH_IERROR

    interface
        subroutine C_MPI_Fatal_if_missing_ierror(ierror) &
                   bind(C,name="C_MPI_Fatal_if_missing_ierror")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: ierror
        end subroutine C_MPI_Fatal_if_missing_ierror
    end interface

contains

    subroutine F_MPI_FINISH_IERROR(ierror, ierror_c)
        integer, optional, intent(out) :: ierror
        integer(kind=c_int), intent(in) :: ierror_c
        if (present(ierror)) then
            ierror = ierror_c
        else if (ierror_c /= 0_c_int) then
            call C_MPI_Fatal_if_missing_ierror(ierror_c)
        end if
    end subroutine F_MPI_FINISH_IERROR

end module mpi_ierror_f
