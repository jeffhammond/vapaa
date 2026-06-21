program test_wcollective_grequest_thread
    use mpi_f08
    implicit none

    integer :: ierr, provided, rank, nranks
    type(MPI_Comm) :: cart

    call MPI_Init_thread(MPI_THREAD_MULTIPLE, provided, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Init_thread")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_rank")
    call MPI_Comm_size(MPI_COMM_WORLD, nranks, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_size")
    call require(provided >= MPI_THREAD_MULTIPLE, "MPI_THREAD_MULTIPLE")
    call require(nranks == 4, "this test expects four ranks")

    call run_ialltoallw()
    call make_cart_comm(cart)
    call run_ineighbor_alltoallw(cart)
    call MPI_Comm_free(cart, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_free")

    if (rank == 0) print *, "Test passed"
    call MPI_Finalize(ierr)

contains

    subroutine require(ok, label)
        logical, intent(in) :: ok
        character(len=*), intent(in) :: label

        if (.not. ok) then
            print *, "FAIL:", trim(label), "rank", rank, "ierr", ierr
            call MPI_Abort(MPI_COMM_WORLD, 1, ierr)
        end if
    end subroutine require

    subroutine wait_request(request, label)
        type(MPI_Request), intent(inout) :: request
        character(len=*), intent(in) :: label

        call require(ierr == MPI_SUCCESS, label // " start")
        call MPI_Wait(request, MPI_STATUS_IGNORE, ierr)
        call require(ierr == MPI_SUCCESS, label // " wait")
    end subroutine wait_request

    subroutine delay_one_second()
        integer :: count_rate, start_count, current_count

        call system_clock(count_rate=count_rate)
        call require(count_rate > 0, "system_clock")
        call system_clock(count=start_count)
        do
            call system_clock(count=current_count)
            if (real(current_count - start_count, kind=8) / &
                real(count_rate, kind=8) >= 1.0_8) exit
        end do
    end subroutine delay_one_second

    subroutine run_ialltoallw()
        integer :: i
        integer :: int_bytes
        integer :: sendbuf(4), recvbuf(4), expected(4)
        integer :: counts(4), bdispls(4)
        type(MPI_Datatype) :: types(4)
        type(MPI_Request) :: request

        counts = 1
        int_bytes = storage_size(sendbuf(1)) / 8
        bdispls = [(int_bytes * (i - 1), i = 1, 4)]
        types = MPI_INTEGER
        do i = 1, 4
            sendbuf(i) = 100 * rank + i
            expected(i) = 100 * (i - 1) + rank + 1
        end do
        recvbuf = -1

        call MPI_Ialltoallw(sendbuf, counts, bdispls, types, recvbuf, counts, &
                            bdispls, types, MPI_COMM_WORLD, request, ierr)
        call delay_one_second()
        call wait_request(request, "MPI_Ialltoallw")
        call require(all(recvbuf == expected), "MPI_Ialltoallw payload")
    end subroutine run_ialltoallw

    subroutine make_cart_comm(comm)
        type(MPI_Comm), intent(out) :: comm
        integer :: dims(1)
        logical :: periods(1)

        dims = [nranks]
        periods = [.true.]
        call MPI_Cart_create(MPI_COMM_WORLD, 1, dims, periods, .false., comm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Cart_create")
    end subroutine make_cart_comm

    subroutine run_ineighbor_alltoallw(comm)
        type(MPI_Comm), intent(in) :: comm
        integer :: left, right
        integer :: int_bytes
        integer :: sendbuf(2), recvbuf(2)
        integer :: counts(2)
        integer(kind=MPI_ADDRESS_KIND) :: adispls(2)
        type(MPI_Datatype) :: types(2)
        type(MPI_Request) :: request

        call MPI_Cart_shift(comm, 0, 1, left, right, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Cart_shift")

        sendbuf = [10 * rank + 1, 10 * rank + 2]
        recvbuf = -1
        counts = 1
        int_bytes = storage_size(sendbuf(1)) / 8
        adispls = [0_MPI_ADDRESS_KIND, int(int_bytes, kind=MPI_ADDRESS_KIND)]
        types = MPI_INTEGER

        call MPI_Ineighbor_alltoallw(sendbuf, counts, adispls, types, recvbuf, &
                                     counts, adispls, types, comm, request, ierr)
        call wait_request(request, "MPI_Ineighbor_alltoallw")
        call require(all(recvbuf == [10 * left + 2, 10 * right + 1]), &
                     "MPI_Ineighbor_alltoallw payload")
    end subroutine run_ineighbor_alltoallw

end program test_wcollective_grequest_thread
