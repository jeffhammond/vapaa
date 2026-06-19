! SPDX-License-Identifier: MIT

module mpi_coll_c

    interface
        subroutine C_MPI_Barrier(comm, ierror) &
                   bind(C,name="C_MPI_Barrier")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm, ierror
        end subroutine C_MPI_Barrier
    end interface

    interface
        subroutine C_MPI_Bcast(buffer, count, datatype, root, comm, &
                               ierror) &
                   bind(C,name="C_MPI_Bcast")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(inout) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, root, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Bcast
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Bcast(buffer, count, datatype, root, comm, &
                                 ierror) &
                   bind(C,name="CFI_MPI_Bcast")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(inout) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, root, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Bcast
    end interface
#endif

    interface
        subroutine C_MPI_Reduce(input, output, count, datatype, op, root, comm, &
                                ierror) &
                   bind(C,name="C_MPI_Reduce")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int) :: count, datatype, op, root, comm, ierror
        end subroutine C_MPI_Reduce
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Reduce(input, output, count, datatype, op, root, comm, &
                                  ierror) &
                   bind(C,name="CFI_MPI_Reduce")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int) :: count, datatype, op, root, comm, ierror
        end subroutine CFI_MPI_Reduce
    end interface
#endif

    interface
        subroutine C_MPI_Allreduce(input, output, count, datatype, op, comm, &
                                   ierror) &
                   bind(C,name="C_MPI_Allreduce")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int) :: count, datatype, op, comm, ierror
        end subroutine C_MPI_Allreduce
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Allreduce(input, output, count, datatype, op, comm, &
                                     ierror) &
                   bind(C,name="CFI_MPI_Allreduce")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int) :: count, datatype, op, comm, ierror
        end subroutine CFI_MPI_Allreduce
    end interface
#endif

    interface
        subroutine C_MPI_Gather(input, scount, stype, output, rcount, rtype, root, comm, &
                                ierror) &
                   bind(C,name="C_MPI_Gather")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int) :: scount, stype, rcount, rtype, root, comm, ierror
        end subroutine C_MPI_Gather
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Gather(input, scount, stype, output, rcount, rtype, root, comm, &
                                  ierror) &
                   bind(C,name="CFI_MPI_Gather")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int) :: scount, stype, rcount, rtype, root, comm, ierror
        end subroutine CFI_MPI_Gather
    end interface
#endif

    interface
        subroutine C_MPI_Allgather(input, scount, stype, output, rcount, rtype, comm, &
                                   ierror) &
                   bind(C,name="C_MPI_Allgather")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int) :: scount, stype, rcount, rtype, comm, ierror
        end subroutine C_MPI_Allgather
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Allgather(input, scount, stype, output, rcount, rtype, comm, &
                                     ierror) &
                   bind(C,name="CFI_MPI_Allgather")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int) :: scount, stype, rcount, rtype, comm, ierror
        end subroutine CFI_MPI_Allgather
    end interface
#endif

    interface
        subroutine C_MPI_Scatter(input, scount, stype, output, rcount, rtype, root, comm, &
                                ierror) &
                   bind(C,name="C_MPI_Scatter")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int) :: scount, stype, rcount, rtype, root, comm, ierror
        end subroutine C_MPI_Scatter
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Scatter(input, scount, stype, output, rcount, rtype, root, comm, &
                                  ierror) &
                   bind(C,name="CFI_MPI_Scatter")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int) :: scount, stype, rcount, rtype, root, comm, ierror
        end subroutine CFI_MPI_Scatter
    end interface
#endif

    interface
        subroutine C_MPI_Alltoall(input, scount, stype, output, rcount, rtype, comm, &
                                  ierror) &
                   bind(C,name="C_MPI_Alltoall")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int) :: scount, stype, rcount, rtype, comm, ierror
        end subroutine C_MPI_Alltoall
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Alltoall(input, scount, stype, output, rcount, rtype, comm, &
                                    ierror) &
                   bind(C,name="CFI_MPI_Alltoall")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int) :: scount, stype, rcount, rtype, comm, ierror
        end subroutine CFI_MPI_Alltoall
    end interface
