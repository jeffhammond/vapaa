#include <stdio.h>
#include <string.h> // memset
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_constants.h"
#include "vapaa_constants.h"
#include "debug.h"

// see mpi_error_f.F90 for the source of these values

// might need to ifdef RC all of the non-zero error codes since some
// might not exist in all implementations.
// it sucks, but it is better than implementing build system support for this.

int C_MPI_ERROR_CODE_C2F(int error_c)
{
         if (error_c == MPI_SUCCESS                   ) { return VAPAA_MPI_SUCCESS; }
    else if (error_c == MPI_ERR_BUFFER                ) { return VAPAA_MPI_ERR_BUFFER; }
    else if (error_c == MPI_ERR_COUNT                 ) { return VAPAA_MPI_ERR_COUNT; }
    else if (error_c == MPI_ERR_TYPE                  ) { return VAPAA_MPI_ERR_TYPE; }
    else if (error_c == MPI_ERR_TAG                   ) { return VAPAA_MPI_ERR_TAG; }
    else if (error_c == MPI_ERR_COMM                  ) { return VAPAA_MPI_ERR_COMM; }
    else if (error_c == MPI_ERR_RANK                  ) { return VAPAA_MPI_ERR_RANK; }
    else if (error_c == MPI_ERR_REQUEST               ) { return VAPAA_MPI_ERR_REQUEST; }
    else if (error_c == MPI_ERR_ROOT                  ) { return VAPAA_MPI_ERR_ROOT; }
    else if (error_c == MPI_ERR_GROUP                 ) { return VAPAA_MPI_ERR_GROUP; }
    else if (error_c == MPI_ERR_OP                    ) { return VAPAA_MPI_ERR_OP; }
    else if (error_c == MPI_ERR_TOPOLOGY              ) { return VAPAA_MPI_ERR_TOPOLOGY; }
    else if (error_c == MPI_ERR_DIMS                  ) { return VAPAA_MPI_ERR_DIMS; }
    else if (error_c == MPI_ERR_ARG                   ) { return VAPAA_MPI_ERR_ARG; }
    else if (error_c == MPI_ERR_UNKNOWN               ) { return VAPAA_MPI_ERR_UNKNOWN; }
    else if (error_c == MPI_ERR_TRUNCATE              ) { return VAPAA_MPI_ERR_TRUNCATE; }
    else if (error_c == MPI_ERR_OTHER                 ) { return VAPAA_MPI_ERR_OTHER; }
    else if (error_c == MPI_ERR_INTERN                ) { return VAPAA_MPI_ERR_INTERN; }
    else if (error_c == MPI_ERR_PENDING               ) { return VAPAA_MPI_ERR_PENDING; }
    else if (error_c == MPI_ERR_IN_STATUS             ) { return VAPAA_MPI_ERR_IN_STATUS; }
    else if (error_c == MPI_ERR_ACCESS                ) { return VAPAA_MPI_ERR_ACCESS; }
    else if (error_c == MPI_ERR_AMODE                 ) { return VAPAA_MPI_ERR_AMODE; }
    else if (error_c == MPI_ERR_ASSERT                ) { return VAPAA_MPI_ERR_ASSERT; }
    else if (error_c == MPI_ERR_BAD_FILE              ) { return VAPAA_MPI_ERR_BAD_FILE; }
    else if (error_c == MPI_ERR_BASE                  ) { return VAPAA_MPI_ERR_BASE; }
    else if (error_c == MPI_ERR_CONVERSION            ) { return VAPAA_MPI_ERR_CONVERSION; }
    else if (error_c == MPI_ERR_DISP                  ) { return VAPAA_MPI_ERR_DISP; }
    else if (error_c == MPI_ERR_DUP_DATAREP           ) { return VAPAA_MPI_ERR_DUP_DATAREP; }
    else if (error_c == MPI_ERR_FILE_EXISTS           ) { return VAPAA_MPI_ERR_FILE_EXISTS; }
    else if (error_c == MPI_ERR_FILE_IN_USE           ) { return VAPAA_MPI_ERR_FILE_IN_USE; }
    else if (error_c == MPI_ERR_FILE                  ) { return VAPAA_MPI_ERR_FILE; }
    else if (error_c == MPI_ERR_INFO_KEY              ) { return VAPAA_MPI_ERR_INFO_KEY; }
    else if (error_c == MPI_ERR_INFO_NOKEY            ) { return VAPAA_MPI_ERR_INFO_NOKEY; }
    else if (error_c == MPI_ERR_INFO_VALUE            ) { return VAPAA_MPI_ERR_INFO_VALUE; }
    else if (error_c == MPI_ERR_INFO                  ) { return VAPAA_MPI_ERR_INFO; }
    else if (error_c == MPI_ERR_IO                    ) { return VAPAA_MPI_ERR_IO; }
    else if (error_c == MPI_ERR_KEYVAL                ) { return VAPAA_MPI_ERR_KEYVAL; }
    else if (error_c == MPI_ERR_LOCKTYPE              ) { return VAPAA_MPI_ERR_LOCKTYPE; }
    else if (error_c == MPI_ERR_NAME                  ) { return VAPAA_MPI_ERR_NAME; }
    else if (error_c == MPI_ERR_NO_MEM                ) { return VAPAA_MPI_ERR_NO_MEM; }
    else if (error_c == MPI_ERR_NOT_SAME              ) { return VAPAA_MPI_ERR_NOT_SAME; }
    else if (error_c == MPI_ERR_NO_SPACE              ) { return VAPAA_MPI_ERR_NO_SPACE; }
    else if (error_c == MPI_ERR_NO_SUCH_FILE          ) { return VAPAA_MPI_ERR_NO_SUCH_FILE; }
    else if (error_c == MPI_ERR_PORT                  ) { return VAPAA_MPI_ERR_PORT; }
#if (MPI_VERSION >= 4)
    else if (error_c == MPI_ERR_PROC_ABORTED          ) { return VAPAA_MPI_ERR_PROC_ABORTED; }
#endif
    else if (error_c == MPI_ERR_QUOTA                 ) { return VAPAA_MPI_ERR_QUOTA; }
    else if (error_c == MPI_ERR_READ_ONLY             ) { return VAPAA_MPI_ERR_READ_ONLY; }
    else if (error_c == MPI_ERR_RMA_ATTACH            ) { return VAPAA_MPI_ERR_RMA_ATTACH; }
    else if (error_c == MPI_ERR_RMA_CONFLICT          ) { return VAPAA_MPI_ERR_RMA_CONFLICT; }
    else if (error_c == MPI_ERR_RMA_RANGE             ) { return VAPAA_MPI_ERR_RMA_RANGE; }
    else if (error_c == MPI_ERR_RMA_SHARED            ) { return VAPAA_MPI_ERR_RMA_SHARED; }
    else if (error_c == MPI_ERR_RMA_SYNC              ) { return VAPAA_MPI_ERR_RMA_SYNC; }
    else if (error_c == MPI_ERR_RMA_FLAVOR            ) { return VAPAA_MPI_ERR_RMA_FLAVOR; }
    else if (error_c == MPI_ERR_SERVICE               ) { return VAPAA_MPI_ERR_SERVICE; }
#if (MPI_VERSION >= 4)
    else if (error_c == MPI_ERR_SESSION               ) { return VAPAA_MPI_ERR_SESSION; }
#endif
    else if (error_c == MPI_ERR_SIZE                  ) { return VAPAA_MPI_ERR_SIZE; }
    else if (error_c == MPI_ERR_SPAWN                 ) { return VAPAA_MPI_ERR_SPAWN; }
    else if (error_c == MPI_ERR_UNSUPPORTED_DATAREP   ) { return VAPAA_MPI_ERR_UNSUPPORTED_DATAREP; }
    else if (error_c == MPI_ERR_UNSUPPORTED_OPERATION ) { return VAPAA_MPI_ERR_UNSUPPORTED_OPERATION; }
#if (MPI_VERSION >= 4)
    else if (error_c == MPI_ERR_VALUE_TOO_LARGE       ) { return VAPAA_MPI_ERR_VALUE_TOO_LARGE; }
#endif
    else if (error_c == MPI_ERR_WIN                   ) { return VAPAA_MPI_ERR_WIN; }
    else if (error_c == MPI_T_ERR_CANNOT_INIT         ) { return VAPAA_MPI_T_ERR_CANNOT_INIT; }
    //else if (error_c == MPI_T_ERR_NOT_ACCESSIBLE      ) { return VAPAA_MPI_T_ERR_NOT_ACCESSIBLE; }
    else if (error_c == MPI_T_ERR_NOT_INITIALIZED     ) { return VAPAA_MPI_T_ERR_NOT_INITIALIZED; }
#if (MPI_VERSION >= 4)
    else if (error_c == MPI_T_ERR_NOT_SUPPORTED       ) { return VAPAA_MPI_T_ERR_NOT_SUPPORTED; }
#endif
    else if (error_c == MPI_T_ERR_MEMORY              ) { return VAPAA_MPI_T_ERR_MEMORY; }
    else if (error_c == MPI_T_ERR_INVALID             ) { return VAPAA_MPI_T_ERR_INVALID; }
    else if (error_c == MPI_T_ERR_INVALID_INDEX       ) { return VAPAA_MPI_T_ERR_INVALID_INDEX; }
    else if (error_c == MPI_T_ERR_INVALID_ITEM        ) { return VAPAA_MPI_T_ERR_INVALID_ITEM; }
    else if (error_c == MPI_T_ERR_INVALID_SESSION     ) { return VAPAA_MPI_T_ERR_INVALID_SESSION; }
    else if (error_c == MPI_T_ERR_INVALID_HANDLE      ) { return VAPAA_MPI_T_ERR_INVALID_HANDLE; }
    else if (error_c == MPI_T_ERR_INVALID_NAME        ) { return VAPAA_MPI_T_ERR_INVALID_NAME; }
    else if (error_c == MPI_T_ERR_OUT_OF_HANDLES      ) { return VAPAA_MPI_T_ERR_OUT_OF_HANDLES; }
    else if (error_c == MPI_T_ERR_OUT_OF_SESSIONS     ) { return VAPAA_MPI_T_ERR_OUT_OF_SESSIONS; }
    else if (error_c == MPI_T_ERR_CVAR_SET_NOT_NOW    ) { return VAPAA_MPI_T_ERR_CVAR_SET_NOT_NOW; }
    else if (error_c == MPI_T_ERR_CVAR_SET_NEVER      ) { return VAPAA_MPI_T_ERR_CVAR_SET_NEVER; }
    else if (error_c == MPI_T_ERR_PVAR_NO_WRITE       ) { return VAPAA_MPI_T_ERR_PVAR_NO_WRITE; }
    else if (error_c == MPI_T_ERR_PVAR_NO_STARTSTOP   ) { return VAPAA_MPI_T_ERR_PVAR_NO_STARTSTOP; }
    else if (error_c == MPI_T_ERR_PVAR_NO_ATOMIC      ) { return VAPAA_MPI_T_ERR_PVAR_NO_ATOMIC; }
    else if (error_c == MPI_ERR_LASTCODE              ) { return VAPAA_MPI_ERR_LASTCODE; }
    else {
        int len;
        char name[MPI_MAX_ERROR_STRING] = {0};
        MPI_Error_string(error_c, name, &len);
        VAPAA_Warning("Unknown error code returned from the C library: %d=%x, name=%s\n",
                       error_c, error_c, name);
        return VAPAA_MPI_ERR_UNKNOWN;
    }
}

