! SPDX-License-Identifier: MIT

#include "vapaa_constants.h"

module mpi_error_f
    implicit none

    ! error codes
    integer, parameter :: MPI_SUCCESS                                = VAPAA_MPI_SUCCESS
    integer, parameter :: MPI_ERR_BUFFER                             = VAPAA_MPI_ERR_BUFFER
    integer, parameter :: MPI_ERR_COUNT                              = VAPAA_MPI_ERR_COUNT
    integer, parameter :: MPI_ERR_TYPE                               = VAPAA_MPI_ERR_TYPE
    integer, parameter :: MPI_ERR_TAG                                = VAPAA_MPI_ERR_TAG
    integer, parameter :: MPI_ERR_COMM                               = VAPAA_MPI_ERR_COMM
    integer, parameter :: MPI_ERR_RANK                               = VAPAA_MPI_ERR_RANK
    integer, parameter :: MPI_ERR_REQUEST                            = VAPAA_MPI_ERR_REQUEST
    integer, parameter :: MPI_ERR_ROOT                               = VAPAA_MPI_ERR_ROOT
    integer, parameter :: MPI_ERR_GROUP                              = VAPAA_MPI_ERR_GROUP
    integer, parameter :: MPI_ERR_OP                                 = VAPAA_MPI_ERR_OP
    integer, parameter :: MPI_ERR_TOPOLOGY                           = VAPAA_MPI_ERR_TOPOLOGY
    integer, parameter :: MPI_ERR_DIMS                               = VAPAA_MPI_ERR_DIMS
    integer, parameter :: MPI_ERR_ARG                                = VAPAA_MPI_ERR_ARG
    integer, parameter :: MPI_ERR_UNKNOWN                            = VAPAA_MPI_ERR_UNKNOWN
    integer, parameter :: MPI_ERR_TRUNCATE                           = VAPAA_MPI_ERR_TRUNCATE
    integer, parameter :: MPI_ERR_OTHER                              = VAPAA_MPI_ERR_OTHER
    integer, parameter :: MPI_ERR_INTERN                             = VAPAA_MPI_ERR_INTERN
    integer, parameter :: MPI_ERR_PENDING                            = VAPAA_MPI_ERR_PENDING
    integer, parameter :: MPI_ERR_IN_STATUS                          = VAPAA_MPI_ERR_IN_STATUS
    integer, parameter :: MPI_ERR_ACCESS                             = VAPAA_MPI_ERR_ACCESS
    integer, parameter :: MPI_ERR_AMODE                              = VAPAA_MPI_ERR_AMODE
    integer, parameter :: MPI_ERR_ASSERT                             = VAPAA_MPI_ERR_ASSERT
    integer, parameter :: MPI_ERR_BAD_FILE                           = VAPAA_MPI_ERR_BAD_FILE
    integer, parameter :: MPI_ERR_BASE                               = VAPAA_MPI_ERR_BASE
    integer, parameter :: MPI_ERR_CONVERSION                         = VAPAA_MPI_ERR_CONVERSION
    integer, parameter :: MPI_ERR_DISP                               = VAPAA_MPI_ERR_DISP
    integer, parameter :: MPI_ERR_DUP_DATAREP                        = VAPAA_MPI_ERR_DUP_DATAREP
    integer, parameter :: MPI_ERR_FILE_EXISTS                        = VAPAA_MPI_ERR_FILE_EXISTS
    integer, parameter :: MPI_ERR_FILE_IN_USE                        = VAPAA_MPI_ERR_FILE_IN_USE
    integer, parameter :: MPI_ERR_FILE                               = VAPAA_MPI_ERR_FILE
    integer, parameter :: MPI_ERR_INFO_KEY                           = VAPAA_MPI_ERR_INFO_KEY
    integer, parameter :: MPI_ERR_INFO_NOKEY                         = VAPAA_MPI_ERR_INFO_NOKEY
    integer, parameter :: MPI_ERR_INFO_VALUE                         = VAPAA_MPI_ERR_INFO_VALUE
    integer, parameter :: MPI_ERR_INFO                               = VAPAA_MPI_ERR_INFO
    integer, parameter :: MPI_ERR_IO                                 = VAPAA_MPI_ERR_IO
    integer, parameter :: MPI_ERR_KEYVAL                             = VAPAA_MPI_ERR_KEYVAL
    integer, parameter :: MPI_ERR_LOCKTYPE                           = VAPAA_MPI_ERR_LOCKTYPE
    integer, parameter :: MPI_ERR_NAME                               = VAPAA_MPI_ERR_NAME
    integer, parameter :: MPI_ERR_NO_MEM                             = VAPAA_MPI_ERR_NO_MEM
    integer, parameter :: MPI_ERR_NOT_SAME                           = VAPAA_MPI_ERR_NOT_SAME
    integer, parameter :: MPI_ERR_NO_SPACE                           = VAPAA_MPI_ERR_NO_SPACE
    integer, parameter :: MPI_ERR_NO_SUCH_FILE                       = VAPAA_MPI_ERR_NO_SUCH_FILE
    integer, parameter :: MPI_ERR_PORT                               = VAPAA_MPI_ERR_PORT
    integer, parameter :: MPI_ERR_PROC_ABORTED                       = VAPAA_MPI_ERR_PROC_ABORTED
    integer, parameter :: MPI_ERR_QUOTA                              = VAPAA_MPI_ERR_QUOTA
    integer, parameter :: MPI_ERR_READ_ONLY                          = VAPAA_MPI_ERR_READ_ONLY
    integer, parameter :: MPI_ERR_RMA_ATTACH                         = VAPAA_MPI_ERR_RMA_ATTACH
    integer, parameter :: MPI_ERR_RMA_CONFLICT                       = VAPAA_MPI_ERR_RMA_CONFLICT
    integer, parameter :: MPI_ERR_RMA_RANGE                          = VAPAA_MPI_ERR_RMA_RANGE
    integer, parameter :: MPI_ERR_RMA_SHARED                         = VAPAA_MPI_ERR_RMA_SHARED
    integer, parameter :: MPI_ERR_RMA_SYNC                           = VAPAA_MPI_ERR_RMA_SYNC
    integer, parameter :: MPI_ERR_RMA_FLAVOR                         = VAPAA_MPI_ERR_RMA_FLAVOR
    integer, parameter :: MPI_ERR_SERVICE                            = VAPAA_MPI_ERR_SERVICE
    integer, parameter :: MPI_ERR_SESSION                            = VAPAA_MPI_ERR_SESSION
    integer, parameter :: MPI_ERR_ERRHANDLER                         = VAPAA_MPI_ERR_ERRHANDLER
    integer, parameter :: MPI_ERR_ABI                                = VAPAA_MPI_ERR_ABI
    integer, parameter :: MPI_ERR_SIZE                               = VAPAA_MPI_ERR_SIZE
    integer, parameter :: MPI_ERR_SPAWN                              = VAPAA_MPI_ERR_SPAWN
    integer, parameter :: MPI_ERR_UNSUPPORTED_DATAREP                = VAPAA_MPI_ERR_UNSUPPORTED_DATAREP
    integer, parameter :: MPI_ERR_UNSUPPORTED_OPERATION              = VAPAA_MPI_ERR_UNSUPPORTED_OPERATION
    integer, parameter :: MPI_ERR_VALUE_TOO_LARGE                    = VAPAA_MPI_ERR_VALUE_TOO_LARGE
    integer, parameter :: MPI_ERR_WIN                                = VAPAA_MPI_ERR_WIN
    integer, parameter :: MPI_T_ERR_CANNOT_INIT                      = VAPAA_MPI_T_ERR_CANNOT_INIT
    integer, parameter :: MPI_T_ERR_NOT_ACCESSIBLE                   = VAPAA_MPI_T_ERR_NOT_ACCESSIBLE
    integer, parameter :: MPI_T_ERR_NOT_INITIALIZED                  = VAPAA_MPI_T_ERR_NOT_INITIALIZED
    integer, parameter :: MPI_T_ERR_NOT_SUPPORTED                    = VAPAA_MPI_T_ERR_NOT_SUPPORTED
    integer, parameter :: MPI_T_ERR_MEMORY                           = VAPAA_MPI_T_ERR_MEMORY
    integer, parameter :: MPI_T_ERR_INVALID                          = VAPAA_MPI_T_ERR_INVALID
    integer, parameter :: MPI_T_ERR_INVALID_INDEX                    = VAPAA_MPI_T_ERR_INVALID_INDEX
    integer, parameter :: MPI_T_ERR_INVALID_ITEM                     = VAPAA_MPI_T_ERR_INVALID_ITEM
    integer, parameter :: MPI_T_ERR_INVALID_SESSION                  = VAPAA_MPI_T_ERR_INVALID_SESSION
    integer, parameter :: MPI_T_ERR_INVALID_HANDLE                   = VAPAA_MPI_T_ERR_INVALID_HANDLE
    integer, parameter :: MPI_T_ERR_INVALID_NAME                     = VAPAA_MPI_T_ERR_INVALID_NAME
    integer, parameter :: MPI_T_ERR_OUT_OF_HANDLES                   = VAPAA_MPI_T_ERR_OUT_OF_HANDLES
    integer, parameter :: MPI_T_ERR_OUT_OF_SESSIONS                  = VAPAA_MPI_T_ERR_OUT_OF_SESSIONS
    integer, parameter :: MPI_T_ERR_CVAR_SET_NOT_NOW                 = VAPAA_MPI_T_ERR_CVAR_SET_NOT_NOW
    integer, parameter :: MPI_T_ERR_CVAR_SET_NEVER                   = VAPAA_MPI_T_ERR_CVAR_SET_NEVER
    integer, parameter :: MPI_T_ERR_PVAR_NO_WRITE                    = VAPAA_MPI_T_ERR_PVAR_NO_WRITE
    integer, parameter :: MPI_T_ERR_PVAR_NO_STARTSTOP                = VAPAA_MPI_T_ERR_PVAR_NO_STARTSTOP
    integer, parameter :: MPI_T_ERR_PVAR_NO_ATOMIC                   = VAPAA_MPI_T_ERR_PVAR_NO_ATOMIC
    integer, parameter :: MPI_ERR_LASTCODE                           = VAPAA_MPI_ERR_LASTCODE

    interface MPI_Error_string
