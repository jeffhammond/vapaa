! SPDX-License-Identifier: MIT

module mpi_direct_file_f
    use iso_c_binding, only: c_char, c_int, c_int64_t, c_intptr_t, c_null_char
    implicit none

    interface MPI_File_get_amode
        module procedure MPI_File_get_amode_f08
    end interface MPI_File_get_amode
    interface MPI_File_get_atomicity
        module procedure MPI_File_get_atomicity_f08
    end interface MPI_File_get_atomicity
    interface MPI_File_set_atomicity
        module procedure MPI_File_set_atomicity_f08
    end interface MPI_File_set_atomicity
    interface MPI_File_get_byte_offset
        module procedure MPI_File_get_byte_offset_f08
    end interface MPI_File_get_byte_offset
    interface MPI_File_get_group
        module procedure MPI_File_get_group_f08
    end interface MPI_File_get_group
    interface MPI_File_get_info
        module procedure MPI_File_get_info_f08
    end interface MPI_File_get_info
    interface MPI_File_set_info
        module procedure MPI_File_set_info_f08
    end interface MPI_File_set_info
    interface MPI_File_get_position
        module procedure MPI_File_get_position_f08
    end interface MPI_File_get_position
    interface MPI_File_get_position_shared
        module procedure MPI_File_get_position_shared_f08
    end interface MPI_File_get_position_shared
    interface MPI_File_get_type_extent
        module procedure MPI_File_get_type_extent_f08
    end interface MPI_File_get_type_extent
    interface MPI_File_seek
        module procedure MPI_File_seek_f08
    end interface MPI_File_seek
    interface MPI_File_seek_shared
        module procedure MPI_File_seek_shared_f08
    end interface MPI_File_seek_shared
    interface MPI_File_sync
        module procedure MPI_File_sync_f08
    end interface MPI_File_sync

#ifdef HAVE_CFI
    interface MPI_File_get_view
        module procedure MPI_File_get_view_f08
    end interface MPI_File_get_view
