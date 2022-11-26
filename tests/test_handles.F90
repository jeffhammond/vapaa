program test_handles
    use mpi_f08
    implicit none
    type(MPI_Comm) :: world = MPI_COMM_WORLD
    type(MPI_Comm) :: self  = MPI_COMM_SELF
    type(MPI_Comm) :: cnull = MPI_COMM_NULL
    type(MPI_Datatype) :: d = MPI_DATATYPE_NULL
    type(MPI_File)     :: f = MPI_FILE_NULL    
    type(MPI_Group)    :: g = MPI_GROUP_NULL   
    type(MPI_Info)     :: i = MPI_INFO_NULL    
    type(MPI_Message)  :: m = MPI_MESSAGE_NULL 
    type(MPI_Op)       :: o = MPI_OP_NULL      
    type(MPI_Request)  :: r = MPI_REQUEST_NULL 
    type(MPI_Win)      :: w = MPI_WIN_NULL     
    integer :: ierror
    call MPI_Init(ierror)
    call MPI_Barrier(world)
    call MPI_Finalize(ierror)
end program test_handles
