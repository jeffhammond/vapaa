! SPDX-License-Identifier: MIT

module mpi_abi_c

    interface
        subroutine C_MPI_Abi_get_fortran_booleans(logical_size, logical_true, logical_false, is_set, ierror) &
                   bind(C,name="C_MPI_Abi_get_fortran_booleans")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: logical_size
            logical, intent(out) :: logical_true, logical_false
            integer(kind=c_int), intent(out) :: is_set, ierror
        end subroutine C_MPI_Abi_get_fortran_booleans
    end interface

    interface
        subroutine C_MPI_Abi_get_fortran_info(info, ierror) &
                   bind(C,name="C_MPI_Abi_get_fortran_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: info, ierror
        end subroutine C_MPI_Abi_get_fortran_info
    end interface

    interface
        subroutine C_MPI_Abi_get_info(info, ierror) &
                   bind(C,name="C_MPI_Abi_get_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: info, ierror
        end subroutine C_MPI_Abi_get_info
    end interface

    interface
        subroutine C_MPI_Abi_get_version(abi_major, abi_minor, ierror) &
                   bind(C,name="C_MPI_Abi_get_version")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: abi_major, abi_minor, ierror
        end subroutine C_MPI_Abi_get_version
    end interface

    interface
        subroutine C_MPI_Abi_set_fortran_booleans(logical_size, logical_true, logical_false, ierror) &
                   bind(C,name="C_MPI_Abi_set_fortran_booleans")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: logical_size
            logical, intent(in) :: logical_true, logical_false
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Abi_set_fortran_booleans
    end interface

    interface
        subroutine C_MPI_Abi_set_fortran_info(info, ierror) &
                   bind(C,name="C_MPI_Abi_set_fortran_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: info
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Abi_set_fortran_info
    end interface

end module mpi_abi_c
