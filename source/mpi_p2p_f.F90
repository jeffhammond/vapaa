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

    interface MPI_Iprobe
        module procedure MPI_Iprobe_f08
    end interface MPI_Iprobe

    interface MPI_Improbe
        module procedure MPI_Improbe_f08
    end interface MPI_Improbe

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
        subroutine MPI_Send_f08ts(buffer, count, datatype, dest, tag, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            type(*), dimension(..), intent(in) :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
        end subroutine MPI_Send_f08ts
        subroutine MPI_Send_c_f08ts(buffer, count, datatype, dest, tag, comm, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            type(*), dimension(..), intent(in) :: buffer
            integer(kind=MPI_COUNT_KIND), intent(in) :: count
            integer, intent(in) :: dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
        end subroutine MPI_Send_c_f08ts
#elif defined(HAVE_PGIF)
        module procedure MPI_Send_pgif_f08ts
        module procedure MPI_Send_c_pgif_f08ts
#else
        module procedure MPI_Send_f08
        module procedure MPI_Send_c_f08
#endif
    end interface MPI_Send

    interface PMPI_Send
#ifdef HAVE_CFI
        module procedure PMPI_Send_f08ts
        module procedure PMPI_Send_c_f08ts
#elif defined(HAVE_PGIF)
        module procedure MPI_Send_pgif_f08ts
        module procedure MPI_Send_c_pgif_f08ts
#else
        module procedure MPI_Send_f08
        module procedure MPI_Send_c_f08
#endif
    end interface PMPI_Send

    interface MPI_Bsend
#ifdef HAVE_CFI
        module procedure MPI_Bsend_f08ts
#else
        module procedure MPI_Bsend_f08
#endif
    end interface MPI_Bsend

    interface MPI_Ssend
#ifdef HAVE_CFI
        module procedure MPI_Ssend_f08ts
#else
        module procedure MPI_Ssend_f08
#endif
    end interface MPI_Ssend

    interface MPI_Rsend
#ifdef HAVE_CFI
        module procedure MPI_Rsend_f08ts
#else
        module procedure MPI_Rsend_f08
#endif
    end interface MPI_Rsend

    interface MPI_Buffer_attach
#ifdef HAVE_CFI
        module procedure MPI_Buffer_attach_f08ts
#endif
    end interface MPI_Buffer_attach

    interface MPI_Buffer_detach
        module procedure MPI_Buffer_detach_f08
    end interface MPI_Buffer_detach

    interface MPI_Buffer_flush
        module procedure MPI_Buffer_flush_f08
    end interface MPI_Buffer_flush

    interface MPI_Buffer_iflush
        module procedure MPI_Buffer_iflush_f08
    end interface MPI_Buffer_iflush

    interface MPI_Isend
#ifdef HAVE_CFI
        module procedure MPI_Isend_f08ts
#elif defined(HAVE_PGIF)
        module procedure MPI_Isend_pgif_f08ts
#else
        module procedure MPI_Isend_f08
#endif
    end interface MPI_Isend

    interface MPI_Ibsend
#ifdef HAVE_CFI
        module procedure MPI_Ibsend_f08ts
#else
        module procedure MPI_Ibsend_f08
#endif
    end interface MPI_Ibsend

    interface MPI_Issend
#ifdef HAVE_CFI
        module procedure MPI_Issend_f08ts
#else
        module procedure MPI_Issend_f08
#endif
    end interface MPI_Issend

    interface MPI_Irsend
#ifdef HAVE_CFI
        module procedure MPI_Irsend_f08ts
#else
        module procedure MPI_Irsend_f08
#endif
    end interface MPI_Irsend

    interface MPI_Recv
#ifdef HAVE_CFI
        subroutine MPI_Recv_f08ts(buffer, count, datatype, source, tag, comm, status, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Status
            type(*), dimension(..) :: buffer
            integer, intent(in) :: count, source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Status), intent(out), target :: status
            integer, optional, intent(out) :: ierror
        end subroutine MPI_Recv_f08ts
        subroutine MPI_Recv_c_f08ts(buffer, count, datatype, source, tag, comm, status, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Status
            type(*), dimension(..), asynchronous :: buffer
            integer(kind=MPI_COUNT_KIND), intent(in) :: count
            integer, intent(in) :: source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Status), intent(out), target :: status
            integer, optional, intent(out) :: ierror
        end subroutine MPI_Recv_c_f08ts
#elif defined(HAVE_PGIF)
        module procedure MPI_Recv_pgif_f08ts
        module procedure MPI_Recv_c_pgif_f08ts
#else
        module procedure MPI_Recv_f08
        module procedure MPI_Recv_c_f08
#endif
    end interface MPI_Recv

    interface PMPI_Recv
#ifdef HAVE_CFI
        module procedure PMPI_Recv_f08ts
        module procedure PMPI_Recv_c_f08ts
#elif defined(HAVE_PGIF)
        module procedure MPI_Recv_pgif_f08ts
        module procedure MPI_Recv_c_pgif_f08ts
#else
        module procedure MPI_Recv_f08
        module procedure MPI_Recv_c_f08
#endif
    end interface PMPI_Recv

    interface MPI_Irecv
#ifdef HAVE_CFI
        module procedure MPI_Irecv_f08ts
#elif defined(HAVE_PGIF)
        module procedure MPI_Irecv_pgif_f08ts
#else
#ifndef __NVCOMPILER
        module procedure MPI_Irecv_scalar_f08
#endif
        module procedure MPI_Irecv_f08
#endif
    end interface MPI_Irecv

    interface MPI_Send_init
#ifdef HAVE_CFI
        module procedure MPI_Send_init_f08ts
#else
        module procedure MPI_Send_init_f08
#endif
    end interface MPI_Send_init

    interface MPI_Bsend_init
#ifdef HAVE_CFI
        module procedure MPI_Bsend_init_f08ts
#else
        module procedure MPI_Bsend_init_f08
#endif
    end interface MPI_Bsend_init

    interface MPI_Ssend_init
#ifdef HAVE_CFI
        module procedure MPI_Ssend_init_f08ts
#else
        module procedure MPI_Ssend_init_f08
#endif
    end interface MPI_Ssend_init

    interface MPI_Rsend_init
#ifdef HAVE_CFI
        module procedure MPI_Rsend_init_f08ts
#else
        module procedure MPI_Rsend_init_f08
#endif
    end interface MPI_Rsend_init

    interface MPI_Recv_init
#ifdef HAVE_CFI
        module procedure MPI_Recv_init_f08ts
#else
        module procedure MPI_Recv_init_f08
#endif
    end interface MPI_Recv_init

    interface MPI_Psend_init
#ifdef HAVE_CFI
        module procedure MPI_Psend_init_f08ts
#else
        module procedure MPI_Psend_init_f08
#endif
    end interface MPI_Psend_init

    interface MPI_Precv_init
#ifdef HAVE_CFI
        module procedure MPI_Precv_init_f08ts
#else
        module procedure MPI_Precv_init_f08
#endif
    end interface MPI_Precv_init

    interface MPI_Pready
        module procedure MPI_Pready_f08
    end interface MPI_Pready

    interface MPI_Pready_list
        module procedure MPI_Pready_list_f08
    end interface MPI_Pready_list

    interface MPI_Pready_range
        module procedure MPI_Pready_range_f08
    end interface MPI_Pready_range

    interface MPI_Parrived
        module procedure MPI_Parrived_f08
    end interface MPI_Parrived

    interface MPI_Mrecv
#ifdef HAVE_CFI
        module procedure MPI_Mrecv_f08ts
#else
        module procedure MPI_Mrecv_f08
#endif
    end interface MPI_Mrecv

    interface MPI_Imrecv
#ifdef HAVE_CFI
        module procedure MPI_Imrecv_f08ts
#else
        module procedure MPI_Imrecv_f08
#endif
    end interface MPI_Imrecv

    interface MPI_Sendrecv
#ifdef HAVE_CFI
        module procedure MPI_Sendrecv_f08ts
#else
        module procedure MPI_Sendrecv_f08
#endif
    end interface MPI_Sendrecv

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

        subroutine MPI_Iprobe_f08(source, tag, comm, flag, stat, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Status
            use mpi_p2p_c, only: C_MPI_Iprobe
            integer, intent(in) :: source, tag
            type(MPI_Comm), intent(in) :: comm
            logical, intent(out) :: flag
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: source_c, tag_c, flag_c, ierror_c
            source_c  = source
            tag_c     = tag
            call C_MPI_Iprobe(source_c, tag_c, comm % MPI_VAL, flag_c, stat, ierror_c)
            flag = (flag_c .ne. 0)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Iprobe_f08

        subroutine MPI_Improbe_f08(source, tag, comm, flag, message, stat, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Message, MPI_Status
            use mpi_p2p_c, only: C_MPI_Improbe
            integer, intent(in) :: source, tag
            type(MPI_Comm), intent(in) :: comm
            logical, intent(out) :: flag
            type(MPI_Message), intent(out) :: message
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: source_c, tag_c, flag_c, ierror_c
            source_c = source
            tag_c = tag
            call C_MPI_Improbe(source_c, tag_c, comm % MPI_VAL, flag_c, message % MPI_VAL, stat, ierror_c)
            flag = (flag_c .ne. 0)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Improbe_f08

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

        subroutine MPI_Send_c_f08(buffer, count, datatype, dest, tag, comm, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: C_MPI_Send_c
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in) :: buffer
            integer(kind=MPI_COUNT_KIND), intent(in) :: count
            integer, intent(in) :: dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: dest_c, tag_c, ierror_c
            dest_c = dest
            tag_c = tag
            call C_MPI_Send_c(buffer, count, datatype % MPI_VAL, dest_c, tag_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Send_c_f08

#ifdef HAVE_CFI
        subroutine PMPI_Send_f08ts(buffer, count, datatype, dest, tag, comm, ierror)
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
        end subroutine PMPI_Send_f08ts

        subroutine PMPI_Send_c_f08ts(buffer, count, datatype, dest, tag, comm, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: CFI_MPI_Send_c
            type(*), dimension(..), intent(in) :: buffer
            integer(kind=MPI_COUNT_KIND), intent(in) :: count
            integer, intent(in) :: dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: dest_c, tag_c, ierror_c
            dest_c = dest
            tag_c = tag
            call CFI_MPI_Send_c(buffer, count, datatype % MPI_VAL, dest_c, tag_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine PMPI_Send_c_f08ts
#endif

#ifdef HAVE_PGIF
        subroutine MPI_Send_pgif_f08ts(buffer, count, datatype, dest, tag, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: PGIF_MPI_Send
            type(*), dimension(..), intent(in) :: buffer
!pgi$ ignore_tkr(c) buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call PGIF_MPI_Send(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                               comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Send_pgif_f08ts

        subroutine MPI_Send_c_pgif_f08ts(buffer, count, datatype, dest, tag, comm, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: PGIF_MPI_Send_c
            type(*), dimension(..), intent(in) :: buffer
!pgi$ ignore_tkr(c) buffer
            integer(kind=MPI_COUNT_KIND), intent(in) :: count
            integer, intent(in) :: dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: dest_c, tag_c, ierror_c
            dest_c = dest
            tag_c = tag
            call PGIF_MPI_Send_c(buffer, count, datatype % MPI_VAL, dest_c, tag_c, &
                                 comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Send_c_pgif_f08ts
#endif

        subroutine MPI_Bsend_f08(buffer, count, datatype, dest, tag, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: C_MPI_Bsend
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in) :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call C_MPI_Bsend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Bsend_f08

#ifdef HAVE_CFI
        subroutine MPI_Bsend_f08ts(buffer, count, datatype, dest, tag, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: CFI_MPI_Bsend
            type(*), dimension(..), intent(in) :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call CFI_MPI_Bsend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Bsend_f08ts
#endif

        subroutine MPI_Ssend_f08(buffer, count, datatype, dest, tag, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: C_MPI_Ssend
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in) :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call C_MPI_Ssend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Ssend_f08

#ifdef HAVE_CFI
        subroutine MPI_Ssend_f08ts(buffer, count, datatype, dest, tag, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: CFI_MPI_Ssend
            type(*), dimension(..), intent(in) :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call CFI_MPI_Ssend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Ssend_f08ts
#endif

        subroutine MPI_Rsend_f08(buffer, count, datatype, dest, tag, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: C_MPI_Rsend
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in) :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call C_MPI_Rsend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Rsend_f08

#ifdef HAVE_CFI
        subroutine MPI_Rsend_f08ts(buffer, count, datatype, dest, tag, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_p2p_c, only: CFI_MPI_Rsend
            type(*), dimension(..), intent(in) :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call CFI_MPI_Rsend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Rsend_f08ts
#endif

#ifdef HAVE_CFI
        subroutine MPI_Buffer_attach_f08ts(buffer, size, ierror)
            use mpi_p2p_c, only: CFI_MPI_Buffer_attach
            type(*), dimension(..), asynchronous :: buffer
            integer, intent(in) :: size
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: size_c, ierror_c
            size_c = size
            call CFI_MPI_Buffer_attach(buffer, size_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Buffer_attach_f08ts
#endif

        subroutine MPI_Buffer_detach_f08(buffer_addr, size, ierror)
            use iso_c_binding, only: c_ptr
            use mpi_p2p_c, only: C_MPI_Buffer_detach
            type(c_ptr), intent(out) :: buffer_addr
            integer, intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: size_c, ierror_c
            call C_MPI_Buffer_detach(buffer_addr, size_c, ierror_c)
            size = size_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Buffer_detach_f08

        subroutine MPI_Buffer_flush_f08(ierror)
            use mpi_p2p_c, only: C_MPI_Buffer_flush
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Buffer_flush(ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Buffer_flush_f08

        subroutine MPI_Buffer_iflush_f08(request, ierror)
            use mpi_handle_types, only: MPI_Request
            use mpi_p2p_c, only: C_MPI_Buffer_iflush
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Buffer_iflush(request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Buffer_iflush_f08

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

#ifdef HAVE_PGIF
        subroutine MPI_Isend_pgif_f08ts(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: PGIF_MPI_Isend
            type(*), dimension(..), intent(in), asynchronous :: buffer
!pgi$ ignore_tkr(c) buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call PGIF_MPI_Isend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Isend_pgif_f08ts
#endif

        subroutine MPI_Ibsend_f08(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: C_MPI_Ibsend
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call C_MPI_Ibsend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                              comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Ibsend_f08

#ifdef HAVE_CFI
        subroutine MPI_Ibsend_f08ts(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Ibsend
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call CFI_MPI_Ibsend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Ibsend_f08ts
#endif

        subroutine MPI_Issend_f08(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: C_MPI_Issend
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call C_MPI_Issend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                              comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Issend_f08

#ifdef HAVE_CFI
        subroutine MPI_Issend_f08ts(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Issend
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call CFI_MPI_Issend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Issend_f08ts
#endif

        subroutine MPI_Irsend_f08(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: C_MPI_Irsend
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call C_MPI_Irsend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                              comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Irsend_f08

#ifdef HAVE_CFI
        subroutine MPI_Irsend_f08ts(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Irsend
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call CFI_MPI_Irsend(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Irsend_f08ts
#endif

        subroutine MPI_Send_init_f08(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: C_MPI_Send_init
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call C_MPI_Send_init(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                 comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Send_init_f08

#ifdef HAVE_CFI
        subroutine MPI_Send_init_f08ts(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Send_init
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call CFI_MPI_Send_init(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                   comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Send_init_f08ts
#endif

        subroutine MPI_Bsend_init_f08(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: C_MPI_Bsend_init
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call C_MPI_Bsend_init(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                  comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Bsend_init_f08

#ifdef HAVE_CFI
        subroutine MPI_Bsend_init_f08ts(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Bsend_init
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call CFI_MPI_Bsend_init(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                    comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Bsend_init_f08ts
#endif

        subroutine MPI_Ssend_init_f08(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: C_MPI_Ssend_init
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call C_MPI_Ssend_init(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                  comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Ssend_init_f08

#ifdef HAVE_CFI
        subroutine MPI_Ssend_init_f08ts(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Ssend_init
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call CFI_MPI_Ssend_init(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                    comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Ssend_init_f08ts
#endif

        subroutine MPI_Rsend_init_f08(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: C_MPI_Rsend_init
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call C_MPI_Rsend_init(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                  comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Rsend_init_f08

#ifdef HAVE_CFI
        subroutine MPI_Rsend_init_f08ts(buffer, count, datatype, dest, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Rsend_init
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer, intent(in) :: count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, dest_c, tag_c, ierror_c
            count_c = count
            dest_c = dest
            tag_c = tag
            call CFI_MPI_Rsend_init(buffer, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                    comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Rsend_init_f08ts
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

        subroutine MPI_Recv_c_f08(buffer, count, datatype, source, tag, comm, stat, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Status
            use mpi_p2p_c, only: C_MPI_Recv_c
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(out) :: buffer
            integer(kind=MPI_COUNT_KIND), intent(in) :: count
            integer, intent(in) :: source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: source_c, tag_c, ierror_c
            source_c = source
            tag_c = tag
            call C_MPI_Recv_c(buffer, count, datatype % MPI_VAL, source_c, tag_c, comm % MPI_VAL, stat, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Recv_c_f08

#ifdef HAVE_CFI
        subroutine PMPI_Recv_f08ts(buffer, count, datatype, source, tag, comm, stat, ierror)
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
        end subroutine PMPI_Recv_f08ts

        subroutine PMPI_Recv_c_f08ts(buffer, count, datatype, source, tag, comm, stat, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Status
            use mpi_p2p_c, only: CFI_MPI_Recv_c
            type(*), dimension(..), intent(inout), asynchronous :: buffer
            integer(kind=MPI_COUNT_KIND), intent(in) :: count
            integer, intent(in) :: source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: source_c, tag_c, ierror_c
            source_c = source
            tag_c = tag
            call CFI_MPI_Recv_c(buffer, count, datatype % MPI_VAL, source_c, tag_c, comm % MPI_VAL, stat, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine PMPI_Recv_c_f08ts
#endif

#ifdef HAVE_PGIF
        subroutine MPI_Recv_pgif_f08ts(buffer, count, datatype, source, tag, comm, stat, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Status
            use mpi_p2p_c, only: PGIF_MPI_Recv
            type(*), dimension(..), intent(inout) :: buffer
!pgi$ ignore_tkr(c) buffer
            integer, intent(in) :: count, source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, source_c, tag_c, ierror_c
            count_c = count
            source_c = source
            tag_c = tag
            call PGIF_MPI_Recv(buffer, count_c, datatype % MPI_VAL, source_c, tag_c, &
                               comm % MPI_VAL, stat, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Recv_pgif_f08ts

        subroutine MPI_Recv_c_pgif_f08ts(buffer, count, datatype, source, tag, comm, stat, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Status
            use mpi_p2p_c, only: PGIF_MPI_Recv_c
            type(*), dimension(..), intent(inout), asynchronous :: buffer
!pgi$ ignore_tkr(c) buffer
            integer(kind=MPI_COUNT_KIND), intent(in) :: count
            integer, intent(in) :: source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: source_c, tag_c, ierror_c
            source_c = source
            tag_c = tag
            call PGIF_MPI_Recv_c(buffer, count, datatype % MPI_VAL, source_c, tag_c, &
                                 comm % MPI_VAL, stat, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Recv_c_pgif_f08ts
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

        subroutine MPI_Irecv_scalar_f08(buffer, count, datatype, source, tag, comm, request, ierror)
            use mpi_error_f, only: MPI_ERR_COUNT
            use mpi_global_constants, only: MPI_REQUEST_NULL
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: C_MPI_Irecv
            integer, intent(in), asynchronous :: buffer
            integer, intent(in) :: count, source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: buffer_c(1)
            integer(kind=c_int) :: count_c, source_c, tag_c, ierror_c
            if (count .ne. 0) then
                request = MPI_REQUEST_NULL
                if (present(ierror)) ierror = MPI_ERR_COUNT
                return
            end if
            buffer_c(1) = buffer
            count_c = count
            source_c = source
            tag_c = tag
            call C_MPI_Irecv(buffer_c, count_c, datatype % MPI_VAL, source_c, tag_c, comm % MPI_VAL, &
                             request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Irecv_scalar_f08

#ifdef HAVE_CFI
        subroutine MPI_Irecv_f08ts(buffer, count, datatype, source, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Irecv
            type(*), dimension(..), intent(in), asynchronous :: buffer
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

#ifdef HAVE_PGIF
        subroutine MPI_Irecv_pgif_f08ts(buffer, count, datatype, source, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: PGIF_MPI_Irecv
            type(*), dimension(..), intent(inout), asynchronous :: buffer
!pgi$ ignore_tkr(c) buffer
            integer, intent(in) :: count, source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, source_c, tag_c, ierror_c
            count_c = count
            source_c = source
            tag_c = tag
            call PGIF_MPI_Irecv(buffer, count_c, datatype % MPI_VAL, source_c, tag_c, &
                                comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Irecv_pgif_f08ts
#endif

        subroutine MPI_Recv_init_f08(buffer, count, datatype, source, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: C_MPI_Recv_init
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(inout), asynchronous :: buffer
            integer, intent(in) :: count, source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, source_c, tag_c, ierror_c
            count_c = count
            source_c = source
            tag_c = tag
            call C_MPI_Recv_init(buffer, count_c, datatype % MPI_VAL, source_c, tag_c, &
                                 comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Recv_init_f08

#ifdef HAVE_CFI
        subroutine MPI_Recv_init_f08ts(buffer, count, datatype, source, tag, comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Recv_init
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
            call CFI_MPI_Recv_init(buffer, count_c, datatype % MPI_VAL, source_c, tag_c, &
                                   comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Recv_init_f08ts
#endif

        subroutine MPI_Psend_init_f08(buffer, partitions, count, datatype, dest, tag, comm, info, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Info, MPI_Request
            use mpi_p2p_c, only: C_MPI_Psend_init
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(in), asynchronous :: buffer
            integer, intent(in) :: partitions, count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: partitions_c, count_c, dest_c, tag_c, ierror_c
            partitions_c = partitions
            count_c = count
            dest_c = dest
            tag_c = tag
            call C_MPI_Psend_init(buffer, partitions_c, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                  comm % MPI_VAL, info % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Psend_init_f08

#ifdef HAVE_CFI
        subroutine MPI_Psend_init_f08ts(buffer, partitions, count, datatype, dest, tag, comm, info, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Info, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Psend_init
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer, intent(in) :: partitions, count, dest, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: partitions_c, count_c, dest_c, tag_c, ierror_c
            partitions_c = partitions
            count_c = count
            dest_c = dest
            tag_c = tag
            call CFI_MPI_Psend_init(buffer, partitions_c, count_c, datatype % MPI_VAL, dest_c, tag_c, &
                                    comm % MPI_VAL, info % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Psend_init_f08ts
#endif

        subroutine MPI_Precv_init_f08(buffer, partitions, count, datatype, source, tag, comm, info, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Info, MPI_Request
            use mpi_p2p_c, only: C_MPI_Precv_init
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(inout), asynchronous :: buffer
            integer, intent(in) :: partitions, count, source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: partitions_c, count_c, source_c, tag_c, ierror_c
            partitions_c = partitions
            count_c = count
            source_c = source
            tag_c = tag
            call C_MPI_Precv_init(buffer, partitions_c, count_c, datatype % MPI_VAL, source_c, tag_c, &
                                  comm % MPI_VAL, info % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Precv_init_f08

#ifdef HAVE_CFI
        subroutine MPI_Precv_init_f08ts(buffer, partitions, count, datatype, source, tag, comm, info, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Info, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Precv_init
            type(*), dimension(..), intent(inout), asynchronous :: buffer
            integer, intent(in) :: partitions, count, source, tag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: partitions_c, count_c, source_c, tag_c, ierror_c
            partitions_c = partitions
            count_c = count
            source_c = source
            tag_c = tag
            call CFI_MPI_Precv_init(buffer, partitions_c, count_c, datatype % MPI_VAL, source_c, tag_c, &
                                    comm % MPI_VAL, info % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Precv_init_f08ts
#endif

        subroutine MPI_Pready_f08(partition, request, ierror)
            use mpi_handle_types, only: MPI_Request
            use mpi_p2p_c, only: C_MPI_Pready
            integer, intent(in) :: partition
            type(MPI_Request), intent(in) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: partition_c, ierror_c
            partition_c = partition
            call C_MPI_Pready(partition_c, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Pready_f08

        subroutine MPI_Pready_list_f08(length, partitions, request, ierror)
            use mpi_handle_types, only: MPI_Request
            use mpi_p2p_c, only: C_MPI_Pready_list
            integer, intent(in) :: length
            integer, intent(in) :: partitions(length)
            type(MPI_Request), intent(in) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: length_c, partitions_c(length), ierror_c
            length_c = length
            partitions_c = partitions
            call C_MPI_Pready_list(length_c, partitions_c, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Pready_list_f08

        subroutine MPI_Pready_range_f08(partition_low, partition_high, request, ierror)
            use mpi_handle_types, only: MPI_Request
            use mpi_p2p_c, only: C_MPI_Pready_range
            integer, intent(in) :: partition_low, partition_high
            type(MPI_Request), intent(in) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: partition_low_c, partition_high_c, ierror_c
            partition_low_c = partition_low
            partition_high_c = partition_high
            call C_MPI_Pready_range(partition_low_c, partition_high_c, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Pready_range_f08

        subroutine MPI_Parrived_f08(request, partition, flag, ierror)
            use mpi_handle_types, only: MPI_Request
            use mpi_p2p_c, only: C_MPI_Parrived
            type(MPI_Request), intent(in) :: request
            integer, intent(in) :: partition
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: partition_c, flag_c, ierror_c
            partition_c = partition
            call C_MPI_Parrived(request % MPI_VAL, partition_c, flag_c, ierror_c)
            flag = (flag_c .ne. 0)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Parrived_f08

        subroutine MPI_Mrecv_f08(buffer, count, datatype, message, stat, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Message, MPI_Status
            use mpi_p2p_c, only: C_MPI_Mrecv
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(inout) :: buffer
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Message), intent(inout) :: message
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, ierror_c
            count_c = count
            call C_MPI_Mrecv(buffer, count_c, datatype % MPI_VAL, message % MPI_VAL, stat, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Mrecv_f08

#ifdef HAVE_CFI
        subroutine MPI_Mrecv_f08ts(buffer, count, datatype, message, stat, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Message, MPI_Status
            use mpi_p2p_c, only: CFI_MPI_Mrecv
            type(*), dimension(..), intent(inout) :: buffer
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Message), intent(inout) :: message
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, ierror_c
            count_c = count
            call CFI_MPI_Mrecv(buffer, count_c, datatype % MPI_VAL, message % MPI_VAL, stat, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Mrecv_f08ts
#endif

        subroutine MPI_Imrecv_f08(buffer, count, datatype, message, request, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Message, MPI_Request
            use mpi_p2p_c, only: C_MPI_Imrecv
!dir$ ignore_tkr buffer
            integer, dimension(*), intent(inout), asynchronous :: buffer
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Message), intent(inout) :: message
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, ierror_c
            count_c = count
            call C_MPI_Imrecv(buffer, count_c, datatype % MPI_VAL, message % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Imrecv_f08

#ifdef HAVE_CFI
        subroutine MPI_Imrecv_f08ts(buffer, count, datatype, message, request, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Message, MPI_Request
            use mpi_p2p_c, only: CFI_MPI_Imrecv
            type(*), dimension(..), intent(inout), asynchronous :: buffer
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Message), intent(inout) :: message
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, ierror_c
            count_c = count
            call CFI_MPI_Imrecv(buffer, count_c, datatype % MPI_VAL, message % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Imrecv_f08ts
#endif

        subroutine MPI_Sendrecv_f08(sbuffer, scount, sdatatype, dest, stag, &
                                    rbuffer, rcount, rdatatype, src,  rtag, &
                                    comm, stat, ierror) 
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Status
            use mpi_p2p_c, only: C_MPI_Sendrecv
!dir$ ignore_tkr sbuffer, rbuffer
            integer, dimension(*), intent(in) :: sbuffer
            integer, dimension(*), intent(inout) :: rbuffer
            integer, intent(in) :: scount, rcount, dest, src, stag, rtag
            type(MPI_Datatype), intent(in) :: sdatatype, rdatatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: scount_c, rcount_c, dest_c, src_c, stag_c, rtag_c, ierror_c
            ! buffer
            scount_c = scount
            dest_c = dest 
            stag_c = stag
            rcount_c = rcount
            src_c = src 
            rtag_c = rtag
            call C_MPI_Sendrecv(sbuffer, scount_c, sdatatype % MPI_VAL, dest_c, stag_c, &
                                rbuffer, rcount_c, rdatatype % MPI_VAL, src_c,  rtag_c, &
                                comm % MPI_VAL, stat, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Sendrecv_f08

#ifdef HAVE_CFI
        subroutine MPI_Sendrecv_f08ts(sbuffer, scount, sdatatype, dest, stag, &
                                      rbuffer, rcount, rdatatype, src,  rtag, &
                                      comm, stat, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Status
            use mpi_p2p_c, only: CFI_MPI_Sendrecv
            type(*), dimension(..), intent(in) :: sbuffer
            type(*), dimension(..), intent(inout) :: rbuffer
            integer, intent(in) :: scount, rcount, dest, src, stag, rtag
            type(MPI_Datatype), intent(in) :: sdatatype, rdatatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Status), intent(inout) :: stat
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: scount_c, rcount_c, dest_c, src_c, stag_c, rtag_c, ierror_c
            ! buffer
            scount_c = scount
            dest_c = dest 
            stag_c = stag
            rcount_c = rcount
            src_c = src 
            rtag_c = rtag
            call CFI_MPI_Sendrecv(sbuffer, scount_c, sdatatype % MPI_VAL, dest_c, stag_c, &
                                  rbuffer, rcount_c, rdatatype % MPI_VAL, src_c,  rtag_c, &
                                  comm % MPI_VAL, stat, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Sendrecv_f08ts
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
