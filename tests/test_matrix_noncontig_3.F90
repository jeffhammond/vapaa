program main
    use mpi_f08
    implicit none
    integer :: me, np, i, j, ierr, eclass
    type(MPI_Datatype) :: v(3)
    integer, dimension(9,8) :: A
    integer, dimension(7,6) :: B
    integer, dimension(5,4) :: C
    integer, dimension(9,8*3) :: A3
    integer, dimension(7,6*3) :: B3
    integer, dimension(5,4*3) :: C3
    type(MPI_Request) :: r(2)
    type(MPI_Status) :: s(2)
    character(len=MPI_MAX_ERROR_STRING) :: string
    integer :: len
    logical :: t1, t2, t3

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
        call MPI_Type_commit(v(2))
    end block

    block
        integer :: s
        integer, dimension(2) :: sizes, subsizes, starts
        sizes    = shape(B)
        subsizes = shape(C)
        starts   = 1
        call MPI_Type_create_subarray(2, sizes, subsizes, starts, MPI_ORDER_FORTRAN, MPI_INTEGER, v(3))
        call MPI_Type_size(v(3), s)
        call MPI_Type_commit(v(3))
    end block

    do j = 1, size(A,2)
      do i = 1, size(A,1)
        !write(*,'(6i4)') i, j, size(A,2)-j, size(A,1)-i, j-1, i-1
        A(i,j) = min( size(A,2)-j, size(A,1)-i, j-1, i-1 )
      end do
    end do

    A3(:, 1: 8) = A
    A3(:, 9:16) = A
    A3(:,17:24) = A

    ! debug only
    write(*,'(a)') 'A3='
    do j = 1, size(A,1)
      write(*,'(30i4)') A3(j,:)
    end do

    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ! B = A(2:8,2:7) with datatype
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    B3 = 0
    call MPI_Isend( A3, 3, v(1), me, 99, MPI_COMM_WORLD, r(1), ierr)
    call MPI_Irecv( B3, 3 * size(B), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2), ierr)
    call MPI_Waitall(2, r, s, ierr)

    t1 = any(B3(:,1:6).ne.A3(2:8,2:7))
    t2 = any(B3(:,1:6).ne.A3(2:8,10:15))
    t3 = any(B3(:,1:6).ne.A3(2:8,18:23))
    if (t1.or.t2.or.t3) then
        print*,'an error has occurred'
        if (me .eq. 0) then
            write(*,'(a)') 'B3='
            do j = 1, size(B3,1)
              write(*,'(30i4)') B3(j,:)
            end do
        endif
    else
        ! debug only
        write(*,'(a)') 'B3='
        do j = 1, size(B3,1)
          write(*,'(30i4)') B3(j,:)
        end do
    endif

#if 0
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
    else
        ! debug only
        write(*,'(a)') 'C='
        do j = 1, size(C,1)
          write(*,'(30i4)') C(j,:)
        end do
    endif
#endif

    call MPI_Type_free(v(1))
    call MPI_Type_free(v(2))
    call MPI_Type_free(v(3))

    if (me.eq.0) then
        print*,'non-contiguous matrix support 3 is okay'
    end if

    call MPI_Finalize()

end program main
