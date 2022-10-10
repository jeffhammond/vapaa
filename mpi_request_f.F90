module mpi_request_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Request_get_status
        module procedure MPI_Request_get_status_f08
    end interface MPI_Request_get_status

    contains

        subroutine MPI_Request_get_status_f08(request, flag, status, ierror)
            use mpi_handle_types, only: MPI_Status, MPI_Request
            use mpi_request_c, only: C_MPI_Request_get_status
            type(MPI_Request), intent(in) :: request
            logical, intent(out) :: flag
            type(MPI_Status), intent(inout) :: status
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: flag_c, ierror_c
            call C_MPI_Request_get_status(request % MPI_VAL, flag_c, status, ierror_c)
            if (flag_c .eq. 0) then
                flag = .false.
            else
                flag = .true.
            endif
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Request_get_status_f08

end module mpi_request_f
