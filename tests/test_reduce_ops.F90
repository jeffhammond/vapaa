program main
    use mpi_f08
    implicit none
    integer :: ierror
    integer :: i, me, np, ref
    integer, dimension(10) :: ix, iy
    type(MPI_Op) :: o
    type(MPI_Op), dimension(10) :: ops = [ MPI_MAX, MPI_MIN, MPI_SUM, MPI_PROD, &
                                           MPI_BAND, MPI_BOR, MPI_BXOR, &
                                           MPI_LAND, MPI_LOR, MPI_LXOR ] 
    character(8), dimension(10) :: opn = [ 'MPI_MAX ', 'MPI_MIN ', 'MPI_SUM ', 'MPI_PROD', &
                                           'MPI_BAND', 'MPI_BOR ', 'MPI_BXOR', &
                                           'MPI_LAND', 'MPI_LOR ', 'MPI_LXOR' ] 

    call MPI_Init(ierror)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    call MPI_Barrier(MPI_COMM_WORLD)

    do i = 1, size(ops)
        o = ops(i)
        ix  = 0
        iy  = 0
        ref = 0
        if (o.eq.MPI_MAX) then
            ix  = me
            ref = np-1
        else if (o.eq.MPI_MIN) then
            ix  = -me
            ref = 1-np
        else if (o.eq.MPI_SUM) then
            ix  = me
            ref = np*(np-1)/2
        else if (o.eq.MPI_PROD) then
            ix  = np
            ref = np**np
        else if (o.eq.MPI_BAND) then
            ix  = ISHFT(1,me)
            ref = 0
        else if (o.eq.MPI_BOR) then
            if (np.lt.32) then
                ix  = ISHFT(1,me)
                ref = ISHFT(1,np)-1
            end if
        else if (o.eq.MPI_BXOR) then
            ix  = 1
            ref = MOD(np,2)
        else if (o.eq.MPI_LAND) then
            ix  = me
            ref = 0
        else if (o.eq.MPI_LOR) then
            ix  = me
            ref = 1
        else if (o.eq.MPI_LXOR) then
            ix  = me
            ref = MOD(np-1,2)
        else
            call MPI_Abort(MPI_COMM_WORLD,i)
        endif
        call MPI_Allreduce(ix, iy, size(ix), MPI_INTEGER, o, MPI_COMM_WORLD)
        if (any(iy.ne.ref)) then
            print*,'an error has occurred ',opn(i),' ref=',ref
            print*,me,':',iy
            call MPI_Abort(MPI_COMM_WORLD,i)
        else
            if (me.eq.0) then
                print*,'MPI_Allreduce with ',opn(i),' is okay'
            end if
        end if
    end do

    call MPI_Finalize(ierror)

end program main
