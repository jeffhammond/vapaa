program test_reductions
    use mpi_f08
    implicit none
    integer :: ierror
    integer :: i, me, np
    integer :: b
    integer, allocatable :: ix(:), iy(:)
    double precision, allocatable :: dx(:), dy(:)

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
        if (me.eq.0) print*,b,' integers'
        allocate( ix(b) )
        allocate( iy(b) )
        ix =  1
        iy = -1
        call MPI_Allreduce(ix, iy, b, MPI_INTEGER, MPI_SUM,  MPI_COMM_WORLD)
        if (any(iy.ne.np)) then
            print*,'an error has occurred'
            print*,iy
        endif
        deallocate( ix )
        deallocate( iy )
    enddo

    do i=0,20
        b = 2**i
        if (me.eq.0) print*,b,' doubles'
        allocate( dx(b) )
        allocate( dy(b) )
        dx =  1
        dy = -1
        call MPI_Allreduce(dx, dy, b, MPI_DOUBLE_PRECISION, MPI_SUM,  MPI_COMM_WORLD)
        if (any(abs(dy-np).gt.tiny(0.0d0))) then
            print*,'an error has occurred'
            print*,dy
        endif
        deallocate( dx )
        deallocate( dy )
    enddo

    if(me.eq.0) print*,'EVERYTHING IS OKAY'

    call MPI_Finalize(ierror)

end program test_reductions
