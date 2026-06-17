// SPDX-License-Identifier: MIT

#include <stdlib.h>
#include <mpi.h>
#include "convert_handles.h"
#include "convert_constants.h"
#include "detect_sentinels.h"

void C_MPI_Request_get_status(const int * request_f, int * flag_f, struct F_MPI_Status * status_f, int * ierror)
{
    int flag;
    MPI_Request request = C_MPI_REQUEST_FROMINT(*request_f);
    if (C_IS_MPI_STATUS_IGNORE(status_f)) {
        *ierror = MPI_Request_get_status(request, &flag, MPI_STATUS_IGNORE);
    } else {
        MPI_Status status;
        *ierror = MPI_Request_get_status(request, &flag, &status);
        C_MPI_STATUS_FROM_C(&status, status_f);
    }
    *flag_f = flag;
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Request_get_status_all(int * count, int requests_f[], int * flag_f,
                                  struct F_MPI_Status statuses_f[], int * ierror)
{
    MPI_Request *requests = malloc((size_t) *count * sizeof(MPI_Request));
    if (requests == NULL) {
        *ierror = MPI_ERR_OTHER;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    for (int i = 0; i < *count; i++) {
        requests[i] = C_MPI_REQUEST_FROMINT(requests_f[i]);
    }

#if MPI_VERSION >= 4
    if (C_IS_MPI_STATUSES_IGNORE(statuses_f)) {
        *ierror = MPI_Request_get_status_all(*count, requests, flag_f, MPI_STATUSES_IGNORE);
    } else {
        MPI_Status *statuses = malloc((size_t) *count * sizeof(MPI_Status));
        if (statuses == NULL) {
            free(requests);
            *ierror = MPI_ERR_OTHER;
            C_MPI_RC_FIX(*ierror);
            return;
        }
        *ierror = MPI_Request_get_status_all(*count, requests, flag_f, statuses);
        if (*ierror == MPI_SUCCESS) {
            for (int i = 0; i < *count; i++) {
                C_MPI_STATUS_FROM_C(&statuses[i], &statuses_f[i]);
            }
        }
        free(statuses);
    }
#else
    *flag_f = 0;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif

    free(requests);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Request_get_status_any(int * count, int requests_f[], int * index_f, int * flag_f,
                                  struct F_MPI_Status * status_f, int * ierror)
{
    MPI_Request *requests = malloc((size_t) *count * sizeof(MPI_Request));
    if (requests == NULL) {
        *ierror = MPI_ERR_OTHER;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    for (int i = 0; i < *count; i++) {
        requests[i] = C_MPI_REQUEST_FROMINT(requests_f[i]);
    }

#if MPI_VERSION >= 4
    int index;
    if (C_IS_MPI_STATUS_IGNORE(status_f)) {
        *ierror = MPI_Request_get_status_any(*count, requests, &index, flag_f, MPI_STATUS_IGNORE);
    } else {
        MPI_Status status;
        *ierror = MPI_Request_get_status_any(*count, requests, &index, flag_f, &status);
        if (*ierror == MPI_SUCCESS) {
            C_MPI_STATUS_FROM_C(&status, status_f);
        }
    }
    *index_f = C_MPI_UNDEFINED_C2F(index);
#else
    *index_f = VAPAA_MPI_UNDEFINED;
    *flag_f = 0;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif

    free(requests);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Request_get_status_some(int * incount, int requests_f[], int * outcount_f,
                                   int indices[], struct F_MPI_Status statuses_f[], int * ierror)
{
    MPI_Request *requests = malloc((size_t) *incount * sizeof(MPI_Request));
    if (requests == NULL) {
        *ierror = MPI_ERR_OTHER;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    for (int i = 0; i < *incount; i++) {
        requests[i] = C_MPI_REQUEST_FROMINT(requests_f[i]);
    }

#if MPI_VERSION >= 4
    if (C_IS_MPI_STATUSES_IGNORE(statuses_f)) {
        *ierror = MPI_Request_get_status_some(*incount, requests, outcount_f, indices, MPI_STATUSES_IGNORE);
    } else {
        MPI_Status *statuses = malloc((size_t) *incount * sizeof(MPI_Status));
        if (statuses == NULL) {
            free(requests);
            *ierror = MPI_ERR_OTHER;
            C_MPI_RC_FIX(*ierror);
            return;
        }
        *ierror = MPI_Request_get_status_some(*incount, requests, outcount_f, indices, statuses);
        if (*ierror == MPI_SUCCESS && *outcount_f > 0) {
            for (int i = 0; i < *outcount_f; i++) {
                C_MPI_STATUS_FROM_C(&statuses[i], &statuses_f[i]);
            }
        }
        free(statuses);
    }
#else
    *outcount_f = VAPAA_MPI_UNDEFINED;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif

    free(requests);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Request_free(int * request_f, int * ierror)
{
    MPI_Request request = C_MPI_REQUEST_FROMINT(*request_f);
    *ierror = MPI_Request_free(&request);
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Cancel(const int * request_f, int * ierror)
{
    MPI_Request request = C_MPI_REQUEST_FROMINT(*request_f);
    *ierror = MPI_Cancel(&request);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Start(int * request_f, int * ierror)
{
    MPI_Request request = C_MPI_REQUEST_FROMINT(*request_f);
    *ierror = MPI_Start(&request);
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Startall(int * count, int requests_f[], int * ierror)
{
    MPI_Request *requests = malloc((size_t) *count * sizeof(MPI_Request));
    if (requests == NULL) {
        *ierror = MPI_ERR_OTHER;
        C_MPI_RC_FIX(*ierror);
        return;
    }

    for (int i = 0; i < *count; i++) {
        requests[i] = C_MPI_REQUEST_FROMINT(requests_f[i]);
    }
    *ierror = MPI_Startall(*count, requests);
    for (int i = 0; i < *count; i++) {
        requests_f[i] = C_MPI_REQUEST_TOINT(requests[i]);
    }

    free(requests);
    C_MPI_RC_FIX(*ierror);
}
