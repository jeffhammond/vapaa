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

    interface
        subroutine C_MPI_Init_thread(required_c, provided_c, ierror_c) bind(C,name="C_MPI_Init_thread")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: required_c, provided_c, ierror_c
        end subroutine C_MPI_Init_thread
    end interface

    interface
        subroutine C_MPI_Initialized(flag_c, ierror_c) bind(C,name="C_MPI_Initialized")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: flag_c, ierror_c
        end subroutine C_MPI_Initialized
    end interface

    interface
        subroutine C_MPI_Finalized(flag_c, ierror_c) bind(C,name="C_MPI_Finalize")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: flag_c, ierror_c
        end subroutine C_MPI_Finalized
    end interface

    interface
        subroutine C_MPI_Query_thread(provided_c, ierror_c) bind(C,name="C_MPI_Query_thread")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: provided_c, ierror_c
        end subroutine C_MPI_Query_thread
    end interface

end module mpi_core_c
