module mpi_datatype_f
    use iso_c_binding, only: c_int
    use mpi_global_constants, only: MPI_Datatype
    implicit none
    type(MPI_Datatype) :: MPI_AINT
    type(MPI_Datatype) :: MPI_OFFSET
    type(MPI_Datatype) :: MPI_COUNT
    type(MPI_Datatype) :: MPI_LOGICAL
    type(MPI_Datatype) :: MPI_CHARACTER
    type(MPI_Datatype) :: MPI_BYTE
    type(MPI_Datatype) :: MPI_INTEGER
    type(MPI_Datatype) :: MPI_REAL
    type(MPI_Datatype) :: MPI_DOUBLE_PRECISION
    type(MPI_Datatype) :: MPI_COMPLEX
    type(MPI_Datatype) :: MPI_DOUBLE_COMPLEX
    type(MPI_Datatype) :: MPI_INTEGER1
    type(MPI_Datatype) :: MPI_INTEGER2
    type(MPI_Datatype) :: MPI_INTEGER4
    type(MPI_Datatype) :: MPI_INTEGER8
    type(MPI_Datatype) :: MPI_INTEGER16
    type(MPI_Datatype) :: MPI_REAL2
    type(MPI_Datatype) :: MPI_REAL4
    type(MPI_Datatype) :: MPI_REAL8
    type(MPI_Datatype) :: MPI_REAL16
    type(MPI_Datatype) :: MPI_COMPLEX4
    type(MPI_Datatype) :: MPI_COMPLEX8
    type(MPI_Datatype) :: MPI_COMPLEX16
    type(MPI_Datatype) :: MPI_COMPLEX32

    contains
        subroutine F_MPI_Init_datatypes()
            use mpi_datatype_c
            integer(kind=c_int) :: AINT_c, OFFSET_c, COUNT_c
            integer(kind=c_int) :: LOGICAL_c, CHARACTER_c, BYTE_c, INTEGER_c
            integer(kind=c_int) :: REAL_c, DOUBLE_PRECISION_c, COMPLEX_c, DOUBLE_COMPLEX_c
            integer(kind=c_int) :: INTEGER1_c, INTEGER2_c, INTEGER4_c, INTEGER8_c, INTEGER16_c
            integer(kind=c_int) :: REAL2_c, REAL4_c, REAL8_c, REAL16_c
            integer(kind=c_int) :: COMPLEX4_c, COMPLEX8_c, COMPLEX16_c, COMPLEX32_c
            call C_MPI_DATATYPE_BUILTINS(AINT_c, OFFSET_c, COUNT_c, &
                                         LOGICAL_c, CHARACTER_c, BYTE_c, INTEGER_c, &
                                         REAL_c, DOUBLE_PRECISION_c, COMPLEX_c, DOUBLE_COMPLEX_c, & 
                                         INTEGER1_c, INTEGER2_c, INTEGER4_c, INTEGER8_c, INTEGER16_c, & 
                                         REAL2_c, REAL4_c, REAL8_c, REAL16_c, &
                                         COMPLEX4_c, COMPLEX8_c, COMPLEX16_c, COMPLEX32_c)
            MPI_AINT % MPI_VAL             = AINT_c 
            MPI_OFFSET % MPI_VAL           = OFFSET_c 
            MPI_COUNT % MPI_VAL            = COUNT_c 
            MPI_LOGICAL % MPI_VAL          = LOGICAL_c 
            MPI_CHARACTER % MPI_VAL        = CHARACTER_c 
            MPI_BYTE % MPI_VAL             = BYTE_c 
            MPI_INTEGER % MPI_VAL          = INTEGER_c 
            MPI_REAL % MPI_VAL             = REAL_c 
            MPI_DOUBLE_PRECISION % MPI_VAL = DOUBLE_PRECISION_c 
            MPI_COMPLEX % MPI_VAL          = COMPLEX_c 
            MPI_DOUBLE_COMPLEX % MPI_VAL   = DOUBLE_COMPLEX_c 
            MPI_INTEGER1 % MPI_VAL         = INTEGER1_c 
            MPI_INTEGER2 % MPI_VAL         = INTEGER2_c 
            MPI_INTEGER4 % MPI_VAL         = INTEGER4_c 
            MPI_INTEGER8 % MPI_VAL         = INTEGER8_c 
            MPI_INTEGER16 % MPI_VAL        = INTEGER16_c 
            MPI_REAL2 % MPI_VAL            = REAL2_c 
            MPI_REAL4 % MPI_VAL            = REAL4_c 
            MPI_REAL8 % MPI_VAL            = REAL8_c 
            MPI_REAL16 % MPI_VAL           = REAL16_c 
            MPI_COMPLEX4 % MPI_VAL         = COMPLEX4_c 
            MPI_COMPLEX8 % MPI_VAL         = COMPLEX8_c 
            MPI_COMPLEX16 % MPI_VAL        = COMPLEX16_c 
            MPI_COMPLEX32 % MPI_VAL        = COMPLEX32_c 
        end subroutine F_MPI_Init_datatypes

end module mpi_datatype_f
