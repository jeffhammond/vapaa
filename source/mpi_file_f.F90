module mpi_file_f
    use iso_c_binding, only: c_int
    implicit none

    ! I/O file mode constants
    integer, parameter :: MPI_MODE_APPEND           =   1
    integer, parameter :: MPI_MODE_CREATE           =   2
    integer, parameter :: MPI_MODE_DELETE_ON_CLOSE  =   4
    integer, parameter :: MPI_MODE_EXCL             =   8
    integer, parameter :: MPI_MODE_RDONLY           =  16
    integer, parameter :: MPI_MODE_RDWR             =  32
    integer, parameter :: MPI_MODE_SEQUENTIAL       =  64
    integer, parameter :: MPI_MODE_UNIQUE_OPEN      = 128
    integer, parameter :: MPI_MODE_WRONLY           = 256

    interface MPI_File_open
        module procedure MPI_File_open_f08
    end interface MPI_File_open

    interface MPI_File_close
        module procedure MPI_File_close_f08
    end interface MPI_File_close

    contains

        subroutine MPI_File_open_f08(comm, filename, amode, info, file, ierror) 
            use iso_c_binding, only: c_char, c_null_char
            use mpi_handle_types, only: MPI_Comm, MPI_Info, MPI_File
            use mpi_file_c, only: C_MPI_File_open
            type(MPI_Comm), intent(in) :: comm
            character(len=*), intent(in) :: filename
            integer, intent(in) :: amode
            type(MPI_info), intent(in) :: info
            type(MPI_File), intent(in) :: file
            integer, optional, intent(out) :: ierror
            character(c_char), dimension(:), allocatable :: filename_c
            integer(kind=c_int) :: amode_c, ierror_c
            integer :: i, ls
            ls = len(filename)
            amode_c = amode
            allocate( filename_c(ls+1) )
            filename_c = c_null_char
            do i = 1, ls
              filename_c(i) = filename(i:i)
            end do
            call C_MPI_File_open(comm % MPI_VAL, filename_c, amode_c, info % MPI_VAL, file % MPI_VAL, ierror_c)
            deallocate( filename_c )
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_open_f08

        subroutine MPI_File_close_f08(file, ierror) 
            use mpi_handle_types, only: MPI_File
            use mpi_file_c, only: C_MPI_File_close
            type(MPI_File), intent(in) :: file
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_File_close(file % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_close_f08

        subroutine MPI_File_delete_f08(filename, info, ierror) 
            use iso_c_binding, only: c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_file_c, only: C_MPI_File_delete
            character(len=*), intent(in) :: filename
            type(MPI_info), intent(in) :: info
            integer, optional, intent(out) :: ierror
            character(c_char), dimension(:), allocatable :: filename_c
            integer(kind=c_int) :: ierror_c
            integer :: i, ls
            ls = len(filename)
            allocate( filename_c(ls+1) )
            filename_c = c_null_char
            do i = 1, ls
              filename_c(i) = filename(i:i)
            end do
            call C_MPI_File_delete(filename_c, info % MPI_VAL, ierror_c)
            deallocate( filename_c )
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_delete_f08

        subroutine MPI_File_set_size(file, size, ierror)
            use iso_c_binding, only: c_intptr_t
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File
            use mpi_file_c, only: C_MPI_File_set_size
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(in) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_File_set_size(file % MPI_VAL, size, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_set_size

end module mpi_file_f
