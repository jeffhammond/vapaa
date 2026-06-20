program test_cfi_matrix_collectives
    use mpi_f08
    implicit none

    integer, parameter :: nrow = 4, ncol = 4, nelem = nrow * ncol
    integer :: ierr, rank, nranks

    call MPI_Init(ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Init")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_rank")
    call MPI_Comm_size(MPI_COMM_WORLD, nranks, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_size")
    call require(nranks == 4, "this test expects four ranks")

    call run_integer_patterns()
    call run_integer_reductions()

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

    subroutine run_integer_patterns()
        integer, target :: a(8, 8), contig(nrow, ncol)

        call fill_integer(a, rank)
        contig = a(1:nrow, 1:ncol)
        call run_integer_case("integer contig", 1, contig)
        call run_integer_case("integer column stride", 2, a(1:nrow, 1:8:2))
        call run_integer_case("integer row stride", 3, a(1:8:2, 1:ncol))
        call run_integer_case("integer checkerboard", 4, a(1:8:2, 1:8:2))
    end subroutine run_integer_patterns

    subroutine run_integer_case(label, pattern, sendbuf)
        character(len=*), intent(in) :: label
        integer, intent(in), asynchronous :: sendbuf(:, :)
        integer, intent(in) :: pattern
        integer :: root_expected(nrow, ncol)
        integer :: gathered(nrow, ncol * 4)
        integer :: gathered_expected(nrow, ncol * 4)
        integer :: alltoall_recv(nrow, ncol)
        integer :: alltoall_expected(nrow, ncol)

        call make_integer_block(0, pattern, root_expected)

        call run_integer_bcast(label // " bcast", pattern, root_expected)

        gathered = -1
        gathered_expected = -1
        call MPI_Gather(sendbuf, nelem, MPI_INTEGER, gathered, nelem, &
                        MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
        call require(ierr == MPI_SUCCESS, label // " gather")
        if (rank == 0) then
            call make_integer_gather_expected(pattern, gathered_expected)
            call require(all(gathered == gathered_expected), &
                         label // " gather payload")
        end if

        gathered = -1
        call MPI_Allgather(sendbuf, nelem, MPI_INTEGER, gathered, nelem, &
                           MPI_INTEGER, MPI_COMM_WORLD, ierr)
        call require(ierr == MPI_SUCCESS, label // " allgather")
        call make_integer_gather_expected(pattern, gathered_expected)
        call require(all(gathered == gathered_expected), &
                     label // " allgather payload")

        call run_integer_scatter(label // " scatter", pattern)

        alltoall_recv = -1
        call MPI_Alltoall(sendbuf, nelem / 4, MPI_INTEGER, alltoall_recv, &
                          nelem / 4, MPI_INTEGER, MPI_COMM_WORLD, ierr)
        call require(ierr == MPI_SUCCESS, label // " alltoall")
        call make_integer_alltoall_expected(pattern, alltoall_expected)
        call require(all(alltoall_recv == alltoall_expected), &
                     label // " alltoall payload")
    end subroutine run_integer_case

    subroutine run_integer_bcast(label, pattern, expected)
        character(len=*), intent(in) :: label
        integer, intent(in) :: pattern
        integer, intent(in) :: expected(:, :)
        integer, target :: matrix(8, 8), contig(nrow, ncol)

        matrix = -99
        contig = -99
        if (rank == 0) then
            select case (pattern)
            case (1)
                contig = expected
            case (2)
                matrix(1:nrow, 1:8:2) = expected
            case (3)
                matrix(1:8:2, 1:ncol) = expected
            case (4)
                matrix(1:8:2, 1:8:2) = expected
            end select
        end if

        select case (pattern)
        case (1)
            call MPI_Bcast(contig, nelem, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
            call require(all(contig == expected), label // " payload")
        case (2)
            call MPI_Bcast(matrix(1:nrow, 1:8:2), nelem, MPI_INTEGER, 0, &
                           MPI_COMM_WORLD, ierr)
            call require(all(matrix(1:nrow, 1:8:2) == expected), &
                         label // " payload")
        case (3)
            call MPI_Bcast(matrix(1:8:2, 1:ncol), nelem, MPI_INTEGER, 0, &
                           MPI_COMM_WORLD, ierr)
            call require(all(matrix(1:8:2, 1:ncol) == expected), &
                         label // " payload")
        case (4)
            call MPI_Bcast(matrix(1:8:2, 1:8:2), nelem, MPI_INTEGER, 0, &
                           MPI_COMM_WORLD, ierr)
            call require(all(matrix(1:8:2, 1:8:2) == expected), &
                         label // " payload")
        end select
        call require(ierr == MPI_SUCCESS, label)
    end subroutine run_integer_bcast

    subroutine run_integer_scatter(label, pattern)
        character(len=*), intent(in) :: label
        integer, intent(in) :: pattern
        integer :: sendbuf(nrow, ncol * 4)
        integer :: expected(nrow, ncol)
        integer, target :: matrix(8, 8), contig(nrow, ncol)

        sendbuf = -1
        if (rank == 0) call make_integer_gather_expected(pattern, sendbuf)
        call make_integer_block(rank, pattern, expected)
        matrix = -99
        contig = -99

        select case (pattern)
        case (1)
            call MPI_Scatter(sendbuf, nelem, MPI_INTEGER, contig, nelem, &
                             MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
            call require(all(contig == expected), label // " payload")
        case (2)
            call MPI_Scatter(sendbuf, nelem, MPI_INTEGER, &
                             matrix(1:nrow, 1:8:2), nelem, MPI_INTEGER, 0, &
                             MPI_COMM_WORLD, ierr)
            call require(all(matrix(1:nrow, 1:8:2) == expected), &
                         label // " payload")
        case (3)
            call MPI_Scatter(sendbuf, nelem, MPI_INTEGER, &
                             matrix(1:8:2, 1:ncol), nelem, MPI_INTEGER, 0, &
                             MPI_COMM_WORLD, ierr)
            call require(all(matrix(1:8:2, 1:ncol) == expected), &
                         label // " payload")
        case (4)
            call MPI_Scatter(sendbuf, nelem, MPI_INTEGER, &
                             matrix(1:8:2, 1:8:2), nelem, MPI_INTEGER, 0, &
                             MPI_COMM_WORLD, ierr)
            call require(all(matrix(1:8:2, 1:8:2) == expected), &
                         label // " payload")
        end select
        call require(ierr == MPI_SUCCESS, label)
    end subroutine run_integer_scatter

    subroutine run_integer_reductions()
        integer :: sendbuf(nrow, ncol), recvbuf(nrow, ncol)
        integer :: expected(nrow, ncol)
        integer :: i

        sendbuf = rank + 1
        recvbuf = -1
        expected = 0
        do i = 1, nranks
            expected = expected + i
        end do

        call MPI_Reduce(sendbuf, recvbuf, nelem, MPI_INTEGER, MPI_SUM, 0, &
                        MPI_COMM_WORLD, ierr)
        call require(ierr == MPI_SUCCESS, "integer reduce")
        if (rank == 0) call require(all(recvbuf == expected), &
                                    "integer reduce payload")

        recvbuf = -1
        call MPI_Allreduce(sendbuf, recvbuf, nelem, MPI_INTEGER, MPI_SUM, &
                           MPI_COMM_WORLD, ierr)
        call require(ierr == MPI_SUCCESS, "integer allreduce")
        call require(all(recvbuf == expected), "integer allreduce payload")

        call MPI_Scan(sendbuf, recvbuf, nelem, MPI_INTEGER, MPI_SUM, &
                      MPI_COMM_WORLD, ierr)
        call require(ierr == MPI_SUCCESS, "integer scan")
        call require(all(recvbuf == ((rank + 1) * (rank + 2)) / 2), &
                     "integer scan payload")

        recvbuf = -1
        call MPI_Exscan(sendbuf, recvbuf, nelem, MPI_INTEGER, MPI_SUM, &
                        MPI_COMM_WORLD, ierr)
        call require(ierr == MPI_SUCCESS, "integer exscan")
        if (rank > 0) then
            call require(all(recvbuf == (rank * (rank + 1)) / 2), &
                         "integer exscan payload")
        end if
    end subroutine run_integer_reductions

    subroutine make_integer_gather_expected(pattern, expected)
        integer, intent(in) :: pattern
        integer, intent(out) :: expected(nrow, ncol * 4)
        integer :: r

        do r = 0, 3
            call make_integer_block(r, pattern, &
                                    expected(:, r * ncol + 1:(r + 1) * ncol))
        end do
    end subroutine make_integer_gather_expected

    subroutine make_integer_alltoall_expected(pattern, expected)
        integer, intent(in) :: pattern
        integer, intent(out) :: expected(nrow, ncol)
        integer :: source_rank
        integer :: block(nrow, ncol)
        integer :: linear(nelem)

        do source_rank = 0, 3
            call make_integer_block(source_rank, pattern, block)
            linear = reshape(block, [nelem])
            expected(:, source_rank + 1) = &
                linear(rank * (nelem / 4) + 1:(rank + 1) * (nelem / 4))
        end do
    end subroutine make_integer_alltoall_expected

    subroutine make_integer_block(source_rank, pattern, block)
        integer, intent(in) :: source_rank, pattern
        integer, intent(out) :: block(nrow, ncol)
        integer :: tmp(8, 8)

        call fill_integer(tmp, source_rank)
        select case (pattern)
        case (1)
            block = tmp(1:nrow, 1:ncol)
        case (2)
            block = tmp(1:nrow, 1:8:2)
        case (3)
            block = tmp(1:8:2, 1:ncol)
        case (4)
            block = tmp(1:8:2, 1:8:2)
        end select
    end subroutine make_integer_block

    subroutine fill_integer(a, source_rank)
        integer, intent(out) :: a(:, :)
        integer, intent(in) :: source_rank
        integer :: i, j

        do j = 1, size(a, 2)
            do i = 1, size(a, 1)
                a(i, j) = 1000 * source_rank + 100 * j + i
            end do
        end do
    end subroutine fill_integer

end program test_cfi_matrix_collectives
