program main
    use mpi_f08
    implicit none
    integer :: me, np, i
    integer :: A(20,20), B(10,10)
    type(MPI_Datatype) :: v

    call MPI_Init()
    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    if (me.eq.0) then
        print*,'MPI_SUBARRAYS_SUPPORTED=',MPI_SUBARRAYS_SUPPORTED
        print*,'MPI_ASYNC_PROTECTS_NONBLOCKING=',MPI_ASYNC_PROTECTS_NONBLOCKING
    endif

    A = reshape([(i, i = 1,400)],[20,20])
    if (me.eq.0) print*,'A=',A

    B = 0
    call MPI_Bcast( A(2:20:2,2:20:2), 100, MPI_INTEGER, 0, MPI_COMM_WORLD )

    if (me.eq.0) print*,'B=',B

    call MPI_Finalize()

end program main
