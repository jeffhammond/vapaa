program test_core
    use mpi_f08
    implicit none
    integer :: ierror
    integer :: me, np
    integer :: v, sv
    character(len=MPI_MAX_LIBRARY_VERSION_STRING) :: lib
    integer :: liblen
    logical :: flags(3,2)

    flags = .false.

    call MPI_Initialized(flags(1,1))
    !call MPI_Finalized(flags(1,2))

    call MPI_Init(ierror)

    call MPI_Initialized(flags(2,1))
    !call MPI_Finalized(flags(2,2))

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)
    print*,'I am ',me,' of ',np,' of WORLD'

    if (np.eq.3) call MPI_Abort(MPI_COMM_WORLD,3)

    call MPI_Get_version(v,sv)
    if (me.eq.0) print*,'MPI ',v,'.',sv

    call MPI_Get_library_version(lib, liblen)
    !if (me.eq.0) print*,'MPI library: ',lib

    call MPI_Comm_rank(MPI_COMM_SELF,me)
    call MPI_Comm_size(MPI_COMM_SELF,np)
    print*,'I am ',me,' of ',np,' of SELF'

    call MPI_Finalize(ierror)

    call MPI_Initialized(flags(3,1))
    !call MPI_Finalized(flags(3,2))

    if (me.eq.0) print*,'init=',flags(:,1)!,' final=',flags(:,2)

end program test_core
