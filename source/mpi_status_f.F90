module mpi_status_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Status_set_elements
        module procedure MPI_Status_set_elements_f08
    end interface MPI_Status_set_elements

    contains

        ! NON-STANDARD

        subroutine F_MPI_Init_status()
            use mpi_global_constants, only: MPI_STATUS_IGNORE, MPI_STATUSES_IGNORE
            MPI_STATUS_IGNORE % MPI_SOURCE   = -9119
            MPI_STATUS_IGNORE % MPI_TAG      = -9119
            MPI_STATUS_IGNORE % MPI_ERROR    = -9119
            MPI_STATUSES_IGNORE % MPI_SOURCE = -9119
            MPI_STATUSES_IGNORE % MPI_TAG    = -9119
            MPI_STATUSES_IGNORE % MPI_ERROR  = -9119
        end subroutine F_MPI_Init_status

        ! STANDARD

        subroutine MPI_Status_set_elements_f08(status, datatype, count, ierror)
            use mpi_handle_types, only: MPI_Status, MPI_Datatype
            use mpi_status_c, only: C_MPI_Status_set_elements
            type(MPI_Status), intent(inout) :: status
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(out) :: count
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, ierror_c
            count_c = count
            call C_MPI_Status_set_elements(status, datatype % MPI_VAL, count_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Status_set_elements_f08

end module mpi_status_f
