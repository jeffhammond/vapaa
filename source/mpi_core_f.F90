! SPDX-License-Identifier: MIT

module mpi_core_f
    use iso_c_binding, only: c_int
    implicit none

    logical :: global_handles_are_initialized = .false.

    interface MPI_Init
        module procedure MPI_Init_f08
    end interface MPI_Init

    interface MPI_Finalize
        module procedure MPI_Finalize_f08
    end interface MPI_Finalize

    interface MPI_Init_thread
        module procedure MPI_Init_thread_f08
    end interface MPI_Init_thread

    interface MPI_Initialized
        module procedure MPI_Initialized_f08
    end interface MPI_Initialized

    interface MPI_Finalized
        module procedure MPI_Finalized_f08
    end interface MPI_Finalized

    interface MPI_Query_thread
        module procedure MPI_Query_thread_f08
    end interface MPI_Query_thread

    interface MPI_Abort
        module procedure MPI_Abort_f08
    end interface MPI_Abort

    interface MPI_Get_version
        module procedure MPI_Get_version_f08
    end interface MPI_Get_version

    interface MPI_Get_library_version
#ifdef HAVE_CFI
        module procedure MPI_Get_library_version_f08ts
#else
        module procedure MPI_Get_library_version_f08
#endif
    end interface MPI_Get_library_version

    interface MPI_Wtime
        module procedure MPI_Wtime_f08
    end interface MPI_Wtime

    interface MPI_Wtick
        module procedure MPI_Wtick_f08
    end interface MPI_Wtick

    contains

        subroutine F_Check_design_assumptions()
            use iso_c_binding, only: c_sizeof, c_int
            use mpi_handle_types
            integer            :: i(4),j
            type(MPI_Comm)     :: c
            type(MPI_Datatype) :: d
            type(MPI_Message)  :: m
            type(MPI_Op)       :: o
            type(MPI_Group)    :: g
            type(MPI_Request)  :: r(4)
            type(MPI_Win)      :: w
            if (c_sizeof(int(0,c_int)).ne.c_sizeof(int(0))) then
                print*,'Design assumptions violated: INTEGER'
                stop
            endif
            if (c_sizeof(c).ne.c_sizeof(j)) then
                print*,'Design assumptions violated: MPI_Comm'
                stop
            endif
            if (c_sizeof(d).ne.c_sizeof(j)) then
                print*,'Design assumptions violated: MPI_Datatype'
                stop
            endif
            if (c_sizeof(g).ne.c_sizeof(j)) then
                print*,'Design assumptions violated: MPI_Group'
                stop
            endif
            if (c_sizeof(m).ne.c_sizeof(j)) then
                print*,'Design assumptions violated: MPI_Message'
                stop
            endif
            if (c_sizeof(o).ne.c_sizeof(j)) then
                print*,'Design assumptions violated: MPI_Op'
                stop
            endif
            if (c_sizeof(r).ne.c_sizeof(i)) then
                print*,'Design assumptions violated: MPI_Request'
                stop
            endif
            if (c_sizeof(w).ne.c_sizeof(j)) then
                print*,'Design assumptions violated: MPI_Win'
                stop
            endif
        end subroutine F_Check_design_assumptions

        subroutine F_MPI_INIT_ADDRESS_SENTINELS()
            use mpi_global_constants
            use detect_sentinels_c
            call C_MPI_BOTTOM(MPI_BOTTOM)
            call C_MPI_STATUS_IGNORE(MPI_STATUS_IGNORE)
            call C_MPI_STATUSES_IGNORE(MPI_STATUSES_IGNORE)
            call C_MPI_ERRCODES_IGNORE(MPI_ERRCODES_IGNORE)
            call C_MPI_IN_PLACE(MPI_IN_PLACE)
            call C_MPI_ARGV_NULL(MPI_ARGV_NULL)
            call C_MPI_ARGVS_NULL(MPI_ARGVS_NULL)
            call C_MPI_UNWEIGHTED(MPI_UNWEIGHTED)
            call C_MPI_WEIGHTS_EMPTY(MPI_WEIGHTS_EMPTY)
        end subroutine F_MPI_INIT_ADDRESS_SENTINELS

        subroutine MPI_Init_f08(ierror) 
            use iso_c_binding, only: c_sizeof, c_int
            use mpi_core_c, only: C_MPI_Init
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Init(ierror_c)
            call F_MPI_INIT_ADDRESS_SENTINELS()
            call F_Check_design_assumptions()
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Init_f08

        subroutine MPI_Init_thread_f08(required, provided, ierror) 
            use mpi_core_c, only: C_MPI_Init_thread
            integer, intent(in) :: required
            integer, intent(out) :: provided
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: required_c, provided_c, ierror_c
            required_c = required
            call C_MPI_Init_thread(required_c, provided_c, ierror_c)
            provided = provided_c
            call F_MPI_INIT_ADDRESS_SENTINELS()
            call F_Check_design_assumptions()
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Init_thread_f08

        subroutine MPI_Finalize_f08(ierror) 
            use mpi_core_c, only: C_MPI_Finalize
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Finalize(ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Finalize_f08

        ! MPI 4.0 2.6.3
        ! Logical flags are integers with value 0 meaning “false” and a non-zero value meaning “true.”

        subroutine MPI_Initialized_f08(flag, ierror) 
            use mpi_core_c, only: C_MPI_Initialized
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: flag_c, ierror_c
            call C_MPI_Initialized(flag_c, ierror_c)
            flag = (flag_c .ne. 0)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Initialized_f08

        subroutine MPI_Finalized_f08(flag, ierror) 
            use mpi_core_c, only: C_MPI_Finalized
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: flag_c, ierror_c
            call C_MPI_Finalized(flag_c, ierror_c)
            flag = (flag_c .ne. 0)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Finalized_f08

        subroutine MPI_Query_thread_f08(provided, ierror) 
            use mpi_core_c, only: C_MPI_Query_thread
            integer, intent(out) :: provided
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: provided_c, ierror_c
            call C_MPI_Query_thread(provided_c, ierror_c)
            provided = provided_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Query_thread_f08

        subroutine MPI_Abort_f08(comm, errorcode, ierror) 
            use mpi_handle_types, only: MPI_Comm
            use mpi_core_c, only: C_MPI_Abort
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: errorcode
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: errorcode_c, ierror_c
            errorcode_c = errorcode
            call C_MPI_Abort(comm % MPI_VAL, errorcode_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Abort_f08

        subroutine MPI_Get_version_f08(version, subversion, ierror) 
            use mpi_core_c, only: C_MPI_Get_version
            integer, intent(out) :: version, subversion
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: version_c, subversion_c, ierror_c
            call C_MPI_Get_version(version_c, subversion_c, ierror_c)
            version = version_c
            subversion = subversion_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_version_f08

        subroutine MPI_Get_library_version_f08(version, resultlen, ierror) 
            use mpi_core_c, only: C_MPI_Get_library_version
            use mpi_global_constants, only: MPI_MAX_LIBRARY_VERSION_STRING
            character(len=MPI_MAX_LIBRARY_VERSION_STRING), intent(out) :: version
            integer, intent(out) :: resultlen
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: resultlen_c, ierror_c
            call C_MPI_Get_library_version(version, resultlen_c, ierror_c)
            resultlen = resultlen_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_library_version_f08

#ifdef HAVE_CFI
        subroutine MPI_Get_library_version_f08ts(version, resultlen, ierror)
            use mpi_core_c, only: CFI_MPI_Get_library_version
            use mpi_global_constants, only: MPI_MAX_LIBRARY_VERSION_STRING
            character(len=MPI_MAX_LIBRARY_VERSION_STRING), intent(out) :: version
            integer, intent(out) :: resultlen
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: resultlen_c, ierror_c
            call CFI_MPI_Get_library_version(version, resultlen_c, ierror_c)
            resultlen = resultlen_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_library_version_f08ts
#endif

        function MPI_Wtime_f08() result(time)
            use mpi_core_c, only: C_MPI_Wtime
            double precision :: time
            time = C_MPI_Wtime()
        end function MPI_Wtime_f08

        function MPI_Wtick_f08() result(time)
            use mpi_core_c, only: C_MPI_Wtick
            double precision :: time
            time = C_MPI_Wtick()
        end function MPI_Wtick_f08

end module mpi_core_f
