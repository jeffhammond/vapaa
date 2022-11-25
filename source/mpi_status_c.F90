module mpi_status_c

    ! NOT STANDARD STUFF

    ! STANDARD STUFF

    interface
        subroutine C_MPI_Status_set_elements(status, datatype_c, count_c, ierror_c) &
                   bind(C,name="C_MPI_Status_set_elements")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(inout) :: status
            integer(kind=c_int), intent(in) :: datatype_c, count_c
            integer(kind=c_int), intent(out) :: ierror_c
        end subroutine C_MPI_Status_set_elements
    end interface

end module mpi_status_c
