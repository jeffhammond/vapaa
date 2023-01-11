module mpi_error_c

    interface
        subroutine C_MPI_Error_string(errorcode, string, resultlen, ierror) &
                   bind(C,name="C_MPI_Error_string")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: errorcode
            integer(kind=c_int), intent(out) :: resultlen, ierror
            character(kind=c_char), dimension(*), intent(out) :: string
        end subroutine C_MPI_Error_string
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Error_string(errorcode, string, resultlen, ierror) &
                   bind(C,name="CFI_MPI_Error_string")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: errorcode
            integer(kind=c_int), intent(out) :: resultlen, ierror
            type(*), dimension(..), intent(inout) :: string
        end subroutine CFI_MPI_Error_string
    end interface
#endif

    interface
        subroutine C_MPI_Error_class(errorcode, errorclass, ierror) &
                   bind(C,name="C_MPI_Error_class")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: errorcode
            integer(kind=c_int), intent(out) :: errorclass, ierror
        end subroutine C_MPI_Error_class
    end interface

end module mpi_error_c
