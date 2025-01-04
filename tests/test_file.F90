program main
    use mpi_f08
    implicit none
    integer :: ierror, slen
    integer :: me, np
    integer :: amode
    type(MPI_File) :: f
    character(len=9) :: filename
    character(len=MPI_MAX_ERROR_STRING) :: string

    call MPI_Init(ierror)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)
    print*,'I am ',me,' of ',np,' of WORLD'

    write(filename,'(a4,i4)') 'file',me
    amode = IOR( MPI_MODE_CREATE, MPI_MODE_RDWR )

    call MPI_File_open(MPI_COMM_SELF,trim(adjustl(filename)),amode,MPI_INFO_NULL,f,ierror)
    if (ierror.ne.MPI_SUCCESS) then
        print*,'open failed'
        call MPI_Error_string(ierror, string, slen)    
        print*,'why? ',trim(string)
    endif

    call MPI_File_close(f,ierror)
    if (ierror.ne.MPI_SUCCESS) then
        print*,'close failed'
        call MPI_Error_string(ierror, string, slen)    
        print*,'why? ',trim(string)
    endif

    call MPI_File_delete(trim(adjustl(filename)),MPI_INFO_NULL)
    if (ierror.ne.MPI_SUCCESS) then
        print*,'delete failed'
        call MPI_Error_string(ierror, string, slen)    
        print*,'why? ',trim(string)
    endif

    call MPI_Finalize(ierror)
        print *, 'Test passed'

end program main
