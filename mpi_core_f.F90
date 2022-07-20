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

    interface MPI_Comm_rank
        module procedure MPI_Comm_rank_f08
    end interface MPI_Comm_rank

    interface MPI_Comm_size
        module procedure MPI_Comm_size_f08
    end interface MPI_Comm_size

    contains

        subroutine MPI_Init_f08(ierror) 
            use mpi_global_constants, only: MPI_COMM_WORLD, MPI_COMM_NULL
            use mpi_core_c, only: C_MPI_Init, C_MPI_COMM_WORLD, C_MPI_COMM_NULL
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: comm_c, ierror_c
            call C_MPI_Init(ierror_c)
            call C_MPI_COMM_WORLD(comm_c)
            MPI_COMM_WORLD % MPI_VAL = comm_c
            call C_MPI_COMM_NULL(comm_c)
            MPI_COMM_NULL % MPI_VAL = comm_c
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

        subroutine MPI_Comm_rank_f08(comm, rank, ierror) 
            use mpi_handle_types, only: MPI_Comm
            use mpi_core_c, only: C_MPI_Comm_rank
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: rank
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: comm_c, rank_c, ierror_c
            comm_c = comm % MPI_VAL
            call C_MPI_Comm_rank(comm_c, rank_c, ierror_c)
            rank = rank_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_rank_f08

        subroutine MPI_Comm_size_f08(comm, size, ierror) 
            use mpi_handle_types, only: MPI_Comm
            use mpi_core_c, only: C_MPI_Comm_size
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: comm_c, size_c, ierror_c
            comm_c = comm % MPI_VAL
            call C_MPI_Comm_size(comm_c, size_c, ierror_c)
            size = size_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_size_f08

end module mpi_core_f