int C_MPI_ERROR_CODE_F2C(int error_f)
{
         if (error_f == VAPAA_MPI_SUCCESS                    ) { return MPI_SUCCESS;                   }
    else if (error_f == VAPAA_MPI_ERR_BUFFER                 ) { return MPI_ERR_BUFFER;                }
    else if (error_f == VAPAA_MPI_ERR_COUNT                  ) { return MPI_ERR_COUNT;                 }
    else if (error_f == VAPAA_MPI_ERR_TYPE                   ) { return MPI_ERR_TYPE;                  }
    else if (error_f == VAPAA_MPI_ERR_TAG                    ) { return MPI_ERR_TAG;                   }
    else if (error_f == VAPAA_MPI_ERR_COMM                   ) { return MPI_ERR_COMM;                  }
    else if (error_f == VAPAA_MPI_ERR_RANK                   ) { return MPI_ERR_RANK;                  }
    else if (error_f == VAPAA_MPI_ERR_REQUEST                ) { return MPI_ERR_REQUEST;               }
    else if (error_f == VAPAA_MPI_ERR_ROOT                   ) { return MPI_ERR_ROOT;                  }
    else if (error_f == VAPAA_MPI_ERR_GROUP                  ) { return MPI_ERR_GROUP;                 }
    else if (error_f == VAPAA_MPI_ERR_OP                     ) { return MPI_ERR_OP;                    }
    else if (error_f == VAPAA_MPI_ERR_TOPOLOGY               ) { return MPI_ERR_TOPOLOGY;              }
    else if (error_f == VAPAA_MPI_ERR_DIMS                   ) { return MPI_ERR_DIMS;                  }
    else if (error_f == VAPAA_MPI_ERR_ARG                    ) { return MPI_ERR_ARG;                   }
    else if (error_f == VAPAA_MPI_ERR_UNKNOWN                ) { return MPI_ERR_UNKNOWN;               }
    else if (error_f == VAPAA_MPI_ERR_TRUNCATE               ) { return MPI_ERR_TRUNCATE;              }
    else if (error_f == VAPAA_MPI_ERR_OTHER                  ) { return MPI_ERR_OTHER;                 }
    else if (error_f == VAPAA_MPI_ERR_INTERN                 ) { return MPI_ERR_INTERN;                }
    else if (error_f == VAPAA_MPI_ERR_PENDING                ) { return MPI_ERR_PENDING;               }
    else if (error_f == VAPAA_MPI_ERR_IN_STATUS              ) { return MPI_ERR_IN_STATUS;             }
    else if (error_f == VAPAA_MPI_ERR_ACCESS                 ) { return MPI_ERR_ACCESS;                }
    else if (error_f == VAPAA_MPI_ERR_AMODE                  ) { return MPI_ERR_AMODE;                 }
    else if (error_f == VAPAA_MPI_ERR_ASSERT                 ) { return MPI_ERR_ASSERT;                }
    else if (error_f == VAPAA_MPI_ERR_BAD_FILE               ) { return MPI_ERR_BAD_FILE;              }
    else if (error_f == VAPAA_MPI_ERR_BASE                   ) { return MPI_ERR_BASE;                  }
    else if (error_f == VAPAA_MPI_ERR_CONVERSION             ) { return MPI_ERR_CONVERSION;            }
    else if (error_f == VAPAA_MPI_ERR_DISP                   ) { return MPI_ERR_DISP;                  }
    else if (error_f == VAPAA_MPI_ERR_DUP_DATAREP            ) { return MPI_ERR_DUP_DATAREP;           }
    else if (error_f == VAPAA_MPI_ERR_FILE_EXISTS            ) { return MPI_ERR_FILE_EXISTS;           }
    else if (error_f == VAPAA_MPI_ERR_FILE_IN_USE            ) { return MPI_ERR_FILE_IN_USE;           }
    else if (error_f == VAPAA_MPI_ERR_FILE                   ) { return MPI_ERR_FILE;                  }
    else if (error_f == VAPAA_MPI_ERR_INFO_KEY               ) { return MPI_ERR_INFO_KEY;              }
    else if (error_f == VAPAA_MPI_ERR_INFO_NOKEY             ) { return MPI_ERR_INFO_NOKEY;            }
    else if (error_f == VAPAA_MPI_ERR_INFO_VALUE             ) { return MPI_ERR_INFO_VALUE;            }
    else if (error_f == VAPAA_MPI_ERR_INFO                   ) { return MPI_ERR_INFO;                  }
    else if (error_f == VAPAA_MPI_ERR_IO                     ) { return MPI_ERR_IO;                    }
    else if (error_f == VAPAA_MPI_ERR_KEYVAL                 ) { return MPI_ERR_KEYVAL;                }
    else if (error_f == VAPAA_MPI_ERR_LOCKTYPE               ) { return MPI_ERR_LOCKTYPE;              }
    else if (error_f == VAPAA_MPI_ERR_NAME                   ) { return MPI_ERR_NAME;                  }
    else if (error_f == VAPAA_MPI_ERR_NO_MEM                 ) { return MPI_ERR_NO_MEM;                }
    else if (error_f == VAPAA_MPI_ERR_NOT_SAME               ) { return MPI_ERR_NOT_SAME;              }
    else if (error_f == VAPAA_MPI_ERR_NO_SPACE               ) { return MPI_ERR_NO_SPACE;              }
    else if (error_f == VAPAA_MPI_ERR_NO_SUCH_FILE           ) { return MPI_ERR_NO_SUCH_FILE;          }
    else if (error_f == VAPAA_MPI_ERR_PORT                   ) { return MPI_ERR_PORT;                  }
#if (MPI_VERSION >= 4)
    else if (error_f == VAPAA_MPI_ERR_PROC_ABORTED           ) { return MPI_ERR_PROC_ABORTED;          }
#endif
    else if (error_f == VAPAA_MPI_ERR_QUOTA                  ) { return MPI_ERR_QUOTA;                 }
    else if (error_f == VAPAA_MPI_ERR_READ_ONLY              ) { return MPI_ERR_READ_ONLY;             }
    else if (error_f == VAPAA_MPI_ERR_RMA_ATTACH             ) { return MPI_ERR_RMA_ATTACH;            }
    else if (error_f == VAPAA_MPI_ERR_RMA_CONFLICT           ) { return MPI_ERR_RMA_CONFLICT;          }
    else if (error_f == VAPAA_MPI_ERR_RMA_RANGE              ) { return MPI_ERR_RMA_RANGE;             }
    else if (error_f == VAPAA_MPI_ERR_RMA_SHARED             ) { return MPI_ERR_RMA_SHARED;            }
    else if (error_f == VAPAA_MPI_ERR_RMA_SYNC               ) { return MPI_ERR_RMA_SYNC;              }
    else if (error_f == VAPAA_MPI_ERR_RMA_FLAVOR             ) { return MPI_ERR_RMA_FLAVOR;            }
    else if (error_f == VAPAA_MPI_ERR_SERVICE                ) { return MPI_ERR_SERVICE;               }
#if (MPI_VERSION >= 4)
    else if (error_f == VAPAA_MPI_ERR_SESSION                ) { return MPI_ERR_SESSION;               }
#endif
    else if (error_f == VAPAA_MPI_ERR_SIZE                   ) { return MPI_ERR_SIZE;                  }
    else if (error_f == VAPAA_MPI_ERR_SPAWN                  ) { return MPI_ERR_SPAWN;                 }
    else if (error_f == VAPAA_MPI_ERR_UNSUPPORTED_DATAREP    ) { return MPI_ERR_UNSUPPORTED_DATAREP;   }
    else if (error_f == VAPAA_MPI_ERR_UNSUPPORTED_OPERATION  ) { return MPI_ERR_UNSUPPORTED_OPERATION; }
#if (MPI_VERSION >= 4)
    else if (error_f == VAPAA_MPI_ERR_VALUE_TOO_LARGE        ) { return MPI_ERR_VALUE_TOO_LARGE;       }
#endif
    else if (error_f == VAPAA_MPI_ERR_WIN                    ) { return MPI_ERR_WIN;                   }
    else if (error_f == VAPAA_MPI_T_ERR_CANNOT_INIT          ) { return MPI_T_ERR_CANNOT_INIT;         }
    //else if (error_f == VAPAA_MPI_T_ERR_NOT_ACCESSIBLE       ) { return MPI_T_ERR_NOT_ACCESSIBLE;      }
    else if (error_f == VAPAA_MPI_T_ERR_NOT_INITIALIZED      ) { return MPI_T_ERR_NOT_INITIALIZED;     }
#if (MPI_VERSION >= 4)
    else if (error_f == VAPAA_MPI_T_ERR_NOT_SUPPORTED        ) { return MPI_T_ERR_NOT_SUPPORTED;       }
#endif
    else if (error_f == VAPAA_MPI_T_ERR_MEMORY               ) { return MPI_T_ERR_MEMORY;              }
    else if (error_f == VAPAA_MPI_T_ERR_INVALID              ) { return MPI_T_ERR_INVALID;             }
    else if (error_f == VAPAA_MPI_T_ERR_INVALID_INDEX        ) { return MPI_T_ERR_INVALID_INDEX;       }
    else if (error_f == VAPAA_MPI_T_ERR_INVALID_ITEM         ) { return MPI_T_ERR_INVALID_ITEM;        }
    else if (error_f == VAPAA_MPI_T_ERR_INVALID_SESSION      ) { return MPI_T_ERR_INVALID_SESSION;     }
    else if (error_f == VAPAA_MPI_T_ERR_INVALID_HANDLE       ) { return MPI_T_ERR_INVALID_HANDLE;      }
    else if (error_f == VAPAA_MPI_T_ERR_INVALID_NAME         ) { return MPI_T_ERR_INVALID_NAME;        }
    else if (error_f == VAPAA_MPI_T_ERR_OUT_OF_HANDLES       ) { return MPI_T_ERR_OUT_OF_HANDLES;      }
    else if (error_f == VAPAA_MPI_T_ERR_OUT_OF_SESSIONS      ) { return MPI_T_ERR_OUT_OF_SESSIONS;     }
    else if (error_f == VAPAA_MPI_T_ERR_CVAR_SET_NOT_NOW     ) { return MPI_T_ERR_CVAR_SET_NOT_NOW;    }
    else if (error_f == VAPAA_MPI_T_ERR_CVAR_SET_NEVER       ) { return MPI_T_ERR_CVAR_SET_NEVER;      }
    else if (error_f == VAPAA_MPI_T_ERR_PVAR_NO_WRITE        ) { return MPI_T_ERR_PVAR_NO_WRITE;       }
    else if (error_f == VAPAA_MPI_T_ERR_PVAR_NO_STARTSTOP    ) { return MPI_T_ERR_PVAR_NO_STARTSTOP;   }
    else if (error_f == VAPAA_MPI_T_ERR_PVAR_NO_ATOMIC       ) { return MPI_T_ERR_PVAR_NO_ATOMIC;      }
    else if (error_f == VAPAA_MPI_ERR_LASTCODE               ) { return MPI_ERR_LASTCODE;              }
    else {
        fprintf(stderr, "Unknown error code returned from the F library: %d\n", error_f);
        return MPI_ERR_UNKNOWN;
    }
}

