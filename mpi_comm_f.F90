module mpi_comm_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Comm_rank
        module procedure MPI_Comm_rank_f08
    end interface MPI_Comm_rank

    interface MPI_Comm_size
        module procedure MPI_Comm_size_f08
    end interface MPI_Comm_size

    contains

        subroutine MPI_Comm_rank_f08(comm, rank, ierror) 
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_rank
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: rank
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, ierror_c
            call C_MPI_Comm_rank(comm % MPI_VAL, rank_c, ierror_c)
            rank = rank_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_rank_f08

        subroutine MPI_Comm_size_f08(comm, size, ierror) 
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_size
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: size_c, ierror_c
            call C_MPI_Comm_size(comm % MPI_VAL, size_c, ierror_c)
            size = size_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_size_f08

end module mpi_comm_f
