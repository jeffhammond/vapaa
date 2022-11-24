module mpi_file_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_FILE_nULL(file_f) bind(C,name="C_MPI_FILE_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: file_f
        end subroutine C_MPI_FILE_NULL
    end interface

    ! STANDARD STUFF

end module mpi_file_c
