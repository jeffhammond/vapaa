module mpi_coll_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Barrier
        module procedure MPI_Barrier_f08
    end interface MPI_Barrier

    interface MPI_Bcast
        module procedure MPI_Bcast_f08
    end interface MPI_Bcast

    interface MPI_Allreduce
        module procedure MPI_Allreduce_f08
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
            use mpi_coll_c, only: C_MPI_Bcast, CFI_MPI_Bcast
#ifdef __NVCOMPILER
            class(*), dimension(..), intent(inout) :: buffer
#else
            type(*), dimension(..), intent(inout) :: buffer
#endif
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
            if (is_contiguous(buffer)) then
                call C_MPI_Bcast(buffer, count_c, datatype_c, root_c, comm_c, ierror_c)
            else
                call CFI_MPI_Bcast(buffer, count_c, datatype_c, root_c, comm_c, ierror_c)
            endif
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Bcast_f08

        subroutine MPI_Allreduce_f08(input, output, count, datatype, op, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Op
            use mpi_coll_c, only: C_MPI_Allreduce, CFI_MPI_Allreduce
#ifdef __NVCOMPILER
            class(*), dimension(..), intent(in)    :: input
            class(*), dimension(..), intent(inout) :: output
#else
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
#endif
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
            if (is_contiguous(input).and.is_contiguous(output)) then
                call C_MPI_Allreduce(input, output, count_c, datatype_c, op_c, comm_c, ierror_c)
            else if (.not.is_contiguous(input).and..not.is_contiguous(output)) then
                call CFI_MPI_Allreduce(input, output, count_c, datatype_c, op_c, comm_c, ierror_c)
            else
                print*,'Allreduce input/output both contiguous or both not (FIXME)'
                stop
            endif
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Allreduce_f08

end module mpi_coll_f