void C_MPI_Error_string(int * errorcode_f, char ** pstring, int * resultlen, int * ierror)
{
    if (VAPAA_MPI_MAX_ERROR_STRING < MPI_MAX_ERROR_STRING) {
        fprintf(stderr,"C_MPI_Error_string: Fortran buffer is not large enough - "
                       "bad things are going to happen now!\n"
                       "VAPAA_MPI_MAX_ERROR_STRING=%d, MPI_MAX_ERROR_STRING=%d\n",
                       VAPAA_MPI_MAX_ERROR_STRING, MPI_MAX_ERROR_STRING);
    }
    char * string = *pstring;
    int errorcode_c = C_MPI_ERROR_CODE_F2C(*errorcode_f);
    memset(string,0,MPI_MAX_ERROR_STRING);
    *ierror = MPI_Error_string(errorcode_c, string, resultlen);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Error_string(int * errorcode_f, CFI_cdesc_t * string_d, int * resultlen, int * ierror)
{
    if (VAPAA_MPI_MAX_ERROR_STRING < MPI_MAX_ERROR_STRING) {
        fprintf(stderr,"C_MPI_Error_string: Fortran buffer is not large enough - "
                       "bad things are going to happen now!\n"
                       "VAPAA_MPI_MAX_ERROR_STRING=%d, MPI_MAX_ERROR_STRING=%d\n",
                       VAPAA_MPI_MAX_ERROR_STRING, MPI_MAX_ERROR_STRING);
    }
    char * string = string_d -> base_addr;
    //int    length = string_d -> elem_len; // input string length
    int errorcode_c = C_MPI_ERROR_CODE_F2C(*errorcode_f);
    memset(string,0,MPI_MAX_ERROR_STRING);
    *ierror = MPI_Error_string(errorcode_c, string, resultlen);
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Error_class(int * errorcode_f, int * errorclass, int * ierror)
{
    int errorcode_c = C_MPI_ERROR_CODE_F2C(*errorcode_f);
    *ierror = MPI_Error_class(errorcode_c, errorclass);
    C_MPI_RC_FIX(*ierror);
}
