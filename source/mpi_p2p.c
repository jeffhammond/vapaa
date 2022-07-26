#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "detect_sentinels.h"
#include "convert_handles.h"
#include "convert_constants.h"

// STANDARD STUFF

void C_MPI_Probe(const int * source, const int * tag, const int * comm_f, MPI_Status * status, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Probe(C_MPI_PROC_NULL_DETECTOR(*source), *tag, comm,
                        C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Mprobe(const int * source, const int * tag, const int * comm_f, int * message_f, MPI_Status * status, int * ierror)
{
    MPI_Message message;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Mprobe(C_MPI_PROC_NULL_DETECTOR(*source), *tag, comm, &message,
                         C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    *message_f = MPI_Message_c2f(message);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Test(int * request_f, int * flag, MPI_Status * status, int * ierror)
{
    // Request is inout so we have to convert before and after
    MPI_Request request = C_MPI_REQUEST_F2C(*request_f);
    *ierror = MPI_Test(&request, flag,
                       C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Testall(const int * count_f, int requests_f[], int * flag_f, MPI_Status statuses[], int * ierror)
{
    const int count = *count_f;
    int flag;

    MPI_Request * requests = malloc( count * sizeof(MPI_Request) );
    if (requests == NULL) {
        *ierror = MPI_ERR_OTHER;
        C_MPI_RC_FIX(*ierror);
        return;
    }

    for (int i=0; i<count; i++) {
        requests[i] = C_MPI_REQUEST_F2C(requests_f[i]);
    }
    *ierror = MPI_Testall(count, requests, &flag,
                          C_IS_MPI_STATUSES_IGNORE(statuses) ? MPI_STATUSES_IGNORE : statuses);
    for (int i=0; i<count; i++) {
        requests_f[i] = MPI_Request_c2f(requests[i]);
    }

    *flag_f  = flag;

    free(requests);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Testsome(const int * incount_f, int requests_f[], int * outcount_f, int array_of_indices[], MPI_Status statuses[], int * ierror)
{
    const int incount = *incount_f;
    int outcount;

    MPI_Request * requests = malloc( incount * sizeof(MPI_Request) );
    if (requests == NULL) {
        *ierror = MPI_ERR_OTHER;
        C_MPI_RC_FIX(*ierror);
        return;
    }

    for (int i=0; i<incount; i++) {
        requests[i] = C_MPI_REQUEST_F2C(requests_f[i]);
    }
    *ierror = MPI_Testsome(incount, requests, &outcount, array_of_indices,
                           C_IS_MPI_STATUSES_IGNORE(statuses) ? MPI_STATUSES_IGNORE : statuses);
    for (int i=0; i<incount; i++) {
        requests_f[i] = MPI_Request_c2f(requests[i]);
    }

    *outcount_f = outcount;

    free(requests);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Testany(const int * count_f, int requests_f[], int * index_f, int * flag_f, MPI_Status * status, int * ierror)
{
    const int count = *count_f;
    int index, flag;

    MPI_Request * requests = malloc( count * sizeof(MPI_Request) );
    if (requests == NULL) {
        *ierror = MPI_ERR_OTHER;
        return;
    }

    for (int i=0; i<count; i++) {
        requests[i] = C_MPI_REQUEST_F2C(requests_f[i]);
    }
    *ierror = MPI_Testany(count, requests, &index, &flag,
                          C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    for (int i=0; i<count; i++) {
        requests_f[i] = MPI_Request_c2f(requests[i]);
    }

    *index_f = index;
    *flag_f  = flag;

    free(requests);
}

void C_MPI_Wait(int * request_f, MPI_Status * status, int * ierror)
{
    // Request is inout so we have to convert before and after
    MPI_Request request = C_MPI_REQUEST_F2C(*request_f);
    *ierror = MPI_Wait(&request, 
                       C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Waitall(const int * count_f, int requests_f[], MPI_Status statuses[], int * ierror)
{
    const int count = *count_f;

    MPI_Request * requests = malloc( count * sizeof(MPI_Request) );
    if (requests == NULL) {
        *ierror = MPI_ERR_OTHER;
        C_MPI_RC_FIX(*ierror);
        return;
    }

    for (int i=0; i<count; i++) {
        requests[i] = C_MPI_REQUEST_F2C(requests_f[i]);
    }
    *ierror = MPI_Waitall(count, requests,
                          C_IS_MPI_STATUSES_IGNORE(statuses) ? MPI_STATUSES_IGNORE : statuses);
    for (int i=0; i<count; i++) {
        requests_f[i] = MPI_Request_c2f(requests[i]);
    }

    free(requests);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Waitsome(const int * incount_f, int requests_f[], int * outcount_f, int array_of_indices[], MPI_Status statuses[], int * ierror)
{
    const int incount = *incount_f;
    int outcount;

    MPI_Request * requests = malloc( incount * sizeof(MPI_Request) );
    if (requests == NULL) {
        *ierror = MPI_ERR_OTHER;
        C_MPI_RC_FIX(*ierror);
        return;
    }

    for (int i=0; i<incount; i++) {
        requests[i] = C_MPI_REQUEST_F2C(requests_f[i]);
    }
    *ierror = MPI_Waitsome(incount, requests, &outcount, array_of_indices,
                           C_IS_MPI_STATUSES_IGNORE(statuses) ? MPI_STATUSES_IGNORE : statuses);
    for (int i=0; i<incount; i++) {
        requests_f[i] = MPI_Request_c2f(requests[i]);
    }

    *outcount_f = outcount;

    free(requests);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Waitany(const int * count_f, int requests_f[], int * index_f, MPI_Status * status, int * ierror)
{
    const int count = *count_f;
    int index;

    MPI_Request * requests = malloc( count * sizeof(MPI_Request) );
    if (requests == NULL) {
        *ierror = MPI_ERR_OTHER;
        C_MPI_RC_FIX(*ierror);
        return;
    }

    for (int i=0; i<count; i++) {
        requests[i] = C_MPI_REQUEST_F2C(requests_f[i]);
    }
    *ierror = MPI_Waitany(count, requests, &index,
                          C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    for (int i=0; i<count; i++) {
        requests_f[i] = MPI_Request_c2f(requests[i]);
    }

    *index_f = index;

    free(requests);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Send(void * buffer, int * count, int * datatype_f, int * dest, int * tag, int * comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Send(buffer, *count, datatype, *dest, *tag, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Send(CFI_cdesc_t * desc, int * count, int * datatype_f, int * dest, int * tag, int * comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Send(desc->base_addr, *count, datatype, *dest, *tag, comm);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Isend(void * buffer, int * count, int * datatype_f, int * dest, int * tag, int * comm_f, int * request_f, int * ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Isend(buffer, *count, datatype, *dest, *tag, comm, &request);
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Isend(CFI_cdesc_t * desc, int * count, int * datatype_f, int * dest, int * tag, int * comm_f, int * request_f, int * ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Isend(desc->base_addr, *count, datatype, *dest, *tag, comm, &request);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}
#endif

/* DESIGN NOTE
 * We do not need to convert the status object because we define it
 * such that no conversion should be necessary.
 */

void C_MPI_Recv(void * buffer, int * count, int * datatype_f, int * source, int *tag, int * comm_f, MPI_Status * status, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Recv(buffer, *count, datatype, *source, *tag, comm,
                       C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Recv(CFI_cdesc_t * desc, int * count, int * datatype_f, int * source, int * tag, int * comm_f, MPI_Status * status, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Recv(desc->base_addr, *count, datatype, *source, *tag, comm,
                           C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Irecv(void * buffer, int * count, int * datatype_f, int * source, int *tag, int * comm_f, int * request_f, int * ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Irecv(buffer, *count, datatype, *source, *tag, comm, &request);
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Irecv(CFI_cdesc_t * desc, int * count, int * datatype_f, int * source, int * tag, int * comm_f, int * request_f, int * ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Irecv(desc->base_addr, *count, datatype, *source, *tag, comm, &request);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(comm, 99);
    }
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Mrecv(void * buffer, int * count, int * datatype_f, int * message_f, MPI_Status * status, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Message  message  = C_MPI_MESSAGE_F2C(*message_f);
    *ierror = MPI_Mrecv(buffer, *count, datatype, &message,
                        C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Mrecv(CFI_cdesc_t * desc, int * count, int * datatype_f, int * message_f, MPI_Status * status, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Message  message  = C_MPI_MESSAGE_F2C(*message_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Mrecv(desc->base_addr, *count, datatype, &message,
                            C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(MPI_COMM_SELF, 99);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Imrecv(void * buffer, int * count, int * datatype_f, int * message_f, int * request_f, int * ierror)
{
    MPI_Request  request  = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Message  message  = C_MPI_MESSAGE_F2C(*message_f);
    *ierror = MPI_Imrecv(buffer, *count, datatype, &message, &request);
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Imrecv(CFI_cdesc_t * desc, int * count, int * datatype_f, int * message_f, int * request_f, int * ierror)
{
    MPI_Request  request  = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(*datatype_f);
    MPI_Message  message  = C_MPI_MESSAGE_F2C(*message_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Imrecv(desc->base_addr, *count, datatype, &message, &request);
    } else {
        fprintf(stderr, "FIXME: not contiguous case\n");
        MPI_Abort(MPI_COMM_SELF, 99);
    }
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}
#endif

