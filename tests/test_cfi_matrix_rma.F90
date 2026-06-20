program test_cfi_matrix_rma
    use mpi_f08
    implicit none

    integer, parameter :: nrow = 4, ncol = 4, nelem = nrow * ncol
    integer :: ierr, rank, disp_unit
    integer(kind=MPI_ADDRESS_KIND) :: win_size
    integer, target :: winbuf(nelem)
    type(MPI_Win) :: win

    call MPI_Init(ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Init")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_rank")

    disp_unit = storage_size(winbuf(1)) / 8
    win_size = int(nelem * disp_unit, MPI_ADDRESS_KIND)
    winbuf = -1
    call MPI_Win_create(winbuf, win_size, disp_unit, MPI_INFO_NULL, &
                        MPI_COMM_WORLD, win, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Win_create")

    call run_integer_patterns()

    call MPI_Win_free(win, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Win_free")

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
        integer, target :: a(8, 8), contig(nrow, ncol), expected(nrow, ncol)

        call fill_integer(a)
        contig = a(1:nrow, 1:ncol)
        call run_integer_case("integer contig", contig, contig)
        expected = a(1:nrow, 1:8:2)
        call run_integer_case("integer column stride", a(1:nrow, 1:8:2), &
                              expected)
        expected = a(1:8:2, 1:ncol)
        call run_integer_case("integer row stride", a(1:8:2, 1:ncol), &
                              expected)
        expected = a(1:8:2, 1:8:2)
        call run_integer_case("integer checkerboard", a(1:8:2, 1:8:2), &
                              expected)
    end subroutine run_integer_patterns

    subroutine run_integer_case(label, origin, expected)
        character(len=*), intent(in) :: label
        integer, intent(in), asynchronous :: origin(:, :), expected(:, :)

        call run_put(label, origin, expected)
        call run_get(label, expected)
        call run_accumulate(label, origin, expected)
        call run_get_accumulate(label, origin, expected)
        call run_rput(label, origin, expected)
        call run_rget(label, expected)
        call run_raccumulate(label, origin, expected)
        call run_rget_accumulate(label, origin, expected)
    end subroutine run_integer_case

    subroutine run_put(label, origin, expected)
        character(len=*), intent(in) :: label
        integer, intent(in), asynchronous :: origin(:, :), expected(:, :)

        winbuf = -1
        call lock_self(label // " put lock")
        call MPI_Put(origin, nelem, MPI_INTEGER, rank, 0_MPI_ADDRESS_KIND, &
                     nelem, MPI_INTEGER, win, ierr)
        call require(ierr == MPI_SUCCESS, label // " put")
        call unlock_self(label // " put unlock")
        call require(all(reshape(winbuf, [nrow, ncol]) == expected), &
                     label // " put payload")
    end subroutine run_put

    subroutine run_get(label, expected)
        character(len=*), intent(in) :: label
        integer, intent(in) :: expected(:, :)
        integer, target :: matrix(8, 8)

        winbuf = reshape(expected, [nelem])
        matrix = -9999
        call lock_self(label // " get lock")
        call MPI_Get(matrix(1:nrow, 1:8:2), nelem, MPI_INTEGER, rank, &
                     0_MPI_ADDRESS_KIND, nelem, MPI_INTEGER, win, ierr)
        call require(ierr == MPI_SUCCESS, label // " get")
        call unlock_self(label // " get unlock")
        call require(all(matrix(1:nrow, 1:8:2) == expected), &
                     label // " get payload")
    end subroutine run_get

    subroutine run_accumulate(label, origin, expected)
        character(len=*), intent(in) :: label
        integer, intent(in), asynchronous :: origin(:, :), expected(:, :)
        integer :: base(nrow, ncol)

        base = 10
        winbuf = reshape(base, [nelem])
        call lock_self(label // " accumulate lock")
        call MPI_Accumulate(origin, nelem, MPI_INTEGER, rank, &
                            0_MPI_ADDRESS_KIND, nelem, MPI_INTEGER, MPI_SUM, &
                            win, ierr)
        call require(ierr == MPI_SUCCESS, label // " accumulate")
        call unlock_self(label // " accumulate unlock")
        call require(all(reshape(winbuf, [nrow, ncol]) == base + expected), &
                     label // " accumulate payload")
    end subroutine run_accumulate

    subroutine run_get_accumulate(label, origin, expected)
        character(len=*), intent(in) :: label
        integer, intent(in), asynchronous :: origin(:, :), expected(:, :)
        integer, target :: result_matrix(8, 8)
        integer :: old(nrow, ncol)

        old = 20
        winbuf = reshape(old, [nelem])
        result_matrix = -9999
        call lock_self(label // " get_accumulate lock")
        call MPI_Get_accumulate(origin, nelem, MPI_INTEGER, &
                                result_matrix(1:8:2, 1:ncol), nelem, &
                                MPI_INTEGER, rank, 0_MPI_ADDRESS_KIND, nelem, &
                                MPI_INTEGER, MPI_SUM, win, ierr)
        call require(ierr == MPI_SUCCESS, label // " get_accumulate")
        call unlock_self(label // " get_accumulate unlock")
        call require(all(result_matrix(1:8:2, 1:ncol) == old), &
                     label // " get_accumulate result payload")
        call require(all(reshape(winbuf, [nrow, ncol]) == old + expected), &
                     label // " get_accumulate target payload")
    end subroutine run_get_accumulate

    subroutine run_rput(label, origin, expected)
        character(len=*), intent(in) :: label
        integer, intent(in), asynchronous :: origin(:, :), expected(:, :)
        type(MPI_Request) :: request

        winbuf = -1
        call lock_self(label // " rput lock")
        call MPI_Rput(origin, nelem, MPI_INTEGER, rank, 0_MPI_ADDRESS_KIND, &
                      nelem, MPI_INTEGER, win, request, ierr)
        call require(ierr == MPI_SUCCESS, label // " rput")
        call MPI_Wait(request, MPI_STATUS_IGNORE, ierr)
        call require(ierr == MPI_SUCCESS, label // " rput wait")
        call unlock_self(label // " rput unlock")
        call require(all(reshape(winbuf, [nrow, ncol]) == expected), &
                     label // " rput payload")
    end subroutine run_rput

    subroutine run_rget(label, expected)
        character(len=*), intent(in) :: label
        integer, intent(in) :: expected(:, :)
        integer, target :: matrix(8, 8)
        type(MPI_Request) :: request

        winbuf = reshape(expected, [nelem])
        matrix = -9999
        call lock_self(label // " rget lock")
        call MPI_Rget(matrix(1:nrow, 1:8:2), nelem, MPI_INTEGER, rank, &
                      0_MPI_ADDRESS_KIND, nelem, MPI_INTEGER, win, request, &
                      ierr)
        call require(ierr == MPI_SUCCESS, label // " rget")
        call MPI_Wait(request, MPI_STATUS_IGNORE, ierr)
        call require(ierr == MPI_SUCCESS, label // " rget wait")
        call unlock_self(label // " rget unlock")
        call require(all(matrix(1:nrow, 1:8:2) == expected), &
                     label // " rget payload")
    end subroutine run_rget

    subroutine run_raccumulate(label, origin, expected)
        character(len=*), intent(in) :: label
        integer, intent(in), asynchronous :: origin(:, :), expected(:, :)
        integer :: base(nrow, ncol)
        type(MPI_Request) :: request

        base = 30
        winbuf = reshape(base, [nelem])
        call lock_self(label // " raccumulate lock")
        call MPI_Raccumulate(origin, nelem, MPI_INTEGER, rank, &
                             0_MPI_ADDRESS_KIND, nelem, MPI_INTEGER, MPI_SUM, &
                             win, request, ierr)
        call require(ierr == MPI_SUCCESS, label // " raccumulate")
        call MPI_Wait(request, MPI_STATUS_IGNORE, ierr)
        call require(ierr == MPI_SUCCESS, label // " raccumulate wait")
        call unlock_self(label // " raccumulate unlock")
        call require(all(reshape(winbuf, [nrow, ncol]) == base + expected), &
                     label // " raccumulate payload")
    end subroutine run_raccumulate

    subroutine run_rget_accumulate(label, origin, expected)
        character(len=*), intent(in) :: label
        integer, intent(in), asynchronous :: origin(:, :), expected(:, :)
        integer, target :: result_matrix(8, 8)
        integer :: old(nrow, ncol)
        type(MPI_Request) :: request

        old = 40
        winbuf = reshape(old, [nelem])
        result_matrix = -9999
        call lock_self(label // " rget_accumulate lock")
        call MPI_Rget_accumulate(origin, nelem, MPI_INTEGER, &
                                 result_matrix(1:8:2, 1:ncol), nelem, &
                                 MPI_INTEGER, rank, 0_MPI_ADDRESS_KIND, &
                                 nelem, MPI_INTEGER, MPI_SUM, win, request, &
                                 ierr)
        call require(ierr == MPI_SUCCESS, label // " rget_accumulate")
        call MPI_Wait(request, MPI_STATUS_IGNORE, ierr)
        call require(ierr == MPI_SUCCESS, label // " rget_accumulate wait")
        call unlock_self(label // " rget_accumulate unlock")
        call require(all(result_matrix(1:8:2, 1:ncol) == old), &
                     label // " rget_accumulate result payload")
        call require(all(reshape(winbuf, [nrow, ncol]) == old + expected), &
                     label // " rget_accumulate target payload")
    end subroutine run_rget_accumulate

    subroutine lock_self(label)
        character(len=*), intent(in) :: label

        call MPI_Win_lock(MPI_LOCK_EXCLUSIVE, rank, 0, win, ierr)
        call require(ierr == MPI_SUCCESS, label)
    end subroutine lock_self

    subroutine unlock_self(label)
        character(len=*), intent(in) :: label

        call MPI_Win_unlock(rank, win, ierr)
        call require(ierr == MPI_SUCCESS, label)
    end subroutine unlock_self

    subroutine fill_integer(a)
        integer, intent(out) :: a(:, :)
        integer :: i, j

        do j = 1, size(a, 2)
            do i = 1, size(a, 1)
                a(i, j) = 1000 * rank + 100 * j + i
            end do
        end do
    end subroutine fill_integer

end program test_cfi_matrix_rma
