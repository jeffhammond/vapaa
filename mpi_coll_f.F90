module mpi_coll_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Barrier
        module procedure MPI_Barrier_f08
    end interface MPI_Barrier

    interface MPI_Bcast
        module procedure MPI_Bcast_f08
    end interface MPI_Bcast

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
            if (is_contiguous(buffer)) then
                call C_MPI_Bcast(buffer, count_c, datatype_c, root_c, comm_c, ierror_c)
            else
                call CFI_MPI_Bcast(buffer, count_c, datatype_c, root_c, comm_c, ierror_c)
            endif
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Bcast_f08

end module mpi_coll_f

