module test_op_trampoline_slots_m
    use iso_c_binding, only: c_ptr, c_f_pointer
    use mpi_f08
    implicit none

contains

    subroutine add_ints(invec, inoutvec, len, datatype)
        type(c_ptr), value :: invec, inoutvec
        integer :: len
        type(MPI_Datatype) :: datatype
        integer, pointer :: in_values(:), inout_values(:)

        if (datatype == MPI_DATATYPE_NULL) return
        call c_f_pointer(invec, in_values, [len])
        call c_f_pointer(inoutvec, inout_values, [len])
        inout_values = inout_values + in_values
    end subroutine add_ints

end module test_op_trampoline_slots_m

program test_op_trampoline_slots
    use mpi_f08
    use test_op_trampoline_slots_m, only: add_ints
    implicit none

    integer, parameter :: nops = 64, nvalues = 8
    integer :: ierr, rank, nranks
    integer :: i, expected
    integer :: sendbuf(nvalues), recvbuf(nvalues)
    type(MPI_Datatype) :: one_integer
    type(MPI_Op) :: ops(nops)

    call MPI_Init(ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Init")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_rank")
    call MPI_Comm_size(MPI_COMM_WORLD, nranks, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_size")

    call MPI_Type_contiguous(1, MPI_INTEGER, one_integer, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_contiguous")
    call MPI_Type_commit(one_integer, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_commit")

    do i = 1, nops
        call MPI_Op_create(add_ints, .true., ops(i), ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Op_create")
    end do

    do i = 1, nops
        sendbuf = rank + i
        recvbuf = -1
        call MPI_Allreduce(sendbuf, recvbuf, nvalues, one_integer, ops(i), &
                           MPI_COMM_WORLD, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Allreduce user op")
        expected = nranks * i + (nranks * (nranks - 1)) / 2
        call require(all(recvbuf == expected), "MPI_Allreduce user op payload")
    end do

    do i = 1, nops
        call MPI_Op_free(ops(i), ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Op_free")
    end do
    call MPI_Type_free(one_integer, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_free")

    if (rank == 0) print *, "Test passed"
    call MPI_Finalize(ierr)

contains

    subroutine require(ok, label)
        logical, intent(in) :: ok
        character(len=*), intent(in) :: label

        if (.not. ok) then
            print *, "FAIL:", trim(label), "rank", rank
            call MPI_Abort(MPI_COMM_WORLD, 1, ierr)
        end if
    end subroutine require

end program test_op_trampoline_slots
