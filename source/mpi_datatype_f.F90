module mpi_datatype_f
    use iso_c_binding, only: c_int
    use mpi_global_constants, only: MPI_Datatype
    implicit none

    ! Fortran types come first
    type(MPI_Datatype), parameter :: MPI_CHARACTER              = MPI_Datatype(MPI_VAL = -1001)
    type(MPI_Datatype), parameter :: MPI_LOGICAL                = MPI_Datatype(MPI_VAL = -1002)
    type(MPI_Datatype), parameter :: MPI_INTEGER                = MPI_Datatype(MPI_VAL = -1003)
    type(MPI_Datatype), parameter :: MPI_REAL                   = MPI_Datatype(MPI_VAL = -1004)
    type(MPI_Datatype), parameter :: MPI_DOUBLE_PRECISION       = MPI_Datatype(MPI_VAL = -1005)
    type(MPI_Datatype), parameter :: MPI_COMPLEX                = MPI_Datatype(MPI_VAL = -1006)
    type(MPI_Datatype), parameter :: MPI_DOUBLE_COMPLEX         = MPI_Datatype(MPI_VAL = -1007)
    type(MPI_Datatype), parameter :: MPI_INTEGER1               = MPI_Datatype(MPI_VAL = -1008)
    type(MPI_Datatype), parameter :: MPI_INTEGER2               = MPI_Datatype(MPI_VAL = -1009)
    type(MPI_Datatype), parameter :: MPI_INTEGER4               = MPI_Datatype(MPI_VAL = -1010)
    type(MPI_Datatype), parameter :: MPI_INTEGER8               = MPI_Datatype(MPI_VAL = -1011)
    type(MPI_Datatype), parameter :: MPI_INTEGER16              = MPI_Datatype(MPI_VAL = -1012)
    type(MPI_Datatype), parameter :: MPI_REAL2                  = MPI_Datatype(MPI_VAL = -1013)
    type(MPI_Datatype), parameter :: MPI_REAL4                  = MPI_Datatype(MPI_VAL = -1014)
    type(MPI_Datatype), parameter :: MPI_REAL8                  = MPI_Datatype(MPI_VAL = -1015)
    type(MPI_Datatype), parameter :: MPI_REAL16                 = MPI_Datatype(MPI_VAL = -1016)
    type(MPI_Datatype), parameter :: MPI_COMPLEX4               = MPI_Datatype(MPI_VAL = -1017)
    type(MPI_Datatype), parameter :: MPI_COMPLEX8               = MPI_Datatype(MPI_VAL = -1018)
    type(MPI_Datatype), parameter :: MPI_COMPLEX16              = MPI_Datatype(MPI_VAL = -1019)
    type(MPI_Datatype), parameter :: MPI_COMPLEX32              = MPI_Datatype(MPI_VAL = -1020)

    ! these are language-agnostic
    type(MPI_Datatype), parameter :: MPI_AINT                        = MPI_Datatype(MPI_VAL = -2001)
    type(MPI_Datatype), parameter :: MPI_COUNT                       = MPI_Datatype(MPI_VAL = -2002)
    type(MPI_Datatype), parameter :: MPI_OFFSET                      = MPI_Datatype(MPI_VAL = -2003)

    ! C and C++ types are less likely
    type(MPI_Datatype), parameter :: MPI_BYTE                        = MPI_Datatype(MPI_VAL = -3011)
    type(MPI_Datatype), parameter :: MPI_CHAR                        = MPI_Datatype(MPI_VAL = -3012)
    type(MPI_Datatype), parameter :: MPI_UNSIGNED_CHAR               = MPI_Datatype(MPI_VAL = -3013)
    type(MPI_Datatype), parameter :: MPI_SIGNED_CHAR                 = MPI_Datatype(MPI_VAL = -3014)
    type(MPI_Datatype), parameter :: MPI_WCHAR                       = MPI_Datatype(MPI_VAL = -3015)
    type(MPI_Datatype), parameter :: MPI_SHORT                       = MPI_Datatype(MPI_VAL = -3016)
    type(MPI_Datatype), parameter :: MPI_UNSIGNED_SHORT              = MPI_Datatype(MPI_VAL = -3017)
    type(MPI_Datatype), parameter :: MPI_INT                         = MPI_Datatype(MPI_VAL = -3018)
    type(MPI_Datatype), parameter :: MPI_LONG                        = MPI_Datatype(MPI_VAL = -3019)
    type(MPI_Datatype), parameter :: MPI_UNSIGNED                    = MPI_Datatype(MPI_VAL = -3020)
    type(MPI_Datatype), parameter :: MPI_UNSIGNED_LONG               = MPI_Datatype(MPI_VAL = -3021)
    type(MPI_Datatype), parameter :: MPI_LONG_LONG_INT               = MPI_Datatype(MPI_VAL = -3022)
    type(MPI_Datatype), parameter :: MPI_UNSIGNED_LONG_LONG          = MPI_Datatype(MPI_VAL = -3023)
    type(MPI_Datatype), parameter :: MPI_FLOAT                       = MPI_Datatype(MPI_VAL = -3024)
    type(MPI_Datatype), parameter :: MPI_DOUBLE                      = MPI_Datatype(MPI_VAL = -3025)
    type(MPI_Datatype), parameter :: MPI_LONG_DOUBLE                 = MPI_Datatype(MPI_VAL = -3026)
    type(MPI_Datatype), parameter :: MPI_C_BOOL                      = MPI_Datatype(MPI_VAL = -3027)
    type(MPI_Datatype), parameter :: MPI_INT8_T                      = MPI_Datatype(MPI_VAL = -3028)
    type(MPI_Datatype), parameter :: MPI_INT16_T                     = MPI_Datatype(MPI_VAL = -3029)
    type(MPI_Datatype), parameter :: MPI_INT32_T                     = MPI_Datatype(MPI_VAL = -3030)
    type(MPI_Datatype), parameter :: MPI_INT64_T                     = MPI_Datatype(MPI_VAL = -3031)
    type(MPI_Datatype), parameter :: MPI_UINT8_T                     = MPI_Datatype(MPI_VAL = -3032)
    type(MPI_Datatype), parameter :: MPI_UINT16_T                    = MPI_Datatype(MPI_VAL = -3033)
    type(MPI_Datatype), parameter :: MPI_UINT32_T                    = MPI_Datatype(MPI_VAL = -3034)
    type(MPI_Datatype), parameter :: MPI_UINT64_T                    = MPI_Datatype(MPI_VAL = -3035)
    type(MPI_Datatype), parameter :: MPI_C_COMPLEX                   = MPI_Datatype(MPI_VAL = -3036)
    type(MPI_Datatype), parameter :: MPI_C_FLOAT_COMPLEX             = MPI_Datatype(MPI_VAL = -3037)
    type(MPI_Datatype), parameter :: MPI_C_DOUBLE_COMPLEX            = MPI_Datatype(MPI_VAL = -3038)
    type(MPI_Datatype), parameter :: MPI_C_LONG_DOUBLE_COMPLEX       = MPI_Datatype(MPI_VAL = -3039)

    contains

end module mpi_datatype_f
