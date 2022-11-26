module mpi_core_c

    ! NONSTANDARD STUFF

    interface
        subroutine C_MPI_IN_PLACE(inplace) &
                   bind(C,name="C_MPI_IN_PLACE")
            use iso_c_binding, only: c_intptr_t 
            implicit none
#ifdef HAVE_CFI
            type(*) :: inplace
#else
            class(*) :: inplace
#endif
        end subroutine C_MPI_IN_PLACE
    end interface

    interface
        subroutine C_MPI_BOTTOM(bottom) &
                   bind(C,name="C_MPI_BOTTOM")
            use iso_c_binding, only: c_intptr_t 
            implicit none
#ifdef HAVE_CFI
            type(*) :: bottom
#else
            class(*) :: bottom
#endif
        end subroutine C_MPI_BOTTOM
    end interface

    ! STANDARD STUFF

    interface
        subroutine C_MPI_Init(ierror_c) &
                   bind(C,name="C_MPI_Init")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: ierror_c
        end subroutine C_MPI_Init
    end interface

    interface
        subroutine C_MPI_Finalize(ierror_c) &
                   bind(C,name="C_MPI_Finalize")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: ierror_c
        end subroutine C_MPI_Finalize
    end interface

    interface
        subroutine C_MPI_Init_thread(required_c, provided_c, ierror_c) &
                   bind(C,name="C_MPI_Init_thread")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: required_c, provided_c, ierror_c
        end subroutine C_MPI_Init_thread
    end interface

    interface
        subroutine C_MPI_Initialized(flag_c, ierror_c) &
                   bind(C,name="C_MPI_Initialized")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: flag_c, ierror_c
        end subroutine C_MPI_Initialized
    end interface

    interface
        subroutine C_MPI_Finalized(flag_c, ierror_c) &
                   bind(C,name="C_MPI_Finalize")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: flag_c, ierror_c
        end subroutine C_MPI_Finalized
    end interface

    interface
        subroutine C_MPI_Query_thread(provided_c, ierror_c) &
                   bind(C,name="C_MPI_Query_thread")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: provided_c, ierror_c
        end subroutine C_MPI_Query_thread
    end interface

    interface
        subroutine C_MPI_Abort(comm_c, errorcode_c, ierror_c) &
                   bind(C,name="C_MPI_Abort")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, errorcode_c, ierror_c
        end subroutine C_MPI_Abort
    end interface

    interface
        subroutine C_MPI_Get_version(version_c, subversion_c, ierror_c) &
                   bind(C,name="C_MPI_Get_version")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: version_c, subversion_c, ierror_c
        end subroutine C_MPI_Get_version
    end interface

    interface
        subroutine C_MPI_Get_library_version(version_c, resultlen_c, ierror_c) &
                   bind(C,name="C_MPI_Get_library_version")
            use iso_c_binding, only: c_int, c_char
            implicit none
            character(kind=c_char), dimension(:) :: version_c
            integer(kind=c_int) :: resultlen_c, ierror_c
        end subroutine C_MPI_Get_library_version
    end interface

    interface
        function C_MPI_Wtime() result(time_c) &
                 bind(C,name="C_MPI_Wtime")
            use iso_c_binding, only: c_double
            implicit none
            real(kind=c_double) :: time_c
        end function C_MPI_Wtime
    end interface

    interface
        function C_MPI_Wtick() result(time_c) &
                 bind(C,name="C_MPI_Wtick")
            use iso_c_binding, only: c_double
            implicit none
            real(kind=c_double) :: time_c
        end function C_MPI_Wtick
    end interface

end module mpi_core_c

