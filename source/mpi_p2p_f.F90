! SPDX-License-Identifier: MIT

module mpi_p2p_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Probe
        module procedure MPI_Probe_f08
    end interface MPI_Probe

    interface MPI_Mprobe
        module procedure MPI_Mprobe_f08
    end interface MPI_Mprobe

    interface MPI_Test
        module procedure MPI_Test_f08
    end interface MPI_Test

    interface MPI_Testall
        module procedure MPI_Testall_f08
    end interface MPI_Testall

    interface MPI_Testsome
        module procedure MPI_Testsome_f08
    end interface MPI_Testsome

    interface MPI_Testany
        module procedure MPI_Testany_f08
    end interface MPI_Testany

    interface MPI_Wait
        module procedure MPI_Wait_f08
    end interface MPI_Wait

    interface MPI_Waitall
        module procedure MPI_Waitall_f08
    end interface MPI_Waitall

    interface MPI_Waitsome
        module procedure MPI_Waitsome_f08
    end interface MPI_Waitsome

    interface MPI_Waitany
        module procedure MPI_Waitany_f08
    end interface MPI_Waitany

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

    interface MPI_Pack
#ifdef HAVE_CFI
        module procedure MPI_Pack_f08ts
#else
        module procedure MPI_Pack_f08
#endif
    end interface MPI_Pack

    interface MPI_Unpack
#ifdef HAVE_CFI
        module procedure MPI_Unpack_f08ts
#else
        module procedure MPI_Unpack_f08
