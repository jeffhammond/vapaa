! SPDX-License-Identifier: MIT

module mpi_p2p_c

    interface
        subroutine C_MPI_Probe(source, tag, comm, status, ierror) &
                   bind(C,name="C_MPI_Probe")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in), value :: source, tag, comm
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Probe
    end interface

    interface
        subroutine C_MPI_Mprobe(source, tag, comm, message, status, ierror) &
                   bind(C,name="C_MPI_Mprobe")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in), value :: source, tag, comm
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(out) :: message, ierror
        end subroutine C_MPI_Mprobe
    end interface

    interface
        subroutine C_MPI_Iprobe(source, tag, comm, flag, status, ierror) &
                   bind(C,name="C_MPI_Iprobe")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in), value :: source, tag, comm
            integer(kind=c_int), intent(out) :: flag, ierror
            type(MPI_Status), intent(inout) :: status
        end subroutine C_MPI_Iprobe
    end interface

    interface
        subroutine C_MPI_Improbe(source, tag, comm, flag, message, status, ierror) &
                   bind(C,name="C_MPI_Improbe")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in), value :: source, tag, comm
            integer(kind=c_int), intent(out) :: flag, message, ierror
            type(MPI_Status), intent(inout) :: status
        end subroutine C_MPI_Improbe
    end interface

    interface
        subroutine C_MPI_Test(request, flag, status, ierror) &
                   bind(C,name="C_MPI_Test")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(inout) :: request
            integer(kind=c_int), intent(out) :: flag, ierror
            type(MPI_Status), intent(inout) :: status
        end subroutine C_MPI_Test
    end interface

    interface
        subroutine C_MPI_Testall(count, requests, flag, statuses, ierror) &
                   bind(C,name="C_MPI_Testall")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status, MPI_Request
            implicit none
            integer(kind=c_int), intent(in), value :: count
            type(MPI_Request), intent(inout) :: requests(*)
            integer(kind=c_int), intent(out) :: flag, ierror
            type(MPI_Status), intent(inout) :: statuses(*)
        end subroutine C_MPI_Testall
    end interface

    interface
        subroutine C_MPI_Testsome(incount, requests, outcount, indices, statuses, &
                                  ierror) &
                   bind(C,name="C_MPI_Testsome")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status, MPI_Request
            implicit none
            integer(kind=c_int), intent(in), value :: incount
            type(MPI_Request), intent(inout) :: requests(*)
            integer(kind=c_int), intent(out) :: outcount, indices(*)
            type(MPI_Status), intent(inout) :: statuses(*)
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Testsome
    end interface

    interface
        subroutine C_MPI_Testany(count, requests, index, flag, status, ierror) &
                   bind(C,name="C_MPI_Testany")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status, MPI_Request
            implicit none
            integer(kind=c_int), intent(in), value :: count
            type(MPI_Request), intent(inout) :: requests(*)
            integer(kind=c_int), intent(out) :: index, flag, ierror
            type(MPI_Status), intent(inout) :: status
        end subroutine C_MPI_Testany
    end interface

    interface
        subroutine C_MPI_Wait(request, status, ierror) &
                   bind(C,name="C_MPI_Wait")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(inout) :: request
            integer(kind=c_int), intent(out) :: ierror
            type(MPI_Status), intent(inout) :: status
        end subroutine C_MPI_Wait
    end interface

    interface
        subroutine C_MPI_Waitall(count, requests, statuses, ierror) &
                   bind(C,name="C_MPI_Waitall")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status, MPI_Request
            implicit none
            integer(kind=c_int), intent(in), value :: count
            type(MPI_Request), intent(inout) :: requests(*)
            type(MPI_Status), intent(out) :: statuses(*)
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Waitall
    end interface

    interface
        subroutine C_MPI_Waitsome(incount, requests, outcount, indices, statuses, &
                                  ierror) &
                   bind(C,name="C_MPI_Waitsome")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status, MPI_Request
            implicit none
            integer(kind=c_int), intent(in), value :: incount
            type(MPI_Request), intent(inout) :: requests(*)
            integer(kind=c_int), intent(out) :: outcount, indices(*)
            type(MPI_Status), intent(inout) :: statuses(*)
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Waitsome
    end interface

    interface
        subroutine C_MPI_Waitany(count, requests, index, status, ierror) &
                   bind(C,name="C_MPI_Waitany")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status, MPI_Request
            implicit none
            integer(kind=c_int), intent(in), value :: count
            type(MPI_Request), intent(inout) :: requests(*)
            integer(kind=c_int), intent(out) :: index, ierror
            type(MPI_Status), intent(inout) :: status
        end subroutine C_MPI_Waitany
    end interface

    interface
        subroutine C_MPI_Send(buffer, count, datatype, dest, tag, comm, &
                              ierror) &
                   bind(C,name="C_MPI_Send")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Send
    end interface

    interface
        subroutine C_MPI_Send_c(buffer, count, datatype, dest, tag, comm, &
                                ierror) &
                   bind(C,name="C_MPI_Send_c")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), dimension(*), intent(in) :: buffer
            integer(kind=c_int64_t), intent(in), value :: count
            integer(kind=c_int), intent(in), value :: datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Send_c
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Send(buffer, count, datatype, dest, tag, comm, &
                                ierror) &
                   bind(C,name="CFI_MPI_Send")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Send
    end interface

    interface
        subroutine CFI_MPI_Send_c(buffer, count, datatype, dest, tag, comm, &
                                  ierror) &
                   bind(C,name="CFI_MPI_Send_c")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            type(*), dimension(..), intent(in) :: buffer
            integer(kind=c_int64_t), intent(in), value :: count
            integer(kind=c_int), intent(in), value :: datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Send_c
    end interface