#if HAVE_CFI
        module procedure MPI_Error_string_f08ts
#else
        module procedure MPI_Error_string_f08
#endif
    end interface MPI_Error_string

    interface MPI_Error_class
        module procedure MPI_Error_class_f08
    end interface MPI_Error_class

    interface MPI_Add_error_class
        module procedure MPI_Add_error_class_f08
    end interface MPI_Add_error_class

    interface MPI_Add_error_code
        module procedure MPI_Add_error_code_f08
    end interface MPI_Add_error_code

    interface MPI_Add_error_string
        module procedure MPI_Add_error_string_f08
    end interface MPI_Add_error_string

    interface MPI_Remove_error_class
        module procedure MPI_Remove_error_class_f08
    end interface MPI_Remove_error_class

    interface MPI_Remove_error_code
        module procedure MPI_Remove_error_code_f08
    end interface MPI_Remove_error_code

    interface MPI_Remove_error_string
        module procedure MPI_Remove_error_string_f08
    end interface MPI_Remove_error_string

    interface MPI_Errhandler_free
        module procedure MPI_Errhandler_free_f08
    end interface MPI_Errhandler_free

    interface MPI_Comm_call_errhandler
        module procedure MPI_Comm_call_errhandler_f08
    end interface MPI_Comm_call_errhandler

    interface MPI_Comm_get_errhandler
        module procedure MPI_Comm_get_errhandler_f08
    end interface MPI_Comm_get_errhandler

    interface MPI_Comm_set_errhandler
        module procedure MPI_Comm_set_errhandler_f08
    end interface MPI_Comm_set_errhandler

    interface MPI_File_call_errhandler
        module procedure MPI_File_call_errhandler_f08
    end interface MPI_File_call_errhandler

    interface MPI_File_get_errhandler
        module procedure MPI_File_get_errhandler_f08
    end interface MPI_File_get_errhandler

    interface MPI_File_set_errhandler
        module procedure MPI_File_set_errhandler_f08
    end interface MPI_File_set_errhandler

    interface MPI_Win_call_errhandler
        module procedure MPI_Win_call_errhandler_f08
    end interface MPI_Win_call_errhandler

    interface MPI_Win_get_errhandler
        module procedure MPI_Win_get_errhandler_f08
    end interface MPI_Win_get_errhandler

    interface MPI_Win_set_errhandler
        module procedure MPI_Win_set_errhandler_f08
    end interface MPI_Win_set_errhandler

    interface MPI_Session_call_errhandler
        module procedure MPI_Session_call_errhandler_f08
    end interface MPI_Session_call_errhandler

    interface MPI_Session_get_errhandler
        module procedure MPI_Session_get_errhandler_f08
    end interface MPI_Session_get_errhandler

    interface MPI_Session_set_errhandler
        module procedure MPI_Session_set_errhandler_f08
    end interface MPI_Session_set_errhandler

    contains

        subroutine MPI_Error_string_f08(errorcode, string, resultlen, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_global_constants, only: MPI_MAX_ERROR_STRING
            use mpi_error_c, only: C_MPI_Error_string
            integer, intent(in) :: errorcode
            character(len=MPI_MAX_ERROR_STRING), intent(out) :: string
            integer, intent(out) :: resultlen
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorcode_c, resultlen_c, ierror_c
            errorcode_c = errorcode
            call C_MPI_Error_string(errorcode_c, string, resultlen_c, ierror_c)
            resultlen = resultlen_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Error_string_f08

#ifdef HAVE_CFI
        subroutine MPI_Error_string_f08ts(errorcode, string, resultlen, ierror)
            use iso_c_binding, only: c_int, c_char
            use mpi_global_constants, only: MPI_MAX_ERROR_STRING
            use mpi_error_c, only: CFI_MPI_Error_string
            integer, intent(in) :: errorcode
            character(len=MPI_MAX_ERROR_STRING), intent(out) :: string
            integer, intent(out) :: resultlen
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorcode_c, resultlen_c, ierror_c
            errorcode_c = errorcode
            call CFI_MPI_Error_string(errorcode_c, string, resultlen_c, ierror_c)
            resultlen = resultlen_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Error_string_f08ts
#endif

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

        subroutine MPI_Add_error_class_f08(errorclass, ierror)
            use iso_c_binding, only: c_int
            use mpi_error_c, only: C_MPI_Add_error_class
            integer, intent(out) :: errorclass
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorclass_c, ierror_c
            call C_MPI_Add_error_class(errorclass_c, ierror_c)
            errorclass = errorclass_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Add_error_class_f08

        subroutine MPI_Add_error_code_f08(errorclass, errorcode, ierror)
            use iso_c_binding, only: c_int
            use mpi_error_c, only: C_MPI_Add_error_code
            integer, intent(in) :: errorclass
            integer, intent(out) :: errorcode
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorclass_c, errorcode_c, ierror_c
            errorclass_c = errorclass
            call C_MPI_Add_error_code(errorclass_c, errorcode_c, ierror_c)
            errorcode = errorcode_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Add_error_code_f08

        subroutine MPI_Add_error_string_f08(errorcode, string, ierror)
            use iso_c_binding, only: c_int, c_char, c_null_char
            use mpi_error_c, only: C_MPI_Add_error_string
            integer, intent(in) :: errorcode
            character(len=*), intent(in) :: string
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorcode_c, ierror_c
            integer :: i, ls
            character(kind=c_char), dimension(:), allocatable :: string_c
            ls = len(string)
            allocate(string_c(ls + 1))
            string_c = c_null_char
            do i = 1, ls
                string_c(i) = string(i:i)
            end do
            errorcode_c = errorcode
            call C_MPI_Add_error_string(errorcode_c, string_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
            deallocate(string_c)
        end subroutine MPI_Add_error_string_f08

        subroutine MPI_Remove_error_class_f08(errorclass, ierror)
            use iso_c_binding, only: c_int
            use mpi_error_c, only: C_MPI_Remove_error_class
            integer, intent(in) :: errorclass
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorclass_c, ierror_c
            errorclass_c = errorclass
            call C_MPI_Remove_error_class(errorclass_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Remove_error_class_f08

        subroutine MPI_Remove_error_code_f08(errorcode, ierror)
            use iso_c_binding, only: c_int
            use mpi_error_c, only: C_MPI_Remove_error_code
            integer, intent(in) :: errorcode
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorcode_c, ierror_c
            errorcode_c = errorcode
            call C_MPI_Remove_error_code(errorcode_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Remove_error_code_f08

        subroutine MPI_Remove_error_string_f08(errorcode, ierror)
            use iso_c_binding, only: c_int
            use mpi_error_c, only: C_MPI_Remove_error_string
            integer, intent(in) :: errorcode
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorcode_c, ierror_c
            errorcode_c = errorcode
            call C_MPI_Remove_error_string(errorcode_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Remove_error_string_f08

        subroutine MPI_Errhandler_free_f08(errhandler, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Errhandler
            use mpi_error_c, only: C_MPI_Errhandler_free
            type(MPI_Errhandler), intent(inout) :: errhandler
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_Errhandler_free(errhandler % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Errhandler_free_f08

        subroutine MPI_Comm_call_errhandler_f08(comm, errorcode, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Comm
            use mpi_error_c, only: C_MPI_Comm_call_errhandler
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: errorcode
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorcode_c, ierror_c
            errorcode_c = errorcode
            call C_MPI_Comm_call_errhandler(comm % MPI_VAL, errorcode_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_call_errhandler_f08

        subroutine MPI_Comm_get_errhandler_f08(comm, errhandler, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Comm, MPI_Errhandler
            use mpi_error_c, only: C_MPI_Comm_get_errhandler
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Errhandler), intent(out) :: errhandler
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_Comm_get_errhandler(comm % MPI_VAL, errhandler % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_get_errhandler_f08

        subroutine MPI_Comm_set_errhandler_f08(comm, errhandler, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Comm, MPI_Errhandler
            use mpi_error_c, only: C_MPI_Comm_set_errhandler
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Errhandler), intent(in) :: errhandler
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_Comm_set_errhandler(comm % MPI_VAL, errhandler % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_set_errhandler_f08

        subroutine MPI_File_call_errhandler_f08(file, errorcode, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_File
            use mpi_error_c, only: C_MPI_File_call_errhandler
            type(MPI_File), intent(in) :: file
            integer, intent(in) :: errorcode
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorcode_c, ierror_c
            errorcode_c = errorcode
            call C_MPI_File_call_errhandler(file % MPI_VAL, errorcode_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_call_errhandler_f08

        subroutine MPI_File_get_errhandler_f08(file, errhandler, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_File, MPI_Errhandler
            use mpi_error_c, only: C_MPI_File_get_errhandler
            type(MPI_File), intent(in) :: file
            type(MPI_Errhandler), intent(out) :: errhandler
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_File_get_errhandler(file % MPI_VAL, errhandler % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_get_errhandler_f08

        subroutine MPI_File_set_errhandler_f08(file, errhandler, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_File, MPI_Errhandler
            use mpi_error_c, only: C_MPI_File_set_errhandler
            type(MPI_File), intent(in) :: file
            type(MPI_Errhandler), intent(in) :: errhandler
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_File_set_errhandler(file % MPI_VAL, errhandler % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_File_set_errhandler_f08

        subroutine MPI_Win_call_errhandler_f08(win, errorcode, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Win
            use mpi_error_c, only: C_MPI_Win_call_errhandler
            type(MPI_Win), intent(in) :: win
            integer, intent(in) :: errorcode
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorcode_c, ierror_c
            errorcode_c = errorcode
            call C_MPI_Win_call_errhandler(win % MPI_VAL, errorcode_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_call_errhandler_f08

        subroutine MPI_Win_get_errhandler_f08(win, errhandler, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Win, MPI_Errhandler
            use mpi_error_c, only: C_MPI_Win_get_errhandler
            type(MPI_Win), intent(in) :: win
            type(MPI_Errhandler), intent(out) :: errhandler
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_Win_get_errhandler(win % MPI_VAL, errhandler % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_get_errhandler_f08

        subroutine MPI_Win_set_errhandler_f08(win, errhandler, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Win, MPI_Errhandler
            use mpi_error_c, only: C_MPI_Win_set_errhandler
            type(MPI_Win), intent(in) :: win
            type(MPI_Errhandler), intent(in) :: errhandler
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_Win_set_errhandler(win % MPI_VAL, errhandler % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_set_errhandler_f08

        subroutine MPI_Session_call_errhandler_f08(session, errorcode, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Session
            use mpi_error_c, only: C_MPI_Session_call_errhandler
            type(MPI_Session), intent(in) :: session
            integer, intent(in) :: errorcode
            integer, optional, intent(out) :: ierror
            integer(c_int) :: errorcode_c, ierror_c
            errorcode_c = errorcode
            call C_MPI_Session_call_errhandler(session % MPI_VAL, errorcode_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_call_errhandler_f08

        subroutine MPI_Session_get_errhandler_f08(session, errhandler, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Session, MPI_Errhandler
            use mpi_error_c, only: C_MPI_Session_get_errhandler
            type(MPI_Session), intent(in) :: session
            type(MPI_Errhandler), intent(out) :: errhandler
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_Session_get_errhandler(session % MPI_VAL, errhandler % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_get_errhandler_f08

        subroutine MPI_Session_set_errhandler_f08(session, errhandler, ierror)
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Session, MPI_Errhandler
            use mpi_error_c, only: C_MPI_Session_set_errhandler
            type(MPI_Session), intent(in) :: session
            type(MPI_Errhandler), intent(in) :: errhandler
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call C_MPI_Session_set_errhandler(session % MPI_VAL, errhandler % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_set_errhandler_f08

end module mpi_error_f
