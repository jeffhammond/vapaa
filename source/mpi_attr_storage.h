// SPDX-License-Identifier: MIT

#ifndef MPI_ATTR_STORAGE_H
#define MPI_ATTR_STORAGE_H

#include <stdint.h>

void *VAPAA_MPI_Attr_store_fint(int value);
void *VAPAA_MPI_Attr_store_aint(intptr_t value);
int VAPAA_MPI_Attr_load_fint(void *attrval, int *value);
int VAPAA_MPI_Attr_load_aint(void *attrval, intptr_t *value);
void VAPAA_MPI_Attr_forget(void *attrval);

#endif
