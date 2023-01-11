module mpi_core_c

    interface
        subroutine C_MPI_Init(ierror) &
                   bind(C,name="C_MPI_Init")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Init
    end interface

    interface
        subroutine C_MPI_Finalize(ierror) &
                   bind(C,name="C_MPI_Finalize")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Finalize
    end interface

    interface
        subroutine C_MPI_Init_thread(required, provided, ierror) &
                   bind(C,name="C_MPI_Init_thread")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: required
            integer(kind=c_int), intent(out) :: provided, ierror
        end subroutine C_MPI_Init_thread
    end interface

    interface
        subroutine C_MPI_Initialized(flag, ierror) &
                   bind(C,name="C_MPI_Initialized")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine C_MPI_Initialized
    end interface

    interface
        subroutine C_MPI_Finalized(flag, ierror) &
                   bind(C,name="C_MPI_Finalize")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine C_MPI_Finalized
    end interface

    interface
        subroutine C_MPI_Query_thread(provided, ierror) &
                   bind(C,name="C_MPI_Query_thread")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: provided, ierror
        end subroutine C_MPI_Query_thread
    end interface

    interface
        subroutine C_MPI_Abort(comm, errorcode, ierror) &
                   bind(C,name="C_MPI_Abort")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, errorcode
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Abort
    end interface

    interface
        subroutine C_MPI_Get_version(version, subversion, ierror) &
                   bind(C,name="C_MPI_Get_version")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: version, subversion, ierror
        end subroutine C_MPI_Get_version
    end interface

    interface
        subroutine C_MPI_Get_library_version(version, resultlen, ierror) &
                   bind(C,name="C_MPI_Get_library_version")
            use iso_c_binding, only: c_int, c_char
            implicit none
            character(kind=c_char), dimension(*), intent(out) :: version
            integer(kind=c_int), intent(out) :: resultlen, ierror
        end subroutine C_MPI_Get_library_version
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Get_library_version(version, resultlen, ierror) &
                   bind(C,name="CFI_MPI_Get_library_version")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(inout) :: version
            integer(kind=c_int), intent(out) :: resultlen, ierror
        end subroutine CFI_MPI_Get_library_version
    end interface
#endif

    interface
        function C_MPI_Wtime() result(time) &
                 bind(C,name="C_MPI_Wtime")
            use iso_c_binding, only: c_double
            implicit none
            real(kind=c_double) :: time
        end function C_MPI_Wtime
    end interface

    interface
        function C_MPI_Wtick() result(time) &
                 bind(C,name="C_MPI_Wtick")
            use iso_c_binding, only: c_double
            implicit none
            real(kind=c_double) :: time
        end function C_MPI_Wtick
    end interface

end module mpi_core_c

