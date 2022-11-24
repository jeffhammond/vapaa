program test_collectives
    use mpi_f08
    implicit none
    integer :: ierror
    integer :: i, me, np
    integer :: b
    integer, allocatable :: x(:)

    call MPI_Init(ierror)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    call MPI_Barrier(MPI_COMM_WORLD)
    do i=0,np
        if (me.eq.i) print*,'I am ',me,' of ',np,' of WORLD'
        call MPI_Barrier(MPI_COMM_WORLD)
    enddo

    do i=0,20
        b = 2**i
        if (me.eq.0) print*,'b=',b
        allocate( x(b) )
        if (me.eq.0) then
            x = np
        else
            x = -1
        endif
        call MPI_Bcast(x, b, MPI_INTEGER, 0, MPI_COMM_WORLD)
        if (any(x.ne.np)) then
            print*,'an error has occurred'
        endif
        deallocate( x )
    enddo

    call MPI_Finalize(ierror)

end program test_collectives
