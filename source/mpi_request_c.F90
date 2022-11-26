module mpi_request_c

    interface
        subroutine C_MPI_Request_get_status(request, flag_c, status, ierror_c) &
                   bind(C,name="C_MPI_Request_get_status")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(in) :: request
            integer(kind=c_int), intent(out) :: flag_c, ierror_c
        end subroutine C_MPI_Request_get_status
    end interface

end module mpi_request_c
