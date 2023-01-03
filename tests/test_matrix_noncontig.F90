program main
    use mpi_f08
    implicit none
    integer :: me, np, i
    type(MPI_Datatype) :: v
#if 0
    integer, allocatable :: A(:,:)
    allocate( A(30,20) )
#else
    integer :: A(30,32)
#endif

    call MPI_Init()
    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    if (me.eq.0) then
        print*,'MPI_SUBARRAYS_SUPPORTED=',MPI_SUBARRAYS_SUPPORTED
        print*,'MPI_ASYNC_PROTECTS_NONBLOCKING=',MPI_ASYNC_PROTECTS_NONBLOCKING
    endif

    A = reshape([(i, i = 1,size(A,1)*size(A,2))],[size(A,1),size(A,2)])
    !if (me.eq.0) print*,'A=[',A,']'
    !if (me.eq.0) print*,'shape(A)=',shape(A)

    call MPI_Bcast( A(1:30:1,1:20:3), 1, MPI_INTEGER, 0, MPI_COMM_WORLD )
    if (me.eq.0) print*,'A=',A

    call MPI_Finalize()

end program main
