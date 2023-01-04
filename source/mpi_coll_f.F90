module mpi_coll_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Barrier
        module procedure MPI_Barrier_f08
    end interface MPI_Barrier

    interface MPI_Bcast
#ifdef HAVE_CFI
        module procedure MPI_Bcast_f08ts
#else
        module procedure MPI_Bcast_f08
#endif
    end interface MPI_Bcast

    interface MPI_Reduce
#ifdef HAVE_CFI
        module procedure MPI_Reduce_f08ts
#else
        module procedure MPI_Reduce_f08
#endif
    end interface MPI_Reduce

    interface MPI_Allreduce
#ifdef HAVE_CFI
        module procedure MPI_Allreduce_f08ts
#else
        module procedure MPI_Allreduce_f08
#endif
    end interface MPI_Allreduce

    interface MPI_Gather
#ifdef HAVE_CFI
        module procedure MPI_Gather_f08ts
#else
        module procedure MPI_Gather_f08
#endif
    end interface MPI_Gather

    interface MPI_Allgather
#ifdef HAVE_CFI
        module procedure MPI_Allgather_f08ts
#else
        module procedure MPI_Allgather_f08
#endif
    end interface MPI_Allgather

    interface MPI_Scatter
#ifdef HAVE_CFI
        module procedure MPI_Scatter_f08ts
#else
        module procedure MPI_Scatter_f08
#endif
    end interface MPI_Scatter

    interface MPI_Alltoall
#ifdef HAVE_CFI
        module procedure MPI_Alltoall_f08ts
#else
        module procedure MPI_Alltoall_f08
