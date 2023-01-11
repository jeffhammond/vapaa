program main
    use mpi_f08
    implicit none
    integer :: me, np, i
    character :: A(104), B(26)
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
    B = A(1:104:4)
    if (me.ne.0) A = 'X'
    do i=1,100
        call MPI_Barrier(MPI_COMM_WORLD)
    enddo
    print*, me, 'IN A=[',A,']'
    call MPI_Barrier(MPI_COMM_WORLD)
    write(*,'(a,26a1,a)')  'REF B=[',B,']'
    call MPI_Barrier(MPI_COMM_WORLD)

    call MPI_Bcast( A(1:104:2), 1, v, 0, MPI_COMM_WORLD)
    call MPI_Barrier(MPI_COMM_WORLD)

    if (me.ne.0) print*, me, 'OUT A=[',A,']'

    call MPI_Barrier(MPI_COMM_WORLD)
    if (me.ne.0) then
        if (any(A(1:104:4).ne.B)) then
            write(*,'(a,26a1,a)') 'A[...]=[',A(1:104:4),']'
            write(*,'(a,26a1,a)') 'B[ * ]=[',B,']'
            !call MPI_Abort(MPI_COMM_WORLD,me)
        end if
        if (any(A(2:104:4).ne.'X').or.any(A(3:104:4).ne.'X').or.any(A(4:104:4).ne.'X')) then
            write(*,'(a,104a1,a)') 'A=[',A,']'
            write(*,'(a,26a1,a)')  'A[...]=[',A(1:104:4),']'
            write(*,'(a,26a1,a)')  'A[...]=[',A(2:104:4),']'
            write(*,'(a,26a1,a)')  'A[...]=[',A(3:104:4),']'
            write(*,'(a,26a1,a)')  'A[...]=[',A(4:104:4),']'
            write(*,'(a,26a1,a)')  'B=[',B,']'
            !call MPI_Abort(MPI_COMM_WORLD,-me)
        end if
    end if
    call MPI_Barrier(MPI_COMM_WORLD)

    call MPI_Type_free(v)

    if (me.eq.0) then
        print*,'serialization support is okay'
    end if

    call MPI_Finalize()

end program main
