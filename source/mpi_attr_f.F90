! SPDX-License-Identifier: MIT

#include "vapaa_constants.h"

module mpi_attr_f
    implicit none

    interface MPI_Type_get_name
#if HAVE_CFI
        module procedure MPI_Type_get_name_f08ts
#else
        module procedure MPI_Type_get_name_f08
#endif
    end interface MPI_Type_get_name

    interface MPI_Type_set_name
#if HAVE_CFI
        module procedure MPI_Type_set_name_f08ts
#else
        module procedure MPI_Type_set_name_f08
#endif
    end interface MPI_Type_set_name

    interface MPI_Attr_delete
        module procedure MPI_Attr_delete_f08
    end interface MPI_Attr_delete

    interface MPI_Attr_get
        module procedure MPI_Attr_get_f08
    end interface MPI_Attr_get

    interface MPI_Attr_put
        module procedure MPI_Attr_put_f08
    end interface MPI_Attr_put

    interface MPI_Keyval_free
        module procedure MPI_Keyval_free_f08
    end interface MPI_Keyval_free

    contains

        subroutine MPI_Attr_delete_f08(comm, keyval, ierror)
            use iso_c_binding, only: c_int
            use mpi_attr_c, only: VAPAA_MPI_Attr_delete
            use mpi_handle_types, only: MPI_Comm
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: keyval
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Attr_delete(comm % MPI_VAL, int(keyval,c_int), ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Attr_delete_f08

        subroutine MPI_Attr_get_f08(comm, keyval, attribute_val, flag, ierror)
            use iso_c_binding, only: c_int
            use mpi_attr_c, only: VAPAA_MPI_Attr_get
            use mpi_handle_types, only: MPI_Comm
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: keyval
            integer, intent(out) :: attribute_val
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(c_int) :: attribute_val_c, flag_c, ierror_c
            call VAPAA_MPI_Attr_get(comm % MPI_VAL, int(keyval,c_int), attribute_val_c, flag_c, ierror_c)
            attribute_val = attribute_val_c
            flag = flag_c /= 0
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Attr_get_f08

        subroutine MPI_Attr_put_f08(comm, keyval, attribute_val, ierror)
            use iso_c_binding, only: c_int
            use mpi_attr_c, only: VAPAA_MPI_Attr_put
            use mpi_handle_types, only: MPI_Comm
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: keyval, attribute_val
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Attr_put(comm % MPI_VAL, int(keyval,c_int), int(attribute_val,c_int), ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Attr_put_f08

        subroutine MPI_Keyval_free_f08(keyval, ierror)
            use iso_c_binding, only: c_int
            use mpi_attr_c, only: VAPAA_MPI_Keyval_free
            integer, intent(inout) :: keyval
            integer, optional, intent(out) :: ierror
            integer(c_int) :: keyval_c, ierror_c
            keyval_c = keyval
            call VAPAA_MPI_Keyval_free(keyval_c, ierror_c)
            keyval = keyval_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Keyval_free_f08

        subroutine MPI_Type_get_name_f08(datatype, name, resultlen, ierror)
            use iso_c_binding, only: c_int
            use mpi_global_constants, only: MPI_Datatype
            use mpi_attr_c, only: C_MPI_Type_get_name
            type(MPI_Datatype), intent(in) :: datatype
            character(len=*), intent(out) :: name
            integer, intent(out) :: resultlen
            integer, optional, intent(out) :: ierror
            integer(c_int) :: resultlen_c, ierror_c
            call C_MPI_Type_get_name(datatype % MPI_VAL, name, resultlen_c, ierror_c)
            resultlen = resultlen_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_get_name_f08

#ifdef HAVE_CFI
        subroutine MPI_Type_get_name_f08ts(datatype, name, resultlen, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_global_constants, only: MPI_Datatype
            use mpi_attr_c, only: CFI_MPI_Type_get_name
            type(MPI_Datatype), intent(in) :: datatype
            character(len=*), intent(out) :: name
            integer, intent(out) :: resultlen
            integer, optional, intent(out) :: ierror
            integer(c_int) :: resultlen_c, ierror_c
            integer :: i, ls
            character(kind=c_char), dimension(:), allocatable :: name_c
            ls = len(name)
            allocate( name_c(ls+1) )
            name     = ' '
            name_c   = c_null_char
            call CFI_MPI_Type_get_name(datatype % MPI_VAL, name_c, resultlen_c, ierror_c)
            do i=1, ls
                if (name_c(i) == c_null_char) exit
                name(i:i) = name_c(i)
            end do
            resultlen = resultlen_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_get_name_f08ts
#endif

        subroutine MPI_Type_set_name_f08(datatype, name, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_global_constants, only: MPI_Datatype
            use mpi_attr_c, only: C_MPI_Type_set_name
            type(MPI_Datatype), intent(in) :: datatype
            character(len=*), intent(in) :: name
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_Type_set_name(datatype % MPI_VAL, name, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_set_name_f08

#ifdef HAVE_CFI
        subroutine MPI_Type_set_name_f08ts(datatype, name, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_global_constants, only: MPI_Datatype
            use mpi_attr_c, only: CFI_MPI_Type_set_name
            type(MPI_Datatype), intent(in) :: datatype
            character(len=*), intent(in) :: name
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            integer :: i, ls
            character(kind=c_char), dimension(:), allocatable :: name_c
            ls = len(name)
            allocate( name_c(ls+1) )
            name_c   = c_null_char
            do i=1, ls
                name_c(i) = name(i:i)
            end do
            call CFI_MPI_Type_set_name(datatype % MPI_VAL, name_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_set_name_f08ts
#endif

end module mpi_attr_f
