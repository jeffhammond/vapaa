! SPDX-License-Identifier: MIT

module mpi_direct_file_data_f
    use mpi_ierror_f, only: F_MPI_FINISH_IERROR
    use iso_c_binding, only: c_int, c_int64_t
    use mpi_global_constants, only: MPI_OFFSET_KIND
    use mpi_handle_types, only: MPI_File, MPI_Datatype, MPI_Request, MPI_Status
    implicit none

#ifdef HAVE_CFI
    interface MPI_File_iread
        module procedure MPI_File_iread_f08ts
    end interface
    interface MPI_File_iread_all
        module procedure MPI_File_iread_all_f08ts
    end interface
    interface MPI_File_iread_at
        module procedure MPI_File_iread_at_f08ts
    end interface
    interface MPI_File_iread_at_all
        module procedure MPI_File_iread_at_all_f08ts
    end interface
    interface MPI_File_iread_shared
        module procedure MPI_File_iread_shared_f08ts
    end interface
    interface MPI_File_iwrite
        module procedure MPI_File_iwrite_f08ts
    end interface
    interface MPI_File_iwrite_all
        module procedure MPI_File_iwrite_all_f08ts
    end interface
    interface MPI_File_iwrite_at
        module procedure MPI_File_iwrite_at_f08ts
    end interface
    interface MPI_File_iwrite_at_all
        module procedure MPI_File_iwrite_at_all_f08ts
    end interface
    interface MPI_File_iwrite_shared
        module procedure MPI_File_iwrite_shared_f08ts
    end interface
    interface MPI_File_read_ordered
        module procedure MPI_File_read_ordered_f08ts
    end interface
    interface MPI_File_read_shared
        module procedure MPI_File_read_shared_f08ts
    end interface
    interface MPI_File_write_ordered
        module procedure MPI_File_write_ordered_f08ts
    end interface
    interface MPI_File_write_shared
        module procedure MPI_File_write_shared_f08ts
    end interface
    interface MPI_File_read_all_begin
        module procedure MPI_File_read_all_begin_f08ts
    end interface
    interface MPI_File_read_at_all_begin
        module procedure MPI_File_read_at_all_begin_f08ts
    end interface
    interface MPI_File_read_ordered_begin
        module procedure MPI_File_read_ordered_begin_f08ts
    end interface
    interface MPI_File_write_all_begin
        module procedure MPI_File_write_all_begin_f08ts
    end interface
    interface MPI_File_write_at_all_begin
        module procedure MPI_File_write_at_all_begin_f08ts
    end interface
    interface MPI_File_write_ordered_begin
        module procedure MPI_File_write_ordered_begin_f08ts
    end interface
    interface MPI_File_read_all_end
        module procedure MPI_File_read_all_end_f08ts
    end interface
    interface MPI_File_read_at_all_end
        module procedure MPI_File_read_at_all_end_f08ts
    end interface
    interface MPI_File_read_ordered_end
        module procedure MPI_File_read_ordered_end_f08ts
    end interface
    interface MPI_File_write_all_end
        module procedure MPI_File_write_all_end_f08ts
    end interface
    interface MPI_File_write_at_all_end
        module procedure MPI_File_write_at_all_end_f08ts
    end interface
    interface MPI_File_write_ordered_end
        module procedure MPI_File_write_ordered_end_f08ts
    end interface

    interface
        subroutine VAPAA_MPI_File_iread(fh, buf, count, datatype, request, ierror) bind(C,name="VAPAA_MPI_File_iread")
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..), asynchronous :: buf
            integer(c_int), intent(out) :: request, ierror
        end subroutine
        subroutine VAPAA_MPI_File_iread_all(fh, buf, count, datatype, request, ierror) &
                   bind(C,name="VAPAA_MPI_File_iread_all")
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..), asynchronous :: buf
            integer(c_int), intent(out) :: request, ierror
        end subroutine
        subroutine VAPAA_MPI_File_iread_shared(fh, buf, count, datatype, request, ierror) &
                   bind(C,name="VAPAA_MPI_File_iread_shared")
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..), asynchronous :: buf
            integer(c_int), intent(out) :: request, ierror
        end subroutine
        subroutine VAPAA_MPI_File_iwrite(fh, buf, count, datatype, request, ierror) &
                   bind(C,name="VAPAA_MPI_File_iwrite")
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..), intent(in), asynchronous :: buf
            integer(c_int), intent(out) :: request, ierror
        end subroutine
        subroutine VAPAA_MPI_File_iwrite_all(fh, buf, count, datatype, request, ierror) &
                   bind(C,name="VAPAA_MPI_File_iwrite_all")
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..), intent(in), asynchronous :: buf
            integer(c_int), intent(out) :: request, ierror
        end subroutine
        subroutine VAPAA_MPI_File_iwrite_shared(fh, buf, count, datatype, request, ierror) &
                   bind(C,name="VAPAA_MPI_File_iwrite_shared")
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..), intent(in), asynchronous :: buf
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_File_iread_at(fh, offset, buf, count, datatype, request, ierror) &
                   bind(C,name="VAPAA_MPI_File_iread_at")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            integer(c_int64_t), intent(in) :: offset
            type(*), dimension(..), asynchronous :: buf
            integer(c_int), intent(out) :: request, ierror
        end subroutine
        subroutine VAPAA_MPI_File_iread_at_all(fh, offset, buf, count, datatype, request, ierror) &
                   bind(C,name="VAPAA_MPI_File_iread_at_all")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            integer(c_int64_t), intent(in) :: offset
            type(*), dimension(..), asynchronous :: buf
            integer(c_int), intent(out) :: request, ierror
        end subroutine
        subroutine VAPAA_MPI_File_iwrite_at(fh, offset, buf, count, datatype, request, ierror) &
                   bind(C,name="VAPAA_MPI_File_iwrite_at")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            integer(c_int64_t), intent(in) :: offset
            type(*), dimension(..), intent(in), asynchronous :: buf
            integer(c_int), intent(out) :: request, ierror
        end subroutine
        subroutine VAPAA_MPI_File_iwrite_at_all(fh, offset, buf, count, datatype, request, ierror) &
                   bind(C,name="VAPAA_MPI_File_iwrite_at_all")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            integer(c_int64_t), intent(in) :: offset
            type(*), dimension(..), intent(in), asynchronous :: buf
            integer(c_int), intent(out) :: request, ierror
        end subroutine

        subroutine VAPAA_MPI_File_read_ordered(fh, buf, count, datatype, status, ierror) &
                   bind(C,name="VAPAA_MPI_File_read_ordered")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..) :: buf
            type(MPI_Status), intent(out) :: status
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_File_read_shared(fh, buf, count, datatype, status, ierror) &
                   bind(C,name="VAPAA_MPI_File_read_shared")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..) :: buf
            type(MPI_Status), intent(out) :: status
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_File_write_ordered(fh, buf, count, datatype, status, ierror) &
                   bind(C,name="VAPAA_MPI_File_write_ordered")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..), intent(in) :: buf
            type(MPI_Status), intent(out) :: status
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_File_write_shared(fh, buf, count, datatype, status, ierror) &
                   bind(C,name="VAPAA_MPI_File_write_shared")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..), intent(in) :: buf
            type(MPI_Status), intent(out) :: status
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_File_read_all_begin(fh, buf, count, datatype, ierror) &
                   bind(C,name="VAPAA_MPI_File_read_all_begin")
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..), asynchronous :: buf
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_File_read_ordered_begin(fh, buf, count, datatype, ierror) &
                   bind(C,name="VAPAA_MPI_File_read_ordered_begin")
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..), asynchronous :: buf
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_File_write_all_begin(fh, buf, count, datatype, ierror) &
                   bind(C,name="VAPAA_MPI_File_write_all_begin")
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..), intent(in), asynchronous :: buf
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_File_write_ordered_begin(fh, buf, count, datatype, ierror) &
                   bind(C,name="VAPAA_MPI_File_write_ordered_begin")
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            type(*), dimension(..), intent(in), asynchronous :: buf
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_File_read_at_all_begin(fh, offset, buf, count, datatype, ierror) &
                   bind(C,name="VAPAA_MPI_File_read_at_all_begin")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            integer(c_int64_t), intent(in) :: offset
            type(*), dimension(..), asynchronous :: buf
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_File_write_at_all_begin(fh, offset, buf, count, datatype, ierror) &
                   bind(C,name="VAPAA_MPI_File_write_at_all_begin")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(c_int), intent(in) :: fh, count, datatype
            integer(c_int64_t), intent(in) :: offset
            type(*), dimension(..), intent(in), asynchronous :: buf
            integer(c_int), intent(out) :: ierror
        end subroutine

        subroutine VAPAA_MPI_File_read_all_end(fh, buf, status, ierror) bind(C,name="VAPAA_MPI_File_read_all_end")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(c_int), intent(in) :: fh
            type(*), dimension(..), asynchronous :: buf
            type(MPI_Status), intent(out) :: status
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_File_read_at_all_end(fh, buf, status, ierror) &
                   bind(C,name="VAPAA_MPI_File_read_at_all_end")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(c_int), intent(in) :: fh
            type(*), dimension(..), asynchronous :: buf
            type(MPI_Status), intent(out) :: status
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_File_read_ordered_end(fh, buf, status, ierror) &
                   bind(C,name="VAPAA_MPI_File_read_ordered_end")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(c_int), intent(in) :: fh
            type(*), dimension(..), asynchronous :: buf
            type(MPI_Status), intent(out) :: status
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_File_write_all_end(fh, buf, status, ierror) bind(C,name="VAPAA_MPI_File_write_all_end")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(c_int), intent(in) :: fh
            type(*), dimension(..), intent(in), asynchronous :: buf
            type(MPI_Status), intent(out) :: status
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_File_write_at_all_end(fh, buf, status, ierror) &
                   bind(C,name="VAPAA_MPI_File_write_at_all_end")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(c_int), intent(in) :: fh
            type(*), dimension(..), intent(in), asynchronous :: buf
            type(MPI_Status), intent(out) :: status
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_File_write_ordered_end(fh, buf, status, ierror) &
                   bind(C,name="VAPAA_MPI_File_write_ordered_end")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            integer(c_int), intent(in) :: fh
            type(*), dimension(..), intent(in), asynchronous :: buf
            type(MPI_Status), intent(out) :: status
            integer(c_int), intent(out) :: ierror
        end subroutine
    end interface
