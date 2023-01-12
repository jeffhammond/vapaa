program main
    use mpi_f08
    implicit none
    integer :: me, np, i, j
    type(MPI_Datatype) :: v
    integer, dimension(9,8) :: A
    integer, dimension(7,6) :: B
    integer, dimension(5,4) :: C
    type(MPI_Request) :: r(2)

    call MPI_Init()
    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    ! we are going to use a subarray dt to send the C-sized inside of B that
    ! is itself the inside of A.  the inside of A is the size of B.
    block
        integer :: s
        integer, dimension(2) :: sizes, subsizes, starts
        sizes    = shape(B)
        subsizes = shape(C)
        starts   = 2
        call MPI_Type_create_subarray(2, sizes, subsizes, starts, MPI_ORDER_FORTRAN, MPI_INTEGER, v)

        call MPI_Type_size(v, s)
        print*,'type size = ',s

        call MPI_Type_commit(v)
    end block

    do j = 1, size(A,2)
      do i = 1, size(A,1)
        !write(*,'(6i4)') i, j, size(A,2)-j, size(A,1)-i, j-1, i-1
        A(i,j) = min( size(A,2)-j, size(A,1)-i, j-1, i-1 )
      end do
    end do

    ! debug only
    write(*,'(a)') 'A='
    do j = 1, size(A,2)
      write(*,'(30i4)') A(:,j)
    end do

    B = 0
    call MPI_Isend( A(2:8,2:7), size(A(2:8,2:7)), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(1))
    call MPI_Irecv( B, size(B), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2))
    call MPI_Waitall(2, r, MPI_STATUSES_IGNORE)
    if (any(B.ne.A(2:8,2:7))) then
        print*,'an error has occurred'
        if (me .eq. 0) then
            !write(*,'(a,600i4,a)') 'A=[',A,']'
            write(*,'(a,100i4,a)') 'A[...]=[',A(2:8,2:7),']'
            write(*,'(a,100i4,a)') 'B[ * ]=[',B,']'
        endif
    endif
    ! debug only
    write(*,'(a)') 'B='
    do j = 1, size(B,2)
      write(*,'(30i4)') B(:,j)
    end do

    B = 0
    call MPI_Isend( A(2:8,2:7), 1, v, me, 99, MPI_COMM_WORLD, r(1))
    call MPI_Irecv( C, size(C), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2))
    call MPI_Waitall(2, r, MPI_STATUSES_IGNORE)
    if (any(C.ne.A(3:7,3:6))) then
        print*,'an error has occurred'
        if (me .eq. 0) then
            !write(*,'(a,600i4,a)') 'A=[',A,']'
            write(*,'(a,100i4,a)') 'A[...]=[',A(3:7,3:6),']'
            write(*,'(a,100i4,a)') 'C[ * ]=[',C,']'
        endif
    endif
    ! debug only
    write(*,'(a)') 'C='
    do j = 1, size(C,2)
      write(*,'(30i4)') C(:,j)
    end do

    call MPI_Type_free(v)

    if (me.eq.0) then
        print*,'non-contiguous matrix support is okay'
    end if

    call MPI_Finalize()

end program main
