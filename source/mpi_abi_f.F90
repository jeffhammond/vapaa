! SPDX-License-Identifier: MIT

module mpi_abi_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Abi_get_fortran_booleans
        module procedure MPI_Abi_get_fortran_booleans_f08
    end interface MPI_Abi_get_fortran_booleans

    interface MPI_Abi_get_fortran_info
        module procedure MPI_Abi_get_fortran_info_f08
    end interface MPI_Abi_get_fortran_info

    interface MPI_Abi_get_info
        module procedure MPI_Abi_get_info_f08
    end interface MPI_Abi_get_info

    interface MPI_Abi_get_version
        module procedure MPI_Abi_get_version_f08
    end interface MPI_Abi_get_version

    interface MPI_Abi_set_fortran_booleans
        module procedure MPI_Abi_set_fortran_booleans_f08
    end interface MPI_Abi_set_fortran_booleans

    interface MPI_Abi_set_fortran_info
        module procedure MPI_Abi_set_fortran_info_f08
    end interface MPI_Abi_set_fortran_info

    contains

        subroutine MPI_Abi_get_fortran_booleans_f08(logical_size, logical_true, logical_false, is_set, ierror)
            use mpi_abi_c, only: C_MPI_Abi_get_fortran_booleans
            integer, intent(in) :: logical_size
            logical, intent(out) :: logical_true, logical_false, is_set
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: logical_size_c, is_set_c, ierror_c
            logical_size_c = logical_size
            call C_MPI_Abi_get_fortran_booleans(logical_size_c, logical_true, logical_false, is_set_c, ierror_c)
            is_set = (is_set_c /= 0)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Abi_get_fortran_booleans_f08

        subroutine MPI_Abi_get_fortran_info_f08(info, ierror)
            use mpi_handle_types, only: MPI_Info
            use mpi_abi_c, only: C_MPI_Abi_get_fortran_info
            type(MPI_Info), intent(out) :: info
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Abi_get_fortran_info(info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Abi_get_fortran_info_f08

        subroutine MPI_Abi_get_info_f08(info, ierror)
            use mpi_handle_types, only: MPI_Info
            use mpi_abi_c, only: C_MPI_Abi_get_info
            type(MPI_Info), intent(out) :: info
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Abi_get_info(info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Abi_get_info_f08

        subroutine MPI_Abi_get_version_f08(abi_major, abi_minor, ierror)
            use mpi_abi_c, only: C_MPI_Abi_get_version
            integer, intent(out) :: abi_major, abi_minor
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: abi_major_c, abi_minor_c, ierror_c
            call C_MPI_Abi_get_version(abi_major_c, abi_minor_c, ierror_c)
            abi_major = abi_major_c
            abi_minor = abi_minor_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Abi_get_version_f08

        subroutine MPI_Abi_set_fortran_booleans_f08(logical_size, logical_true, logical_false, ierror)
            use mpi_abi_c, only: C_MPI_Abi_set_fortran_booleans
            integer, intent(in) :: logical_size
            logical, intent(in) :: logical_true, logical_false
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: logical_size_c, ierror_c
            logical_size_c = logical_size
            call C_MPI_Abi_set_fortran_booleans(logical_size_c, logical_true, logical_false, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Abi_set_fortran_booleans_f08

        subroutine MPI_Abi_set_fortran_info_f08(info, ierror)
            use mpi_handle_types, only: MPI_Info
            use mpi_abi_c, only: C_MPI_Abi_set_fortran_info
            type(MPI_Info), intent(in) :: info
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Abi_set_fortran_info(info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Abi_set_fortran_info_f08

end module mpi_abi_f
