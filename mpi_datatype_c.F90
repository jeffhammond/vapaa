module mpi_datatype_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_DATATYPE_NULL(datatype_f) bind(C,name="C_MPI_DATATYPE_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: datatype_f
        end subroutine C_MPI_DATATYPE_NULL
    end interface

    ! STANDARD STUFF

end module mpi_datatype_c
