! SPDX-License-Identifier: MIT

module mpi_info_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Info_create
        module procedure MPI_Info_create_f08
    end interface MPI_Info_create

#if 0
    interface MPI_Info_create_env
        module procedure MPI_Info_create_env_f08
    end interface MPI_Info_create_env
#endif

    interface MPI_Info_delete
#ifdef HAVE_CFI
        module procedure MPI_Info_delete_f08ts
#else
        module procedure MPI_Info_delete_f08
#endif
    end interface MPI_Info_delete

    interface MPI_Info_dup
        module procedure MPI_Info_dup_f08
    end interface MPI_Info_dup

    interface MPI_Info_free
        module procedure MPI_Info_free_f08
    end interface MPI_Info_free

    interface MPI_Info_get_nkeys
        module procedure MPI_Info_get_nkeys_f08
    end interface MPI_Info_get_nkeys

    interface MPI_Info_get_nthkey
#ifdef HAVE_CFI
        module procedure MPI_Info_get_nthkey_f08ts
#else
        module procedure MPI_Info_get_nthkey_f08
#endif
    end interface MPI_Info_get_nthkey

    interface MPI_Info_get_string
#ifdef HAVE_CFI
        module procedure MPI_Info_get_string_f08ts
#else
        module procedure MPI_Info_get_string_f08
#endif
    end interface MPI_Info_get_string

    interface MPI_Info_set
#ifdef HAVE_CFI
        module procedure MPI_Info_set_f08ts
#else
        module procedure MPI_Info_set_f08
#endif
    end interface MPI_Info_set

    !!!!!! deprecated in MPI 4.0 !!!!!!
    interface MPI_Info_get
#ifdef HAVE_CFI
        module procedure MPI_Info_get_string_f08ts
#else
        module procedure MPI_Info_get_string_f08
