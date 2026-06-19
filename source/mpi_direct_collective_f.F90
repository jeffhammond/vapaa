! SPDX-License-Identifier: MIT

module mpi_direct_collective_f
    use iso_c_binding, only: c_int, c_intptr_t
    use mpi_global_constants, only: MPI_ADDRESS_KIND
    use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Info, MPI_Op, MPI_Request
    implicit none

#if defined(HAVE_CFI) || defined(HAVE_PGIF)
    interface MPI_Alltoallw
        module procedure MPI_Alltoallw_f08ts
    end interface
    interface MPI_Ibarrier
        module procedure MPI_Ibarrier_f08
    end interface
    interface MPI_Ibcast
        module procedure MPI_Ibcast_f08ts
    end interface
    interface MPI_Iallreduce
        module procedure MPI_Iallreduce_f08ts
    end interface
    interface MPI_Ireduce
        module procedure MPI_Ireduce_f08ts
    end interface
    interface MPI_Igather
        module procedure MPI_Igather_f08ts
    end interface
    interface MPI_Igatherv
        module procedure MPI_Igatherv_f08ts
    end interface
    interface MPI_Iallgather
        module procedure MPI_Iallgather_f08ts
    end interface
    interface MPI_Iallgatherv
        module procedure MPI_Iallgatherv_f08ts
    end interface
    interface MPI_Iscatter
        module procedure MPI_Iscatter_f08ts
    end interface
    interface MPI_Iscatterv
        module procedure MPI_Iscatterv_f08ts
    end interface
    interface MPI_Ialltoall
        module procedure MPI_Ialltoall_f08ts
    end interface
    interface MPI_Ialltoallv
        module procedure MPI_Ialltoallv_f08ts
    end interface
    interface MPI_Ialltoallw
        module procedure MPI_Ialltoallw_f08ts
    end interface
    interface MPI_Iscan
        module procedure MPI_Iscan_f08ts
    end interface
    interface MPI_Iexscan
        module procedure MPI_Iexscan_f08ts
    end interface
    interface MPI_Ireduce_scatter
        module procedure MPI_Ireduce_scatter_f08ts
    end interface
    interface MPI_Ireduce_scatter_block
        module procedure MPI_Ireduce_scatter_block_f08ts
    end interface
    interface MPI_Isendrecv
        module procedure MPI_Isendrecv_f08ts
    end interface
    interface MPI_Isendrecv_replace
        module procedure MPI_Isendrecv_replace_f08ts
    end interface

    interface MPI_Barrier_init
        module procedure MPI_Barrier_init_f08
    end interface
    interface MPI_Bcast_init
        module procedure MPI_Bcast_init_f08ts
    end interface
    interface MPI_Allreduce_init
        module procedure MPI_Allreduce_init_f08ts
    end interface
    interface MPI_Reduce_init
        module procedure MPI_Reduce_init_f08ts
    end interface
    interface MPI_Gather_init
        module procedure MPI_Gather_init_f08ts
    end interface
    interface MPI_Gatherv_init
        module procedure MPI_Gatherv_init_f08ts
    end interface
    interface MPI_Allgather_init
        module procedure MPI_Allgather_init_f08ts
    end interface
    interface MPI_Allgatherv_init
        module procedure MPI_Allgatherv_init_f08ts
    end interface
    interface MPI_Scatter_init
        module procedure MPI_Scatter_init_f08ts
    end interface
    interface MPI_Scatterv_init
        module procedure MPI_Scatterv_init_f08ts
    end interface
    interface MPI_Alltoall_init
        module procedure MPI_Alltoall_init_f08ts
    end interface
    interface MPI_Alltoallv_init
        module procedure MPI_Alltoallv_init_f08ts
    end interface
    interface MPI_Alltoallw_init
        module procedure MPI_Alltoallw_init_f08ts
    end interface
    interface MPI_Scan_init
        module procedure MPI_Scan_init_f08ts
    end interface
    interface MPI_Exscan_init
        module procedure MPI_Exscan_init_f08ts
    end interface
    interface MPI_Reduce_scatter_init
        module procedure MPI_Reduce_scatter_init_f08ts
    end interface
    interface MPI_Reduce_scatter_block_init
        module procedure MPI_Reduce_scatter_block_init_f08ts
    end interface

    interface MPI_Neighbor_allgather
        module procedure MPI_Neighbor_allgather_f08ts
    end interface
    interface MPI_Neighbor_allgatherv
        module procedure MPI_Neighbor_allgatherv_f08ts
    end interface
    interface MPI_Neighbor_alltoall
        module procedure MPI_Neighbor_alltoall_f08ts
    end interface
    interface MPI_Neighbor_alltoallv
        module procedure MPI_Neighbor_alltoallv_f08ts
    end interface
    interface MPI_Neighbor_alltoallw
        module procedure MPI_Neighbor_alltoallw_f08ts
    end interface
    interface MPI_Ineighbor_allgather
        module procedure MPI_Ineighbor_allgather_f08ts
    end interface
    interface MPI_Ineighbor_allgatherv
        module procedure MPI_Ineighbor_allgatherv_f08ts
    end interface
    interface MPI_Ineighbor_alltoall
        module procedure MPI_Ineighbor_alltoall_f08ts
    end interface
    interface MPI_Ineighbor_alltoallv
        module procedure MPI_Ineighbor_alltoallv_f08ts
    end interface
    interface MPI_Ineighbor_alltoallw
        module procedure MPI_Ineighbor_alltoallw_f08ts
    end interface
    interface MPI_Neighbor_allgather_init
        module procedure MPI_Neighbor_allgather_init_f08ts
    end interface
    interface MPI_Neighbor_allgatherv_init
        module procedure MPI_Neighbor_allgatherv_init_f08ts
    end interface
    interface MPI_Neighbor_alltoall_init
        module procedure MPI_Neighbor_alltoall_init_f08ts
    end interface
    interface MPI_Neighbor_alltoallv_init
        module procedure MPI_Neighbor_alltoallv_init_f08ts
    end interface
    interface MPI_Neighbor_alltoallw_init
        module procedure MPI_Neighbor_alltoallw_init_f08ts
    end interface

