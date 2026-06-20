! SPDX-License-Identifier: MIT

module mpi_request_f
    use mpi_ierror_f, only: F_MPI_FINISH_IERROR
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Request_get_status
        module procedure MPI_Request_get_status_f08
    end interface MPI_Request_get_status

    interface MPI_Request_get_status_all
        module procedure MPI_Request_get_status_all_f08
    end interface MPI_Request_get_status_all

    interface MPI_Request_get_status_any
        module procedure MPI_Request_get_status_any_f08
    end interface MPI_Request_get_status_any

    interface MPI_Request_get_status_some
        module procedure MPI_Request_get_status_some_f08
    end interface MPI_Request_get_status_some

    interface MPI_Request_free
        module procedure MPI_Request_free_f08
    end interface MPI_Request_free

    interface MPI_Cancel
        module procedure MPI_Cancel_f08
    end interface MPI_Cancel

    interface MPI_Start
        module procedure MPI_Start_f08
    end interface MPI_Start

    interface MPI_Startall
        module procedure MPI_Startall_f08
    end interface MPI_Startall

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
            flag = (flag_c .ne. 0)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Request_get_status_f08

        subroutine MPI_Request_get_status_all_f08(count, requests, flag, statuses, ierror)
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_request_c, only: C_MPI_Request_get_status_all
            integer, intent(in) :: count
            type(MPI_Request), intent(in) :: requests(count)
            logical, intent(out) :: flag
            type(MPI_Status), intent(inout) :: statuses(*)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, flag_c, ierror_c
            count_c = count
            call C_MPI_Request_get_status_all(count_c, requests, flag_c, statuses, ierror_c)
            flag = (flag_c .ne. 0)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Request_get_status_all_f08

        subroutine MPI_Request_get_status_any_f08(count, requests, index, flag, status, ierror)
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_request_c, only: C_MPI_Request_get_status_any
            integer, intent(in) :: count
            type(MPI_Request), intent(in) :: requests(count)
            integer, intent(out) :: index
            logical, intent(out) :: flag
            type(MPI_Status), intent(inout) :: status
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, index_c, flag_c, ierror_c
            count_c = count
            call C_MPI_Request_get_status_any(count_c, requests, index_c, flag_c, status, ierror_c)
            if (index_c .ge. 0) then
                index = index_c + 1
            else
                index = index_c
            end if
            flag = (flag_c .ne. 0)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Request_get_status_any_f08

        subroutine MPI_Request_get_status_some_f08(incount, requests, outcount, indices, statuses, ierror)
            use mpi_handle_types, only: MPI_Request, MPI_Status
            use mpi_request_c, only: C_MPI_Request_get_status_some
            integer, intent(in) :: incount
            type(MPI_Request), intent(in) :: requests(incount)
            integer, intent(out) :: outcount, indices(*)
            type(MPI_Status), intent(inout) :: statuses(*)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: incount_c, outcount_c, ierror_c
            incount_c = incount
            call C_MPI_Request_get_status_some(incount_c, requests, outcount_c, indices, statuses, ierror_c)
            outcount = outcount_c
            if (outcount_c > 0) indices(1:outcount_c) = indices(1:outcount_c) + 1
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Request_get_status_some_f08

        subroutine MPI_Request_free_f08(request, ierror)
            use mpi_handle_types, only: MPI_Request
            use mpi_request_c, only: C_MPI_Request_free
            type(MPI_Request), intent(inout) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Request_free(request % MPI_VAL, ierror_c)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Request_free_f08

        subroutine MPI_Cancel_f08(request, ierror)
            use mpi_handle_types, only: MPI_Request
            use mpi_request_c, only: C_MPI_Cancel
            type(MPI_Request), intent(in) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Cancel(request % MPI_VAL, ierror_c)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Cancel_f08

        subroutine MPI_Start_f08(request, ierror)
            use mpi_handle_types, only: MPI_Request
            use mpi_request_c, only: C_MPI_Start
            type(MPI_Request), intent(inout) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Start(request % MPI_VAL, ierror_c)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Start_f08

        subroutine MPI_Startall_f08(count, requests, ierror)
            use mpi_handle_types, only: MPI_Request
            use mpi_request_c, only: C_MPI_Startall
            integer, intent(in) :: count
            type(MPI_Request), intent(inout) :: requests(count)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, ierror_c
            count_c = count
            call C_MPI_Startall(count_c, requests, ierror_c)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Startall_f08

end module mpi_request_f
