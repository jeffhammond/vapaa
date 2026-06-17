! SPDX-License-Identifier: MIT

module mpi_direct_comm_c
    use iso_c_binding, only: c_int, c_int64_t, c_intptr_t, c_ptr
    implicit none

    interface
        subroutine VAPAA_MPI_Comm_group(comm, group, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_group")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: group, ierror
        end subroutine VAPAA_MPI_Comm_group

        subroutine VAPAA_MPI_Comm_remote_group(comm, group, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_remote_group")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: group, ierror
        end subroutine VAPAA_MPI_Comm_remote_group

        subroutine VAPAA_MPI_Comm_remote_size(comm, size, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_remote_size")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: size, ierror
        end subroutine VAPAA_MPI_Comm_remote_size

        subroutine VAPAA_MPI_Comm_test_inter(comm, flag, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_test_inter")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine VAPAA_MPI_Comm_test_inter

        subroutine VAPAA_MPI_Comm_get_info(comm, info_used, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_get_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: info_used, ierror
        end subroutine VAPAA_MPI_Comm_get_info

        subroutine VAPAA_MPI_Comm_set_info(comm, info, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_set_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, info
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Comm_set_info

        subroutine VAPAA_MPI_Comm_get_parent(parent, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_get_parent")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: parent, ierror
        end subroutine VAPAA_MPI_Comm_get_parent

        subroutine VAPAA_MPI_Comm_disconnect(comm, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_disconnect")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Comm_disconnect

        subroutine VAPAA_MPI_Intercomm_create(local_comm, local_leader, peer_comm, remote_leader, tag, &
                                              newintercomm, ierror) &
                   bind(C,name="VAPAA_MPI_Intercomm_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: local_comm, local_leader, peer_comm, remote_leader, tag
            integer(kind=c_int), intent(out) :: newintercomm, ierror
        end subroutine VAPAA_MPI_Intercomm_create

        subroutine VAPAA_MPI_Intercomm_merge(intercomm, high, newintracomm, ierror) &
                   bind(C,name="VAPAA_MPI_Intercomm_merge")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: intercomm, high
            integer(kind=c_int), intent(out) :: newintracomm, ierror
        end subroutine VAPAA_MPI_Intercomm_merge

        subroutine VAPAA_MPI_Comm_join(fd, intercomm, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_join")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: fd
            integer(kind=c_int), intent(out) :: intercomm, ierror
        end subroutine VAPAA_MPI_Comm_join

        subroutine VAPAA_MPI_Comm_delete_attr(comm, keyval, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_delete_attr")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, keyval
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Comm_delete_attr

        subroutine VAPAA_MPI_Comm_free_keyval(keyval, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_free_keyval")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: keyval
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Comm_free_keyval

        subroutine VAPAA_MPI_Comm_get_attr(comm, keyval, attrval, flag, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_get_attr")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: comm, keyval
            integer(kind=c_intptr_t), intent(out) :: attrval
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine VAPAA_MPI_Comm_get_attr

        subroutine VAPAA_MPI_Comm_set_attr(comm, keyval, attrval, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_set_attr")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: comm, keyval
            integer(kind=c_intptr_t), intent(in) :: attrval
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Comm_set_attr

        subroutine VAPAA_MPI_Comm_detach_buffer(comm, buffer_addr, size, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_detach_buffer")
            use iso_c_binding, only: c_int, c_ptr
            implicit none
            integer(kind=c_int), intent(in) :: comm
            type(c_ptr), intent(out) :: buffer_addr
            integer(kind=c_int), intent(out) :: size
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Comm_detach_buffer

        subroutine VAPAA_MPI_Comm_detach_buffer_c(comm, buffer_addr, size, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_detach_buffer_c")
            use iso_c_binding, only: c_int, c_int64_t, c_ptr
            implicit none
            integer(kind=c_int), intent(in) :: comm
            type(c_ptr), intent(out) :: buffer_addr
            integer(kind=c_int64_t), intent(out) :: size
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Comm_detach_buffer_c

        subroutine VAPAA_MPI_Comm_flush_buffer(comm, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_flush_buffer")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Comm_flush_buffer

        subroutine VAPAA_MPI_Comm_iflush_buffer(comm, request, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_iflush_buffer")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine VAPAA_MPI_Comm_iflush_buffer

        subroutine VAPAA_MPI_Session_init(info, errhandler, session, ierror) &
                   bind(C,name="VAPAA_MPI_Session_init")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: info, errhandler
            integer(kind=c_int), intent(out) :: session, ierror
        end subroutine VAPAA_MPI_Session_init

        subroutine VAPAA_MPI_Session_finalize(session, ierror) &
                   bind(C,name="VAPAA_MPI_Session_finalize")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: session
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Session_finalize

        subroutine VAPAA_MPI_Session_get_info(session, info_used, ierror) &
                   bind(C,name="VAPAA_MPI_Session_get_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: session
            integer(kind=c_int), intent(out) :: info_used, ierror
        end subroutine VAPAA_MPI_Session_get_info

        subroutine VAPAA_MPI_Session_get_num_psets(session, info, npset_names, ierror) &
                   bind(C,name="VAPAA_MPI_Session_get_num_psets")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: session, info
            integer(kind=c_int), intent(out) :: npset_names, ierror
        end subroutine VAPAA_MPI_Session_get_num_psets

        subroutine VAPAA_MPI_Session_detach_buffer(session, buffer_addr, size, ierror) &
                   bind(C,name="VAPAA_MPI_Session_detach_buffer")
            use iso_c_binding, only: c_int, c_ptr
            implicit none
            integer(kind=c_int), intent(in) :: session
            type(c_ptr), intent(out) :: buffer_addr
            integer(kind=c_int), intent(out) :: size
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Session_detach_buffer

        subroutine VAPAA_MPI_Session_detach_buffer_c(session, buffer_addr, size, ierror) &
                   bind(C,name="VAPAA_MPI_Session_detach_buffer_c")
            use iso_c_binding, only: c_int, c_int64_t, c_ptr
            implicit none
            integer(kind=c_int), intent(in) :: session
            type(c_ptr), intent(out) :: buffer_addr
            integer(kind=c_int64_t), intent(out) :: size
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Session_detach_buffer_c

        subroutine VAPAA_MPI_Session_flush_buffer(session, ierror) &
                   bind(C,name="VAPAA_MPI_Session_flush_buffer")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: session
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Session_flush_buffer

        subroutine VAPAA_MPI_Session_iflush_buffer(session, request, ierror) &
                   bind(C,name="VAPAA_MPI_Session_iflush_buffer")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: session
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine VAPAA_MPI_Session_iflush_buffer
    end interface

#ifdef HAVE_CFI
    interface
        subroutine VAPAA_MPI_Comm_get_name(comm, name, resultlen, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_get_name")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            type(*), dimension(..), intent(inout) :: name
            integer(kind=c_int), intent(out) :: resultlen, ierror
        end subroutine VAPAA_MPI_Comm_get_name

        subroutine VAPAA_MPI_Comm_set_name(comm, name, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_set_name")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            type(*), dimension(..), intent(in) :: name
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Comm_set_name

        subroutine VAPAA_MPI_Comm_create_from_group(group, stringtag, info, errhandler, newcomm, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_create_from_group")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group, info, errhandler
            type(*), dimension(..), intent(in) :: stringtag
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine VAPAA_MPI_Comm_create_from_group

        subroutine VAPAA_MPI_Intercomm_create_from_groups(local_group, local_leader, remote_group, remote_leader, &
                                                          stringtag, info, errhandler, newintercomm, ierror) &
                   bind(C,name="VAPAA_MPI_Intercomm_create_from_groups")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: local_group, local_leader, remote_group, remote_leader, info, errhandler
            type(*), dimension(..), intent(in) :: stringtag
            integer(kind=c_int), intent(out) :: newintercomm, ierror
        end subroutine VAPAA_MPI_Intercomm_create_from_groups

        subroutine VAPAA_MPI_Comm_attach_buffer(comm, buffer, size, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_attach_buffer")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, size
            type(*), dimension(..), asynchronous :: buffer
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Comm_attach_buffer

        subroutine VAPAA_MPI_Comm_attach_buffer_c(comm, buffer, size, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_attach_buffer_c")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int64_t), intent(in) :: size
            type(*), dimension(..), asynchronous :: buffer
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Comm_attach_buffer_c

        subroutine VAPAA_MPI_Open_port(info, port_name, ierror) &
                   bind(C,name="VAPAA_MPI_Open_port")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: info
            type(*), dimension(..), intent(inout) :: port_name
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Open_port

        subroutine VAPAA_MPI_Close_port(port_name, ierror) &
                   bind(C,name="VAPAA_MPI_Close_port")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: port_name
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Close_port

        subroutine VAPAA_MPI_Comm_accept(port_name, info, root, comm, newcomm, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_accept")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: port_name
            integer(kind=c_int), intent(in) :: info, root, comm
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine VAPAA_MPI_Comm_accept

        subroutine VAPAA_MPI_Comm_connect(port_name, info, root, comm, newcomm, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_connect")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: port_name
            integer(kind=c_int), intent(in) :: info, root, comm
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine VAPAA_MPI_Comm_connect

        subroutine VAPAA_MPI_Lookup_name(service_name, info, port_name, ierror) &
                   bind(C,name="VAPAA_MPI_Lookup_name")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: service_name
            integer(kind=c_int), intent(in) :: info
            type(*), dimension(..), intent(inout) :: port_name
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Lookup_name

        subroutine VAPAA_MPI_Publish_name(service_name, info, port_name, ierror) &
                   bind(C,name="VAPAA_MPI_Publish_name")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: service_name, port_name
            integer(kind=c_int), intent(in) :: info
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Publish_name

        subroutine VAPAA_MPI_Unpublish_name(service_name, info, port_name, ierror) &
                   bind(C,name="VAPAA_MPI_Unpublish_name")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: service_name, port_name
            integer(kind=c_int), intent(in) :: info
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Unpublish_name

        subroutine VAPAA_MPI_Session_get_nth_pset(session, info, n, pset_len, pset_name, ierror) &
                   bind(C,name="VAPAA_MPI_Session_get_nth_pset")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: session, info, n
            integer(kind=c_int), intent(inout) :: pset_len
            type(*), dimension(..), intent(inout) :: pset_name
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Session_get_nth_pset

        subroutine VAPAA_MPI_Session_get_pset_info(session, pset_name, info, ierror) &
                   bind(C,name="VAPAA_MPI_Session_get_pset_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: session
            type(*), dimension(..), intent(in) :: pset_name
            integer(kind=c_int), intent(out) :: info, ierror
        end subroutine VAPAA_MPI_Session_get_pset_info

        subroutine VAPAA_MPI_Session_attach_buffer(session, buffer, size, ierror) &
                   bind(C,name="VAPAA_MPI_Session_attach_buffer")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: session, size
            type(*), dimension(..), asynchronous :: buffer
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Session_attach_buffer

        subroutine VAPAA_MPI_Session_attach_buffer_c(session, buffer, size, ierror) &
                   bind(C,name="VAPAA_MPI_Session_attach_buffer_c")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), intent(in) :: session
            integer(kind=c_int64_t), intent(in) :: size
            type(*), dimension(..), asynchronous :: buffer
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Session_attach_buffer_c
    end interface
#endif

end module mpi_direct_comm_c
