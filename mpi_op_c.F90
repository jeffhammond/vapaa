module mpi_op_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_OP_NULL(op_f) bind(C,name="C_MPI_OP_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: op_f
        end subroutine C_MPI_OP_NULL
    end interface

    ! STANDARD STUFF

end module mpi_op_c
