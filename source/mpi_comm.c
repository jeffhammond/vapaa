// SPDX-License-Identifier: MIT

#include <mpi.h>
#include "convert_handles.h"
#include "convert_constants.h"
#include "vapaa_constants.h"
#include "detect_sentinels.h"
#include "vapaa_error_handling.h"

static int C_MPI_TRANSLATE_SPLIT_TYPE(int f)
{
    if (f == VAPAA_MPI_COMM_TYPE_SHARED) {
        return MPI_COMM_TYPE_SHARED;
    }
#if (MPI_VERSION >= 4)
    else if (f == VAPAA_MPI_COMM_TYPE_HW_UNGUIDED) {
        return MPI_COMM_TYPE_HW_UNGUIDED;
    }
    else if (f == VAPAA_MPI_COMM_TYPE_HW_GUIDED) {
        return MPI_COMM_TYPE_HW_GUIDED;
    }
#if MPI_VERSION >= 5
    else if (f == VAPAA_MPI_COMM_TYPE_RESOURCE_GUIDED) {
        return MPI_COMM_TYPE_RESOURCE_GUIDED;
    }
#endif
#endif
    else {
        // impossible
        MPI_Abort(MPI_COMM_WORLD,f);
        return -1;
    }
}

static int * C_MPI_WEIGHTS_F2C(int *weights)
{
    if (C_IS_MPI_UNWEIGHTED(weights)) {
        return MPI_UNWEIGHTED;
    } else if (C_IS_MPI_WEIGHTS_EMPTY(weights)) {
        return MPI_WEIGHTS_EMPTY;
    } else {
        return weights;
    }
}

