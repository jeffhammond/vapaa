module m
    contains
        subroutine f(invec, inoutvec, len, type)
            use, intrinsic :: iso_c_binding, only : c_ptr, c_f_pointer
            use mpi_f08
            type(c_ptr), value :: invec, inoutvec
            integer :: len, i
            type(MPI_Datatype) :: type
            integer, pointer :: invec_r(:), inoutvec_r(:)
            print*,'HERE', type % MPI_VAL, type == MPI_INTEGER
            call c_f_pointer(invec, invec_r, [len])
            call c_f_pointer(inoutvec, inoutvec_r, [len])
            print*,invec_r,inoutvec_r
            inoutvec_r = invec_r + inoutvec_r
        end subroutine f
#if 0
        subroutine g(invec, inoutvec, len, type)
            use, intrinsic :: iso_c_binding, only : c_ptr, c_f_pointer
            use mpi_f08
            integer, dimension(*) :: invec, inoutvec
            integer :: len, i
            type(MPI_Datatype) :: type
            print*,'G'
            do i = 1, len
                inoutvec(i) = invec(i) + inoutvec(i)
            end do
        end subroutine g
#endif
end module m

program main
    use mpi_f08
    use m
    implicit none
    integer :: ierror
    integer :: i, me, np, ref
    integer, parameter :: b = 10
    integer :: ix(b), iy(b)
    type(MPI_Op) :: op

    call MPI_Init(ierror)

    call MPI_Op_create(f,.true.,op)

    print*,MPI_INTEGER % MPI_VAL!,MPI_Type_f2c(MPI_INTEGER)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    call MPI_Barrier(MPI_COMM_WORLD)
    do i=0,np
        if (me.eq.i) print*,'I am ',me,' of ',np,' of WORLD'
        call MPI_Barrier(MPI_COMM_WORLD)
    enddo

    ref = (np * (np-1)) / 2

    if (me.eq.0) print*,b,' integers'
    ix = me
    iy = -1
    call MPI_Allreduce(ix, iy, b, MPI_INTEGER, MPI_SUM, MPI_COMM_WORLD)
    if (any(iy.ne.np)) then
        print*,'an error has occurred'
        print*,iy
    endif

    if (me.eq.0) print*,b,' integers'
    ix = me
    iy = -1
    call MPI_Allreduce(ix, iy, b, MPI_INTEGER, op,  MPI_COMM_WORLD)
    if (any(iy.ne.np)) then
        print*,'an error has occurred'
        print*,iy
    endif

    call MPI_Op_free(op)

    if(me.eq.0) print*,'EVERYTHING IS OKAY'

    call MPI_Finalize(ierror)

end program main
