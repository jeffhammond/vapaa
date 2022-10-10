module mpi_p2p_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Test
        module procedure MPI_Test_f08
    end interface MPI_Test

    interface MPI_Wait
        module procedure MPI_Wait_f08
    end interface MPI_Wait

    interface MPI_Waitall
        module procedure MPI_Waitall_f08
    end interface MPI_Waitall

    interface MPI_Send
#ifdef HAVE_CFI
        module procedure MPI_Send_f08ts
#else
        module procedure MPI_Send_f08
#endif
    end interface MPI_Send

    interface MPI_Isend
#ifdef HAVE_CFI
        module procedure MPI_Isend_f08ts
#else
        module procedure MPI_Isend_f08
#endif
    end interface MPI_Isend

    interface MPI_Recv
#ifdef HAVE_CFI
        module procedure MPI_Recv_f08ts
#else
        module procedure MPI_Recv_f08
#endif
    end interface MPI_Recv

    interface MPI_Irecv
#ifdef HAVE_CFI
        module procedure MPI_Irecv_f08ts
#else
        module procedure MPI_Irecv_f08
#endif
    end interface MPI_Irecv

    contains

        subroutine MPI_Test_f08(request, flag, stat, ierror) 
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_p2p_c, only: C_MPI_Test
            type(MPI_Request), intent(inout) :: request
            logical, intent(out) :: flag
            type(MPI_Status), intent(out) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: request_c, flag_c, ierror_c
            request_c = request % MPI_VAL
            call C_MPI_Test(request_c, flag_c, stat, ierror_c)
            request % MPI_VAL = request_c
            if (flag_c .eq. 0) then
                flag = .false.
            else
                flag = .true.
            endif
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Test_f08

        subroutine MPI_Wait_f08(request, stat, ierror) 
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_p2p_c, only: C_MPI_Wait
            type(MPI_Request), intent(inout) :: request
            type(MPI_Status), intent(out) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: request_c, ierror_c
            request_c = request % MPI_VAL
            call C_MPI_Wait(request_c, stat, ierror_c)
            request % MPI_VAL = request_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Wait_f08

        subroutine MPI_Waitall_f08(count, requests, statuses, ierror) 
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_p2p_c, only: C_MPI_Waitall
            integer, intent(in) :: count
            type(MPI_Request), intent(inout) :: requests(count)
            type(MPI_Status), intent(out) :: statuses(*)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int), allocatable :: requests_c(:)
            integer(kind=c_int) :: ierror_c
            integer :: i
            ! no error checking - live dangerously
            allocate( requests_c(count) )
            do i=1,count
              requests_c(i) = requests(i) % MPI_VAL
            end do
            call C_MPI_Waitall(count, requests_c, statuses, ierror_c)
            do i=1,count
              requests(i) % MPI_VAL = requests_c(i)
            end do
            deallocate( requests_c )
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Waitall_f08

        subroutine MPI_Send_f08(buffer, count, datatype, dest, tag, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: C_MPI_Send
!dir$ ignore_tkr buffer
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
            type(*), dimension(..), intent(in) :: buffer
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

        subroutine MPI_Isend_f08(buffer, count, datatype, dest, tag, comm, request, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: C_MPI_Isend
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, datatype_c, dest_c, tag_c, comm_c, request_c, ierror_c
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            dest_c = dest 
            tag_c = tag
            comm_c = comm % MPI_VAL
            call C_MPI_Isend(buffer, count_c, datatype_c, dest_c, tag_c, comm_c, request_c, ierror_c)
            request % MPI_VAL = request_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Isend_f08

#ifdef HAVE_CFI
        subroutine MPI_Isend_f08ts(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Isend
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, datatype_c, dest_c, tag_c, comm_c, request_c, ierror_c
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            dest_c = dest 
            tag_c = tag
            comm_c = comm % MPI_VAL
            call CFI_MPI_Isend(buffer, count_c, datatype_c, dest_c, tag_c, comm_c, request_c, ierror_c)
            request % MPI_VAL = request_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Isend_f08ts
#endif

        subroutine MPI_Recv_f08(buffer, count, datatype, source, tag, comm, stat, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Status
            use mpi_p2p_c, only: C_MPI_Recv
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(out) :: buffer
            integer, intent(in) :: count, source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, datatype_c, source_c, tag_c, comm_c, ierror_c
            type(MPI_Status), intent(out) :: stat
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            source_c = source 
            tag_c = tag
            comm_c = comm % MPI_VAL
            call C_MPI_Recv(buffer, count_c, datatype_c, source_c, tag_c, comm_c, stat, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Recv_f08

#ifdef HAVE_CFI
        subroutine MPI_Recv_f08ts(buffer, count, datatype, source, tag, comm, stat, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Status
            use mpi_p2p_c, only: CFI_MPI_Recv
            type(*), dimension(..), intent(inout) :: buffer
            integer, intent(in) :: count, source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, datatype_c, source_c, tag_c, comm_c, ierror_c
            type(MPI_Status), intent(out) :: stat
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            source_c = source 
            tag_c = tag
            comm_c = comm % MPI_VAL
            call CFI_MPI_Recv(buffer, count_c, datatype_c, source_c, tag_c, comm_c, stat, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Recv_f08ts
#endif

        subroutine MPI_Irecv_f08(buffer, count, datatype, source, tag, comm, request, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: C_MPI_Irecv
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(out), asynchronous :: buffer
            integer, intent(in) :: count, source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, datatype_c, source_c, tag_c, comm_c, request_c, ierror_c
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            source_c = source 
            tag_c = tag
            comm_c = comm % MPI_VAL
            call C_MPI_Irecv(buffer, count_c, datatype_c, source_c, tag_c, comm_c, request_c, ierror_c)
            request % MPI_VAL = request_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Irecv_f08

#ifdef HAVE_CFI
        subroutine MPI_Irecv_f08ts(buffer, count, datatype, source, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Irecv
            type(*), dimension(..), intent(inout), asynchronous :: buffer
            integer, intent(in) :: count, source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, datatype_c, source_c, tag_c, comm_c, request_c, ierror_c
            ! buffer
            count_c = count
            datatype_c = datatype % MPI_VAL
            source_c = source 
            tag_c = tag
            comm_c = comm % MPI_VAL
            call CFI_MPI_Irecv(buffer, count_c, datatype_c, source_c, tag_c, comm_c, request_c, ierror_c)
            request % MPI_VAL = request_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Irecv_f08ts
#endif

end module mpi_p2p_f
