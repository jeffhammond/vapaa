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
  PMPI_Comm_rank(MPI_COMM_WORLD, &rank);

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
    double stall = PMPI_Wtime();
    while (PMPI_Wtime() - stall < 1) ;
  }
  PMPI_Abort(MPI_COMM_WORLD, -1);
}


// Print a debugging message.
void VAPAA_Dbg_print_impl(const char *func, const char *format, ...)
{
  int rank;
  PMPI_Comm_rank(MPI_COMM_WORLD, &rank);

  va_list etc;
  int  disp;
  char string[500];

  disp  = 0;
  disp += snprintf(string, 500, "[%d] %s: ", rank, func);
  va_start(etc, format);
  disp += vsnprintf(string+disp, 500-disp, format, etc);
  va_end(etc);

  fprintf(stderr, "%s", string);
}

// Print an VAPAA warning message.
void VAPAA_Warning(const char *fmt, ...)
{
  int rank;
  PMPI_Comm_rank(MPI_COMM_WORLD, &rank);

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
