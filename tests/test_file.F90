program test_core
    use mpi_f08
    implicit none
    integer :: ierror
    integer :: me, np
    type(MPI_File) :: f

    call MPI_Init(ierror)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)
    print*,'I am ',me,' of ',np,' of SELF'

    call MPI_File_open(MPI_COMM_SELF,'me',MPI_MODE_CREATE,MPI_INFO_NULL,f,ierror)
    if (ierror.ne.MPI_SUCCESS) print*,'open failed'

    call MPI_File_close(f,ierror)
    if (ierror.ne.MPI_SUCCESS) print*,'close failed'

    call MPI_Finalize(ierror)

end program test_core
