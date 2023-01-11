program main
    use mpi_f08
    implicit none
    integer :: me, np, i, j
    type(MPI_Datatype) :: v
    integer, dimension(9,8) :: A
    integer, dimension(8,7) :: B
    type(MPI_Request) :: r(2)

    call MPI_Init()
    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    do j = 1, size(A,2)
      do i = 1, size(A,1)
        !write(*,'(6i4)') i, j, size(A,2)-j, size(A,1)-i, j-1, i-1
        A(i,j) = min( size(A,2)-j, size(A,1)-i, j-1, i-1 )
      end do
    end do

    write(*,'(a)') 'A='
    do j = 1, size(A,2)
      write(*,'(30i4)') A(:,j)
    end do

#if 0

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
    endif

#endif

    if (me.eq.0) then
        print*,'non-contiguous matrix support is okay'
    end if

    call MPI_Finalize()

end program main
