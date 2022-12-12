#ifndef DETECT_SENTINELS_H
#define DETECT_SENTINELS_H

#include <stdbool.h>
#include "vapaa_constants.h"

extern void * f08_MPI_BOTTOM_address;             // MPI_BOTTOM
extern void * f08_MPI_STATUS_IGNORE_address[2];   // MPI_STATUS_IGNORE
extern void * f08_MPI_STATUSES_IGNORE_address[2]; // MPI_STATUSES_IGNORE
extern void * f08_MPI_ERRCODES_IGNORE_address;    // MPI_ERRCODES_IGNORE
extern void * f08_MPI_IN_PLACE_address;           // MPI_IN_PLACE
extern void * f08_MPI_ARGV_NULL_address;          // MPI_ARGV_NULL
extern void * f08_MPI_ARGVS_NULL_address;         // MPI_ARGVS_NULL
extern void * f08_MPI_UNWEIGHTED_address;         // MPI_UNWEIGHTED
extern void * f08_MPI_WEIGHTS_EMPTY_address;      // MPI_WEIGHTS_EMPTY

static inline bool C_IS_MPI_BOTTOM(const void * address)
{
    return (address == f08_MPI_BOTTOM_address);
}

static inline bool C_IS_MPI_STATUS_IGNORE(const void * address)
{
    return ((address == f08_MPI_STATUS_IGNORE_address[0]) || (address == f08_MPI_STATUS_IGNORE_address[1]));
}

static inline bool C_IS_MPI_STATUSES_IGNORE(const void * address)
{
    return ((address == f08_MPI_STATUSES_IGNORE_address[0]) || (address == f08_MPI_STATUSES_IGNORE_address[1]));
}

static inline bool C_IS_MPI_ERRCODES_IGNORE(const void * address)
{
    return (address == f08_MPI_ERRCODES_IGNORE_address);
}

static inline bool C_IS_MPI_IN_PLACE(const void * address)
{
    return (address == f08_MPI_IN_PLACE_address);
}

static inline bool C_IS_MPI_ARGV_NULL(const void * address)
{
    return (address == f08_MPI_ARGV_NULL_address);
}

static inline bool C_IS_MPI_ARGVS_NULL(const void * address)
{
    return (address == f08_MPI_ARGVS_NULL_address);
}

static inline bool C_IS_MPI_UNWEIGHTED(const void * address)
{
    return (address == f08_MPI_UNWEIGHTED_address);
}

static inline bool C_IS_MPI_WEIGHTS_EMPTY(const void * address)
{
    return (address == f08_MPI_WEIGHTS_EMPTY_address);
}

#endif // DETECT_SENTINELS_H
