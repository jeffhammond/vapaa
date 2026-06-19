// SPDX-License-Identifier: MIT

#include <stdio.h>

#include "pgif_util.h"

void pgif_check_descriptor_(void *base, int *ierror, VAPAA_PGIF_Desc *desc)
{
    int value = base == NULL ? 0 : *(int *) base;

    *ierror = 0;
    if (desc == NULL) {
        *ierror = 1;
    } else if (desc->tag != VAPAA_PGIF_DESCRIPTOR_TAG) {
        *ierror = 2;
    } else if (desc->rank != 2) {
        *ierror = 3;
    } else if (desc->len != (long long) sizeof(int)) {
        *ierror = 4;
    } else if (desc->dim[0].extent != 3 || desc->dim[1].extent != 3) {
        *ierror = 5;
    } else if (desc->dim[0].lstride != 2 || desc->dim[1].lstride != 12) {
        *ierror = 6;
    } else if (value != 12345) {
        *ierror = 7;
    }

    if (*ierror != 0) {
        fprintf(stderr,
                "bad PGI descriptor: err=%d tag=%lld rank=%lld len=%lld "
                "ext=(%lld,%lld) stride=(%lld,%lld) value=%d\n",
                *ierror, desc ? desc->tag : -1, desc ? desc->rank : -1,
                desc ? desc->len : -1, desc ? desc->dim[0].extent : -1,
                desc ? desc->dim[1].extent : -1,
                desc ? desc->dim[0].lstride : -1,
                desc ? desc->dim[1].lstride : -1, value);
    }
}
