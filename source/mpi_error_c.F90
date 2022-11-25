module mpi_error_c

    ! NOT STANDARD STUFF


    ! STANDARD STUFF

    interface
        subroutine C_MPI_Error_string(errorcode_c, string_c, resultlen_c, ierror_c) &
                   bind(C,name="C_MPI_Error_string")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int) :: errorcode_c, resultlen_c, ierror_c
            character(kind=c_char), dimension(:) :: string_c
        end subroutine C_MPI_Error_string
    end interface

    interface
        subroutine C_MPI_Error_class(errorcode_c, errorclass_c, ierror_c) &
                   bind(C,name="C_MPI_Error_class")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: errorcode_c, errorclass_c, ierror_c
        end subroutine C_MPI_Error_class
    end interface

end module mpi_error_c
