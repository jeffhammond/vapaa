#include "vapaa_constants.h"

module mpi_attr_f
    implicit none

    interface MPI_Comm_get_name
        module procedure MPI_Comm_get_name_f08
    end interface MPI_Comm_get_name

    interface MPI_Comm_set_name
        module procedure MPI_Comm_set_name_f08
    end interface MPI_Comm_set_name

    interface MPI_Type_get_name
        module procedure MPI_Type_get_name_f08
    end interface MPI_Type_get_name

    interface MPI_Type_set_name
        module procedure MPI_Type_set_name_f08
    end interface MPI_Type_set_name

    interface MPI_Win_get_name
        module procedure MPI_Win_get_name_f08
    end interface MPI_Win_get_name

    interface MPI_Win_set_name
        module procedure MPI_Win_set_name_f08
    end interface MPI_Win_set_name

    contains

        subroutine MPI_Comm_get_name_f08(comm, name, resultlen, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Comm
            use mpi_global_constants, only: MPI_MAX_OBJECT_NAME
            use mpi_attr_c, only: C_MPI_Comm_get_name
            type(MPI_Comm), intent(in) :: comm
            character(len=MPI_MAX_OBJECT_NAME), intent(out) :: name
            integer, intent(out) :: resultlen
            integer, optional, intent(out) :: ierror
            integer(c_int) :: resultlen_c, ierror_c
            call C_MPI_Comm_get_name(comm % MPI_VAL, name, resultlen_c, ierror_c)
            resultlen = resultlen_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_get_name_f08

        subroutine MPI_Comm_set_name_f08(comm, name, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Comm
            use mpi_global_constants, only: MPI_MAX_OBJECT_NAME
            use mpi_attr_c, only: C_MPI_Comm_set_name
            type(MPI_Comm), intent(in) :: comm
            character(len=MPI_MAX_OBJECT_NAME), intent(in) :: name
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_Comm_set_name(comm % MPI_VAL, name, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_set_name_f08

        subroutine MPI_Type_get_name_f08(datatype, name, resultlen, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Datatype
            use mpi_global_constants, only: MPI_MAX_OBJECT_NAME
            use mpi_attr_c, only: C_MPI_Type_get_name
            type(MPI_Datatype), intent(in) :: datatype
            character(len=MPI_MAX_OBJECT_NAME), intent(out) :: name
            integer, intent(out) :: resultlen
            integer, optional, intent(out) :: ierror
            integer(c_int) :: resultlen_c, ierror_c
            call C_MPI_Type_get_name(datatype % MPI_VAL, name, resultlen_c, ierror_c)
            resultlen = resultlen_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_get_name_f08

        subroutine MPI_Type_set_name_f08(datatype, name, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Datatype
            use mpi_global_constants, only: MPI_MAX_OBJECT_NAME
            use mpi_attr_c, only: C_MPI_Type_set_name
            type(MPI_Datatype), intent(in) :: datatype
            character(len=MPI_MAX_OBJECT_NAME), intent(in) :: name
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_Type_set_name(datatype % MPI_VAL, name, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_set_name_f08

        subroutine MPI_Win_get_name_f08(win, name, resultlen, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Win
            use mpi_global_constants, only: MPI_MAX_OBJECT_NAME
            use mpi_attr_c, only: C_MPI_Win_get_name
            type(MPI_Win), intent(in) :: win
            character(len=MPI_MAX_OBJECT_NAME), intent(out) :: name
            integer, intent(out) :: resultlen
            integer, optional, intent(out) :: ierror
            integer(c_int) :: resultlen_c, ierror_c
            call C_MPI_Win_get_name(win % MPI_VAL, name, resultlen_c, ierror_c)
            resultlen = resultlen_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_get_name_f08

        subroutine MPI_Win_set_name_f08(win, name, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Win
            use mpi_global_constants, only: MPI_MAX_OBJECT_NAME
            use mpi_attr_c, only: C_MPI_Win_set_name
            type(MPI_Win), intent(in) :: win
            character(len=MPI_MAX_OBJECT_NAME), intent(in) :: name
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_Win_set_name(win % MPI_VAL, name, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_set_name_f08

end module mpi_attr_f
