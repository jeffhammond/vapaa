module mpi_op_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_OP_NULL(op_f) &
                   bind(C,name="C_MPI_OP_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: op_f
        end subroutine C_MPI_OP_NULL
    end interface

    interface
        subroutine C_MPI_OP_BUILTINS( MAXf, MINf, SUMf, PRODf, MAXLOCf, MINLOCf, &
                                      BANDf, BORf, BXORf, LANDf, LORf, LXORf, &
                                      REPLACEf, NO_OPf) &
                   bind(C,name="C_MPI_OP_BUILTINS")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: MAXf
            integer(kind=c_int) :: MINf
            integer(kind=c_int) :: SUMf
            integer(kind=c_int) :: PRODf
            integer(kind=c_int) :: MAXLOCf
            integer(kind=c_int) :: MINLOCf
            integer(kind=c_int) :: BANDf
            integer(kind=c_int) :: BORf
            integer(kind=c_int) :: BXORf
            integer(kind=c_int) :: LANDf
            integer(kind=c_int) :: LORf
            integer(kind=c_int) :: LXORf
            integer(kind=c_int) :: REPLACEf
            integer(kind=c_int) :: NO_OPf
        end subroutine C_MPI_OP_BUILTINS
    end interface

    ! STANDARD STUFF

end module mpi_op_c
