program main
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
    print*,self .eq.self ,self ==self ,self .ne.self ,self /=self
    print*,world.eq.self ,world==self ,world.ne.self ,world/=self
    print*,world.eq.world,world==world,world.ne.world,world/=world
    print*,world.eq.cnull,world==cnull,world.ne.cnull,world/=cnull
    call MPI_Barrier(world)
    print*,d.eq.MPI_DATATYPE_NULL,d==MPI_DATATYPE_NULL
    print*,d.ne.MPI_DATATYPE_NULL,d/=MPI_DATATYPE_NULL
    call MPI_Finalize(ierror)
end program main
