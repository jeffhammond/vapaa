! SPDX-License-Identifier: MIT

module mpi_direct_comm_f
    use iso_c_binding, only: c_char, c_int, c_int64_t, c_intptr_t, c_null_char, c_ptr
    implicit none

    interface MPI_Comm_group
        module procedure MPI_Comm_group_f08
    end interface MPI_Comm_group
    interface MPI_Comm_remote_group
        module procedure MPI_Comm_remote_group_f08
    end interface MPI_Comm_remote_group
    interface MPI_Comm_remote_size
        module procedure MPI_Comm_remote_size_f08
    end interface MPI_Comm_remote_size
    interface MPI_Comm_test_inter
        module procedure MPI_Comm_test_inter_f08
    end interface MPI_Comm_test_inter
    interface MPI_Comm_get_info
        module procedure MPI_Comm_get_info_f08
    end interface MPI_Comm_get_info
    interface MPI_Comm_set_info
        module procedure MPI_Comm_set_info_f08
    end interface MPI_Comm_set_info
    interface MPI_Comm_get_parent
        module procedure MPI_Comm_get_parent_f08
    end interface MPI_Comm_get_parent
    interface MPI_Comm_disconnect
        module procedure MPI_Comm_disconnect_f08
    end interface MPI_Comm_disconnect
    interface MPI_Intercomm_create
        module procedure MPI_Intercomm_create_f08
    end interface MPI_Intercomm_create
    interface MPI_Intercomm_merge
        module procedure MPI_Intercomm_merge_f08
    end interface MPI_Intercomm_merge
    interface MPI_Comm_join
        module procedure MPI_Comm_join_f08
    end interface MPI_Comm_join
    interface MPI_Comm_delete_attr
        module procedure MPI_Comm_delete_attr_f08
    end interface MPI_Comm_delete_attr
    interface MPI_Comm_free_keyval
        module procedure MPI_Comm_free_keyval_f08
    end interface MPI_Comm_free_keyval
    interface MPI_Comm_get_attr
        module procedure MPI_Comm_get_attr_f08
    end interface MPI_Comm_get_attr
    interface MPI_Comm_set_attr
        module procedure MPI_Comm_set_attr_f08
    end interface MPI_Comm_set_attr
    interface MPI_Comm_detach_buffer
        module procedure MPI_Comm_detach_buffer_f08
        module procedure MPI_Comm_detach_buffer_c_f08
    end interface MPI_Comm_detach_buffer
    interface MPI_Comm_flush_buffer
        module procedure MPI_Comm_flush_buffer_f08
    end interface MPI_Comm_flush_buffer
    interface MPI_Comm_iflush_buffer
        module procedure MPI_Comm_iflush_buffer_f08
    end interface MPI_Comm_iflush_buffer
    interface MPI_Session_init
        module procedure MPI_Session_init_f08
    end interface MPI_Session_init
    interface MPI_Session_finalize
        module procedure MPI_Session_finalize_f08
    end interface MPI_Session_finalize
    interface MPI_Session_get_info
        module procedure MPI_Session_get_info_f08
    end interface MPI_Session_get_info
    interface MPI_Session_get_num_psets
        module procedure MPI_Session_get_num_psets_f08
    end interface MPI_Session_get_num_psets
    interface MPI_Session_detach_buffer
        module procedure MPI_Session_detach_buffer_f08
        module procedure MPI_Session_detach_buffer_c_f08
    end interface MPI_Session_detach_buffer
    interface MPI_Session_flush_buffer
        module procedure MPI_Session_flush_buffer_f08
    end interface MPI_Session_flush_buffer
    interface MPI_Session_iflush_buffer
        module procedure MPI_Session_iflush_buffer_f08
    end interface MPI_Session_iflush_buffer

