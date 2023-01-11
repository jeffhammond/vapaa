module mpi_file_c

    interface
        subroutine C_MPI_File_open(comm, filename, amode, info, file, ierror) &
                   bind(C,name="C_MPI_File_open")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: comm, amode, info
            character(len=*,kind=c_char) :: filename
            integer(kind=c_int), intent(out) :: file, ierror
        end subroutine C_MPI_File_open
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_File_open(comm, filename, amode, info, file, ierror) &
                   bind(C,name="CFI_MPI_File_open")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: comm, amode, info
            type(*), dimension(..) :: filename
            integer(kind=c_int), intent(out) :: file, ierror
        end subroutine CFI_MPI_File_open
    end interface
#endif

    interface
        subroutine C_MPI_File_close(file, ierror) &
                   bind(C,name="C_MPI_File_close")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: file
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_close
    end interface

    interface
        subroutine C_MPI_File_delete(filename, info, ierror) &
                   bind(C,name="C_MPI_File_delete")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: info
            character(len=*,kind=c_char), intent(in) :: filename
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_delete
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_File_delete(filename, info, ierror) &
                   bind(C,name="CFI_MPI_File_delete")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: info
            type(*), dimension(..), intent(in) :: filename
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_File_delete
    end interface
#endif

    interface
        subroutine C_MPI_File_set_size(file, size, ierror) &
                   bind(C,name="C_MPI_File_set_size")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: file
            integer(kind=c_intptr_t), intent(in) :: size
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_set_size
    end interface

    interface
        subroutine C_MPI_File_preallocate(file, size, ierror) &
                   bind(C,name="C_MPI_File_preallocate")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: file
            integer(kind=c_intptr_t), intent(in) :: size
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_preallocate
    end interface

    interface
        subroutine C_MPI_File_get_size(file, size, ierror) &
                   bind(C,name="C_MPI_File_get_size")
            use iso_c_binding, only: c_int, c_size_t
            implicit none
            integer(kind=c_int), intent(in) :: file
            integer(kind=c_size_t), intent(out) :: size
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_get_size
    end interface

    interface
        subroutine C_MPI_File_set_view(file, disp, etype, filetype, datarep, info, ierror) &
                   bind(C,name="C_MPI_File_set_view")
            use iso_c_binding, only: c_int, c_intptr_t, c_char
            implicit none
            integer(kind=c_int), intent(in) :: file, etype, filetype, info
            integer(kind=c_intptr_t), intent(in) :: disp
            character(len=*,kind=c_char) :: datarep
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_set_view
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_File_set_view(file, disp, etype, filetype, datarep, info, ierror) &
                   bind(C,name="CFI_MPI_File_set_view")
            use iso_c_binding, only: c_int, c_intptr_t, c_char
            implicit none
            integer(kind=c_int), intent(in) :: file, etype, filetype, info
            integer(kind=c_intptr_t), intent(in) :: disp
            type(*), dimension(..) :: datarep
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_File_set_view
    end interface
#endif

    interface
        subroutine C_MPI_File_read_at(file, offset, buf, count, datatype, status, ierror) &
                   bind(C,name="C_MPI_File_read_at")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            integer(kind=c_intptr_t), intent(in) :: offset
            integer(kind=c_int), dimension(*) :: buf
            integer(kind=c_int), intent(out) :: ierror
            type(MPI_Status) :: status
        end subroutine C_MPI_File_read_at
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_File_read_at(file, offset, buf, count, datatype, status, ierror) &
                   bind(C,name="CFI_MPI_File_read_at")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            integer(kind=c_intptr_t), intent(in) :: offset
            type(*), dimension(..) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_File_read_at
    end interface
#endif

    interface
        subroutine C_MPI_File_read_at_all(file, offset, buf, count, datatype, status, ierror) &
                   bind(C,name="C_MPI_File_read_at_all")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            integer(kind=c_intptr_t), intent(in) :: offset
            integer(kind=c_int), dimension(*) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_read_at_all
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_File_read_at_all(file, offset, buf, count, datatype, status, ierror) &
                   bind(C,name="CFI_MPI_File_read_at_all")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            integer(kind=c_intptr_t), intent(in) :: offset
            type(*), dimension(..) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_File_read_at_all
    end interface
#endif

    interface
        subroutine C_MPI_File_read(file, buf, count, datatype, status, ierror) &
                   bind(C,name="C_MPI_File_read")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            integer(kind=c_int), dimension(*) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_read
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_File_read(file, buf, count, datatype, status, ierror) &
                   bind(C,name="CFI_MPI_File_read")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            type(*), dimension(..) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_File_read
    end interface
#endif

    interface
        subroutine C_MPI_File_read_all(file, buf, count, datatype, status, ierror) &
                   bind(C,name="C_MPI_File_read_all")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            integer(kind=c_int), dimension(*) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_read_all
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_File_read_all(file, buf, count, datatype, status, ierror) &
                   bind(C,name="CFI_MPI_File_read_all")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            type(*), dimension(..) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_File_read_all
    end interface
#endif

    interface
        subroutine C_MPI_File_write_at(file, offset, buf, count, datatype, status, ierror) &
                   bind(C,name="C_MPI_File_write_at")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            integer(kind=c_intptr_t), intent(in) :: offset
            integer(kind=c_int), dimension(*), intent(in) :: buf
            integer(kind=c_int), intent(out) :: ierror
            type(MPI_Status) :: status
        end subroutine C_MPI_File_write_at
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_File_write_at(file, offset, buf, count, datatype, status, ierror) &
                   bind(C,name="CFI_MPI_File_write_at")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            integer(kind=c_intptr_t), intent(in) :: offset
            type(*), dimension(..) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_File_write_at
    end interface
#endif

    interface
        subroutine C_MPI_File_write_at_all(file, offset, buf, count, datatype, status, ierror) &
                   bind(C,name="C_MPI_File_write_at_all")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            integer(kind=c_intptr_t), intent(in) :: offset
            integer(kind=c_int), dimension(*) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_write_at_all
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_File_write_at_all(file, offset, buf, count, datatype, status, ierror) &
                   bind(C,name="CFI_MPI_File_write_at_all")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            integer(kind=c_intptr_t), intent(in) :: offset
            type(*), dimension(..), intent(in) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_File_write_at_all
    end interface
#endif

    interface
        subroutine C_MPI_File_write(file, buf, count, datatype, status, ierror) &
                   bind(C,name="C_MPI_File_write")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            integer(kind=c_int), dimension(*), intent(in) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_write
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_File_write(file, buf, count, datatype, status, ierror) &
                   bind(C,name="CFI_MPI_File_write")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            type(*), dimension(..), intent(in) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_File_write
    end interface
#endif

    interface
        subroutine C_MPI_File_write_all(file, buf, count, datatype, status, ierror) &
                   bind(C,name="C_MPI_File_write_all")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            integer(kind=c_int), dimension(*), intent(in) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_write_all
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_File_write_all(file, buf, count, datatype, status, ierror) &
                   bind(C,name="CFI_MPI_File_write_all")
            use iso_c_binding, only: c_int, c_intptr_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(kind=c_int), intent(in) :: file, count, datatype
            type(*), dimension(..), intent(in) :: buf
            type(MPI_Status) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_File_write_all
    end interface
#endif

end module mpi_file_c
