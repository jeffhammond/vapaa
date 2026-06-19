#ifndef PGIF_UTIL_H
#define PGIF_UTIL_H

#include <stdbool.h>
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

typedef struct {
    void *addr;
    int count;
    MPI_Datatype datatype;
    MPI_Datatype owned_datatype;
} VAPAA_PGIF_Buffer;

int VAPAA_PGIF_is_contiguous(const VAPAA_PGIF_Desc *desc);
int VAPAA_PGIF_is_valid(const VAPAA_PGIF_Desc *desc);
int VAPAA_PGIF_buffer_is_contiguous(const VAPAA_PGIF_Desc *desc);
void *VAPAA_PGIF_ADDR(void *base);
void *VAPAA_PGIF_IN_ADDR(void *base);
int VAPAA_PGIF_PREPARE_BUFFER(void *base, const VAPAA_PGIF_Desc *desc,
                              int count, MPI_Datatype datatype,
                              bool in_place_allowed,
                              VAPAA_PGIF_Buffer *buffer);
int VAPAA_PGIF_RELEASE_BUFFER(VAPAA_PGIF_Buffer *buffer);
int VAPAA_PGIF_CREATE_DATATYPE(const VAPAA_PGIF_Desc *desc, int count,
                               MPI_Datatype input_datatype,
                               MPI_Datatype *array_datatype);

#endif
