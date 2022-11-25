program test_core
    use mpi_f08
    implicit none
    integer :: requested = MPI_THREAD_MULTIPLE
    integer :: provided
    integer :: me

    call MPI_Init_thread(requested,provided)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)

    if (me.eq.0) then
        print*,'Init_thread:',requested,provided
    endif

    call MPI_Query_thread(provided)

    if (me.eq.0) then
        print*,'Query:',provided
    endif

    call MPI_Finalize()

end program test_core
