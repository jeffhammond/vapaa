program main
    use mpi_f08
    implicit none
    type(MPI_Comm) :: w = MPI_COMM_WORLD
    type(MPI_Comm) :: dw(4), cart, node
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

    call MPI_Comm_dup_with_info(MPI_COMM_WORLD,MPI_INFO_NULL,dw(3))

#if MPI_VERSION >= 4
    call MPI_Comm_idup_with_info(MPI_COMM_WORLD,MPI_INFO_NULL,dw(4),r)
    call MPI_Wait(r,MPI_STATUS_IGNORE)
#endif

    !if (np.eq.3) call MPI_Abort(MPI_COMM_WORLD,3)

    do i=1,3
        call MPI_Comm_compare(w,dw(i),res)
        !print*,'compare result(',i,')=',res
        !print*,me,': barrier ',i
        call MPI_Barrier(dw(i))
        !print*,me,': free ',i
        call MPI_Comm_free(dw(i))
    end do

    block
        integer :: dims(2) = 0
        logical :: periods(2) = .false.
        call MPI_Dims_create(np, 2, dims)
        if (me.eq.0) print*,'dims=',dims
        call MPI_Cart_create(MPI_COMM_WORLD, 2, dims, periods, .true., cart, ierror)
        call MPI_Barrier(cart)
        call MPI_Comm_free(cart)
    end block

    block
        integer :: xme, xnp
        call MPI_Comm_split_type(MPI_COMM_WORLD, MPI_COMM_TYPE_SHARED, me, MPI_INFO_NULL, node)
        call MPI_Comm_rank(node,xme)
        call MPI_Comm_size(node,xnp)
        print*,'I am ',xme,' of ',xnp,' of this node'
        call MPI_Comm_free(node)
    end block

    call MPI_Finalize(ierror)

end program main
