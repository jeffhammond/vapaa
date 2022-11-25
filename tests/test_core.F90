program test_core
    use mpi_f08
    implicit none
    integer :: ierror
    integer :: me, np
    integer :: v, sv
    character(len=MPI_MAX_LIBRARY_VERSION_STRING) :: lib
    integer :: liblen

    call MPI_Init(ierror)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)
    print*,'I am ',me,' of ',np,' of WORLD'

    call MPI_Get_version(v,sv)
    if (me.eq.0) print*,'MPI ',v,'.',sv

    call MPI_Get_library_version(lib, liblen)
    if (me.eq.0) print*,'MPI library: ',lib

    call MPI_Comm_rank(MPI_COMM_SELF,me)
    call MPI_Comm_size(MPI_COMM_SELF,np)
    print*,'I am ',me,' of ',np,' of SELF'

    call MPI_Finalize(ierror)

end program test_core