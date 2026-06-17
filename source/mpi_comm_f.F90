! SPDX-License-Identifier: MIT

module mpi_comm_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Comm_rank
        module procedure MPI_Comm_rank_f08
    end interface MPI_Comm_rank

    interface MPI_Comm_size
        module procedure MPI_Comm_size_f08
    end interface MPI_Comm_size

    interface MPI_Comm_compare
        module procedure MPI_Comm_compare_f08
    end interface MPI_Comm_compare

    interface MPI_Comm_dup
        module procedure MPI_Comm_dup_f08
    end interface MPI_Comm_dup

    interface MPI_Comm_dup_with_info
        module procedure MPI_Comm_dup_with_info_f08
    end interface MPI_Comm_dup_with_info

    interface MPI_Comm_idup
        module procedure MPI_Comm_idup_f08
    end interface MPI_Comm_idup

    interface MPI_Comm_idup_with_info
        module procedure MPI_Comm_idup_with_info_f08
    end interface MPI_Comm_idup_with_info

    interface MPI_Comm_create
        module procedure MPI_Comm_create_f08
    end interface MPI_Comm_create

    interface MPI_Comm_create_group
        module procedure MPI_Comm_create_group_f08
    end interface MPI_Comm_create_group

    interface MPI_Comm_split
        module procedure MPI_Comm_split_f08
    end interface MPI_Comm_split

    interface MPI_Comm_split_type
        module procedure MPI_Comm_split_type_f08
    end interface MPI_Comm_split_type

    interface MPI_Comm_free
        module procedure MPI_Comm_free_f08
    end interface MPI_Comm_free

    interface MPI_Cart_create
        module procedure MPI_Cart_create_f08
    end interface MPI_Cart_create

    interface MPI_Dims_create
        module procedure MPI_Dims_create_f08
    end interface MPI_Dims_create

    interface MPI_Cart_coords
        module procedure MPI_Cart_coords_f08
    end interface MPI_Cart_coords

    interface MPI_Cart_get
        module procedure MPI_Cart_get_f08
    end interface MPI_Cart_get

    interface MPI_Cart_map
        module procedure MPI_Cart_map_f08
    end interface MPI_Cart_map

    interface MPI_Cart_rank
        module procedure MPI_Cart_rank_f08
    end interface MPI_Cart_rank

    interface MPI_Cart_shift
        module procedure MPI_Cart_shift_f08
    end interface MPI_Cart_shift

    interface MPI_Cart_sub
        module procedure MPI_Cart_sub_f08
    end interface MPI_Cart_sub

    interface MPI_Cartdim_get
        module procedure MPI_Cartdim_get_f08
    end interface MPI_Cartdim_get

    interface MPI_Dist_graph_create
        module procedure MPI_Dist_graph_create_f08
        module procedure MPI_Dist_graph_create_sentinel_f08
    end interface MPI_Dist_graph_create

    interface MPI_Dist_graph_create_adjacent
        module procedure MPI_Dist_graph_create_adjacent_f08
        module procedure MPI_Dist_graph_create_adjacent_sentinel_f08
    end interface MPI_Dist_graph_create_adjacent

    interface MPI_Dist_graph_neighbors
        module procedure MPI_Dist_graph_neighbors_f08
        module procedure MPI_Dist_graph_neighbors_sentinel_f08
    end interface MPI_Dist_graph_neighbors

    interface MPI_Dist_graph_neighbors_count
        module procedure MPI_Dist_graph_neighbors_count_f08
    end interface MPI_Dist_graph_neighbors_count

    interface MPI_Graph_create
        module procedure MPI_Graph_create_f08
    end interface MPI_Graph_create

    interface MPI_Graph_get
        module procedure MPI_Graph_get_f08
    end interface MPI_Graph_get

    interface MPI_Graph_map
        module procedure MPI_Graph_map_f08
    end interface MPI_Graph_map

    interface MPI_Graph_neighbors
        module procedure MPI_Graph_neighbors_f08
    end interface MPI_Graph_neighbors

    interface MPI_Graph_neighbors_count
        module procedure MPI_Graph_neighbors_count_f08
    end interface MPI_Graph_neighbors_count

    interface MPI_Graphdims_get
        module procedure MPI_Graphdims_get_f08
    end interface MPI_Graphdims_get

    interface MPI_Topo_test
        module procedure MPI_Topo_test_f08
    end interface MPI_Topo_test

    interface MPI_Get_hw_resource_info
        module procedure MPI_Get_hw_resource_info_f08
    end interface MPI_Get_hw_resource_info

    contains

        subroutine MPI_Comm_rank_f08(comm, rank, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_rank
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: rank
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, ierror_c
            call C_MPI_Comm_rank(comm % MPI_VAL, rank_c, ierror_c)
            rank = rank_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_rank_f08

        subroutine MPI_Comm_size_f08(comm, size, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_size
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: size_c, ierror_c
            call C_MPI_Comm_size(comm % MPI_VAL, size_c, ierror_c)
            size = size_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_size_f08

        subroutine MPI_Comm_compare_f08(comm1, comm2, result, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_compare
            type(MPI_Comm), intent(in) :: comm1, comm2
            integer, intent(out) :: result
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: result_c, ierror_c
            call C_MPI_Comm_compare(comm1 % MPI_VAL, comm2 % MPI_VAL, result_c, ierror_c)
            result = result_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_compare_f08

        subroutine MPI_Comm_dup_f08(comm, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_dup
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_dup(comm % MPI_VAL, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_dup_f08

        subroutine MPI_Comm_dup_with_info_f08(comm, info, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info
            use mpi_comm_c, only: C_MPI_Comm_dup_with_info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_dup_with_info(comm % MPI_VAL, info % MPI_VAL, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_dup_with_info_f08

        subroutine MPI_Comm_idup_f08(comm, newcomm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Request
            use mpi_comm_c, only: C_MPI_Comm_idup
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Comm), intent(out), asynchronous :: newcomm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_idup(comm % MPI_VAL, newcomm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_idup_f08

        subroutine MPI_Comm_idup_with_info_f08(comm, info, newcomm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info, MPI_Request
            use mpi_comm_c, only: C_MPI_Comm_idup_with_info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(out), asynchronous :: newcomm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_idup_with_info(comm % MPI_VAL, info % MPI_VAL, newcomm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_idup_with_info_f08

        subroutine MPI_Comm_create_f08(comm, group, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Group
            use mpi_comm_c, only: C_MPI_Comm_create
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Group), intent(in) :: group
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_create(comm % MPI_VAL, group % MPI_VAL, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_create_f08

        subroutine MPI_Comm_create_group_f08(comm, group, tag, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Group
            use mpi_comm_c, only: C_MPI_Comm_create_group
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Group), intent(in) :: group
            integer, intent(in) :: tag
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: tag_c, ierror_c
            tag_c = tag
            call C_MPI_Comm_create_group(comm % MPI_VAL, group % MPI_VAL, tag_c, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_create_group_f08

        subroutine MPI_Comm_split_f08(comm, color, key, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_split
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: color, key
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: color_c, key_c, ierror_c
            color_c = color
            key_c = key
            call C_MPI_Comm_split(comm % MPI_VAL, color_c, key_c, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_split_f08

        subroutine MPI_Comm_split_type_f08(comm, type, key, info, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info
            use mpi_comm_c, only: C_MPI_Comm_split_type
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: type, key
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: type_c, key_c, ierror_c
            type_c = type
            key_c = key
            call C_MPI_Comm_split_type(comm % MPI_VAL, type_c, key_c, info % MPI_VAL, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_split_type_f08

        subroutine MPI_Comm_free_f08(comm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_free
            type(MPI_Comm), intent(inout) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_free(comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_free_f08

        subroutine MPI_Cart_create_f08(comm, ndims, dims, periods, reorder, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Cart_create
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: ndims, dims(ndims)
            logical, intent(in) :: periods(ndims), reorder
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ndims_c, reorder_c, dims_c(ndims), periods_c(ndims), ierror_c
            ndims_c = ndims
            if (reorder) then
                reorder_c = 1
            else
                reorder_c = 0
            end if
            dims_c = dims
            where (periods)
                periods_c = 1
            elsewhere
                periods_c = 0
            end where
            call C_MPI_Cart_create(comm % MPI_VAL, ndims_c, dims_c, periods_c, reorder_c, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Cart_create_f08

        subroutine MPI_Dims_create_f08(nnodes, ndims, dims, ierror)
            use mpi_comm_c, only: C_MPI_Dims_create
            integer, intent(in) :: nnodes, ndims
            integer, intent(inout) :: dims(ndims)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: nnodes_c, ndims_c, dims_c(ndims), ierror_c
            nnodes_c = nnodes
            ndims_c = ndims
            dims_c = dims
            call C_MPI_Dims_create(nnodes_c, ndims_c, dims_c, ierror_c)
            dims = dims_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Dims_create_f08

        subroutine MPI_Cart_coords_f08(comm, rank, maxdims, coords, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Cart_coords
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: rank, maxdims
            integer, intent(out) :: coords(maxdims)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, maxdims_c, coords_c(maxdims), ierror_c
            rank_c = rank
            maxdims_c = maxdims
            call C_MPI_Cart_coords(comm % MPI_VAL, rank_c, maxdims_c, coords_c, ierror_c)
            coords = coords_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Cart_coords_f08

        subroutine MPI_Cart_get_f08(comm, maxdims, dims, periods, coords, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Cart_get
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: maxdims
            integer, intent(out) :: dims(maxdims)
            logical, intent(out) :: periods(maxdims)
            integer, intent(out) :: coords(maxdims)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: maxdims_c, dims_c(maxdims), periods_c(maxdims), coords_c(maxdims), ierror_c
            maxdims_c = maxdims
            call C_MPI_Cart_get(comm % MPI_VAL, maxdims_c, dims_c, periods_c, coords_c, ierror_c)
            dims = dims_c
            periods = (periods_c /= 0)
            coords = coords_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Cart_get_f08

        subroutine MPI_Cart_map_f08(comm, ndims, dims, periods, newrank, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Cart_map
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: ndims
            integer, intent(in) :: dims(ndims)
            logical, intent(in) :: periods(ndims)
            integer, intent(out) :: newrank
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ndims_c, dims_c(ndims), periods_c(ndims), newrank_c, ierror_c
            ndims_c = ndims
            dims_c = dims
            where (periods)
                periods_c = 1
            elsewhere
                periods_c = 0
            end where
            call C_MPI_Cart_map(comm % MPI_VAL, ndims_c, dims_c, periods_c, newrank_c, ierror_c)
            newrank = newrank_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Cart_map_f08

        subroutine MPI_Cart_rank_f08(comm, coords, rank, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Cart_rank
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: coords(*)
            integer, intent(out) :: rank
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, ierror_c
            call C_MPI_Cart_rank(comm % MPI_VAL, coords, rank_c, ierror_c)
            rank = rank_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Cart_rank_f08

        subroutine MPI_Cart_shift_f08(comm, direction, disp, rank_source, rank_dest, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Cart_shift
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: direction, disp
            integer, intent(out) :: rank_source, rank_dest
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: direction_c, disp_c, rank_source_c, rank_dest_c, ierror_c
            direction_c = direction
            disp_c = disp
            call C_MPI_Cart_shift(comm % MPI_VAL, direction_c, disp_c, rank_source_c, rank_dest_c, ierror_c)
            rank_source = rank_source_c
            rank_dest = rank_dest_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Cart_shift_f08

        subroutine MPI_Cart_sub_f08(comm, remain_dims, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Cart_sub, C_MPI_Cartdim_get
            type(MPI_Comm), intent(in) :: comm
            logical, intent(in) :: remain_dims(*)
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int), allocatable :: remain_dims_c(:)
            integer(kind=c_int) :: ndims_c, ierror_c
            call C_MPI_Cartdim_get(comm % MPI_VAL, ndims_c, ierror_c)
            if (ierror_c == 0) then
                allocate(remain_dims_c(ndims_c))
                where (remain_dims(1:ndims_c))
                    remain_dims_c = 1
                elsewhere
                    remain_dims_c = 0
                end where
                call C_MPI_Cart_sub(comm % MPI_VAL, remain_dims_c, newcomm % MPI_VAL, ierror_c)
            end if
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Cart_sub_f08

        subroutine MPI_Cartdim_get_f08(comm, ndims, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Cartdim_get
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: ndims
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ndims_c, ierror_c
            call C_MPI_Cartdim_get(comm % MPI_VAL, ndims_c, ierror_c)
            ndims = ndims_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Cartdim_get_f08

        subroutine MPI_Dist_graph_create_f08(comm_old, n, sources, degrees, destinations, weights, info, &
                                             reorder, comm_dist_graph, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info
            use mpi_comm_c, only: C_MPI_Dist_graph_create
            type(MPI_Comm), intent(in) :: comm_old
            integer, intent(in) :: n
            integer, intent(in) :: sources(n), degrees(n), destinations(*)
            integer, intent(in), target :: weights(*)
            type(MPI_Info), intent(in) :: info
            logical, intent(in) :: reorder
            type(MPI_Comm), intent(out) :: comm_dist_graph
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: n_c, reorder_c, ierror_c
            n_c = n
            if (reorder) then
                reorder_c = 1
            else
                reorder_c = 0
            end if
            call C_MPI_Dist_graph_create(comm_old % MPI_VAL, n_c, sources, degrees, destinations, weights, &
                                         info % MPI_VAL, reorder_c, comm_dist_graph % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Dist_graph_create_f08

        subroutine MPI_Dist_graph_create_sentinel_f08(comm_old, n, sources, degrees, destinations, weights, info, &
                                                      reorder, comm_dist_graph, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info
            use mpi_comm_c, only: C_MPI_Dist_graph_create_sentinel
            type(MPI_Comm), intent(in) :: comm_old
            integer, intent(in) :: n
            integer, intent(in) :: sources(n), degrees(n), destinations(*)
            integer, intent(in), target :: weights
            type(MPI_Info), intent(in) :: info
            logical, intent(in) :: reorder
            type(MPI_Comm), intent(out) :: comm_dist_graph
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: n_c, reorder_c, ierror_c
            n_c = n
            if (reorder) then
                reorder_c = 1
            else
                reorder_c = 0
            end if
            call C_MPI_Dist_graph_create_sentinel(comm_old % MPI_VAL, n_c, sources, degrees, destinations, weights, &
                                                  info % MPI_VAL, reorder_c, comm_dist_graph % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Dist_graph_create_sentinel_f08

        subroutine MPI_Dist_graph_create_adjacent_f08(comm_old, indegree, sources, sourceweights, outdegree, &
                                                      destinations, destweights, info, reorder, &
                                                      comm_dist_graph, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info
            use mpi_comm_c, only: C_MPI_Dist_graph_create_adjacent
            type(MPI_Comm), intent(in) :: comm_old
            integer, intent(in) :: indegree
            integer, intent(in) :: sources(indegree)
            integer, intent(in), target :: sourceweights(*)
            integer, intent(in) :: outdegree
            integer, intent(in) :: destinations(outdegree)
            integer, intent(in), target :: destweights(*)
            type(MPI_Info), intent(in) :: info
            logical, intent(in) :: reorder
            type(MPI_Comm), intent(out) :: comm_dist_graph
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: indegree_c, outdegree_c, reorder_c, ierror_c
            indegree_c = indegree
            outdegree_c = outdegree
            if (reorder) then
                reorder_c = 1
            else
                reorder_c = 0
            end if
            call C_MPI_Dist_graph_create_adjacent(comm_old % MPI_VAL, indegree_c, sources, sourceweights, &
                                                  outdegree_c, destinations, destweights, info % MPI_VAL, &
                                                  reorder_c, comm_dist_graph % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Dist_graph_create_adjacent_f08

        subroutine MPI_Dist_graph_create_adjacent_sentinel_f08(comm_old, indegree, sources, sourceweights, &
                                                               outdegree, destinations, destweights, info, reorder, &
                                                               comm_dist_graph, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info
            use mpi_comm_c, only: C_MPI_Dist_graph_create_adjacent_sentinel
            type(MPI_Comm), intent(in) :: comm_old
            integer, intent(in) :: indegree
            integer, intent(in) :: sources(indegree)
            integer, intent(in), target :: sourceweights
            integer, intent(in) :: outdegree
            integer, intent(in) :: destinations(outdegree)
            integer, intent(in), target :: destweights
            type(MPI_Info), intent(in) :: info
            logical, intent(in) :: reorder
            type(MPI_Comm), intent(out) :: comm_dist_graph
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: indegree_c, outdegree_c, reorder_c, ierror_c
            indegree_c = indegree
            outdegree_c = outdegree
            if (reorder) then
                reorder_c = 1
            else
                reorder_c = 0
            end if
            call C_MPI_Dist_graph_create_adjacent_sentinel(comm_old % MPI_VAL, indegree_c, sources, sourceweights, &
                                                           outdegree_c, destinations, destweights, info % MPI_VAL, &
                                                           reorder_c, comm_dist_graph % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Dist_graph_create_adjacent_sentinel_f08

        subroutine MPI_Dist_graph_neighbors_f08(comm, maxindegree, sources, sourceweights, maxoutdegree, &
                                                destinations, destweights, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Dist_graph_neighbors
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: maxindegree
            integer, intent(out) :: sources(maxindegree)
            integer, target :: sourceweights(*)
            integer, intent(in) :: maxoutdegree
            integer, intent(out) :: destinations(maxoutdegree)
            integer, target :: destweights(*)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: maxindegree_c, maxoutdegree_c, ierror_c
            maxindegree_c = maxindegree
            maxoutdegree_c = maxoutdegree
            call C_MPI_Dist_graph_neighbors(comm % MPI_VAL, maxindegree_c, sources, sourceweights, &
                                            maxoutdegree_c, destinations, destweights, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Dist_graph_neighbors_f08

        subroutine MPI_Dist_graph_neighbors_sentinel_f08(comm, maxindegree, sources, sourceweights, maxoutdegree, &
                                                         destinations, destweights, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Dist_graph_neighbors_sentinel
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: maxindegree
            integer, intent(out) :: sources(maxindegree)
            integer, intent(in), target :: sourceweights
            integer, intent(in) :: maxoutdegree
            integer, intent(out) :: destinations(maxoutdegree)
            integer, intent(in), target :: destweights
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: maxindegree_c, maxoutdegree_c, ierror_c
            maxindegree_c = maxindegree
            maxoutdegree_c = maxoutdegree
            call C_MPI_Dist_graph_neighbors_sentinel(comm % MPI_VAL, maxindegree_c, sources, sourceweights, &
                                                     maxoutdegree_c, destinations, destweights, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Dist_graph_neighbors_sentinel_f08

        subroutine MPI_Dist_graph_neighbors_count_f08(comm, indegree, outdegree, weighted, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Dist_graph_neighbors_count
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: indegree, outdegree
            logical, intent(out) :: weighted
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: indegree_c, outdegree_c, weighted_c, ierror_c
            call C_MPI_Dist_graph_neighbors_count(comm % MPI_VAL, indegree_c, outdegree_c, weighted_c, ierror_c)
            indegree = indegree_c
            outdegree = outdegree_c
            weighted = (weighted_c /= 0)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Dist_graph_neighbors_count_f08

        subroutine MPI_Graph_create_f08(comm_old, nnodes, indx, edges, reorder, comm_graph, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Graph_create
            type(MPI_Comm), intent(in) :: comm_old
            integer, intent(in) :: nnodes
            integer, intent(in) :: indx(nnodes), edges(*)
            logical, intent(in) :: reorder
            type(MPI_Comm), intent(out) :: comm_graph
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: nnodes_c, reorder_c, ierror_c
            nnodes_c = nnodes
            if (reorder) then
                reorder_c = 1
            else
                reorder_c = 0
            end if
            call C_MPI_Graph_create(comm_old % MPI_VAL, nnodes_c, indx, edges, reorder_c, &
                                    comm_graph % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Graph_create_f08

        subroutine MPI_Graph_get_f08(comm, maxindex, maxedges, indx, edges, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Graph_get
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: maxindex, maxedges
            integer, intent(out) :: indx(maxindex), edges(maxedges)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: maxindex_c, maxedges_c, ierror_c
            maxindex_c = maxindex
            maxedges_c = maxedges
            call C_MPI_Graph_get(comm % MPI_VAL, maxindex_c, maxedges_c, indx, edges, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Graph_get_f08

        subroutine MPI_Graph_map_f08(comm, nnodes, indx, edges, newrank, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Graph_map
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: nnodes
            integer, intent(in) :: indx(nnodes), edges(*)
            integer, intent(out) :: newrank
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: nnodes_c, newrank_c, ierror_c
            nnodes_c = nnodes
            call C_MPI_Graph_map(comm % MPI_VAL, nnodes_c, indx, edges, newrank_c, ierror_c)
            newrank = newrank_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Graph_map_f08

        subroutine MPI_Graph_neighbors_f08(comm, rank, maxneighbors, neighbors, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Graph_neighbors
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: rank, maxneighbors
            integer, intent(out) :: neighbors(maxneighbors)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, maxneighbors_c, ierror_c
            rank_c = rank
            maxneighbors_c = maxneighbors
            call C_MPI_Graph_neighbors(comm % MPI_VAL, rank_c, maxneighbors_c, neighbors, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Graph_neighbors_f08

        subroutine MPI_Graph_neighbors_count_f08(comm, rank, nneighbors, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Graph_neighbors_count
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: rank
            integer, intent(out) :: nneighbors
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, nneighbors_c, ierror_c
            rank_c = rank
            call C_MPI_Graph_neighbors_count(comm % MPI_VAL, rank_c, nneighbors_c, ierror_c)
            nneighbors = nneighbors_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Graph_neighbors_count_f08

        subroutine MPI_Graphdims_get_f08(comm, nnodes, nedges, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Graphdims_get
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: nnodes, nedges
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: nnodes_c, nedges_c, ierror_c
            call C_MPI_Graphdims_get(comm % MPI_VAL, nnodes_c, nedges_c, ierror_c)
            nnodes = nnodes_c
            nedges = nedges_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Graphdims_get_f08

        subroutine MPI_Topo_test_f08(comm, status, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Topo_test
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: status
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: status_c, ierror_c
            call C_MPI_Topo_test(comm % MPI_VAL, status_c, ierror_c)
            status = status_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Topo_test_f08

        subroutine MPI_Get_hw_resource_info_f08(hw_info, ierror)
            use mpi_handle_types, only: MPI_Info
            use mpi_comm_c, only: C_MPI_Get_hw_resource_info
            type(MPI_Info), intent(out) :: hw_info
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Get_hw_resource_info(hw_info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_hw_resource_info_f08

end module mpi_comm_f
