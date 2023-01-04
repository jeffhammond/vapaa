program main
    use mpi_f08
    implicit none
    integer :: me, np, i
    type(MPI_Request) :: r(2)

    call MPI_Init()
    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    block ! 3D

        integer, dimension(10,10,10) :: A
        integer, dimension(5,5,5) :: B

        A = reshape([(i, i = 1,size(A))],shape(A))

        B = 0
        call MPI_Isend( A(1:10:2,1:10:2,1:10:2), size(A(1:10:2,1:10:2,1:10:2)), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(1))
        call MPI_Irecv( B, size(B), MPI_INTEGER, me, 99, MPI_COMM_WORLD, r(2))
        call MPI_Waitall(2, r, MPI_STATUSES_IGNORE)
        if (any(B.ne.A(1:10:2,1:10:2,1:10:2))) then
            print*,'an error has occurred'
            if (me .eq. 0) then
                write(*,'(a,125i4,a)') 'A[...]=[',A(1:10:2,1:10:2,1:10:2),']'
                write(*,'(a,125i4,a)') 'B[ * ]=[',B,']'
            endif
        endif

    end block

    if (me.eq.0) then
        print*,'non-contiguous tensor support is okay'
    end if

    call MPI_Finalize()

    end program main
