module mpi_core_f
    use iso_c_binding, only: c_int
    implicit none

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

    contains

        subroutine F_MPI_Init_handles()
            use mpi_global_constants, only: MPI_COMM_WORLD,    &
                                            MPI_COMM_SELF,     &
                                            MPI_COMM_NULL,     &
                                            MPI_DATATYPE_NULL, &
                                            MPI_FILE_NULL,     &
                                            MPI_GROUP_NULL,    &
                                            MPI_INFO_NULL,     &
                                            MPI_MESSAGE_NULL,  &
                                            MPI_OP_NULL,       &
                                            MPI_REQUEST_NULL,  &
                                            MPI_WIN_NULL
            use mpi_comm_c, only:     C_MPI_COMM_WORLD,    &
                                      C_MPI_COMM_SELF,     &
                                      C_MPI_COMM_NULL
            use mpi_datatype_c, only: C_MPI_DATATYPE_NULL
            use mpi_file_c, only:     C_MPI_FILE_NULL
            use mpi_group_c, only:    C_MPI_GROUP_NULL
            use mpi_info_c, only:     C_MPI_INFO_NULL
            use mpi_message_c, only:  C_MPI_MESSAGE_NULL
            use mpi_op_c, only:       C_MPI_OP_NULL
            use mpi_request_c, only:  C_MPI_REQUEST_NULL
            use mpi_win_c, only:      C_MPI_WIN_NULL
            integer(kind=c_int) :: comm_c, datatype_c, file_c, group_c
            integer(kind=c_int) :: info_c, message_c, op_c, request_c
            integer(kind=c_int) :: win_c
            ! comm
            call C_MPI_COMM_WORLD(comm_c)
            MPI_COMM_WORLD % MPI_VAL = comm_c
            call C_MPI_COMM_SELF(comm_c)
            MPI_COMM_SELF % MPI_VAL = comm_c
            call C_MPI_COMM_NULL(comm_c)
            MPI_COMM_NULL % MPI_VAL = comm_c
            ! datatype
            call C_MPI_DATATYPE_NULL(datatype_c)
            MPI_DATATYPE_NULL % MPI_VAL = datatype_c
            ! file
            call C_MPI_FILE_NULL(file_c)
            MPI_FILE_NULL % MPI_VAL = file_c
            ! group
            call C_MPI_GROUP_NULL(group_c)
            MPI_GROUP_NULL % MPI_VAL = group_c
            ! message
            call C_MPI_MESSAGE_NULL(message_c)
            MPI_MESSAGE_NULL % MPI_VAL = message_c
            ! info
            call C_MPI_INFO_NULL(info_c)
            MPI_INFO_NULL % MPI_VAL = info_c
            ! op
            call C_MPI_OP_NULL(op_c)
            MPI_OP_NULL % MPI_VAL = op_c
            ! request
            call C_MPI_REQUEST_NULL(request_c)
            MPI_REQUEST_NULL % MPI_VAL = request_c
            ! win
            call C_MPI_WIN_NULL(win_c)
            MPI_WIN_NULL % MPI_VAL = win_c
        end subroutine F_MPI_Init_handles

        subroutine MPI_Init_f08(ierror) 
            use mpi_core_c, only: C_MPI_Init
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Init(ierror_c)
            call F_MPI_Init_handles()
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
            call F_MPI_Init_handles()
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
            integer, intent(out) :: errorcode
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: comm_c, errorcode_c, ierror_c
            comm_c = comm % MPI_VAL
            errorcode_c = errorcode
            call C_MPI_Abort(comm_c, errorcode_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Abort_f08

end module mpi_core_f
