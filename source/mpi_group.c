// SPDX-License-Identifier: MIT

#include <mpi.h>
#include "convert_handles.h"
#include "convert_constants.h"
#include "vapaa_error_handling.h"

// STANDARD STUFF

void C_MPI_Group_rank(int * group_f, int * rank, int * ierror)
{
    MPI_Group group = C_MPI_GROUP_FROMINT(*group_f);
    *ierror = MPI_Group_rank(group, rank);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_size(int * group_f, int * size, int * ierror)
{
    MPI_Group group = C_MPI_GROUP_FROMINT(*group_f);
    *ierror = MPI_Group_size(group, size);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_translate_ranks(int * group1_f, int * n, int * ranks1, int * group2_f, int * ranks2, int * ierror)
{
    MPI_Group group1 = C_MPI_GROUP_FROMINT(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_FROMINT(*group2_f);
    *ierror = MPI_Group_translate_ranks(group1, *n, ranks1, group2, ranks2);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_compare(int * group1_f, int * group2_f, int * result_f, int * ierror)
{
    MPI_Group group1 = C_MPI_GROUP_FROMINT(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_FROMINT(*group2_f);
    int result;
    *ierror = MPI_Group_compare(group1, group2, &result);
    *result_f = C_MPI_COMPARE_RESULT_C2F(result);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_group(int * comm_f, int * group_f, int * ierror)
{
    MPI_Group group = MPI_GROUP_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_group(comm, &group);
    *group_f = C_MPI_GROUP_TOINT(group);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_union(int * group1_f, int * group2_f, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group1 = C_MPI_GROUP_FROMINT(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_FROMINT(*group2_f);
    *ierror = MPI_Group_union(group1, group2, &newgroup);
    *newgroup_f = C_MPI_GROUP_TOINT(newgroup);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_intersection(int * group1_f, int * group2_f, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group1 = C_MPI_GROUP_FROMINT(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_FROMINT(*group2_f);
    *ierror = MPI_Group_intersection(group1, group2, &newgroup);
    *newgroup_f = C_MPI_GROUP_TOINT(newgroup);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_difference(int * group1_f, int * group2_f, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group1 = C_MPI_GROUP_FROMINT(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_FROMINT(*group2_f);
    *ierror = MPI_Group_difference(group1, group2, &newgroup);
    *newgroup_f = C_MPI_GROUP_TOINT(newgroup);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_incl(int * group_f, int * n, int * ranks, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group = C_MPI_GROUP_FROMINT(*group_f);
    *ierror = MPI_Group_incl(group, *n, ranks, &newgroup);
    *newgroup_f = C_MPI_GROUP_TOINT(newgroup);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_excl(int * group_f, int * n, int * ranks, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group = C_MPI_GROUP_FROMINT(*group_f);
    *ierror = MPI_Group_excl(group, *n, ranks, &newgroup);
    *newgroup_f = C_MPI_GROUP_TOINT(newgroup);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_range_incl(int * group_f, int * n, int ranges_f[][3], int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group = C_MPI_GROUP_FROMINT(*group_f);
    *ierror = MPI_Group_range_incl(group, *n, ranges_f, &newgroup);
    *newgroup_f = C_MPI_GROUP_TOINT(newgroup);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_range_excl(int * group_f, int * n, int ranges_f[][3], int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group = C_MPI_GROUP_FROMINT(*group_f);
    *ierror = MPI_Group_range_excl(group, *n, ranges_f, &newgroup);
    *newgroup_f = C_MPI_GROUP_TOINT(newgroup);
    C_MPI_RC_FIX(*ierror);
}

#if MPI_VERSION >= 4
void C_MPI_Group_from_session_pset(int * session_f, char * pset_name, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Session session = C_MPI_SESSION_FROMINT(*session_f);
    *ierror = MPI_Group_from_session_pset(session, pset_name, &newgroup);
    *newgroup_f = C_MPI_GROUP_TOINT(newgroup);
    C_MPI_RC_FIX(*ierror);
}
#else
void C_MPI_Group_from_session_pset(int * session_f, char * pset_name, int * newgroup_f, int * ierror)
{
    (void) session_f;
    (void) pset_name;
    *newgroup_f = VAPAA_MPI_GROUP_NULL;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    VAPAA_MPI_handle_synthetic_error_no_object(ierror);
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Group_free(int * group_f, int * ierror)
{
    MPI_Group group = C_MPI_GROUP_FROMINT(*group_f);
    *ierror = MPI_Group_free(&group);
    *group_f = C_MPI_GROUP_TOINT(group);
    C_MPI_RC_FIX(*ierror);
}
