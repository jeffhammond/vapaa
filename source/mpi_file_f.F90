! SPDX-License-Identifier: MIT

#include "vapaa_constants.h"

module mpi_file_f
    use iso_c_binding, only: c_int
    implicit none

    ! I/O file mode constants
    integer, parameter :: MPI_MODE_APPEND           = VAPAA_MPI_MODE_APPEND
    integer, parameter :: MPI_MODE_CREATE           = VAPAA_MPI_MODE_CREATE
    integer, parameter :: MPI_MODE_DELETE_ON_CLOSE  = VAPAA_MPI_MODE_DELETE_ON_CLOSE
    integer, parameter :: MPI_MODE_EXCL             = VAPAA_MPI_MODE_EXCL
    integer, parameter :: MPI_MODE_RDONLY           = VAPAA_MPI_MODE_RDONLY
    integer, parameter :: MPI_MODE_RDWR             = VAPAA_MPI_MODE_RDWR
    integer, parameter :: MPI_MODE_SEQUENTIAL       = VAPAA_MPI_MODE_SEQUENTIAL
    integer, parameter :: MPI_MODE_UNIQUE_OPEN      = VAPAA_MPI_MODE_UNIQUE_OPEN
    integer, parameter :: MPI_MODE_WRONLY           = VAPAA_MPI_MODE_WRONLY

    interface MPI_File_open
#ifdef HAVE_CFI
        module procedure MPI_File_open_f08ts
#else
        module procedure MPI_File_open_f08
#endif
    end interface MPI_File_open

    interface MPI_File_close
        module procedure MPI_File_close_f08
    end interface MPI_File_close

    interface MPI_File_delete
#ifdef HAVE_CFI
        module procedure MPI_File_delete_f08ts
#else
        module procedure MPI_File_delete_f08
#endif
    end interface MPI_File_delete

    interface MPI_File_set_size
        module procedure MPI_File_set_size_f08
    end interface MPI_File_set_size

    interface MPI_File_preallocate
        module procedure MPI_File_preallocate_f08
    end interface MPI_File_preallocate

    interface MPI_File_get_size
        module procedure MPI_File_get_size_f08
    end interface MPI_File_get_size

    interface MPI_File_set_view
#ifdef HAVE_CFI
        module procedure MPI_File_set_view_f08ts
#else
        module procedure MPI_File_set_view_f08
#endif
    end interface MPI_File_set_view

    interface MPI_File_read_at
#ifdef HAVE_CFI
        module procedure MPI_File_read_at_f08ts
#else
        module procedure MPI_File_read_at_f08
#endif
    end interface MPI_File_read_at

    interface MPI_File_read_at_all
#ifdef HAVE_CFI
        module procedure MPI_File_read_at_all_f08ts
#else
        module procedure MPI_File_read_at_all_f08
#endif
    end interface MPI_File_read_at_all

    interface MPI_File_read
#ifdef HAVE_CFI
        module procedure MPI_File_read_f08ts
#else
        module procedure MPI_File_read_f08
#endif
    end interface MPI_File_read

    interface MPI_File_read_all
#ifdef HAVE_CFI
        module procedure MPI_File_read_all_f08ts
#else
        module procedure MPI_File_read_all_f08
#endif
    end interface MPI_File_read_all

    interface MPI_File_write_at
#ifdef HAVE_CFI
        module procedure MPI_File_write_at_f08ts
#else
        module procedure MPI_File_write_at_f08
#endif
    end interface MPI_File_write_at

    interface MPI_File_write_at_all
#ifdef HAVE_CFI
        module procedure MPI_File_write_at_all_f08ts
#else
        module procedure MPI_File_write_at_all_f08
#endif
    end interface MPI_File_write_at_all

    interface MPI_File_write
#ifdef HAVE_CFI
        module procedure MPI_File_write_f08ts
#else
        module procedure MPI_File_write_f08
