// See COPYRIGHT.ARMCI-MPI in top-level directory.

#ifndef DEBUG_H
#define DEBUG_H

#include <unistd.h> // usleep
int usleep(unsigned);

#include <stdarg.h>

#ifdef NO_SEATBELTS

#define VAPAA_Assert(X) ((void)0)
#define VAPAA_Assert_msg(X,MSG) ((void)0)

#else

// Likely/Unlikely macros borrowed from MPICH:
#if ( defined(__GNUC__) && (__GNUC__ >= 3) ) || defined(__IBMC__) || defined(__INTEL_COMPILER) || defined(__clang__)
#  define unlikely(x_) __builtin_expect(!!(x_),0)
#  define likely(x_)   __builtin_expect(!!(x_),1)
#else
#  define unlikely(x_) (x_)
#  define likely(x_)   (x_)
#endif

void VAPAA_Assert_fail(const char *expr, const char *msg, const char *file, int line, const char *func);
#define VAPAA_Assert(EXPR)          do { if (unlikely(!(EXPR))) VAPAA_Assert_fail(#EXPR, NULL, __FILE__, __LINE__, __func__); } while(0)
#define VAPAA_Assert_msg(EXPR, MSG) do { if (unlikely(!(EXPR))) VAPAA_Assert_fail(#EXPR, MSG,  __FILE__, __LINE__, __func__); } while(0)

#endif // NO_SEATBELTS

void VAPAA_Warning(const char *fmt, ...);

#endif // DEBUG_H