#endif
    end interface MPI_Alltoall

    contains

        subroutine MPI_Barrier_f08(comm, ierror) 
            use mpi_handle_types, only: MPI_Comm
            use mpi_coll_c, only: C_MPI_Barrier
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Barrier(comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Barrier_f08

        subroutine MPI_Bcast_f08(buffer, count, datatype, root, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_coll_c, only: C_MPI_Bcast
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(inout) :: buffer
            integer, intent(in) :: count, root
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, root_c, ierror_c
            count_c = count
            root_c = root
            call C_MPI_Bcast(buffer, count_c, datatype % MPI_VAL, root_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Bcast_f08

#ifdef HAVE_CFI
        subroutine MPI_Bcast_f08ts(buffer, count, datatype, root, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_coll_c, only: CFI_MPI_Bcast
            type(*), dimension(..), intent(inout) :: buffer
            integer, intent(in) :: count, root
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, root_c, ierror_c
            count_c = count
            root_c = root
            call CFI_MPI_Bcast(buffer, count_c, datatype % MPI_VAL, root_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Bcast_f08ts
#endif

        subroutine MPI_Reduce_f08(input, output, count, datatype, op, root, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Op
            use mpi_coll_c, only: C_MPI_Reduce
!dir$ ignore_tkr input, output
            integer, dimension(*), intent(in)    :: input
            integer, dimension(*), intent(inout) :: output
            integer, intent(in) :: count, root
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, root_c, ierror_c
            count_c = count
            root_c = root
            call C_MPI_Reduce(input, output, count_c, datatype % MPI_VAL, op % MPI_VAL, root_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Reduce_f08

#ifdef HAVE_CFI
        subroutine MPI_Reduce_f08ts(input, output, count, datatype, op, root, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Op
            use mpi_coll_c, only: CFI_MPI_Reduce
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer, intent(in) :: count, root
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, root_c, ierror_c
            count_c = count
            root_c = root
            call CFI_MPI_Reduce(input, output, count_c, datatype % MPI_VAL, op % MPI_VAL, root_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Reduce_f08ts
#endif

        subroutine MPI_Allreduce_f08(input, output, count, datatype, op, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Op
            use mpi_coll_c, only: C_MPI_Allreduce
!dir$ ignore_tkr input, output
            integer, dimension(*), intent(in)    :: input
            integer, dimension(*), intent(inout) :: output
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, ierror_c
            count_c = count
            call C_MPI_Allreduce(input, output, count_c, datatype % MPI_VAL, op % MPI_VAL, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Allreduce_f08

#ifdef HAVE_CFI
        subroutine MPI_Allreduce_f08ts(input, output, count, datatype, op, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Op
            use mpi_coll_c, only: CFI_MPI_Allreduce
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, ierror_c
            count_c = count
            call CFI_MPI_Allreduce(input, output, count_c, datatype % MPI_VAL, op % MPI_VAL, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Allreduce_f08ts
#endif

        subroutine MPI_Gather_f08(input, scount, stype, output, rcount, rtype, root, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_coll_c, only: C_MPI_Gather
!dir$ ignore_tkr input, output
            integer, dimension(*), intent(in)    :: input
            integer, dimension(*), intent(inout) :: output
            integer, intent(in) :: scount, rcount, root
            type(MPI_Datatype), intent(in) :: stype, rtype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: scount_c, rcount_c, root_c, ierror_c
            scount_c = scount
            rcount_c = rcount
            root_c = root
            call C_MPI_Gather(input, scount_c, stype % MPI_VAL, output, rcount_c, rtype % MPI_VAL, root_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Gather_f08

#ifdef HAVE_CFI
        subroutine MPI_Gather_f08ts(input, scount, stype, output, rcount, rtype, root, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_coll_c, only: CFI_MPI_Gather
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer, intent(in) :: scount, rcount, root
            type(MPI_Datatype), intent(in) :: stype, rtype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: scount_c, rcount_c, root_c, ierror_c
            scount_c = scount
            rcount_c = rcount
            root_c = root
            call CFI_MPI_Gather(input, scount_c, stype % MPI_VAL, output, rcount_c, rtype % MPI_VAL, &
                                root_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Gather_f08ts
#endif

        subroutine MPI_Allgather_f08(input, scount, stype, output, rcount, rtype, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_coll_c, only: C_MPI_Allgather
!dir$ ignore_tkr input, output
            integer, dimension(*), intent(in)    :: input
            integer, dimension(*), intent(inout) :: output
            integer, intent(in) :: scount, rcount
            type(MPI_Datatype), intent(in) :: stype, rtype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: scount_c, rcount_c, ierror_c
            scount_c = scount
            rcount_c = rcount
            call C_MPI_Allgather(input, scount_c, stype % MPI_VAL, output, rcount_c, rtype % MPI_VAL, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Allgather_f08

#ifdef HAVE_CFI
        subroutine MPI_Allgather_f08ts(input, scount, stype, output, rcount, rtype, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_coll_c, only: CFI_MPI_Allgather
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer, intent(in) :: scount, rcount
            type(MPI_Datatype), intent(in) :: stype, rtype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: scount_c, rcount_c, ierror_c
            scount_c = scount
            rcount_c = rcount
            call CFI_MPI_Allgather(input, scount_c, stype % MPI_VAL, output, rcount_c, rtype % MPI_VAL, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Allgather_f08ts
#endif

        subroutine MPI_Scatter_f08(input, scount, stype, output, rcount, rtype, root, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_coll_c, only: C_MPI_Scatter
!dir$ ignore_tkr input, output
            integer, dimension(*), intent(in)    :: input
            integer, dimension(*), intent(inout) :: output
            integer, intent(in) :: scount, rcount, root
            type(MPI_Datatype), intent(in) :: stype, rtype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: scount_c, rcount_c, root_c, ierror_c
            scount_c = scount
            rcount_c = rcount
            root_c = root
            call C_MPI_Scatter(input, scount_c, stype % MPI_VAL, output, rcount_c, rtype % MPI_VAL, &
                               root_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Scatter_f08

#ifdef HAVE_CFI
        subroutine MPI_Scatter_f08ts(input, scount, stype, output, rcount, rtype, root, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_coll_c, only: CFI_MPI_Scatter
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer, intent(in) :: scount, rcount, root
            type(MPI_Datatype), intent(in) :: stype, rtype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: scount_c, rcount_c, root_c, ierror_c
            scount_c = scount
            rcount_c = rcount
            root_c = root
            call CFI_MPI_Scatter(input, scount_c, stype % MPI_VAL, output, rcount_c, rtype % MPI_VAL, &
                                 root_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Scatter_f08ts
#endif

        subroutine MPI_Alltoall_f08(input, scount, stype, output, rcount, rtype, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_coll_c, only: C_MPI_Alltoall
!dir$ ignore_tkr input, output
            integer, dimension(*), intent(in)    :: input
            integer, dimension(*), intent(inout) :: output
            integer, intent(in) :: scount, rcount
            type(MPI_Datatype), intent(in) :: stype, rtype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: scount_c, rcount_c, ierror_c
            scount_c = scount
            rcount_c = rcount
            call C_MPI_Alltoall(input, scount_c, stype % MPI_VAL, output, rcount_c, rtype % MPI_VAL, &
                                comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Alltoall_f08

#ifdef HAVE_CFI
        subroutine MPI_Alltoall_f08ts(input, scount, stype, output, rcount, rtype, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_coll_c, only: CFI_MPI_Alltoall
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer, intent(in) :: scount, rcount
            type(MPI_Datatype), intent(in) :: stype, rtype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: scount_c, rcount_c, ierror_c
            scount_c = scount
            rcount_c = rcount
            call CFI_MPI_Alltoall(input, scount_c, stype % MPI_VAL, output, rcount_c, rtype % MPI_VAL, &
                                  comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Alltoall_f08ts
#endif

        subroutine MPI_Alltoallv_f08(input, scounts, sdisps, stype, output, rcounts, rdisps, rtype, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_coll_c, only: C_MPI_Alltoallv
!dir$ ignore_tkr input, output
            integer, dimension(*), intent(in)    :: input
            integer, dimension(*), intent(inout) :: output
            integer, intent(in), dimension(*) :: scounts, sdisps, rcounts, rdisps
            type(MPI_Datatype), intent(in) :: stype, rtype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            ! assume Fortran INTEGER and C int are equivalent
            call C_MPI_Alltoallv(input, scounts, sdisps, stype % MPI_VAL, output, rcounts, rdisps, rtype % MPI_VAL, &
                                 comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Alltoallv_f08

#ifdef HAVE_CFI
        subroutine MPI_Alltoallv_f08ts(input, scounts, sdisps, stype, output, rcounts, rdisps, rtype, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_coll_c, only: CFI_MPI_Alltoallv
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer, intent(in), dimension(*) :: scounts, sdisps, rcounts, rdisps
            type(MPI_Datatype), intent(in) :: stype, rtype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            ! assume Fortran INTEGER and C int are equivalent
            call CFI_MPI_Alltoallv(input, scounts, sdisps, stype % MPI_VAL, output, rcounts, rdisps, rtype % MPI_VAL, &
                                   comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Alltoallv_f08ts
#endif

end module mpi_coll_f

