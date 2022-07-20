module mpi_global_constants
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
end module mpi_global_constants
