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

    contains

        subroutine MPI_Init_f08(ierror) 
            use mpi_core_c, only: C_MPI_Init
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Init(ierror_c)
            if (present(ierror)) then
                ierror = ierror_c
            endif
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
            if (present(ierror)) then
                ierror = ierror_c
            endif
        end subroutine MPI_Init_thread_f08

        subroutine MPI_Finalize_f08(ierror) 
            use mpi_core_c, only: C_MPI_Finalize
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Finalize(ierror_c)
            if (present(ierror)) then
                ierror = ierror_c
            endif
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
            if (present(ierror)) then
                ierror = ierror_c
            endif
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
            if (present(ierror)) then
                ierror = ierror_c
            endif
        end subroutine MPI_Finalized_f08

        subroutine MPI_Query_thread_f08(provided, ierror) 
            use mpi_core_c, only: C_MPI_Query_thread
            integer, intent(out) :: provided
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: provided_c, ierror_c
            call C_MPI_Query_thread(provided_c, ierror_c)
            provided = provided_c
            if (present(ierror)) then
                ierror = ierror_c
            endif
        end subroutine MPI_Query_thread_f08

        subroutine MPI_Abort_f08(comm, errorcode, ierror) 
            use mpi_handle_types, only: MPI_Comm
            use mpi_core_c, only: C_MPI_Abort
            integer, intent(out) :: errorcode
            integer, optional, intent(out) :: ierror
            type(MPI_Comm) :: comm
            integer(kind=c_int) :: comm_c, errorcode_c, ierror_c
            comm_c = comm % MPI_VAL
            errorcode_c = errorcode
            call C_MPI_Abort(comm_c, errorcode_c, ierror_c)
            if (present(ierror)) then
                ierror = ierror_c
            endif
        end subroutine MPI_Abort_f08

end module mpi_core_f
