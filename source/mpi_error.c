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

int C_MPI_ERROR_CODE_F2C(int error_f)
{
         if (error_f ==  0 ) { return MPI_SUCCESS;                   }
    else if (error_f ==  1 ) { return MPI_ERR_BUFFER;                }
    else if (error_f ==  2 ) { return MPI_ERR_COUNT;                 }
    else if (error_f ==  3 ) { return MPI_ERR_TYPE;                  }
    else if (error_f ==  4 ) { return MPI_ERR_TAG;                   }
    else if (error_f ==  5 ) { return MPI_ERR_COMM;                  }
    else if (error_f ==  6 ) { return MPI_ERR_RANK;                  }
    else if (error_f ==  7 ) { return MPI_ERR_REQUEST;               }
    else if (error_f ==  8 ) { return MPI_ERR_ROOT;                  }
    else if (error_f ==  9 ) { return MPI_ERR_GROUP;                 }
    else if (error_f == 10 ) { return MPI_ERR_OP;                    }
    else if (error_f == 11 ) { return MPI_ERR_TOPOLOGY;              }
    else if (error_f == 12 ) { return MPI_ERR_DIMS;                  }
    else if (error_f == 13 ) { return MPI_ERR_ARG;                   }
    else if (error_f == 14 ) { return MPI_ERR_UNKNOWN;               }
    else if (error_f == 15 ) { return MPI_ERR_TRUNCATE;              }
    else if (error_f == 16 ) { return MPI_ERR_OTHER;                 }
    else if (error_f == 17 ) { return MPI_ERR_INTERN;                }
    else if (error_f == 18 ) { return MPI_ERR_PENDING;               }
    else if (error_f == 19 ) { return MPI_ERR_IN_STATUS;             }
    else if (error_f == 20 ) { return MPI_ERR_ACCESS;                }
    else if (error_f == 21 ) { return MPI_ERR_AMODE;                 }
    else if (error_f == 22 ) { return MPI_ERR_ASSERT;                }
    else if (error_f == 23 ) { return MPI_ERR_BAD_FILE;              }
    else if (error_f == 24 ) { return MPI_ERR_BASE;                  }
    else if (error_f == 25 ) { return MPI_ERR_CONVERSION;            }
    else if (error_f == 26 ) { return MPI_ERR_DISP;                  }
    else if (error_f == 27 ) { return MPI_ERR_DUP_DATAREP;           }
    else if (error_f == 28 ) { return MPI_ERR_FILE_EXISTS;           }
    else if (error_f == 29 ) { return MPI_ERR_FILE_IN_USE;           }
    else if (error_f == 30 ) { return MPI_ERR_FILE;                  }
    else if (error_f == 31 ) { return MPI_ERR_INFO_KEY;              }
    else if (error_f == 32 ) { return MPI_ERR_INFO_NOKEY;            }
    else if (error_f == 33 ) { return MPI_ERR_INFO_VALUE;            }
    else if (error_f == 34 ) { return MPI_ERR_INFO;                  }
    else if (error_f == 35 ) { return MPI_ERR_IO;                    }
    else if (error_f == 36 ) { return MPI_ERR_KEYVAL;                }
    else if (error_f == 37 ) { return MPI_ERR_LOCKTYPE;              }
    else if (error_f == 38 ) { return MPI_ERR_NAME;                  }
    else if (error_f == 39 ) { return MPI_ERR_NO_MEM;                }
    else if (error_f == 40 ) { return MPI_ERR_NOT_SAME;              }
    else if (error_f == 41 ) { return MPI_ERR_NO_SPACE;              }
    else if (error_f == 42 ) { return MPI_ERR_NO_SUCH_FILE;          }
    else if (error_f == 43 ) { return MPI_ERR_PORT;                  }
    else if (error_f == 44 ) { return MPI_ERR_PROC_ABORTED;          }
    else if (error_f == 45 ) { return MPI_ERR_QUOTA;                 }
    else if (error_f == 46 ) { return MPI_ERR_READ_ONLY;             }
    else if (error_f == 47 ) { return MPI_ERR_RMA_ATTACH;            }
    else if (error_f == 48 ) { return MPI_ERR_RMA_CONFLICT;          }
    else if (error_f == 49 ) { return MPI_ERR_RMA_RANGE;             }
    else if (error_f == 50 ) { return MPI_ERR_RMA_SHARED;            }
    else if (error_f == 51 ) { return MPI_ERR_RMA_SYNC;              }
    else if (error_f == 52 ) { return MPI_ERR_RMA_FLAVOR;            }
    else if (error_f == 53 ) { return MPI_ERR_SERVICE;               }
    else if (error_f == 54 ) { return MPI_ERR_SESSION;               }
    else if (error_f == 55 ) { return MPI_ERR_SIZE;                  }
    else if (error_f == 56 ) { return MPI_ERR_SPAWN;                 }
    else if (error_f == 57 ) { return MPI_ERR_UNSUPPORTED_DATAREP;   }
    else if (error_f == 58 ) { return MPI_ERR_UNSUPPORTED_OPERATION; }
    else if (error_f == 59 ) { return MPI_ERR_VALUE_TOO_LARGE;       }
    else if (error_f == 60 ) { return MPI_ERR_WIN;                   }
    else if (error_f == 61 ) { return MPI_T_ERR_CANNOT_INIT;         }
    //else if (error_f == 62 ) { return MPI_T_ERR_NOT_ACCESSIBLE;      }
    else if (error_f == 63 ) { return MPI_T_ERR_NOT_INITIALIZED;     }
    else if (error_f == 64 ) { return MPI_T_ERR_NOT_SUPPORTED;       }
    else if (error_f == 65 ) { return MPI_T_ERR_MEMORY;              }
    else if (error_f == 66 ) { return MPI_T_ERR_INVALID;             }
    else if (error_f == 67 ) { return MPI_T_ERR_INVALID_INDEX;       }
    else if (error_f == 68 ) { return MPI_T_ERR_INVALID_ITEM;        }
    else if (error_f == 69 ) { return MPI_T_ERR_INVALID_SESSION;     }
    else if (error_f == 70 ) { return MPI_T_ERR_INVALID_HANDLE;      }
    else if (error_f == 71 ) { return MPI_T_ERR_INVALID_NAME;        }
    else if (error_f == 72 ) { return MPI_T_ERR_OUT_OF_HANDLES;      }
    else if (error_f == 73 ) { return MPI_T_ERR_OUT_OF_SESSIONS;     }
    else if (error_f == 74 ) { return MPI_T_ERR_CVAR_SET_NOT_NOW;    }
    else if (error_f == 75 ) { return MPI_T_ERR_CVAR_SET_NEVER;      }
    else if (error_f == 76 ) { return MPI_T_ERR_PVAR_NO_WRITE;       }
    else if (error_f == 77 ) { return MPI_T_ERR_PVAR_NO_STARTSTOP;   }
    else if (error_f == 78 ) { return MPI_T_ERR_PVAR_NO_ATOMIC;      }
    else if (error_f == 79 ) { return MPI_ERR_LASTCODE;              }
    else {
        fprintf(stderr, "Unknown error code returned from the F library: %d\n", error_f);
        return MPI_ERR_UNKNOWN;
    }
}

//void C_MPI_Error_string(char * string, int * resultlen, int * ierror)
void CFI_MPI_Error_string(int * errorcode_f, CFI_cdesc_t * string_d, int * resultlen, int * ierror)
{
    char * string = string_d -> base_addr;
    int errorcode_c = C_MPI_ERROR_CODE_C2F(*errorcode_f);
    *ierror = MPI_Error_string(errorcode_c, string, resultlen);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Error_class(int * errorcode_f, int * errorclass, int * ierror)
{
    int errorcode_c = C_MPI_ERROR_CODE_C2F(*errorcode_f);
    *ierror = MPI_Error_class(errorcode_c, errorclass);
    C_MPI_RC_FIX(*ierror);
}
