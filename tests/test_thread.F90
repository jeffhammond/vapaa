program main

    use mpi_f08

    implicit none

    integer :: requested = MPI_THREAD_MULTIPLE
    integer :: provided
    integer :: me

    call MPI_Init_thread(requested,provided)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)

    if (me.eq.0) then

        print*,'Init_thread:',requested,provided

        call MPI_Query_thread(provided)
        print*,'Query:',provided

        ! make sure all 4 thread levels are defined
        print*,'MPI_THREAD_SINGLE     = ',MPI_THREAD_SINGLE
        print*,'MPI_THREAD_FUNNELED   = ',MPI_THREAD_FUNNELED
        print*,'MPI_THREAD_SERIALIZED = ',MPI_THREAD_SERIALIZED
        print*,'MPI_THREAD_MULTIPLE   = ',MPI_THREAD_MULTIPLE

    endif

    call MPI_Finalize()
        print *, 'Test passed'

end program main
