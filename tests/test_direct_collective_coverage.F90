program test_direct_collective_coverage
    use mpi_f08
    implicit none

    integer :: ierr, provided, rank, nranks
    integer :: sum_ranks
    type(MPI_Comm) :: cart

    call MPI_Init_thread(MPI_THREAD_MULTIPLE, provided, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Init_thread")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_rank")
    call MPI_Comm_size(MPI_COMM_WORLD, nranks, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_size")
    call require(provided >= MPI_THREAD_MULTIPLE, "MPI_THREAD_MULTIPLE")
    call MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_set_errhandler world")
    call require(nranks == 4, "this test expects four ranks")
    sum_ranks = (nranks * (nranks + 1)) / 2

    call run_nonblocking_collectives()
    call run_persistent_collectives()
    call make_cart_comm(cart)
    call run_neighbor_collectives(cart)
    call MPI_Comm_free(cart, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_free cart")

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

    subroutine wait_request(req, label)
        type(MPI_Request), intent(inout) :: req
        character(len=*), intent(in) :: label

        call require(ierr == MPI_SUCCESS, label // " start")
        call MPI_Wait(req, MPI_STATUS_IGNORE, ierr)
        call require(ierr == MPI_SUCCESS, label // " wait")
    end subroutine wait_request

    logical function wait_request_maybe(req, label) result(ran)
        type(MPI_Request), intent(inout) :: req
        character(len=*), intent(in) :: label

        if (ierr == MPI_SUCCESS) then
            call MPI_Wait(req, MPI_STATUS_IGNORE, ierr)
            call require(ierr == MPI_SUCCESS, label // " wait")
            ran = .true.
        else
            call require(ierr == MPI_ERR_UNSUPPORTED_OPERATION, &
                         label // " unsupported")
            ran = .false.
        end if
    end function wait_request_maybe

    logical function run_persistent_request(req, label) result(ran)
        type(MPI_Request), intent(inout) :: req
        character(len=*), intent(in) :: label

        if (ierr == MPI_SUCCESS) then
            call MPI_Start(req, ierr)
            call require(ierr == MPI_SUCCESS, label // " start")
            call MPI_Wait(req, MPI_STATUS_IGNORE, ierr)
            call require(ierr == MPI_SUCCESS, label // " wait")
            call MPI_Request_free(req, ierr)
            call require(ierr == MPI_SUCCESS, label // " free")
            ran = .true.
        else
            call require(ierr == MPI_ERR_UNSUPPORTED_OPERATION, &
                         label // " unsupported")
            ran = .false.
        end if
    end function run_persistent_request

    subroutine fill_counts(counts, displs)
        integer, intent(out) :: counts(:), displs(:)
        integer :: i

        do i = 1, size(counts)
            counts(i) = 1
            displs(i) = i - 1
        end do
    end subroutine fill_counts

    subroutine fill_byte_displs(displs)
        integer, intent(out) :: displs(:)
        integer :: i, bytes
        integer :: sample

        bytes = storage_size(sample) / 8
        do i = 1, size(displs)
            displs(i) = (i - 1) * bytes
        end do
    end subroutine fill_byte_displs

    subroutine fill_aint_byte_displs(displs)
        integer(kind=MPI_ADDRESS_KIND), intent(out) :: displs(:)
        integer :: i, bytes
        integer :: sample

        bytes = storage_size(sample) / 8
        do i = 1, size(displs)
            displs(i) = int((i - 1) * bytes, MPI_ADDRESS_KIND)
        end do
    end subroutine fill_aint_byte_displs

    subroutine fill_types(types)
        type(MPI_Datatype), intent(out) :: types(:)
        integer :: i

        do i = 1, size(types)
            types(i) = MPI_INTEGER
        end do
    end subroutine fill_types

    subroutine run_nonblocking_collectives()
        type(MPI_Request) :: req
        integer :: send1, recv1, bcast1
        integer :: send4(4), recv4(4), expected4(4)
        integer :: counts(4), displs(4), bdispls(4)
        type(MPI_Datatype) :: types(4)
        integer :: i
        logical :: ran

        call fill_counts(counts, displs)
        call fill_byte_displs(bdispls)
        call fill_types(types)

        call MPI_Ibarrier(MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Ibarrier")

        bcast1 = -1
        if (rank == 0) bcast1 = 17
        call MPI_Ibcast(bcast1, 1, MPI_INTEGER, 0, MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Ibcast")
        call require(bcast1 == 17, "MPI_Ibcast payload")

        send1 = rank + 1
        recv1 = -1
        call MPI_Ireduce(send1, recv1, 1, MPI_INTEGER, MPI_SUM, 0, &
                         MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Ireduce")
        if (rank == 0) call require(recv1 == sum_ranks, "MPI_Ireduce payload")

        recv1 = -1
        call MPI_Iallreduce(send1, recv1, 1, MPI_INTEGER, MPI_SUM, &
                            MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Iallreduce")
        call require(recv1 == sum_ranks, "MPI_Iallreduce payload")

        recv1 = -1
        call MPI_Iscan(send1, recv1, 1, MPI_INTEGER, MPI_SUM, &
                       MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Iscan")
        call require(recv1 == ((rank + 1) * (rank + 2)) / 2, &
                     "MPI_Iscan payload")

        recv1 = -1
        call MPI_Iexscan(send1, recv1, 1, MPI_INTEGER, MPI_SUM, &
                         MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Iexscan")
        if (rank > 0) call require(recv1 == (rank * (rank + 1)) / 2, &
                                   "MPI_Iexscan payload")

        recv4 = -1
        call MPI_Igather(send1, 1, MPI_INTEGER, recv4, 1, MPI_INTEGER, 0, &
                         MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Igather")
        if (rank == 0) call require(all(recv4 == [1, 2, 3, 4]), &
                                    "MPI_Igather payload")

        send4 = [11, 12, 13, 14]
        recv1 = -1
        call MPI_Iscatter(send4, 1, MPI_INTEGER, recv1, 1, MPI_INTEGER, 0, &
                          MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Iscatter")
        call require(recv1 == 11 + rank, "MPI_Iscatter payload")

        recv4 = -1
        call MPI_Iallgather(send1, 1, MPI_INTEGER, recv4, 1, MPI_INTEGER, &
                            MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Iallgather")
        call require(all(recv4 == [1, 2, 3, 4]), "MPI_Iallgather payload")

        do i = 1, 4
            send4(i) = 100 * rank + i
            expected4(i) = 100 * (i - 1) + rank + 1
        end do
        recv4 = -1
        call MPI_Ialltoall(send4, 1, MPI_INTEGER, recv4, 1, MPI_INTEGER, &
                           MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Ialltoall")
        call require(all(recv4 == expected4), "MPI_Ialltoall payload")

        recv4 = -1
        call MPI_Igatherv(send1, 1, MPI_INTEGER, recv4, counts, displs, &
                          MPI_INTEGER, 0, MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Igatherv")
        if (rank == 0) call require(all(recv4 == [1, 2, 3, 4]), &
                                    "MPI_Igatherv payload")

        send4 = [21, 22, 23, 24]
        recv1 = -1
        call MPI_Iscatterv(send4, counts, displs, MPI_INTEGER, recv1, 1, &
                           MPI_INTEGER, 0, MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Iscatterv")
        call require(recv1 == 21 + rank, "MPI_Iscatterv payload")

        recv4 = -1
        call MPI_Iallgatherv(send1, 1, MPI_INTEGER, recv4, counts, displs, &
                             MPI_INTEGER, MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Iallgatherv")
        call require(all(recv4 == [1, 2, 3, 4]), "MPI_Iallgatherv payload")

        do i = 1, 4
            send4(i) = 200 * rank + i
            expected4(i) = 200 * (i - 1) + rank + 1
        end do
        recv4 = -1
        call MPI_Ialltoallv(send4, counts, displs, MPI_INTEGER, recv4, &
                            counts, displs, MPI_INTEGER, MPI_COMM_WORLD, &
                            req, ierr)
        call wait_request(req, "MPI_Ialltoallv")
        call require(all(recv4 == expected4), "MPI_Ialltoallv payload")

        recv4 = -1
        call MPI_Ialltoallw(send4, counts, bdispls, types, recv4, counts, &
                            bdispls, types, MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Ialltoallw")
        call require(all(recv4 == expected4), "MPI_Ialltoallw payload")

        send4 = rank + 1
        recv1 = -1
        call MPI_Ireduce_scatter(send4, recv1, counts, MPI_INTEGER, MPI_SUM, &
                                 MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Ireduce_scatter")
        call require(recv1 == sum_ranks, "MPI_Ireduce_scatter payload")

        recv1 = -1
        call MPI_Ireduce_scatter_block(send4, recv1, 1, MPI_INTEGER, &
                                       MPI_SUM, MPI_COMM_WORLD, req, ierr)
        call wait_request(req, "MPI_Ireduce_scatter_block")
        call require(recv1 == sum_ranks, &
                     "MPI_Ireduce_scatter_block payload")

        send1 = rank + 31
        recv1 = -1
        call MPI_Isendrecv(send1, 1, MPI_INTEGER, rank, 9, recv1, 1, &
                           MPI_INTEGER, rank, 9, MPI_COMM_WORLD, req, ierr)
        ran = wait_request_maybe(req, "MPI_Isendrecv")
        if (ran) call require(recv1 == rank + 31, "MPI_Isendrecv payload")

        recv1 = rank + 41
        call MPI_Isendrecv_replace(recv1, 1, MPI_INTEGER, rank, 10, rank, &
                                   10, MPI_COMM_WORLD, req, ierr)
        ran = wait_request_maybe(req, "MPI_Isendrecv_replace")
        if (ran) call require(recv1 == rank + 41, &
                              "MPI_Isendrecv_replace payload")
    end subroutine run_nonblocking_collectives

    subroutine run_persistent_collectives()
        type(MPI_Request) :: req
        integer :: send1, recv1, bcast1
        integer :: send4(4), recv4(4), counts(4), displs(4), bdispls(4)
        type(MPI_Datatype) :: types(4)
        logical :: ran

        call fill_counts(counts, displs)
        call fill_byte_displs(bdispls)
        call fill_types(types)
        send1 = rank + 1

        call MPI_Barrier_init(MPI_COMM_WORLD, MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Barrier_init")

        bcast1 = -1
        if (rank == 0) bcast1 = 71
        call MPI_Bcast_init(bcast1, 1, MPI_INTEGER, 0, MPI_COMM_WORLD, &
                            MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Bcast_init")
        if (ran) call require(bcast1 == 71, "MPI_Bcast_init payload")

        recv1 = -1
        call MPI_Reduce_init(send1, recv1, 1, MPI_INTEGER, MPI_SUM, 0, &
                             MPI_COMM_WORLD, MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Reduce_init")
        if (ran .and. rank == 0) call require(recv1 == sum_ranks, &
                                              "MPI_Reduce_init payload")

        recv1 = -1
        call MPI_Allreduce_init(send1, recv1, 1, MPI_INTEGER, MPI_SUM, &
                                MPI_COMM_WORLD, MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Allreduce_init")
        if (ran) call require(recv1 == sum_ranks, &
                              "MPI_Allreduce_init payload")

        recv1 = -1
        call MPI_Scan_init(send1, recv1, 1, MPI_INTEGER, MPI_SUM, &
                           MPI_COMM_WORLD, MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Scan_init")
        if (ran) call require(recv1 == ((rank + 1) * (rank + 2)) / 2, &
                              "MPI_Scan_init payload")

        recv1 = -1
        call MPI_Exscan_init(send1, recv1, 1, MPI_INTEGER, MPI_SUM, &
                             MPI_COMM_WORLD, MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Exscan_init")
        if (ran .and. rank > 0) call require(recv1 == (rank * (rank + 1)) / 2, &
                                             "MPI_Exscan_init payload")

        recv4 = -1
        call MPI_Gather_init(send1, 1, MPI_INTEGER, recv4, 1, MPI_INTEGER, &
                             0, MPI_COMM_WORLD, MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Gather_init")
        if (ran .and. rank == 0) call require(all(recv4 == [1, 2, 3, 4]), &
                                              "MPI_Gather_init payload")

        send4 = [31, 32, 33, 34]
        recv1 = -1
        call MPI_Scatter_init(send4, 1, MPI_INTEGER, recv1, 1, MPI_INTEGER, &
                              0, MPI_COMM_WORLD, MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Scatter_init")
        if (ran) call require(recv1 == 31 + rank, &
                              "MPI_Scatter_init payload")

        recv4 = -1
        call MPI_Allgather_init(send1, 1, MPI_INTEGER, recv4, 1, &
                                MPI_INTEGER, MPI_COMM_WORLD, MPI_INFO_NULL, &
                                req, ierr)
        ran = run_persistent_request(req, "MPI_Allgather_init")
        if (ran) call require(all(recv4 == [1, 2, 3, 4]), &
                              "MPI_Allgather_init payload")

        send4 = [rank * 10 + 1, rank * 10 + 2, rank * 10 + 3, rank * 10 + 4]
        recv4 = -1
        call MPI_Alltoall_init(send4, 1, MPI_INTEGER, recv4, 1, &
                               MPI_INTEGER, MPI_COMM_WORLD, MPI_INFO_NULL, &
                               req, ierr)
        ran = run_persistent_request(req, "MPI_Alltoall_init")
        if (ran) call require(all(recv4 == [rank + 1, 10 + rank + 1, &
                                            20 + rank + 1, 30 + rank + 1]), &
                              "MPI_Alltoall_init payload")

        call MPI_Gatherv_init(send1, 1, MPI_INTEGER, recv4, counts, displs, &
                              MPI_INTEGER, 0, MPI_COMM_WORLD, MPI_INFO_NULL, &
                              req, ierr)
        ran = run_persistent_request(req, "MPI_Gatherv_init")
        if (ran .and. rank == 0) call require(all(recv4 == [1, 2, 3, 4]), &
                                              "MPI_Gatherv_init payload")

        send4 = [41, 42, 43, 44]
        recv1 = -1
        call MPI_Scatterv_init(send4, counts, displs, MPI_INTEGER, recv1, &
                               1, MPI_INTEGER, 0, MPI_COMM_WORLD, &
                               MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Scatterv_init")
        if (ran) call require(recv1 == 41 + rank, &
                              "MPI_Scatterv_init payload")

        recv4 = -1
        call MPI_Allgatherv_init(send1, 1, MPI_INTEGER, recv4, counts, &
                                 displs, MPI_INTEGER, MPI_COMM_WORLD, &
                                 MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Allgatherv_init")
        if (ran) call require(all(recv4 == [1, 2, 3, 4]), &
                              "MPI_Allgatherv_init payload")

        send4 = [rank * 20 + 1, rank * 20 + 2, rank * 20 + 3, rank * 20 + 4]
        recv4 = -1
        call MPI_Alltoallv_init(send4, counts, displs, MPI_INTEGER, recv4, &
                                counts, displs, MPI_INTEGER, MPI_COMM_WORLD, &
                                MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Alltoallv_init")
        if (ran) call require(all(recv4 == [rank + 1, 20 + rank + 1, &
                                            40 + rank + 1, 60 + rank + 1]), &
                              "MPI_Alltoallv_init payload")

        send4 = rank + 1
        recv1 = -1
        call MPI_Reduce_scatter_init(send4, recv1, counts, MPI_INTEGER, &
                                     MPI_SUM, MPI_COMM_WORLD, MPI_INFO_NULL, &
                                     req, ierr)
        ran = run_persistent_request(req, "MPI_Reduce_scatter_init")
        if (ran) call require(recv1 == sum_ranks, &
                              "MPI_Reduce_scatter_init payload")

        recv1 = -1
        call MPI_Reduce_scatter_block_init(send4, recv1, 1, MPI_INTEGER, &
                                           MPI_SUM, MPI_COMM_WORLD, &
                                           MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Reduce_scatter_block_init")
        if (ran) call require(recv1 == sum_ranks, &
                              "MPI_Reduce_scatter_block_init payload")
    end subroutine run_persistent_collectives

    subroutine make_cart_comm(comm)
        type(MPI_Comm), intent(out) :: comm
        integer :: dims(1)
        logical :: periods(1)

        dims = [nranks]
        periods = [.true.]
        call MPI_Cart_create(MPI_COMM_WORLD, 1, dims, periods, .false., &
                             comm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Cart_create")
        call MPI_Comm_set_errhandler(comm, MPI_ERRORS_RETURN, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_set_errhandler cart")
    end subroutine make_cart_comm

    subroutine run_neighbor_collectives(comm)
        type(MPI_Comm), intent(in) :: comm
        type(MPI_Request) :: req
        integer :: left, right, send1
        integer :: send2(2), recv2(2), counts(2), displs(2)
        integer(kind=MPI_ADDRESS_KIND) :: adispls(2)
        type(MPI_Datatype) :: types(2)
        logical :: ran

        left = modulo(rank - 1, nranks)
        right = modulo(rank + 1, nranks)
        counts = [1, 1]
        displs = [0, 1]
        call fill_aint_byte_displs(adispls)
        types = [MPI_INTEGER, MPI_INTEGER]
        send1 = rank

        recv2 = -1
        call MPI_Neighbor_allgather(send1, 1, MPI_INTEGER, recv2, 1, &
                                    MPI_INTEGER, comm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Neighbor_allgather")
        call require(all(recv2 == [left, right]), &
                     "MPI_Neighbor_allgather payload")

        recv2 = -1
        call MPI_Ineighbor_allgather(send1, 1, MPI_INTEGER, recv2, 1, &
                                     MPI_INTEGER, comm, req, ierr)
        call wait_request(req, "MPI_Ineighbor_allgather")
        call require(all(recv2 == [left, right]), &
                     "MPI_Ineighbor_allgather payload")

        send2 = [10 * rank + 1, 10 * rank + 2]
        recv2 = -1
        call MPI_Neighbor_alltoall(send2, 1, MPI_INTEGER, recv2, 1, &
                                   MPI_INTEGER, comm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Neighbor_alltoall")
        call require(all(recv2 == [10 * left + 2, 10 * right + 1]), &
                     "MPI_Neighbor_alltoall payload")

        recv2 = -1
        call MPI_Ineighbor_alltoall(send2, 1, MPI_INTEGER, recv2, 1, &
                                    MPI_INTEGER, comm, req, ierr)
        call wait_request(req, "MPI_Ineighbor_alltoall")
        call require(all(recv2 == [10 * left + 2, 10 * right + 1]), &
                     "MPI_Ineighbor_alltoall payload")

        recv2 = -1
        call MPI_Neighbor_allgatherv(send1, 1, MPI_INTEGER, recv2, counts, &
                                     displs, MPI_INTEGER, comm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Neighbor_allgatherv")
        call require(all(recv2 == [left, right]), &
                     "MPI_Neighbor_allgatherv payload")

        recv2 = -1
        call MPI_Ineighbor_allgatherv(send1, 1, MPI_INTEGER, recv2, counts, &
                                      displs, MPI_INTEGER, comm, req, ierr)
        call wait_request(req, "MPI_Ineighbor_allgatherv")
        call require(all(recv2 == [left, right]), &
                     "MPI_Ineighbor_allgatherv payload")

        recv2 = -1
        call MPI_Neighbor_alltoallv(send2, counts, displs, MPI_INTEGER, &
                                    recv2, counts, displs, MPI_INTEGER, &
                                    comm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Neighbor_alltoallv")
        call require(all(recv2 == [10 * left + 2, 10 * right + 1]), &
                     "MPI_Neighbor_alltoallv payload")

        recv2 = -1
        call MPI_Ineighbor_alltoallv(send2, counts, displs, MPI_INTEGER, &
                                     recv2, counts, displs, MPI_INTEGER, &
                                     comm, req, ierr)
        call wait_request(req, "MPI_Ineighbor_alltoallv")
        call require(all(recv2 == [10 * left + 2, 10 * right + 1]), &
                     "MPI_Ineighbor_alltoallv payload")

        recv2 = -1
        call MPI_Neighbor_alltoallw(send2, counts, adispls, types, recv2, &
                                    counts, adispls, types, comm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Neighbor_alltoallw")
        call require(all(recv2 == [10 * left + 2, 10 * right + 1]), &
                     "MPI_Neighbor_alltoallw payload")

        recv2 = -1
        call MPI_Ineighbor_alltoallw(send2, counts, adispls, types, recv2, &
                                     counts, adispls, types, comm, req, ierr)
        call wait_request(req, "MPI_Ineighbor_alltoallw")
        call require(all(recv2 == [10 * left + 2, 10 * right + 1]), &
                     "MPI_Ineighbor_alltoallw payload")

        call MPI_Neighbor_allgather_init(send1, 1, MPI_INTEGER, recv2, 1, &
                                         MPI_INTEGER, comm, MPI_INFO_NULL, &
                                         req, ierr)
        ran = run_persistent_request(req, "MPI_Neighbor_allgather_init")
        if (ran) call require(all(recv2 == [left, right]), &
                              "MPI_Neighbor_allgather_init payload")

        call MPI_Neighbor_alltoall_init(send2, 1, MPI_INTEGER, recv2, 1, &
                                        MPI_INTEGER, comm, MPI_INFO_NULL, &
                                        req, ierr)
        ran = run_persistent_request(req, "MPI_Neighbor_alltoall_init")
        if (ran) call require(all(recv2 == [10 * left + 2, 10 * right + 1]), &
                              "MPI_Neighbor_alltoall_init payload")

        call MPI_Neighbor_allgatherv_init(send1, 1, MPI_INTEGER, recv2, &
                                          counts, displs, MPI_INTEGER, comm, &
                                          MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Neighbor_allgatherv_init")
        if (ran) call require(all(recv2 == [left, right]), &
                              "MPI_Neighbor_allgatherv_init payload")

        call MPI_Neighbor_alltoallv_init(send2, counts, displs, MPI_INTEGER, &
                                         recv2, counts, displs, MPI_INTEGER, &
                                         comm, MPI_INFO_NULL, req, ierr)
        ran = run_persistent_request(req, "MPI_Neighbor_alltoallv_init")
        if (ran) call require(all(recv2 == [10 * left + 2, 10 * right + 1]), &
                              "MPI_Neighbor_alltoallv_init payload")

    end subroutine run_neighbor_collectives

end program test_direct_collective_coverage
