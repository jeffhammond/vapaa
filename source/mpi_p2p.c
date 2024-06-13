// SPDX-License-Identifier: MIT

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "detect_sentinels.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "cfi_util.h"
#include "debug.h"

// STANDARD STUFF

void C_MPI_Probe(int source, int tag, int comm_f, struct F_MPI_Status * status_f, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    const bool need_status = C_IS_MPI_STATUS_IGNORE(status_f);
    MPI_Status status;
    *ierror = MPI_Probe(C_MPI_PROC_NULL_DETECTOR(source), tag, comm,
                        need_status ? &status : MPI_STATUS_IGNORE);
    if (need_status) {
        C_MPI_STATUS_C2F(&status, status_f);
    }
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Mprobe(int source, int tag, int comm_f, int * message_f, MPI_Status * status, int * ierror)
{
    MPI_Message message;
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    *ierror = MPI_Mprobe(C_MPI_PROC_NULL_DETECTOR(source), tag, comm, &message,
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

void C_MPI_Testall(int count, int requests_f[], int * flag_f, MPI_Status statuses[], int * ierror)
{
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

void C_MPI_Testsome(int incount, int requests_f[], int * outcount_f, int array_of_indices[], MPI_Status statuses[], int * ierror)
{
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

void C_MPI_Testany(int count, int requests_f[], int * index_f, int * flag_f, MPI_Status * status, int * ierror)
{
    int index, flag;

    MPI_Request * requests = malloc( count * sizeof(MPI_Request) );
    if (requests == NULL) {
        *ierror = MPI_ERR_OTHER;
        C_MPI_RC_FIX(*ierror);
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

void C_MPI_Waitall(int count, int requests_f[], struct F_MPI_Status statuses_f[], int * ierror)
{
    MPI_Request * requests = malloc( count * sizeof(MPI_Request) );
    if (requests == NULL) {
        *ierror = MPI_ERR_OTHER;
        C_MPI_RC_FIX(*ierror);
        return;
    }
    for (int i=0; i<count; i++) {
        requests[i] = C_MPI_REQUEST_F2C(requests_f[i]);
    }

    if ( C_IS_MPI_STATUSES_IGNORE(statuses_f) )
    {
        *ierror = MPI_Waitall(count, requests, MPI_STATUSES_IGNORE);
    }
    else
    {
        MPI_Status * statuses = malloc( count * sizeof(MPI_Status) );
        if (statuses == NULL) {
            *ierror = MPI_ERR_OTHER;
            C_MPI_RC_FIX(*ierror);
            return;
        }
        *ierror = MPI_Waitall(count, requests, statuses);
        for (int i=0; i<count; i++) {
            C_MPI_STATUS_C2F( &statuses[i], &statuses_f[i] );
        }
        free(statuses);
    }

    for (int i=0; i<count; i++) {
        requests_f[i] = MPI_Request_c2f(requests[i]);
    }
    free(requests);

    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Waitsome(int incount, int requests_f[], int * outcount_f, int array_of_indices[], MPI_Status statuses[], int * ierror)
{
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

void C_MPI_Waitany(int count, int requests_f[], int * index_f, MPI_Status * status, int * ierror)
{
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

void C_MPI_Send(void * buffer, int count, int datatype_f, int dest, int tag, int comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    *ierror = MPI_Send(buffer, count, datatype, dest, tag, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Send(CFI_cdesc_t * desc, int count, int datatype_f, int dest, int tag, int comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Send(desc->base_addr, count, datatype, dest, tag, comm);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, count, datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Send(desc->base_addr, 1, subarray_type, dest, tag, comm);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Isend(void * buffer, int count, int datatype_f, int dest, int tag, int comm_f, int * request_f, int * ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    *ierror = MPI_Isend(buffer, count, datatype, dest, tag, comm, &request);
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Isend(CFI_cdesc_t * desc, int count, int datatype_f, int dest, int tag, int comm_f, int * request_f, int * ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Isend(desc->base_addr, count, datatype, dest, tag, comm, &request);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, count, datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Isend(desc->base_addr, 1, subarray_type, dest, tag, comm, &request);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}
#endif

/* DESIGN NOTE
 * We do not need to convert the status object because we define it
 * such that no conversion should be necessary.
 */

void C_MPI_Recv(void * buffer, int count, int datatype_f, int source, int tag, int comm_f, MPI_Status * status, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    *ierror = MPI_Recv(buffer, count, datatype, source, tag, comm,
                       C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Recv(CFI_cdesc_t * desc, int count, int datatype_f, int source, int tag, int comm_f, MPI_Status * status, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Recv(desc->base_addr, count, datatype, source, tag, comm,
                           C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, count, datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Recv(desc->base_addr, 1, subarray_type, source, tag, comm,
                           C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Irecv(void * buffer, int count, int datatype_f, int source, int tag, int comm_f, int * request_f, int * ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    *ierror = MPI_Irecv(buffer, count, datatype, source, tag, comm, &request);
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Irecv(CFI_cdesc_t * desc, int count, int datatype_f, int source, int tag, int comm_f, int * request_f, int * ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Irecv(desc->base_addr, count, datatype, source, tag, comm, &request);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, count, datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Irecv(desc->base_addr, 1, subarray_type, source, tag, comm, &request);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Mrecv(void * buffer, int count, int datatype_f, int * message_f, MPI_Status * status, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Message  message  = C_MPI_MESSAGE_F2C(*message_f);
    *ierror = MPI_Mrecv(buffer, count, datatype, &message,
                        C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Mrecv(CFI_cdesc_t * desc, int count, int datatype_f, int * message_f, MPI_Status * status, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Message  message  = C_MPI_MESSAGE_F2C(*message_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Mrecv(desc->base_addr, count, datatype, &message,
                            C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, count, datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Mrecv(desc->base_addr, 1, subarray_type, &message,
                            C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Imrecv(void * buffer, int count, int datatype_f, int * message_f, int * request_f, int * ierror)
{
    MPI_Request  request  = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Message  message  = C_MPI_MESSAGE_F2C(*message_f);
    *ierror = MPI_Imrecv(buffer, count, datatype, &message, &request);
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Imrecv(CFI_cdesc_t * desc, int count, int datatype_f, int * message_f, int * request_f, int * ierror)
{
    MPI_Request  request  = MPI_REQUEST_NULL;
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Message  message  = C_MPI_MESSAGE_F2C(*message_f);
    if (1 == CFI_is_contiguous(desc)) {
        *ierror = MPI_Imrecv(desc->base_addr, count, datatype, &message, &request);
    } else {
        int rc;
        MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(desc, count, datatype, &subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Imrecv(desc->base_addr, 1, subarray_type, &message, &request);
        rc = PMPI_Type_free(&subarray_type);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Sendrecv(void * sbuffer, int scount, int sdatatype_f, int dest, int stag, 
                    void * rbuffer, int rcount, int rdatatype_f, int src,  int rtag,
                    int comm_f, MPI_Status * status, int * ierror)
{
    MPI_Datatype sdatatype = C_MPI_TYPE_F2C(sdatatype_f);
    MPI_Datatype rdatatype = C_MPI_TYPE_F2C(rdatatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    *ierror = MPI_Sendrecv(sbuffer, scount, sdatatype, dest, stag, 
                           rbuffer, rcount, rdatatype, src,  rtag,
                           comm, C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Sendrecv(CFI_cdesc_t * sdesc, int scount, int sdatatype_f, int dest, int stag, 
                      CFI_cdesc_t * rdesc, int rcount, int rdatatype_f, int src,  int rtag,
                      int comm_f, MPI_Status * status, int * ierror)
{
    MPI_Datatype sdatatype = C_MPI_TYPE_F2C(sdatatype_f);
    MPI_Datatype rdatatype = C_MPI_TYPE_F2C(rdatatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    if ((1 == CFI_is_contiguous(sdesc)) && (1 == CFI_is_contiguous(sdesc))) {
        *ierror = MPI_Sendrecv(sdesc->base_addr, scount, sdatatype, dest, stag, 
                               rdesc->base_addr, rcount, rdatatype, src,  rtag,
                               comm, C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
    } else {
        int rc;
        MPI_Datatype subarray_type_s = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(sdesc, scount, sdatatype, &subarray_type_s);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type_s);
        VAPAA_Assert(rc == MPI_SUCCESS);
        MPI_Datatype subarray_type_r = MPI_DATATYPE_NULL;
        rc = VAPAA_CFI_CREATE_DATATYPE(rdesc, rcount, rdatatype, &subarray_type_r);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_commit(&subarray_type_r);
        VAPAA_Assert(rc == MPI_SUCCESS);
        *ierror = MPI_Sendrecv(sdesc->base_addr, 1, subarray_type_s, dest, stag, 
                               rdesc->base_addr, 1, subarray_type_r, src,  rtag,
                               comm, C_IS_MPI_STATUS_IGNORE(status) ? MPI_STATUS_IGNORE : status);
        rc = PMPI_Type_free(&subarray_type_s);
        VAPAA_Assert(rc == MPI_SUCCESS);
        rc = PMPI_Type_free(&subarray_type_r);
        VAPAA_Assert(rc == MPI_SUCCESS);
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Pack(void * inbuf, int incount, int datatype_f, void * outbuf, int outsize, int * position, int comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    *ierror = MPI_Pack(inbuf, incount, datatype, outbuf, outsize, position, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Pack(CFI_cdesc_t * indesc, int incount, int datatype_f, CFI_cdesc_t * outdesc, int outsize, int * position, int comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    if (0 == CFI_is_contiguous(outdesc)) {
        VAPAA_Warning("MPI_Pack requires the output buffer be contiguous.\n");
        *ierror = MPI_ERR_ARG;
    } else {
        if (1 == CFI_is_contiguous(indesc)) {
            *ierror = MPI_Pack(indesc->base_addr, incount, datatype, outdesc->base_addr, outsize, position, comm);
        } else {
            int rc;
            MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
            rc = VAPAA_CFI_CREATE_DATATYPE(indesc, incount, datatype, &subarray_type);
            VAPAA_Assert(rc == MPI_SUCCESS);
            rc = PMPI_Type_commit(&subarray_type);
            VAPAA_Assert(rc == MPI_SUCCESS);
            *ierror = MPI_Pack(indesc->base_addr, 1, subarray_type, outdesc->base_addr, outsize, position, comm);
            rc = PMPI_Type_free(&subarray_type);
            VAPAA_Assert(rc == MPI_SUCCESS);
        }
    }
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Unpack(void * inbuf, int insize, int * position, void * outbuf, int outcount,  int datatype_f, int comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    *ierror = MPI_Unpack(inbuf, insize, position, outbuf, outcount, datatype, comm);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Unpack(CFI_cdesc_t * indesc, int insize, int * position, CFI_cdesc_t * outdesc, int outcount,  int datatype_f, int comm_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Comm comm = C_MPI_COMM_F2C(comm_f);
    if (0 == CFI_is_contiguous(indesc)) {
        VAPAA_Warning("MPI_Unpack requires the input buffer be contiguous.\n");
        *ierror = MPI_ERR_ARG;
    } else {
        if (1 == CFI_is_contiguous(outdesc)) {
            *ierror = MPI_Unpack(indesc->base_addr, insize, position, outdesc->base_addr, outcount, datatype, comm);
        } else {
            int rc;
            MPI_Datatype subarray_type = MPI_DATATYPE_NULL;
            rc = VAPAA_CFI_CREATE_DATATYPE(outdesc, outcount, datatype, &subarray_type);
            VAPAA_Assert(rc == MPI_SUCCESS);
            rc = PMPI_Type_commit(&subarray_type);
            VAPAA_Assert(rc == MPI_SUCCESS);
            *ierror = MPI_Unpack(indesc->base_addr, insize, position, outdesc->base_addr, 1, subarray_type, comm);
            rc = PMPI_Type_free(&subarray_type);
            VAPAA_Assert(rc == MPI_SUCCESS);
        }
    }
    C_MPI_RC_FIX(*ierror);
}
#endif
