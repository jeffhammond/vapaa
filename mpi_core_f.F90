module mpi_core_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Init
        module procedure MPI_Init_f08
    end interface MPI_Init

    interface MPI_Finalize
        module procedure MPI_Finalize_f08
    end interface MPI_Finalize

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

        subroutine MPI_Finalize_f08(ierror) 
            use mpi_core_c, only: C_MPI_Finalize
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Finalize(ierror_c)
            if (present(ierror)) then
                ierror = ierror_c
            endif
        end subroutine MPI_Finalize_f08

end module mpi_core_f
