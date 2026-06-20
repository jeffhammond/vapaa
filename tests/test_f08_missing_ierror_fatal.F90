program main
    use mpi_f08
    implicit none

    integer :: ierr
    integer :: abi_major, abi_minor

    call MPI_Init(ierr)
    if (ierr /= MPI_SUCCESS) error stop 1

    call MPI_Comm_set_errhandler(MPI_COMM_SELF, MPI_ERRORS_RETURN, ierr)
    if (ierr /= MPI_SUCCESS) error stop 1

    call MPI_Abi_get_version(abi_major, abi_minor)

    print *, 'MPI_Abi_get_version returned without ierror'
    error stop 1
end program main
