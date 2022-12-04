#include <mpi.h>
#include "mpi_handle_conversions.h"
#include "mpi_constant_conversions.h"

// STANDARD STUFF

void C_MPI_Group_rank(int * group_f, int * rank, int * ierror)
{
    MPI_Group group = C_MPI_GROUP_F2C(*group_f);
    *ierror = MPI_Group_rank(group, rank);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_size(int * group_f, int * size, int * ierror)
{
    MPI_Group group = C_MPI_GROUP_F2C(*group_f);
    *ierror = MPI_Group_size(group, size);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_translate_ranks(int * group1_f, int * n, int * ranks1, int * group2_f, int * ranks2, int * ierror)
{
    MPI_Group group1 = C_MPI_GROUP_F2C(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_F2C(*group2_f);
    *ierror = MPI_Group_translate_ranks(group1, *n, ranks1, group2, ranks2);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_compare(int * group1_f, int * group2_f, int * result_f, int * ierror)
{
    MPI_Group group1 = C_MPI_GROUP_F2C(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_F2C(*group2_f);
    int result;
    *ierror = MPI_Group_compare(group1, group2, &result);
    *result_f = C_MPI_COMPARE_RESULT_F2C(result);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_group(int * comm_f, int * group_f, int * ierror)
{
    MPI_Group group = MPI_GROUP_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Comm_group(comm, &group);
    *group_f = MPI_Group_c2f(group);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_union(int * group1_f, int * group2_f, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group1 = C_MPI_GROUP_F2C(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_F2C(*group2_f);
    *ierror = MPI_Group_union(group1, group2, &newgroup);
    *newgroup_f = MPI_Group_c2f(newgroup);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_intersection(int * group1_f, int * group2_f, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group1 = C_MPI_GROUP_F2C(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_F2C(*group2_f);
    *ierror = MPI_Group_intersection(group1, group2, &newgroup);
    *newgroup_f = MPI_Group_c2f(newgroup);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_difference(int * group1_f, int * group2_f, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group1 = C_MPI_GROUP_F2C(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_F2C(*group2_f);
    *ierror = MPI_Group_difference(group1, group2, &newgroup);
    *newgroup_f = MPI_Group_c2f(newgroup);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_incl(int * group_f, int * n, int * ranks, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group = C_MPI_GROUP_F2C(*group_f);
    *ierror = MPI_Group_incl(group, *n, ranks, &newgroup);
    *newgroup_f = MPI_Group_c2f(newgroup);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Group_excl(int * group_f, int * n, int * ranks, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group = C_MPI_GROUP_F2C(*group_f);
    *ierror = MPI_Group_excl(group, *n, ranks, &newgroup);
    *newgroup_f = MPI_Group_c2f(newgroup);
    C_MPI_RC_FIX(*ierror);
}

// TODO
// MPI_Group_range_incl
// MPI_Group_range_excl
// MPI_Group_from_session_pset

void C_MPI_Group_free(int * group_f, int * ierror)
{
    MPI_Group group = C_MPI_GROUP_F2C(*group_f);
    *ierror = MPI_Group_free(&group);
    *group_f = MPI_Group_c2f(group);
    C_MPI_RC_FIX(*ierror);
}
