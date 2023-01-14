#include "vapaa_constants.h"

module mpi_attr_f
    implicit none

    interface MPI_Type_set_name
#if HAVE_CFI
        module procedure MPI_Type_set_name_f08ts
#else
        module procedure MPI_Type_set_name_f08
#endif
    end interface MPI_Type_set_name

    contains

        subroutine MPI_Type_set_name_f08(datatype, type_name, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_global_constants, only: MPI_Datatype
            use mpi_attr_c, only: C_MPI_Type_set_name
            type(MPI_Datatype), intent(in) :: datatype
            character(len=*), intent(in) :: type_name
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_Type_set_name(datatype % MPI_VAL, type_name, ierror_c)
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
