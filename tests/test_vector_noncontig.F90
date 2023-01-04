program main
    use mpi_f08
    implicit none
    integer :: me, np, i
    integer :: A(100), B(25)
    type(MPI_Datatype) :: v
    type(MPI_Request) :: r(2)

    call MPI_Init()
    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    !if (me.eq.0) then
    !    print*,'MPI_SUBARRAYS_SUPPORTED=',MPI_SUBARRAYS_SUPPORTED
    !    print*,'MPI_ASYNC_PROTECTS_NONBLOCKING=',MPI_ASYNC_PROTECTS_NONBLOCKING
    !endif

    A = [(i, i = 1,100)]
    !if (me.eq.0) print*,'A=',A

    call MPI_Type_vector(25,1,4,MPI_INTEGER,v)
    call MPI_Type_commit(v)

    B = 0
    call MPI_Isend( A, 1, v, me, 99, MPI_COMM_WORLD, r(1))
    call MPI_Irecv( B, 25, MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2))
    call MPI_Waitall(2, r, MPI_STATUSES_IGNORE)
    !if (me.eq.0) print*,'B=',B
    if (any(B.ne.A(1:100:4))) then
        print*,'an error has occurred'
    endif

    B = 0
    call MPI_Isend( A(1:100:4), 25, MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(1))
    call MPI_Irecv( B, 25, MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2))
    call MPI_Waitall(2, r, MPI_STATUSES_IGNORE)
    !if (me.eq.0) print*,'B=',B
    if (any(B.ne.A(1:100:4))) then
        print*,'an error has occurred'
    endif

    call MPI_Type_free(v)

    if (me.eq.0) then
        print*,'non-contiguous vector support is okay'
    end if

    call MPI_Finalize()

end program main
