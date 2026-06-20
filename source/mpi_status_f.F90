! SPDX-License-Identifier: MIT

module mpi_status_f
    use mpi_ierror_f, only: F_MPI_FINISH_IERROR
    use iso_c_binding, only: c_int, c_int64_t
    implicit none

    interface MPI_Status_get_source
        module procedure MPI_Status_get_source_f08
    end interface MPI_Status_get_source

    interface MPI_Status_get_tag
        module procedure MPI_Status_get_tag_f08
    end interface MPI_Status_get_tag

    interface MPI_Status_get_error
        module procedure MPI_Status_get_error_f08
    end interface MPI_Status_get_error

    interface MPI_Status_set_source
        module procedure MPI_Status_set_source_f08
    end interface MPI_Status_set_source

    interface MPI_Status_set_tag
        module procedure MPI_Status_set_tag_f08
    end interface MPI_Status_set_tag

    interface MPI_Status_set_error
        module procedure MPI_Status_set_error_f08
    end interface MPI_Status_set_error

    interface MPI_Status_set_cancelled
        module procedure MPI_Status_set_cancelled_f08
    end interface MPI_Status_set_cancelled

    interface MPI_Status_set_elements
        module procedure MPI_Status_set_elements_f08
    end interface MPI_Status_set_elements

    interface MPI_Status_set_elements_x
        module procedure MPI_Status_set_elements_x_f08
    end interface MPI_Status_set_elements_x

    interface MPI_Test_cancelled
        module procedure MPI_Test_cancelled_f08
    end interface MPI_Test_cancelled

    interface MPI_Status_f082f
        module procedure MPI_Status_f082f_f08
    end interface MPI_Status_f082f

    interface MPI_Status_f2f08
        module procedure MPI_Status_f2f08_f08
    end interface MPI_Status_f2f08

    contains

        subroutine MPI_Status_get_source_f08(status, source, ierror)
            use mpi_handle_types, only: MPI_Status
            use mpi_status_c, only: C_MPI_Status_get_source
            type(MPI_Status), intent(in) :: status
            integer, intent(out) :: source
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: source_c, ierror_c
            call C_MPI_Status_get_source(status, source_c, ierror_c)
            source = source_c
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Status_get_source_f08

        subroutine MPI_Status_f082f_f08(status_f08, status_f)
            use mpi_global_constants, only: MPI_ERROR, MPI_SOURCE, MPI_STATUS_SIZE, MPI_TAG
            use mpi_handle_types, only: MPI_Status
            type(MPI_Status), intent(in) :: status_f08
            integer, intent(out) :: status_f(MPI_STATUS_SIZE)
            status_f = 0
            status_f(MPI_SOURCE) = status_f08 % MPI_SOURCE
            status_f(MPI_TAG) = status_f08 % MPI_TAG
            status_f(MPI_ERROR) = status_f08 % MPI_ERROR
        end subroutine MPI_Status_f082f_f08

        subroutine MPI_Status_f2f08_f08(status_f, status_f08)
            use mpi_global_constants, only: MPI_ERROR, MPI_SOURCE, MPI_STATUS_SIZE, MPI_TAG
            use mpi_handle_types, only: MPI_Status
            integer, intent(in) :: status_f(MPI_STATUS_SIZE)
            type(MPI_Status), intent(out) :: status_f08
#ifdef MPI_ABI
            status_f08 % MPI_internal = 0
#else
            status_f08 % count_lo = 0
            status_f08 % count_hi_and_cancelled = 0
            status_f08 % cancelled = 0
            status_f08 % ucount = 0
