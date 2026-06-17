! SPDX-License-Identifier: MIT

module mpi_direct_file_c
    use iso_c_binding, only: c_int, c_intptr_t, c_int64_t
    implicit none

    interface
        subroutine VAPAA_MPI_File_get_amode(fh, amode, ierror) &
                   bind(C,name="VAPAA_MPI_File_get_amode")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: fh
            integer(kind=c_int), intent(out) :: amode, ierror
        end subroutine VAPAA_MPI_File_get_amode

        subroutine VAPAA_MPI_File_get_atomicity(fh, flag, ierror) &
                   bind(C,name="VAPAA_MPI_File_get_atomicity")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: fh
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine VAPAA_MPI_File_get_atomicity

        subroutine VAPAA_MPI_File_set_atomicity(fh, flag, ierror) &
                   bind(C,name="VAPAA_MPI_File_set_atomicity")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: fh, flag
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_File_set_atomicity

        subroutine VAPAA_MPI_File_get_byte_offset(fh, offset, disp, ierror) &
                   bind(C,name="VAPAA_MPI_File_get_byte_offset")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), intent(in) :: fh
            integer(kind=c_int64_t), intent(in) :: offset
            integer(kind=c_int64_t), intent(out) :: disp
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_File_get_byte_offset

        subroutine VAPAA_MPI_File_get_group(fh, group, ierror) &
                   bind(C,name="VAPAA_MPI_File_get_group")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: fh
            integer(kind=c_int), intent(out) :: group, ierror
        end subroutine VAPAA_MPI_File_get_group

        subroutine VAPAA_MPI_File_get_info(fh, info_used, ierror) &
                   bind(C,name="VAPAA_MPI_File_get_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: fh
            integer(kind=c_int), intent(out) :: info_used, ierror
        end subroutine VAPAA_MPI_File_get_info

        subroutine VAPAA_MPI_File_set_info(fh, info, ierror) &
                   bind(C,name="VAPAA_MPI_File_set_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: fh, info
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_File_set_info

        subroutine VAPAA_MPI_File_get_position(fh, offset, ierror) &
                   bind(C,name="VAPAA_MPI_File_get_position")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), intent(in) :: fh
            integer(kind=c_int64_t), intent(out) :: offset
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_File_get_position

        subroutine VAPAA_MPI_File_get_position_shared(fh, offset, ierror) &
                   bind(C,name="VAPAA_MPI_File_get_position_shared")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), intent(in) :: fh
            integer(kind=c_int64_t), intent(out) :: offset
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_File_get_position_shared

        subroutine VAPAA_MPI_File_get_type_extent(fh, datatype, extent, ierror) &
                   bind(C,name="VAPAA_MPI_File_get_type_extent")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: fh, datatype
            integer(kind=c_intptr_t), intent(out) :: extent
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_File_get_type_extent

        subroutine VAPAA_MPI_File_seek(fh, offset, whence, ierror) &
                   bind(C,name="VAPAA_MPI_File_seek")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), intent(in) :: fh, whence
            integer(kind=c_int64_t), intent(in) :: offset
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_File_seek

        subroutine VAPAA_MPI_File_seek_shared(fh, offset, whence, ierror) &
                   bind(C,name="VAPAA_MPI_File_seek_shared")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), intent(in) :: fh, whence
            integer(kind=c_int64_t), intent(in) :: offset
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_File_seek_shared

        subroutine VAPAA_MPI_File_sync(fh, ierror) &
                   bind(C,name="VAPAA_MPI_File_sync")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: fh
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_File_sync
    end interface

#ifdef HAVE_CFI
    interface
        subroutine VAPAA_MPI_File_get_view(fh, disp, etype, filetype, datarep, ierror) &
                   bind(C,name="VAPAA_MPI_File_get_view")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), intent(in) :: fh
            integer(kind=c_int64_t), intent(out) :: disp
            integer(kind=c_int), intent(out) :: etype, filetype
            type(*), dimension(..), intent(inout) :: datarep
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_File_get_view
    end interface
#endif

end module mpi_direct_file_c
