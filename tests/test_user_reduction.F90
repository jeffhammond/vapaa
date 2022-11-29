!module m
!    contains
         subroutine f( cin, cout, count, datatype )
         use iso_c_binding, only: c_ptr, c_f_pointer
         use mpi_f08
         type(c_ptr), value :: cin, cout
         integer :: count
         type(MPI_Datatype) :: datatype
         integer, pointer :: cin_r(:), cout_r(:)
         !print*,'HERE', datatype % MPI_VAL, datatype == MPI_INTEGER
         !if (datatype .ne. MPI_INTEGER) then
         !   print *, 'Invalid datatype (',datatype,') passed to user_op()'
         !   return
         !endif
         call c_f_pointer(cin, cin_r, [count])
         call c_f_pointer(cout, cout_r, [count])
         cout_r = cin_r + cout_r
         end
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
!end module m

program main
    use mpi_f08
!    use m
    implicit none
    external :: f
    integer :: ierror
    integer :: i, me, np, ref
    integer, parameter :: b = 10
    integer :: ix(b), iy(b)
    type(MPI_Op) :: op

    call MPI_Init(ierror)

    call MPI_Op_create(f,.true.,op,ierror)

    !print*,MPI_INTEGER % MPI_VAL!,MPI_Type_f2c(MPI_INTEGER)

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
    if (any(iy.ne.ref)) then
        print*,'an error has occurred in MPI_SUM'
        print*,iy
    endif

    if (me.eq.0) print*,b,' integers'
    ix = me
    iy = -1
    call MPI_Allreduce(ix, iy, b, MPI_INTEGER, op, MPI_COMM_WORLD)
    if (any(iy.ne.ref)) then
        print*,'an error has occurred in op'
        print*,iy
    endif

    call MPI_Op_free(op,ierror)

    if(me.eq.0) print*,'EVERYTHING IS OKAY'

    call MPI_Finalize(ierror)

end program main
