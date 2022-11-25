module mpi_file_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_FILE_NULL(file_f) bind(C,name="C_MPI_FILE_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: file_f
        end subroutine C_MPI_FILE_NULL
    end interface

    ! STANDARD STUFF

    interface
        subroutine C_MPI_File_open(comm_c, filename_c, amode_c, info_c, file_c, ierror_c) bind(C,name="C_MPI_File_open")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int) :: comm_c, amode_c, info_c, file_c, ierror_c
            character(kind=c_char), dimension(:) :: filename_c
        end subroutine C_MPI_File_open
    end interface

    interface
        subroutine C_MPI_File_close(file_c, ierror_c) bind(C,name="C_MPI_File_close")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: file_c, ierror_c
        end subroutine C_MPI_File_close
    end interface

end module mpi_file_c
