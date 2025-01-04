program main
    use mpi_f08
    implicit none
    integer :: ierror
    integer :: i, me, np
    integer, dimension(2) :: ix, iy, ref
    !type(MPI_Op) :: o

    call MPI_Init(ierror)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    call MPI_Barrier(MPI_COMM_WORLD)

    ix  = [me+1,me]
    iy  = 0
    ref = [np,np-1]
    call MPI_Allreduce(ix, iy, 1, MPI_2INTEGER, MPI_MAXLOC, MPI_COMM_WORLD)
    if (any(iy.ne.ref)) then
        print*,'an error has occurred in MPI_MAXLOC, ref=',ref
        print*,me,':',iy
        call MPI_Abort(MPI_COMM_WORLD,i)
    else
        if (me.eq.0) then
            print*,'MPI_Allreduce with MPI_MAXLOC is okay'
        end if
    end if

    ix  = [me+1,me]
    iy  = 0
    ref = [1,0]
    call MPI_Allreduce(ix, iy, 1, MPI_2INTEGER, MPI_MINLOC, MPI_COMM_WORLD)
    if (any(iy.ne.ref)) then
        print*,'an error has occurred in MPI_MINLOC, ref=',ref
        print*,me,':',iy
        call MPI_Abort(MPI_COMM_WORLD,i)
    else
        if (me.eq.0) then
            print*,'MPI_Allreduce with MPI_MINLOC is okay'
        print *, 'Test passed'
        end if
    end if

    call MPI_Finalize(ierror)

end program main
