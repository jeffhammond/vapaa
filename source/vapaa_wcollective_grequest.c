// SPDX-License-Identifier: MIT

#include "vapaa_wcollective_grequest.h"

#include "vapaa_error_handling.h"

#include <pthread.h>
#include <stdlib.h>
#include <mpi.h>

typedef enum {
    VAPAA_WCOLL_ALLTOALLW,
    VAPAA_WCOLL_NEIGHBOR_ALLTOALLW
} VAPAA_Wcollective_kind;

typedef struct {
    VAPAA_Wcollective_kind kind;
    MPI_Request request;
    pthread_mutex_t lock;
    int rc;

    const void *sendbuf;
    const int *sendcounts;
    const int *sdispls_int;
    MPI_Aint *sdispls_aint;
    MPI_Datatype *sendtypes;

    void *recvbuf;
    const int *recvcounts;
    const int *rdispls_int;
    MPI_Aint *rdispls_aint;
    MPI_Datatype *recvtypes;

    MPI_Comm comm;

    int *owned_sendcounts;
    int *owned_sdispls_int;
    MPI_Aint *owned_sdispls_aint;
    MPI_Datatype *owned_sendtypes;
    MPI_Aint *owned_rdispls_aint;
    MPI_Datatype *owned_recvtypes;
} VAPAA_Wcollective_request;

static void VAPAA_Wcollective_free_state(VAPAA_Wcollective_request *state)
{
    if (state == NULL) {
        return;
    }
    free(state->owned_sendcounts);
    free(state->owned_sdispls_int);
    free(state->owned_sdispls_aint);
    free(state->owned_sendtypes);
    free(state->owned_rdispls_aint);
    free(state->owned_recvtypes);
    free(state);
}

static int VAPAA_Wcollective_get_rc(VAPAA_Wcollective_request *state)
{
    int rc;
    pthread_mutex_lock(&state->lock);
    rc = state->rc;
    pthread_mutex_unlock(&state->lock);
    return rc;
}

static void VAPAA_Wcollective_set_rc(VAPAA_Wcollective_request *state, int rc)
{
    pthread_mutex_lock(&state->lock);
    state->rc = rc;
    pthread_mutex_unlock(&state->lock);
}

static int VAPAA_Wcollective_perform(VAPAA_Wcollective_request *state)
{
    if (state->kind == VAPAA_WCOLL_ALLTOALLW) {
        return MPI_Alltoallw(state->sendbuf, state->sendcounts,
                             state->sdispls_int, state->sendtypes,
                             state->recvbuf, state->recvcounts,
                             state->rdispls_int, state->recvtypes,
                             state->comm);
    }
    return MPI_Neighbor_alltoallw(state->sendbuf, state->sendcounts,
                                  state->sdispls_aint, state->sendtypes,
                                  state->recvbuf, state->recvcounts,
                                  state->rdispls_aint, state->recvtypes,
                                  state->comm);
}

static int VAPAA_Wcollective_query(void *extra_state, MPI_Status *status)
{
    VAPAA_Wcollective_request *state = extra_state;
    int rc = VAPAA_Wcollective_get_rc(state);
    int status_rc;

    status->MPI_SOURCE = MPI_UNDEFINED;
    status->MPI_TAG = MPI_UNDEFINED;
    status_rc = MPI_Status_set_cancelled(status, 0);
    if (rc == MPI_SUCCESS && status_rc != MPI_SUCCESS) {
        rc = status_rc;
    }
    status_rc = MPI_Status_set_elements(status, MPI_BYTE, 0);
    if (rc == MPI_SUCCESS && status_rc != MPI_SUCCESS) {
        rc = status_rc;
    }
    return rc;
}

static int VAPAA_Wcollective_free(void *extra_state)
{
    VAPAA_Wcollective_request *state = extra_state;
    int rc = VAPAA_Wcollective_get_rc(state);
    pthread_mutex_destroy(&state->lock);
    VAPAA_Wcollective_free_state(state);
    return rc;
}

static int VAPAA_Wcollective_cancel(void *extra_state, int complete)
{
    VAPAA_Wcollective_request *state = extra_state;

    (void) complete;
    (void) MPI_Abort(state->comm, MPI_ERR_REQUEST);
    return MPI_ERR_REQUEST;
}

static void *VAPAA_Wcollective_worker(void *arg)
{
    VAPAA_Wcollective_request *state = arg;
    MPI_Request request = state->request;
    int rc = VAPAA_Wcollective_perform(state);

    VAPAA_Wcollective_set_rc(state, rc);
    (void) MPI_Grequest_complete(request);
    return NULL;
}

static int VAPAA_Wcollective_complete_and_free(MPI_Request *request,
                                               VAPAA_Wcollective_request *state,
                                               int rc)
{
    MPI_Comm comm = state->comm;
    MPI_Request local_request = *request;
    int complete_rc;
    int result;

    VAPAA_Wcollective_set_rc(state, rc);
    complete_rc = MPI_Grequest_complete(local_request);
    if (complete_rc == MPI_SUCCESS) {
        (void) MPI_Request_free(&local_request);
    }
    *request = MPI_REQUEST_NULL;
    result = rc == MPI_SUCCESS ? complete_rc : rc;
    VAPAA_MPI_handle_synthetic_error_comm(comm, &result);
    return result;
}