#ifdef HAVE_CFI
    interface MPI_Comm_get_name
        module procedure MPI_Comm_get_name_f08
    end interface MPI_Comm_get_name
    interface MPI_Comm_set_name
        module procedure MPI_Comm_set_name_f08
    end interface MPI_Comm_set_name
    interface MPI_Comm_create_from_group
        module procedure MPI_Comm_create_from_group_f08
    end interface MPI_Comm_create_from_group
    interface MPI_Intercomm_create_from_groups
        module procedure MPI_Intercomm_create_from_groups_f08
    end interface MPI_Intercomm_create_from_groups
    interface MPI_Comm_attach_buffer
        module procedure MPI_Comm_attach_buffer_f08ts
        module procedure MPI_Comm_attach_buffer_c_f08ts
    end interface MPI_Comm_attach_buffer
    interface MPI_Open_port
        module procedure MPI_Open_port_f08
    end interface MPI_Open_port
    interface MPI_Close_port
        module procedure MPI_Close_port_f08
    end interface MPI_Close_port
    interface MPI_Comm_accept
        module procedure MPI_Comm_accept_f08
    end interface MPI_Comm_accept
    interface MPI_Comm_connect
        module procedure MPI_Comm_connect_f08
    end interface MPI_Comm_connect
    interface MPI_Lookup_name
        module procedure MPI_Lookup_name_f08
    end interface MPI_Lookup_name
    interface MPI_Publish_name
        module procedure MPI_Publish_name_f08
    end interface MPI_Publish_name
    interface MPI_Unpublish_name
        module procedure MPI_Unpublish_name_f08
    end interface MPI_Unpublish_name
    interface MPI_Session_get_nth_pset
        module procedure MPI_Session_get_nth_pset_f08
    end interface MPI_Session_get_nth_pset
    interface MPI_Session_get_pset_info
        module procedure MPI_Session_get_pset_info_f08
    end interface MPI_Session_get_pset_info
    interface MPI_Session_attach_buffer
        module procedure MPI_Session_attach_buffer_f08ts
        module procedure MPI_Session_attach_buffer_c_f08ts
    end interface MPI_Session_attach_buffer
