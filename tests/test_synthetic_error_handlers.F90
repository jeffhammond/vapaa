program main
    use mpi_f08
    implicit none

    integer :: ierr, errors
    integer :: abi_major, abi_minor
    type(MPI_Errhandler) :: handler
    type(MPI_Comm) :: newcomm
    type(MPI_Request) :: request
    integer :: handler_calls

    errors = 0
    handler_calls = 0

    call MPI_Init(ierr)
    call record(ierr == MPI_SUCCESS, 'MPI_Init')

    call MPI_Comm_set_errhandler(MPI_COMM_SELF, MPI_ERRORS_RETURN, ierr)
    call record(ierr == MPI_SUCCESS, 'MPI_Comm_set_errhandler return')
    call MPI_Abi_get_version(abi_major, abi_minor, ierr)
    call record(ierr == MPI_SUCCESS .or. &
                ierr == MPI_ERR_UNSUPPORTED_OPERATION, &
                'MPI_Abi_get_version returns when requested')

    call MPI_Comm_create_errhandler(comm_handler, handler, ierr)
    call record(ierr == MPI_SUCCESS, 'MPI_Comm_create_errhandler')
    call MPI_Comm_set_errhandler(MPI_COMM_SELF, handler, ierr)
    call record(ierr == MPI_SUCCESS, 'MPI_Comm_set_errhandler custom')

    handler_calls = 0
    call MPI_Abi_get_version(abi_major, abi_minor, ierr)
    call record(ierr == MPI_SUCCESS .or. &
                ierr == MPI_ERR_UNSUPPORTED_OPERATION, &
                'MPI_Abi_get_version with custom handler')
    if (ierr == MPI_ERR_UNSUPPORTED_OPERATION) then
        call record(handler_calls == 1, 'custom handler call count')
    else
        call record(handler_calls == 0, &
                    'custom handler not called on MPI-5 ABI success')
    end if

    handler_calls = 0
    call MPI_Comm_idup_with_info(MPI_COMM_SELF, MPI_INFO_NULL, newcomm, &
                                 request, ierr)
    if (ierr == MPI_ERR_UNSUPPORTED_OPERATION) then
        call record(ierr == MPI_ERR_UNSUPPORTED_OPERATION, &
                    'MPI_Comm_idup_with_info unsupported error')
        call record(handler_calls == 1, &
                    'communicator synthetic handler call count')
    else
        call record(ierr == MPI_SUCCESS, 'MPI_Comm_idup_with_info success')
        if (ierr == MPI_SUCCESS) then
            call MPI_Wait(request, MPI_STATUS_IGNORE, ierr)
            call record(ierr == MPI_SUCCESS, 'MPI_Comm_idup_with_info wait')
            call MPI_Comm_free(newcomm, ierr)
            call record(ierr == MPI_SUCCESS, 'MPI_Comm_idup_with_info free')
        end if
        call record(handler_calls == 0, &
                    'communicator handler not called on MPI-4 success')
    end if

    call MPI_Errhandler_free(handler, ierr)
    call record(ierr == MPI_SUCCESS, 'MPI_Errhandler_free')
    call MPI_Comm_set_errhandler(MPI_COMM_SELF, MPI_ERRORS_RETURN, ierr)
    call record(ierr == MPI_SUCCESS, 'restore MPI_ERRORS_RETURN')

    call MPI_Finalize(ierr)
    call record(ierr == MPI_SUCCESS, 'MPI_Finalize')

    if (errors == 0) then
        print *, 'Test passed'
    else
        print *, 'Test failed with ', errors, ' errors'
        error stop 1
    end if

contains

    subroutine record(ok, label)
        logical, intent(in) :: ok
        character(len=*), intent(in) :: label
        if (.not. ok) then
            errors = errors + 1
            print *, 'failure: ', trim(label)
        end if
    end subroutine record

    subroutine comm_handler(comm, error_code)
        type(MPI_Comm) :: comm
        integer :: error_code
        if (error_code == MPI_SUCCESS) then
            errors = errors + 1
            print *, 'failure: handler error code'
        end if
        handler_calls = handler_calls + 1
        comm = comm
    end subroutine comm_handler

end program main
