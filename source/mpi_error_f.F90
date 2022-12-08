module mpi_error_f
    implicit none

    ! error codes
    integer, parameter :: MPI_SUCCESS                                =  0
    integer, parameter :: MPI_ERR_BUFFER                             =  1
    integer, parameter :: MPI_ERR_COUNT                              =  2
    integer, parameter :: MPI_ERR_TYPE                               =  3
    integer, parameter :: MPI_ERR_TAG                                =  4
    integer, parameter :: MPI_ERR_COMM                               =  5
    integer, parameter :: MPI_ERR_RANK                               =  6
    integer, parameter :: MPI_ERR_REQUEST                            =  7
    integer, parameter :: MPI_ERR_ROOT                               =  8
    integer, parameter :: MPI_ERR_GROUP                              =  9
    integer, parameter :: MPI_ERR_OP                                 = 10
    integer, parameter :: MPI_ERR_TOPOLOGY                           = 11
    integer, parameter :: MPI_ERR_DIMS                               = 12
    integer, parameter :: MPI_ERR_ARG                                = 13
    integer, parameter :: MPI_ERR_UNKNOWN                            = 14
    integer, parameter :: MPI_ERR_TRUNCATE                           = 15
    integer, parameter :: MPI_ERR_OTHER                              = 16
    integer, parameter :: MPI_ERR_INTERN                             = 17
    integer, parameter :: MPI_ERR_PENDING                            = 18
    integer, parameter :: MPI_ERR_IN_STATUS                          = 19
    integer, parameter :: MPI_ERR_ACCESS                             = 20
    integer, parameter :: MPI_ERR_AMODE                              = 21
    integer, parameter :: MPI_ERR_ASSERT                             = 22
    integer, parameter :: MPI_ERR_BAD_FILE                           = 23
    integer, parameter :: MPI_ERR_BASE                               = 24
    integer, parameter :: MPI_ERR_CONVERSION                         = 25
    integer, parameter :: MPI_ERR_DISP                               = 26
    integer, parameter :: MPI_ERR_DUP_DATAREP                        = 27
    integer, parameter :: MPI_ERR_FILE_EXISTS                        = 28
    integer, parameter :: MPI_ERR_FILE_IN_USE                        = 29
    integer, parameter :: MPI_ERR_FILE                               = 30
    integer, parameter :: MPI_ERR_INFO_KEY                           = 31
    integer, parameter :: MPI_ERR_INFO_NOKEY                         = 32
    integer, parameter :: MPI_ERR_INFO_VALUE                         = 33
    integer, parameter :: MPI_ERR_INFO                               = 34
    integer, parameter :: MPI_ERR_IO                                 = 35
    integer, parameter :: MPI_ERR_KEYVAL                             = 36
    integer, parameter :: MPI_ERR_LOCKTYPE                           = 37
    integer, parameter :: MPI_ERR_NAME                               = 38
    integer, parameter :: MPI_ERR_NO_MEM                             = 39
    integer, parameter :: MPI_ERR_NOT_SAME                           = 40
    integer, parameter :: MPI_ERR_NO_SPACE                           = 41
    integer, parameter :: MPI_ERR_NO_SUCH_FILE                       = 42
    integer, parameter :: MPI_ERR_PORT                               = 43
    integer, parameter :: MPI_ERR_PROC_ABORTED                       = 44
    integer, parameter :: MPI_ERR_QUOTA                              = 45
    integer, parameter :: MPI_ERR_READ_ONLY                          = 46
    integer, parameter :: MPI_ERR_RMA_ATTACH                         = 47
    integer, parameter :: MPI_ERR_RMA_CONFLICT                       = 48
    integer, parameter :: MPI_ERR_RMA_RANGE                          = 49
    integer, parameter :: MPI_ERR_RMA_SHARED                         = 50
    integer, parameter :: MPI_ERR_RMA_SYNC                           = 51
    integer, parameter :: MPI_ERR_RMA_FLAVOR                         = 52
    integer, parameter :: MPI_ERR_SERVICE                            = 53
    integer, parameter :: MPI_ERR_SESSION                            = 54
    integer, parameter :: MPI_ERR_SIZE                               = 55
    integer, parameter :: MPI_ERR_SPAWN                              = 56
    integer, parameter :: MPI_ERR_UNSUPPORTED_DATAREP                = 57
    integer, parameter :: MPI_ERR_UNSUPPORTED_OPERATION              = 58
    integer, parameter :: MPI_ERR_VALUE_TOO_LARGE                    = 59
    integer, parameter :: MPI_ERR_WIN                                = 60
    integer, parameter :: MPI_T_ERR_CANNOT_INIT                      = 61
    integer, parameter :: MPI_T_ERR_NOT_ACCESSIBLE                   = 62
    integer, parameter :: MPI_T_ERR_NOT_INITIALIZED                  = 63
    integer, parameter :: MPI_T_ERR_NOT_SUPPORTED                    = 64
    integer, parameter :: MPI_T_ERR_MEMORY                           = 65
    integer, parameter :: MPI_T_ERR_INVALID                          = 66
    integer, parameter :: MPI_T_ERR_INVALID_INDEX                    = 67
    integer, parameter :: MPI_T_ERR_INVALID_ITEM                     = 68
    integer, parameter :: MPI_T_ERR_INVALID_SESSION                  = 69
    integer, parameter :: MPI_T_ERR_INVALID_HANDLE                   = 70
    integer, parameter :: MPI_T_ERR_INVALID_NAME                     = 71
    integer, parameter :: MPI_T_ERR_OUT_OF_HANDLES                   = 72
    integer, parameter :: MPI_T_ERR_OUT_OF_SESSIONS                  = 73
    integer, parameter :: MPI_T_ERR_CVAR_SET_NOT_NOW                 = 74
    integer, parameter :: MPI_T_ERR_CVAR_SET_NEVER                   = 75
    integer, parameter :: MPI_T_ERR_PVAR_NO_WRITE                    = 76
    integer, parameter :: MPI_T_ERR_PVAR_NO_STARTSTOP                = 77
    integer, parameter :: MPI_T_ERR_PVAR_NO_ATOMIC                   = 78
    integer, parameter :: MPI_ERR_LASTCODE                           = 79

    interface MPI_Error_string
        module procedure MPI_Error_string_f08
    end interface MPI_Error_string

    interface MPI_Error_class
        module procedure MPI_Error_class_f08
    end interface MPI_Error_class

    contains

        subroutine MPI_Error_string_f08(errorcode, string, resultlen, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_global_constants, only: MPI_MAX_ERROR_STRING
            use mpi_error_c, only: CFI_MPI_Error_string
            integer, intent(in) :: errorcode
            character(len=MPI_MAX_ERROR_STRING), intent(out) :: string
            integer, intent(out) :: resultlen
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorcode_c, resultlen_c, ierror_c
            character(c_char), dimension(:), allocatable :: string_c
            integer :: i
            errorcode_c = errorcode
            allocate( string_c(MPI_MAX_ERROR_STRING) )
            string_c = c_null_char
            call CFI_MPI_Error_string(errorcode_c, string_c, resultlen_c, ierror_c)
            resultlen = resultlen_c
            string = c_null_char
            do i = 1, min(resultlen+1,MPI_MAX_ERROR_STRING)
              string(i:i) = string_c(i)
            end do
            deallocate( string_c )
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Error_string_f08

        subroutine MPI_Error_class_f08(errorcode, errorclass, ierror)
            use iso_c_binding, only: c_int
            use mpi_error_c, only: C_MPI_Error_class
            integer, intent(in) :: errorcode
            integer, intent(out) :: errorclass
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorcode_c, errorclass_c, ierror_c
            errorcode_c = errorcode
            call C_MPI_Error_class(errorcode_c, errorclass_c, ierror_c)
            errorclass = errorclass_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Error_class_f08

end module mpi_error_f
