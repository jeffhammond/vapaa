module mpi_group_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_GROUP_NULL(group_f) bind(C,name="C_MPI_GROUP_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: group_f
        end subroutine C_MPI_GROUP_NULL
    end interface

    ! STANDARD STUFF

end module mpi_group_c
