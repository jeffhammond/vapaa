program main
    use mpi_f08
    implicit none
    integer :: me,ierror,e,c
    character(len=MPI_MAX_ERROR_STRING) :: s
    integer :: len

    call MPI_Init(ierror)
    call MPI_Comm_rank(MPI_COMM_WORLD,me)

    if (me.eq.0) then

        s = '\0'

        print*,'NAME   :       error       class        name       length'

        e = MPI_SUCCESS
        call MPI_Error_string(e, s, len)
        call MPI_Error_class(e, c)
        print*,'SUCCESS:',e,c,trim(s),len

        e = MPI_ERR_INTERN
        call MPI_Error_string(e, s, len)
        call MPI_Error_class(e, c)
        print*,'INTERN: ',e,c,trim(s),len

        e = MPI_ERR_OTHER
        call MPI_Error_string(e, s, len)
        call MPI_Error_class(e, c)
        print*,'OTHER:  ',e,c,trim(s),len

        e = MPI_ERR_UNKNOWN
        call MPI_Error_string(e, s, len)
        call MPI_Error_class(e, c)
        print*,'UNKNOWN:',e,c,trim(s),len

    endif

    call MPI_Finalize(ierror)
end program main
