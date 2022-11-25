module mpi_global_constants
    use iso_c_binding, only: c_int, c_size_t, c_intptr_t
    use mpi_handle_types

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

    ! thread levels
    integer, parameter :: MPI_THREAD_SINGLE     = 0
    integer, parameter :: MPI_THREAD_FUNNELED   = 1
    integer, parameter :: MPI_THREAD_SERIALIZED = 2
    integer, parameter :: MPI_THREAD_MULTIPLE   = 3

    ! comparisons (communicators and groups)
    integer, parameter :: MPI_IDENT     = 0
    integer, parameter :: MPI_CONGRUENT = 1
    integer, parameter :: MPI_SIMILAR   = 2
    integer, parameter :: MPI_UNEQUAL   = 3

    ! useful handles
    type(MPI_Comm)     :: MPI_COMM_WORLD
    type(MPI_Comm)     :: MPI_COMM_SELF

    ! NULL handles
    type(MPI_Comm)     :: MPI_COMM_NULL
    type(MPI_Datatype) :: MPI_DATATYPE_NULL
    type(MPI_File)     :: MPI_FILE_NULL
    type(MPI_Group)    :: MPI_GROUP_NULL
    type(MPI_Info)     :: MPI_INFO_NULL
    type(MPI_Message)  :: MPI_MESSAGE_NULL
    type(MPI_Op)       :: MPI_OP_NULL
    type(MPI_Request)  :: MPI_REQUEST_NULL
    type(MPI_Win)      :: MPI_WIN_NULL

    ! Magic sentinels
    !  The constants that cannot be used in initialization expressions or assignments in Fortran are as follows:
    ! Buffer address sentinels
    integer :: MPI_BOTTOM          =  0
    integer :: MPI_IN_PLACE        =  1
    integer :: MPI_ARGV_NULL       =  0
    integer :: MPI_ARGVS_NULL      =  0
    integer :: MPI_ERRCODES_IGNORE = -1
    integer :: MPI_UNWEIGHTED      = -1
    integer :: MPI_WEIGHTS_EMPTY   =  0
    ! Note that in Fortran MPI_STATUS_IGNORE and MPI_STATUSES_IGNORE are objects like MPI_BOTTOM
    ! (not usable for initialization or assignment).
    ! MPI_STATUS_IGNORE and MPI_STATUSES_IGNORE are not required to have the same values in C and Fortran.
    type(MPI_Status) :: MPI_STATUS_IGNORE
    type(MPI_Status) :: MPI_STATUSES_IGNORE(1)

    ! 2.5.4 Named Constants
    ! The constants that are required to be compile-time constants
    ! (and can thus be used for array length declarations and labels 
    ! in C switch and Fortran case/select statements) are:

    ! use a ridiculously large value that will always be larger than
    ! what any implementation uses, to avoid having to query the
    ! underlying implementation
    integer, parameter :: MPI_MAX_PROCESSOR_NAME         = (1024*1024)
    integer, parameter :: MPI_MAX_LIBRARY_VERSION_STRING = (1024*1024)
    integer, parameter :: MPI_MAX_ERROR_STRING           = (1024*1024)
    integer, parameter :: MPI_MAX_DATAREP_STRING         = (1024*1024)
    integer, parameter :: MPI_MAX_INFO_KEY               = (1024*1024)
    integer, parameter :: MPI_MAX_INFO_VAL               = (1024*1024)
    integer, parameter :: MPI_MAX_OBJECT_NAME            = (1024*1024)
    integer, parameter :: MPI_MAX_PORT_NAME              = (1024*1024)

    ! these must be queried out of the implementation, unfortunately,
    ! but we can at least say this much, since MPI F08 was added
    ! in MPI 3.0
    integer, parameter :: MPI_VERSION    = 3
    integer, parameter :: MPI_SUBVERSION = 0

    ! make this unusable, to force use of type(MPI_Status)
    integer, parameter :: MPI_STATUS_SIZE = -1

    ! these are natural, but may not strictly match the MPI implementation
    integer, parameter :: MPI_ADDRESS_KIND = c_intptr_t
    integer, parameter :: MPI_COUNT_KIND   = c_size_t
    integer, parameter :: MPI_INTEGER_KIND = c_int
    integer, parameter :: MPI_OFFSET_KIND  = c_intptr_t ! c_ptrdiff_t

    ! this requires work...
    logical, parameter :: MPI_SUBARRAYS_SUPPORTED        = .false.
    ! i do not know a compiler that does not satisfy this...
    logical, parameter :: MPI_ASYNC_PROTECTS_NONBLOCKING = .true.

end module mpi_global_constants
