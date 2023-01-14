program main
    use mpi_f08
    implicit none
    integer :: me,ierror,e,c
    character(len=MPI_MAX_ERROR_STRING) :: s
    integer :: len
    type(MPI_Datatype) :: v

    call MPI_Init(ierror)
    call MPI_Comm_rank(MPI_COMM_WORLD,me)

    if (me.eq.0) then

        call MPI_Type_vector(26,1,2,MPI_CHARACTER,v)
        call MPI_Type_set_name(v,'VAPAA: 26,1,2,MPI_CHAR')
        call MPI_Type_commit(v)
        call MPI_Type_free(v)

    endif

    if (me.eq.0) then
        print*,'attribute support is okay'
    end if

    call MPI_Finalize(ierror)
end program main
