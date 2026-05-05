! SPDX-License-Identifier: MIT

module mpi_status_c

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
        subroutine C_MPI_Get_count(status, datatype, count, ierror) &
                   bind(C,name="C_MPI_Get_count")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(in) :: status
            integer(kind=c_int), intent(in), value :: datatype
            integer(kind=c_int), intent(out) :: count, ierror
        end subroutine C_MPI_Get_count
    end interface

end module mpi_status_c
