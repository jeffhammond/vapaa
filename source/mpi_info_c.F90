module mpi_info_c

    interface
        subroutine C_MPI_Info_create(info, ierror) &
                   bind(C,name="C_MPI_Info_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: info, ierror
        end subroutine C_MPI_Info_create
    end interface

#if 0
    interface
        subroutine C_MPI_Info_create_env(info, ierror) &
                   bind(C,name="C_MPI_Info_create_env")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: info, ierror
        end subroutine C_MPI_Info_create_env
    end interface
#endif

    interface
        subroutine C_MPI_Info_delete(info, key, ierror) &
                   bind(C,name="C_MPI_Info_delete")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: info
            character(kind=c_char), dimension(*), intent(in) :: key
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Info_delete
    end interface

    interface
        subroutine CFI_MPI_Info_delete(info, key, ierror) &
                   bind(C,name="CFI_MPI_Info_delete")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: info
            type(*), dimension(..), intent(in) :: key
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Info_delete
    end interface

    interface
        subroutine C_MPI_Info_dup(info, newinfo, ierror) &
                   bind(C,name="C_MPI_Info_dup")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: info
            integer(kind=c_int), intent(out) :: newinfo, ierror
        end subroutine C_MPI_Info_dup
    end interface

    interface
        subroutine C_MPI_Info_free(info, ierror) &
                   bind(C,name="C_MPI_Info_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: info
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Info_free
    end interface

    interface
        subroutine C_MPI_Info_get_nkeys(info, nkeys, ierror) &
                   bind(C,name="C_MPI_Info_get_nkeys")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: info
            integer(kind=c_int), intent(out) :: nkeys, ierror
        end subroutine C_MPI_Info_get_nkeys
    end interface

    interface
        subroutine C_MPI_Info_get_nthkey(info, n, key, ierror) &
                   bind(C,name="C_MPI_Info_get_nthkey")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: info, n
            character(kind=c_char), dimension(*), intent(out) :: key
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Info_get_nthkey
    end interface

    interface
        subroutine CFI_MPI_Info_get_nthkey(info, n, key, ierror) &
                   bind(C,name="CFI_MPI_Info_get_nthkey")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: info, n
            type(*), dimension(..), intent(inout) :: key
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Info_get_nthkey
    end interface

    interface
        subroutine C_MPI_Info_get_string(info, key, buflen, value, flag, ierror) &
                   bind(C,name="C_MPI_Info_get_string")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: info
            character(kind=c_char), dimension(*), intent(in) :: key
            integer(kind=c_int), intent(inout) :: buflen
            character(kind=c_char), dimension(*), intent(out) :: value
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine C_MPI_Info_get_string
    end interface

    interface
        subroutine CFI_MPI_Info_get_string(info, key, buflen, value, flag, ierror) &
                   bind(C,name="CFI_MPI_Info_get_string")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: info
            integer(kind=c_int), intent(inout) :: buflen
            type(*), dimension(..), intent(in) :: key
            type(*), dimension(..), intent(inout) :: value
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine CFI_MPI_Info_get_string
    end interface

    interface
        subroutine C_MPI_Info_set(info, key, value, ierror) &
                   bind(C,name="C_MPI_Info_set")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: info
            character(kind=c_char), dimension(*), intent(in) :: key
            character(kind=c_char), dimension(*), intent(in) :: value
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Info_set
    end interface

    interface
        subroutine CFI_MPI_Info_set(info, key, value, ierror) &
                   bind(C,name="CFI_MPI_Info_set")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: info
            type(*), dimension(..), intent(in) :: key
            type(*), dimension(..), intent(in) :: value
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Info_set
    end interface

end module mpi_info_c