static int VAPAA_Wcollective_startup_error(VAPAA_Wcollective_request *state,
                                           int rc)
{
    MPI_Comm comm = state->comm;

    VAPAA_MPI_handle_synthetic_error_comm(comm, &rc);
    pthread_mutex_destroy(&state->lock);
    VAPAA_Wcollective_free_state(state);
    return rc;
}

static int VAPAA_Wcollective_start(VAPAA_Wcollective_request *state,
                                   MPI_Request *request)
{
    int rc;
    int provided = MPI_THREAD_SINGLE;

    *request = MPI_REQUEST_NULL;
    rc = pthread_mutex_init(&state->lock, NULL);
    if (rc != 0) {
        VAPAA_Wcollective_free_state(state);
        return MPI_ERR_OTHER;
    }
    state->rc = MPI_SUCCESS;

    rc = MPI_Query_thread(&provided);
    if (rc != MPI_SUCCESS) {
        return VAPAA_Wcollective_startup_error(state, rc);
    }
    if (provided < MPI_THREAD_MULTIPLE) {
        return VAPAA_Wcollective_startup_error(state, MPI_ERR_OTHER);
    }

    rc = MPI_Grequest_start(VAPAA_Wcollective_query,
                            VAPAA_Wcollective_free,
                            VAPAA_Wcollective_cancel,
                            state, request);
    if (rc != MPI_SUCCESS) {
        return VAPAA_Wcollective_startup_error(state, rc);
    }
    state->request = *request;

    pthread_t thread;
    pthread_attr_t attr;
    int pthread_rc = pthread_attr_init(&attr);
    int attr_initialized = (pthread_rc == 0);
    if (pthread_rc == 0) {
        pthread_rc = pthread_attr_setdetachstate(&attr,
                                                 PTHREAD_CREATE_DETACHED);
    }
    if (pthread_rc == 0) {
        pthread_rc = pthread_create(&thread, &attr,
                                    VAPAA_Wcollective_worker, state);
    }
    if (attr_initialized) {
        (void) pthread_attr_destroy(&attr);
    }
    if (pthread_rc != 0) {
        return VAPAA_Wcollective_complete_and_free(request, state,
                                                   MPI_ERR_OTHER);
    }
    return MPI_SUCCESS;
}

int VAPAA_Grequest_alltoallw(const void *sendbuf, const int sendcounts[],
                             const int sdispls[], MPI_Datatype sendtypes[],
                             void *recvbuf, const int recvcounts[],
                             const int rdispls[], MPI_Datatype recvtypes[],
                             MPI_Comm comm, int *owned_sendcounts,
                             int *owned_sdispls, MPI_Datatype *owned_sendtypes,
                             MPI_Datatype *owned_recvtypes,
                             MPI_Request *request)
{
    VAPAA_Wcollective_request *state = calloc(1, sizeof(*state));
    if (state == NULL) {
        free(owned_sendcounts);
        free(owned_sdispls);
        free(owned_sendtypes);
        free(owned_recvtypes);
        *request = MPI_REQUEST_NULL;
        return MPI_ERR_OTHER;
    }

    state->kind = VAPAA_WCOLL_ALLTOALLW;
    state->sendbuf = sendbuf;
    state->sendcounts = sendcounts;
    state->sdispls_int = sdispls;
    state->sendtypes = sendtypes;
    state->recvbuf = recvbuf;
    state->recvcounts = recvcounts;
    state->rdispls_int = rdispls;
    state->recvtypes = recvtypes;
    state->comm = comm;
    state->owned_sendcounts = owned_sendcounts;
    state->owned_sdispls_int = owned_sdispls;
    state->owned_sendtypes = owned_sendtypes;
    state->owned_recvtypes = owned_recvtypes;

    return VAPAA_Wcollective_start(state, request);
}

int VAPAA_Grequest_neighbor_alltoallw(const void *sendbuf,
                                      const int sendcounts[],
                                      MPI_Aint sdispls[],
                                      MPI_Datatype sendtypes[],
                                      void *recvbuf,
                                      const int recvcounts[],
                                      MPI_Aint rdispls[],
                                      MPI_Datatype recvtypes[],
                                      MPI_Comm comm,
                                      MPI_Aint *owned_sdispls,
                                      MPI_Datatype *owned_sendtypes,
                                      MPI_Aint *owned_rdispls,
                                      MPI_Datatype *owned_recvtypes,
                                      MPI_Request *request)
{
    VAPAA_Wcollective_request *state = calloc(1, sizeof(*state));
    if (state == NULL) {
        free(owned_sdispls);
        free(owned_sendtypes);
        free(owned_rdispls);
        free(owned_recvtypes);
        *request = MPI_REQUEST_NULL;
        return MPI_ERR_OTHER;
    }

    state->kind = VAPAA_WCOLL_NEIGHBOR_ALLTOALLW;
    state->sendbuf = sendbuf;
    state->sendcounts = sendcounts;
    state->sdispls_aint = sdispls;
    state->sendtypes = sendtypes;
    state->recvbuf = recvbuf;
    state->recvcounts = recvcounts;
    state->rdispls_aint = rdispls;
    state->recvtypes = recvtypes;
    state->comm = comm;
    state->owned_sdispls_aint = owned_sdispls;
    state->owned_sendtypes = owned_sendtypes;
    state->owned_rdispls_aint = owned_rdispls;
    state->owned_recvtypes = owned_recvtypes;

    return VAPAA_Wcollective_start(state, request);
}
