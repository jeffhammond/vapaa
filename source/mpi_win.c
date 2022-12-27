#include <mpi.h>
#include "vapaa_constants.h"

#if 0
static int C_MPI_TRANSLATE_WIN_ASSERT(int f)
{
    // all of the VAPAA constants are powers of two, to ensure bit logic works
    int c = 0;
    if (f & VAPAA_MPI_NOCHECK  ) c |= MPI_MODE_NOCHECK;
    if (f & VAPAA_MPI_NOSTORE  ) c |= MPI_MODE_NOSTORE;
    if (f & VAPAA_MPI_NOPUT    ) c |= MPI_MODE_NOPUT;
    if (f & VAPAA_MPI_NOPRECEDE) c |= MPI_MODE_NOPRECEDE;
    if (f & VAPAA_MPI_NOSUCCEED) c |= MPI_MODE_NOSUCCEED;
    return c;
}
#endif
