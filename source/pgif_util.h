#ifndef PGIF_UTIL_H
#define PGIF_UTIL_H

#include <mpi.h>

#define VAPAA_PGIF_MAXDIMS 7
#define VAPAA_PGIF_DESCRIPTOR_TAG 35LL

typedef struct {
    long long lbound;
    long long extent;
    long long sstride;
    long long soffset;
    long long lstride;
    long long ubound;
} VAPAA_PGIF_Dim;

typedef struct {
    long long tag;
    long long rank;
    long long kind;
    long long len;
    long long flags;
    long long lsize;
    long long gsize;
    long long lbase;
    long long *gbase;
    long long *unused;
    VAPAA_PGIF_Dim dim[VAPAA_PGIF_MAXDIMS];
} VAPAA_PGIF_Desc;

int VAPAA_PGIF_is_contiguous(const VAPAA_PGIF_Desc *desc);
int VAPAA_PGIF_is_valid(const VAPAA_PGIF_Desc *desc);
int VAPAA_PGIF_CREATE_DATATYPE(const VAPAA_PGIF_Desc *desc, int count,
                               MPI_Datatype input_datatype,
                               MPI_Datatype *array_datatype);

#endif
