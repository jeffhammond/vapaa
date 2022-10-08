module mpi_p2p_c

    ! STANDARD STUFF

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
        subroutine C_MPI_Recv(buffer, count_c, datatype_c, source_c, tag_c, comm_c, status_c, &
                              ierror_c) bind(C,name="C_MPI_Recv")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), dimension(*), intent(in) :: buffer
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
            type(*), dimension(..), intent(in) :: buffer
            integer(kind=c_int) :: count_c, datatype_c, source_c, tag_c, comm_c, ierror_c
            type(MPI_Status), intent(out) :: status_c
        end subroutine CFI_MPI_Recv
    end interface
#endif

end module mpi_p2p_c
