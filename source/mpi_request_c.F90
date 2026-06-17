! SPDX-License-Identifier: MIT

module mpi_request_c

    interface
        subroutine C_MPI_Request_get_status(request, flag, status, ierror) &
                   bind(C,name="C_MPI_Request_get_status")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(in) :: request
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine C_MPI_Request_get_status
    end interface

    interface
        subroutine C_MPI_Request_get_status_all(count, requests, flag, statuses, ierror) &
                   bind(C,name="C_MPI_Request_get_status_all")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Request, MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: count
            type(MPI_Request), intent(in) :: requests(*)
            integer(kind=c_int), intent(out) :: flag, ierror
            type(MPI_Status), intent(inout) :: statuses(*)
        end subroutine C_MPI_Request_get_status_all
    end interface

    interface
        subroutine C_MPI_Request_get_status_any(count, requests, index, flag, status, ierror) &
                   bind(C,name="C_MPI_Request_get_status_any")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Request, MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: count
            type(MPI_Request), intent(in) :: requests(*)
            integer(kind=c_int), intent(out) :: index, flag, ierror
            type(MPI_Status), intent(inout) :: status
        end subroutine C_MPI_Request_get_status_any
    end interface

    interface
        subroutine C_MPI_Request_get_status_some(incount, requests, outcount, indices, statuses, ierror) &
                   bind(C,name="C_MPI_Request_get_status_some")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Request, MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: incount
            type(MPI_Request), intent(in) :: requests(*)
            integer(kind=c_int), intent(out) :: outcount, indices(*), ierror
            type(MPI_Status), intent(inout) :: statuses(*)
        end subroutine C_MPI_Request_get_status_some
    end interface

    interface
        subroutine C_MPI_Request_free(request, ierror) &
                   bind(C,name="C_MPI_Request_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: request
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Request_free
    end interface

    interface
        subroutine C_MPI_Cancel(request, ierror) &
                   bind(C,name="C_MPI_Cancel")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: request
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Cancel
    end interface

    interface
        subroutine C_MPI_Start(request, ierror) &
                   bind(C,name="C_MPI_Start")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: request
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Start
    end interface

    interface
        subroutine C_MPI_Startall(count, requests, ierror) &
                   bind(C,name="C_MPI_Startall")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Request
            implicit none
            integer(kind=c_int), intent(in) :: count
            type(MPI_Request), intent(inout) :: requests(*)
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Startall
    end interface

end module mpi_request_c
