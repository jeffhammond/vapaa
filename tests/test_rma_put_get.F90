program main
    use mpi_f08
    use iso_c_binding, only: c_intptr_t, c_sizeof
    implicit none
    integer :: ierror, me, np, errs_local, errs_total
    integer, parameter :: n = 16
    integer, allocatable, target :: buf(:)
    integer, allocatable :: src(:), got(:)
    type(MPI_Win) :: win
    integer(kind=c_intptr_t) :: winsize, target_disp
    integer :: disp_unit, right, left

    call MPI_Init(ierror)
    call MPI_Comm_rank(MPI_COMM_WORLD, me)
    call MPI_Comm_size(MPI_COMM_WORLD, np)

    errs_local = 0
    right = mod(me + 1, np)
    left  = mod(me + np - 1, np)

    allocate(buf(n), src(n), got(n))
    buf = me
    src = me
    got = -1

    disp_unit   = int(c_sizeof(buf(1)))
    winsize     = int(n, c_intptr_t) * int(disp_unit, c_intptr_t)
    target_disp = 0_c_intptr_t

    call MPI_Win_create(buf, winsize, disp_unit, MPI_INFO_NULL, MPI_COMM_WORLD, win)

    ! Put: each rank writes its rank id into the right neighbor's window.
    ! After the closing fence, my buf should hold the value 'left' put.
    call MPI_Win_fence(0, win)
    call MPI_Put(src, n, MPI_INTEGER, right, target_disp, n, MPI_INTEGER, win)
    call MPI_Win_fence(0, win)

    if (any(buf .ne. left)) then
        print *, 'rank', me, ': MPI_Put failed; expected', left, 'got', buf(1)
        errs_local = errs_local + 1
    endif

    ! Reset windows so each rank's buf is its own rank id again.
    buf = me
    call MPI_Win_fence(0, win)

    ! Get: read right neighbor's buf into local 'got'.
    call MPI_Get(got, n, MPI_INTEGER, right, target_disp, n, MPI_INTEGER, win)
    call MPI_Win_fence(0, win)

    if (any(got .ne. right)) then
        print *, 'rank', me, ': MPI_Get failed; expected', right, 'got', got(1)
        errs_local = errs_local + 1
    endif

    call MPI_Win_free(win)
    deallocate(buf, src, got)

    call MPI_Allreduce(errs_local, errs_total, 1, MPI_INTEGER, MPI_SUM, MPI_COMM_WORLD)
    if (me .eq. 0 .and. errs_total .eq. 0) print *, 'Test passed'

    call MPI_Finalize(ierror)
end program main
