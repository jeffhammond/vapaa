module mpi_status_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Status_set_elements
        module procedure MPI_Status_set_elements_f08
    end interface MPI_Status_set_elements

    contains

        subroutine MPI_Status_set_elements_f08(status, datatype, count, ierror)
            use mpi_handle_types, only: MPI_Status, MPI_Datatype, C_MPI_Status
            use mpi_handle_operators, only: F_MPI_Status_copy_c2f, F_MPI_Status_copy_f2c
            use mpi_status_c, only: C_MPI_Status_set_elements
            type(MPI_Status), intent(inout) :: status
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(out) :: count
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, ierror_c
            type(C_MPI_Status) :: status_c
            count_c = count
            status_c = F_MPI_Status_copy_f2c(status)
            call C_MPI_Status_set_elements(status_c, datatype % MPI_VAL, count_c, ierror_c)
            status = F_MPI_Status_copy_c2f(status_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Status_set_elements_f08

end module mpi_status_f
