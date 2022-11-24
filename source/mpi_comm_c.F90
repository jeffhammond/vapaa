module mpi_comm_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_COMM_WORLD(comm_f) bind(C,name="C_MPI_COMM_WORLD")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_f
        end subroutine C_MPI_COMM_WORLD
    end interface

    interface
        subroutine C_MPI_COMM_SELF(comm_f) bind(C,name="C_MPI_COMM_SELF")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_f
        end subroutine C_MPI_COMM_SELF
    end interface

    interface
        subroutine C_MPI_COMM_NULL(comm_f) bind(C,name="C_MPI_COMM_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_f
        end subroutine C_MPI_COMM_NULL
    end interface

    ! STANDARD STUFF

    interface
        subroutine C_MPI_Comm_rank(comm_c, rank_c, ierror_c) bind(C,name="C_MPI_Comm_rank")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, rank_c, ierror_c
        end subroutine C_MPI_Comm_rank
    end interface

    interface
        subroutine C_MPI_Comm_size(comm_c, size_c, ierror_c) bind(C,name="C_MPI_Comm_size")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, size_c, ierror_c
        end subroutine C_MPI_Comm_size
    end interface

end module mpi_comm_c

