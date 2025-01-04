program main
    use mpi_f08
    implicit none
    integer :: me, np, i, j, ierr, eclass
    type(MPI_Datatype) :: v(3)
    integer, dimension(9,8) :: A, X
    integer, dimension(7,6) :: B
    integer, dimension(5,4) :: C
    type(MPI_Request) :: r(2)
    type(MPI_Status) :: s(2)
    character(len=MPI_MAX_ERROR_STRING) :: string
    integer :: len

    call MPI_Init()
    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    block
        integer :: s
        integer, dimension(2) :: sizes, subsizes, starts
        sizes    = shape(A)
        subsizes = shape(B)
        starts   = 1
        call MPI_Type_create_subarray(2, sizes, subsizes, starts, MPI_ORDER_FORTRAN, MPI_INTEGER, v(1))
        call MPI_Type_size(v(1), s)
        print*,'s=',s/4,size(B)
        call MPI_Type_commit(v(1))
    end block

    block
        integer :: s
        integer, dimension(2) :: sizes, subsizes, starts
        sizes    = shape(A)
        subsizes = shape(C)
        starts   = 2
        call MPI_Type_create_subarray(2, sizes, subsizes, starts, MPI_ORDER_FORTRAN, MPI_INTEGER, v(2))
        call MPI_Type_size(v(2), s)
        print*,'s=',s/4,size(C)
        call MPI_Type_commit(v(2))
    end block

    ! we are going to use a subarray dt to send the C-sized inside of B that
    ! is itself the inside of A.  the inside of A is the size of B.
    block
        integer :: s
        integer, dimension(2) :: sizes, subsizes, starts
        sizes    = shape(B)
        subsizes = shape(C)
        starts   = 1
        call MPI_Type_create_subarray(2, sizes, subsizes, starts, MPI_ORDER_FORTRAN, MPI_INTEGER, v(3))
        call MPI_Type_size(v(3), s)
        print*,'s=',s/4,size(C)
        call MPI_Type_commit(v(3))
    end block

    do j = 1, size(A,2)
      do i = 1, size(A,1)
        !write(*,'(6i4)') i, j, size(A,2)-j, size(A,1)-i, j-1, i-1
        A(i,j) = min( size(A,2)-j, size(A,1)-i, j-1, i-1 )
      end do
    end do

    ! debug only
    write(*,'(a)') 'A='
    do j = 1, size(A,1)
      write(*,'(30i4)') A(j,:)
    end do

    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ! B = A(2:8,2:7) with subarray
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    B = 0
    call MPI_Isend( A(2:8,2:7), size(A(2:8,2:7)), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(1), ierr)
    call MPI_Irecv( B, size(B), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2), ierr)
    call MPI_Waitall(2, r, s, ierr)
    if (any(B.ne.A(2:8,2:7))) then
        print*,'an error has occurred'
        if (me .eq. 0) then
            write(*,'(a)') 'B='
            do j = 1, size(B,1)
              write(*,'(30i4)') B(j,:)
            end do
        endif
        stop 1
    else
        ! debug only
        write(*,'(a)') 'B='
        do j = 1, size(B,1)
          write(*,'(30i4)') B(j,:)
        end do
    endif

    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ! B = A(2:8,2:7) with datatype
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    B = 0
    call MPI_Isend( A, 1, v(1), me, 99, MPI_COMM_WORLD, r(1), ierr)
    call MPI_Irecv( B, size(B), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2), ierr)
    call MPI_Waitall(2, r, s, ierr)
    if (any(B.ne.A(2:8,2:7))) then
        print*,'an error has occurred'
        if (me .eq. 0) then
            write(*,'(a)') 'B='
            do j = 1, size(B,1)
              write(*,'(30i4)') B(j,:)
            end do
        endif
        stop 2
    else
        ! debug only
        write(*,'(a)') 'B='
        do j = 1, size(B,1)
          write(*,'(30i4)') B(j,:)
        end do
    endif

    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ! C = A(3:7,3:6) with subarray
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    C = 0
    call MPI_Isend( A(3:7,3:6), size(A(3:7,3:6)), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(1), ierr)
    call MPI_Irecv( C, size(C), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2), ierr)
    call MPI_Waitall(2, r, s, ierr)
    if (any(C.ne.A(3:7,3:6))) then
        print*,'an error has occurred'
        if (me .eq. 0) then
            write(*,'(a)') 'C='
            do j = 1, size(C,1)
              write(*,'(30i4)') C(j,:)
            end do
        endif
        stop 3
    else
        ! debug only
        write(*,'(a)') 'C='
        do j = 1, size(C,1)
          write(*,'(30i4)') C(j,:)
        end do
    endif

    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ! C = A(3:7,3:6) with datatype
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    C = 0
    call MPI_Isend( A, 1, v(2), me, 99, MPI_COMM_WORLD, r(1), ierr)
    call MPI_Irecv( C, size(C), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2), ierr)
    call MPI_Waitall(2, r, s, ierr)
    if (any(C.ne.A(3:7,3:6))) then
        print*,'an error has occurred'
        if (me .eq. 0) then
            write(*,'(a)') 'C='
            do j = 1, size(C,1)
              write(*,'(30i4)') C(j,:)
            end do
        endif
        stop 4
    else
        ! debug only
        write(*,'(a)') 'C='
        do j = 1, size(C,1)
          write(*,'(30i4)') C(j,:)
        end do
    endif

    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ! C = A(3:7,3:6) with subbarray and datatype
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    C = 0
    call MPI_Isend( A(2:8,2:7), 1, v(3), me, 99, MPI_COMM_WORLD, r(1), ierr)
    call MPI_Irecv( C, size(C), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2), ierr)
    call MPI_Waitall(2, r, s, ierr)
    if (any(C.ne.A(3:7,3:6))) then
        print*,'an error has occurred'
        if (me .eq. 0) then
            write(*,'(a)') 'C='
            do j = 1, size(C,1)
              write(*,'(30i4)') C(j,:)
            end do
        endif
        stop 5
    else
        ! debug only
        write(*,'(a)') 'C='
        do j = 1, size(C,1)
          write(*,'(30i4)') C(j,:)
        end do
    endif

    call MPI_Type_free(v(1))
    call MPI_Type_free(v(2))
    call MPI_Type_free(v(3))

    if (me.eq.0) then
        print*,'non-contiguous matrix support 2 is okay'
        print *, 'Test passed'
    end if

    call MPI_Finalize()

end program main
