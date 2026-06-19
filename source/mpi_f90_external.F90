! SPDX-License-Identifier: MIT
!
! Generated legacy externals for the integer-handle mpi module.
! These names resolve to the mpif.h ABI entry points in mpi_f77*.c.

module mpi_f90_external
    use mpi_f90_constants, only: MPI_ADDRESS_KIND
    implicit none
    private

    public :: MPI_NULL_COPY_FN, MPI_NULL_DELETE_FN
    public :: MPI_COMM_DUP_FN, MPI_COMM_NULL_COPY_FN, MPI_COMM_NULL_DELETE_FN
    public :: MPI_TYPE_DUP_FN, MPI_TYPE_NULL_COPY_FN, MPI_TYPE_NULL_DELETE_FN
    public :: MPI_WIN_DUP_FN, MPI_WIN_NULL_COPY_FN, MPI_WIN_NULL_DELETE_FN

    public :: MPI_Abi_get_fortran_booleans, MPI_Abi_get_fortran_info, MPI_Abi_get_info, MPI_Abi_get_version
    public :: MPI_Abi_set_fortran_booleans, MPI_Abi_set_fortran_info, MPI_Accumulate, MPI_Add_error_class
    public :: MPI_Add_error_code, MPI_Add_error_string, MPI_Aint_add, MPI_Aint_diff
    public :: MPI_Allgather, MPI_Allgather_init, MPI_Allgatherv, MPI_Allgatherv_init
    public :: MPI_Allreduce_init, MPI_Alltoall, MPI_Alltoall_init, MPI_Alltoallv
    public :: MPI_Alltoallv_init, MPI_Alltoallw, MPI_Alltoallw_init, MPI_Attr_delete
    public :: MPI_Barrier_init, MPI_Bcast, MPI_Bcast_init, MPI_Bsend
    public :: MPI_Bsend_init, MPI_Buffer_attach, MPI_Buffer_detach, MPI_Buffer_flush
    public :: MPI_Buffer_iflush, MPI_Cancel, MPI_Cart_coords, MPI_Cart_create
    public :: MPI_Cart_get, MPI_Cart_map, MPI_Cart_rank, MPI_Cart_shift
    public :: MPI_Cart_sub, MPI_Cartdim_get, MPI_Close_port, MPI_Comm_accept
    public :: MPI_Comm_attach_buffer, MPI_Comm_call_errhandler, MPI_Comm_compare, MPI_Comm_connect
    public :: MPI_Comm_create, MPI_Comm_create_errhandler, MPI_Comm_create_from_group, MPI_Comm_create_group
    public :: MPI_Comm_delete_attr, MPI_Comm_detach_buffer, MPI_Comm_disconnect, MPI_Comm_dup_with_info
    public :: MPI_Comm_flush_buffer, MPI_Comm_get_errhandler, MPI_Comm_get_info, MPI_Comm_get_name
    public :: MPI_Comm_group, MPI_Comm_idup, MPI_Comm_idup_with_info, MPI_Comm_iflush_buffer
    public :: MPI_Comm_join, MPI_Comm_remote_group, MPI_Comm_set_errhandler, MPI_Comm_set_info
    public :: MPI_Comm_set_name, MPI_Comm_spawn, MPI_Comm_spawn_multiple, MPI_Comm_split_type
    public :: MPI_Comm_test_inter, MPI_Compare_and_swap, MPI_Dims_create, MPI_Dist_graph_create
    public :: MPI_Dist_graph_create_adjacent, MPI_Dist_graph_neighbors, MPI_Dist_graph_neighbors_count, MPI_Errhandler_free
    public :: MPI_Exscan, MPI_Exscan_init, MPI_Fetch_and_op, MPI_File_call_errhandler
    public :: MPI_File_close, MPI_File_create_errhandler, MPI_File_delete, MPI_File_get_amode
    public :: MPI_File_get_atomicity, MPI_File_get_byte_offset, MPI_File_get_errhandler, MPI_File_get_group
    public :: MPI_File_get_info, MPI_File_get_position, MPI_File_get_position_shared, MPI_File_get_size
    public :: MPI_File_get_type_extent, MPI_File_get_view, MPI_File_iread, MPI_File_iread_all
    public :: MPI_File_iread_at, MPI_File_iread_at_all, MPI_File_iread_shared, MPI_File_iwrite
    public :: MPI_File_iwrite_all, MPI_File_iwrite_at, MPI_File_iwrite_at_all, MPI_File_iwrite_shared
    public :: MPI_File_open, MPI_File_preallocate, MPI_File_read, MPI_File_read_all
    public :: MPI_File_read_all_begin, MPI_File_read_all_end, MPI_File_read_at, MPI_File_read_at_all
    public :: MPI_File_read_at_all_begin, MPI_File_read_at_all_end, MPI_File_read_ordered, MPI_File_read_ordered_begin
    public :: MPI_File_read_ordered_end, MPI_File_read_shared, MPI_File_seek, MPI_File_seek_shared
    public :: MPI_File_set_atomicity, MPI_File_set_errhandler, MPI_File_set_info, MPI_File_set_size
    public :: MPI_File_set_view, MPI_File_sync, MPI_File_write, MPI_File_write_all
    public :: MPI_File_write_all_begin, MPI_File_write_all_end, MPI_File_write_at, MPI_File_write_at_all
    public :: MPI_File_write_at_all_begin, MPI_File_write_at_all_end, MPI_File_write_ordered, MPI_File_write_ordered_begin
    public :: MPI_File_write_ordered_end, MPI_File_write_shared, MPI_Gather, MPI_Gather_init
    public :: MPI_Gatherv, MPI_Gatherv_init, MPI_Get, MPI_Get_accumulate
    public :: MPI_Get_count, MPI_Get_elements_x, MPI_Get_hw_resource_info, MPI_Graph_create
    public :: MPI_Graph_get, MPI_Graph_map, MPI_Graph_neighbors, MPI_Graph_neighbors_count
    public :: MPI_Graphdims_get, MPI_Grequest_complete, MPI_Grequest_start, MPI_Group_compare
    public :: MPI_Group_difference, MPI_Group_excl, MPI_Group_free, MPI_Group_from_session_pset
    public :: MPI_Group_incl, MPI_Group_intersection, MPI_Group_range_excl, MPI_Group_range_incl
    public :: MPI_Group_rank, MPI_Group_size, MPI_Group_translate_ranks, MPI_Group_union
    public :: MPI_Iallgather, MPI_Iallgatherv, MPI_Iallreduce, MPI_Ialltoall
    public :: MPI_Ialltoallv, MPI_Ialltoallw, MPI_Ibarrier, MPI_Ibcast
    public :: MPI_Ibsend, MPI_Iexscan, MPI_Igather, MPI_Igatherv
    public :: MPI_Improbe, MPI_Imrecv, MPI_Ineighbor_allgather, MPI_Ineighbor_allgatherv
    public :: MPI_Ineighbor_alltoall, MPI_Ineighbor_alltoallv, MPI_Ineighbor_alltoallw, MPI_Info_create
    public :: MPI_Info_create_env, MPI_Info_delete, MPI_Info_dup, MPI_Info_free
    public :: MPI_Info_get, MPI_Info_get_nkeys, MPI_Info_get_nthkey, MPI_Info_get_string
    public :: MPI_Info_get_valuelen, MPI_Info_set, MPI_Intercomm_create, MPI_Intercomm_create_from_groups
    public :: MPI_Intercomm_merge, MPI_Iprobe, MPI_Irecv, MPI_Ireduce
    public :: MPI_Ireduce_scatter, MPI_Ireduce_scatter_block, MPI_Irsend, MPI_Iscan
    public :: MPI_Iscatter, MPI_Iscatterv, MPI_Isend, MPI_Isendrecv
    public :: MPI_Isendrecv_replace, MPI_Issend, MPI_Lookup_name, MPI_Mprobe
    public :: MPI_Mrecv, MPI_Neighbor_allgather, MPI_Neighbor_allgather_init, MPI_Neighbor_allgatherv
    public :: MPI_Neighbor_allgatherv_init, MPI_Neighbor_alltoall, MPI_Neighbor_alltoall_init, MPI_Neighbor_alltoallv
    public :: MPI_Neighbor_alltoallv_init, MPI_Neighbor_alltoallw, MPI_Neighbor_alltoallw_init, MPI_Op_commutative
    public :: MPI_Op_create, MPI_Op_create_c, MPI_Op_free, MPI_Open_port
    public :: MPI_Pack, MPI_Pack_external, MPI_Pack_external_size, MPI_Pack_size
    public :: MPI_Parrived, MPI_Pready, MPI_Pready_list, MPI_Pready_range
    public :: MPI_Precv_init, MPI_Probe, MPI_Psend_init, MPI_Publish_name
    public :: MPI_Put, MPI_Raccumulate, MPI_Recv_init, MPI_Reduce
    public :: MPI_Reduce_init, MPI_Reduce_local, MPI_Reduce_scatter, MPI_Reduce_scatter_block
    public :: MPI_Reduce_scatter_block_init, MPI_Reduce_scatter_init, MPI_Register_datarep, MPI_Register_datarep_c
    public :: MPI_Remove_error_class, MPI_Remove_error_code, MPI_Remove_error_string, MPI_Request_free
    public :: MPI_Request_get_status, MPI_Request_get_status_all, MPI_Request_get_status_any, MPI_Request_get_status_some
    public :: MPI_Rget, MPI_Rget_accumulate, MPI_Rput, MPI_Rsend
    public :: MPI_Rsend_init, MPI_Scan, MPI_Scan_init, MPI_Scatter
    public :: MPI_Scatter_init, MPI_Scatterv, MPI_Scatterv_init, MPI_Send_init
    public :: MPI_Sendrecv, MPI_Sendrecv_replace, MPI_Session_attach_buffer, MPI_Session_call_errhandler
    public :: MPI_Session_create_errhandler, MPI_Session_detach_buffer, MPI_Session_finalize, MPI_Session_flush_buffer
    public :: MPI_Session_get_errhandler, MPI_Session_get_info, MPI_Session_get_nth_pset, MPI_Session_get_num_psets
    public :: MPI_Session_get_pset_info, MPI_Session_iflush_buffer, MPI_Session_init, MPI_Session_set_errhandler
    public :: MPI_Ssend_init, MPI_Start, MPI_Startall, MPI_Status_get_error
    public :: MPI_Status_get_source, MPI_Status_get_tag, MPI_Status_set_cancelled, MPI_Status_set_elements
    public :: MPI_Status_set_elements_x, MPI_Status_set_error, MPI_Status_set_source, MPI_Status_set_tag
    public :: MPI_Test, MPI_Test_cancelled, MPI_Testall, MPI_Testany
    public :: MPI_Testsome, MPI_Topo_test, MPI_Type_create_darray, MPI_Type_create_f90_complex
    public :: MPI_Type_create_hindexed, MPI_Type_create_hindexed_block, MPI_Type_create_hvector, MPI_Type_create_indexed_block
    public :: MPI_Type_create_resized, MPI_Type_create_subarray, MPI_Type_delete_attr, MPI_Type_get_extent
    public :: MPI_Type_get_extent_x, MPI_Type_get_name, MPI_Type_get_true_extent, MPI_Type_get_true_extent_x
    public :: MPI_Type_get_value_index, MPI_Type_match_size, MPI_Type_set_name, MPI_Type_size_x
    public :: MPI_Type_vector, MPI_Unpack_external, MPI_Unpublish_name, MPI_Wait
    public :: MPI_Waitall, MPI_Waitany, MPI_Waitsome, MPI_Win_allocate
    public :: MPI_Win_allocate_shared, MPI_Win_attach, MPI_Win_call_errhandler, MPI_Win_complete
    public :: MPI_Win_create_dynamic, MPI_Win_create_errhandler, MPI_Win_delete_attr, MPI_Win_detach
    public :: MPI_Win_fence, MPI_Win_flush, MPI_Win_flush_all, MPI_Win_flush_local
    public :: MPI_Win_flush_local_all, MPI_Win_get_errhandler, MPI_Win_get_group, MPI_Win_get_info
    public :: MPI_Win_get_name, MPI_Win_lock, MPI_Win_lock_all, MPI_Win_post
    public :: MPI_Win_set_errhandler, MPI_Win_set_info, MPI_Win_set_name, MPI_Win_shared_query
    public :: MPI_Win_start, MPI_Win_sync, MPI_Win_test, MPI_Win_unlock
    public :: MPI_Win_unlock_all, MPI_Win_wait

    integer(kind=MPI_ADDRESS_KIND), external :: MPI_Aint_add
    integer(kind=MPI_ADDRESS_KIND), external :: MPI_Aint_diff
    external :: MPI_NULL_COPY_FN, MPI_NULL_DELETE_FN
    external :: MPI_COMM_DUP_FN, MPI_COMM_NULL_COPY_FN, MPI_COMM_NULL_DELETE_FN
    external :: MPI_TYPE_DUP_FN, MPI_TYPE_NULL_COPY_FN, MPI_TYPE_NULL_DELETE_FN
    external :: MPI_WIN_DUP_FN, MPI_WIN_NULL_COPY_FN, MPI_WIN_NULL_DELETE_FN
    external :: MPI_Abi_get_fortran_booleans, MPI_Abi_get_fortran_info, MPI_Abi_get_info, MPI_Abi_get_version
    external :: MPI_Abi_set_fortran_booleans, MPI_Abi_set_fortran_info, MPI_Accumulate, MPI_Add_error_class
    external :: MPI_Add_error_code, MPI_Add_error_string, MPI_Allgather, MPI_Allgather_init
    external :: MPI_Allgatherv, MPI_Allgatherv_init, MPI_Allreduce_init, MPI_Alltoall
    external :: MPI_Alltoall_init, MPI_Alltoallv, MPI_Alltoallv_init, MPI_Alltoallw
    external :: MPI_Alltoallw_init, MPI_Attr_delete, MPI_Barrier_init, MPI_Bcast
    external :: MPI_Bcast_init, MPI_Bsend, MPI_Bsend_init, MPI_Buffer_attach
    external :: MPI_Buffer_detach, MPI_Buffer_flush, MPI_Buffer_iflush, MPI_Cancel
    external :: MPI_Cart_coords, MPI_Cart_create, MPI_Cart_get, MPI_Cart_map
    external :: MPI_Cart_rank, MPI_Cart_shift, MPI_Cart_sub, MPI_Cartdim_get
    external :: MPI_Close_port, MPI_Comm_accept, MPI_Comm_attach_buffer, MPI_Comm_call_errhandler
    external :: MPI_Comm_compare, MPI_Comm_connect, MPI_Comm_create, MPI_Comm_create_errhandler
    external :: MPI_Comm_create_from_group, MPI_Comm_create_group, MPI_Comm_delete_attr, MPI_Comm_detach_buffer
    external :: MPI_Comm_disconnect, MPI_Comm_dup_with_info, MPI_Comm_flush_buffer, MPI_Comm_get_errhandler
    external :: MPI_Comm_get_info, MPI_Comm_get_name, MPI_Comm_group, MPI_Comm_idup
    external :: MPI_Comm_idup_with_info, MPI_Comm_iflush_buffer, MPI_Comm_join, MPI_Comm_remote_group
    external :: MPI_Comm_set_errhandler, MPI_Comm_set_info, MPI_Comm_set_name, MPI_Comm_spawn
    external :: MPI_Comm_spawn_multiple, MPI_Comm_split_type, MPI_Comm_test_inter, MPI_Compare_and_swap
    external :: MPI_Dims_create, MPI_Dist_graph_create, MPI_Dist_graph_create_adjacent, MPI_Dist_graph_neighbors
    external :: MPI_Dist_graph_neighbors_count, MPI_Errhandler_free, MPI_Exscan, MPI_Exscan_init
    external :: MPI_Fetch_and_op, MPI_File_call_errhandler, MPI_File_close, MPI_File_create_errhandler
    external :: MPI_File_delete, MPI_File_get_amode, MPI_File_get_atomicity, MPI_File_get_byte_offset
    external :: MPI_File_get_errhandler, MPI_File_get_group, MPI_File_get_info, MPI_File_get_position
    external :: MPI_File_get_position_shared, MPI_File_get_size, MPI_File_get_type_extent, MPI_File_get_view
    external :: MPI_File_iread, MPI_File_iread_all, MPI_File_iread_at, MPI_File_iread_at_all
    external :: MPI_File_iread_shared, MPI_File_iwrite, MPI_File_iwrite_all, MPI_File_iwrite_at
    external :: MPI_File_iwrite_at_all, MPI_File_iwrite_shared, MPI_File_open, MPI_File_preallocate
    external :: MPI_File_read, MPI_File_read_all, MPI_File_read_all_begin, MPI_File_read_all_end
    external :: MPI_File_read_at, MPI_File_read_at_all, MPI_File_read_at_all_begin, MPI_File_read_at_all_end
    external :: MPI_File_read_ordered, MPI_File_read_ordered_begin, MPI_File_read_ordered_end, MPI_File_read_shared
    external :: MPI_File_seek, MPI_File_seek_shared, MPI_File_set_atomicity, MPI_File_set_errhandler
    external :: MPI_File_set_info, MPI_File_set_size, MPI_File_set_view, MPI_File_sync
    external :: MPI_File_write, MPI_File_write_all, MPI_File_write_all_begin, MPI_File_write_all_end
    external :: MPI_File_write_at, MPI_File_write_at_all, MPI_File_write_at_all_begin, MPI_File_write_at_all_end
    external :: MPI_File_write_ordered, MPI_File_write_ordered_begin, MPI_File_write_ordered_end, MPI_File_write_shared
    external :: MPI_Gather, MPI_Gather_init, MPI_Gatherv, MPI_Gatherv_init
    external :: MPI_Get, MPI_Get_accumulate, MPI_Get_count, MPI_Get_elements_x
    external :: MPI_Get_hw_resource_info, MPI_Graph_create, MPI_Graph_get, MPI_Graph_map
    external :: MPI_Graph_neighbors, MPI_Graph_neighbors_count, MPI_Graphdims_get, MPI_Grequest_complete
    external :: MPI_Grequest_start, MPI_Group_compare, MPI_Group_difference, MPI_Group_excl
    external :: MPI_Group_free, MPI_Group_from_session_pset, MPI_Group_incl, MPI_Group_intersection
    external :: MPI_Group_range_excl, MPI_Group_range_incl, MPI_Group_rank, MPI_Group_size
    external :: MPI_Group_translate_ranks, MPI_Group_union, MPI_Iallgather, MPI_Iallgatherv
    external :: MPI_Iallreduce, MPI_Ialltoall, MPI_Ialltoallv, MPI_Ialltoallw
    external :: MPI_Ibarrier, MPI_Ibcast, MPI_Ibsend, MPI_Iexscan
    external :: MPI_Igather, MPI_Igatherv, MPI_Improbe, MPI_Imrecv
    external :: MPI_Ineighbor_allgather, MPI_Ineighbor_allgatherv, MPI_Ineighbor_alltoall, MPI_Ineighbor_alltoallv
    external :: MPI_Ineighbor_alltoallw, MPI_Info_create, MPI_Info_create_env, MPI_Info_delete
    external :: MPI_Info_dup, MPI_Info_free, MPI_Info_get, MPI_Info_get_nkeys
    external :: MPI_Info_get_nthkey, MPI_Info_get_string, MPI_Info_get_valuelen, MPI_Info_set
    external :: MPI_Intercomm_create, MPI_Intercomm_create_from_groups, MPI_Intercomm_merge, MPI_Iprobe
    external :: MPI_Irecv, MPI_Ireduce, MPI_Ireduce_scatter, MPI_Ireduce_scatter_block
    external :: MPI_Irsend, MPI_Iscan, MPI_Iscatter, MPI_Iscatterv
    external :: MPI_Isend, MPI_Isendrecv, MPI_Isendrecv_replace, MPI_Issend
    external :: MPI_Lookup_name, MPI_Mprobe, MPI_Mrecv, MPI_Neighbor_allgather
    external :: MPI_Neighbor_allgather_init, MPI_Neighbor_allgatherv, MPI_Neighbor_allgatherv_init, MPI_Neighbor_alltoall
    external :: MPI_Neighbor_alltoall_init, MPI_Neighbor_alltoallv, MPI_Neighbor_alltoallv_init, MPI_Neighbor_alltoallw
    external :: MPI_Neighbor_alltoallw_init, MPI_Op_commutative, MPI_Op_create, MPI_Op_create_c
    external :: MPI_Op_free, MPI_Open_port, MPI_Pack, MPI_Pack_external
    external :: MPI_Pack_external_size, MPI_Pack_size, MPI_Parrived, MPI_Pready
    external :: MPI_Pready_list, MPI_Pready_range, MPI_Precv_init, MPI_Probe
    external :: MPI_Psend_init, MPI_Publish_name, MPI_Put, MPI_Raccumulate
    external :: MPI_Recv_init, MPI_Reduce, MPI_Reduce_init, MPI_Reduce_local
    external :: MPI_Reduce_scatter, MPI_Reduce_scatter_block, MPI_Reduce_scatter_block_init, MPI_Reduce_scatter_init
    external :: MPI_Register_datarep, MPI_Register_datarep_c, MPI_Remove_error_class, MPI_Remove_error_code
    external :: MPI_Remove_error_string, MPI_Request_free, MPI_Request_get_status, MPI_Request_get_status_all
    external :: MPI_Request_get_status_any, MPI_Request_get_status_some, MPI_Rget, MPI_Rget_accumulate
    external :: MPI_Rput, MPI_Rsend, MPI_Rsend_init, MPI_Scan
    external :: MPI_Scan_init, MPI_Scatter, MPI_Scatter_init, MPI_Scatterv
    external :: MPI_Scatterv_init, MPI_Send_init, MPI_Sendrecv, MPI_Sendrecv_replace
    external :: MPI_Session_attach_buffer, MPI_Session_call_errhandler, MPI_Session_create_errhandler, MPI_Session_detach_buffer
    external :: MPI_Session_finalize, MPI_Session_flush_buffer, MPI_Session_get_errhandler, MPI_Session_get_info
    external :: MPI_Session_get_nth_pset, MPI_Session_get_num_psets, MPI_Session_get_pset_info, MPI_Session_iflush_buffer
    external :: MPI_Session_init, MPI_Session_set_errhandler, MPI_Ssend_init, MPI_Start
    external :: MPI_Startall, MPI_Status_get_error, MPI_Status_get_source, MPI_Status_get_tag
    external :: MPI_Status_set_cancelled, MPI_Status_set_elements, MPI_Status_set_elements_x, MPI_Status_set_error
    external :: MPI_Status_set_source, MPI_Status_set_tag, MPI_Test, MPI_Test_cancelled
    external :: MPI_Testall, MPI_Testany, MPI_Testsome, MPI_Topo_test
    external :: MPI_Type_create_darray, MPI_Type_create_f90_complex, MPI_Type_create_hindexed, MPI_Type_create_hindexed_block
    external :: MPI_Type_create_hvector, MPI_Type_create_indexed_block, MPI_Type_create_resized, MPI_Type_create_subarray
    external :: MPI_Type_delete_attr, MPI_Type_get_extent, MPI_Type_get_extent_x, MPI_Type_get_name
    external :: MPI_Type_get_true_extent, MPI_Type_get_true_extent_x, MPI_Type_get_value_index, MPI_Type_match_size
    external :: MPI_Type_set_name, MPI_Type_size_x, MPI_Type_vector, MPI_Unpack_external
    external :: MPI_Unpublish_name, MPI_Wait, MPI_Waitall, MPI_Waitany
    external :: MPI_Waitsome, MPI_Win_allocate, MPI_Win_allocate_shared, MPI_Win_attach
    external :: MPI_Win_call_errhandler, MPI_Win_complete, MPI_Win_create_dynamic, MPI_Win_create_errhandler
    external :: MPI_Win_delete_attr, MPI_Win_detach, MPI_Win_fence, MPI_Win_flush
    external :: MPI_Win_flush_all, MPI_Win_flush_local, MPI_Win_flush_local_all, MPI_Win_get_errhandler
    external :: MPI_Win_get_group, MPI_Win_get_info, MPI_Win_get_name, MPI_Win_lock
    external :: MPI_Win_lock_all, MPI_Win_post, MPI_Win_set_errhandler, MPI_Win_set_info
    external :: MPI_Win_set_name, MPI_Win_shared_query, MPI_Win_start, MPI_Win_sync
    external :: MPI_Win_test, MPI_Win_unlock, MPI_Win_unlock_all, MPI_Win_wait

end module mpi_f90_external
