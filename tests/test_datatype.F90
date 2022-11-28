program main
    use mpi_f08
    implicit none
    integer :: me, np
    type(MPI_Datatype) :: v

    call MPI_Init()
    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    if (me.eq.0) then
        print*,'MPI_SUBARRAYS_SUPPORTED=',MPI_SUBARRAYS_SUPPORTED
        print*,'MPI_ASYNC_PROTECTS_NONBLOCKING=',MPI_ASYNC_PROTECTS_NONBLOCKING
    endif

    call MPI_Type_contiguous(25,MPI_INTEGER,v)
    call MPI_Type_commit(v)
    call MPI_Type_free(v)

    call MPI_Type_vector(25,1,2,MPI_INTEGER,v)
    call MPI_Type_commit(v)
    call MPI_Type_free(v)

    call MPI_Type_create_subarray(2,[10,10],[5,5],[0,0],MPI_ORDER_FORTRAN,MPI_INTEGER,v)
    call MPI_Type_commit(v)
    call MPI_Type_free(v)

    call MPI_Type_create_subarray(2,[10,10],[5,5],[0,0],MPI_ORDER_C,MPI_INTEGER,v)
    call MPI_Type_commit(v)
    call MPI_Type_free(v)

    call MPI_Finalize()

end program main
