#include <mpi.h>

// We use the same values as MPICH but cannot be sure every MPI will,
// so we convert them here.  See mpi_global_constants.F90 for our values.

MAYBE_UNUSED
static int C_MPI_THREAD_LEVEL_F2C(int level_f)
{
    if (level_f == 3) {
       return MPI_THREAD_MULTIPLE;
    } else if (level_f == 2) {
       return MPI_THREAD_SERIALIZED; 
    } else if (level_f == 1) {
       return MPI_THREAD_FUNNELED; 
    } else { //if (level_f == 0) {
       return MPI_THREAD_SINGLE; 
    }
}

MAYBE_UNUSED
static int C_MPI_THREAD_LEVEL_C2F(int level_c)
{
    if (level_c == MPI_THREAD_MULTIPLE) {
       return 3;
    } else if (level_c == MPI_THREAD_SERIALIZED) {
       return 2; 
    } else if (level_c == MPI_THREAD_FUNNELED) {
       return 1; 
    } else { //if (level_c == MPI_THREAD_SINGLE) {
       return 0; 
    }
}

/************* VAPAA ERROR CODES **************
integer, parameter :: MPI_SUCCESS                                =  0
integer, parameter :: MPI_ERR_BUFFER                             =  1
integer, parameter :: MPI_ERR_COUNT                              =  2
integer, parameter :: MPI_ERR_TYPE                               =  3
integer, parameter :: MPI_ERR_TAG                                =  4
integer, parameter :: MPI_ERR_COMM                               =  5
integer, parameter :: MPI_ERR_RANK                               =  6
integer, parameter :: MPI_ERR_REQUEST                            =  7
integer, parameter :: MPI_ERR_ROOT                               =  8
integer, parameter :: MPI_ERR_GROUP                              =  9
integer, parameter :: MPI_ERR_OP                                 = 10
integer, parameter :: MPI_ERR_TOPOLOGY                           = 11
integer, parameter :: MPI_ERR_DIMS                               = 12
integer, parameter :: MPI_ERR_ARG                                = 13
integer, parameter :: MPI_ERR_UNKNOWN                            = 14
integer, parameter :: MPI_ERR_TRUNCATE                           = 15
integer, parameter :: MPI_ERR_OTHER                              = 16
integer, parameter :: MPI_ERR_INTERN                             = 17
integer, parameter :: MPI_ERR_PENDING                            = 18
integer, parameter :: MPI_ERR_IN_STATUS                          = 19
integer, parameter :: MPI_ERR_ACCESS                             = 20
integer, parameter :: MPI_ERR_AMODE                              = 21
integer, parameter :: MPI_ERR_ASSERT                             = 22
integer, parameter :: MPI_ERR_BAD_FILE                           = 23
integer, parameter :: MPI_ERR_BASE                               = 24
integer, parameter :: MPI_ERR_CONVERSION                         = 25
integer, parameter :: MPI_ERR_DISP                               = 26
integer, parameter :: MPI_ERR_DUP_DATAREP                        = 27
integer, parameter :: MPI_ERR_FILE_EXISTS                        = 28
integer, parameter :: MPI_ERR_FILE_IN_USE                        = 29
integer, parameter :: MPI_ERR_FILE                               = 30
integer, parameter :: MPI_ERR_INFO_KEY                           = 31
integer, parameter :: MPI_ERR_INFO_NOKEY                         = 32
integer, parameter :: MPI_ERR_INFO_VALUE                         = 33
integer, parameter :: MPI_ERR_INFO                               = 34
integer, parameter :: MPI_ERR_IO                                 = 35
integer, parameter :: MPI_ERR_KEYVAL                             = 36
integer, parameter :: MPI_ERR_LOCKTYPE                           = 37
integer, parameter :: MPI_ERR_NAME                               = 38
integer, parameter :: MPI_ERR_NO_MEM                             = 39
integer, parameter :: MPI_ERR_NOT_SAME                           = 40
integer, parameter :: MPI_ERR_NO_SPACE                           = 41
integer, parameter :: MPI_ERR_NO_SUCH_FILE                       = 42
integer, parameter :: MPI_ERR_PORT                               = 43
integer, parameter :: MPI_ERR_PROC_ABORTED                       = 44
integer, parameter :: MPI_ERR_QUOTA                              = 45
integer, parameter :: MPI_ERR_READ_ONLY                          = 46
integer, parameter :: MPI_ERR_RMA_ATTACH                         = 47
integer, parameter :: MPI_ERR_RMA_CONFLICT                       = 48
integer, parameter :: MPI_ERR_RMA_RANGE                          = 49
integer, parameter :: MPI_ERR_RMA_SHARED                         = 50
integer, parameter :: MPI_ERR_RMA_SYNC                           = 51
integer, parameter :: MPI_ERR_RMA_FLAVOR                         = 52
integer, parameter :: MPI_ERR_SERVICE                            = 53
integer, parameter :: MPI_ERR_SESSION                            = 54
integer, parameter :: MPI_ERR_SIZE                               = 55
integer, parameter :: MPI_ERR_SPAWN                              = 56
integer, parameter :: MPI_ERR_UNSUPPORTED_DATAREP                = 57
integer, parameter :: MPI_ERR_UNSUPPORTED_OPERATION              = 58
integer, parameter :: MPI_ERR_VALUE_TOO_LARGE                    = 59
integer, parameter :: MPI_ERR_WIN                                = 60
integer, parameter :: MPI_T_ERR_CANNOT_INIT                      = 61
integer, parameter :: MPI_T_ERR_NOT_ACCESSIBLE                   = 62
integer, parameter :: MPI_T_ERR_NOT_INITIALIZED                  = 63
integer, parameter :: MPI_T_ERR_NOT_SUPPORTED                    = 64
integer, parameter :: MPI_T_ERR_MEMORY                           = 65
integer, parameter :: MPI_T_ERR_INVALID                          = 66
integer, parameter :: MPI_T_ERR_INVALID_INDEX                    = 67
integer, parameter :: MPI_T_ERR_INVALID_ITEM                     = 68
integer, parameter :: MPI_T_ERR_INVALID_SESSION                  = 69
integer, parameter :: MPI_T_ERR_INVALID_HANDLE                   = 70
integer, parameter :: MPI_T_ERR_INVALID_NAME                     = 71
integer, parameter :: MPI_T_ERR_OUT_OF_HANDLES                   = 72
integer, parameter :: MPI_T_ERR_OUT_OF_SESSIONS                  = 73
integer, parameter :: MPI_T_ERR_CVAR_SET_NOT_NOW                 = 74
integer, parameter :: MPI_T_ERR_CVAR_SET_NEVER                   = 75
integer, parameter :: MPI_T_ERR_PVAR_NO_WRITE                    = 76
integer, parameter :: MPI_T_ERR_PVAR_NO_STARTSTOP                = 77
integer, parameter :: MPI_T_ERR_PVAR_NO_ATOMIC                   = 78
integer, parameter :: MPI_ERR_LASTCODE                           = 79
**************************************/

