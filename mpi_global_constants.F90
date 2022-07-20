module mpi_global_constants
    use mpi_handle_types, only: MPI_Comm
    type(MPI_Comm) :: MPI_COMM_WORLD
end module mpi_global_constants