#endif

    contains

        subroutine make_c_string(f, c)
            character(len=*), intent(in) :: f
            character(kind=c_char), allocatable, intent(out) :: c(:)
            integer :: i, n
            n = len_trim(f)
            allocate(c(n + 1))
            c = c_null_char
            do i = 1, n
                c(i) = f(i:i)
            end do
        end subroutine make_c_string

        subroutine copy_c_string(c, f)
            character(kind=c_char), intent(in) :: c(:)
            character(len=*), intent(out) :: f
            integer :: i, n
            n = min(len(f), size(c))
            f = ' '
            do i = 1, n
                if (c(i) == c_null_char) exit
                f(i:i) = c(i)
            end do
        end subroutine copy_c_string

        subroutine MPI_Comm_group_f08(comm, group, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Group
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_group
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Group), intent(out) :: group
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_group(comm % MPI_VAL, group % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_group_f08

        subroutine MPI_Comm_remote_group_f08(comm, group, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Group
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_remote_group
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Group), intent(out) :: group
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_remote_group(comm % MPI_VAL, group % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_remote_group_f08

        subroutine MPI_Comm_remote_size_f08(comm, size, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_remote_size
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: size_c, ierror_c
            call VAPAA_MPI_Comm_remote_size(comm % MPI_VAL, size_c, ierror_c)
            size = size_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_remote_size_f08

        subroutine MPI_Comm_test_inter_f08(comm, flag, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_test_inter
            type(MPI_Comm), intent(in) :: comm
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(c_int) :: flag_c, ierror_c
            call VAPAA_MPI_Comm_test_inter(comm % MPI_VAL, flag_c, ierror_c)
            flag = flag_c /= 0
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_test_inter_f08

        subroutine MPI_Comm_get_info_f08(comm, info_used, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_get_info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(out) :: info_used
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_get_info(comm % MPI_VAL, info_used % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_get_info_f08

        subroutine MPI_Comm_set_info_f08(comm, info, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_set_info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_set_info(comm % MPI_VAL, info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_set_info_f08

        subroutine MPI_Comm_get_parent_f08(parent, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_get_parent
            type(MPI_Comm), intent(out) :: parent
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_get_parent(parent % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_get_parent_f08

        subroutine MPI_Comm_disconnect_f08(comm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_disconnect
            type(MPI_Comm), intent(inout) :: comm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_disconnect(comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_disconnect_f08

        subroutine MPI_Intercomm_create_f08(local_comm, local_leader, peer_comm, remote_leader, tag, newintercomm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Intercomm_create
            type(MPI_Comm), intent(in) :: local_comm, peer_comm
            integer, intent(in) :: local_leader, remote_leader, tag
            type(MPI_Comm), intent(out) :: newintercomm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Intercomm_create(local_comm % MPI_VAL, int(local_leader,c_int), peer_comm % MPI_VAL, &
                                            int(remote_leader,c_int), int(tag,c_int), newintercomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Intercomm_create_f08

        subroutine MPI_Intercomm_merge_f08(intercomm, high, newintracomm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Intercomm_merge
            type(MPI_Comm), intent(in) :: intercomm
            logical, intent(in) :: high
            type(MPI_Comm), intent(out) :: newintracomm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: high_c, ierror_c
            high_c = merge(1_c_int, 0_c_int, high)
            call VAPAA_MPI_Intercomm_merge(intercomm % MPI_VAL, high_c, newintracomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Intercomm_merge_f08

        subroutine MPI_Comm_join_f08(fd, intercomm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_join
            integer, intent(in) :: fd
            type(MPI_Comm), intent(out) :: intercomm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_join(int(fd,c_int), intercomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_join_f08

#ifdef HAVE_CFI
        subroutine MPI_Comm_get_name_f08(comm, comm_name, resultlen, ierror)
            use mpi_global_constants, only: MPI_MAX_OBJECT_NAME
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_get_name
            type(MPI_Comm), intent(in) :: comm
            character(len=MPI_MAX_OBJECT_NAME), intent(out) :: comm_name
            integer, intent(out) :: resultlen
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: comm_name_c(:)
            integer(c_int) :: resultlen_c, ierror_c
            allocate(comm_name_c(len(comm_name) + 1))
            comm_name_c = c_null_char
            call VAPAA_MPI_Comm_get_name(comm % MPI_VAL, comm_name_c, resultlen_c, ierror_c)
            call copy_c_string(comm_name_c, comm_name)
            resultlen = resultlen_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_get_name_f08

        subroutine MPI_Comm_set_name_f08(comm, comm_name, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_set_name
            type(MPI_Comm), intent(in) :: comm
            character(len=*), intent(in) :: comm_name
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: comm_name_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(comm_name, comm_name_c)
            call VAPAA_MPI_Comm_set_name(comm % MPI_VAL, comm_name_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_set_name_f08

        subroutine MPI_Comm_create_from_group_f08(group, stringtag, info, errhandler, newcomm, ierror)
            use mpi_handle_types, only: MPI_Group, MPI_Info, MPI_Errhandler, MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_create_from_group
            type(MPI_Group), intent(in) :: group
            character(len=*), intent(in) :: stringtag
            type(MPI_Info), intent(in) :: info
            type(MPI_Errhandler), intent(in) :: errhandler
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: stringtag_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(stringtag, stringtag_c)
            call VAPAA_MPI_Comm_create_from_group(group % MPI_VAL, stringtag_c, info % MPI_VAL, &
                                                  errhandler % MPI_VAL, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_create_from_group_f08

        subroutine MPI_Intercomm_create_from_groups_f08(local_group, local_leader, remote_group, remote_leader, &
                                                        stringtag, info, errhandler, newintercomm, ierror)
            use mpi_handle_types, only: MPI_Group, MPI_Info, MPI_Errhandler, MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Intercomm_create_from_groups
            type(MPI_Group), intent(in) :: local_group, remote_group
            integer, intent(in) :: local_leader, remote_leader
            character(len=*), intent(in) :: stringtag
            type(MPI_Info), intent(in) :: info
            type(MPI_Errhandler), intent(in) :: errhandler
            type(MPI_Comm), intent(out) :: newintercomm
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: stringtag_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(stringtag, stringtag_c)
            call VAPAA_MPI_Intercomm_create_from_groups(local_group % MPI_VAL, int(local_leader,c_int), &
                                                        remote_group % MPI_VAL, int(remote_leader,c_int), &
                                                        stringtag_c, info % MPI_VAL, errhandler % MPI_VAL, &
                                                        newintercomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Intercomm_create_from_groups_f08
#endif

        subroutine MPI_Comm_delete_attr_f08(comm, comm_keyval, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_delete_attr
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: comm_keyval
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_delete_attr(comm % MPI_VAL, int(comm_keyval,c_int), ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_delete_attr_f08

        subroutine MPI_Comm_free_keyval_f08(comm_keyval, ierror)
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_free_keyval
#ifdef HAVE_PGIF
            use mpi_direct_callback_f, only: VAPAA_PGIF_Comm_keyval_release
#endif
            integer, intent(inout) :: comm_keyval
            integer, optional, intent(out) :: ierror
            integer(c_int) :: keyval_c, old_keyval_c, ierror_c
            keyval_c = comm_keyval
            old_keyval_c = keyval_c
            call VAPAA_MPI_Comm_free_keyval(keyval_c, ierror_c)
#ifdef HAVE_PGIF
            if (ierror_c == 0_c_int) call VAPAA_PGIF_Comm_keyval_release(int(old_keyval_c))
#endif
            comm_keyval = keyval_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_free_keyval_f08

        subroutine MPI_Comm_get_attr_f08(comm, comm_keyval, attribute_val, flag, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_get_attr
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: comm_keyval
            integer(kind=MPI_ADDRESS_KIND), intent(out) :: attribute_val
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(c_int) :: flag_c, ierror_c
            call VAPAA_MPI_Comm_get_attr(comm % MPI_VAL, int(comm_keyval,c_int), attribute_val, flag_c, ierror_c)
            flag = flag_c /= 0
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_get_attr_f08

        subroutine MPI_Comm_set_attr_f08(comm, comm_keyval, attribute_val, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_set_attr
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: comm_keyval
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: attribute_val
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_set_attr(comm % MPI_VAL, int(comm_keyval,c_int), attribute_val, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_set_attr_f08

#ifdef HAVE_CFI
        subroutine MPI_Comm_attach_buffer_f08ts(comm, buffer, size, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_attach_buffer
            type(MPI_Comm), intent(in) :: comm
            type(*), dimension(..), asynchronous :: buffer
            integer, intent(in) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_attach_buffer(comm % MPI_VAL, buffer, int(size,c_int), ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_attach_buffer_f08ts

        subroutine MPI_Comm_attach_buffer_c_f08ts(comm, buffer, size, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_attach_buffer_c
            type(MPI_Comm), intent(in) :: comm
            type(*), dimension(..), asynchronous :: buffer
            integer(kind=MPI_COUNT_KIND), intent(in) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_attach_buffer_c(comm % MPI_VAL, buffer, size, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_attach_buffer_c_f08ts
#endif

        subroutine MPI_Comm_detach_buffer_f08(comm, buffer_addr, size, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_detach_buffer
            type(MPI_Comm), intent(in) :: comm
            type(c_ptr), intent(out) :: buffer_addr
            integer, intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: size_c, ierror_c
            call VAPAA_MPI_Comm_detach_buffer(comm % MPI_VAL, buffer_addr, size_c, ierror_c)
            size = size_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_detach_buffer_f08

        subroutine MPI_Comm_detach_buffer_c_f08(comm, buffer_addr, size, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_detach_buffer_c
            type(MPI_Comm), intent(in) :: comm
            type(c_ptr), intent(out) :: buffer_addr
            integer(kind=MPI_COUNT_KIND), intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_detach_buffer_c(comm % MPI_VAL, buffer_addr, size, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_detach_buffer_c_f08

        subroutine MPI_Comm_flush_buffer_f08(comm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_flush_buffer
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_flush_buffer(comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_flush_buffer_f08

        subroutine MPI_Comm_iflush_buffer_f08(comm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Request
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_iflush_buffer
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_iflush_buffer(comm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_iflush_buffer_f08

#ifdef HAVE_CFI
        subroutine MPI_Open_port_f08(info, port_name, ierror)
            use mpi_global_constants, only: MPI_MAX_PORT_NAME
            use mpi_handle_types, only: MPI_Info
            use mpi_direct_comm_c, only: VAPAA_MPI_Open_port
            type(MPI_Info), intent(in) :: info
            character(len=MPI_MAX_PORT_NAME), intent(out) :: port_name
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: port_name_c(:)
            integer(c_int) :: ierror_c
            allocate(port_name_c(len(port_name) + 1))
            port_name_c = c_null_char
            call VAPAA_MPI_Open_port(info % MPI_VAL, port_name_c, ierror_c)
            call copy_c_string(port_name_c, port_name)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Open_port_f08

        subroutine MPI_Close_port_f08(port_name, ierror)
            use mpi_direct_comm_c, only: VAPAA_MPI_Close_port
            character(len=*), intent(in) :: port_name
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: port_name_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(port_name, port_name_c)
            call VAPAA_MPI_Close_port(port_name_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Close_port_f08

        subroutine MPI_Comm_accept_f08(port_name, info, root, comm, newcomm, ierror)
            use mpi_handle_types, only: MPI_Info, MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_accept
            character(len=*), intent(in) :: port_name
            type(MPI_Info), intent(in) :: info
            integer, intent(in) :: root
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: port_name_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(port_name, port_name_c)
            call VAPAA_MPI_Comm_accept(port_name_c, info % MPI_VAL, int(root,c_int), comm % MPI_VAL, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_accept_f08

        subroutine MPI_Comm_connect_f08(port_name, info, root, comm, newcomm, ierror)
            use mpi_handle_types, only: MPI_Info, MPI_Comm
            use mpi_direct_comm_c, only: VAPAA_MPI_Comm_connect
            character(len=*), intent(in) :: port_name
            type(MPI_Info), intent(in) :: info
            integer, intent(in) :: root
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: port_name_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(port_name, port_name_c)
            call VAPAA_MPI_Comm_connect(port_name_c, info % MPI_VAL, int(root,c_int), comm % MPI_VAL, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_connect_f08

        subroutine MPI_Lookup_name_f08(service_name, info, port_name, ierror)
            use mpi_global_constants, only: MPI_MAX_PORT_NAME
            use mpi_handle_types, only: MPI_Info
            use mpi_direct_comm_c, only: VAPAA_MPI_Lookup_name
            character(len=*), intent(in) :: service_name
            type(MPI_Info), intent(in) :: info
            character(len=MPI_MAX_PORT_NAME), intent(out) :: port_name
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: service_name_c(:), port_name_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(service_name, service_name_c)
            allocate(port_name_c(len(port_name) + 1))
            port_name_c = c_null_char
            call VAPAA_MPI_Lookup_name(service_name_c, info % MPI_VAL, port_name_c, ierror_c)
            call copy_c_string(port_name_c, port_name)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Lookup_name_f08

        subroutine MPI_Publish_name_f08(service_name, info, port_name, ierror)
            use mpi_handle_types, only: MPI_Info
            use mpi_direct_comm_c, only: VAPAA_MPI_Publish_name
            character(len=*), intent(in) :: service_name, port_name
            type(MPI_Info), intent(in) :: info
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: service_name_c(:), port_name_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(service_name, service_name_c)
            call make_c_string(port_name, port_name_c)
            call VAPAA_MPI_Publish_name(service_name_c, info % MPI_VAL, port_name_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Publish_name_f08

        subroutine MPI_Unpublish_name_f08(service_name, info, port_name, ierror)
            use mpi_handle_types, only: MPI_Info
            use mpi_direct_comm_c, only: VAPAA_MPI_Unpublish_name
            character(len=*), intent(in) :: service_name, port_name
            type(MPI_Info), intent(in) :: info
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: service_name_c(:), port_name_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(service_name, service_name_c)
            call make_c_string(port_name, port_name_c)
            call VAPAA_MPI_Unpublish_name(service_name_c, info % MPI_VAL, port_name_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Unpublish_name_f08
#endif

        subroutine MPI_Session_init_f08(info, errhandler, session, ierror)
            use mpi_handle_types, only: MPI_Info, MPI_Errhandler, MPI_Session
            use mpi_direct_comm_c, only: VAPAA_MPI_Session_init
            type(MPI_Info), intent(in) :: info
            type(MPI_Errhandler), intent(in) :: errhandler
            type(MPI_Session), intent(out) :: session
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Session_init(info % MPI_VAL, errhandler % MPI_VAL, session % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_init_f08

        subroutine MPI_Session_finalize_f08(session, ierror)
            use mpi_handle_types, only: MPI_Session
            use mpi_direct_comm_c, only: VAPAA_MPI_Session_finalize
            type(MPI_Session), intent(inout) :: session
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Session_finalize(session % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_finalize_f08

        subroutine MPI_Session_get_info_f08(session, info_used, ierror)
            use mpi_handle_types, only: MPI_Session, MPI_Info
            use mpi_direct_comm_c, only: VAPAA_MPI_Session_get_info
            type(MPI_Session), intent(in) :: session
            type(MPI_Info), intent(out) :: info_used
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Session_get_info(session % MPI_VAL, info_used % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_get_info_f08

        subroutine MPI_Session_get_num_psets_f08(session, info, npset_names, ierror)
            use mpi_handle_types, only: MPI_Session, MPI_Info
            use mpi_direct_comm_c, only: VAPAA_MPI_Session_get_num_psets
            type(MPI_Session), intent(in) :: session
            type(MPI_Info), intent(in) :: info
            integer, intent(out) :: npset_names
            integer, optional, intent(out) :: ierror
            integer(c_int) :: npset_names_c, ierror_c
            call VAPAA_MPI_Session_get_num_psets(session % MPI_VAL, info % MPI_VAL, npset_names_c, ierror_c)
            npset_names = npset_names_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_get_num_psets_f08

#ifdef HAVE_CFI
        subroutine MPI_Session_get_nth_pset_f08(session, info, n, pset_len, pset_name, ierror)
            use mpi_handle_types, only: MPI_Session, MPI_Info
            use mpi_direct_comm_c, only: VAPAA_MPI_Session_get_nth_pset
            type(MPI_Session), intent(in) :: session
            type(MPI_Info), intent(in) :: info
            integer, intent(in) :: n
            integer, intent(inout) :: pset_len
            character(len=*), intent(out) :: pset_name
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: pset_name_c(:)
            integer(c_int) :: pset_len_c, ierror_c
            allocate(pset_name_c(len(pset_name) + 1))
            pset_name_c = c_null_char
            pset_len_c = pset_len
            call VAPAA_MPI_Session_get_nth_pset(session % MPI_VAL, info % MPI_VAL, int(n,c_int), pset_len_c, pset_name_c, ierror_c)
            call copy_c_string(pset_name_c, pset_name)
            pset_len = pset_len_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_get_nth_pset_f08

        subroutine MPI_Session_get_pset_info_f08(session, pset_name, info, ierror)
            use mpi_handle_types, only: MPI_Session, MPI_Info
            use mpi_direct_comm_c, only: VAPAA_MPI_Session_get_pset_info
            type(MPI_Session), intent(in) :: session
            character(len=*), intent(in) :: pset_name
            type(MPI_Info), intent(out) :: info
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: pset_name_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(pset_name, pset_name_c)
            call VAPAA_MPI_Session_get_pset_info(session % MPI_VAL, pset_name_c, info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_get_pset_info_f08
#endif

#ifdef HAVE_CFI
        subroutine MPI_Session_attach_buffer_f08ts(session, buffer, size, ierror)
            use mpi_handle_types, only: MPI_Session
            use mpi_direct_comm_c, only: VAPAA_MPI_Session_attach_buffer
            type(MPI_Session), intent(in) :: session
            type(*), dimension(..), asynchronous :: buffer
            integer, intent(in) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Session_attach_buffer(session % MPI_VAL, buffer, int(size,c_int), ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_attach_buffer_f08ts

        subroutine MPI_Session_attach_buffer_c_f08ts(session, buffer, size, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Session
            use mpi_direct_comm_c, only: VAPAA_MPI_Session_attach_buffer_c
            type(MPI_Session), intent(in) :: session
            type(*), dimension(..), asynchronous :: buffer
            integer(kind=MPI_COUNT_KIND), intent(in) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Session_attach_buffer_c(session % MPI_VAL, buffer, size, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_attach_buffer_c_f08ts
#endif

        subroutine MPI_Session_detach_buffer_f08(session, buffer_addr, size, ierror)
            use mpi_handle_types, only: MPI_Session
            use mpi_direct_comm_c, only: VAPAA_MPI_Session_detach_buffer
            type(MPI_Session), intent(in) :: session
            type(c_ptr), intent(out) :: buffer_addr
            integer, intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: size_c, ierror_c
            call VAPAA_MPI_Session_detach_buffer(session % MPI_VAL, buffer_addr, size_c, ierror_c)
            size = size_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_detach_buffer_f08

        subroutine MPI_Session_detach_buffer_c_f08(session, buffer_addr, size, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Session
            use mpi_direct_comm_c, only: VAPAA_MPI_Session_detach_buffer_c
            type(MPI_Session), intent(in) :: session
            type(c_ptr), intent(out) :: buffer_addr
            integer(kind=MPI_COUNT_KIND), intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Session_detach_buffer_c(session % MPI_VAL, buffer_addr, size, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_detach_buffer_c_f08

        subroutine MPI_Session_flush_buffer_f08(session, ierror)
            use mpi_handle_types, only: MPI_Session
            use mpi_direct_comm_c, only: VAPAA_MPI_Session_flush_buffer
            type(MPI_Session), intent(in) :: session
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Session_flush_buffer(session % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_flush_buffer_f08

        subroutine MPI_Session_iflush_buffer_f08(session, request, ierror)
            use mpi_handle_types, only: MPI_Session, MPI_Request
            use mpi_direct_comm_c, only: VAPAA_MPI_Session_iflush_buffer
            type(MPI_Session), intent(in) :: session
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Session_iflush_buffer(session % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Session_iflush_buffer_f08

end module mpi_direct_comm_f
