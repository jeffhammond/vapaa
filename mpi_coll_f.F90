module mpi_coll_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Barrier
        module procedure MPI_Barrier_f08
    end interface MPI_Barrier

    contains

        subroutine MPI_Barrier_f08(comm, ierror) 
            use mpi_handle_types, only: MPI_Comm
            use mpi_coll_c, only: C_MPI_Barrier
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: comm_c, ierror_c
            comm_c = comm % MPI_VAL
            call C_MPI_Barrier(comm_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Barrier_f08

end module mpi_coll_f
