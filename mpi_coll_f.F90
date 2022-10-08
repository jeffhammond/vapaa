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

    contains

        subroutine MPI_Barrier_f08(comm, ierror) 
            use mpi_handle_types, only: MPI_Comm
            use mpi_coll_c, only: C_MPI_Barrier
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: comm_c, ierror_c
            comm_c = comm % MPI_VAL
            call C_MPI_Barrier(comm_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Barrier_f08

        subroutine MPI_Bcast_f08(buffer, count, datatype, root, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_coll_c, only: C_MPI_Bcast
            integer, dimension(*), intent(inout) :: buffer
            integer, intent(in) :: count, root
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, datatype_c, root_c, comm_c, ierror_c
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            root_c = root
            comm_c = comm % MPI_VAL
            call C_MPI_Bcast(buffer, count_c, datatype_c, root_c, comm_c, ierror_c)
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
            integer(kind=c_int) :: count_c, datatype_c, root_c, comm_c, ierror_c
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            root_c = root
            comm_c = comm % MPI_VAL
            call CFI_MPI_Bcast(buffer, count_c, datatype_c, root_c, comm_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Bcast_f08ts
#endif

        subroutine MPI_Reduce_f08(input, output, count, datatype, op, root, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Op
            use mpi_coll_c, only: C_MPI_Reduce
            integer, dimension(*), intent(in)    :: input
            integer, dimension(*), intent(inout) :: output
            integer, intent(in) :: count, root
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, datatype_c, op_c, root_c, comm_c, ierror_c
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            op_c = op % MPI_VAL
            root_c = root
            comm_c = comm % MPI_VAL
            call C_MPI_Reduce(input, output, count_c, datatype_c, op_c, root_c, comm_c, ierror_c)
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
            integer(kind=c_int) :: count_c, datatype_c, op_c, root_c, comm_c, ierror_c
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            op_c = op % MPI_VAL
            root_c = root
            comm_c = comm % MPI_VAL
            call CFI_MPI_Reduce(input, output, count_c, datatype_c, op_c, root_c, comm_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Reduce_f08ts
#endif

        subroutine MPI_Allreduce_f08(input, output, count, datatype, op, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Op
            use mpi_coll_c, only: C_MPI_Allreduce
            integer, dimension(*), intent(in)    :: input
            integer, dimension(*), intent(inout) :: output
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, datatype_c, op_c, comm_c, ierror_c
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            op_c = op % MPI_VAL
            comm_c = comm % MPI_VAL
            call C_MPI_Allreduce(input, output, count_c, datatype_c, op_c, comm_c, ierror_c)
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
            integer(kind=c_int) :: count_c, datatype_c, op_c, comm_c, ierror_c
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            op_c = op % MPI_VAL
            comm_c = comm % MPI_VAL
            call CFI_MPI_Allreduce(input, output, count_c, datatype_c, op_c, comm_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Allreduce_f08ts
#endif

end module mpi_coll_f

