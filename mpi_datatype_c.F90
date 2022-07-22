module mpi_datatype_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_DATATYPE_NULL(datatype_f) bind(C,name="C_MPI_DATATYPE_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: datatype_f
        end subroutine C_MPI_DATATYPE_NULL
    end interface

    interface
        subroutine C_MPI_INTEGER(datatype_f) bind(C,name="C_MPI_INTEGER")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: datatype_f
        end subroutine C_MPI_INTEGER
    end interface

    interface
        subroutine C_MPI_REAL(datatype_f) bind(C,name="C_MPI_REAL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: datatype_f
        end subroutine C_MPI_REAL
    end interface

    interface
        subroutine C_MPI_DOUBLE_PRECISION(datatype_f) bind(C,name="C_MPI_DOUBLE_PRECISION")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: datatype_f
        end subroutine C_MPI_DOUBLE_PRECISION
    end interface

    interface
        subroutine C_MPI_COMPLEX(datatype_f) bind(C,name="C_MPI_COMPLEX")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: datatype_f
        end subroutine C_MPI_COMPLEX
    end interface

    interface
        subroutine C_MPI_LOGICAL(datatype_f) bind(C,name="C_MPI_LOGICAL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: datatype_f
        end subroutine C_MPI_LOGICAL
    end interface

    interface
        subroutine C_MPI_CHARACTER(datatype_f) bind(C,name="C_MPI_CHARACTER")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: datatype_f
        end subroutine C_MPI_CHARACTER
    end interface

    interface
        subroutine C_MPI_BYTE(datatype_f) bind(C,name="C_MPI_BYTE")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: datatype_f
        end subroutine C_MPI_BYTE
    end interface

    ! STANDARD STUFF

end module mpi_datatype_c
