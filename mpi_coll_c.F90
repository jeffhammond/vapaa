module mpi_coll_c

    ! STANDARD STUFF

    interface
        subroutine C_MPI_Barrier(comm_c, ierror_c) bind(C,name="C_MPI_Barrier")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, ierror_c
        end subroutine C_MPI_Barrier
    end interface

end module mpi_coll_c