#endif
    end interface MPI_File_write

    interface MPI_File_write_all
#ifdef HAVE_CFI
        module procedure MPI_File_write_all_f08ts
#else
        module procedure MPI_File_write_all_f08
#endif
    end interface MPI_File_write_all

    contains

        subroutine MPI_File_open_f08(comm, filename, amode, info, file, ierror)
            use iso_c_binding, only: c_char, c_null_char
            use mpi_handle_types, only: MPI_Comm, MPI_Info, MPI_File
            use mpi_file_c, only: C_MPI_File_open
            type(MPI_Comm), intent(in) :: comm
            character(len=*), intent(in) :: filename
            integer, intent(in) :: amode
            type(MPI_info), intent(in) :: info
            type(MPI_File), intent(out) :: file
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: amode_c, ierror_c
            amode_c = amode
            call C_MPI_File_open(comm % MPI_VAL, filename, amode_c, info % MPI_VAL, file % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_open_f08

#ifdef HAVE_CFI
        subroutine MPI_File_open_f08ts(comm, filename, amode, info, file, ierror)
            use iso_c_binding, only: c_char, c_null_char
            use mpi_handle_types, only: MPI_Comm, MPI_Info, MPI_File
            use mpi_file_c, only: CFI_MPI_File_open
            type(MPI_Comm), intent(in) :: comm
            character(len=*), intent(in) :: filename
            integer, intent(in) :: amode
            type(MPI_info), intent(in) :: info
            type(MPI_File), intent(out) :: file
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: amode_c, ierror_c
            integer :: i, ls
            character(kind=c_char), dimension(:), allocatable :: filename_c
            amode_c = amode
            ls = len(filename)
            allocate( filename_c(ls+1) )
            filename_c = c_null_char
            do i=1, ls
                filename_c(i) = filename(i:i)
            end do
            call CFI_MPI_File_open(comm % MPI_VAL, filename_c, amode_c, info % MPI_VAL, file % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
            deallocate( filename_c )
        end subroutine MPI_File_open_f08ts
#endif

        subroutine MPI_File_close_f08(file, ierror)
            use mpi_handle_types, only: MPI_File
            use mpi_file_c, only: C_MPI_File_close
            type(MPI_File), intent(inout) :: file
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_File_close(file % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_close_f08

        subroutine MPI_File_delete_f08(filename, info, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Info
            use mpi_file_c, only: C_MPI_File_delete
            character(len=*), intent(in) :: filename
            type(MPI_info), intent(in) :: info
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_File_delete(filename, info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_delete_f08

#ifdef HAVE_CFI
        subroutine MPI_File_delete_f08ts(filename, info, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_handle_types, only: MPI_Info
            use mpi_file_c, only: CFI_MPI_File_delete
            character(len=*), intent(in) :: filename
            type(MPI_info), intent(in) :: info
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            integer :: i, ls
            character(kind=c_char), dimension(:), allocatable :: filename_c
            ls = len(filename)
            allocate( filename_c(ls+1) )
            filename_c = c_null_char
            do i=1, ls
                filename_c(i) = filename(i:i)
            end do
            call CFI_MPI_File_delete(filename_c, info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
            deallocate( filename_c )
        end subroutine MPI_File_delete_f08ts
#endif

        subroutine MPI_File_set_size_f08(file, size, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File
            use mpi_file_c, only: C_MPI_File_set_size
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(in) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_File_set_size(file % MPI_VAL, size, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_set_size_f08

        subroutine MPI_File_preallocate_f08(file, size, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File
            use mpi_file_c, only: C_MPI_File_preallocate
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(in) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_File_preallocate(file % MPI_VAL, size, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_preallocate_f08

        subroutine MPI_File_get_size_f08(file, size, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File
            use mpi_file_c, only: C_MPI_File_get_size
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(c_size_t) :: size_c
            integer(c_int) :: ierror_c
            call C_MPI_File_get_size(file % MPI_VAL, size_c, ierror_c)
            size = size_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_get_size_f08

        subroutine MPI_File_set_view_f08(file, disp, etype, filetype, datarep, info, ierror)
            use iso_c_binding, only: c_int, c_size_t, c_char, c_null_char
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_info
            use mpi_file_c, only: C_MPI_File_set_view
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(in) :: disp
            type(MPI_Datatype), intent(in) :: etype, filetype
            character(len=*), intent(in) :: datarep
            type(MPI_info), intent(in) :: info
            integer, optional, intent(out) :: ierror
            integer(c_size_t) :: disp_c
            integer(c_int) :: ierror_c
            disp_c = disp
            call C_MPI_File_set_view(file % MPI_VAL, disp_c, etype % MPI_VAL, filetype % MPI_VAL, &
                                     datarep, info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_set_view_f08

#ifdef HAVE_CFI
        subroutine MPI_File_set_view_f08ts(file, disp, etype, filetype, datarep, info, ierror)
            use iso_c_binding, only: c_int, c_size_t, c_char, c_null_char
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_info
            use mpi_file_c, only: CFI_MPI_File_set_view
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(in) :: disp
            type(MPI_Datatype), intent(in) :: etype, filetype
            character(len=*), intent(in) :: datarep
            type(MPI_info), intent(in) :: info
            integer, optional, intent(out) :: ierror
            integer(c_size_t) :: disp_c
            integer(c_int) :: ierror_c
            integer :: i, ls
            character(kind=c_char), dimension(:), allocatable :: datarep_c
            ls = len(datarep)
            allocate( datarep_c(ls+1) )
            datarep_c = c_null_char
            do i=1, ls
                datarep_c(i) = datarep(i:i)
            end do
            disp_c = disp
            call CFI_MPI_File_set_view(file % MPI_VAL, disp_c, etype % MPI_VAL, filetype % MPI_VAL, &
                                       datarep_c, info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
            deallocate( datarep_c )
        end subroutine MPI_File_set_view_f08ts
#endif

        subroutine MPI_File_read_at_f08(file, offset, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: C_MPI_File_read_at
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
!dir$ ignore_tkr buf
            integer, dimension(*) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            integer(c_size_t) :: offset_c
            offset_c = offset
            count_c = count
            call C_MPI_File_read_at(file % MPI_VAL, offset_c, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_read_at_f08

#ifdef HAVE_CFI
        subroutine MPI_File_read_at_f08ts(file, offset, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: CFI_MPI_File_read_at
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
            type(*), dimension(..) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            integer(c_size_t) :: offset_c
            offset_c = offset
            count_c = count
            call CFI_MPI_File_read_at(file % MPI_VAL, offset_c, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_read_at_f08ts
#endif

        subroutine MPI_File_read_at_all_f08(file, offset, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: C_MPI_File_read_at_all
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
!dir$ ignore_tkr buf
            integer, dimension(*) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            integer(c_size_t) :: offset_c
            offset_c = offset
            count_c = count
            call C_MPI_File_read_at_all(file % MPI_VAL, offset_c, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_read_at_all_f08

#ifdef HAVE_CFI
        subroutine MPI_File_read_at_all_f08ts(file, offset, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: CFI_MPI_File_read_at_all
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
            type(*), dimension(..) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            integer(c_size_t) :: offset_c
            offset_c = offset
            count_c = count
            call CFI_MPI_File_read_at_all(file % MPI_VAL, offset_c, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_read_at_all_f08ts
#endif

        subroutine MPI_File_read_f08(file, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: C_MPI_File_read
            type(MPI_File), intent(in) :: file
!dir$ ignore_tkr buf
            integer, dimension(*) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            count_c = count
            call C_MPI_File_read(file % MPI_VAL, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_read_f08

#ifdef HAVE_CFI
        subroutine MPI_File_read_f08ts(file, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: CFI_MPI_File_read
            type(MPI_File), intent(in) :: file
            type(*), dimension(..) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            count_c = count
            call CFI_MPI_File_read(file % MPI_VAL, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_read_f08ts
#endif

        subroutine MPI_File_read_all_f08(file, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: C_MPI_File_read_all
            type(MPI_File), intent(in) :: file
!dir$ ignore_tkr buf
            integer, dimension(*) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            count_c = count
            call C_MPI_File_read_all(file % MPI_VAL, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_read_all_f08

#ifdef HAVE_CFI
        subroutine MPI_File_read_all_f08ts(file, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: CFI_MPI_File_read_all
            type(MPI_File), intent(in) :: file
            type(*), dimension(..) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            count_c = count
            call CFI_MPI_File_read_all(file % MPI_VAL, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_read_all_f08ts
#endif

        subroutine MPI_File_write_at_f08(file, offset, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: C_MPI_File_write_at
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
!dir$ ignore_tkr buf
            integer, dimension(*), intent(in) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            integer(c_size_t) :: offset_c
            offset_c = offset
            count_c = count
            call C_MPI_File_write_at(file % MPI_VAL, offset_c, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_write_at_f08

#ifdef HAVE_CFI
        subroutine MPI_File_write_at_f08ts(file, offset, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: CFI_MPI_File_write_at
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
            type(*), dimension(..), intent(in) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            integer(c_size_t) :: offset_c
            offset_c = offset
            count_c = count
            call CFI_MPI_File_write_at(file % MPI_VAL, offset_c, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_write_at_f08ts
#endif

        subroutine MPI_File_write_at_all_f08(file, offset, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: C_MPI_File_write_at_all
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
!dir$ ignore_tkr buf
            integer, dimension(*), intent(in) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            integer(c_size_t) :: offset_c
            offset_c = offset
            count_c = count
            call C_MPI_File_write_at_all(file % MPI_VAL, offset_c, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_write_at_all_f08

#ifdef HAVE_CFI
        subroutine MPI_File_write_at_all_f08ts(file, offset, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: CFI_MPI_File_write_at_all
            type(MPI_File), intent(in) :: file
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
            type(*), dimension(..), intent(in) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            integer(c_size_t) :: offset_c
            offset_c = offset
            count_c = count
            call CFI_MPI_File_write_at_all(file % MPI_VAL, offset_c, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_write_at_all_f08ts
#endif

        subroutine MPI_File_write_f08(file, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: C_MPI_File_write
            type(MPI_File), intent(in) :: file
!dir$ ignore_tkr buf
            integer, dimension(*), intent(in) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            count_c = count
            call C_MPI_File_write(file % MPI_VAL, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_write_f08

#ifdef HAVE_CFI
        subroutine MPI_File_write_f08ts(file, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: CFI_MPI_File_write
            type(MPI_File), intent(in) :: file
            type(*), dimension(..), intent(in) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            count_c = count
            call CFI_MPI_File_write(file % MPI_VAL, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_write_f08ts
#endif

        subroutine MPI_File_write_all_f08(file, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: C_MPI_File_write_all
            type(MPI_File), intent(in) :: file
!dir$ ignore_tkr buf
            integer, dimension(*), intent(in) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            count_c = count
            call C_MPI_File_write_all(file % MPI_VAL, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_write_all_f08

#ifdef HAVE_CFI
        subroutine MPI_File_write_all_f08ts(file, buf, count, datatype, status, ierror)
            use iso_c_binding, only: c_size_t
            use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Status
            use mpi_file_c, only: CFI_MPI_File_write_all
            type(MPI_File), intent(in) :: file
            type(*), dimension(..), intent(in) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status) :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            count_c = count
            call CFI_MPI_File_write_all(file % MPI_VAL, buf, count_c, datatype % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_write_all_f08ts
#endif

end module mpi_file_f
