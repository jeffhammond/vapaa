module mpi_p2p_f
    use iso_c_binding, only: c_int
    implicit none

    contains

        subroutine MPI_Send_f08(buffer, count, datatype, dest, tag, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: C_MPI_Send
            integer, dimension(*), intent(in) :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, datatype_c, dest_c, tag_c, comm_c, ierror_c
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            dest_c = dest 
            tag_c = tag
            comm_c = comm % MPI_VAL
            call C_MPI_Send(buffer, count_c, datatype_c, dest_c, tag_c, comm_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Send_f08

#ifdef HAVE_CFI
        subroutine MPI_Send_f08ts(buffer, count, datatype, dest, tag, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: CFI_MPI_Send
            type(*), dimension(..), intent(inout) :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, datatype_c, dest_c, tag_c, comm_c, ierror_c
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            dest_c = dest 
            tag_c = tag
            comm_c = comm % MPI_VAL
            call CFI_MPI_Send(buffer, count_c, datatype_c, dest_c, tag_c, comm_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Send_f08ts
#endif

end module mpi_p2p_f
