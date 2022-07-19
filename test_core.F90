program test_core
    use mpi_core_f
    implicit none
    print*,'A'
    call MPI_Init
    print*,'B'
    call MPI_Finalize
    print*,'C'
end program test_core
