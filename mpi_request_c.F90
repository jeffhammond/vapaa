module mpi_request_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_REQUEST_NULL(request_f) bind(C,name="C_MPI_REQUEST_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: request_f
        end subroutine C_MPI_REQUEST_NULL
    end interface

    ! STANDARD STUFF

end module mpi_request_c
