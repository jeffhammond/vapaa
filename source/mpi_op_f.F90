module mpi_op_f
    use iso_c_binding, only: c_int
    use mpi_handle_types, only: MPI_Op
    implicit none

    ! built-in ops
    type(MPI_Op), parameter :: MPI_MAX      = MPI_Op(MPI_VAL = -10001)
    type(MPI_Op), parameter :: MPI_MIN      = MPI_Op(MPI_VAL = -10002)
    type(MPI_Op), parameter :: MPI_SUM      = MPI_Op(MPI_VAL = -10003)
    type(MPI_Op), parameter :: MPI_PROD     = MPI_Op(MPI_VAL = -10004)
    type(MPI_Op), parameter :: MPI_MAXLOC   = MPI_Op(MPI_VAL = -10005)
    type(MPI_Op), parameter :: MPI_MINLOC   = MPI_Op(MPI_VAL = -10006)
    type(MPI_Op), parameter :: MPI_BAND     = MPI_Op(MPI_VAL = -10007)
    type(MPI_Op), parameter :: MPI_BOR      = MPI_Op(MPI_VAL = -10008)
    type(MPI_Op), parameter :: MPI_BXOR     = MPI_Op(MPI_VAL = -10009)
    type(MPI_Op), parameter :: MPI_LAND     = MPI_Op(MPI_VAL = -10010)
    type(MPI_Op), parameter :: MPI_LOR      = MPI_Op(MPI_VAL = -10011)
    type(MPI_Op), parameter :: MPI_LXOR     = MPI_Op(MPI_VAL = -10012)
    type(MPI_Op), parameter :: MPI_REPLACE  = MPI_Op(MPI_VAL = -10013)
    type(MPI_Op), parameter :: MPI_NO_OP    = MPI_Op(MPI_VAL = -10014)

    contains

end module mpi_op_f
