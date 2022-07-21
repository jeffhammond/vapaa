module mpi_status_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_STATUS_IGNORE(status_f) bind(C,name="C_MPI_STATUS_IGNORE")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: status_f
        end subroutine C_MPI_STATUS_IGNORE
    end interface

    ! STANDARD STUFF

end module mpi_status_c
