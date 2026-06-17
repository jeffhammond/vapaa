// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"
#include "vapaa_constants.h"

void VAPAA_MPI_Comm_group(int *comm_f, int *group_f, int *ierror)
{
    MPI_Group group = MPI_GROUP_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_group(comm, &group);
    *group_f = C_MPI_GROUP_TOINT(group);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_remote_group(int *comm_f, int *group_f, int *ierror)
{
    MPI_Group group = MPI_GROUP_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_remote_group(comm, &group);
    *group_f = C_MPI_GROUP_TOINT(group);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_remote_size(int *comm_f, int *size, int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_remote_size(comm, size);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_test_inter(int *comm_f, int *flag, int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_test_inter(comm, flag);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_get_info(int *comm_f, int *info_f, int *ierror)
{
    MPI_Info info = MPI_INFO_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_get_info(comm, &info);
    *info_f = C_MPI_INFO_TOINT(info);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_set_info(int *comm_f, int *info_f, int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Comm_set_info(comm, info);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_get_parent(int *parent_f, int *ierror)
{
    MPI_Comm parent = MPI_COMM_NULL;
    *ierror = MPI_Comm_get_parent(&parent);
    *parent_f = C_MPI_COMM_TOINT(parent);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_disconnect(int *comm_f, int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_disconnect(&comm);
    *comm_f = C_MPI_COMM_TOINT(comm);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Intercomm_create(int *local_comm_f, int *local_leader, int *peer_comm_f, int *remote_leader,
                                int *tag, int *newintercomm_f, int *ierror)
{
    MPI_Comm newintercomm = MPI_COMM_NULL;
    MPI_Comm local_comm = C_MPI_COMM_FROMINT(*local_comm_f);
    MPI_Comm peer_comm = C_MPI_COMM_FROMINT(*peer_comm_f);
    *ierror = MPI_Intercomm_create(local_comm, *local_leader, peer_comm, *remote_leader, *tag, &newintercomm);
    *newintercomm_f = C_MPI_COMM_TOINT(newintercomm);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Intercomm_merge(int *intercomm_f, int *high, int *newintracomm_f, int *ierror)
{
    MPI_Comm newintracomm = MPI_COMM_NULL;
    MPI_Comm intercomm = C_MPI_COMM_FROMINT(*intercomm_f);
    *ierror = MPI_Intercomm_merge(intercomm, *high, &newintracomm);
    *newintracomm_f = C_MPI_COMM_TOINT(newintracomm);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_join(int *fd, int *intercomm_f, int *ierror)
{
    MPI_Comm intercomm = MPI_COMM_NULL;
    *ierror = MPI_Comm_join(*fd, &intercomm);
    *intercomm_f = C_MPI_COMM_TOINT(intercomm);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_delete_attr(int *comm_f, int *keyval, int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_delete_attr(comm, *keyval);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_free_keyval(int *keyval, int *ierror)
{
    *ierror = MPI_Comm_free_keyval(keyval);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_get_attr(int *comm_f, int *keyval, intptr_t *attrval_f, int *flag, int *ierror)
{
    void *attrval = NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_get_attr(comm, C_MPI_COMM_ATTR_GLOBAL_F2C(*keyval), &attrval, flag);
    *attrval_f = (intptr_t) attrval;
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_set_attr(int *comm_f, int *keyval, intptr_t *attrval_f, int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_set_attr(comm, *keyval, (void *) *attrval_f);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_detach_buffer(int *comm_f, void **buffer_addr, int *size, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_detach_buffer(comm, buffer_addr, size);
#else
    (void) comm_f;
    *buffer_addr = NULL;
    *size = 0;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_detach_buffer_c(int *comm_f, void **buffer_addr, int64_t *size_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Count size = 0;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_detach_buffer_c(comm, buffer_addr, &size);
    *size_f = (int64_t) size;
#else
    (void) comm_f;
    *buffer_addr = NULL;
    *size_f = 0;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_flush_buffer(int *comm_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_flush_buffer(comm);
#else
    (void) comm_f;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_iflush_buffer(int *comm_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
#if MPI_VERSION >= 4
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_iflush_buffer(comm, &request);
#else
    (void) comm_f;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
static char *VAPAA_CFI_CHAR(CFI_cdesc_t *desc)
{
    return (char *) desc->base_addr;
}

void VAPAA_MPI_Comm_get_name(int *comm_f, CFI_cdesc_t *name_d, int *resultlen, int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_get_name(comm, VAPAA_CFI_CHAR(name_d), resultlen);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_set_name(int *comm_f, CFI_cdesc_t *name_d, int *ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_set_name(comm, VAPAA_CFI_CHAR(name_d));
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_create_from_group(int *group_f, CFI_cdesc_t *stringtag_d, int *info_f, int *errhandler_f,
                                      int *newcomm_f, int *ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
#if MPI_VERSION >= 4
    MPI_Group group = C_MPI_GROUP_FROMINT(*group_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    MPI_Errhandler errhandler = C_MPI_ERRHANDLER_FROMINT(*errhandler_f);
    *ierror = MPI_Comm_create_from_group(group, VAPAA_CFI_CHAR(stringtag_d), info, errhandler, &newcomm);
#else
    (void) group_f;
    (void) stringtag_d;
    (void) info_f;
    (void) errhandler_f;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Intercomm_create_from_groups(int *local_group_f, int *local_leader, int *remote_group_f,
                                            int *remote_leader, CFI_cdesc_t *stringtag_d, int *info_f,
                                            int *errhandler_f, int *newintercomm_f, int *ierror)
{
    MPI_Comm newintercomm = MPI_COMM_NULL;
#if MPI_VERSION >= 4
    MPI_Group local_group = C_MPI_GROUP_FROMINT(*local_group_f);
    MPI_Group remote_group = C_MPI_GROUP_FROMINT(*remote_group_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    MPI_Errhandler errhandler = C_MPI_ERRHANDLER_FROMINT(*errhandler_f);
    *ierror = MPI_Intercomm_create_from_groups(local_group, *local_leader, remote_group, *remote_leader,
                                               VAPAA_CFI_CHAR(stringtag_d), info, errhandler, &newintercomm);
#else
    (void) local_group_f;
    (void) local_leader;
    (void) remote_group_f;
    (void) remote_leader;
    (void) stringtag_d;
    (void) info_f;
    (void) errhandler_f;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    *newintercomm_f = C_MPI_COMM_TOINT(newintercomm);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_attach_buffer(int *comm_f, CFI_cdesc_t *buffer, int *size, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_attach_buffer(comm, buffer->base_addr, *size);
#else
    (void) comm_f;
    (void) buffer;
    (void) size;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_attach_buffer_c(int *comm_f, CFI_cdesc_t *buffer, int64_t *size, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_attach_buffer_c(comm, buffer->base_addr, (MPI_Count) *size);
#else
    (void) comm_f;
    (void) buffer;
    (void) size;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Open_port(int *info_f, CFI_cdesc_t *port_name_d, int *ierror)
{
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Open_port(info, VAPAA_CFI_CHAR(port_name_d));
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Close_port(CFI_cdesc_t *port_name_d, int *ierror)
{
    *ierror = MPI_Close_port(VAPAA_CFI_CHAR(port_name_d));
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_accept(CFI_cdesc_t *port_name_d, int *info_f, int *root, int *comm_f, int *newcomm_f, int *ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Comm_accept(VAPAA_CFI_CHAR(port_name_d), info, C_MPI_ROOT_F2C(*root), comm, &newcomm);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Comm_connect(CFI_cdesc_t *port_name_d, int *info_f, int *root, int *comm_f, int *newcomm_f, int *ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Comm_connect(VAPAA_CFI_CHAR(port_name_d), info, C_MPI_ROOT_F2C(*root), comm, &newcomm);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Lookup_name(CFI_cdesc_t *service_name_d, int *info_f, CFI_cdesc_t *port_name_d, int *ierror)
{
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Lookup_name(VAPAA_CFI_CHAR(service_name_d), info, VAPAA_CFI_CHAR(port_name_d));
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Publish_name(CFI_cdesc_t *service_name_d, int *info_f, CFI_cdesc_t *port_name_d, int *ierror)
{
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Publish_name(VAPAA_CFI_CHAR(service_name_d), info, VAPAA_CFI_CHAR(port_name_d));
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Unpublish_name(CFI_cdesc_t *service_name_d, int *info_f, CFI_cdesc_t *port_name_d, int *ierror)
{
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Unpublish_name(VAPAA_CFI_CHAR(service_name_d), info, VAPAA_CFI_CHAR(port_name_d));
    C_MPI_RC_FIX(*ierror);
}
#endif

void VAPAA_MPI_Session_init(int *info_f, int *errhandler_f, int *session_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Session session = MPI_SESSION_NULL;
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    MPI_Errhandler errhandler = C_MPI_ERRHANDLER_FROMINT(*errhandler_f);
    *ierror = MPI_Session_init(info, errhandler, &session);
    *session_f = C_MPI_SESSION_TOINT(session);
#else
    (void) info_f;
    (void) errhandler_f;
    *session_f = VAPAA_MPI_SESSION_NULL;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Session_finalize(int *session_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f);
    *ierror = MPI_Session_finalize(&session);
    *session_f = C_MPI_SESSION_TOINT(session);
#else
    *session_f = VAPAA_MPI_SESSION_NULL;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Session_get_info(int *session_f, int *info_f, int *ierror)
{
    MPI_Info info = MPI_INFO_NULL;
#if MPI_VERSION >= 4
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f);
    *ierror = MPI_Session_get_info(session, &info);
#else
    (void) session_f;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    *info_f = C_MPI_INFO_TOINT(info);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Session_get_num_psets(int *session_f, int *info_f, int *npset_names, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Session_get_num_psets(session, info, npset_names);
#else
    (void) session_f;
    (void) info_f;
    *npset_names = 0;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void VAPAA_MPI_Session_get_nth_pset(int *session_f, int *info_f, int *n, int *pset_len, CFI_cdesc_t *pset_name_d, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Session_get_nth_pset(session, info, *n, pset_len, VAPAA_CFI_CHAR(pset_name_d));
#else
    (void) session_f;
    (void) info_f;
    (void) n;
    (void) pset_name_d;
    *pset_len = 0;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Session_get_pset_info(int *session_f, CFI_cdesc_t *pset_name_d, int *info_f, int *ierror)
{
    MPI_Info info = MPI_INFO_NULL;
#if MPI_VERSION >= 4
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f);
    *ierror = MPI_Session_get_pset_info(session, VAPAA_CFI_CHAR(pset_name_d), &info);
#else
    (void) session_f;
    (void) pset_name_d;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    *info_f = C_MPI_INFO_TOINT(info);
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Session_attach_buffer(int *session_f, CFI_cdesc_t *buffer, int *size, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f);
    *ierror = MPI_Session_attach_buffer(session, buffer->base_addr, *size);
#else
    (void) session_f;
    (void) buffer;
    (void) size;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Session_attach_buffer_c(int *session_f, CFI_cdesc_t *buffer, int64_t *size, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f);
    *ierror = MPI_Session_attach_buffer_c(session, buffer->base_addr, (MPI_Count) *size);
#else
    (void) session_f;
    (void) buffer;
    (void) size;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}
#endif

void VAPAA_MPI_Session_detach_buffer(int *session_f, void **buffer_addr, int *size, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f);
    *ierror = MPI_Session_detach_buffer(session, buffer_addr, size);
#else
    (void) session_f;
    *buffer_addr = NULL;
    *size = 0;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Session_detach_buffer_c(int *session_f, void **buffer_addr, int64_t *size_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Count size = 0;
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f);
    *ierror = MPI_Session_detach_buffer_c(session, buffer_addr, &size);
    *size_f = (int64_t) size;
#else
    (void) session_f;
    *buffer_addr = NULL;
    *size_f = 0;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Session_flush_buffer(int *session_f, int *ierror)
{
#if MPI_VERSION >= 4
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f);
    *ierror = MPI_Session_flush_buffer(session);
#else
    (void) session_f;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    C_MPI_RC_FIX(*ierror);
}

void VAPAA_MPI_Session_iflush_buffer(int *session_f, int *request_f, int *ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
#if MPI_VERSION >= 4
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f);
    *ierror = MPI_Session_iflush_buffer(session, &request);
#else
    (void) session_f;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
#endif
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}
