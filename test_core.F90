program test_core
    use mpi_f08
    implicit none
    integer :: ierror
    integer :: me, np
    call MPI_Init(ierror)
    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)
    print*,'I am ',me,' of ',np
    call MPI_Finalize(ierror)
end program test_core