#endif
    end interface MPI_Unpack

    contains

        subroutine MPI_Probe_f08(source, tag, comm, stat, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Status
            use mpi_p2p_c, only: C_MPI_Probe
            integer, intent(in) :: source, tag
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: source_c, tag_c, ierror_c
            source_c = source
            tag_c    = tag
            call C_MPI_Probe(source_c, tag_c, comm % MPI_VAL, stat, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Probe_f08

        subroutine MPI_Mprobe_f08(source, tag, comm, message, stat, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Message, MPI_Status
            use mpi_p2p_c, only: C_MPI_Mprobe
            integer, intent(in) :: source, tag
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Message), intent(out) :: message
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: source_c, tag_c, ierror_c
            source_c  = source
            tag_c     = tag
            call C_MPI_Mprobe(source_c, tag_c, comm % MPI_VAL, message % MPI_VAL, stat, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Mprobe_f08

        subroutine MPI_Test_f08(request, flag, stat, ierror) 
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_p2p_c, only: C_MPI_Test
            type(MPI_Request), intent(inout) :: request
            logical, intent(out) :: flag
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: flag_c, ierror_c
            call C_MPI_Test(request % MPI_VAL, flag_c, stat, ierror_c)
            flag = (flag_c .ne. 0)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Test_f08

        subroutine MPI_Testall_f08(count, requests, flag, statuses, ierror) 
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_p2p_c, only: C_MPI_Testall
            integer, intent(in) :: count
            type(MPI_Request), intent(inout) :: requests(count)
            logical, intent(out) :: flag
            type(MPI_Status), intent(inout) :: statuses(*)
            integer, optional, intent(out) :: ierror
            !integer(kind=c_int), allocatable :: requests_c(:)
            integer(kind=c_int) :: count_c, flag_c, ierror_c
            !integer :: i
            ! no error checking - live dangerously
            !allocate( requests_c(count) )
            !do i=1,count
            !  requests_c(i) = requests(i) % MPI_VAL
            !end do
            count_c = count
            !call C_MPI_Testall(count_c, requests_c, flag_c, statuses, ierror_c)
            call C_MPI_Testall(count_c, requests, flag_c, statuses, ierror_c)
            flag = (flag_c .ne. 0)
            !do i=1,count
            !  requests(i) % MPI_VAL = requests_c(i)
            !end do
            !deallocate( requests_c )
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Testall_f08

        subroutine MPI_Testsome_f08(incount, requests, outcount, indices, statuses, ierror) 
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_p2p_c, only: C_MPI_Testsome
            integer, intent(in) :: incount
            type(MPI_Request), intent(inout) :: requests(incount)
            integer, intent(out) :: outcount, indices(*)
            type(MPI_Status), intent(inout) :: statuses(*)
            integer, optional, intent(out) :: ierror
            !integer(kind=c_int), allocatable :: indices_c(:), requests_c(:)
            integer(kind=c_int) :: incount_c, outcount_c, ierror_c
            !integer :: i
            ! no error checking - live dangerously
            !allocate( indices_c(incount), requests_c(incount) )
            !do i=1,incount
            !  requests_c(i) = requests(i) % MPI_VAL
            !end do
            incount_c = incount
            call C_MPI_Testsome(incount_c, requests, outcount_c, indices, statuses, ierror_c)
            outcount = outcount_c
            !do i=1,incount
            !  indices(i) = indices_c(i)
            !  requests(i) % MPI_VAL = requests_c(i)
            !end do
            !deallocate( indices_c, requests_c )
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Testsome_f08

        subroutine MPI_Testany_f08(count, requests, index, flag, status, ierror) 
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_p2p_c, only: C_MPI_Testany
            integer, intent(in) :: count
            type(MPI_Request), intent(inout) :: requests(count)
            integer, intent(out) :: index
            logical, intent(out) :: flag
            type(MPI_Status), intent(inout) :: status
            integer, optional, intent(out) :: ierror
            !integer(kind=c_int), allocatable :: requests_c(:)
            integer(kind=c_int) :: count_c, index_c, flag_c, ierror_c
            !integer :: i
            ! no error checking - live dangerously
            !allocate( requests_c(count) )
            !do i=1,count
            !  requests_c(i) = requests(i) % MPI_VAL
            !end do
            count_c = count
            call C_MPI_Testany(count_c, requests, index_c, flag_c, status, ierror_c)
            if (index_c .ge. 0) then
                index = index_c + 1
            endif
            flag = (flag_c .ne. 0)
            !do i=1,count
            !  requests(i) % MPI_VAL = requests_c(i)
            !end do
            !deallocate( requests_c )
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Testany_f08

        subroutine MPI_Wait_f08(request, stat, ierror) 
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_p2p_c, only: C_MPI_Wait
            type(MPI_Request), intent(inout) :: request
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Wait(request % MPI_VAL, stat, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Wait_f08

        subroutine MPI_Waitall_f08(count, requests, statuses, ierror) 
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_p2p_c, only: C_MPI_Waitall
            integer, intent(in) :: count
            type(MPI_Request), intent(inout) :: requests(count)
            type(MPI_Status), intent(inout) :: statuses(*)
            integer, optional, intent(out) :: ierror
            !integer(kind=c_int), allocatable :: requests_c(:)
            integer(kind=c_int) :: count_c, ierror_c
            !integer :: i
            ! no error checking - live dangerously
            !allocate( requests_c(count) )
            !do i=1,count
            !  requests_c(i) = requests(i) % MPI_VAL
            !end do
            count_c = count
            call C_MPI_Waitall(count_c, requests, statuses, ierror_c)
            !do i=1,count
            !  requests(i) % MPI_VAL = requests_c(i)
            !end do
            !deallocate( requests_c )
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Waitall_f08

        subroutine MPI_Waitsome_f08(incount, requests, outcount, indices, statuses, ierror) 
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_p2p_c, only: C_MPI_Waitsome
            integer, intent(in) :: incount
            type(MPI_Request), intent(inout) :: requests(incount)
            integer, intent(out) :: outcount, indices(*)
            type(MPI_Status), intent(inout) :: statuses(*)
            integer, optional, intent(out) :: ierror
            !integer(kind=c_int), allocatable :: indices_c(:), requests_c(:)
            integer(kind=c_int) :: incount_c, outcount_c, ierror_c
            !integer :: i
            ! no error checking - live dangerously
            !allocate( indices_c(incount), requests_c(incount) )
            !do i=1,incount
            !  requests_c(i) = requests(i) % MPI_VAL
            !end do
            incount_c = incount
            call C_MPI_Waitsome(incount_c, requests, outcount_c, indices, statuses, ierror_c)
            outcount = outcount_c
            !do i=1,incount
            !  indices(i) = indices_c(i)
            !  requests(i) % MPI_VAL = requests_c(i)
            !end do
            !deallocate( indices_c, requests_c )
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Waitsome_f08

        subroutine MPI_Waitany_f08(count, requests, index, status, ierror) 
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_p2p_c, only: C_MPI_Waitany
            integer, intent(in) :: count
            type(MPI_Request), intent(inout) :: requests(count)
            integer, intent(out) :: index
            type(MPI_Status), intent(inout) :: status
            integer, optional, intent(out) :: ierror
            !integer(kind=c_int), allocatable :: requests_c(:)
            integer(kind=c_int) :: count_c, index_c, ierror_c
            !integer :: i
            ! no error checking - live dangerously
            !allocate( requests_c(count) )
            !do i=1,count
            !  requests_c(i) = requests(i) % MPI_VAL
            !end do
            count_c = count
            call C_MPI_Waitany(count_c, requests, index_c, status, ierror_c)
            if (index_c .ge. 0) then
                index = index_c + 1
            endif
            !do i=1,count
            !  requests(i) % MPI_VAL = requests_c(i)
            !end do
            !deallocate( requests_c )
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Waitany_f08

        subroutine MPI_Send_f08(buffer, count, datatype, dest, tag, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: C_MPI_Send
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in) :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            ! buffer
            count_c = count
            dest_c = dest 
            tag_c = tag
            call C_MPI_Send(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, comm % MPI_VAL, ierror_c)
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
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            ! buffer
            count_c = count
            dest_c = dest 
            tag_c = tag
            call CFI_MPI_Send(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, comm % MPI_VAL, ierror_c)
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
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c  = dest 
            tag_c   = tag
            call C_MPI_Isend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, comm % MPI_VAL, request % MPI_VAL, ierror_c)
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
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c  = dest 
            tag_c   = tag
            call CFI_MPI_Isend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, comm % MPI_VAL, request % MPI_VAL, ierror_c)
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
            integer(kind=c_int) :: count_c, source_c, tag_c, ierror_c
            type(MPI_Status), intent(inout) :: stat
            count_c = count
            source_c = source 
            tag_c = tag
            call C_MPI_Recv(buffer, count_c, datatype % MPI_VAL, source_c, tag_c, comm % MPI_VAL, stat, ierror_c)
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
            integer(kind=c_int) :: count_c, source_c, tag_c, ierror_c
            type(MPI_Status), intent(inout) :: stat
            count_c = count
            source_c = source 
            tag_c = tag
            call CFI_MPI_Recv(buffer, count_c, datatype % MPI_VAL, source_c, tag_c, comm % MPI_VAL, stat, ierror_c)
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
            integer(kind=c_int) :: count_c, source_c, tag_c, ierror_c
            count_c = count
            source_c = source 
            tag_c = tag
            call C_MPI_Irecv(buffer, count_c, datatype % MPI_VAL, source_c, tag_c, comm % MPI_VAL, request % MPI_VAL, ierror_c)
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
            integer(kind=c_int) :: count_c, source_c, tag_c, ierror_c
            count_c = count
            source_c = source 
            tag_c = tag
            call CFI_MPI_Irecv(buffer, count_c, datatype % MPI_VAL, source_c, tag_c, comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Irecv_f08ts
#endif

        subroutine MPI_Pack_f08(inbuf, incount, datatype, outbuf, outsize, position, comm, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: C_MPI_Pack
!dir$ ignore_tkr inbuf
            integer, dimension(*), intent(in) :: inbuf
            integer, intent(in) :: incount, outsize
            type(MPI_Datatype), intent(in) :: datatype
!dir$ ignore_tkr outbuf
            integer, dimension(*), intent(out) :: outbuf
            integer, intent(inout) :: position
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: incount_c, outsize_c, position_c, ierror_c
            incount_c  = incount
            outsize_c  = outsize
            position_c = position
            call C_MPI_Pack(inbuf, incount_c, datatype % MPI_VAL, outbuf, outsize_c, position_c, comm % MPI_VAL, ierror_c)
            position  = position_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Pack_f08

#ifdef HAVE_CFI
        subroutine MPI_Pack_f08ts(inbuf, incount, datatype, outbuf, outsize, position, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: CFI_MPI_Pack
            type(*), dimension(..), intent(in) :: inbuf
            integer, intent(in) :: incount, outsize
            type(MPI_Datatype), intent(in) :: datatype
            type(*), dimension(..), intent(inout) :: outbuf
            integer, intent(inout) :: position
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: incount_c, outsize_c, position_c, ierror_c
            incount_c  = incount
            outsize_c  = outsize
            position_c = position
            call CFI_MPI_Pack(inbuf, incount_c, datatype % MPI_VAL, outbuf, outsize_c, position_c, comm % MPI_VAL, ierror_c)
            position  = position_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Pack_f08ts
#endif

        subroutine MPI_Unpack_f08(inbuf, insize, position, outbuf, outcount, datatype, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: C_MPI_Unpack
!dir$ ignore_tkr inbuf
            integer, dimension(*), intent(in) :: inbuf
            integer, intent(in) :: insize, outcount
            integer, intent(inout) :: position
!dir$ ignore_tkr outbuf
            integer, dimension(*), intent(out) :: outbuf
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: insize_c, position_c, outcount_c, ierror_c
            insize_c   = insize
            position_c = position
            outcount_c = outcount
            call C_MPI_Unpack(inbuf, insize_c, position_c, outbuf, outcount_c, datatype % MPI_VAL, comm % MPI_VAL, ierror_c)
            position = position_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Unpack_f08

#ifdef HAVE_CFI
        subroutine MPI_Unpack_f08ts(inbuf, insize, position, outbuf, outcount, datatype, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: CFI_MPI_Unpack
            type(*), dimension(..), intent(in) :: inbuf
            integer, intent(in) :: insize, outcount
            integer, intent(inout) :: position
            type(*), dimension(..), intent(inout) :: outbuf
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: insize_c, position_c, outcount_c, ierror_c
            insize_c   = insize
            position_c = position
            outcount_c = outcount
            call CFI_MPI_Unpack(inbuf, insize_c, position_c, outbuf, outcount_c, datatype % MPI_VAL, comm % MPI_VAL, ierror_c)
            position = position_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Unpack_f08ts
#endif

end module mpi_p2p_f
