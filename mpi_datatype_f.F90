module mpi_datatype_f
    use iso_c_binding, only: c_int
    use mpi_global_constants, only: MPI_Datatype
    implicit none

    type(MPI_Datatype) :: MPI_INTEGER
    type(MPI_Datatype) :: MPI_REAL
    type(MPI_Datatype) :: MPI_DOUBLE_PRECISION
    type(MPI_Datatype) :: MPI_COMPLEX
    type(MPI_Datatype) :: MPI_LOGICAL
    type(MPI_Datatype) :: MPI_CHARACTER
    type(MPI_Datatype) :: MPI_BYTE

    contains
        subroutine F_MPI_Init_datatypes()
            use mpi_datatype_c, only: C_MPI_INTEGER,          &
                                      C_MPI_REAL,             &
                                      C_MPI_DOUBLE_PRECISION, &
                                      C_MPI_COMPLEX,          &
                                      C_MPI_LOGICAL,          &
                                      C_MPI_CHARACTER,        &
                                      C_MPI_BYTE
            integer(kind=c_int) :: datatype_c
            call C_MPI_INTEGER(datatype_c)
            MPI_INTEGER % MPI_VAL = datatype_c
            call C_MPI_REAL(datatype_c)
            MPI_REAL % MPI_VAL = datatype_c
            call C_MPI_DOUBLE_PRECISION(datatype_c)
            MPI_DOUBLE_PRECISION % MPI_VAL = datatype_c
            call C_MPI_COMPLEX(datatype_c)
            MPI_COMPLEX % MPI_VAL = datatype_c
            call C_MPI_LOGICAL(datatype_c)
            MPI_LOGICAL % MPI_VAL = datatype_c
            call C_MPI_CHARACTER(datatype_c)
            MPI_CHARACTER % MPI_VAL = datatype_c
            call C_MPI_BYTE(datatype_c)
            MPI_BYTE % MPI_VAL = datatype_c
        end subroutine F_MPI_Init_datatypes

end module mpi_datatype_f
