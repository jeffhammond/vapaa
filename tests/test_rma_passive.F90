program main
    use mpi_f08
    use iso_c_binding, only: c_intptr_t, c_sizeof, c_ptr, c_f_pointer
    implicit none
    integer :: ierror, me, np, errs_local, errs_total, i
    integer, allocatable :: src(:), dst(:)
    integer, pointer :: window_buf(:)
    type(c_ptr) :: baseptr
    type(MPI_Win) :: win
    type(MPI_Request) :: req
    integer(kind=c_intptr_t) :: winsize, target_disp
    integer :: disp_unit

    call MPI_Init(ierror)
    call MPI_Comm_rank(MPI_COMM_WORLD, me)
    call MPI_Comm_size(MPI_COMM_WORLD, np)

    errs_local = 0
    disp_unit  = 4   ! MPI_INTEGER is 4 bytes per the standard

    ! Every rank allocates np ints; only rank 0's window is read/written by
    ! the test, the rest is just there to keep allocate semantics simple.
    winsize = int(np * disp_unit, c_intptr_t)
    call MPI_Win_allocate(winsize, disp_unit, MPI_INFO_NULL, MPI_COMM_WORLD, baseptr, win)
    call c_f_pointer(baseptr, window_buf, [np])
    window_buf = -1

    allocate(src(1), dst(1))
    src(1)      = me
    dst(1)      = -1
    target_disp = int(me, c_intptr_t)   ! offset is in disp_unit (= ints)

    call MPI_Barrier(MPI_COMM_WORLD)

    ! Rput: each rank writes its id into rank 0's window at slot `me`.
    call MPI_Win_lock(MPI_LOCK_SHARED, 0, 0, win)
    call MPI_Rput(src, 1, MPI_INTEGER, 0, target_disp, 1, MPI_INTEGER, win, req)
    call MPI_Wait(req, MPI_STATUS_IGNORE)
    call MPI_Win_flush(0, win)
    call MPI_Win_unlock(0, win)

    call MPI_Barrier(MPI_COMM_WORLD)

    if (me .eq. 0) then
        do i = 1, np
            if (window_buf(i) .ne. (i - 1)) then
                print *, 'rank 0: Rput verification failed at slot', i-1, &
                         'expected', i-1, 'got', window_buf(i)
                errs_local = errs_local + 1
            endif
        enddo
    endif

    call MPI_Barrier(MPI_COMM_WORLD)

    ! Rget: each rank reads its own slot back and checks it sees its id.
    call MPI_Win_lock(MPI_LOCK_SHARED, 0, 0, win)
    call MPI_Rget(dst, 1, MPI_INTEGER, 0, target_disp, 1, MPI_INTEGER, win, req)
    call MPI_Wait(req, MPI_STATUS_IGNORE)
    call MPI_Win_unlock(0, win)

    if (dst(1) .ne. me) then
        print *, 'rank', me, ': Rget verification failed; expected', me, 'got', dst(1)
        errs_local = errs_local + 1
    endif

    call MPI_Win_free(win)
    deallocate(src, dst)

    call MPI_Allreduce(errs_local, errs_total, 1, MPI_INTEGER, MPI_SUM, MPI_COMM_WORLD)
    if (me .eq. 0 .and. errs_total .eq. 0) print *, 'Test passed'

    call MPI_Finalize(ierror)
end program main
