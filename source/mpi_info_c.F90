module mpi_info_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_INFO_NULL(info_f) bind(C,name="C_MPI_INFO_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: info_f
        end subroutine C_MPI_INFO_NULL
    end interface

    ! STANDARD STUFF

end module mpi_info_c
