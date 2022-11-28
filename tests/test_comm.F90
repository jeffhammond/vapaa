program test_comm
    use mpi_f08
    implicit none
    type(MPI_Comm) :: w = MPI_COMM_WORLD
    type(MPI_Comm) :: dw(4), cart
    integer :: ierror
    integer :: me, np
    integer :: i,res
    type(MPI_Request) :: r

    call MPI_Init(ierror)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)
    print*,'I am ',me,' of ',np,' of WORLD'

    call MPI_Comm_dup(MPI_COMM_WORLD,dw(1))

    call MPI_Comm_idup(MPI_COMM_WORLD,dw(2),r)
    call MPI_Wait(r,MPI_STATUS_IGNORE)

    call MPI_Comm_dup_with_info(MPI_COMM_WORLD,MPI_INFO_NULL,dw(2))

#if MPI_VERSION >= 4
    call MPI_Comm_idup_with_info(MPI_COMM_WORLD,MPI_INFO_NULL,dw(2),r)
    call MPI_Wait(r,MPI_STATUS_IGNORE)
#endif

    call MPI_Comm_compare(w,dw(1),res)

    !if (np.eq.3) call MPI_Abort(MPI_COMM_WORLD,3)

    do i=1,size(dw)
        call MPI_Comm_free(dw(i))
    end do

    block
        integer :: dims(2)
        call MPI_Dims_create(np, size(shape(dims)), dims)
        call MPI_Cart_create(MPI_COMM_WORLD, size(shape(dims)), dims, [.false.,.false.], .true., cart)
        call MPI_Barrier(cart)
        call MPI_Comm_free(cart)
    end block

    call MPI_Finalize(ierror)

end program test_comm