#endif

    contains

        subroutine copy_c_string(c, f)
            character(kind=c_char), intent(in) :: c(:)
            character(len=*), intent(out) :: f
            integer :: i, n
            n = min(len(f), size(c))
            f = c_null_char
            do i = 1, n
                f(i:i) = c(i)
            end do
        end subroutine copy_c_string

        subroutine MPI_File_get_amode_f08(fh, amode, ierror)
            use mpi_handle_types, only: MPI_File
            use mpi_direct_file_c, only: VAPAA_MPI_File_get_amode
            type(MPI_File), intent(in) :: fh
            integer, intent(out) :: amode
            integer, optional, intent(out) :: ierror
            integer(c_int) :: amode_c, ierror_c
            call VAPAA_MPI_File_get_amode(fh % MPI_VAL, amode_c, ierror_c)
            amode = amode_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_get_amode_f08

        subroutine MPI_File_get_atomicity_f08(fh, flag, ierror)
            use mpi_handle_types, only: MPI_File
            use mpi_direct_file_c, only: VAPAA_MPI_File_get_atomicity
            type(MPI_File), intent(in) :: fh
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(c_int) :: flag_c, ierror_c
            call VAPAA_MPI_File_get_atomicity(fh % MPI_VAL, flag_c, ierror_c)
            flag = flag_c /= 0
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_get_atomicity_f08

        subroutine MPI_File_set_atomicity_f08(fh, flag, ierror)
            use mpi_handle_types, only: MPI_File
            use mpi_direct_file_c, only: VAPAA_MPI_File_set_atomicity
            type(MPI_File), intent(in) :: fh
            logical, intent(in) :: flag
            integer, optional, intent(out) :: ierror
            integer(c_int) :: flag_c, ierror_c
            flag_c = merge(1_c_int, 0_c_int, flag)
            call VAPAA_MPI_File_set_atomicity(fh % MPI_VAL, flag_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_set_atomicity_f08

        subroutine MPI_File_get_byte_offset_f08(fh, offset, disp, ierror)
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File
            use mpi_direct_file_c, only: VAPAA_MPI_File_get_byte_offset
            type(MPI_File), intent(in) :: fh
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
            integer(kind=MPI_OFFSET_KIND), intent(out) :: disp
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_get_byte_offset(fh % MPI_VAL, offset, disp, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_get_byte_offset_f08

        subroutine MPI_File_get_group_f08(fh, group, ierror)
            use mpi_handle_types, only: MPI_File, MPI_Group
            use mpi_direct_file_c, only: VAPAA_MPI_File_get_group
            type(MPI_File), intent(in) :: fh
            type(MPI_Group), intent(out) :: group
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_get_group(fh % MPI_VAL, group % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_get_group_f08

        subroutine MPI_File_get_info_f08(fh, info_used, ierror)
            use mpi_handle_types, only: MPI_File, MPI_Info
            use mpi_direct_file_c, only: VAPAA_MPI_File_get_info
            type(MPI_File), intent(in) :: fh
            type(MPI_Info), intent(out) :: info_used
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_get_info(fh % MPI_VAL, info_used % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_get_info_f08

        subroutine MPI_File_set_info_f08(fh, info, ierror)
            use mpi_handle_types, only: MPI_File, MPI_Info
            use mpi_direct_file_c, only: VAPAA_MPI_File_set_info
            type(MPI_File), intent(in) :: fh
            type(MPI_Info), intent(in) :: info
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_set_info(fh % MPI_VAL, info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_set_info_f08

        subroutine MPI_File_get_position_f08(fh, offset, ierror)
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File
            use mpi_direct_file_c, only: VAPAA_MPI_File_get_position
            type(MPI_File), intent(in) :: fh
            integer(kind=MPI_OFFSET_KIND), intent(out) :: offset
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_get_position(fh % MPI_VAL, offset, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_get_position_f08

        subroutine MPI_File_get_position_shared_f08(fh, offset, ierror)
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File
            use mpi_direct_file_c, only: VAPAA_MPI_File_get_position_shared
            type(MPI_File), intent(in) :: fh
            integer(kind=MPI_OFFSET_KIND), intent(out) :: offset
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_get_position_shared(fh % MPI_VAL, offset, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_get_position_shared_f08

        subroutine MPI_File_get_type_extent_f08(fh, datatype, extent, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_File, MPI_Datatype
            use mpi_direct_file_c, only: VAPAA_MPI_File_get_type_extent
            type(MPI_File), intent(in) :: fh
            type(MPI_Datatype), intent(in) :: datatype
            integer(kind=MPI_ADDRESS_KIND), intent(out) :: extent
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_get_type_extent(fh % MPI_VAL, datatype % MPI_VAL, extent, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_get_type_extent_f08

#ifdef HAVE_CFI
        subroutine MPI_File_get_view_f08(fh, disp, etype, filetype, datarep, ierror)
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File, MPI_Datatype
            use mpi_direct_file_c, only: VAPAA_MPI_File_get_view
            type(MPI_File), intent(in) :: fh
            integer(kind=MPI_OFFSET_KIND), intent(out) :: disp
            type(MPI_Datatype), intent(out) :: etype, filetype
            character(len=*), intent(out) :: datarep
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: datarep_c(:)
            integer(c_int) :: ierror_c
            allocate(datarep_c(len(datarep) + 1))
            datarep_c = c_null_char
            call VAPAA_MPI_File_get_view(fh % MPI_VAL, disp, etype % MPI_VAL, filetype % MPI_VAL, datarep_c, ierror_c)
            call copy_c_string(datarep_c, datarep)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_get_view_f08
#endif

        subroutine MPI_File_seek_f08(fh, offset, whence, ierror)
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File
            use mpi_direct_file_c, only: VAPAA_MPI_File_seek
            type(MPI_File), intent(in) :: fh
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
            integer, intent(in) :: whence
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_seek(fh % MPI_VAL, offset, int(whence,c_int), ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_seek_f08

        subroutine MPI_File_seek_shared_f08(fh, offset, whence, ierror)
            use mpi_global_constants, only: MPI_OFFSET_KIND
            use mpi_handle_types, only: MPI_File
            use mpi_direct_file_c, only: VAPAA_MPI_File_seek_shared
            type(MPI_File), intent(in) :: fh
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
            integer, intent(in) :: whence
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_seek_shared(fh % MPI_VAL, offset, int(whence,c_int), ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_seek_shared_f08

        subroutine MPI_File_sync_f08(fh, ierror)
            use mpi_handle_types, only: MPI_File
            use mpi_direct_file_c, only: VAPAA_MPI_File_sync
            type(MPI_File), intent(in) :: fh
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_sync(fh % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_sync_f08

end module mpi_direct_file_f
