module mpi_core_c

    interface
        subroutine C_MPI_Init(ierror_c) bind(C,name="C_MPI_Init")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: ierror_c
        end subroutine C_MPI_Init
    end interface

    interface
        subroutine C_MPI_Finalize(ierror_c) bind(C,name="C_MPI_Finalize")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: ierror_c
        end subroutine C_MPI_Finalize
    end interface

end module mpi_core_c
