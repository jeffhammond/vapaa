module mpi_p2p_c

    interface
        subroutine C_MPI_Probe(source, tag, comm, status, ierror) &
                   bind(C,name="C_MPI_Probe")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: C_MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: source, tag, comm
            type(C_MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Probe
    end interface

    interface
        subroutine C_MPI_Mprobe(source, tag, comm, message, status, ierror) &
                   bind(C,name="C_MPI_Mprobe")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: C_MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: source, tag, comm
            type(C_MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(out) :: message, ierror
        end subroutine C_MPI_Mprobe
    end interface

    interface
        subroutine C_MPI_Test(request, flag, status, ierror) &
                   bind(C,name="C_MPI_Test")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: C_MPI_Status
            implicit none
            integer(kind=c_int), intent(inout) :: request
            integer(kind=c_int), intent(out) :: flag, ierror
            type(C_MPI_Status), intent(inout) :: status
        end subroutine C_MPI_Test
    end interface

    interface
        subroutine C_MPI_Testall(count, requests, flag, statuses, ierror) &
                   bind(C,name="C_MPI_Testall")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: C_MPI_Status, MPI_Request
            implicit none
            integer(kind=c_int), intent(in) :: count
            !integer(kind=c_int), intent(inout) :: requests(*)
            type(MPI_Request), intent(inout) :: requests(*)
            integer(kind=c_int), intent(out) :: flag, ierror
            type(C_MPI_Status), intent(inout) :: statuses(*)
        end subroutine C_MPI_Testall
    end interface

    interface
        subroutine C_MPI_Testsome(incount, requests, outcount, indices, statuses, &
                                  ierror) &
                   bind(C,name="C_MPI_Testsome")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: C_MPI_Status, MPI_Request
            implicit none
            integer(kind=c_int), intent(in) :: incount
            !integer(kind=c_int), intent(inout) :: requests(*)
            type(MPI_Request), intent(inout) :: requests(*)
            integer(kind=c_int), intent(out) :: outcount, indices(*)
            type(C_MPI_Status), intent(inout) :: statuses(*)
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Testsome
    end interface

    interface
        subroutine C_MPI_Testany(count, requests, index, flag, status, ierror) &
                   bind(C,name="C_MPI_Testany")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: C_MPI_Status, MPI_Request
            implicit none
            integer(kind=c_int), intent(in) :: count
            !integer(kind=c_int), intent(inout) :: requests(*)
            type(MPI_Request), intent(inout) :: requests(*)
            integer(kind=c_int), intent(out) :: index, flag, ierror
            type(C_MPI_Status), intent(inout) :: status
        end subroutine C_MPI_Testany
    end interface

    interface
        subroutine C_MPI_Wait(request, status, ierror) &
                   bind(C,name="C_MPI_Wait")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: C_MPI_Status
            implicit none
            integer(kind=c_int), intent(inout) :: request
            integer(kind=c_int), intent(out) :: ierror
            type(C_MPI_Status), intent(inout) :: status
        end subroutine C_MPI_Wait
    end interface

    interface
        subroutine C_MPI_Waitall(count, requests, statuses, ierror) &
                   bind(C,name="C_MPI_Waitall")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: C_MPI_Status, MPI_Request
            implicit none
            integer(kind=c_int), intent(in) :: count
            !integer(kind=c_int), intent(inout) :: requests(*)
            type(MPI_Request), intent(inout) :: requests(*)
            integer(kind=c_int), intent(out) :: ierror
            type(C_MPI_Status), intent(inout) :: statuses(*)
        end subroutine C_MPI_Waitall
    end interface

    interface
        subroutine C_MPI_Waitsome(incount, requests, outcount, indices, statuses, &
                                  ierror) &
                   bind(C,name="C_MPI_Waitsome")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: C_MPI_Status, MPI_Request
            implicit none
            integer(kind=c_int), intent(in) :: incount
            !integer(kind=c_int), intent(inout) :: requests(*)
            type(MPI_Request), intent(inout) :: requests(*)
            integer(kind=c_int), intent(out) :: outcount, indices(*)
            type(C_MPI_Status), intent(inout) :: statuses(*)
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Waitsome
    end interface

    interface
        subroutine C_MPI_Waitany(count, requests, index, status, ierror) &
                   bind(C,name="C_MPI_Waitany")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: C_MPI_Status, MPI_Request
            implicit none
            integer(kind=c_int), intent(in) :: count
            !integer(kind=c_int), intent(inout) :: requests(*)
            type(MPI_Request), intent(inout) :: requests(*)
            integer(kind=c_int), intent(out) :: index, ierror
            type(C_MPI_Status), intent(inout) :: status
        end subroutine C_MPI_Waitany
    end interface

    interface
        subroutine C_MPI_Send(buffer, count, datatype, dest, tag, comm, &
                              ierror) &
                   bind(C,name="C_MPI_Send")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in) :: buffer
            integer(kind=c_int) :: count, datatype, dest, tag, comm, ierror
        end subroutine C_MPI_Send
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Send(buffer, count, datatype, dest, tag, comm, &
                                ierror) &
                   bind(C,name="CFI_MPI_Send")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: buffer
            integer(kind=c_int) :: count, datatype, dest, tag, comm, ierror
        end subroutine CFI_MPI_Send
    end interface
#endif

    interface
        subroutine C_MPI_Isend(buffer, count, datatype, dest, tag, comm, request, &
                              ierror) &
                   bind(C,name="C_MPI_Isend")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: buffer
            integer(kind=c_int), intent(in) :: count, datatype, dest, tag, comm
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
            integer(kind=c_int) :: count, datatype, dest, tag, comm, request, ierror
        end subroutine CFI_MPI_Isend
    end interface
#endif

    interface
        subroutine C_MPI_Recv(buffer, count, datatype, source, tag, comm, status, &
                              ierror) &
                   bind(C,name="C_MPI_Recv")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: C_MPI_Status
            implicit none
            integer(kind=c_int), dimension(*), intent(out) :: buffer
            integer(kind=c_int) :: count, datatype, source, tag, comm, ierror
            type(C_MPI_Status), intent(out) :: status
        end subroutine C_MPI_Recv
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Recv(buffer, count, datatype, source, tag, comm, status, &
                                ierror) &
                   bind(C,name="CFI_MPI_Recv")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: C_MPI_Status
            implicit none
            type(*), dimension(..), intent(inout) :: buffer
            integer(kind=c_int) :: count, datatype, source, tag, comm, ierror
            type(C_MPI_Status), intent(out) :: status
        end subroutine CFI_MPI_Recv
    end interface
#endif

    interface
        subroutine C_MPI_Irecv(buffer, count, datatype, source, tag, comm, request, &
                              ierror) &
                   bind(C,name="C_MPI_Irecv")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: buffer
            integer(kind=c_int) :: count, datatype, source, tag, comm, request, ierror
        end subroutine C_MPI_Irecv
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Irecv(buffer, count, datatype, source, tag, comm, request, &
                                ierror) &
                   bind(C,name="CFI_MPI_Irecv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(inout), asynchronous :: buffer
            integer(kind=c_int) :: count, datatype, source, tag, comm, request, ierror
        end subroutine CFI_MPI_Irecv
    end interface
#endif

end module mpi_p2p_c
