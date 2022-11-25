program test_handles
    use mpi_f08
    implicit none
    type(MPI_Comm) :: world = MPI_COMM_WORLD
    integer :: ierror
    call MPI_Init(ierror)
    call MPI_Barrier(world)
    call MPI_Finalize(ierror)
end program test_handles
