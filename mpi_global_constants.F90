module mpi_global_constants
    use iso_c_binding, only: c_int, c_size_t, c_intptr_t
    use mpi_handle_types

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
    ! but if we do not support them and force the user to query using
    ! the library call, they will get the right answer.
    !integer, parameter :: MPI_VERSION    = 3
    !integer, parameter :: MPI_SUBVERSION = 1

    ! make this unusable, to force use of type(MPI_Status)
    integer, parameter :: MPI_STATUS_SIZE = -1

    ! these are natural, but may not strictly match the MPI implementation
    integer, parameter :: MPI_ADDRESS_KIND = c_intptr_t
    integer, parameter :: MPI_COUNT_KIND   = c_size_t
    integer, parameter :: MPI_INTEGER_KIND = c_int
    integer, parameter :: MPI_OFFSET_KIND  = c_intptr_t ! c_ptrdiff_t

    ! this requires work...
    logical, parameter :: MPI_SUBARRAYS_SUPPORTED        = .false.

    ! i do not know a compiler that does not support this...
    logical, parameter :: MPI_ASYNC_PROTECTS_NONBLOCKING = .true.

end module mpi_global_constants
