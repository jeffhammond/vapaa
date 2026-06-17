/*
 * Local MPICH test harness configuration for Vapaa.
 *
 * This is the small subset of MPICH's generated mpitestconf.h needed by the
 * imported f08 tests.
 */

#ifndef MPITESTCONF_H_INCLUDED
#define MPITESTCONF_H_INCLUDED

#define HAVE_STDARG_H 1
#define HAVE_STRING_H 1
#define HAVE_UNISTD_H 1
#define HAVE_SYS_TIME_H 1
#define HAVE_SYS_RESOURCE_H 1
#define HAVE_GETRUSAGE 1
#define HAVE_MPI_INIT_THREAD 1
#define HAVE_MPI_WIN_CREATE 1
#define HAVE_PTHREAD_BARRIER_INIT 1

#define F77_NAME_LOWER_USCORE 1

#define THREAD_PACKAGE_NAME THREAD_PACKAGE_POSIX

#endif