#endif
            status_f08 % MPI_SOURCE = status_f(MPI_SOURCE)
            status_f08 % MPI_TAG = status_f(MPI_TAG)
            status_f08 % MPI_ERROR = status_f(MPI_ERROR)
        end subroutine MPI_Status_f2f08_f08

        subroutine MPI_Status_get_tag_f08(status, tag, ierror)
            use mpi_handle_types, only: MPI_Status
            use mpi_status_c, only: C_MPI_Status_get_tag
            type(MPI_Status), intent(in) :: status
            integer, intent(out) :: tag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: tag_c, ierror_c
            call C_MPI_Status_get_tag(status, tag_c, ierror_c)
            tag = tag_c
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Status_get_tag_f08

        subroutine MPI_Status_get_error_f08(status, error, ierror)
            use mpi_handle_types, only: MPI_Status
            use mpi_status_c, only: C_MPI_Status_get_error
            type(MPI_Status), intent(in) :: status
            integer, intent(out) :: error
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: error_c, ierror_c
            call C_MPI_Status_get_error(status, error_c, ierror_c)
            error = error_c
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Status_get_error_f08

        subroutine MPI_Status_set_source_f08(status, source, ierror)
            use mpi_handle_types, only: MPI_Status
            use mpi_status_c, only: C_MPI_Status_set_source
            type(MPI_Status), intent(inout) :: status
            integer, intent(in) :: source
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: source_c, ierror_c
            source_c = source
            call C_MPI_Status_set_source(status, source_c, ierror_c)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Status_set_source_f08

        subroutine MPI_Status_set_tag_f08(status, tag, ierror)
            use mpi_handle_types, only: MPI_Status
            use mpi_status_c, only: C_MPI_Status_set_tag
            type(MPI_Status), intent(inout) :: status
            integer, intent(in) :: tag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: tag_c, ierror_c
            tag_c = tag
            call C_MPI_Status_set_tag(status, tag_c, ierror_c)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Status_set_tag_f08

        subroutine MPI_Status_set_error_f08(status, error, ierror)
            use mpi_handle_types, only: MPI_Status
            use mpi_status_c, only: C_MPI_Status_set_error
            type(MPI_Status), intent(inout) :: status
            integer, intent(in) :: error
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: error_c, ierror_c
            error_c = error
            call C_MPI_Status_set_error(status, error_c, ierror_c)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Status_set_error_f08

        subroutine MPI_Status_set_cancelled_f08(status, flag, ierror)
            use mpi_handle_types, only: MPI_Status
            use mpi_status_c, only: C_MPI_Status_set_cancelled
            type(MPI_Status), intent(inout) :: status
            logical, intent(in) :: flag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: flag_c, ierror_c
            flag_c = merge(1_c_int, 0_c_int, flag)
            call C_MPI_Status_set_cancelled(status, flag_c, ierror_c)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Status_set_cancelled_f08

        subroutine MPI_Status_set_elements_f08(status, datatype, count, ierror)
            use mpi_handle_types, only: MPI_Status, MPI_Datatype
            use mpi_status_c, only: C_MPI_Status_set_elements
            type(MPI_Status), intent(inout) :: status
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(in) :: count
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, ierror_c
            count_c = count
            call C_MPI_Status_set_elements(status, datatype % MPI_VAL, count_c, ierror_c)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Status_set_elements_f08

        subroutine MPI_Status_set_elements_x_f08(status, datatype, count, ierror)
            use mpi_handle_types, only: MPI_Status, MPI_Datatype
            use mpi_status_c, only: C_MPI_Status_set_elements_x
            type(MPI_Status), intent(inout) :: status
            type(MPI_Datatype), intent(in) :: datatype
            integer(kind=c_int64_t), intent(in) :: count
            integer, optional, intent(out) :: ierror
            integer(kind=c_int64_t) :: count_c
            integer(kind=c_int) :: ierror_c
            count_c = count
            call C_MPI_Status_set_elements_x(status, datatype % MPI_VAL, count_c, ierror_c)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Status_set_elements_x_f08

        subroutine MPI_Test_cancelled_f08(status, flag, ierror)
            use mpi_handle_types, only: MPI_Status
            use mpi_status_c, only: C_MPI_Test_cancelled
            type(MPI_Status), intent(in) :: status
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: flag_c, ierror_c
            call C_MPI_Test_cancelled(status, flag_c, ierror_c)
            flag = (flag_c /= 0)
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine MPI_Test_cancelled_f08

end module mpi_status_f