MAYBE_UNUSED
static int C_MPI_ERROR_CODE_C2F(int level_c)
{
         if (error_c == MPI_SUCCESS                                ) { return  0; }
    else if (error_c == MPI_ERR_BUFFER                             ) { return  1; }
    else if (error_c == MPI_ERR_COUNT                              ) { return  2; }
    else if (error_c == MPI_ERR_TYPE                               ) { return  3; }
    else if (error_c == MPI_ERR_TAG                                ) { return  4; }
    else if (error_c == MPI_ERR_COMM                               ) { return  5; }
    else if (error_c == MPI_ERR_RANK                               ) { return  6; }
    else if (error_c == MPI_ERR_REQUEST                            ) { return  7; }
    else if (error_c == MPI_ERR_ROOT                               ) { return  8; }
    else if (error_c == MPI_ERR_GROUP                              ) { return  9; }
    else if (error_c == MPI_ERR_OP                                 ) { return 10; }
    else if (error_c == MPI_ERR_TOPOLOGY                           ) { return 11; }
    else if (error_c == MPI_ERR_DIMS                               ) { return 12; }
    else if (error_c == MPI_ERR_ARG                                ) { return 13; }
    else if (error_c == MPI_ERR_UNKNOWN                            ) { return 14; }
    else if (error_c == MPI_ERR_TRUNCATE                           ) { return 15; }
    else if (error_c == MPI_ERR_OTHER                              ) { return 16; }
    else if (error_c == MPI_ERR_INTERN                             ) { return 17; }
    else if (error_c == MPI_ERR_PENDING                            ) { return 18; }
    else if (error_c == MPI_ERR_IN_STATUS                          ) { return 19; }
    else if (error_c == MPI_ERR_ACCESS                             ) { return 20; }
    else if (error_c == MPI_ERR_AMODE                              ) { return 21; }
    else if (error_c == MPI_ERR_ASSERT                             ) { return 22; }
    else if (error_c == MPI_ERR_BAD_FILE                           ) { return 23; }
    else if (error_c == MPI_ERR_BASE                               ) { return 24; }
    else if (error_c == MPI_ERR_CONVERSION                         ) { return 25; }
    else if (error_c == MPI_ERR_DISP                               ) { return 26; }
    else if (error_c == MPI_ERR_DUP_DATAREP                        ) { return 27; }
    else if (error_c == MPI_ERR_FILE_EXISTS                        ) { return 28; }
    else if (error_c == MPI_ERR_FILE_IN_USE                        ) { return 29; }
    else if (error_c == MPI_ERR_FILE                               ) { return 30; }
    else if (error_c == MPI_ERR_INFO_KEY                           ) { return 31; }
    else if (error_c == MPI_ERR_INFO_NOKEY                         ) { return 32; }
    else if (error_c == MPI_ERR_INFO_VALUE                         ) { return 33; }
    else if (error_c == MPI_ERR_INFO                               ) { return 34; }
    else if (error_c == MPI_ERR_IO                                 ) { return 35; }
    else if (error_c == MPI_ERR_KEYVAL                             ) { return 36; }
    else if (error_c == MPI_ERR_LOCKTYPE                           ) { return 37; }
    else if (error_c == MPI_ERR_NAME                               ) { return 38; }
    else if (error_c == MPI_ERR_NO_MEM                             ) { return 39; }
    else if (error_c == MPI_ERR_NOT_SAME                           ) { return 40; }
    else if (error_c == MPI_ERR_NO_SPACE                           ) { return 41; }
    else if (error_c == MPI_ERR_NO_SUCH_FILE                       ) { return 42; }
    else if (error_c == MPI_ERR_PORT                               ) { return 43; }
    else if (error_c == MPI_ERR_PROC_ABORTED                       ) { return 44; }
    else if (error_c == MPI_ERR_QUOTA                              ) { return 45; }
    else if (error_c == MPI_ERR_READ_ONLY                          ) { return 46; }
    else if (error_c == MPI_ERR_RMA_ATTACH                         ) { return 47; }
    else if (error_c == MPI_ERR_RMA_CONFLICT                       ) { return 48; }
    else if (error_c == MPI_ERR_RMA_RANGE                          ) { return 49; }
    else if (error_c == MPI_ERR_RMA_SHARED                         ) { return 50; }
    else if (error_c == MPI_ERR_RMA_SYNC                           ) { return 51; }
    else if (error_c == MPI_ERR_RMA_FLAVOR                         ) { return 52; }
    else if (error_c == MPI_ERR_SERVICE                            ) { return 53; }
    else if (error_c == MPI_ERR_SESSION                            ) { return 54; }
    else if (error_c == MPI_ERR_SIZE                               ) { return 55; }
    else if (error_c == MPI_ERR_SPAWN                              ) { return 56; }
    else if (error_c == MPI_ERR_UNSUPPORTED_DATAREP                ) { return 57; }
    else if (error_c == MPI_ERR_UNSUPPORTED_OPERATION              ) { return 58; }
    else if (error_c == MPI_ERR_VALUE_TOO_LARGE                    ) { return 59; }
    else if (error_c == MPI_ERR_WIN                                ) { return 60; }
    else if (error_c == MPI_T_ERR_CANNOT_INIT                      ) { return 61; }
    else if (error_c == MPI_T_ERR_NOT_ACCESSIBLE                   ) { return 62; }
    else if (error_c == MPI_T_ERR_NOT_INITIALIZED                  ) { return 63; }
    else if (error_c == MPI_T_ERR_NOT_SUPPORTED                    ) { return 64; }
    else if (error_c == MPI_T_ERR_MEMORY                           ) { return 65; }
    else if (error_c == MPI_T_ERR_INVALID                          ) { return 66; }
    else if (error_c == MPI_T_ERR_INVALID_INDEX                    ) { return 67; }
    else if (error_c == MPI_T_ERR_INVALID_ITEM                     ) { return 68; }
    else if (error_c == MPI_T_ERR_INVALID_SESSION                  ) { return 69; }
    else if (error_c == MPI_T_ERR_INVALID_HANDLE                   ) { return 70; }
    else if (error_c == MPI_T_ERR_INVALID_NAME                     ) { return 71; }
    else if (error_c == MPI_T_ERR_OUT_OF_HANDLES                   ) { return 72; }
    else if (error_c == MPI_T_ERR_OUT_OF_SESSIONS                  ) { return 73; }
    else if (error_c == MPI_T_ERR_CVAR_SET_NOT_NOW                 ) { return 74; }
    else if (error_c == MPI_T_ERR_CVAR_SET_NEVER                   ) { return 75; }
    else if (error_c == MPI_T_ERR_PVAR_NO_WRITE                    ) { return 76; }
    else if (error_c == MPI_T_ERR_PVAR_NO_STARTSTOP                ) { return 77; }
    else if (error_c == MPI_T_ERR_PVAR_NO_ATOMIC                   ) { return 78; }
    else if (error_c == MPI_ERR_LASTCODE                           ) { return 79; }
    else {
        fprintf(stderr, "Unknown error code returned from the C library: %d\n", error_c);
        return 14; /* MPI_ERR_UNKNOWN */
    }
}
