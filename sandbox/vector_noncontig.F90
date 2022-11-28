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

    if (me.eq.0) then
        print*,'MPI_SUBARRAYS_SUPPORTED=',MPI_SUBARRAYS_SUPPORTED
        print*,'MPI_ASYNC_PROTECTS_NONBLOCKING=',MPI_ASYNC_PROTECTS_NONBLOCKING
    endif

    A = [i, i=1,100]
    B = 0

    call MPI_Type_vector(25,1,2,MPI_INTEGER,v)
    call MPI_Type_commit(v)

    if (me.eq.0) print*,'A=',A

    call MPI_Isend( A(1:100:1), 1, v, 1, 99, MPI_COMM_WORLD, r(1))
    call MPI_Irecv( B, 25, MPI_INTEGER, 0, 99, MPI_COMM_WORLD, r(2))
    call MPI_Waitall(2, r, MPI_STATUSES_IGNORE)

    if (me.eq.0) print*,'B=',B

    B = 0

    call MPI_Isend( A(1:100:2), 1, v, 1, 99, MPI_COMM_WORLD, r(1))
    call MPI_Irecv( B, 25, MPI_INTEGER, 0, 99, MPI_COMM_WORLD, r(2))
    call MPI_Waitall(2, r, MPI_STATUSES_IGNORE)

    if (me.eq.0) print*,'B=',B

    call MPI_Type_free(v)

    call MPI_Finalize()

end program main
