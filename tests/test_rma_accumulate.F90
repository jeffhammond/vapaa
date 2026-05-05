program main
    use mpi_f08
    use iso_c_binding, only: c_intptr_t, c_sizeof
    implicit none
    integer :: ierror, me, np, errs_local, errs_total, expected
    integer, allocatable, target :: counter(:)
    integer :: contrib(1), got(1)
    type(MPI_Win) :: win
    integer(kind=c_intptr_t) :: winsize, target_disp
    integer :: disp_unit

    call MPI_Init(ierror)
    call MPI_Comm_rank(MPI_COMM_WORLD, me)
    call MPI_Comm_size(MPI_COMM_WORLD, np)

    errs_local = 0
    allocate(counter(1))
    counter(1) = 0

    disp_unit   = int(c_sizeof(counter(1)))
    winsize     = int(disp_unit, c_intptr_t)
    target_disp = 0_c_intptr_t

    call MPI_Win_create(counter, winsize, disp_unit, MPI_INFO_NULL, MPI_COMM_WORLD, win)

    ! Accumulate: every rank sums its rank id into rank 0's counter.
    call MPI_Win_fence(0, win)
    contrib(1) = me
    call MPI_Accumulate(contrib, 1, MPI_INTEGER, 0, target_disp, 1, MPI_INTEGER, MPI_SUM, win)
    call MPI_Win_fence(0, win)

    if (me .eq. 0) then
        expected = (np * (np - 1)) / 2
        if (counter(1) .ne. expected) then
            print *, 'rank 0: MPI_Accumulate failed; expected', expected, 'got', counter(1)
            errs_local = errs_local + 1
        endif
        counter(1) = 0
    endif

    ! Fetch_and_op: every rank atomically adds 1 to rank 0's counter under
    ! lock_all/unlock_all. After everyone is done, the counter holds np.
    call MPI_Win_fence(0, win)

    contrib(1) = 1
    got(1)     = -1
    call MPI_Win_lock_all(0, win)
    call MPI_Fetch_and_op(contrib, got, MPI_INTEGER, 0, target_disp, MPI_SUM, win)
    call MPI_Win_flush(0, win)
    call MPI_Win_unlock_all(win)

    call MPI_Barrier(MPI_COMM_WORLD)

    if (me .eq. 0 .and. counter(1) .ne. np) then
        print *, 'rank 0: Fetch_and_op final counter wrong; expected', np, 'got', counter(1)
        errs_local = errs_local + 1
    endif

    if (got(1) .lt. 0 .or. got(1) .ge. np) then
        print *, 'rank', me, ': Fetch_and_op fetched out-of-range value', got(1)
        errs_local = errs_local + 1
    endif

    call MPI_Win_free(win)
    deallocate(counter)

    call MPI_Allreduce(errs_local, errs_total, 1, MPI_INTEGER, MPI_SUM, MPI_COMM_WORLD)
    if (me .eq. 0 .and. errs_total .eq. 0) print *, 'Test passed'

    call MPI_Finalize(ierror)
end program main
