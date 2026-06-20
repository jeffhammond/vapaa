! SPDX-License-Identifier: MIT

module mpi_status_c

    interface
        subroutine C_MPI_Status_get_source(status, source, ierror) &
                   bind(C,name="C_MPI_Status_get_source")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(in) :: status
            integer(kind=c_int), intent(out) :: source, ierror
        end subroutine C_MPI_Status_get_source
    end interface

    interface
        subroutine C_MPI_Status_get_tag(status, tag, ierror) &
                   bind(C,name="C_MPI_Status_get_tag")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(in) :: status
            integer(kind=c_int), intent(out) :: tag, ierror
        end subroutine C_MPI_Status_get_tag
    end interface

    interface
        subroutine C_MPI_Status_get_error(status, error, ierror) &
                   bind(C,name="C_MPI_Status_get_error")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(in) :: status
            integer(kind=c_int), intent(out) :: error, ierror
        end subroutine C_MPI_Status_get_error
    end interface

    interface
        subroutine C_MPI_Status_set_source(status, source, ierror) &
                   bind(C,name="C_MPI_Status_set_source")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(in) :: source
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Status_set_source
    end interface

    interface
        subroutine C_MPI_Status_set_tag(status, tag, ierror) &
                   bind(C,name="C_MPI_Status_set_tag")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(in) :: tag
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Status_set_tag
    end interface

    interface
        subroutine C_MPI_Status_set_error(status, error, ierror) &
                   bind(C,name="C_MPI_Status_set_error")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(in) :: error
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Status_set_error
    end interface

    interface
        subroutine C_MPI_Status_set_cancelled(status, flag, ierror) &
                   bind(C,name="C_MPI_Status_set_cancelled")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(in) :: flag
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Status_set_cancelled
    end interface

    interface
        subroutine C_MPI_Status_set_elements(status, datatype, count, ierror) &
                   bind(C,name="C_MPI_Status_set_elements")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(in), value :: datatype, count
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Status_set_elements
    end interface

    interface
        subroutine C_MPI_Status_set_elements_x(status, datatype, count, ierror) &
                   bind(C,name="C_MPI_Status_set_elements_x")
            use iso_c_binding, only: c_int, c_int64_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(in), value :: datatype
            integer(kind=c_int64_t), intent(in) :: count
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Status_set_elements_x
    end interface

    interface
        subroutine C_MPI_Test_cancelled(status, flag, ierror) &
                   bind(C,name="C_MPI_Test_cancelled")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(in) :: status
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine C_MPI_Test_cancelled
    end interface

end module mpi_status_c
