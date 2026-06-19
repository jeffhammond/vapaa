! SPDX-License-Identifier: MIT

module mpi_f90_error
    use iso_c_binding, only: c_int
    implicit none
    private

    public :: MPI_Error_class
    public :: MPI_Error_string

    interface MPI_Error_class
        module procedure MPI_Error_class_f90
    end interface
    interface MPI_Error_string
        module procedure MPI_Error_string_f90
    end interface

contains

    subroutine MPI_Error_class_f90(errorcode, errorclass, ierror)
        use mpi_error_c, only: C_MPI_Error_class
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: errorcode
        integer, intent(out) :: errorclass
        integer, optional, intent(out) :: ierror
        integer(c_int) :: errorclass_c, ierror_c
        call C_MPI_Error_class(int(errorcode,c_int), errorclass_c, ierror_c)
        errorclass = errorclass_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Error_class_f90

    subroutine MPI_Error_string_f90(errorcode, string, resultlen, ierror)
#ifdef HAVE_CFI
        use mpi_error_c, only: CFI_MPI_Error_string
#else
        use mpi_error_c, only: C_MPI_Error_string
#endif
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: errorcode
        character(len=*), intent(out) :: string
        integer, intent(out) :: resultlen
        integer, optional, intent(out) :: ierror
        integer(c_int) :: resultlen_c, ierror_c
#ifdef HAVE_CFI
        call CFI_MPI_Error_string(int(errorcode,c_int), string, resultlen_c, ierror_c)
#else
        call C_MPI_Error_string(int(errorcode,c_int), string, resultlen_c, ierror_c)
#endif
        resultlen = resultlen_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Error_string_f90

end module mpi_f90_error
