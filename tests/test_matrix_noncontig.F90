program main
    use mpi_f08
    implicit none
    integer :: me, np, i
    integer, dimension(30,20), asynchronous :: A
    integer, dimension(10,10), asynchronous :: B
    type(MPI_Request) :: r(2)

    call MPI_Init()
    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    if (me.eq.0) then
        print*,'MPI_SUBARRAYS_SUPPORTED=',MPI_SUBARRAYS_SUPPORTED
        print*,'MPI_ASYNC_PROTECTS_NONBLOCKING=',MPI_ASYNC_PROTECTS_NONBLOCKING
    endif

    A = reshape([(i, i = 1,size(A))],shape(A))
    !if (me.eq.0) print*,'A=',A

    B = 0
    call MPI_Isend( A(1:10,1:20:2), size(A(1:10,1:20:2)), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(1))
    call MPI_Irecv( B, size(B), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2))
    call MPI_Waitall(2, r, MPI_STATUSES_IGNORE)
    if (any(B.ne.A(1:10,1:20:2))) then
        print*,'an error has occurred'
        if (me .eq. 0) then
            !write(*,'(a,600i4,a)') 'A=[',A,']'
            write(*,'(a,100i4,a)') 'A[...]=[',A(1:10,1:20:2),']'
            write(*,'(a,100i4,a)') 'B[ * ]=[',B,']'
        endif
        stop 1
    endif

    B = 0
    call MPI_Isend( A(1:30:3,1:20:2), size(A(1:30:3,1:20:2)), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(1))
    call MPI_Irecv( B, size(B), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2))
    call MPI_Waitall(2, r, MPI_STATUSES_IGNORE)
    if (any(B.ne.A(1:30:3,1:20:2))) then
        print*,'an error has occurred'
        if (me .eq. 0) then
            !write(*,'(a,600i4,a)') 'A=[',A,']'
            write(*,'(a,100i4,a)') 'A[...]=[',A(1:30:3,1:20:2),']'
            write(*,'(a,100i4,a)') 'B[ * ]=[',B,']'
        endif
        stop 2
    endif

    B = 0
    call MPI_Isend( A(1:30:3,1:20:2), size(A(1:30:3,1:20:2))-1, MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(1))
    call MPI_Irecv( B, size(B), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2))
    call MPI_Waitall(2, r, MPI_STATUSES_IGNORE)
    ! first check the omitted element, then set it to what it should be so the whole array check passes
    if (B(10,10).ne.0) then
        print*,'an error has occurred'
        if (me .eq. 0) then
            !write(*,'(a,600i4,a)') 'A=[',A,']'
            write(*,'(a,100i4,a)') 'A[...]=[',A(1:30:3,1:20:2),']'
            write(*,'(a,100i4,a)') 'B[ * ]=[',B,']'
        endif
        stop 3
    else
        B(10,10) = A(28,19) 
    endif
    if (any(B.ne.A(1:30:3,1:20:2))) then
        print*,'an error has occurred'
        if (me .eq. 0) then
            !write(*,'(a,600i4,a)') 'A=[',A,']'
            write(*,'(a,100i4,a)') 'A[...]=[',A(1:30:3,1:20:2),']'
            write(*,'(a,100i4,a)') 'B[ * ]=[',B,']'
        endif
        stop 4
    endif

    if (me.eq.0) then
        print*,'non-contiguous matrix support is okay'
    end if

    call MPI_Finalize()

end program main