#ifdef HAVE_CFI
    interface
        subroutine VAPAA_MPI_Alltoallw(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, &
                                       rdispls, recvtypes, comm, ierror) bind(C,name="VAPAA_MPI_Alltoallw")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Datatype
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*)
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: recvtypes(*)
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_Ibarrier(comm, request, ierror) bind(C,name="VAPAA_MPI_Ibarrier")
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Barrier_init(comm, info, request, ierror) bind(C,name="VAPAA_MPI_Barrier_init")
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ibcast(buffer, count, datatype, root, comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Ibcast")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..) :: buffer
!pgi$ ignore_tkr(c) buffer
            integer(c_int), intent(in) :: count, datatype, root, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Bcast_init(buffer, count, datatype, root, comm, info, request, ierror) &
                   bind(C,name="VAPAA_MPI_Bcast_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), asynchronous :: buffer
!pgi$ ignore_tkr(c) buffer
            integer(c_int), intent(in) :: count, datatype, root, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iallreduce(sendbuf, recvbuf, count, datatype, op, comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Iallreduce")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iscan(sendbuf, recvbuf, count, datatype, op, comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Iscan")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iexscan(sendbuf, recvbuf, count, datatype, op, comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Iexscan")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Allreduce_init(sendbuf, recvbuf, count, datatype, op, comm, info, request, &
                                            ierror) bind(C,name="VAPAA_MPI_Allreduce_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Scan_init(sendbuf, recvbuf, count, datatype, op, comm, info, request, ierror) &
                   bind(C,name="VAPAA_MPI_Scan_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Exscan_init(sendbuf, recvbuf, count, datatype, op, comm, info, request, ierror) &
                   bind(C,name="VAPAA_MPI_Exscan_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ireduce(sendbuf, recvbuf, count, datatype, op, root, comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Ireduce")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, root, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Reduce_init(sendbuf, recvbuf, count, datatype, op, root, comm, info, request, &
                                         ierror) bind(C,name="VAPAA_MPI_Reduce_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, root, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Igather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm, &
                                     request, ierror) bind(C,name="VAPAA_MPI_Igather")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, root, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iscatter(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm, &
                                      request, ierror) bind(C,name="VAPAA_MPI_Iscatter")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, root, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Gather_init(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, &
                                         comm, info, request, ierror) bind(C,name="VAPAA_MPI_Gather_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, root, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Scatter_init(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, &
                                          comm, info, request, ierror) bind(C,name="VAPAA_MPI_Scatter_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, root, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iallgather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, &
                                        request, ierror) bind(C,name="VAPAA_MPI_Iallgather")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ialltoall(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, &
                                       request, ierror) bind(C,name="VAPAA_MPI_Ialltoall")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Allgather_init(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, &
                                            comm, info, request, ierror) bind(C,name="VAPAA_MPI_Allgather_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Alltoall_init(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, &
                                           comm, info, request, ierror) bind(C,name="VAPAA_MPI_Alltoall_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Igatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, recvtype, &
                                      root, comm, request, ierror) bind(C,name="VAPAA_MPI_Igatherv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype, root, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Gatherv_init(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, &
                                          recvtype, root, comm, info, request, ierror) &
                   bind(C,name="VAPAA_MPI_Gatherv_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype
            integer(c_int), intent(in) :: root, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iscatterv(sendbuf, sendcounts, displs, sendtype, recvbuf, recvcount, recvtype, &
                                       root, comm, request, ierror) bind(C,name="VAPAA_MPI_Iscatterv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), displs(*), sendtype, recvcount, recvtype, root, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Scatterv_init(sendbuf, sendcounts, displs, sendtype, recvbuf, recvcount, &
                                           recvtype, root, comm, info, request, ierror) &
                   bind(C,name="VAPAA_MPI_Scatterv_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), displs(*), sendtype, recvcount, recvtype
            integer(c_int), intent(in) :: root, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iallgatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, &
                                         recvtype, comm, request, ierror) bind(C,name="VAPAA_MPI_Iallgatherv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Allgatherv_init(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, &
                                             recvtype, comm, info, request, ierror) &
                   bind(C,name="VAPAA_MPI_Allgatherv_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ialltoallv(sendbuf, sendcounts, sdispls, sendtype, recvbuf, recvcounts, &
                                        rdispls, recvtype, comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Ialltoallv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*), sendtype
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*), recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Alltoallv_init(sendbuf, sendcounts, sdispls, sendtype, recvbuf, recvcounts, &
                                            rdispls, recvtype, comm, info, request, ierror) &
                   bind(C,name="VAPAA_MPI_Alltoallv_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*), sendtype
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*), recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ialltoallw(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, &
                                        rdispls, recvtypes, comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Ialltoallw")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Datatype
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*)
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: recvtypes(*)
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Alltoallw_init(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, &
                                            rdispls, recvtypes, comm, info, request, ierror) &
                   bind(C,name="VAPAA_MPI_Alltoallw_init")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Datatype
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*)
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: recvtypes(*)
            integer(c_int), intent(in) :: comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ireduce_scatter(sendbuf, recvbuf, recvcounts, datatype, op, comm, request, &
                                             ierror) bind(C,name="VAPAA_MPI_Ireduce_scatter")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcounts(*), datatype, op, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Reduce_scatter_init(sendbuf, recvbuf, recvcounts, datatype, op, comm, info, &
                                                 request, ierror) bind(C,name="VAPAA_MPI_Reduce_scatter_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcounts(*), datatype, op, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ireduce_scatter_block(sendbuf, recvbuf, recvcount, datatype, op, comm, &
                                                   request, ierror) &
                   bind(C,name="VAPAA_MPI_Ireduce_scatter_block")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcount, datatype, op, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Reduce_scatter_block_init(sendbuf, recvbuf, recvcount, datatype, op, comm, &
                                                       info, request, ierror) &
                   bind(C,name="VAPAA_MPI_Reduce_scatter_block_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcount, datatype, op, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Isendrecv(sendbuf, sendcount, sendtype, dest, sendtag, recvbuf, recvcount, &
                                       recvtype, source, recvtag, comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Isendrecv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, dest, sendtag, recvcount, recvtype, source, recvtag, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Isendrecv_replace(buf, count, datatype, dest, sendtag, source, recvtag, comm, &
                                               request, ierror) bind(C,name="VAPAA_MPI_Isendrecv_replace")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(inout), asynchronous :: buf
!pgi$ ignore_tkr(c) buf
            integer(c_int), intent(in) :: count, datatype, dest, sendtag, source, recvtag, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_allgather(sendbuf, sendcount, sendtype, recvbuf, recvcount, &
                                                recvtype, comm, ierror) &
                   bind(C,name="VAPAA_MPI_Neighbor_allgather")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_alltoall(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, &
                                               comm, ierror) bind(C,name="VAPAA_MPI_Neighbor_alltoall")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_Ineighbor_allgather(sendbuf, sendcount, sendtype, recvbuf, recvcount, &
                                                 recvtype, comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Ineighbor_allgather")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ineighbor_alltoall(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, &
                                                comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Ineighbor_alltoall")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_allgather_init(sendbuf, sendcount, sendtype, recvbuf, recvcount, &
                                                     recvtype, comm, info, request, ierror) &
                   bind(C,name="VAPAA_MPI_Neighbor_allgather_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_alltoall_init(sendbuf, sendcount, sendtype, recvbuf, recvcount, &
                                                    recvtype, comm, info, request, ierror) &
                   bind(C,name="VAPAA_MPI_Neighbor_alltoall_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_allgatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, &
                                                 displs, recvtype, comm, ierror) &
                   bind(C,name="VAPAA_MPI_Neighbor_allgatherv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype, comm
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_Ineighbor_allgatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, &
                                                  displs, recvtype, comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Ineighbor_allgatherv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_allgatherv_init(sendbuf, sendcount, sendtype, recvbuf, recvcounts, &
                                                      displs, recvtype, comm, info, request, ierror) &
                   bind(C,name="VAPAA_MPI_Neighbor_allgatherv_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_alltoallv(sendbuf, sendcounts, sdispls, sendtype, recvbuf, &
                                                recvcounts, rdispls, recvtype, comm, ierror) &
                   bind(C,name="VAPAA_MPI_Neighbor_alltoallv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*), sendtype
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*), recvtype, comm
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_Ineighbor_alltoallv(sendbuf, sendcounts, sdispls, sendtype, recvbuf, &
                                                 recvcounts, rdispls, recvtype, comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Ineighbor_alltoallv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*), sendtype
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*), recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_alltoallv_init(sendbuf, sendcounts, sdispls, sendtype, recvbuf, &
                                                     recvcounts, rdispls, recvtype, comm, info, request, &
                                                     ierror) bind(C,name="VAPAA_MPI_Neighbor_alltoallv_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*), sendtype
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*), recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_alltoallw(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, &
                                                recvcounts, rdispls, recvtypes, comm, ierror) &
                   bind(C,name="VAPAA_MPI_Neighbor_alltoallw")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Datatype
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer(c_int), intent(in) :: sendcounts(*), recvcounts(*)
            integer(c_intptr_t), intent(in) :: sdispls(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*), recvtypes(*)
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_Ineighbor_alltoallw(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, &
                                                 recvcounts, rdispls, recvtypes, comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Ineighbor_alltoallw")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Datatype
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer(c_int), intent(in) :: sendcounts(*), recvcounts(*)
            integer(c_intptr_t), intent(in) :: sdispls(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*), recvtypes(*)
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_alltoallw_init(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, &
                                                     recvcounts, rdispls, recvtypes, comm, info, request, &
                                                     ierror) bind(C,name="VAPAA_MPI_Neighbor_alltoallw_init")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Datatype
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer(c_int), intent(in) :: sendcounts(*), recvcounts(*)
            integer(c_intptr_t), intent(in) :: sdispls(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*), recvtypes(*)
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine
    end interface
#elif defined(HAVE_PGIF)
    interface
        subroutine VAPAA_MPI_Alltoallw(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, &
                                       rdispls, recvtypes, comm, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Datatype
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*)
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: recvtypes(*)
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_Ibarrier(comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Barrier_init(comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ibcast(buffer, count, datatype, root, comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..) :: buffer
!pgi$ ignore_tkr(c) buffer
            integer(c_int), intent(in) :: count, datatype, root, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Bcast_init(buffer, count, datatype, root, comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), asynchronous :: buffer
!pgi$ ignore_tkr(c) buffer
            integer(c_int), intent(in) :: count, datatype, root, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iallreduce(sendbuf, recvbuf, count, datatype, op, comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iscan(sendbuf, recvbuf, count, datatype, op, comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iexscan(sendbuf, recvbuf, count, datatype, op, comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Allreduce_init(sendbuf, recvbuf, count, datatype, op, comm, info, request, &
                                            ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Scan_init(sendbuf, recvbuf, count, datatype, op, comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Exscan_init(sendbuf, recvbuf, count, datatype, op, comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ireduce(sendbuf, recvbuf, count, datatype, op, root, comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, root, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Reduce_init(sendbuf, recvbuf, count, datatype, op, root, comm, info, request, &
                                         ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: count, datatype, op, root, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Igather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm, &
                                     request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, root, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iscatter(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm, &
                                      request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, root, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Gather_init(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, &
                                         comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, root, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Scatter_init(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, &
                                          comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, root, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iallgather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, &
                                        request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ialltoall(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, &
                                       request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Allgather_init(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, &
                                            comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Alltoall_init(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, &
                                           comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Igatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, recvtype, &
                                      root, comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype, root, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Gatherv_init(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, &
                                          recvtype, root, comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype
            integer(c_int), intent(in) :: root, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iscatterv(sendbuf, sendcounts, displs, sendtype, recvbuf, recvcount, recvtype, &
                                       root, comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), displs(*), sendtype, recvcount, recvtype, root, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Scatterv_init(sendbuf, sendcounts, displs, sendtype, recvbuf, recvcount, &
                                           recvtype, root, comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), displs(*), sendtype, recvcount, recvtype
            integer(c_int), intent(in) :: root, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Iallgatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, &
                                         recvtype, comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Allgatherv_init(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, &
                                             recvtype, comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ialltoallv(sendbuf, sendcounts, sdispls, sendtype, recvbuf, recvcounts, &
                                        rdispls, recvtype, comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*), sendtype
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*), recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Alltoallv_init(sendbuf, sendcounts, sdispls, sendtype, recvbuf, recvcounts, &
                                            rdispls, recvtype, comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*), sendtype
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*), recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ialltoallw(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, &
                                        rdispls, recvtypes, comm, request, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Datatype
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*)
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: recvtypes(*)
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Alltoallw_init(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, &
                                            rdispls, recvtypes, comm, info, request, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Datatype
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*)
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: recvtypes(*)
            integer(c_int), intent(in) :: comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ireduce_scatter(sendbuf, recvbuf, recvcounts, datatype, op, comm, request, &
                                             ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcounts(*), datatype, op, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Reduce_scatter_init(sendbuf, recvbuf, recvcounts, datatype, op, comm, info, &
                                                 request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcounts(*), datatype, op, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ireduce_scatter_block(sendbuf, recvbuf, recvcount, datatype, op, comm, &
                                                   request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcount, datatype, op, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Reduce_scatter_block_init(sendbuf, recvbuf, recvcount, datatype, op, comm, &
                                                       info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: recvcount, datatype, op, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Isendrecv(sendbuf, sendcount, sendtype, dest, sendtag, recvbuf, recvcount, &
                                       recvtype, source, recvtag, comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, dest, sendtag, recvcount, recvtype, source, recvtag, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Isendrecv_replace(buf, count, datatype, dest, sendtag, source, recvtag, comm, &
                                               request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(inout), asynchronous :: buf
!pgi$ ignore_tkr(c) buf
            integer(c_int), intent(in) :: count, datatype, dest, sendtag, source, recvtag, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_allgather(sendbuf, sendcount, sendtype, recvbuf, recvcount, &
                                                recvtype, comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_alltoall(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, &
                                               comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_Ineighbor_allgather(sendbuf, sendcount, sendtype, recvbuf, recvcount, &
                                                 recvtype, comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Ineighbor_alltoall(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, &
                                                comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_allgather_init(sendbuf, sendcount, sendtype, recvbuf, recvcount, &
                                                     recvtype, comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_alltoall_init(sendbuf, sendcount, sendtype, recvbuf, recvcount, &
                                                    recvtype, comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcount, recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_allgatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, &
                                                 displs, recvtype, comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype, comm
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_Ineighbor_allgatherv(sendbuf, sendcount, sendtype, recvbuf, recvcounts, &
                                                  displs, recvtype, comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_allgatherv_init(sendbuf, sendcount, sendtype, recvbuf, recvcounts, &
                                                      displs, recvtype, comm, info, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcount, sendtype, recvcounts(*), displs(*), recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_alltoallv(sendbuf, sendcounts, sdispls, sendtype, recvbuf, &
                                                recvcounts, rdispls, recvtype, comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*), sendtype
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*), recvtype, comm
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_Ineighbor_alltoallv(sendbuf, sendcounts, sdispls, sendtype, recvbuf, &
                                                 recvcounts, rdispls, recvtype, comm, request, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*), sendtype
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*), recvtype, comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_alltoallv_init(sendbuf, sendcounts, sdispls, sendtype, recvbuf, &
                                                     recvcounts, rdispls, recvtype, comm, info, request, &
                                                     ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: sendcounts(*), sdispls(*), sendtype
            integer(c_int), intent(in) :: recvcounts(*), rdispls(*), recvtype, comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_alltoallw(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, &
                                                recvcounts, rdispls, recvtypes, comm, ierror)
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Datatype
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer(c_int), intent(in) :: sendcounts(*), recvcounts(*)
            integer(c_intptr_t), intent(in) :: sdispls(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*), recvtypes(*)
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_Ineighbor_alltoallw(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, &
                                                 recvcounts, rdispls, recvtypes, comm, request, ierror)
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Datatype
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer(c_int), intent(in) :: sendcounts(*), recvcounts(*)
            integer(c_intptr_t), intent(in) :: sdispls(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*), recvtypes(*)
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: comm
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_Neighbor_alltoallw_init(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, &
                                                     recvcounts, rdispls, recvtypes, comm, info, request, &
                                                     ierror)
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Datatype
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer(c_int), intent(in) :: sendcounts(*), recvcounts(*)
            integer(c_intptr_t), intent(in) :: sdispls(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*), recvtypes(*)
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer(c_int), intent(in) :: comm, info
            integer(c_int), intent(out) :: request, ierror
        end subroutine
    end interface
#endif
#endif

    contains

        subroutine finish_ierror(ierror, ierror_c)
            integer, optional, intent(out) :: ierror
            integer(c_int), intent(in) :: ierror_c
            if (present(ierror)) ierror = ierror_c
        end subroutine finish_ierror

#if defined(HAVE_CFI) || defined(HAVE_PGIF)
        subroutine MPI_Alltoallw_f08ts(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, &
                                       rdispls, recvtypes, comm, ierror)
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcounts(*), sdispls(*), recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*), recvtypes(*)
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Alltoallw(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, rdispls, &
                                     recvtypes, comm % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Ibarrier_f08(comm, request, ierror)
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Ibarrier(comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Barrier_init_f08(comm, info, request, ierror)
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Barrier_init(comm % MPI_VAL, info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Ibcast_f08ts(buffer, count, datatype, root, comm, request, ierror)
            type(*), dimension(..), intent(inout), asynchronous :: buffer
!pgi$ ignore_tkr(c) buffer
            integer, intent(in) :: count, root
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Ibcast(buffer, int(count,c_int), datatype % MPI_VAL, int(root,c_int), comm % MPI_VAL, &
                                  request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Bcast_init_f08ts(buffer, count, datatype, root, comm, info, request, ierror)
            type(*), dimension(..), intent(inout), asynchronous :: buffer
!pgi$ ignore_tkr(c) buffer
            integer, intent(in) :: count, root
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Bcast_init(buffer, int(count,c_int), datatype % MPI_VAL, int(root,c_int), comm % MPI_VAL, &
                                      info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Iallreduce_f08ts(sendbuf, recvbuf, count, datatype, op, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Iallreduce(sendbuf, recvbuf, int(count,c_int), datatype % MPI_VAL, op % MPI_VAL, &
                                      comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Iscan_f08ts(sendbuf, recvbuf, count, datatype, op, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Iscan(sendbuf, recvbuf, int(count,c_int), datatype % MPI_VAL, op % MPI_VAL, &
                                 comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Iexscan_f08ts(sendbuf, recvbuf, count, datatype, op, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Iexscan(sendbuf, recvbuf, int(count,c_int), datatype % MPI_VAL, op % MPI_VAL, &
                                   comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Allreduce_init_f08ts(sendbuf, recvbuf, count, datatype, op, comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Allreduce_init(sendbuf, recvbuf, int(count,c_int), datatype % MPI_VAL, op % MPI_VAL, &
                                          comm % MPI_VAL, info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Scan_init_f08ts(sendbuf, recvbuf, count, datatype, op, comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Scan_init(sendbuf, recvbuf, int(count,c_int), datatype % MPI_VAL, op % MPI_VAL, &
                                     comm % MPI_VAL, info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Exscan_init_f08ts(sendbuf, recvbuf, count, datatype, op, comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Exscan_init(sendbuf, recvbuf, int(count,c_int), datatype % MPI_VAL, op % MPI_VAL, &
                                       comm % MPI_VAL, info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Ireduce_f08ts(sendbuf, recvbuf, count, datatype, op, root, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: count, root
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Ireduce(sendbuf, recvbuf, int(count,c_int), datatype % MPI_VAL, op % MPI_VAL, &
                                   int(root,c_int), comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Reduce_init_f08ts(sendbuf, recvbuf, count, datatype, op, root, comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: count, root
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Reduce_init(sendbuf, recvbuf, int(count,c_int), datatype % MPI_VAL, op % MPI_VAL, &
                                       int(root,c_int), comm % MPI_VAL, info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Igather_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm, &
                                     request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: sendcount, recvcount, root
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Igather(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                   int(recvcount,c_int), recvtype % MPI_VAL, int(root,c_int), comm % MPI_VAL, &
                                   request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Iscatter_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm, &
                                      request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: sendcount, recvcount, root
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Iscatter(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                    int(recvcount,c_int), recvtype % MPI_VAL, int(root,c_int), comm % MPI_VAL, &
                                    request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Gather_init_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm, &
                                         info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: sendcount, recvcount, root
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Gather_init(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                       int(recvcount,c_int), recvtype % MPI_VAL, int(root,c_int), comm % MPI_VAL, &
                                       info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Scatter_init_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm, &
                                          info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: sendcount, recvcount, root
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Scatter_init(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                        int(recvcount,c_int), recvtype % MPI_VAL, int(root,c_int), comm % MPI_VAL, &
                                        info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Iallgather_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, &
                                        request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: sendcount, recvcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Iallgather(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                      int(recvcount,c_int), recvtype % MPI_VAL, comm % MPI_VAL, &
                                      request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Ialltoall_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, &
                                       request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: sendcount, recvcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Ialltoall(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                     int(recvcount,c_int), recvtype % MPI_VAL, comm % MPI_VAL, &
                                     request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Allgather_init_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, &
                                            info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: sendcount, recvcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Allgather_init(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                          int(recvcount,c_int), recvtype % MPI_VAL, comm % MPI_VAL, &
                                          info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Alltoall_init_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, &
                                           info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: sendcount, recvcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Alltoall_init(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                         int(recvcount,c_int), recvtype % MPI_VAL, comm % MPI_VAL, &
                                         info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Igatherv_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, recvtype, &
                                      root, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in), asynchronous :: recvcounts(*), displs(*)
            integer, intent(in) :: root
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Igatherv(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, recvcounts, displs, &
                                    recvtype % MPI_VAL, int(root,c_int), comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Gatherv_init_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, recvtype, &
                                          root, comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in), asynchronous :: recvcounts(*), displs(*)
            integer, intent(in) :: root
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Gatherv_init(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, recvcounts, &
                                        displs, recvtype % MPI_VAL, int(root,c_int), comm % MPI_VAL, info % MPI_VAL, &
                                        request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Iscatterv_f08ts(sendbuf, sendcounts, displs, sendtype, recvbuf, recvcount, recvtype, &
                                       root, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in), asynchronous :: sendcounts(*), displs(*)
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: recvcount, root
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Iscatterv(sendbuf, sendcounts, displs, sendtype % MPI_VAL, recvbuf, int(recvcount,c_int), &
                                     recvtype % MPI_VAL, int(root,c_int), comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Scatterv_init_f08ts(sendbuf, sendcounts, displs, sendtype, recvbuf, recvcount, recvtype, &
                                           root, comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in), asynchronous :: sendcounts(*), displs(*)
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: recvcount, root
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Scatterv_init(sendbuf, sendcounts, displs, sendtype % MPI_VAL, recvbuf, &
                                         int(recvcount,c_int), recvtype % MPI_VAL, int(root,c_int), comm % MPI_VAL, &
                                         info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Iallgatherv_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, &
                                         recvtype, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in), asynchronous :: recvcounts(*), displs(*)
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Iallgatherv(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, recvcounts, &
                                       displs, recvtype % MPI_VAL, comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Allgatherv_init_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcounts, displs, &
                                             recvtype, comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in), asynchronous :: recvcounts(*), displs(*)
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Allgatherv_init(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, recvcounts, &
                                           displs, recvtype % MPI_VAL, comm % MPI_VAL, info % MPI_VAL, &
                                           request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Ialltoallv_f08ts(sendbuf, sendcounts, sdispls, sendtype, recvbuf, recvcounts, rdispls, &
                                        recvtype, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in), asynchronous :: sendcounts(*), sdispls(*), recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Ialltoallv(sendbuf, sendcounts, sdispls, sendtype % MPI_VAL, recvbuf, recvcounts, &
                                      rdispls, recvtype % MPI_VAL, comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Alltoallv_init_f08ts(sendbuf, sendcounts, sdispls, sendtype, recvbuf, recvcounts, &
                                            rdispls, recvtype, comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in), asynchronous :: sendcounts(*), sdispls(*), recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Alltoallv_init(sendbuf, sendcounts, sdispls, sendtype % MPI_VAL, recvbuf, recvcounts, &
                                          rdispls, recvtype % MPI_VAL, comm % MPI_VAL, info % MPI_VAL, &
                                          request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Ialltoallw_f08ts(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, &
                                        rdispls, recvtypes, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in), asynchronous :: sendcounts(*), sdispls(*), recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in), asynchronous :: sendtypes(*), recvtypes(*)
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Ialltoallw(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, rdispls, &
                                      recvtypes, comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Alltoallw_init_f08ts(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, &
                                            rdispls, recvtypes, comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in), asynchronous :: sendcounts(*), sdispls(*), recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in), asynchronous :: sendtypes(*), recvtypes(*)
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Alltoallw_init(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, &
                                          rdispls, recvtypes, comm % MPI_VAL, info % MPI_VAL, &
                                          request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Ireduce_scatter_f08ts(sendbuf, recvbuf, recvcounts, datatype, op, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in), asynchronous :: recvcounts(*)
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Ireduce_scatter(sendbuf, recvbuf, recvcounts, datatype % MPI_VAL, op % MPI_VAL, &
                                           comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Reduce_scatter_init_f08ts(sendbuf, recvbuf, recvcounts, datatype, op, comm, info, &
                                                 request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in), asynchronous :: recvcounts(*)
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Reduce_scatter_init(sendbuf, recvbuf, recvcounts, datatype % MPI_VAL, op % MPI_VAL, &
                                               comm % MPI_VAL, info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Ireduce_scatter_block_f08ts(sendbuf, recvbuf, recvcount, datatype, op, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: recvcount
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Ireduce_scatter_block(sendbuf, recvbuf, int(recvcount,c_int), datatype % MPI_VAL, &
                                                 op % MPI_VAL, comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Reduce_scatter_block_init_f08ts(sendbuf, recvbuf, recvcount, datatype, op, comm, &
                                                       info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: recvcount
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Reduce_scatter_block_init(sendbuf, recvbuf, int(recvcount,c_int), datatype % MPI_VAL, &
                                                     op % MPI_VAL, comm % MPI_VAL, info % MPI_VAL, &
                                                     request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Isendrecv_f08ts(sendbuf, sendcount, sendtype, dest, sendtag, recvbuf, recvcount, &
                                       recvtype, source, recvtag, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount, dest, sendtag, recvcount, source, recvtag
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Isendrecv(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, int(dest,c_int), &
                                     int(sendtag,c_int), recvbuf, int(recvcount,c_int), recvtype % MPI_VAL, &
                                     int(source,c_int), int(recvtag,c_int), comm % MPI_VAL, &
                                     request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Isendrecv_replace_f08ts(buf, count, datatype, dest, sendtag, source, recvtag, comm, &
                                               request, ierror)
            type(*), dimension(..), intent(inout), asynchronous :: buf
!pgi$ ignore_tkr(c) buf
            integer, intent(in) :: count, dest, sendtag, source, recvtag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Isendrecv_replace(buf, int(count,c_int), datatype % MPI_VAL, int(dest,c_int), &
                                             int(sendtag,c_int), int(source,c_int), int(recvtag,c_int), &
                                             comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Neighbor_allgather_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, &
                                                ierror)
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount, recvcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Neighbor_allgather(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                              int(recvcount,c_int), recvtype % MPI_VAL, comm % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Neighbor_alltoall_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, &
                                               ierror)
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount, recvcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Neighbor_alltoall(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                             int(recvcount,c_int), recvtype % MPI_VAL, comm % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Ineighbor_allgather_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, &
                                                 request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount, recvcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Ineighbor_allgather(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                               int(recvcount,c_int), recvtype % MPI_VAL, comm % MPI_VAL, &
                                               request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Ineighbor_alltoall_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, comm, &
                                                request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount, recvcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Ineighbor_alltoall(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                              int(recvcount,c_int), recvtype % MPI_VAL, comm % MPI_VAL, &
                                              request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Neighbor_allgather_init_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, &
                                                     comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount, recvcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Neighbor_allgather_init(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                                   int(recvcount,c_int), recvtype % MPI_VAL, comm % MPI_VAL, &
                                                   info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Neighbor_alltoall_init_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, &
                                                    comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount, recvcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Neighbor_alltoall_init(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                                  int(recvcount,c_int), recvtype % MPI_VAL, comm % MPI_VAL, &
                                                  info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Neighbor_allgatherv_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcounts, &
                                                 displs, recvtype, comm, ierror)
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: recvcounts(*), displs(*)
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Neighbor_allgatherv(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                               recvcounts, displs, recvtype % MPI_VAL, comm % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Ineighbor_allgatherv_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcounts, &
                                                  displs, recvtype, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in), asynchronous :: recvcounts(*), displs(*)
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Ineighbor_allgatherv(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                                recvcounts, displs, recvtype % MPI_VAL, comm % MPI_VAL, &
                                                request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Neighbor_allgatherv_init_f08ts(sendbuf, sendcount, sendtype, recvbuf, recvcounts, &
                                                      displs, recvtype, comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcount
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in), asynchronous :: recvcounts(*), displs(*)
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Neighbor_allgatherv_init(sendbuf, int(sendcount,c_int), sendtype % MPI_VAL, recvbuf, &
                                                    recvcounts, displs, recvtype % MPI_VAL, comm % MPI_VAL, &
                                                    info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Neighbor_alltoallv_f08ts(sendbuf, sendcounts, sdispls, sendtype, recvbuf, &
                                                recvcounts, rdispls, recvtype, comm, ierror)
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcounts(*), sdispls(*), recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Neighbor_alltoallv(sendbuf, sendcounts, sdispls, sendtype % MPI_VAL, recvbuf, &
                                              recvcounts, rdispls, recvtype % MPI_VAL, comm % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Ineighbor_alltoallv_f08ts(sendbuf, sendcounts, sdispls, sendtype, recvbuf, &
                                                 recvcounts, rdispls, recvtype, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in), asynchronous :: sendcounts(*), sdispls(*), recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Ineighbor_alltoallv(sendbuf, sendcounts, sdispls, sendtype % MPI_VAL, recvbuf, &
                                               recvcounts, rdispls, recvtype % MPI_VAL, comm % MPI_VAL, &
                                               request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Neighbor_alltoallv_init_f08ts(sendbuf, sendcounts, sdispls, sendtype, recvbuf, &
                                                     recvcounts, rdispls, recvtype, comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in), asynchronous :: sendcounts(*), sdispls(*), recvcounts(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: sendtype, recvtype
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Neighbor_alltoallv_init(sendbuf, sendcounts, sdispls, sendtype % MPI_VAL, recvbuf, &
                                                   recvcounts, rdispls, recvtype % MPI_VAL, comm % MPI_VAL, &
                                                   info % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Neighbor_alltoallw_f08ts(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, &
                                                recvcounts, rdispls, recvtypes, comm, ierror)
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in) :: sendcounts(*), recvcounts(*)
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: sdispls(*), rdispls(*)
            type(MPI_Datatype), intent(in) :: sendtypes(*), recvtypes(*)
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Neighbor_alltoallw(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, &
                                              rdispls, recvtypes, comm % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Ineighbor_alltoallw_f08ts(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, &
                                                 recvcounts, rdispls, recvtypes, comm, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in), asynchronous :: sendcounts(*), recvcounts(*)
            integer(kind=MPI_ADDRESS_KIND), intent(in), asynchronous :: sdispls(*), rdispls(*)
            type(MPI_Datatype), intent(in), asynchronous :: sendtypes(*), recvtypes(*)
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Ineighbor_alltoallw(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, &
                                               rdispls, recvtypes, comm % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Neighbor_alltoallw_init_f08ts(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, &
                                                     recvcounts, rdispls, recvtypes, comm, info, request, ierror)
            type(*), dimension(..), intent(in), asynchronous :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            integer, intent(in), asynchronous :: sendcounts(*), recvcounts(*)
            integer(kind=MPI_ADDRESS_KIND), intent(in), asynchronous :: sdispls(*), rdispls(*)
            type(MPI_Datatype), intent(in), asynchronous :: sendtypes(*), recvtypes(*)
            type(*), dimension(..), asynchronous :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Neighbor_alltoallw_init(sendbuf, sendcounts, sdispls, sendtypes, recvbuf, recvcounts, &
                                                   rdispls, recvtypes, comm % MPI_VAL, info % MPI_VAL, &
                                                   request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

#endif

end module mpi_direct_collective_f
