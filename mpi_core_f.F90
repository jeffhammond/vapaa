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

    interface MPI_Wtime
        module procedure MPI_Wtime_f08
    end interface MPI_Wtime

    interface MPI_Wtick
        module procedure MPI_Wtick_f08
    end interface MPI_Wtick

    contains

        subroutine F_MPI_IN_PLACE()
            use mpi_global_constants, only: MPI_IN_PLACE
            use mpi_core_c, only: C_MPI_IN_PLACE
            call C_MPI_IN_PLACE(MPI_IN_PLACE)
        end subroutine F_MPI_IN_PLACE

        subroutine F_MPI_Init_handles()
            use mpi_global_constants
            use mpi_comm_c, only:     C_MPI_COMM_WORLD,    &
                                      C_MPI_COMM_SELF,     &
                                      C_MPI_COMM_NULL
            use mpi_datatype_c, only: C_MPI_DATATYPE_NULL
            use mpi_file_c, only:     C_MPI_FILE_NULL
            use mpi_group_c, only:    C_MPI_GROUP_NULL
            use mpi_info_c, only:     C_MPI_INFO_NULL
            use mpi_message_c, only:  C_MPI_MESSAGE_NULL
            use mpi_op_c, only:       C_MPI_OP_NULL, C_MPI_OP_BUILTINS
            use mpi_request_c, only:  C_MPI_REQUEST_NULL
            use mpi_win_c, only:      C_MPI_WIN_NULL
            ! comm
            call C_MPI_COMM_WORLD(MPI_COMM_WORLD % MPI_VAL)
            call C_MPI_COMM_SELF(MPI_COMM_SELF % MPI_VAL)
            call C_MPI_COMM_NULL(MPI_COMM_NULL % MPI_VAL)
            ! datatype
            call C_MPI_DATATYPE_NULL(MPI_DATATYPE_NULL % MPI_VAL)
            ! file
            call C_MPI_FILE_NULL(MPI_FILE_NULL % MPI_VAL)
            ! group
            call C_MPI_GROUP_NULL(MPI_GROUP_NULL % MPI_VAL)
            ! message
            call C_MPI_MESSAGE_NULL(MPI_MESSAGE_NULL % MPI_VAL)
            ! info
            call C_MPI_INFO_NULL(MPI_INFO_NULL % MPI_VAL)
            ! op
            call C_MPI_OP_NULL(MPI_OP_NULL % MPI_VAL)
            ! request
            call C_MPI_REQUEST_NULL(MPI_REQUEST_NULL % MPI_VAL)
            ! win
            call C_MPI_WIN_NULL(MPI_WIN_NULL % MPI_VAL)
            ! status ignore
            MPI_STATUS_IGNORE % MPI_SOURCE   = -9119
            MPI_STATUS_IGNORE % MPI_TAG      = -9119
            MPI_STATUS_IGNORE % MPI_ERROR    = -9119
            MPI_STATUSES_IGNORE % MPI_SOURCE = -9119
            MPI_STATUSES_IGNORE % MPI_TAG    = -9119
            MPI_STATUSES_IGNORE % MPI_ERROR  = -9119
            ! we need to be able to check if this function has been called
            ! or else most things will not work.  user must initialize
            ! _this_ library using its MPI_Init, and no other.
            global_handles_are_initialized = .true.
        end subroutine F_MPI_Init_handles

        subroutine MPI_Init_f08(ierror) 
            use mpi_core_c, only: C_MPI_Init
            use mpi_datatype_f, only: F_MPI_Init_datatypes
            use mpi_op_f, only: F_MPI_Init_ops
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Init(ierror_c)
            call F_MPI_Init_handles()
            call F_MPI_Init_datatypes()
            call F_MPI_Init_ops()
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Init_f08

        subroutine MPI_Init_thread_f08(required, provided, ierror) 
            use mpi_core_c, only: C_MPI_Init_thread
            use mpi_datatype_f, only: F_MPI_Init_datatypes
            use mpi_op_f, only: F_MPI_Init_ops
            integer, intent(in) :: required
            integer, intent(out) :: provided
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: required_c, provided_c, ierror_c
            required_c = required
            call C_MPI_Init_thread(required_c, provided_c, ierror_c)
            provided = provided_c
            call F_MPI_Init_handles()
            call F_MPI_Init_datatypes()
            call F_MPI_Init_ops()
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
            if (flag_c .eq. 0) then
                flag = .false.
            else
                flag = .true.
            endif
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Initialized_f08

        subroutine MPI_Finalized_f08(flag, ierror) 
            use mpi_core_c, only: C_MPI_Finalized
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: flag_c, ierror_c
            call C_MPI_Finalized(flag_c, ierror_c)
            if (flag_c .eq. 0) then
                flag = .false.
            else
                flag = .true.
            endif
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
