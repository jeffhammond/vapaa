module mpi_global_constants
    use mpi_handle_types, only: MPI_Comm
    type(MPI_Comm) :: MPI_COMM_WORLD
    type(MPI_Comm) :: MPI_COMM_SELF
    type(MPI_Comm) :: MPI_COMM_NULL
end module mpi_global_constants
