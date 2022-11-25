program test_reductions
    use mpi_f08
    implicit none
    integer :: ierror
    integer :: i, me, np
    integer :: b
    integer, allocatable :: x(:)
    type(MPI_Status) :: s
    type(MPI_Request) :: r
    type(MPI_Request), allocatable :: vr(:)
    logical :: flag

    call MPI_Init(ierror)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    if (0.ne.MOD(np,2)) then
        print*,'Run with an even number of processes'
        call MPI_Abort(MPI_COMM_WORLD,np)
    endif

    call MPI_Barrier(MPI_COMM_WORLD)
    do i=0,np
        if (me.eq.i) print*,'I am ',me,' of ',np,' of WORLD'
        call MPI_Barrier(MPI_COMM_WORLD)
    enddo
    call MPI_Barrier(MPI_COMM_WORLD)

    if(me.eq.0) print*,'BLOCKING'

    do i=0,20
        b = 2**i
        if (me.eq.0) print*,'b=',b
        allocate( x(b) )
        if (0.eq.MOD(me,2)) then
            x = me
            call MPI_Send(x,b,MPI_INTEGER,me+1,i,MPI_COMM_WORLD)
        else
            x = -1
#if 1
            call MPI_Recv(x,b,MPI_INTEGER,me-1,i,MPI_COMM_WORLD,MPI_STATUS_IGNORE)
            s = s
#else
            call MPI_Recv(x,b,MPI_INTEGER,me-1,i,MPI_COMM_WORLD,s)
            if (((s % MPI_SOURCE) .ne. me-1).or.((s % MPI_TAG).ne.i)) then
                print*,'MPI_Status is wrong'
                print*,'status = ',s % MPI_SOURCE,s % MPI_TAG,s % MPI_ERROR
            endif
#endif
            if (any(x.ne.(me-1))) then
                print*,'an error has occurred'
                print*,x
            endif
        endif
        deallocate( x )
    enddo

    if(me.eq.0) print*,'NONBLOCKING'

    do i=0,20
        b = 2**i
        if (me.eq.0) print*,'b=',b
        allocate( x(b) )
        if (0.eq.MOD(me,2)) then
            x = me
            call MPI_Isend(x,b,MPI_INTEGER,me+1,i,MPI_COMM_WORLD,r)
            call MPI_Wait(r,MPI_STATUS_IGNORE)
        else
            x = -1
            call MPI_Irecv(x,b,MPI_INTEGER,me-1,i,MPI_COMM_WORLD,r)
#if 1
            call MPI_Wait(r,MPI_STATUS_IGNORE)
#else
            call MPI_Wait(r,s)
            if (((s % MPI_SOURCE) .ne. me-1).or.((s % MPI_TAG).ne.i)) then
                print*,'MPI_Status is wrong'
                print*,'status = ',s % MPI_SOURCE,s % MPI_TAG,s % MPI_ERROR
            endif
#endif
            if (any(x.ne.(me-1))) then
                print*,'an error has occurred'
                print*,x
            endif
        endif
        deallocate( x )
    enddo

    if(me.eq.0) print*,'WAITALL'

    allocate( vr(2*np) , x(2*np) )
    x = me
    do i=0,np-1
        call MPI_Isend(x(i+1),1,MPI_INTEGER,i,0,MPI_COMM_WORLD,vr(i+1))
        call MPI_Irecv(x(np+i+1),1,MPI_INTEGER,i,0,MPI_COMM_WORLD,vr(np+i+1))
    enddo
    call MPI_Waitall(2*np,vr,MPI_STATUSES_IGNORE)
    do i=0,np-1
      if(x(np+i+1).ne.(i)) then
        print*,'an error has occurred'
        print*,x(np+i)
      endif
    enddo
    deallocate( vr , x )

    if(me.eq.0) print*,'TESTALL'

    allocate( vr(2*np) , x(2*np) )
    x = me
    do i=0,np-1
        call MPI_Isend(x(i+1),1,MPI_INTEGER,i,0,MPI_COMM_WORLD,vr(i+1))
        call MPI_Irecv(x(np+i+1),1,MPI_INTEGER,i,0,MPI_COMM_WORLD,vr(np+i+1))
    enddo
    flag = .false.
    do while (.not.flag)
        call MPI_Testall(2*np,vr,flag,MPI_STATUSES_IGNORE)
    end do
    do i=0,np-1
      if(x(np+i+1).ne.(i)) then
        print*,'an error has occurred'
        print*,x(np+i)
      endif
    enddo
    deallocate( vr , x )

    if(me.eq.0) print*,'EVERYTHING IS OKAY'

    !print*,'LOC:',LOC(r),LOC(r%MPI_VAL)

    call MPI_Finalize(ierror)

end program test_reductions
