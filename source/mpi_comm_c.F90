! SPDX-License-Identifier: MIT

module mpi_comm_c

    interface
        subroutine C_MPI_Comm_rank(comm, rank, ierror) &
                   bind(C,name="C_MPI_Comm_rank")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: rank, ierror
        end subroutine C_MPI_Comm_rank
    end interface

    interface
        subroutine C_MPI_Comm_size(comm, size, ierror) &
                   bind(C,name="C_MPI_Comm_size")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: size, ierror
        end subroutine C_MPI_Comm_size
    end interface

    interface
        subroutine C_MPI_Comm_compare(comm1_c, comm2_c, result, ierror) &
                   bind(C,name="C_MPI_Comm_compare")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm1_c, comm2_c
            integer(kind=c_int), intent(out) :: result, ierror
        end subroutine C_MPI_Comm_compare
    end interface

    interface
        subroutine C_MPI_Comm_dup(comm, newcomm, ierror) &
                   bind(C,name="C_MPI_Comm_dup")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Comm_dup
    end interface

    interface
        subroutine C_MPI_Comm_dup_with_info(comm, info, newcomm, ierror) &
                   bind(C,name="C_MPI_Comm_dup_with_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, info
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Comm_dup_with_info
    end interface

    interface
        subroutine C_MPI_Comm_idup(comm, newcomm, request, ierror) &
                   bind(C,name="C_MPI_Comm_idup")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out), asynchronous :: newcomm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Comm_idup
    end interface

    interface
        subroutine C_MPI_Comm_idup_with_info(comm, info, newcomm, request, ierror) &
                   bind(C,name="C_MPI_Comm_idup_with_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, info
            integer(kind=c_int), intent(out), asynchronous :: newcomm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Comm_idup_with_info
    end interface

    interface
        subroutine C_MPI_Comm_create(comm, group, newcomm, ierror) &
                   bind(C,name="C_MPI_Comm_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, group
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Comm_create
    end interface

    interface
        subroutine C_MPI_Comm_create_group(comm, group, tag, newcomm, ierror) &
                   bind(C,name="C_MPI_Comm_create_group")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, group, tag
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Comm_create_group
    end interface

    interface
        subroutine C_MPI_Comm_split(comm, color, key, newcomm, ierror) &
                   bind(C,name="C_MPI_Comm_split")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, color, key
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Comm_split
    end interface

    interface
        subroutine C_MPI_Comm_split_type(comm, type, key, info, newcomm, ierror) &
                   bind(C,name="C_MPI_Comm_split_type")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, type, key, info
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Comm_split_type
    end interface

    interface
        subroutine C_MPI_Comm_free(comm, ierror) &
                   bind(C,name="C_MPI_Comm_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Comm_free
    end interface

    interface
        subroutine C_MPI_Cart_create(comm, ndims, dims, periods, reorder, newcomm, ierror) &
                   bind(C,name="C_MPI_Cart_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, ndims, reorder
            integer(kind=c_int), intent(in) :: dims(*), periods(*)
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Cart_create
    end interface

    interface
        subroutine C_MPI_Dims_create(nnodes, ndims, dims, ierror) &
                   bind(C,name="C_MPI_Dims_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: nnodes, ndims
            integer(kind=c_int), intent(inout) :: dims(ndims)
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Dims_create
    end interface

    interface
        subroutine C_MPI_Cart_coords(comm, rank, maxdims, coords, ierror) &
                   bind(C,name="C_MPI_Cart_coords")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, rank, maxdims
            integer(kind=c_int), intent(out) :: coords(*), ierror
        end subroutine C_MPI_Cart_coords
    end interface

    interface
        subroutine C_MPI_Cart_get(comm, maxdims, dims, periods, coords, ierror) &
                   bind(C,name="C_MPI_Cart_get")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, maxdims
            integer(kind=c_int), intent(out) :: dims(*), periods(*), coords(*), ierror
        end subroutine C_MPI_Cart_get
    end interface

    interface
        subroutine C_MPI_Cart_map(comm, ndims, dims, periods, newrank, ierror) &
                   bind(C,name="C_MPI_Cart_map")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, ndims
            integer(kind=c_int), intent(in) :: dims(*), periods(*)
            integer(kind=c_int), intent(out) :: newrank, ierror
        end subroutine C_MPI_Cart_map
    end interface

    interface
        subroutine C_MPI_Cart_rank(comm, coords, rank, ierror) &
                   bind(C,name="C_MPI_Cart_rank")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(in) :: coords(*)
            integer(kind=c_int), intent(out) :: rank, ierror
        end subroutine C_MPI_Cart_rank
    end interface

    interface
        subroutine C_MPI_Cart_shift(comm, direction, disp, rank_source, rank_dest, ierror) &
                   bind(C,name="C_MPI_Cart_shift")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, direction, disp
            integer(kind=c_int), intent(out) :: rank_source, rank_dest, ierror
        end subroutine C_MPI_Cart_shift
    end interface

    interface
        subroutine C_MPI_Cart_sub(comm, remain_dims, newcomm, ierror) &
                   bind(C,name="C_MPI_Cart_sub")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(in) :: remain_dims(*)
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Cart_sub
    end interface

    interface
        subroutine C_MPI_Cartdim_get(comm, ndims, ierror) &
                   bind(C,name="C_MPI_Cartdim_get")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: ndims, ierror
        end subroutine C_MPI_Cartdim_get
    end interface

    interface
        subroutine C_MPI_Dist_graph_create(comm_old, n, sources, degrees, destinations, weights, &
                                           info, reorder, comm_dist_graph, ierror) &
                   bind(C,name="C_MPI_Dist_graph_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm_old, n, info, reorder
            integer(kind=c_int), intent(in) :: sources(*), degrees(*), destinations(*), weights(*)
            integer(kind=c_int), intent(out) :: comm_dist_graph, ierror
        end subroutine C_MPI_Dist_graph_create
    end interface

    interface
        subroutine C_MPI_Dist_graph_create_adjacent(comm_old, indegree, sources, sourceweights, &
                                                    outdegree, destinations, destweights, info, &
                                                    reorder, comm_dist_graph, ierror) &
                   bind(C,name="C_MPI_Dist_graph_create_adjacent")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm_old, indegree, outdegree, info, reorder
            integer(kind=c_int), intent(in) :: sources(*), sourceweights(*), destinations(*), destweights(*)
            integer(kind=c_int), intent(out) :: comm_dist_graph, ierror
        end subroutine C_MPI_Dist_graph_create_adjacent
    end interface

    interface
        subroutine C_MPI_Dist_graph_neighbors(comm, maxindegree, sources, sourceweights, &
                                              maxoutdegree, destinations, destweights, ierror) &
                   bind(C,name="C_MPI_Dist_graph_neighbors")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, maxindegree, maxoutdegree
            integer(kind=c_int), intent(out) :: sources(*), destinations(*), ierror
            integer(kind=c_int) :: sourceweights(*), destweights(*)
        end subroutine C_MPI_Dist_graph_neighbors
    end interface

    interface
        subroutine C_MPI_Dist_graph_neighbors_count(comm, indegree, outdegree, weighted, ierror) &
                   bind(C,name="C_MPI_Dist_graph_neighbors_count")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: indegree, outdegree, weighted, ierror
        end subroutine C_MPI_Dist_graph_neighbors_count
    end interface

    interface
        subroutine C_MPI_Graph_create(comm_old, nnodes, indx, edges, reorder, comm_graph, ierror) &
                   bind(C,name="C_MPI_Graph_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm_old, nnodes, reorder
            integer(kind=c_int), intent(in) :: indx(*), edges(*)
            integer(kind=c_int), intent(out) :: comm_graph, ierror
        end subroutine C_MPI_Graph_create
    end interface

    interface
        subroutine C_MPI_Graph_get(comm, maxindex, maxedges, indx, edges, ierror) &
                   bind(C,name="C_MPI_Graph_get")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, maxindex, maxedges
            integer(kind=c_int), intent(out) :: indx(*), edges(*), ierror
        end subroutine C_MPI_Graph_get
    end interface

    interface
        subroutine C_MPI_Graph_map(comm, nnodes, indx, edges, newrank, ierror) &
                   bind(C,name="C_MPI_Graph_map")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, nnodes
            integer(kind=c_int), intent(in) :: indx(*), edges(*)
            integer(kind=c_int), intent(out) :: newrank, ierror
        end subroutine C_MPI_Graph_map
    end interface

    interface
        subroutine C_MPI_Graph_neighbors(comm, rank, maxneighbors, neighbors, ierror) &
                   bind(C,name="C_MPI_Graph_neighbors")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, rank, maxneighbors
            integer(kind=c_int), intent(out) :: neighbors(*), ierror
        end subroutine C_MPI_Graph_neighbors
    end interface

    interface
        subroutine C_MPI_Graph_neighbors_count(comm, rank, nneighbors, ierror) &
                   bind(C,name="C_MPI_Graph_neighbors_count")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, rank
            integer(kind=c_int), intent(out) :: nneighbors, ierror
        end subroutine C_MPI_Graph_neighbors_count
    end interface

    interface
        subroutine C_MPI_Graphdims_get(comm, nnodes, nedges, ierror) &
                   bind(C,name="C_MPI_Graphdims_get")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: nnodes, nedges, ierror
        end subroutine C_MPI_Graphdims_get
    end interface

    interface
        subroutine C_MPI_Topo_test(comm, status, ierror) &
                   bind(C,name="C_MPI_Topo_test")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: status, ierror
        end subroutine C_MPI_Topo_test
    end interface

    interface
        subroutine C_MPI_Get_hw_resource_info(hw_info, ierror) &
                   bind(C,name="C_MPI_Get_hw_resource_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: hw_info, ierror
        end subroutine C_MPI_Get_hw_resource_info
    end interface

end module mpi_comm_c
