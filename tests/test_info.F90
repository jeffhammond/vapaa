program main
    use mpi_f08
    use, intrinsic :: iso_c_binding, only: c_null_char
    implicit none
    integer :: ierror, buflen, nkeys, i
    integer :: me, np
    type(MPI_Info) :: info,dup
    logical :: flag
    character(len=MPI_MAX_INFO_VAL) :: string

    call MPI_Init(ierror)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    call MPI_Comm_size(MPI_COMM_WORLD,np)

    call MPI_Info_create(info)

    call MPI_Info_set(info,'key1','val1')
    call MPI_Info_set(info,'key2','val2')
    call MPI_Info_set(info,'key3','val3')

    call MPI_Info_get_nkeys(info,nkeys)
    if (nkeys .ne. 3) then
        print*,'nkeys=',nkeys,' (should be 3)'
        call MPI_Abort(MPI_COMM_WORLD,nkeys)
    end if

    call MPI_Info_delete(info,'key2')

    call MPI_Info_dup(info,dup)

    call MPI_Info_free(info)

    call MPI_Info_get_nkeys(dup,nkeys)
    if (nkeys .ne. 2) then
        print*,'nkeys=',nkeys,' (should be 2)'
        call MPI_Abort(MPI_COMM_WORLD,nkeys)
    end if

    buflen=MPI_MAX_INFO_VAL
    call MPI_Info_get_string(dup,'key1',buflen,string,flag)
    if ((.not.flag).or.(buflen.ne.5).or.(string(1:4).ne.'val1')) then
        print*,'key1=',trim(string),' buflen=',buflen,' (should be 5)',' flag=',flag,' (should be true)'
        call MPI_Abort(MPI_COMM_WORLD,1)
    end if

    buflen=MPI_MAX_INFO_VAL
    call MPI_Info_get_string(dup,'key2',buflen,string,flag)
    if (flag) then
        print*,'flag=',flag,' (should be false)'
        call MPI_Abort(MPI_COMM_WORLD,1)
    end if

    do i=0,nkeys-1
        call MPI_Info_get_nthkey(dup, i, string)
        if (((i.eq.0).and.(string(1:4).ne.'key1')).or. &
            ((i.eq.1).and.(string(1:4).ne.'key3'))) then
            print*,'key(',i,')=',string
        end if
    end do

    call MPI_Info_free(dup)

    if (me.eq.0) then
        print*,'MPI_Info stuff is okay'
        print *, 'Test passed'
    end if

    call MPI_Finalize()

end program main
