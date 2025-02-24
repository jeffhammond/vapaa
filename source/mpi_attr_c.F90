module mpi_attr_c

    interface
        subroutine C_MPI_Comm_get_name(datatype, name, resultlen, ierror) &
                   bind(C,name="C_MPI_Comm_get_name")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            character(kind=c_char), dimension(*), intent(out) :: name
            integer(kind=c_int), intent(out) :: resultlen
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Comm_get_name
    end interface

    interface
        subroutine C_MPI_Comm_set_name(datatype, name, ierror) &
                   bind(C,name="C_MPI_Comm_set_name")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            character(kind=c_char), dimension(*), intent(in) :: name
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Comm_set_name
    end interface

    interface
        subroutine C_MPI_Type_get_name(datatype, name, resultlen, ierror) &
                   bind(C,name="C_MPI_Type_get_name")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            character(kind=c_char), dimension(*), intent(out) :: name
            integer(kind=c_int), intent(out) :: resultlen
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Type_get_name
    end interface

    interface
        subroutine C_MPI_Type_set_name(datatype, name, ierror) &
                   bind(C,name="C_MPI_Type_set_name")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            character(kind=c_char), dimension(*), intent(in) :: name
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Type_set_name
    end interface

    interface
        subroutine C_MPI_Win_get_name(datatype, name, resultlen, ierror) &
                   bind(C,name="C_MPI_Win_get_name")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            character(kind=c_char), dimension(*), intent(out) :: name
            integer(kind=c_int), intent(out) :: resultlen
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Win_get_name
    end interface

    interface
        subroutine C_MPI_Win_set_name(datatype, name, ierror) &
                   bind(C,name="C_MPI_Win_set_name")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            character(kind=c_char), dimension(*), intent(in) :: name
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Win_set_name
    end interface

end module mpi_attr_c