#endif

    contains

        subroutine finish_ierror(ierror, ierror_c)
            integer, optional, intent(out) :: ierror
            integer(c_int), intent(in) :: ierror_c
            call F_MPI_FINISH_IERROR(ierror, ierror_c)
        end subroutine finish_ierror

#ifdef HAVE_CFI
        subroutine MPI_File_iread_f08ts(fh, buf, count, datatype, request, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_iread(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, &
                                      request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_iread_all_f08ts(fh, buf, count, datatype, request, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_iread_all(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, &
                                          request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_iread_shared_f08ts(fh, buf, count, datatype, request, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_iread_shared(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, &
                                             request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_iwrite_f08ts(fh, buf, count, datatype, request, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_iwrite(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, &
                                       request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_iwrite_all_f08ts(fh, buf, count, datatype, request, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_iwrite_all(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, &
                                           request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_iwrite_shared_f08ts(fh, buf, count, datatype, request, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_iwrite_shared(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, &
                                              request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_iread_at_f08ts(fh, offset, buf, count, datatype, request, ierror)
            type(MPI_File), intent(in) :: fh
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
            type(*), dimension(..), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_iread_at(fh % MPI_VAL, int(offset,c_int64_t), buf, int(count,c_int), &
                                         datatype % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_iread_at_all_f08ts(fh, offset, buf, count, datatype, request, ierror)
            type(MPI_File), intent(in) :: fh
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
            type(*), dimension(..), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_iread_at_all(fh % MPI_VAL, int(offset,c_int64_t), buf, int(count,c_int), &
                                             datatype % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_iwrite_at_f08ts(fh, offset, buf, count, datatype, request, ierror)
            type(MPI_File), intent(in) :: fh
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
            type(*), dimension(..), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_iwrite_at(fh % MPI_VAL, int(offset,c_int64_t), buf, int(count,c_int), &
                                          datatype % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_iwrite_at_all_f08ts(fh, offset, buf, count, datatype, request, ierror)
            type(MPI_File), intent(in) :: fh
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
            type(*), dimension(..), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_iwrite_at_all(fh % MPI_VAL, int(offset,c_int64_t), buf, int(count,c_int), &
                                              datatype % MPI_VAL, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_read_ordered_f08ts(fh, buf, count, datatype, status, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(inout) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status), intent(out), target :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_read_ordered(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, &
                                             status, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_read_shared_f08ts(fh, buf, count, datatype, status, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(inout) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status), intent(out), target :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_read_shared(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, &
                                            status, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_write_ordered_f08ts(fh, buf, count, datatype, status, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(in) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status), intent(out), target :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_write_ordered(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, &
                                              status, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_write_shared_f08ts(fh, buf, count, datatype, status, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(in) :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Status), intent(out), target :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_write_shared(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, &
                                             status, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_read_all_begin_f08ts(fh, buf, count, datatype, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(inout), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_read_all_begin(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_read_ordered_begin_f08ts(fh, buf, count, datatype, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(inout), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_read_ordered_begin(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, &
                                                   ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_write_all_begin_f08ts(fh, buf, count, datatype, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(in), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_write_all_begin(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_write_ordered_begin_f08ts(fh, buf, count, datatype, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(in), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_write_ordered_begin(fh % MPI_VAL, buf, int(count,c_int), datatype % MPI_VAL, &
                                                    ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_read_at_all_begin_f08ts(fh, offset, buf, count, datatype, ierror)
            type(MPI_File), intent(in) :: fh
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
            type(*), dimension(..), intent(inout), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_read_at_all_begin(fh % MPI_VAL, int(offset,c_int64_t), buf, int(count,c_int), &
                                                  datatype % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_write_at_all_begin_f08ts(fh, offset, buf, count, datatype, ierror)
            type(MPI_File), intent(in) :: fh
            integer(kind=MPI_OFFSET_KIND), intent(in) :: offset
            type(*), dimension(..), intent(in), asynchronous :: buf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_write_at_all_begin(fh % MPI_VAL, int(offset,c_int64_t), buf, int(count,c_int), &
                                                   datatype % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_read_all_end_f08ts(fh, buf, status, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(inout), asynchronous :: buf
            type(MPI_Status), intent(out), target :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_read_all_end(fh % MPI_VAL, buf, status, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_read_at_all_end_f08ts(fh, buf, status, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(inout), asynchronous :: buf
            type(MPI_Status), intent(out), target :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_read_at_all_end(fh % MPI_VAL, buf, status, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_read_ordered_end_f08ts(fh, buf, status, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(inout), asynchronous :: buf
            type(MPI_Status), intent(out), target :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_read_ordered_end(fh % MPI_VAL, buf, status, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_write_all_end_f08ts(fh, buf, status, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(in), asynchronous :: buf
            type(MPI_Status), intent(out), target :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_write_all_end(fh % MPI_VAL, buf, status, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_write_at_all_end_f08ts(fh, buf, status, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(in), asynchronous :: buf
            type(MPI_Status), intent(out), target :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_write_at_all_end(fh % MPI_VAL, buf, status, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_File_write_ordered_end_f08ts(fh, buf, status, ierror)
            type(MPI_File), intent(in) :: fh
            type(*), dimension(..), intent(in), asynchronous :: buf
            type(MPI_Status), intent(out), target :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_write_ordered_end(fh % MPI_VAL, buf, status, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine
#endif

end module mpi_direct_file_data_f
