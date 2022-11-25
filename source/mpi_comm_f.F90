module mpi_comm_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Comm_rank
        module procedure MPI_Comm_rank_f08
    end interface MPI_Comm_rank

    interface MPI_Comm_size
        module procedure MPI_Comm_size_f08
    end interface MPI_Comm_size

    interface MPI_Comm_compare
        module procedure MPI_Comm_compare_f08
    end interface MPI_Comm_compare

    interface MPI_Comm_dup
        module procedure MPI_Comm_dup_f08
    end interface MPI_Comm_dup

    interface MPI_Comm_dup_with_info
        module procedure MPI_Comm_dup_with_info_f08
    end interface MPI_Comm_dup_with_info

    interface MPI_Comm_idup
        module procedure MPI_Comm_idup_f08
    end interface MPI_Comm_idup

    interface MPI_Comm_idup_with_info
        module procedure MPI_Comm_idup_with_info_f08
    end interface MPI_Comm_idup_with_info

    contains

        subroutine MPI_Comm_rank_f08(comm, rank, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_rank
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: rank
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, ierror_c
            call C_MPI_Comm_rank(comm % MPI_VAL, rank_c, ierror_c)
            rank = rank_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_rank_f08

        subroutine MPI_Comm_size_f08(comm, size, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_size
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: size_c, ierror_c
            call C_MPI_Comm_size(comm % MPI_VAL, size_c, ierror_c)
            size = size_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_size_f08

        subroutine MPI_Comm_compare_f08(comm1, comm2, result, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_compare
            type(MPI_Comm), intent(in) :: comm1, comm2
            integer, intent(out) :: result
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: result_c, ierror_c
            call C_MPI_Comm_compare(comm1 % MPI_VAL, comm2 % MPI_VAL, result_c, ierror_c)
            result = result_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_compare_f08

        subroutine MPI_Comm_dup_f08(comm, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_dup
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_dup(comm % MPI_VAL, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_dup_f08

        subroutine MPI_Comm_dup_with_info_f08(comm, info, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info
            use mpi_comm_c, only: C_MPI_Comm_dup_with_info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_dup_with_info(comm % MPI_VAL, info % MPI_VAL, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_dup_with_info_f08

        subroutine MPI_Comm_idup_f08(comm, newcomm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Request
            use mpi_comm_c, only: C_MPI_Comm_idup
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Comm), intent(out), asynchronous :: newcomm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_idup(comm % MPI_VAL, newcomm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_idup_f08

        subroutine MPI_Comm_idup_with_info_f08(comm, info, newcomm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info, MPI_Request
            use mpi_comm_c, only: C_MPI_Comm_idup_with_info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(out), asynchronous :: newcomm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_idup_with_info(comm % MPI_VAL, info % MPI_VAL, newcomm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_idup_with_info_f08

end module mpi_comm_f
