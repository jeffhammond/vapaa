// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdlib.h>
#include <mpi.h>
#include "mpi_attr_storage.h"
#include "debug.h"

enum vapaa_attr_kind {
    VAPAA_ATTR_FINT,
    VAPAA_ATTR_AINT
};

struct vapaa_attr_storage {
    struct vapaa_attr_storage *next;
    void *addr;
    enum vapaa_attr_kind kind;
    union {
        int fint;
        MPI_Aint aint;
    } value;
};

static struct vapaa_attr_storage *attr_head = NULL;

static struct vapaa_attr_storage *attr_find(void *addr)
{
    for (struct vapaa_attr_storage *p = attr_head; p != NULL; p = p->next) {
        if (p->addr == addr) {
            return p;
        }
    }
    return NULL;
}

static void *attr_store(enum vapaa_attr_kind kind, intptr_t value)
{
    struct vapaa_attr_storage *p = malloc(sizeof(*p));
    VAPAA_Assert(p != NULL);
    p->kind = kind;
    if (kind == VAPAA_ATTR_FINT) {
        p->value.fint = (int) value;
        p->addr = &p->value.fint;
    } else {
        p->value.aint = (MPI_Aint) value;
        p->addr = &p->value.aint;
    }
    p->next = attr_head;
    attr_head = p;
    return p->addr;
}

void *VAPAA_MPI_Attr_store_fint(int value)
{
    return attr_store(VAPAA_ATTR_FINT, (intptr_t) value);
}

void *VAPAA_MPI_Attr_store_aint(intptr_t value)
{
    return attr_store(VAPAA_ATTR_AINT, value);
}

int VAPAA_MPI_Attr_load_fint(void *attrval, int *value)
{
    struct vapaa_attr_storage *p = attr_find(attrval);
    if (p == NULL) {
        return 0;
    }
    if (p->kind == VAPAA_ATTR_FINT) {
        *value = (int) p->value.fint;
    } else {
        *value = (int) p->value.aint;
    }
    return 1;
}

int VAPAA_MPI_Attr_load_aint(void *attrval, intptr_t *value)
{
    struct vapaa_attr_storage *p = attr_find(attrval);
    if (p == NULL) {
        return 0;
    }
    if (p->kind == VAPAA_ATTR_FINT) {
        *value = (intptr_t) p->value.fint;
    } else {
        *value = (intptr_t) p->value.aint;
    }
    return 1;
}

void VAPAA_MPI_Attr_forget(void *attrval)
{
    struct vapaa_attr_storage **prev = &attr_head;
    for (struct vapaa_attr_storage *p = attr_head; p != NULL; p = p->next) {
        if (p->addr == attrval) {
            *prev = p->next;
            free(p);
            return;
        }
        prev = &p->next;
    }
}
