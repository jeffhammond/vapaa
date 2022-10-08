#include <mpi.h>

// NOT STANDARD STUFF

void C_MPI_DATATYPE_NULL(int * datatype)
{
    *datatype = MPI_Type_c2f(MPI_DATATYPE_NULL);
}

void C_MPI_DATATYPE_BUILTINS(int * AINT, int * OFFSET, int * COUNT,
                             int * LOGICAL, int * CHARACTER, int * BYTE, int * INTEGER, 
                             int * REAL, int * DOUBLE_PRECISION,
                             int * COMPLEX, int * DOUBLE_COMPLEX,
                             int * INTEGER1, int * INTEGER2, int * INTEGER4, int * INTEGER8, int * INTEGER16,
                             int * REAL2, int * REAL4, int * REAL8, int * REAL16,
                             int * COMPLEX4, int * COMPLEX8, int * COMPLEX16, int * COMPLEX32)
{
    *AINT             = MPI_Type_c2f(MPI_AINT);
    *OFFSET           = MPI_Type_c2f(MPI_OFFSET);
    *COUNT            = MPI_Type_c2f(MPI_COUNT);
    *LOGICAL          = MPI_Type_c2f(MPI_LOGICAL);
    *CHARACTER        = MPI_Type_c2f(MPI_CHARACTER);
    *BYTE             = MPI_Type_c2f(MPI_BYTE);
    *INTEGER          = MPI_Type_c2f(MPI_INTEGER);
    *REAL             = MPI_Type_c2f(MPI_REAL);
    *DOUBLE_PRECISION = MPI_Type_c2f(MPI_DOUBLE_PRECISION);
    *COMPLEX          = MPI_Type_c2f(MPI_COMPLEX);
    *DOUBLE_COMPLEX   = MPI_Type_c2f(MPI_DOUBLE_COMPLEX);
    *INTEGER1         = MPI_Type_c2f(MPI_INTEGER1);
    *INTEGER2         = MPI_Type_c2f(MPI_INTEGER2);
    *INTEGER4         = MPI_Type_c2f(MPI_INTEGER4);
    *INTEGER8         = MPI_Type_c2f(MPI_INTEGER8);
    *INTEGER16        = MPI_Type_c2f(MPI_INTEGER16);
#ifdef HAVE_MPI_REAL2
    *REAL2            = MPI_Type_c2f(MPI_REAL2);
#else
    *REAL2            = MPI_Type_c2f(MPI_DATATYPE_NULL);
#endif
    *REAL4            = MPI_Type_c2f(MPI_REAL4);
    *REAL8            = MPI_Type_c2f(MPI_REAL8);
#ifdef HAVE_MPI_REAL16
    *REAL16           = MPI_Type_c2f(MPI_REAL16);
#else
    *REAL16           = MPI_Type_c2f(MPI_DATATYPE_NULL);
#endif
#ifdef HAVE_MPI_COMPLEX4
    *COMPLEX4         = MPI_Type_c2f(MPI_COMPLEX4);
#else
    *COMPLEX4         = MPI_Type_c2f(MPI_DATATYPE_NULL);
#endif
    *COMPLEX8         = MPI_Type_c2f(MPI_COMPLEX8);
    *COMPLEX16        = MPI_Type_c2f(MPI_COMPLEX16);
#ifdef HAVE_MPI_COMPLEX32
    *COMPLEX32        = MPI_Type_c2f(MPI_COMPLEX32);
#else
    *COMPLEX32        = MPI_Type_c2f(MPI_DATATYPE_NULL);
#endif
}

// STANDARD STUFF

