module mpi_info_c

    interface
        subroutine C_MPI_Info_create(info_c, ierror_c) &
                   bind(C,name="C_MPI_Info_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: info_c, ierror_c
        end subroutine C_MPI_Info_create
    end interface

#if 0
    interface
        subroutine C_MPI_Info_create_env(info_c, ierror_c) &
                   bind(C,name="C_MPI_Info_create_env")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: info_c, ierror_c
        end subroutine C_MPI_Info_create_env
    end interface
#endif

    interface
        subroutine CFI_MPI_Info_delete(info_c, key_c, ierror_c) &
                   bind(C,name="CFI_MPI_Info_delete")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: info_c
            character(kind=c_char), dimension(:), intent(in) :: key_c
            integer(kind=c_int), intent(out) :: ierror_c
        end subroutine CFI_MPI_Info_delete
    end interface

    interface
        subroutine C_MPI_Info_dup(info_c, newinfo_c, ierror_c) &
                   bind(C,name="C_MPI_Info_dup")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: info_c
            integer(kind=c_int), intent(out) :: newinfo_c, ierror_c
        end subroutine C_MPI_Info_dup
    end interface

    interface
        subroutine C_MPI_Info_free(info_c, ierror_c) &
                   bind(C,name="C_MPI_Info_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: info_c
            integer(kind=c_int), intent(out) :: ierror_c
        end subroutine C_MPI_Info_free
    end interface

    interface
        subroutine C_MPI_Info_get_nkeys(info_c, nkeys_c, ierror_c) &
                   bind(C,name="C_MPI_Info_get_nkeys")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: info_c
            integer(kind=c_int), intent(out) :: nkeys_c, ierror_c
        end subroutine C_MPI_Info_get_nkeys
    end interface

    interface
        subroutine CFI_MPI_Info_get_nthkey(info_c, n_c, key_c, ierror_c) &
                   bind(C,name="CFI_MPI_Info_get_nthkey")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: info_c, n_c
            character(kind=c_char), dimension(:), intent(out) :: key_c
            integer(kind=c_int), intent(out) :: ierror_c
        end subroutine CFI_MPI_Info_get_nthkey
    end interface

    interface
        subroutine CFI_MPI_Info_get_string(info_c, key_c, buflen_c, value_c, flag_c, ierror_c) &
                   bind(C,name="CFI_MPI_Info_get_string")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: info_c
            character(kind=c_char), dimension(:), intent(in) :: key_c
            integer(kind=c_int), intent(inout) :: buflen_c
            character(kind=c_char), dimension(:), intent(out) :: value_c
            integer(kind=c_int), intent(out) :: flag_c, ierror_c
        end subroutine CFI_MPI_Info_get_string
    end interface

    interface
        subroutine CFI_MPI_Info_set(info_c, key_c, value_c, ierror_c) &
                   bind(C,name="CFI_MPI_Info_set")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: info_c
            character(kind=c_char), dimension(:), intent(in) :: key_c, value_c
            integer(kind=c_int), intent(out) :: ierror_c
        end subroutine CFI_MPI_Info_set
    end interface

end module mpi_info_c
