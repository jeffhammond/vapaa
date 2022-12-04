program main
    use mpi_f08
    implicit none
    integer :: ierror, buflen, nkeys, i
    integer :: me, np
    type(MPI_Info) :: info,dup
    logical :: flag
    character(len=MPI_MAX_INFO_VAL) :: string

    call MPI_Init(ierror)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)
    print*,'I am ',me,' of ',np,' of WORLD'

    call MPI_Info_create(info)

    call MPI_Info_set(info,'key1','val1')
    call MPI_Info_set(info,'key2','val2')
    call MPI_Info_set(info,'key3','val3')

    call MPI_Info_get_nkeys(info,nkeys)
    print*,'nkeys=',nkeys

    call MPI_Info_delete(info,'key2')

    call MPI_Info_dup(info,dup)

    call MPI_Info_free(info)

    call MPI_Info_get_nkeys(dup,nkeys)
    print*,'nkeys=',nkeys

    call MPI_Info_get_string(dup,'key1',buflen,string,flag)
    print*,'key1=',string,' buflen=',buflen,' flag=',flag,' (should be true)'

    call MPI_Info_get_string(dup,'key2',buflen,string,flag)
    print*,'key2=',string,' buflen=',buflen,' flag=',flag,' (should be false)'

    do i=0,nkeys
        call MPI_Info_get_nthkey(dup, i, string)
        print*,'key ',i,'=',string
    end do

    call MPI_Info_free(dup)

    call MPI_Finalize(ierror)

end program main