#endif

    interface
        subroutine C_MPI_Bsend(buffer, count, datatype, dest, tag, comm, &
                               ierror) &
                   bind(C,name="C_MPI_Bsend")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Bsend
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Bsend(buffer, count, datatype, dest, tag, comm, &
                                 ierror) &
                   bind(C,name="CFI_MPI_Bsend")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Bsend
    end interface
#endif

    interface
        subroutine C_MPI_Ssend(buffer, count, datatype, dest, tag, comm, &
                               ierror) &
                   bind(C,name="C_MPI_Ssend")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Ssend
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Ssend(buffer, count, datatype, dest, tag, comm, &
                                 ierror) &
                   bind(C,name="CFI_MPI_Ssend")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Ssend
    end interface
#endif

    interface
        subroutine C_MPI_Rsend(buffer, count, datatype, dest, tag, comm, &
                               ierror) &
                   bind(C,name="C_MPI_Rsend")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Rsend
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Rsend(buffer, count, datatype, dest, tag, comm, &
                                 ierror) &
                   bind(C,name="CFI_MPI_Rsend")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Rsend
    end interface
#endif

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Buffer_attach(buffer, size, ierror) &
                   bind(C,name="CFI_MPI_Buffer_attach")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: size
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Buffer_attach
    end interface
#endif

    interface
        subroutine C_MPI_Buffer_detach(buffer_addr, size, ierror) &
                   bind(C,name="C_MPI_Buffer_detach")
            use iso_c_binding, only: c_int, c_ptr
            implicit none
            type(c_ptr), intent(out) :: buffer_addr
            integer(kind=c_int), intent(out) :: size, ierror
        end subroutine C_MPI_Buffer_detach
    end interface

    interface
        subroutine C_MPI_Buffer_flush(ierror) &
                   bind(C,name="C_MPI_Buffer_flush")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Buffer_flush
    end interface

    interface
        subroutine C_MPI_Buffer_iflush(request, ierror) &
                   bind(C,name="C_MPI_Buffer_iflush")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Buffer_iflush
    end interface

    interface
        subroutine C_MPI_Isend(buffer, count, datatype, dest, tag, comm, request, &
                              ierror) &
                   bind(C,name="C_MPI_Isend")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Isend
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Isend(buffer, count, datatype, dest, tag, comm, request, &
                                 ierror) &
                   bind(C,name="CFI_MPI_Isend")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Isend
    end interface
