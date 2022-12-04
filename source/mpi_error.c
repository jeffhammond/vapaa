#include <stdio.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "mpi_constant_conversions.h"

// see mpi_error_f.F90 for the source of these values

// might need to ifdef RC all of the non-zero error codes since some
// might not exist in all implementations.
// it sucks, but it is better than implementing build system support for this.

int C_MPI_ERROR_CODE_C2F(int error_c)
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
    //else if (error_c == MPI_T_ERR_NOT_ACCESSIBLE                   ) { return 62; }
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

//void C_MPI_Error_string(char * string, int * resultlen, int * ierror)
void CFI_MPI_Error_string(int * errorcode, CFI_cdesc_t * string_d, int * resultlen, int * ierror)
{
    char * string = string_d -> base_addr;
    *ierror = MPI_Error_string(*errorcode, string, resultlen);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Error_class(int * errorcode, int * errorclass, int * ierror)
{
    *ierror = MPI_Error_class(*errorcode, errorclass);
    C_MPI_RC_FIX(*ierror);
}
