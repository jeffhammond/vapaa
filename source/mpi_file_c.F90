module mpi_file_c

    interface
        subroutine C_MPI_File_open(comm_c, filename_c, amode_c, info_c, file_c, ierror_c) &
                   bind(C,name="C_MPI_File_open")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int) :: comm_c, amode_c, info_c, file_c, ierror_c
            character(kind=c_char), dimension(:) :: filename_c
        end subroutine C_MPI_File_open
    end interface

    interface
        subroutine C_MPI_File_close(file_c, ierror_c) &
                   bind(C,name="C_MPI_File_close")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: file_c, ierror_c
        end subroutine C_MPI_File_close
    end interface

    interface
        subroutine C_MPI_File_delete(filename_c, info_c, ierror_c) &
                   bind(C,name="C_MPI_File_delete")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int) :: info_c, ierror_c
            character(kind=c_char), dimension(:) :: filename_c
        end subroutine C_MPI_File_delete
    end interface

    interface
        subroutine C_MPI_File_set_size(file_c, size_c, ierror_c) &
                   bind(C,name="C_MPI_File_set_size")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int) :: file_c, ierror_c
            integer(kind=c_intptr_t) :: size_c
        end subroutine C_MPI_File_set_size
    end interface

    interface
        subroutine C_MPI_File_preallocate(file_c, size_c, ierror_c) &
                   bind(C,name="C_MPI_File_preallocate")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int) :: file_c, ierror_c
            integer(kind=c_intptr_t) :: size_c
        end subroutine C_MPI_File_preallocate
    end interface

    interface
        subroutine C_MPI_File_get_size(file_c, size_c, ierror_c) &
                   bind(C,name="C_MPI_File_get_size")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int) :: file_c, ierror_c
            integer(kind=c_intptr_t) :: size_c
        end subroutine C_MPI_File_get_size
    end interface

    interface
        subroutine C_MPI_File_read_at(file_c, offset_c, buf, count_c, datatype_c, status, ierror_c) &
                   bind(C,name="C_MPI_File_read_at")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int) :: file_c, count_c, datatype_c, ierror_c
            integer(kind=c_intptr_t) :: offset_c
            type(*), dimension(..) :: buf
            type(MPI_Status) :: status
        end subroutine C_MPI_File_read_at
    end interface

end module mpi_file_c