#endif

    interface
        subroutine C_MPI_Ibsend(buffer, count, datatype, dest, tag, comm, request, &
                                ierror) &
                   bind(C,name="C_MPI_Ibsend")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Ibsend
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Ibsend(buffer, count, datatype, dest, tag, comm, request, &
                                  ierror) &
                   bind(C,name="CFI_MPI_Ibsend")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Ibsend
    end interface
#endif

    interface
        subroutine C_MPI_Issend(buffer, count, datatype, dest, tag, comm, request, &
                                ierror) &
                   bind(C,name="C_MPI_Issend")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Issend
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Issend(buffer, count, datatype, dest, tag, comm, request, &
                                  ierror) &
                   bind(C,name="CFI_MPI_Issend")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Issend
    end interface
#endif

    interface
        subroutine C_MPI_Irsend(buffer, count, datatype, dest, tag, comm, request, &
                                ierror) &
                   bind(C,name="C_MPI_Irsend")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Irsend
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Irsend(buffer, count, datatype, dest, tag, comm, request, &
                                  ierror) &
                   bind(C,name="CFI_MPI_Irsend")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Irsend
    end interface
#endif

    interface
        subroutine C_MPI_Recv(buffer, count, datatype, source, tag, comm, status, &
                              ierror) &
                   bind(C,name="C_MPI_Recv")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), dimension(*), intent(out) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, source, tag, comm
            type(MPI_Status), intent(out) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Recv
    end interface

    interface
        subroutine C_MPI_Recv_c(buffer, count, datatype, source, tag, comm, status, &
                                ierror) &
                   bind(C,name="C_MPI_Recv_c")
            use iso_c_binding, only: c_int, c_int64_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), dimension(*), intent(out) :: buffer
            integer(kind=c_int64_t), intent(in), value :: count
            integer(kind=c_int), intent(in), value :: datatype, source, tag, comm
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Recv_c
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Recv(buffer, count, datatype, source, tag, comm, status, &
                                ierror) &
                   bind(C,name="CFI_MPI_Recv")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(*), dimension(..), intent(inout) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, source, tag, comm
            type(MPI_Status), intent(out) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Recv
    end interface

    interface
        subroutine CFI_MPI_Recv_c(buffer, count, datatype, source, tag, comm, status, &
                                  ierror) &
                   bind(C,name="CFI_MPI_Recv_c")
            use iso_c_binding, only: c_int, c_int64_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(*), dimension(..), intent(inout), asynchronous :: buffer
            integer(kind=c_int64_t), intent(in), value :: count
            integer(kind=c_int), intent(in), value :: datatype, source, tag, comm
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Recv_c
    end interface
