program main
    use iso_c_binding, only : c_null_char
    use mpi_f08
    implicit none
    integer :: me,ierror
    character(len=MPI_MAX_OBJECT_NAME) :: si, so
    integer :: l
    type(MPI_Datatype) :: v

    call MPI_Init(ierror)
    call MPI_Comm_rank(MPI_COMM_WORLD,me)

    if (me.eq.0) then

        call MPI_Type_vector(26,1,2,MPI_CHARACTER,v)

        so = 'X'
        call MPI_Type_get_name(v,so,l)
        if (l.ne.0) then
            print*,'resultlen is not zero: ', l
            call MPI_Abort(MPI_COMM_WORLD,l)
        endif
        ! not validating that so is an empty string...

        si = 'VAPAA: 26,1,2,MPI_CHAR'
        call MPI_Type_set_name(v,si)

        so = 'X'
        call MPI_Type_get_name(v,so,l)
        if (si(1:22).ne.so(1:22)) then
            call MPI_Abort(MPI_COMM_WORLD,l)
        endif
        ! not validating that so is the same length as the input

        call MPI_Type_free(v)

    endif

    if (me.eq.0) then
        print*,'attribute support is okay'
    end if

    call MPI_Finalize(ierror)

end program main
