module mpi_op_f
    use iso_c_binding, only: c_int
    use mpi_handle_types, only: MPI_Op
    implicit none

    ! built-in ops
    type(MPI_Op) :: MPI_MAX
    type(MPI_Op) :: MPI_MIN
    type(MPI_Op) :: MPI_SUM
    type(MPI_Op) :: MPI_PROD
    type(MPI_Op) :: MPI_MAXLOC
    type(MPI_Op) :: MPI_MINLOC
    type(MPI_Op) :: MPI_BAND
    type(MPI_Op) :: MPI_BOR
    type(MPI_Op) :: MPI_BXOR
    type(MPI_Op) :: MPI_LAND
    type(MPI_Op) :: MPI_LOR
    type(MPI_Op) :: MPI_LXOR
    type(MPI_Op) :: MPI_REPLACE
    type(MPI_Op) :: MPI_NO_OP

    contains
        subroutine F_MPI_Init_ops()
            use mpi_op_c
            integer(kind=c_int) :: MAX_c, MIN_c
            integer(kind=c_int) :: SUM_c, PROD_c
            integer(kind=c_int) :: MAXLOC_c, MINLOC_c
            integer(kind=c_int) :: BAND_c, BOR_c, BXOR_c
            integer(kind=c_int) :: LAND_c, LOR_c, LXOR_c
            integer(kind=c_int) :: REPLACE_c, NO_OP_c
            call C_MPI_OP_BUILTINS( MAX_c, MIN_c, &
                                    SUM_c, PROD_c, &
                                    MAXLOC_c, MINLOC_c, &
                                    BAND_c, BOR_c, BXOR_c, &
                                    LAND_c, LOR_c, LXOR_c, &
                                    REPLACE_c, NO_OP_c)
            MPI_MAX     % MPI_VAL = MAX_c
            MPI_MIN     % MPI_VAL = MIN_c
            MPI_SUM     % MPI_VAL = SUM_c
            MPI_PROD    % MPI_VAL = PROD_c
            MPI_MAXLOC  % MPI_VAL = MAXLOC_c
            MPI_MINLOC  % MPI_VAL = MINLOC_c
            MPI_BAND    % MPI_VAL = BAND_c
            MPI_BOR     % MPI_VAL = BOR_c
            MPI_BXOR    % MPI_VAL = BXOR_c
            MPI_LAND    % MPI_VAL = LAND_c
            MPI_LOR     % MPI_VAL = LOR_c
            MPI_LXOR    % MPI_VAL = LXOR_c
            MPI_REPLACE % MPI_VAL = REPLACE_c
            MPI_NO_OP   % MPI_VAL = NO_OP_c
        end subroutine F_MPI_Init_ops

end module mpi_op_f
