module mpi_comm_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_COMM_WORLD(comm_f) bind(C)
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_f
        end subroutine C_MPI_COMM_WORLD
    end interface

    interface
        subroutine C_MPI_COMM_SELF(comm_f) bind(C)
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_f
        end subroutine C_MPI_COMM_SELF
    end interface

    interface
        subroutine C_MPI_COMM_NULL(comm_f) bind(C)
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_f
        end subroutine C_MPI_COMM_NULL
    end interface

    ! STANDARD STUFF

    interface
        subroutine C_MPI_Comm_rank(comm_c, rank_c, ierror_c) bind(C)
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, rank_c, ierror_c
        end subroutine C_MPI_Comm_rank
    end interface

    interface
        subroutine C_MPI_Comm_size(comm_c, size_c, ierror_c) bind(C)
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, size_c, ierror_c
        end subroutine C_MPI_Comm_size
    end interface

    interface
        subroutine C_MPI_Comm_compare(comm1_c, comm2_c, result_c, ierror_c) bind(C)
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm1_c, comm2_c, result_c, ierror_c
        end subroutine C_MPI_Comm_compare
    end interface

    interface
        subroutine C_MPI_Comm_dup(comm_c, newcomm_c, ierror_c) bind(C)
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, newcomm_c, ierror_c
        end subroutine C_MPI_Comm_dup
    end interface

    interface
        subroutine C_MPI_Comm_dup_with_info(comm_c, info_c, newcomm_c, ierror_c) bind(C)
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, info_c, newcomm_c, ierror_c
        end subroutine C_MPI_Comm_dup_with_info
    end interface

    interface
        subroutine C_MPI_Comm_idup(comm_c, newcomm_c, request_c, ierror_c) bind(C)
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, newcomm_c, request_c, ierror_c
        end subroutine C_MPI_Comm_idup
    end interface

    interface
        subroutine C_MPI_Comm_idup_with_info(comm_c, info_c, newcomm_c, request_c, ierror_c) bind(C)
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, info_c, newcomm_c, request_c, ierror_c
        end subroutine C_MPI_Comm_idup_with_info
    end interface

end module mpi_comm_c

