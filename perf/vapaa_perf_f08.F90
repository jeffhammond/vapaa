! SPDX-License-Identifier: MIT

program vapaa_perf_f08
    use mpi_f08
    use iso_fortran_env, only: int8, int64, real64
    implicit none

    integer :: ierr, rank, nprocs

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr)

    if (rank == 0) then
        write(*,'(a)') "# binding=" // binding_name()
        write(*,'(a)') "# columns=benchmark bytes iterations seconds latency_us message_rate_s bandwidth_MB_s"
    end if

    call bench_p2p_latency(rank, nprocs)
    call bench_p2p_rate(rank, nprocs)
    call bench_coll_bcast(rank, nprocs)
    call bench_coll_allreduce(rank, nprocs)
    call bench_coll_alltoall(rank, nprocs)
    call bench_rma_put(rank, nprocs)
    call bench_rma_get(rank, nprocs)

    call MPI_Finalize(ierr)

contains

    function binding_name() result(name)
        character(len=:), allocatable :: name
#ifdef VAPAA_PERF_BINDING
        name = VAPAA_PERF_BINDING
#else
        name = "unknown"
#endif
    end function binding_name

    integer function env_int(name, default_value)
        character(len=*), intent(in) :: name
        integer, intent(in) :: default_value
        character(len=64) :: value
        integer :: stat, parsed
        call get_environment_variable(name, value, status=stat)
        if (stat == 0) then
            read(value, *, iostat=stat) parsed
            if (stat == 0 .and. parsed > 0) then
                env_int = parsed
                return
            end if
        end if
        env_int = default_value
    end function env_int

    subroutine choose_loop(bytes, iterations, skip)
        integer, intent(in) :: bytes
        integer, intent(out) :: iterations, skip
        integer :: scale
        scale = max(1, bytes)
        iterations = max(100, min(200000, 2000000 / scale))
        skip = max(10, min(1000, iterations / 10))
        iterations = env_int("VAPAA_PERF_ITERS", iterations)
        skip = env_int("VAPAA_PERF_SKIP", skip)
    end subroutine choose_loop

    subroutine print_result(name, bytes, iterations, seconds, latency_us, message_rate, bandwidth)
        character(len=*), intent(in) :: name
        integer, intent(in) :: bytes, iterations
        real(real64), intent(in) :: seconds, latency_us, message_rate, bandwidth
        write(*,'(a,1x,i0,1x,i0,1x,es16.8,1x,es16.8,1x,es16.8,1x,es16.8)') &
            trim(name), bytes, iterations, seconds, latency_us, message_rate, bandwidth
    end subroutine print_result

    subroutine barrier()
        integer :: ierr
        call MPI_Barrier(MPI_COMM_WORLD, ierr)
    end subroutine barrier

    subroutine reduce_max_seconds(local_seconds, max_seconds)
        real(real64), intent(in) :: local_seconds
        real(real64), intent(out) :: max_seconds
        integer :: ierr
        call MPI_Reduce(local_seconds, max_seconds, 1, MPI_DOUBLE_PRECISION, MPI_MAX, 0, MPI_COMM_WORLD, ierr)
    end subroutine reduce_max_seconds

    subroutine bench_p2p_latency(rank, nprocs)
        integer, intent(in) :: rank, nprocs
        integer, parameter :: sizes(*) = [0, 1, 8, 64, 512, 4096, 32768, 262144]
        integer :: s, bytes, count, storage_count, i, iterations, skip, ierr, peer
        integer(int8), allocatable :: sbuf(:), rbuf(:)
        real(real64) :: t0, t1, seconds, max_seconds, latency_us, msg_rate, bandwidth

        if (nprocs < 2) return
        peer = merge(1, 0, rank == 0)

        do s = 1, size(sizes)
            bytes = sizes(s)
            count = bytes
            storage_count = max(1, count)
            allocate(sbuf(storage_count), rbuf(storage_count))
            sbuf = rank
            rbuf = -1
            call choose_loop(bytes, iterations, skip)
            call barrier()

            do i = 1, skip
                if (rank == 0) then
                    call MPI_Send(sbuf, count, MPI_BYTE, peer, 100, MPI_COMM_WORLD, ierr)
                    call MPI_Recv(rbuf, count, MPI_BYTE, peer, 101, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
                else if (rank == 1) then
                    call MPI_Recv(rbuf, count, MPI_BYTE, peer, 100, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
                    call MPI_Send(rbuf, count, MPI_BYTE, peer, 101, MPI_COMM_WORLD, ierr)
                end if
            end do
            call barrier()

            t0 = MPI_Wtime()
            do i = 1, iterations
                if (rank == 0) then
                    call MPI_Send(sbuf, count, MPI_BYTE, peer, 100, MPI_COMM_WORLD, ierr)
                    call MPI_Recv(rbuf, count, MPI_BYTE, peer, 101, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
                else if (rank == 1) then
                    call MPI_Recv(rbuf, count, MPI_BYTE, peer, 100, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
                    call MPI_Send(rbuf, count, MPI_BYTE, peer, 101, MPI_COMM_WORLD, ierr)
                end if
            end do
            t1 = MPI_Wtime()

            seconds = t1 - t0
            call reduce_max_seconds(seconds, max_seconds)
            seconds = max_seconds
            latency_us = seconds * 1.0e6_real64 / real(2 * iterations, real64)
            msg_rate = real(2 * iterations, real64) / seconds
            bandwidth = 2.0_real64 * real(iterations, real64) * real(bytes, real64) / seconds / 1.0e6_real64
            if (rank == 0) call print_result("p2p_pingpong", bytes, iterations, seconds, latency_us, msg_rate, bandwidth)
            deallocate(sbuf, rbuf)
        end do
    end subroutine bench_p2p_latency

    subroutine bench_p2p_rate(rank, nprocs)
        integer, intent(in) :: rank, nprocs
        integer, parameter :: sizes(*) = [8, 64, 512]
        integer, parameter :: window = 64
        integer :: s, bytes, count, i, j, iterations, skip, ierr, peer
        integer(int8), allocatable :: sbuf(:), rbuf(:)
        type(MPI_Request), allocatable :: reqs(:)
        real(real64) :: t0, t1, seconds, max_seconds, latency_us, msg_rate, bandwidth

        if (nprocs < 2) return
        peer = merge(1, 0, rank == 0)
        allocate(reqs(2 * window))

        do s = 1, size(sizes)
            bytes = sizes(s)
            count = bytes
            allocate(sbuf(count * window), rbuf(count * window))
            sbuf = rank
            rbuf = -1
            call choose_loop(bytes, iterations, skip)
            iterations = max(10, iterations / window)
            call barrier()

            do i = 1, skip
                if (rank < 2) then
                    do j = 1, window
                        call MPI_Irecv(rbuf((j - 1) * count + 1), count, MPI_BYTE, peer, 200 + j, MPI_COMM_WORLD, reqs(j), ierr)
                        call MPI_Isend(sbuf((j - 1) * count + 1), count, MPI_BYTE, peer, 200 + j, MPI_COMM_WORLD, reqs(window + j), ierr)
                    end do
                    call MPI_Waitall(2 * window, reqs, MPI_STATUSES_IGNORE, ierr)
                end if
            end do
            call barrier()

            if (rank < 2) then
                t0 = MPI_Wtime()
                do i = 1, iterations
                    do j = 1, window
                        call MPI_Irecv(rbuf((j - 1) * count + 1), count, MPI_BYTE, peer, 200 + j, MPI_COMM_WORLD, reqs(j), ierr)
                        call MPI_Isend(sbuf((j - 1) * count + 1), count, MPI_BYTE, peer, 200 + j, MPI_COMM_WORLD, reqs(window + j), ierr)
                    end do
                    call MPI_Waitall(2 * window, reqs, MPI_STATUSES_IGNORE, ierr)
                end do
                t1 = MPI_Wtime()
            else
                t0 = 0.0_real64
                t1 = 0.0_real64
            end if

            seconds = t1 - t0
            call reduce_max_seconds(seconds, max_seconds)
            seconds = max_seconds
            latency_us = seconds * 1.0e6_real64 / real(iterations, real64)
            msg_rate = real(2 * iterations * window, real64) / seconds
            bandwidth = 2.0_real64 * real(iterations, real64) * real(window, real64) * &
                real(bytes, real64) / seconds / 1.0e6_real64
            if (rank == 0) call print_result("p2p_message_rate", bytes, iterations * window, seconds, latency_us, msg_rate, bandwidth)
            deallocate(sbuf, rbuf)
        end do

        deallocate(reqs)
    end subroutine bench_p2p_rate

    subroutine bench_coll_bcast(rank, nprocs)
        integer, intent(in) :: rank, nprocs
        integer, parameter :: sizes(*) = [8, 64, 512, 4096, 32768, 262144]
        integer :: s, bytes, count, i, iterations, skip, ierr
        integer(int8), allocatable :: buf(:)
        real(real64) :: t0, t1, seconds, max_seconds, latency_us, msg_rate, bandwidth
        if (nprocs < 1) return

        do s = 1, size(sizes)
            bytes = sizes(s)
            count = bytes
            allocate(buf(count))
            buf = rank
            call choose_loop(bytes, iterations, skip)
            call barrier()
            do i = 1, skip
                call MPI_Bcast(buf, count, MPI_BYTE, 0, MPI_COMM_WORLD, ierr)
            end do
            call barrier()
            t0 = MPI_Wtime()
            do i = 1, iterations
                call MPI_Bcast(buf, count, MPI_BYTE, 0, MPI_COMM_WORLD, ierr)
            end do
            t1 = MPI_Wtime()
            seconds = t1 - t0
            call reduce_max_seconds(seconds, max_seconds)
            seconds = max_seconds
            latency_us = seconds * 1.0e6_real64 / real(iterations, real64)
            msg_rate = real(iterations, real64) / seconds
            bandwidth = real(iterations, real64) * real(bytes, real64) * &
                real(max(1, nprocs - 1), real64) / seconds / 1.0e6_real64
            if (rank == 0) call print_result("coll_bcast", bytes, iterations, seconds, latency_us, msg_rate, bandwidth)
            deallocate(buf)
        end do
    end subroutine bench_coll_bcast

    subroutine bench_coll_allreduce(rank, nprocs)
        integer, intent(in) :: rank, nprocs
        integer, parameter :: sizes(*) = [8, 64, 512, 4096, 32768, 262144]
        integer :: s, bytes, count, i, iterations, skip, ierr
        integer(int64), allocatable :: sbuf(:), rbuf(:)
        real(real64) :: t0, t1, seconds, max_seconds, latency_us, msg_rate, bandwidth
        if (nprocs < 1) return

        do s = 1, size(sizes)
            bytes = sizes(s)
            count = bytes / 8
            allocate(sbuf(count), rbuf(count))
            sbuf = rank + 1
            rbuf = 0
            call choose_loop(bytes, iterations, skip)
            call barrier()
            do i = 1, skip
                call MPI_Allreduce(sbuf, rbuf, count, MPI_INTEGER8, MPI_SUM, MPI_COMM_WORLD, ierr)
            end do
            call barrier()
            t0 = MPI_Wtime()
            do i = 1, iterations
                call MPI_Allreduce(sbuf, rbuf, count, MPI_INTEGER8, MPI_SUM, MPI_COMM_WORLD, ierr)
            end do
            t1 = MPI_Wtime()
            seconds = t1 - t0
            call reduce_max_seconds(seconds, max_seconds)
            seconds = max_seconds
            latency_us = seconds * 1.0e6_real64 / real(iterations, real64)
            msg_rate = real(iterations, real64) / seconds
            bandwidth = real(iterations, real64) * real(bytes, real64) / seconds / 1.0e6_real64
            if (rank == 0) call print_result("coll_allreduce", bytes, iterations, seconds, latency_us, msg_rate, bandwidth)
            deallocate(sbuf, rbuf)
        end do
    end subroutine bench_coll_allreduce

    subroutine bench_coll_alltoall(rank, nprocs)
        integer, intent(in) :: rank, nprocs
        integer, parameter :: sizes(*) = [8, 64, 512, 4096]
        integer :: s, bytes, elem_count, total_count, i, iterations, skip, ierr
        integer(int8), allocatable :: sbuf(:), rbuf(:)
        real(real64) :: t0, t1, seconds, max_seconds, latency_us, msg_rate, bandwidth
        if (nprocs < 2) return

        do s = 1, size(sizes)
            bytes = sizes(s)
            elem_count = bytes
            total_count = elem_count * nprocs
            allocate(sbuf(total_count), rbuf(total_count))
            sbuf = rank + 1
            rbuf = 0
            call choose_loop(bytes, iterations, skip)
            iterations = max(100, iterations / max(1, nprocs))
            call barrier()
            do i = 1, skip
                call MPI_Alltoall(sbuf, elem_count, MPI_BYTE, rbuf, elem_count, MPI_BYTE, MPI_COMM_WORLD, ierr)
            end do
            call barrier()
            t0 = MPI_Wtime()
            do i = 1, iterations
                call MPI_Alltoall(sbuf, elem_count, MPI_BYTE, rbuf, elem_count, MPI_BYTE, MPI_COMM_WORLD, ierr)
            end do
            t1 = MPI_Wtime()
            seconds = t1 - t0
            call reduce_max_seconds(seconds, max_seconds)
            seconds = max_seconds
            latency_us = seconds * 1.0e6_real64 / real(iterations, real64)
            msg_rate = real(iterations * nprocs * max(0, nprocs - 1), real64) / seconds
            bandwidth = real(iterations, real64) * real(bytes, real64) * real(nprocs, real64) * &
                real(max(0, nprocs - 1), real64) / seconds / 1.0e6_real64
            if (rank == 0) call print_result("coll_alltoall", bytes, iterations, seconds, latency_us, msg_rate, bandwidth)
            deallocate(sbuf, rbuf)
        end do
    end subroutine bench_coll_alltoall

    subroutine bench_rma_put(rank, nprocs)
        integer, intent(in) :: rank, nprocs
        integer, parameter :: sizes(*) = [8, 64, 512, 4096, 32768]
        integer :: s, bytes, count, i, iterations, skip, ierr, target
        integer(int8), allocatable, target :: winbuf(:)
        integer(int8), allocatable :: sbuf(:)
        type(MPI_Win) :: win
        real(real64) :: t0, t1, seconds, max_seconds, latency_us, msg_rate, bandwidth
        if (nprocs < 2) return
        target = merge(1, 0, rank == 0)

        do s = 1, size(sizes)
            bytes = sizes(s)
            count = bytes
            allocate(winbuf(count), sbuf(count))
            winbuf = 0
            sbuf = rank + 1
            call MPI_Win_create(winbuf, int(count, MPI_ADDRESS_KIND), 1, MPI_INFO_NULL, MPI_COMM_WORLD, win, ierr)
            call choose_loop(bytes, iterations, skip)
            call barrier()
            do i = 1, skip
                if (rank < 2) then
                    call MPI_Win_lock(MPI_LOCK_SHARED, target, 0, win, ierr)
                    call MPI_Put(sbuf, count, MPI_BYTE, target, 0_MPI_ADDRESS_KIND, count, MPI_BYTE, win, ierr)
                    call MPI_Win_unlock(target, win, ierr)
                end if
            end do
            call barrier()
            t0 = MPI_Wtime()
            do i = 1, iterations
                if (rank < 2) then
                    call MPI_Win_lock(MPI_LOCK_SHARED, target, 0, win, ierr)
                    call MPI_Put(sbuf, count, MPI_BYTE, target, 0_MPI_ADDRESS_KIND, count, MPI_BYTE, win, ierr)
                    call MPI_Win_unlock(target, win, ierr)
                end if
            end do
            t1 = MPI_Wtime()
            seconds = t1 - t0
            call reduce_max_seconds(seconds, max_seconds)
            seconds = max_seconds
            latency_us = seconds * 1.0e6_real64 / real(iterations, real64)
            msg_rate = real(iterations, real64) / seconds
            bandwidth = real(iterations, real64) * real(bytes, real64) / seconds / 1.0e6_real64
            if (rank == 0) call print_result("rma_put_lock_unlock", bytes, iterations, seconds, latency_us, msg_rate, bandwidth)
            call MPI_Win_free(win, ierr)
            deallocate(winbuf, sbuf)
        end do
    end subroutine bench_rma_put

    subroutine bench_rma_get(rank, nprocs)
        integer, intent(in) :: rank, nprocs
        integer, parameter :: sizes(*) = [8, 64, 512, 4096, 32768]
        integer :: s, bytes, count, i, iterations, skip, ierr, target
        integer(int8), allocatable, target :: winbuf(:)
        integer(int8), allocatable :: rbuf(:)
        type(MPI_Win) :: win
        real(real64) :: t0, t1, seconds, max_seconds, latency_us, msg_rate, bandwidth
        if (nprocs < 2) return
        target = merge(1, 0, rank == 0)

        do s = 1, size(sizes)
            bytes = sizes(s)
            count = bytes
            allocate(winbuf(count), rbuf(count))
            winbuf = rank + 10
            rbuf = 0
            call MPI_Win_create(winbuf, int(count, MPI_ADDRESS_KIND), 1, MPI_INFO_NULL, MPI_COMM_WORLD, win, ierr)
            call choose_loop(bytes, iterations, skip)
            call barrier()
            do i = 1, skip
                if (rank < 2) then
                    call MPI_Win_lock(MPI_LOCK_SHARED, target, 0, win, ierr)
                    call MPI_Get(rbuf, count, MPI_BYTE, target, 0_MPI_ADDRESS_KIND, count, MPI_BYTE, win, ierr)
                    call MPI_Win_unlock(target, win, ierr)
                end if
            end do
            call barrier()
            t0 = MPI_Wtime()
            do i = 1, iterations
                if (rank < 2) then
                    call MPI_Win_lock(MPI_LOCK_SHARED, target, 0, win, ierr)
                    call MPI_Get(rbuf, count, MPI_BYTE, target, 0_MPI_ADDRESS_KIND, count, MPI_BYTE, win, ierr)
                    call MPI_Win_unlock(target, win, ierr)
                end if
            end do
            t1 = MPI_Wtime()
            seconds = t1 - t0
            call reduce_max_seconds(seconds, max_seconds)
            seconds = max_seconds
            latency_us = seconds * 1.0e6_real64 / real(iterations, real64)
            msg_rate = real(iterations, real64) / seconds
            bandwidth = real(iterations, real64) * real(bytes, real64) / seconds / 1.0e6_real64
            if (rank == 0) call print_result("rma_get_lock_unlock", bytes, iterations, seconds, latency_us, msg_rate, bandwidth)
            call MPI_Win_free(win, ierr)
            deallocate(winbuf, rbuf)
        end do
    end subroutine bench_rma_get

end program vapaa_perf_f08