#endif

    ! v-collectives

    interface
        subroutine C_MPI_Gatherv(input, scount, stype, output, rcounts, rdisps, rtype, root, comm, &
                                 ierror) &
                   bind(C,name="C_MPI_Gatherv")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int), dimension(*), intent(in) :: rcounts, rdisps
            integer(kind=c_int) :: scount, stype, rtype, root, comm, ierror
        end subroutine C_MPI_Gatherv
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Gatherv(input, scount, stype, output, rcounts, rdisps, rtype, root, comm, &
                                   ierror) &
                   bind(C,name="CFI_MPI_Gatherv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int), dimension(*), intent(in) :: rcounts, rdisps
            integer(kind=c_int) :: scount, stype, rtype, root, comm, ierror
        end subroutine CFI_MPI_Gatherv
    end interface
#endif

    interface
        subroutine C_MPI_Allgatherv(input, scount, stype, output, rcounts, rdisps, rtype, comm, &
                                    ierror) &
                   bind(C,name="C_MPI_Allgatherv")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int), dimension(*), intent(in) :: rcounts, rdisps
            integer(kind=c_int) :: scount, stype, rtype, comm, ierror
        end subroutine C_MPI_Allgatherv
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Allgatherv(input, scount, stype, output, rcounts, rdisps, rtype, comm, &
                                      ierror) &
                   bind(C,name="CFI_MPI_Allgatherv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int), dimension(*), intent(in) :: rcounts, rdisps
            integer(kind=c_int) :: scount, stype, rtype, comm, ierror
        end subroutine CFI_MPI_Allgatherv
    end interface
#endif

    interface
        subroutine C_MPI_Scatterv(input, scounts, sdisps, stype, output, rcount, rtype, root, comm, &
                                 ierror) &
                   bind(C,name="C_MPI_Scatterv")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int), dimension(*), intent(in) :: scounts, sdisps
            integer(kind=c_int) :: stype, rcount, rtype, root, comm, ierror
        end subroutine C_MPI_Scatterv
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Scatterv(input, scounts, sdisps, stype, output, rcount, rtype, root, comm, &
                                    ierror) &
                   bind(C,name="CFI_MPI_Scatterv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int), dimension(*), intent(in) :: scounts, sdisps
            integer(kind=c_int) :: stype, rcount, rtype, root, comm, ierror
        end subroutine CFI_MPI_Scatterv
    end interface
#endif

    interface
        subroutine C_MPI_Alltoallv(input, scounts, sdisps, stype, output, rcounts, rdisps, rtype, comm, &
                                   ierror) &
                   bind(C,name="C_MPI_Alltoallv")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int), dimension(*), intent(in) :: scounts, sdisps, rcounts, rdisps
            integer(kind=c_int) :: stype, rtype, comm, ierror
        end subroutine C_MPI_Alltoallv
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Alltoallv(input, scounts, sdisps, stype, output, rcounts, rdisps, rtype, comm, &
                                     ierror) &
                   bind(C,name="CFI_MPI_Alltoallv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int), dimension(*), intent(in) :: scounts, sdisps, rcounts, rdisps
            integer(kind=c_int) :: stype, rtype, comm, ierror
        end subroutine CFI_MPI_Alltoallv
    end interface
#endif

#ifdef HAVE_PGIF
    interface CFI_MPI_Bcast
        subroutine PGIF_MPI_Bcast(buffer, count, datatype, root, comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(inout) :: buffer
!pgi$ ignore_tkr(c) buffer
            integer(kind=c_int), intent(in) :: count, datatype, root, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine PGIF_MPI_Bcast
    end interface

    interface CFI_MPI_Reduce
        subroutine PGIF_MPI_Reduce(input, output, count, datatype, op, root, &
                                   comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: input
            type(*), dimension(..), intent(inout) :: output
!pgi$ ignore_tkr(c) input, output
            integer(kind=c_int), intent(in) :: count, datatype, op, root, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine PGIF_MPI_Reduce
    end interface

    interface CFI_MPI_Allreduce
        subroutine PGIF_MPI_Allreduce(input, output, count, datatype, op, comm, &
                                      ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: input
            type(*), dimension(..), intent(inout) :: output
!pgi$ ignore_tkr(c) input, output
            integer(kind=c_int), intent(in) :: count, datatype, op, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine PGIF_MPI_Allreduce
    end interface

    interface CFI_MPI_Gather
        subroutine PGIF_MPI_Gather(input, scount, stype, output, rcount, rtype, &
                                   root, comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: input
            type(*), dimension(..), intent(inout) :: output
!pgi$ ignore_tkr(c) input, output
            integer(kind=c_int), intent(in) :: scount, stype, rcount, rtype
            integer(kind=c_int), intent(in) :: root, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine PGIF_MPI_Gather
    end interface

    interface CFI_MPI_Allgather
        subroutine PGIF_MPI_Allgather(input, scount, stype, output, rcount, &
                                      rtype, comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: input
            type(*), dimension(..), intent(inout) :: output
!pgi$ ignore_tkr(c) input, output
            integer(kind=c_int), intent(in) :: scount, stype, rcount, rtype
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine PGIF_MPI_Allgather
    end interface

    interface CFI_MPI_Scatter
        subroutine PGIF_MPI_Scatter(input, scount, stype, output, rcount, &
                                    rtype, root, comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: input
            type(*), dimension(..), intent(inout) :: output
!pgi$ ignore_tkr(c) input, output
            integer(kind=c_int), intent(in) :: scount, stype, rcount, rtype
            integer(kind=c_int), intent(in) :: root, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine PGIF_MPI_Scatter
    end interface

    interface CFI_MPI_Alltoall
        subroutine PGIF_MPI_Alltoall(input, scount, stype, output, rcount, &
                                     rtype, comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: input
            type(*), dimension(..), intent(inout) :: output
!pgi$ ignore_tkr(c) input, output
            integer(kind=c_int), intent(in) :: scount, stype, rcount, rtype
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine PGIF_MPI_Alltoall
    end interface

    interface CFI_MPI_Gatherv
        subroutine PGIF_MPI_Gatherv(input, scount, stype, output, rcounts, &
                                    rdisps, rtype, root, comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: input
            type(*), dimension(..), intent(inout) :: output
!pgi$ ignore_tkr(c) input, output
            integer(kind=c_int), intent(in) :: scount, stype, rtype, root, comm
            integer(kind=c_int), dimension(*), intent(in) :: rcounts, rdisps
            integer(kind=c_int), intent(out) :: ierror
        end subroutine PGIF_MPI_Gatherv
    end interface

    interface CFI_MPI_Allgatherv
        subroutine PGIF_MPI_Allgatherv(input, scount, stype, output, rcounts, &
                                       rdisps, rtype, comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: input
            type(*), dimension(..), intent(inout) :: output
!pgi$ ignore_tkr(c) input, output
            integer(kind=c_int), intent(in) :: scount, stype, rtype, comm
            integer(kind=c_int), dimension(*), intent(in) :: rcounts, rdisps
            integer(kind=c_int), intent(out) :: ierror
        end subroutine PGIF_MPI_Allgatherv
    end interface

    interface CFI_MPI_Scatterv
        subroutine PGIF_MPI_Scatterv(input, scounts, sdisps, stype, output, &
                                     rcount, rtype, root, comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: input
            type(*), dimension(..), intent(inout) :: output
!pgi$ ignore_tkr(c) input, output
            integer(kind=c_int), dimension(*), intent(in) :: scounts, sdisps
            integer(kind=c_int), intent(in) :: stype, rcount, rtype, root, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine PGIF_MPI_Scatterv
    end interface

    interface CFI_MPI_Alltoallv
        subroutine PGIF_MPI_Alltoallv(input, scounts, sdisps, stype, output, &
                                      rcounts, rdisps, rtype, comm, ierror)
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: input
            type(*), dimension(..), intent(inout) :: output
!pgi$ ignore_tkr(c) input, output
            integer(kind=c_int), dimension(*), intent(in) :: scounts, sdisps
            integer(kind=c_int), dimension(*), intent(in) :: rcounts, rdisps
            integer(kind=c_int), intent(in) :: stype, rtype, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine PGIF_MPI_Alltoallv
    end interface
#endif

end module mpi_coll_c
