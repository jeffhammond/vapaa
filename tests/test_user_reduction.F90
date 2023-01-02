module m
    contains
         subroutine f( cin, cout, count, datatype )
         use iso_c_binding, only: c_ptr, c_f_pointer
         use mpi_f08
         type(c_ptr), value :: cin, cout
         integer :: count
         type(MPI_Datatype) :: datatype
         integer, pointer :: cin_r(:), cout_r(:)
         !print*,'My Reduce Op:', datatype % MPI_VAL, 'INTEGER?',datatype == MPI_INTEGER
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
end module m

program main
    use mpi_f08
    use m
    implicit none
#if 0
    external :: f
#endif
    integer :: ierror
    integer :: i, me, np, ref
    integer, parameter :: b = 10
    integer :: ix(b), iy(b)
    type(MPI_Op) :: op
    type(MPI_Datatype) :: dt

    call MPI_Init(ierror)

    call MPI_Op_create(f,.true.,op,ierror)
    call MPI_Type_contiguous(1,MPI_INTEGER,dt,ierror)
    call MPI_Type_commit(dt,ierror)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    !if (me.eq.0) then
    !    print*,'MPI_INTEGER=',MPI_INTEGER % MPI_VAL!,MPI_Type_f2c(MPI_INTEGER)
    !    print*,'My INTEGER =',dt % MPI_VAL!,MPI_Type_f2c(MPI_INTEGER)
    !endif

    call MPI_Barrier(MPI_COMM_WORLD)

    ref = (np * (np-1)) / 2

    ix = me
    iy = -1
    call MPI_Allreduce(ix, iy, b, MPI_INTEGER, MPI_SUM, MPI_COMM_WORLD)
    if (any(iy.ne.ref)) then
        print*,'an error has occurred in MPI_INTEGER+MPI_SUM'
        print*,iy
    endif
    call MPI_Barrier(MPI_COMM_WORLD)

    ix = me
    iy = -1
    call MPI_Allreduce(ix, iy, b, MPI_INTEGER, op, MPI_COMM_WORLD, ierror)
    if ((ierror.ne.MPI_ERR_OP)) then
        print*,'MPI_INTEGER+op did not fail as expected'
        print*,'ierror=',ierror
    endif
    call MPI_Barrier(MPI_COMM_WORLD)

    ix = me
    iy = -1
    call MPI_Allreduce(ix, iy, b, dt, op, MPI_COMM_WORLD)
    if (any(iy.ne.ref)) then
        print*,'an error has occurred in dt+op'
        print*,iy
    endif
    call MPI_Barrier(MPI_COMM_WORLD)

    call MPI_Op_free(op,ierror)
    call MPI_Type_free(dt,ierror)

    if(me.eq.0) print*,'MPI_Allreduce with user-def op is okay'

    call MPI_Finalize()

end program main