#endif
    end interface MPI_Info_get
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    contains

        subroutine MPI_Info_create_f08(info, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: C_MPI_Info_create
            type(MPI_Info), intent(out) :: info
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Info_create(info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine  MPI_Info_create_f08

#if 0
        subroutine MPI_Info_create_env_f08(info, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: C_MPI_Info_create_env
            type(MPI_Info), intent(out) :: info
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Info_create_env(info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine  MPI_Info_create_env_f08
#endif

        subroutine MPI_Info_delete_f08(info, key, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: C_MPI_Info_delete
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            integer :: i, ls
            character(kind=c_char), dimension(:), allocatable :: key_c
            ls = len(key)
            allocate( key_c(ls+1) )
            key_c = c_null_char
            do i=1, ls
                key_c(i) = key(i:i)
            end do
            call C_MPI_Info_delete(info % MPI_VAL, key_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
            deallocate( key_c )
        end subroutine  MPI_Info_delete_f08

#ifdef HAVE_CFI
        subroutine MPI_Info_delete_f08ts(info, key, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: CFI_MPI_Info_delete
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            integer :: i, ls
            character(kind=c_char), dimension(:), allocatable :: key_c
            ls = len(key)
            allocate( key_c(ls+1) )
            key_c = c_null_char
            do i=1, ls
                key_c(i) = key(i:i)
            end do
            call CFI_MPI_Info_delete(info % MPI_VAL, key_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
            deallocate( key_c )
        end subroutine  MPI_Info_delete_f08ts
#endif

        subroutine MPI_Info_dup_f08(info, newinfo, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: C_MPI_Info_dup
            type(MPI_Info), intent(in) :: info
            type(MPI_Info), intent(out) :: newinfo
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Info_dup(info % MPI_VAL, newinfo % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine  MPI_Info_dup_f08

        subroutine MPI_Info_free_f08(info, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: C_MPI_Info_free
            type(MPI_Info), intent(inout) :: info
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Info_free(info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine  MPI_Info_free_f08

        subroutine MPI_Info_get_nkeys_f08(info, nkeys, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: C_MPI_Info_get_nkeys
            type(MPI_Info), intent(in) :: info
            integer, intent(out) :: nkeys
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: nkeys_c, ierror_c
            call C_MPI_Info_get_nkeys(info % MPI_VAL, nkeys_c, ierror_c)
            nkeys = nkeys_c
            if (present(ierror)) ierror = ierror_c
        end subroutine  MPI_Info_get_nkeys_f08

        subroutine MPI_Info_get_nthkey_f08(info, n, key, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: C_MPI_Info_get_nthkey
            type(MPI_Info), intent(in) :: info
            integer, intent(in) :: n
            character(len=*), intent(out) :: key
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: n_c, ierror_c
            n_c = n
            call C_MPI_Info_get_nthkey(info % MPI_VAL, n_c, key, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine  MPI_Info_get_nthkey_f08

        subroutine MPI_Info_get_nthkey_f08ts(info, n, key, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: CFI_MPI_Info_get_nthkey
            type(MPI_Info), intent(in) :: info
            integer, intent(in) :: n
            character(len=*), intent(out) :: key
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: n_c, ierror_c
            integer :: i, ls
            character(kind=c_char), dimension(:), allocatable :: key_c
            ls = len(key)
            allocate( key_c(ls+1) )
            key_c = c_null_char
            n_c = n
            call CFI_MPI_Info_get_nthkey(info % MPI_VAL, n_c, key_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
            do i=1, ls
                key(i:i) = key_c(i)
            end do
            deallocate( key_c )
        end subroutine  MPI_Info_get_nthkey_f08ts

        subroutine MPI_Info_get_string_f08(info, key, buflen, value, flag, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: C_MPI_Info_get_string
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key
            integer, intent(inout) :: buflen
            character(len=*), intent(out) :: value
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: buflen_c, flag_c, ierror_c
            buflen_c = buflen
            call C_MPI_Info_get_string(info % MPI_VAL, key, buflen_c, value, flag_c, ierror_c)
            buflen = buflen_c
            flag = (flag_c .ne. 0)
            if (present(ierror)) ierror = ierror_c
        end subroutine  MPI_Info_get_string_f08

        subroutine MPI_Info_get_string_f08ts(info, key, buflen, value, flag, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: CFI_MPI_Info_get_string
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key
            integer, intent(inout) :: buflen
            character(len=*), intent(out) :: value
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: buflen_c, flag_c, ierror_c
            integer :: i, lk, lv
            character(kind=c_char), dimension(:), allocatable :: key_c, value_c
            lk = len(key)
            lv = len(value)
            allocate( key_c(lk+1), value_c(lv+1) )
            key_c   = c_null_char
            value_c = c_null_char
            do i=1, lk
                key_c(i) = key(i:i)
            end do
            buflen_c = buflen
            call CFI_MPI_Info_get_string(info % MPI_VAL, key_c, buflen_c, value_c, flag_c, ierror_c)
            buflen = buflen_c
            do i=1, lv
                value(i:i) = value_c(i)
            end do
            flag = (flag_c .ne. 0)
            if (present(ierror)) ierror = ierror_c
            deallocate( key_c, value_c )
        end subroutine  MPI_Info_get_string_f08ts

        subroutine MPI_Info_set_f08(info, key, value, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: C_MPI_Info_set
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key, value
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Info_set(info % MPI_VAL, key, value, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine  MPI_Info_set_f08

        subroutine MPI_Info_set_f08ts(info, key, value, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: CFI_MPI_Info_set
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key, value
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            integer :: i, lk, lv
            character(kind=c_char), dimension(:), allocatable :: key_c, value_c
            lk = len(key)
            lv = len(value)
            allocate( key_c(lk+1), value_c(lv+1) )
            key_c   = c_null_char
            value_c = c_null_char
            do i=1, lk
                key_c(i) = key(i:i)
            end do
            do i=1, lv
                value_c(i) = value(i:i)
            end do
            call CFI_MPI_Info_set(info % MPI_VAL, key_c, value_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
            deallocate( key_c, value_c )
        end subroutine  MPI_Info_set_f08ts

end module mpi_info_f
