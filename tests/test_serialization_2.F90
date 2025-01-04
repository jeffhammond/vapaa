program main
    use mpi_f08
    implicit none
    integer :: me, np
    character :: A(104), B(26), Z(104)
    type(MPI_Request) :: r(2)
    type(MPI_Datatype) :: v

    call MPI_Init()
    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    call MPI_Type_vector(26,1,2,MPI_CHARACTER,v)
    !call MPI_Type_set_name(v,'VAPAA: 26,1,2,MPI_CHAR')
    call MPI_Type_commit(v)

    A = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', &
         'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', &
         'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', &
         'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', &
         'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', &
         'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', &
         'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', &
         'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
    B = A(1:104:4) ! verification array
    Z = 'X'

    !call MPI_Bcast( A(1:104:2), 1, v, 0, MPI_COMM_WORLD)
    !print*, me, 'A=[',A,']'
    call MPI_Isend( A(1:104:2), 1, v, me, 99, MPI_COMM_WORLD, r(1))
    call MPI_Irecv( Z(1:104:2), 1, v, me, 99, MPI_COMM_WORLD, r(2))
    call MPI_Waitall(2, r, MPI_STATUSES_IGNORE)

    if (me.ne.0) then
        if (any(Z(1:104:4).ne.B)) then
            write(*,'(a,26a1,a)') 'Z[...]=[',Z(1:104:4),']'
            write(*,'(a,26a1,a)') 'B[ * ]=[',B,']'
            call MPI_Abort(MPI_COMM_WORLD,me)
        end if
        if (any(Z(2:104:4).ne.'X').or.any(Z(3:104:4).ne.'X').or.any(Z(4:104:4).ne.'X')) then
            write(*,'(a,104a1,a)') 'Z=[',Z,']'
            write(*,'(a,26a1,a)')  'Z[...]=[',Z(1:104:4),']'
            write(*,'(a,26a1,a)')  'Z[...]=[',Z(2:104:4),']'
            write(*,'(a,26a1,a)')  'Z[...]=[',Z(3:104:4),']'
            write(*,'(a,26a1,a)')  'Z[...]=[',Z(4:104:4),']'
            write(*,'(a,26a1,a)')  'B=[',B,']'
            call MPI_Abort(MPI_COMM_WORLD,-me)
        end if
    end if
    call MPI_Barrier(MPI_COMM_WORLD)

    call MPI_Type_free(v)

    if (me.eq.0) then
        print*,'serialization 2 support is okay'
        print *, 'Test passed'
    end if

    call MPI_Finalize()

end program main
