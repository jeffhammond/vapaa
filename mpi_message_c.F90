module mpi_message_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_MESSAGE_NULL(message_f) bind(C,name="C_MPI_MESSAGE_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: message_f
        end subroutine C_MPI_MESSAGE_NULL
    end interface

    ! STANDARD STUFF

end module mpi_message_c
