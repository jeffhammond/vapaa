program test_pgif_util_coverage
    use iso_c_binding, only: c_int
    use mpi_f08
    implicit none

    interface
        subroutine pgif_util_coverage(ierror) bind(C)
            import :: c_int
            integer(c_int), intent(out) :: ierror
        end subroutine pgif_util_coverage
    end interface

    integer :: ierr, rank
    integer(c_int) :: c_ierr

    call MPI_Init(ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Init")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_rank")

    call pgif_util_coverage(c_ierr)
    call require(c_ierr == 0_c_int, "pgif_util_coverage")

    if (rank == 0) print *, "Test passed"
    call MPI_Finalize(ierr)

contains

    subroutine require(ok, label)
        logical, intent(in) :: ok
        character(len=*), intent(in) :: label

        if (.not. ok) then
            print *, "FAIL:", trim(label), "rank", rank, "ierr", ierr, c_ierr
            call MPI_Abort(MPI_COMM_WORLD, 1, ierr)
        end if
    end subroutine require

end program test_pgif_util_coverage