#endif

    interface
        subroutine C_MPI_Irecv(buffer, count, datatype, source, tag, comm, request, &
                              ierror) &
                   bind(C,name="C_MPI_Irecv")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, source, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Irecv
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Irecv(buffer, count, datatype, source, tag, comm, request, &
                                ierror) &
                   bind(C,name="CFI_MPI_Irecv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, source, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Irecv
    end interface
#endif

    interface
        subroutine C_MPI_Send_init(buffer, count, datatype, dest, tag, comm, request, &
                                   ierror) &
                   bind(C,name="C_MPI_Send_init")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Send_init
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Send_init(buffer, count, datatype, dest, tag, comm, request, &
                                     ierror) &
                   bind(C,name="CFI_MPI_Send_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Send_init
    end interface
#endif

    interface
        subroutine C_MPI_Bsend_init(buffer, count, datatype, dest, tag, comm, request, &
                                    ierror) &
                   bind(C,name="C_MPI_Bsend_init")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Bsend_init
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Bsend_init(buffer, count, datatype, dest, tag, comm, request, &
                                      ierror) &
                   bind(C,name="CFI_MPI_Bsend_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Bsend_init
    end interface
#endif

    interface
        subroutine C_MPI_Ssend_init(buffer, count, datatype, dest, tag, comm, request, &
                                    ierror) &
                   bind(C,name="C_MPI_Ssend_init")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Ssend_init
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Ssend_init(buffer, count, datatype, dest, tag, comm, request, &
                                      ierror) &
                   bind(C,name="CFI_MPI_Ssend_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Ssend_init
    end interface
#endif

    interface
        subroutine C_MPI_Rsend_init(buffer, count, datatype, dest, tag, comm, request, &
                                    ierror) &
                   bind(C,name="C_MPI_Rsend_init")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Rsend_init
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Rsend_init(buffer, count, datatype, dest, tag, comm, request, &
                                      ierror) &
                   bind(C,name="CFI_MPI_Rsend_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, dest, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Rsend_init
    end interface
#endif

    interface
        subroutine C_MPI_Recv_init(buffer, count, datatype, source, tag, comm, request, &
                                   ierror) &
                   bind(C,name="C_MPI_Recv_init")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(inout), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, source, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Recv_init
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Recv_init(buffer, count, datatype, source, tag, comm, request, &
                                     ierror) &
                   bind(C,name="CFI_MPI_Recv_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(inout), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype, source, tag, comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Recv_init
    end interface
#endif

    interface
        subroutine C_MPI_Pready(partition, request, ierror) &
                   bind(C,name="C_MPI_Pready")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: partition, request
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Pready
    end interface

    interface
        subroutine C_MPI_Pready_list(length, partitions, request, ierror) &
                   bind(C,name="C_MPI_Pready_list")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: length, request
            integer(kind=c_int), intent(in) :: partitions(*)
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Pready_list
    end interface

    interface
        subroutine C_MPI_Pready_range(partition_low, partition_high, request, ierror) &
                   bind(C,name="C_MPI_Pready_range")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: partition_low, partition_high, request
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Pready_range
    end interface

    interface
        subroutine C_MPI_Parrived(request, partition, flag, ierror) &
                   bind(C,name="C_MPI_Parrived")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: request, partition
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine C_MPI_Parrived
    end interface

    interface
        subroutine C_MPI_Psend_init(buffer, partitions, count, datatype, dest, tag, comm, info, request, &
                                    ierror) &
                   bind(C,name="C_MPI_Psend_init")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: partitions, count, datatype, dest, tag, comm, info
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Psend_init
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Psend_init(buffer, partitions, count, datatype, dest, tag, comm, info, request, &
                                      ierror) &
                   bind(C,name="CFI_MPI_Psend_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: partitions, count, datatype, dest, tag, comm, info
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Psend_init
    end interface
#endif

    interface
        subroutine C_MPI_Precv_init(buffer, partitions, count, datatype, source, tag, comm, info, request, &
                                    ierror) &
                   bind(C,name="C_MPI_Precv_init")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(inout), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: partitions, count, datatype, source, tag, comm, info
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Precv_init
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Precv_init(buffer, partitions, count, datatype, source, tag, comm, info, request, &
                                      ierror) &
                   bind(C,name="CFI_MPI_Precv_init")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(inout), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: partitions, count, datatype, source, tag, comm, info
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Precv_init
    end interface
#endif

    interface
        subroutine C_MPI_Mrecv(buffer, count, datatype, message, status, ierror) &
                   bind(C,name="C_MPI_Mrecv")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), dimension(*), intent(inout) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype
            integer(kind=c_int), intent(inout) :: message
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Mrecv
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Mrecv(buffer, count, datatype, message, status, ierror) &
                   bind(C,name="CFI_MPI_Mrecv")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(*), dimension(..), intent(inout) :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype
            integer(kind=c_int), intent(inout) :: message
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Mrecv
    end interface
#endif

    interface
        subroutine C_MPI_Imrecv(buffer, count, datatype, message, request, ierror) &
                   bind(C,name="C_MPI_Imrecv")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(inout), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype
            integer(kind=c_int), intent(inout) :: message
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Imrecv
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Imrecv(buffer, count, datatype, message, request, ierror) &
                   bind(C,name="CFI_MPI_Imrecv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(inout), asynchronous :: buffer
            integer(kind=c_int), intent(in), value :: count, datatype
            integer(kind=c_int), intent(inout) :: message
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Imrecv
    end interface
#endif

    interface
        subroutine C_MPI_Sendrecv(sbuffer, scount, sdatatype, dest, stag, &
                                  rbuffer, rcount, rdatatype, src,  rtag, &
                                  comm, status, ierror) &
                   bind(C,name="C_MPI_Sendrecv")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), dimension(*), intent(in) :: sbuffer
            integer(kind=c_int), dimension(*), intent(inout) :: rbuffer
            integer(kind=c_int), intent(in), value :: scount, rcount
            integer(kind=c_int), intent(in), value :: sdatatype, rdatatype
            integer(kind=c_int), intent(in), value :: dest, src
            integer(kind=c_int), intent(in), value :: stag, rtag, comm
            type(MPI_Status), intent(out) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Sendrecv
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Sendrecv(sbuffer, scount, sdatatype, dest, stag, &
                                  rbuffer, rcount, rdatatype, src,  rtag, &
                                  comm, status, ierror) &
                   bind(C,name="CFI_MPI_Sendrecv")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(*), dimension(..), intent(in) :: sbuffer
            type(*), dimension(..), intent(inout) :: rbuffer
            integer(kind=c_int), intent(in), value :: scount, rcount
            integer(kind=c_int), intent(in), value :: sdatatype, rdatatype
            integer(kind=c_int), intent(in), value :: dest, src
            integer(kind=c_int), intent(in), value :: stag, rtag, comm
            type(MPI_Status), intent(out) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Sendrecv
    end interface
#endif

    interface
        subroutine C_MPI_Pack(inbuf, incount, datatype, outbuf, outsize, position, comm, &
                              ierror) &
                   bind(C,name="C_MPI_Pack")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in) :: inbuf
            integer(kind=c_int), dimension(*), intent(inout) :: outbuf
            integer(kind=c_int), intent(in), value :: incount, outsize, datatype, comm
            integer(kind=c_int), intent(inout) :: position
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Pack
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Pack(inbuf, incount, datatype, outbuf, outsize, position, comm, &
                                ierror) &
                   bind(C,name="CFI_MPI_Pack")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: inbuf
            type(*), dimension(..), intent(inout) :: outbuf
            integer(kind=c_int), intent(in), value :: incount, outsize, datatype, comm
            integer(kind=c_int), intent(inout) :: position
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Pack
    end interface
#endif

    interface
        subroutine C_MPI_Unpack(inbuf, insize, position, outbuf, outcount, datatype, comm, &
                                ierror) &
                   bind(C,name="C_MPI_Unpack")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), dimension(*), intent(in) :: inbuf
            integer(kind=c_int), dimension(*), intent(inout) :: outbuf
            integer(kind=c_int), intent(in), value :: insize, outcount, datatype, comm
            integer(kind=c_int), intent(inout) :: position
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Unpack
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Unpack(inbuf, insize, position, outbuf, outcount, datatype, comm, &
                                  ierror) &
                   bind(C,name="CFI_MPI_Unpack")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(*), dimension(..), intent(in) :: inbuf
            type(*), dimension(..), intent(inout) :: outbuf
            integer(kind=c_int), intent(in), value :: insize, outcount, datatype, comm
            integer(kind=c_int), intent(inout) :: position
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Unpack
    end interface
#endif

end module mpi_p2p_c
