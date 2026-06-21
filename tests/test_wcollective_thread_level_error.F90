program test_wcollective_thread_level_error
    use mpi_f08
    implicit none

    integer :: ierr, provided, rank, nranks, errors
    type(MPI_Comm) :: comm, cart

    errors = 0

    call MPI_Init(ierr)
    call record(ierr == MPI_SUCCESS, "MPI_Init")
    call MPI_Query_thread(provided, ierr)
    call record(ierr == MPI_SUCCESS, "MPI_Query_thread")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call record(ierr == MPI_SUCCESS, "MPI_Comm_rank")
    call MPI_Comm_size(MPI_COMM_WORLD, nranks, ierr)
    call record(ierr == MPI_SUCCESS, "MPI_Comm_size")
    if (provided >= MPI_THREAD_MULTIPLE) then
        errors = errors + 1
        if (rank == 0) print *, "failure: non-THREAD_MULTIPLE setup"
        call MPI_Finalize(ierr)
        error stop 1
    end if
    call record(nranks == 4, "this test expects four ranks")

    call MPI_Comm_dup(MPI_COMM_WORLD, comm, ierr)
    call record(ierr == MPI_SUCCESS, "MPI_Comm_dup")
    call MPI_Comm_set_errhandler(comm, MPI_ERRORS_RETURN, ierr)
    call record(ierr == MPI_SUCCESS, "MPI_Comm_set_errhandler comm")

    call run_ialltoallw_error(comm)
    call make_cart_comm(comm, cart)
    call MPI_Comm_set_errhandler(cart, MPI_ERRORS_RETURN, ierr)
    call record(ierr == MPI_SUCCESS, "MPI_Comm_set_errhandler cart")
    call run_ineighbor_alltoallw_error(cart)

    call MPI_Comm_free(cart, ierr)
    call record(ierr == MPI_SUCCESS, "MPI_Comm_free cart")
    call MPI_Comm_free(comm, ierr)
    call record(ierr == MPI_SUCCESS, "MPI_Comm_free comm")

    call MPI_Finalize(ierr)
    call record(ierr == MPI_SUCCESS, "MPI_Finalize")

    if (errors == 0) then
        if (rank == 0) print *, "Test passed"
    else
        print *, "Test failed on rank", rank, "with", errors, "errors"
        error stop 1
    end if

contains

    subroutine record(ok, label)
        logical, intent(in) :: ok
        character(len=*), intent(in) :: label

        if (.not. ok) then
            errors = errors + 1
            print *, "failure:", trim(label)
        end if
    end subroutine record

    subroutine expect_thread_error(rc, request, label)
        integer, intent(in) :: rc
        type(MPI_Request), intent(in) :: request
        character(len=*), intent(in) :: label
        integer :: class_ierr, error_class

        call record(rc /= MPI_SUCCESS, label // " error return")
        if (rc /= MPI_SUCCESS) then
            call MPI_Error_class(rc, error_class, class_ierr)
            call record(class_ierr == MPI_SUCCESS, label // " error class")
            call record(error_class == MPI_ERR_OTHER, &
                        label // " MPI_ERR_OTHER class")
        end if
        call record(request .eq. MPI_REQUEST_NULL, label // " request null")
    end subroutine expect_thread_error

    subroutine run_ialltoallw_error(comm)
        type(MPI_Comm), intent(in) :: comm
        integer :: i, int_bytes
        integer :: sendbuf(4), recvbuf(4)
        integer :: counts(4), bdispls(4)
        type(MPI_Datatype) :: types(4)
        type(MPI_Request) :: request

        counts = 1
        int_bytes = storage_size(sendbuf(1)) / 8
        bdispls = [(int_bytes * (i - 1), i = 1, 4)]
        types = MPI_INTEGER
        sendbuf = rank
        recvbuf = -1
        request = MPI_REQUEST_NULL

        call MPI_Ialltoallw(sendbuf, counts, bdispls, types, recvbuf, counts, &
                            bdispls, types, comm, request, ierr)
        call expect_thread_error(ierr, request, "MPI_Ialltoallw")
    end subroutine run_ialltoallw_error

    subroutine make_cart_comm(parent, newcomm)
        type(MPI_Comm), intent(in) :: parent
        type(MPI_Comm), intent(out) :: newcomm
        integer :: dims(1)
        logical :: periods(1)

        dims = [nranks]
        periods = [.true.]
        call MPI_Cart_create(parent, 1, dims, periods, .false., newcomm, ierr)
        call record(ierr == MPI_SUCCESS, "MPI_Cart_create")
    end subroutine make_cart_comm

    subroutine run_ineighbor_alltoallw_error(comm)
        type(MPI_Comm), intent(in) :: comm
        integer :: int_bytes
        integer :: sendbuf(2), recvbuf(2)
        integer :: counts(2)
        integer(kind=MPI_ADDRESS_KIND) :: adispls(2)
        type(MPI_Datatype) :: types(2)
        type(MPI_Request) :: request

        sendbuf = [10 * rank + 1, 10 * rank + 2]
        recvbuf = -1
        counts = 1
        int_bytes = storage_size(sendbuf(1)) / 8
        adispls = [0_MPI_ADDRESS_KIND, int(int_bytes, kind=MPI_ADDRESS_KIND)]
        types = MPI_INTEGER
        request = MPI_REQUEST_NULL

        call MPI_Ineighbor_alltoallw(sendbuf, counts, adispls, types, recvbuf, &
                                     counts, adispls, types, comm, request, &
                                     ierr)
        call expect_thread_error(ierr, request, "MPI_Ineighbor_alltoallw")
    end subroutine run_ineighbor_alltoallw_error

end program test_wcollective_thread_level_error
