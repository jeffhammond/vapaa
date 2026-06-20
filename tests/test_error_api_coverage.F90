program test_error_api_coverage
    use mpi_f08
    implicit none

    integer, parameter :: base_errors(*) = [ &
        MPI_SUCCESS, MPI_ERR_BUFFER, MPI_ERR_COUNT, MPI_ERR_TYPE, &
        MPI_ERR_TAG, MPI_ERR_COMM, MPI_ERR_RANK, MPI_ERR_REQUEST, &
        MPI_ERR_ROOT, MPI_ERR_GROUP, MPI_ERR_OP, MPI_ERR_TOPOLOGY, &
        MPI_ERR_DIMS, MPI_ERR_ARG, MPI_ERR_UNKNOWN, MPI_ERR_TRUNCATE, &
        MPI_ERR_OTHER, MPI_ERR_INTERN, MPI_ERR_PENDING, &
        MPI_ERR_IN_STATUS, MPI_ERR_ACCESS, MPI_ERR_AMODE, &
        MPI_ERR_ASSERT, MPI_ERR_BAD_FILE, MPI_ERR_BASE, &
        MPI_ERR_CONVERSION, MPI_ERR_DISP, MPI_ERR_DUP_DATAREP, &
        MPI_ERR_FILE_EXISTS, MPI_ERR_FILE_IN_USE, MPI_ERR_FILE, &
        MPI_ERR_INFO_KEY, MPI_ERR_INFO_NOKEY, MPI_ERR_INFO_VALUE, &
        MPI_ERR_INFO, MPI_ERR_IO, MPI_ERR_KEYVAL, MPI_ERR_LOCKTYPE, &
        MPI_ERR_NAME, MPI_ERR_NO_MEM, MPI_ERR_NOT_SAME, &
        MPI_ERR_NO_SPACE, MPI_ERR_NO_SUCH_FILE, MPI_ERR_PORT, &
        MPI_ERR_QUOTA, MPI_ERR_READ_ONLY, MPI_ERR_RMA_ATTACH, &
        MPI_ERR_RMA_CONFLICT, MPI_ERR_RMA_RANGE, MPI_ERR_RMA_SHARED, &
        MPI_ERR_RMA_SYNC, MPI_ERR_RMA_FLAVOR, MPI_ERR_SERVICE, &
        MPI_ERR_SIZE, MPI_ERR_SPAWN, MPI_ERR_UNSUPPORTED_DATAREP, &
        MPI_ERR_UNSUPPORTED_OPERATION, MPI_ERR_WIN ]
    integer, parameter :: tool_errors(*) = [ &
        MPI_T_ERR_CANNOT_INIT, MPI_T_ERR_NOT_INITIALIZED, &
        MPI_T_ERR_MEMORY, MPI_T_ERR_INVALID, MPI_T_ERR_INVALID_INDEX, &
        MPI_T_ERR_INVALID_ITEM, MPI_T_ERR_INVALID_SESSION, &
        MPI_T_ERR_INVALID_HANDLE, MPI_T_ERR_INVALID_NAME, &
        MPI_T_ERR_OUT_OF_HANDLES, MPI_T_ERR_OUT_OF_SESSIONS, &
        MPI_T_ERR_CVAR_SET_NOT_NOW, MPI_T_ERR_CVAR_SET_NEVER, &
        MPI_T_ERR_PVAR_NO_WRITE, MPI_T_ERR_PVAR_NO_STARTSTOP, &
        MPI_T_ERR_PVAR_NO_ATOMIC ]

    integer :: ierr, rank, i

    call MPI_Init(ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Init")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_rank")
    call MPI_Comm_set_errhandler(MPI_COMM_SELF, MPI_ERRORS_RETURN, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_set_errhandler self")

    do i = 1, size(base_errors)
        call exercise_error_class(base_errors(i))
    end do

    do i = 1, size(tool_errors)
        call exercise_error_string(tool_errors(i))
    end do

    call exercise_custom_error()

    if (rank == 0) print *, "Test passed"
    call MPI_Finalize(ierr)

contains

    subroutine require(ok, label)
        logical, intent(in) :: ok
        character(len=*), intent(in) :: label

        if (.not. ok) then
            print *, "FAIL:", trim(label), "rank", rank, "ierr", ierr
            call MPI_Abort(MPI_COMM_WORLD, 1, ierr)
        end if
    end subroutine require

    subroutine exercise_error_class(errorcode)
        integer, intent(in) :: errorcode
        integer :: errorclass

        call MPI_Error_class(errorcode, errorclass, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Error_class")
        call require(errorclass == errorcode, "MPI_Error_class payload")
        call exercise_error_string(errorcode)
    end subroutine exercise_error_class

    subroutine exercise_error_string(errorcode)
        integer, intent(in) :: errorcode
        character(len=MPI_MAX_ERROR_STRING) :: message
        integer :: resultlen

        message = ""
        resultlen = -1
        call MPI_Error_string(errorcode, message, resultlen, ierr)
        call require(ierr == MPI_SUCCESS .or. ierr == MPI_ERR_ARG, &
                     "MPI_Error_string")
        if (ierr == MPI_SUCCESS) then
            call require(resultlen >= 0, "MPI_Error_string resultlen")
        end if
    end subroutine exercise_error_string

    subroutine exercise_custom_error()
        integer :: errorclass, errorcode, mapped_class
        character(len=MPI_MAX_ERROR_STRING) :: message
        integer :: resultlen

        call MPI_Add_error_class(errorclass, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Add_error_class")
        call MPI_Add_error_code(errorclass, errorcode, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Add_error_code")
        call MPI_Add_error_string(errorcode, "vapaa custom error", ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Add_error_string")

        call MPI_Error_class(errorcode, mapped_class, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Error_class custom")
        call require(mapped_class == errorclass, "custom error class")
        call MPI_Error_string(errorcode, message, resultlen, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Error_string custom")
        call require(resultlen > 0, "custom error string")

        call MPI_Remove_error_string(errorcode, ierr)
        call require(ierr == MPI_SUCCESS .or. &
                     ierr == MPI_ERR_UNSUPPORTED_OPERATION, &
                     "MPI_Remove_error_string")
        call MPI_Remove_error_code(errorcode, ierr)
        call require(ierr == MPI_SUCCESS .or. &
                     ierr == MPI_ERR_UNSUPPORTED_OPERATION, &
                     "MPI_Remove_error_code")
        call MPI_Remove_error_class(errorclass, ierr)
        call require(ierr == MPI_SUCCESS .or. &
                     ierr == MPI_ERR_UNSUPPORTED_OPERATION, &
                     "MPI_Remove_error_class")
    end subroutine exercise_custom_error

end program test_error_api_coverage
