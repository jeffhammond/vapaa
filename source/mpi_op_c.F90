! SPDX-License-Identifier: MIT

module mpi_op_c

    interface
        subroutine C_MPI_Op_create(userfn, commute, op, ierror) &
                   bind(C,name="C_MPI_Op_create")
            use iso_c_binding, only: c_int, c_funptr
            implicit none
            type(c_funptr), intent(in), value :: userfn
            integer(kind=c_int), intent(in) :: commute
            integer(kind=c_int), intent(out) :: op, ierror
        end subroutine C_MPI_Op_create
    end interface

    interface
        subroutine C_MPI_Op_free(op, ierror) &
                   bind(C,name="C_MPI_Op_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: op
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Op_free
    end interface


end module mpi_op_c
