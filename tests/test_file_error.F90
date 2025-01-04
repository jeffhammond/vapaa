program main
    use mpi_f08
    implicit none
    integer :: ierror
    integer :: me
    character(len=9) :: filename

    call MPI_Init(ierror)

    call MPI_Comm_rank(MPI_COMM_WORLD,me)
    write(filename,'(i8)') me

    ! try to delete the same file twice, which should fail at least once

    call MPI_File_delete(trim(adjustl(filename)),MPI_INFO_NULL,ierror)
    if (ierror.eq.MPI_SUCCESS) then
        print*,'delete succeeded even though it should not have'
        call MPI_Abort(MPI_COMM_SELF,ierror)
    endif

    call MPI_File_delete(trim(adjustl(filename)),MPI_INFO_NULL,ierror)
    if (ierror.eq.MPI_SUCCESS) then
        print*,'delete succeeded even though it should not have'
        call MPI_Abort(MPI_COMM_SELF,ierror)
    endif

    if (me.eq.0) then
        print*,'file errors fail as expected'
        print *, 'Test passed'
    endif

    call MPI_Finalize(ierror)

end program main
