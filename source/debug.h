// See COPYRIGHT.ARMCI-MPI in top-level directory.

#ifndef DEBUG_H
#define DEBUG_H

#include <stdarg.h>

#ifdef NO_SEATBELTS

#define VAPAA_Assert(X) ((void)0)
#define VAPAA_Assert_msg(X,MSG) ((void)0)

#else

void    VAPAA_Assert_fail(const char *expr, const char *msg, const char *file, int line, const char *func);
#define VAPAA_Assert(EXPR)          do { if (unlikely(!(EXPR))) VAPAA_Assert_fail(#EXPR, NULL, __FILE__, __LINE__, __func__); } while(0)
#define VAPAA_Assert_msg(EXPR, MSG) do { if (unlikely(!(EXPR))) VAPAA_Assert_fail(#EXPR, MSG,  __FILE__, __LINE__, __func__); } while(0)

#endif // NO_SEATBELTS

#define VAPAA_Error(...) VAPAA_Error_impl(__FILE__,__LINE__,__func__,__VA_ARGS__)
void    VAPAA_Error_impl(const char *file, const int line, const char *func, const char *msg, ...);
void    VAPAA_Warning(const char *fmt, ...);

#endif // DEBUG_H
