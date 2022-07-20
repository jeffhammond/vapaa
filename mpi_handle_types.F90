module mpi_handle_types
    use iso_c_binding, only: c_int
    implicit none

    type, bind(C) :: MPI_Comm
      ! this is supposed to be a Fortran integer
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Comm

end module mpi_handle_types
