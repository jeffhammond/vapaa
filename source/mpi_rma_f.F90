module mpi_rma_f
    use iso_c_binding, only: c_int
    implicit none

    ! RMA mode constants
    integer, parameter :: MPI_MODE_NOCHECK          =   1
    integer, parameter :: MPI_MODE_NOPRECEDE        =   2
    integer, parameter :: MPI_MODE_NOPUT            =   4
    integer, parameter :: MPI_MODE_NOSTORE          =   8
    integer, parameter :: MPI_MODE_NOSUCCEED        =  16

    contains

end module mpi_rma_f
