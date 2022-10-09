module mpi_p2p_c

    ! STANDARD STUFF

    interface
        subroutine C_MPI_Test(request_c, flag_c, status_c, ierror_c) bind(C,name="C_MPI_Test")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int) :: request_c, flag_c, ierror_c
            type(MPI_Status), intent(out) :: status_c
        end subroutine C_MPI_Test
    end interface

    interface
        subroutine C_MPI_Wait(request_c, status_c, ierror_c) bind(C,name="C_MPI_Wait")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int) :: request_c, ierror_c
            type(MPI_Status), intent(out) :: status_c
        end subroutine C_MPI_Wait
    end interface

    interface
        subroutine C_MPI_Waitall(count_c, requests_c, statuses_c, ierror_c) bind(C,name="C_MPI_Waitall")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int) :: count_c, requests_c(*), ierror_c
            type(MPI_Status), intent(out) :: statuses_c(*)
        end subroutine C_MPI_Waitall
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
