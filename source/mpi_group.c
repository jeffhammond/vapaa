#include <mpi.h>
#include "mpi_handle_conversions.h"

// STANDARD STUFF

void C_MPI_Group_rank(int * group_f, int * rank, int * ierror)
{
    MPI_Group group = C_MPI_GROUP_F2C(*group_f);
    *ierror = MPI_Group_rank(group, rank);
}

void C_MPI_Group_size(int * group_f, int * size, int * ierror)
{
    MPI_Group group = C_MPI_GROUP_F2C(*group_f);
    *ierror = MPI_Group_size(group, size);
}

void C_MPI_Group_translate_ranks(int * group1_f, int * n, int * ranks1, int * group2_f, int * ranks2, int * ierror)
{
    MPI_Group group1 = C_MPI_GROUP_F2C(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_F2C(*group2_f);
    *ierror = MPI_Group_translate_ranks(group1, *n, ranks1, group2, ranks2);
}

void C_MPI_Group_compare(int * group1_f, int * group2_f, int * result_f, int * ierror)
{
    MPI_Group group1 = C_MPI_GROUP_F2C(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_F2C(*group2_f);
    int result;
    *ierror = MPI_Group_compare(group1, group2, &result);
    // translate from the values in the C library
    // to the ones we use (mpi_global_constants.F90)
    if (result == MPI_IDENT) {
        *result_f = 0;
    } else
    if (result == MPI_CONGRUENT) {
        *result_f = 1;
    } else
    if (result == MPI_SIMILAR) {
        *result_f = 2;
    } else
    if (result == MPI_UNEQUAL) {
        *result_f = 3;
    }
}

void C_MPI_Comm_group(int * comm_f, int * group_f, int * ierror)
{
    MPI_Group group = MPI_GROUP_NULL;
    MPI_Comm comm = C_MPI_COMM_F2C(*comm_f);
    *ierror = MPI_Comm_group(comm, &group);
    *group_f = MPI_Group_c2f(group);
}

void C_MPI_Group_union(int * group1_f, int * group2_f, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group1 = C_MPI_GROUP_F2C(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_F2C(*group2_f);
    *ierror = MPI_Group_union(group1, group2, &newgroup);
    *newgroup_f = MPI_Group_c2f(newgroup);
}

void C_MPI_Group_intersection(int * group1_f, int * group2_f, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group1 = C_MPI_GROUP_F2C(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_F2C(*group2_f);
    *ierror = MPI_Group_intersection(group1, group2, &newgroup);
    *newgroup_f = MPI_Group_c2f(newgroup);
}

void C_MPI_Group_difference(int * group1_f, int * group2_f, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group1 = C_MPI_GROUP_F2C(*group1_f);
    MPI_Group group2 = C_MPI_GROUP_F2C(*group2_f);
    *ierror = MPI_Group_difference(group1, group2, &newgroup);
    *newgroup_f = MPI_Group_c2f(newgroup);
}

void C_MPI_Group_incl(int * group_f, int * n, int * ranks, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group = C_MPI_GROUP_F2C(*group_f);
    *ierror = MPI_Group_incl(group, *n, ranks, &newgroup);
    *newgroup_f = MPI_Group_c2f(newgroup);
}

void C_MPI_Group_excl(int * group_f, int * n, int * ranks, int * newgroup_f, int * ierror)
{
    MPI_Group newgroup = MPI_GROUP_NULL;
    MPI_Group group = C_MPI_GROUP_F2C(*group_f);
    *ierror = MPI_Group_excl(group, *n, ranks, &newgroup);
    *newgroup_f = MPI_Group_c2f(newgroup);
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
}
