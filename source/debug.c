// See COPYRIGHT.ARMCI-MPI in top-level directory.

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

#include <mpi.h>

#if HAVE_EXECINFO_H
#include <execinfo.h>
#endif

#include "debug.h"

// Print an assertion failure message and abort the program.
void VAPAA_Assert_fail(const char *expr, const char *msg, const char *file, int line, const char *func)
{
  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  if (msg == NULL) {
    fprintf(stderr, "[%d] VAPAA assert fail in %s() [%s:%d]: \"%s\"\n", rank, func, file, line, expr);
  } else {
    fprintf(stderr, "[%d] VAPAA assert fail in %s() [%s:%d]: \"%s\"\n"
                    "[%d] Message: \"%s\"\n", rank, func, file, line, expr, rank, msg);
  }

#if HAVE_EXECINFO_H
  {
    const int SIZE = 100;
    int    j, nframes;
    void  *frames[SIZE];
    char **symbols;

    nframes = backtrace(frames, SIZE);
    symbols = backtrace_symbols(frames, nframes);

    if (symbols == NULL) {
      perror("Backtrace failure");
    }

    fprintf(stderr, "[%d] Backtrace:\n", rank);
    for (j = 0; j < nframes; j++) {
      fprintf(stderr, "[%d]  %2d - %s\n", rank, nframes-j-1, symbols[j]);
    }

    free(symbols);
  }
#endif

  fflush(NULL);
  {
    double stall = MPI_Wtime();
    while (MPI_Wtime() - stall < 1) ;
  }
  MPI_Abort(MPI_COMM_WORLD, -1);
}

void VAPAA_Warning(const char *fmt, ...)
{
  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  va_list etc;
  int  disp;
  char string[500];

  disp  = 0;
  disp += snprintf(string, 500, "[%d] VAPAA Warning: ", rank);
  va_start(etc, fmt);
  disp += vsnprintf(string+disp, 500-disp, fmt, etc);
  va_end(etc);

  fprintf(stderr, "%s", string);
  fflush(NULL);
}
