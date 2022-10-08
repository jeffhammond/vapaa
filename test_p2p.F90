program test_reductions
    use mpi_f08
    implicit none
    integer :: ierror
    integer :: i, me, np
    integer :: b
    integer, allocatable :: x(:)

    call MPI_Init(ierror)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    if (0.ne.MOD(np,2)) then
        print*,'Run with an even number of processes'
        call MPI_Abort(MPI_COMM_WORLD,np)
    endif
    

    call MPI_Barrier(MPI_COMM_WORLD)
    do i=0,np
        if (me.eq.i) print*,'I am ',me,' of ',np,' of WORLD'
        call MPI_Barrier(MPI_COMM_WORLD)
    enddo

    do i=0,20
        b = 2**i
        if (me.eq.0) print*,'b=',b
        allocate( x(b) )
        if (0.eq.MOD(me,2)) then
            x = me
            call MPI_Send(x,b,MPI_INTEGER,me+1,b,MPI_COMM_WORLD)
        else
            x = -1
            call MPI_Recv(x,b,MPI_INTEGER,me-1,b,MPI_COMM_WORLD,MPI_STATUS_IGNORE)
            if (any(x.ne.(me-1))) then
                print*,'an error has occurred'
                print*,x
            endif
        endif
        deallocate( x )
    enddo

    call MPI_Finalize(ierror)

end program test_reductions