void C_MPI_Comm_rank(int * comm_f, int * rank, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_rank(comm, rank);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_size(int * comm_f, int * size, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_size(comm, size);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_compare(int * comm1_f, int * comm2_f, int * result_f, int * ierror)
{
    MPI_Comm comm1 = C_MPI_COMM_FROMINT(*comm1_f);
    MPI_Comm comm2 = C_MPI_COMM_FROMINT(*comm2_f);
    int result;
    *ierror = MPI_Comm_compare(comm1, comm2, &result);
    *result_f = C_MPI_COMPARE_RESULT_C2F(result);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_dup(int * comm_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_dup(comm, &newcomm);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_dup_with_info(int * comm_f, int * info_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Comm_dup_with_info(comm, info, &newcomm);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_idup(int * comm_f, int * newcomm_f, int * request_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_Comm_idup(comm, &newcomm, &request);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}

#if MPI_VERSION >= 4
void C_MPI_Comm_idup_with_info(int * comm_f, int * info_f, int * newcomm_f, int * request_f, int * ierror)
{
    MPI_Request request = MPI_REQUEST_NULL;
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    *ierror = MPI_Comm_idup_with_info(comm, info, &newcomm, &request);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    *request_f = C_MPI_REQUEST_TOINT(request);
    C_MPI_RC_FIX(*ierror);
}
#else
void C_MPI_Comm_idup_with_info(int * comm_f, int * info_f, int * newcomm_f, int * request_f, int * ierror)
{
    (void) info_f;
    *newcomm_f = VAPAA_MPI_COMM_NULL;
    *request_f = VAPAA_MPI_REQUEST_NULL;
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    VAPAA_MPI_handle_synthetic_error_comm(C_MPI_COMM_FROMINT(*comm_f), ierror);
    C_MPI_RC_FIX(*ierror);
}
#endif

void C_MPI_Comm_create(int * comm_f, int * group_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Group group = C_MPI_GROUP_FROMINT(*group_f);
    *ierror = MPI_Comm_create(comm, group, &newcomm);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_create_group(int * comm_f, int * group_f, int * tag_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Group group = C_MPI_GROUP_FROMINT(*group_f);
    *ierror = MPI_Comm_create_group(comm, group, *tag_f, &newcomm);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_split(int * comm_f, int * color_f, int * key_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_split(comm, *color_f, *key_f, &newcomm);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_split_type(int * comm_f, int * type_f, int * key_f, int * info_f, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    int type = C_MPI_TRANSLATE_SPLIT_TYPE(*type_f);
    *ierror = MPI_Comm_split_type(comm, type, *key_f, info, &newcomm);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Comm_free(int * comm_f, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Comm_free(&comm);
    *comm_f = C_MPI_COMM_TOINT(comm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Cart_create(int * comm_f, int * ndims, int * dims, int * periods, int * reorder, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Cart_create(comm, *ndims, dims, periods, *reorder, &newcomm);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Dims_create(int * nnodes, int * ndims, int * dims, int * ierror)
{
    *ierror = MPI_Dims_create(*nnodes, *ndims, dims);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Cart_coords(int * comm_f, int * rank, int * maxdims, int * coords, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Cart_coords(comm, *rank, *maxdims, coords);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Cart_get(int * comm_f, int * maxdims, int * dims, int * periods, int * coords, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Cart_get(comm, *maxdims, dims, periods, coords);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Cart_map(int * comm_f, int * ndims, int * dims, int * periods, int * newrank, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Cart_map(comm, *ndims, dims, periods, newrank);
    *newrank = C_MPI_UNDEFINED_C2F(*newrank);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Cart_rank(int * comm_f, int * coords, int * rank, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Cart_rank(comm, coords, rank);
    *rank = C_MPI_UNDEFINED_C2F(*rank);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Cart_shift(int * comm_f, int * direction, int * disp, int * rank_source, int * rank_dest, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Cart_shift(comm, *direction, *disp, rank_source, rank_dest);
    *rank_source = C_MPI_SOURCE_C2F(*rank_source);
    *rank_dest = C_MPI_SOURCE_C2F(*rank_dest);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Cart_sub(int * comm_f, int * remain_dims, int * newcomm_f, int * ierror)
{
    MPI_Comm newcomm = MPI_COMM_NULL;
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Cart_sub(comm, remain_dims, &newcomm);
    *newcomm_f = C_MPI_COMM_TOINT(newcomm);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Cartdim_get(int * comm_f, int * ndims, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Cartdim_get(comm, ndims);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Dist_graph_create(int * comm_old_f, int * n, int * sources, int * degrees, int * destinations,
                             int * weights_f, int * info_f, int * reorder, int * comm_dist_graph_f, int * ierror)
{
    MPI_Comm comm_dist_graph = MPI_COMM_NULL;
    MPI_Comm comm_old = C_MPI_COMM_FROMINT(*comm_old_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    int *weights = C_MPI_WEIGHTS_F2C(weights_f);
    *ierror = MPI_Dist_graph_create(comm_old, *n, sources, degrees, destinations, weights,
                                    info, *reorder, &comm_dist_graph);
    *comm_dist_graph_f = C_MPI_COMM_TOINT(comm_dist_graph);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Dist_graph_create_sentinel(int * comm_old_f, int * n, int * sources, int * degrees, int * destinations,
                                      int * weights_f, int * info_f, int * reorder, int * comm_dist_graph_f,
                                      int * ierror)
{
    C_MPI_Dist_graph_create(comm_old_f, n, sources, degrees, destinations, weights_f, info_f, reorder,
                            comm_dist_graph_f, ierror);
}

void C_MPI_Dist_graph_create_adjacent(int * comm_old_f, int * indegree, int * sources, int * sourceweights_f,
                                      int * outdegree, int * destinations, int * destweights_f, int * info_f,
                                      int * reorder, int * comm_dist_graph_f, int * ierror)
{
    MPI_Comm comm_dist_graph = MPI_COMM_NULL;
    MPI_Comm comm_old = C_MPI_COMM_FROMINT(*comm_old_f);
    MPI_Info info = C_MPI_INFO_FROMINT(*info_f);
    int *sourceweights = C_MPI_WEIGHTS_F2C(sourceweights_f);
    int *destweights = C_MPI_WEIGHTS_F2C(destweights_f);
    *ierror = MPI_Dist_graph_create_adjacent(comm_old, *indegree, sources, sourceweights,
                                             *outdegree, destinations, destweights,
                                             info, *reorder, &comm_dist_graph);
    *comm_dist_graph_f = C_MPI_COMM_TOINT(comm_dist_graph);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Dist_graph_create_adjacent_sentinel(int * comm_old_f, int * indegree, int * sources, int * sourceweights_f,
                                               int * outdegree, int * destinations, int * destweights_f, int * info_f,
                                               int * reorder, int * comm_dist_graph_f, int * ierror)
{
    C_MPI_Dist_graph_create_adjacent(comm_old_f, indegree, sources, sourceweights_f, outdegree, destinations,
                                     destweights_f, info_f, reorder, comm_dist_graph_f, ierror);
}

void C_MPI_Dist_graph_neighbors(int * comm_f, int * maxindegree, int * sources, int * sourceweights_f,
                                int * maxoutdegree, int * destinations, int * destweights_f, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    int *sourceweights = C_MPI_WEIGHTS_F2C(sourceweights_f);
    int *destweights = C_MPI_WEIGHTS_F2C(destweights_f);
    *ierror = MPI_Dist_graph_neighbors(comm, *maxindegree, sources, sourceweights,
                                       *maxoutdegree, destinations, destweights);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Dist_graph_neighbors_sentinel(int * comm_f, int * maxindegree, int * sources, int * sourceweights_f,
                                         int * maxoutdegree, int * destinations, int * destweights_f, int * ierror)
{
    C_MPI_Dist_graph_neighbors(comm_f, maxindegree, sources, sourceweights_f, maxoutdegree, destinations,
                               destweights_f, ierror);
}

void C_MPI_Dist_graph_neighbors_count(int * comm_f, int * indegree, int * outdegree, int * weighted, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Dist_graph_neighbors_count(comm, indegree, outdegree, weighted);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Graph_create(int * comm_old_f, int * nnodes, int * indx, int * edges, int * reorder,
                        int * comm_graph_f, int * ierror)
{
    MPI_Comm comm_graph = MPI_COMM_NULL;
    MPI_Comm comm_old = C_MPI_COMM_FROMINT(*comm_old_f);
    *ierror = MPI_Graph_create(comm_old, *nnodes, indx, edges, *reorder, &comm_graph);
    *comm_graph_f = C_MPI_COMM_TOINT(comm_graph);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Graph_get(int * comm_f, int * maxindex, int * maxedges, int * indx, int * edges, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Graph_get(comm, *maxindex, *maxedges, indx, edges);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Graph_map(int * comm_f, int * nnodes, int * indx, int * edges, int * newrank, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Graph_map(comm, *nnodes, indx, edges, newrank);
    *newrank = C_MPI_UNDEFINED_C2F(*newrank);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Graph_neighbors(int * comm_f, int * rank, int * maxneighbors, int * neighbors, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Graph_neighbors(comm, *rank, *maxneighbors, neighbors);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Graph_neighbors_count(int * comm_f, int * rank, int * nneighbors, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Graph_neighbors_count(comm, *rank, nneighbors);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Graphdims_get(int * comm_f, int * nnodes, int * nedges, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    *ierror = MPI_Graphdims_get(comm, nnodes, nedges);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Topo_test(int * comm_f, int * status_f, int * ierror)
{
    MPI_Comm comm = C_MPI_COMM_FROMINT(*comm_f);
    int status;
    *ierror = MPI_Topo_test(comm, &status);
    *status_f = C_MPI_TOPOLOGY_C2F(status);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Get_hw_resource_info(int * hw_info_f, int * ierror)
{
    MPI_Info hw_info = MPI_INFO_NULL;
#if MPI_VERSION >= 5
    *ierror = MPI_Get_hw_resource_info(&hw_info);
#else
    *ierror = MPI_ERR_UNSUPPORTED_OPERATION;
    VAPAA_MPI_handle_synthetic_error_no_object(ierror);
#endif
    *hw_info_f = C_MPI_INFO_TOINT(hw_info);
    C_MPI_RC_FIX(*ierror);
}
