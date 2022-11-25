module mpi_datatype_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_DATATYPE_NULL(datatype_f) &
                   bind(C,name="C_MPI_DATATYPE_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: datatype_f
        end subroutine C_MPI_DATATYPE_NULL
    end interface

    interface
        subroutine C_MPI_DATATYPE_BUILTINS(AINT_f,  OFFSET_f,  COUNT_f, &
                                           LOGICAL_f,  CHARACTER_f,  BYTE_f, INTEGER_f, &
                                           REAL_f,  DOUBLE_PRECISION_f, COMPLEX_f,  DOUBLE_COMPLEX_f, & 
                                           INTEGER1_f,  INTEGER2_f,  INTEGER4_f,  INTEGER8_f,  INTEGER16_f, & 
                                           REAL2_f,  REAL4_f,  REAL8_f,  REAL16_f, &
                                           COMPLEX4_f,  COMPLEX8_f,  COMPLEX16_f,  COMPLEX32_f) &
                                           bind(C,name="C_MPI_DATATYPE_BUILTINS")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: AINT_f
            integer(kind=c_int) :: OFFSET_f
            integer(kind=c_int) :: COUNT_f
            integer(kind=c_int) :: LOGICAL_f
            integer(kind=c_int) :: CHARACTER_f
            integer(kind=c_int) :: BYTE_f
            integer(kind=c_int) :: INTEGER_f
            integer(kind=c_int) :: REAL_f
            integer(kind=c_int) :: DOUBLE_PRECISION_f
            integer(kind=c_int) :: COMPLEX_f
            integer(kind=c_int) :: DOUBLE_COMPLEX_f
            integer(kind=c_int) :: INTEGER1_f
            integer(kind=c_int) :: INTEGER2_f
            integer(kind=c_int) :: INTEGER4_f
            integer(kind=c_int) :: INTEGER8_f
            integer(kind=c_int) :: INTEGER16_f
            integer(kind=c_int) :: REAL2_f
            integer(kind=c_int) :: REAL4_f
            integer(kind=c_int) :: REAL8_f
            integer(kind=c_int) :: REAL16_f
            integer(kind=c_int) :: COMPLEX4_f
            integer(kind=c_int) :: COMPLEX8_f
            integer(kind=c_int) :: COMPLEX16_f
            integer(kind=c_int) :: COMPLEX32_f
        end subroutine C_MPI_DATATYPE_BUILTINS
    end interface

    ! STANDARD STUFF

end module mpi_datatype_c
