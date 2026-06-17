! SPDX-License-Identifier: MIT

module mpi_info_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Info_create
        module procedure MPI_Info_create_f08
    end interface MPI_Info_create

    interface MPI_Info_create_env
        module procedure MPI_Info_create_env_f08
    end interface MPI_Info_create_env

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

    interface MPI_Info_get_valuelen
#ifdef HAVE_CFI
        module procedure MPI_Info_get_valuelen_f08ts
#else
        module procedure MPI_Info_get_valuelen_f08
#endif
    end interface MPI_Info_get_valuelen

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
        module procedure MPI_Info_get_f08ts
#else
        module procedure MPI_Info_get_f08
#endif
    end interface MPI_Info_get
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    contains

        subroutine make_info_c_string(f, c)
            use iso_c_binding, only: c_char, c_null_char
            character(len=*), intent(in) :: f
            character(kind=c_char), dimension(:), allocatable, intent(out) :: c
            integer :: first, last, i, n
            first = 1
            do while (first <= len(f))
                if (f(first:first) .ne. ' ') exit
                first = first + 1
            end do
            last = len(f)
            do while (last >= first)
                if (f(last:last) .ne. ' ') exit
                last = last - 1
            end do
            if (last >= first) then
                n = last - first + 1
            else
                n = 0
            endif
            allocate(c(n+1))
            c = c_null_char
            do i = 1, n
                c(i) = f(first+i-1:first+i-1)
            end do
        end subroutine make_info_c_string

        subroutine copy_info_c_string(c, f, maxchars)
            use iso_c_binding, only: c_char, c_null_char
            character(kind=c_char), dimension(:), intent(in) :: c
            character(len=*), intent(out) :: f
            integer, optional, intent(in) :: maxchars
            integer :: i, n
            f = ' '
            n = min(len(f), size(c))
            if (present(maxchars)) n = min(n, maxchars)
            do i = 1, n
                if (c(i) .eq. c_null_char) exit
                f(i:i) = c(i)
            end do
        end subroutine copy_info_c_string

        integer function info_c_get_string_buflen(buflen, value_len) result(n)
            integer, intent(in) :: buflen, value_len
            if (buflen <= 0) then
                n = 0
            else
                n = min(buflen, value_len) + 1
            endif
        end function info_c_get_string_buflen

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

        subroutine MPI_Info_delete_f08(info, key, ierror)
            use iso_c_binding, only: c_int, c_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: C_MPI_Info_delete
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            character(kind=c_char), dimension(:), allocatable :: key_c
            call make_info_c_string(key, key_c)
            call C_MPI_Info_delete(info % MPI_VAL, key_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
            deallocate( key_c )
        end subroutine  MPI_Info_delete_f08

#ifdef HAVE_CFI
        subroutine MPI_Info_delete_f08ts(info, key, ierror)
            use iso_c_binding, only: c_int, c_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: CFI_MPI_Info_delete
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            character(kind=c_char), dimension(:), allocatable :: key_c
            call make_info_c_string(key, key_c)
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
            character(kind=c_char), dimension(:), allocatable :: key_c
            allocate(key_c(len(key)+1))
            key_c = c_null_char
            n_c = n
            call C_MPI_Info_get_nthkey(info % MPI_VAL, n_c, key_c, ierror_c)
            call copy_info_c_string(key_c, key)
            if (present(ierror)) ierror = ierror_c
            deallocate(key_c)
        end subroutine  MPI_Info_get_nthkey_f08

#ifdef HAVE_CFI
        subroutine MPI_Info_get_nthkey_f08ts(info, n, key, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: CFI_MPI_Info_get_nthkey
            type(MPI_Info), intent(in) :: info
            integer, intent(in) :: n
            character(len=*), intent(out) :: key
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: n_c, ierror_c
            character(kind=c_char), dimension(:), allocatable :: key_c
            allocate( key_c(len(key)+1) )
            key_c = c_null_char
            n_c = n
            call CFI_MPI_Info_get_nthkey(info % MPI_VAL, n_c, key_c, ierror_c)
            call copy_info_c_string(key_c, key)
            if (present(ierror)) ierror = ierror_c
            deallocate( key_c )
        end subroutine  MPI_Info_get_nthkey_f08ts
#endif

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
            integer :: buflen_in, copy_len, value_c_len
            character(kind=c_char), dimension(:), allocatable :: key_c, value_c
            buflen_in = buflen
            call make_info_c_string(key, key_c)
            value_c_len = max(1, info_c_get_string_buflen(buflen_in, len(value)))
            allocate(value_c(value_c_len))
            value_c = c_null_char
            buflen_c = info_c_get_string_buflen(buflen_in, len(value))
            call C_MPI_Info_get_string(info % MPI_VAL, key_c, buflen_c, value_c, flag_c, ierror_c)
            buflen = max(buflen_c - 1, 0)
            flag = (flag_c .ne. 0)
            if (flag .and. buflen_in > 0) then
                copy_len = min(buflen_in, len(value))
                call copy_info_c_string(value_c, value, copy_len)
            endif
            if (present(ierror)) ierror = ierror_c
            deallocate(key_c, value_c)
        end subroutine  MPI_Info_get_string_f08

#ifdef HAVE_CFI
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
            integer :: buflen_in, copy_len, value_c_len
            character(kind=c_char), dimension(:), allocatable :: key_c, value_c
            buflen_in = buflen
            call make_info_c_string(key, key_c)
            value_c_len = max(1, info_c_get_string_buflen(buflen_in, len(value)))
            allocate(value_c(value_c_len))
            value_c = c_null_char
            buflen_c = info_c_get_string_buflen(buflen_in, len(value))
            call CFI_MPI_Info_get_string(info % MPI_VAL, key_c, buflen_c, value_c, flag_c, ierror_c)
            buflen = max(buflen_c - 1, 0)
            flag = (flag_c .ne. 0)
            if (flag .and. buflen_in > 0) then
                copy_len = min(buflen_in, len(value))
                call copy_info_c_string(value_c, value, copy_len)
            endif
            if (present(ierror)) ierror = ierror_c
            deallocate( key_c, value_c )
        end subroutine  MPI_Info_get_string_f08ts
#endif

        subroutine MPI_Info_get_f08(info, key, valuelen, value, flag, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: C_MPI_Info_get_string
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key
            integer, intent(in) :: valuelen
            character(len=*), intent(out) :: value
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: buflen_c, flag_c, ierror_c
            integer :: copy_len, value_c_len
            character(kind=c_char), dimension(:), allocatable :: key_c, value_c
            call make_info_c_string(key, key_c)
            copy_len = min(max(valuelen, 0), len(value))
            if (copy_len <= 0) then
                buflen_c = 0
            else
                buflen_c = copy_len + 1
            endif
            value_c_len = max(1, buflen_c)
            allocate(value_c(value_c_len))
            value_c = c_null_char
            call C_MPI_Info_get_string(info % MPI_VAL, key_c, buflen_c, value_c, flag_c, ierror_c)
            flag = (flag_c .ne. 0)
            if (flag .and. copy_len > 0) call copy_info_c_string(value_c, value, copy_len)
            if (present(ierror)) ierror = ierror_c
            deallocate(key_c, value_c)
        end subroutine MPI_Info_get_f08

#ifdef HAVE_CFI
        subroutine MPI_Info_get_f08ts(info, key, valuelen, value, flag, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: CFI_MPI_Info_get_string
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key
            integer, intent(in) :: valuelen
            character(len=*), intent(out) :: value
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: buflen_c, flag_c, ierror_c
            integer :: copy_len, value_c_len
            character(kind=c_char), dimension(:), allocatable :: key_c, value_c
            call make_info_c_string(key, key_c)
            copy_len = min(max(valuelen, 0), len(value))
            if (copy_len <= 0) then
                buflen_c = 0
            else
                buflen_c = copy_len + 1
            endif
            value_c_len = max(1, buflen_c)
            allocate(value_c(value_c_len))
            value_c = c_null_char
            call CFI_MPI_Info_get_string(info % MPI_VAL, key_c, buflen_c, value_c, flag_c, ierror_c)
            flag = (flag_c .ne. 0)
            if (flag .and. copy_len > 0) call copy_info_c_string(value_c, value, copy_len)
            if (present(ierror)) ierror = ierror_c
            deallocate( key_c, value_c )
        end subroutine MPI_Info_get_f08ts
#endif

        subroutine MPI_Info_get_valuelen_f08(info, key, valuelen, flag, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: C_MPI_Info_get_valuelen
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key
            integer, intent(out) :: valuelen
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: valuelen_c, flag_c, ierror_c
            character(kind=c_char), dimension(:), allocatable :: key_c
            call make_info_c_string(key, key_c)
            call C_MPI_Info_get_valuelen(info % MPI_VAL, key_c, valuelen_c, flag_c, ierror_c)
            valuelen = valuelen_c
            flag = (flag_c .ne. 0)
            if (present(ierror)) ierror = ierror_c
            deallocate( key_c )
        end subroutine MPI_Info_get_valuelen_f08

#ifdef HAVE_CFI
        subroutine MPI_Info_get_valuelen_f08ts(info, key, valuelen, flag, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: CFI_MPI_Info_get_valuelen
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key
            integer, intent(out) :: valuelen
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: valuelen_c, flag_c, ierror_c
            character(kind=c_char), dimension(:), allocatable :: key_c
            call make_info_c_string(key, key_c)
            call CFI_MPI_Info_get_valuelen(info % MPI_VAL, key_c, valuelen_c, flag_c, ierror_c)
            valuelen = valuelen_c
            flag = (flag_c .ne. 0)
            if (present(ierror)) ierror = ierror_c
            deallocate( key_c )
        end subroutine MPI_Info_get_valuelen_f08ts
#endif

        subroutine MPI_Info_set_f08(info, key, value, ierror)
            use iso_c_binding, only: c_int, c_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: C_MPI_Info_set
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key, value
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            character(kind=c_char), dimension(:), allocatable :: key_c, value_c
            call make_info_c_string(key, key_c)
            call make_info_c_string(value, value_c)
            call C_MPI_Info_set(info % MPI_VAL, key_c, value_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
            deallocate(key_c, value_c)
        end subroutine  MPI_Info_set_f08

#ifdef HAVE_CFI
        subroutine MPI_Info_set_f08ts(info, key, value, ierror)
            use iso_c_binding, only: c_int, c_char
            use mpi_handle_types, only: MPI_Info
            use mpi_info_c, only: CFI_MPI_Info_set
            type(MPI_Info), intent(in) :: info
            character(len=*), intent(in) :: key, value
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            character(kind=c_char), dimension(:), allocatable :: key_c, value_c
            call make_info_c_string(key, key_c)
            call make_info_c_string(value, value_c)
            call CFI_MPI_Info_set(info % MPI_VAL, key_c, value_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
            deallocate( key_c, value_c )
        end subroutine  MPI_Info_set_f08ts
#endif

end module mpi_info_f
