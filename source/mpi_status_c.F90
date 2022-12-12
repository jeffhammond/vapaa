module mpi_status_c

    interface
        subroutine C_MPI_Status_set_elements(status, datatype, count, ierror) &
                   bind(C,name="C_MPI_Status_set_elements")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: C_MPI_Status
            implicit none
            type(C_MPI_Status) :: status
            integer(kind=c_int), intent(in) :: datatype, count
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Status_set_elements
    end interface

end module mpi_status_c
