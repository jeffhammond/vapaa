! SPDX-License-Identifier: MIT

#ifdef HAVE_CFI

subroutine MPI_Send_f08ts(buffer, count, datatype, dest, tag, comm, ierror)
    use mpi_handle_types, only: MPI_Comm, MPI_Datatype
    use mpi_p2p_f, only: PMPI_Send
    type(*), dimension(..), intent(in) :: buffer
    integer, intent(in) :: count, dest, tag
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Comm), intent(in) :: comm
    integer, optional, intent(out) :: ierror
!GCC$ ATTRIBUTES weak :: MPI_Send_f08ts

    if (present(ierror)) then
        call PMPI_Send(buffer, count, datatype, dest, tag, comm, ierror)
    else
        call PMPI_Send(buffer, count, datatype, dest, tag, comm)
    end if
end subroutine MPI_Send_f08ts

subroutine MPI_Send_c_f08ts(buffer, count, datatype, dest, tag, comm, ierror)
    use mpi_global_constants, only: MPI_COUNT_KIND
    use mpi_handle_types, only: MPI_Comm, MPI_Datatype
    use mpi_p2p_f, only: PMPI_Send
    type(*), dimension(..), intent(in) :: buffer
    integer(kind=MPI_COUNT_KIND), intent(in) :: count
    integer, intent(in) :: dest, tag
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Comm), intent(in) :: comm
    integer, optional, intent(out) :: ierror
!GCC$ ATTRIBUTES weak :: MPI_Send_c_f08ts

    if (present(ierror)) then
        call PMPI_Send(buffer, count, datatype, dest, tag, comm, ierror)
    else
        call PMPI_Send(buffer, count, datatype, dest, tag, comm)
    end if
end subroutine MPI_Send_c_f08ts

subroutine MPI_Recv_f08ts(buffer, count, datatype, source, tag, comm, status, ierror)
    use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Status
    use mpi_p2p_f, only: PMPI_Recv
    type(*), dimension(..) :: buffer
    integer, intent(in) :: count, source, tag
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Status), intent(inout), target :: status
    integer, optional, intent(out) :: ierror
!GCC$ ATTRIBUTES weak :: MPI_Recv_f08ts

    if (present(ierror)) then
        call PMPI_Recv(buffer, count, datatype, source, tag, comm, status, ierror)
    else
        call PMPI_Recv(buffer, count, datatype, source, tag, comm, status)
    end if
end subroutine MPI_Recv_f08ts

subroutine MPI_Recv_c_f08ts(buffer, count, datatype, source, tag, comm, status, ierror)
    use mpi_global_constants, only: MPI_COUNT_KIND
    use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Status
    use mpi_p2p_f, only: PMPI_Recv
    type(*), dimension(..), asynchronous :: buffer
    integer(kind=MPI_COUNT_KIND), intent(in) :: count
    integer, intent(in) :: source, tag
    type(MPI_Datatype), intent(in) :: datatype
    type(MPI_Comm), intent(in) :: comm
    type(MPI_Status), intent(inout), target :: status
    integer, optional, intent(out) :: ierror
!GCC$ ATTRIBUTES weak :: MPI_Recv_c_f08ts

    if (present(ierror)) then
        call PMPI_Recv(buffer, count, datatype, source, tag, comm, status, ierror)
    else
        call PMPI_Recv(buffer, count, datatype, source, tag, comm, status)
    end if
end subroutine MPI_Recv_c_f08ts

#endif
