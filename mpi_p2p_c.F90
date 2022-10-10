module mpi_p2p_c

    ! STANDARD STUFF

    interface
        subroutine C_MPI_Test(request_c, flag_c, status_c, ierror_c) bind(C,name="C_MPI_Test")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(inout) :: request_c
            integer(kind=c_int), intent(out) :: flag_c, ierror_c
            type(MPI_Status), intent(out) :: status_c
        end subroutine C_MPI_Test
    end interface

    interface
        subroutine C_MPI_Testall(count_c, requests_c, flag_c, statuses_c, ierror_c) bind(C,name="C_MPI_Testall")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: count_c
            integer(kind=c_int), intent(inout) :: requests_c(*)
            integer(kind=c_int), intent(out) :: flag_c, ierror_c
            type(MPI_Status), intent(out) :: statuses_c(*)
        end subroutine C_MPI_Testall
    end interface

    interface
        subroutine C_MPI_Testsome(incount_c, requests_c, outcount_c, indices, statuses_c, &
                                  ierror_c) bind(C,name="C_MPI_Testsome")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: incount_c
            integer(kind=c_int), intent(inout) :: requests_c(*)
            integer(kind=c_int), intent(out) :: outcount_c, indices(*)
            type(MPI_Status), intent(out) :: statuses_c(*)
            integer(kind=c_int), intent(out) :: ierror_c
        end subroutine C_MPI_Testsome
    end interface

    interface
        subroutine C_MPI_Testany(count_c, requests_c, index_c, flag_c, statuses_c, ierror_c) bind(C,name="C_MPI_Testany")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: count_c
            integer(kind=c_int), intent(inout) :: requests_c(*)
            integer(kind=c_int), intent(out) :: index_c, flag_c, ierror_c
            type(MPI_Status), intent(out) :: statuses_c(*)
        end subroutine C_MPI_Testany
    end interface

    interface
        subroutine C_MPI_Wait(request_c, status_c, ierror_c) bind(C,name="C_MPI_Wait")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(inout) :: request_c
            integer(kind=c_int), intent(out) :: ierror_c
            type(MPI_Status), intent(out) :: status_c
        end subroutine C_MPI_Wait
    end interface

    interface
        subroutine C_MPI_Waitall(count_c, requests_c, statuses_c, ierror_c) bind(C,name="C_MPI_Waitall")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: count_c
            integer(kind=c_int), intent(inout) :: requests_c(*)
            integer(kind=c_int), intent(out) :: ierror_c
            type(MPI_Status), intent(out) :: statuses_c(*)
        end subroutine C_MPI_Waitall
    end interface

    interface
        subroutine C_MPI_Waitsome(incount_c, requests_c, outcount_c, indices, statuses_c, &
                                  ierror_c) bind(C,name="C_MPI_Waitsome")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: incount_c
            integer(kind=c_int), intent(inout) :: requests_c(*)
            integer(kind=c_int), intent(out) :: outcount_c, indices(*)
            type(MPI_Status), intent(out) :: statuses_c(*)
            integer(kind=c_int), intent(out) :: ierror_c
        end subroutine C_MPI_Waitsome
    end interface

    interface
        subroutine C_MPI_Waitany(count_c, requests_c, index_c, statuses_c, ierror_c) bind(C,name="C_MPI_Waitany")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: count_c
            integer(kind=c_int), intent(inout) :: requests_c(*)
            integer(kind=c_int), intent(out) :: index_c, ierror_c
            type(MPI_Status), intent(out) :: statuses_c(*)
        end subroutine C_MPI_Waitany
    end interface

    interface
        subroutine C_MPI_Send(buffer, count_c, datatype_c, dest_c, tag_c, comm_c, &
                              ierror_c) bind(C,name="C_MPI_Send")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in) :: buffer
            integer(kind=c_int) :: count_c, datatype_c, dest_c, tag_c, comm_c, ierror_c
        end subroutine C_MPI_Send
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Send(buffer, count_c, datatype_c, dest_c, tag_c, comm_c, &
                                ierror_c) bind(C,name="CFI_MPI_Send")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: buffer
            integer(kind=c_int) :: count_c, datatype_c, dest_c, tag_c, comm_c, ierror_c
        end subroutine CFI_MPI_Send
    end interface
#endif

    interface
        subroutine C_MPI_Isend(buffer, count_c, datatype_c, dest_c, tag_c, comm_c, request_c, &
                              ierror_c) bind(C,name="C_MPI_Isend")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in) :: buffer
            integer(kind=c_int) :: count_c, datatype_c, dest_c, tag_c, comm_c, request_c, ierror_c
        end subroutine C_MPI_Isend
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Isend(buffer, count_c, datatype_c, dest_c, tag_c, comm_c, request_c, &
                                 ierror_c) bind(C,name="CFI_MPI_Isend")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: buffer
            integer(kind=c_int) :: count_c, datatype_c, dest_c, tag_c, comm_c, request_c, ierror_c
        end subroutine CFI_MPI_Isend
    end interface
#endif

    interface
        subroutine C_MPI_Recv(buffer, count_c, datatype_c, source_c, tag_c, comm_c, status_c, &
                              ierror_c) bind(C,name="C_MPI_Recv")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), dimension(*), intent(out) :: buffer
            integer(kind=c_int) :: count_c, datatype_c, source_c, tag_c, comm_c, ierror_c
            type(MPI_Status), intent(out) :: status_c
        end subroutine C_MPI_Recv
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Recv(buffer, count_c, datatype_c, source_c, tag_c, comm_c, status_c, &
                                ierror_c) bind(C,name="CFI_MPI_Recv")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(*), dimension(..), intent(inout) :: buffer
            integer(kind=c_int) :: count_c, datatype_c, source_c, tag_c, comm_c, ierror_c
            type(MPI_Status), intent(out) :: status_c
        end subroutine CFI_MPI_Recv
    end interface
#endif

    interface
        subroutine C_MPI_Irecv(buffer, count_c, datatype_c, source_c, tag_c, comm_c, request_c, &
                              ierror_c) bind(C,name="C_MPI_Irecv")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(out) :: buffer
            integer(kind=c_int) :: count_c, datatype_c, source_c, tag_c, comm_c, request_c, ierror_c
        end subroutine C_MPI_Irecv
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Irecv(buffer, count_c, datatype_c, source_c, tag_c, comm_c, request_c, &
                                ierror_c) bind(C,name="CFI_MPI_Irecv")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(inout) :: buffer
            integer(kind=c_int) :: count_c, datatype_c, source_c, tag_c, comm_c, request_c, ierror_c
        end subroutine CFI_MPI_Irecv
    end interface
#endif

end module mpi_p2p_c
