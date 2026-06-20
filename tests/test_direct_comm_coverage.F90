program test_direct_comm_coverage
    use iso_c_binding, only: c_ptr
    use mpi_f08
    implicit none

    integer :: ierr, rank, nranks

    call MPI_Init(ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Init")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_rank")
    call MPI_Comm_size(MPI_COMM_WORLD, nranks, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_size")
    call require(nranks == 4, "this test expects four ranks")
    call MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_set_errhandler world")
    call MPI_Comm_set_errhandler(MPI_COMM_SELF, MPI_ERRORS_RETURN, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_set_errhandler self")

    call run_comm_basics()
    call run_intercomm()
    call run_buffers_and_ports()
    call run_sessions()

    if (rank == 0) print *, "Test passed"
    call MPI_Finalize(ierr)

contains

    subroutine require(ok, label)
        logical, intent(in) :: ok
        character(len=*), intent(in) :: label

        if (.not. ok) then
            print *, "FAIL:", trim(label), "rank", rank, "ierr", ierr
            call MPI_Abort(MPI_COMM_WORLD, 1, ierr)
        end if
    end subroutine require

    subroutine require_success_or_unsupported(label)
        character(len=*), intent(in) :: label

        call require(ierr == MPI_SUCCESS .or. &
                     ierr == MPI_ERR_UNSUPPORTED_OPERATION, label)
    end subroutine require_success_or_unsupported

    logical function wait_request_if_supported(request, label) result(ran)
        type(MPI_Request), intent(inout) :: request
        character(len=*), intent(in) :: label

        if (ierr == MPI_SUCCESS) then
            call MPI_Wait(request, MPI_STATUS_IGNORE, ierr)
            call require(ierr == MPI_SUCCESS, trim(label) // " wait")
            ran = .true.
        else
            call require_success_or_unsupported(label)
            ran = .false.
        end if
    end function wait_request_if_supported

    subroutine run_comm_basics()
        type(MPI_Group) :: group
        type(MPI_Info) :: info_used, info
        type(MPI_Comm) :: dupcomm, newcomm
        type(MPI_Request) :: request
        logical :: flag
        integer :: result
        character(len=MPI_MAX_OBJECT_NAME) :: name

        call MPI_Comm_group(MPI_COMM_WORLD, group, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_group")

        call MPI_Info_create(info, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Info_create")
        call MPI_Comm_get_info(MPI_COMM_WORLD, info_used, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_get_info")
        call MPI_Info_free(info_used, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Info_free info_used")
        call MPI_Comm_set_info(MPI_COMM_WORLD, info, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_set_info")

        call MPI_Comm_dup_with_info(MPI_COMM_WORLD, info, dupcomm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_dup_with_info")
        call MPI_Comm_compare(MPI_COMM_WORLD, dupcomm, result, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_compare")
        call MPI_Comm_free(dupcomm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_free dupinfo")

        call MPI_Comm_idup(MPI_COMM_WORLD, dupcomm, request, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_idup")
        call MPI_Wait(request, MPI_STATUS_IGNORE, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_idup wait")
        call MPI_Comm_free(dupcomm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_free idup")

        call MPI_Comm_idup_with_info(MPI_COMM_WORLD, info, dupcomm, &
                                     request, ierr)
        if (wait_request_if_supported(request, "MPI_Comm_idup_with_info")) then
            call MPI_Comm_free(dupcomm, ierr)
            call require(ierr == MPI_SUCCESS, "MPI_Comm_free idup info")
        end if

        call MPI_Comm_test_inter(MPI_COMM_WORLD, flag, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_test_inter")
        call require(.not. flag, "MPI_Comm_test_inter payload")

        name = "vapaa direct comm coverage"
        call MPI_Comm_set_name(MPI_COMM_WORLD, name, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_set_name")
        name = ""
        call MPI_Comm_get_name(MPI_COMM_WORLD, name, result, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_get_name")

        call MPI_Comm_create_from_group(group, "vapaa-world-group", &
                                        info, MPI_ERRORS_RETURN, newcomm, &
                                        ierr)
        if (ierr == MPI_SUCCESS) then
            call MPI_Comm_free(newcomm, ierr)
            call require(ierr == MPI_SUCCESS, "MPI_Comm_free from_group")
        else
            call require_success_or_unsupported("MPI_Comm_create_from_group")
        end if

        call MPI_Info_free(info, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Info_free")
        call MPI_Group_free(group, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Group_free")
    end subroutine run_comm_basics

    subroutine run_intercomm()
        type(MPI_Comm) :: localcomm, intercomm, merged
        type(MPI_Group) :: remote_group
        integer :: color, local_leader, remote_leader, remote_size
        logical :: high

        color = merge(0, 1, rank < 2)
        call MPI_Comm_split(MPI_COMM_WORLD, color, rank, localcomm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_split")
        local_leader = 0
        remote_leader = merge(2, 0, color == 0)
        call MPI_Intercomm_create(localcomm, local_leader, &
                                  MPI_COMM_WORLD, remote_leader, 921, &
                                  intercomm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Intercomm_create")
        call MPI_Comm_remote_size(intercomm, remote_size, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_remote_size")
        call require(remote_size == 2, "MPI_Comm_remote_size payload")
        call MPI_Comm_remote_group(intercomm, remote_group, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_remote_group")
        call MPI_Group_free(remote_group, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Group_free remote")
        high = color == 1
        call MPI_Intercomm_merge(intercomm, high, merged, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Intercomm_merge")
        call MPI_Comm_disconnect(intercomm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_disconnect inter")
        call MPI_Comm_free(merged, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_free merged")
        call MPI_Comm_free(localcomm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_free local")
    end subroutine run_intercomm

    subroutine run_buffers_and_ports()
        integer, target :: buffer(1024)
        type(c_ptr) :: detached
        integer :: bufsize
        integer(kind=MPI_COUNT_KIND) :: csize
        type(MPI_Request) :: request
        character(len=MPI_MAX_PORT_NAME) :: port_name

        bufsize = storage_size(buffer(1)) / 8 * size(buffer)
        call MPI_Comm_attach_buffer(MPI_COMM_WORLD, buffer, bufsize, ierr)
        if (ierr == MPI_SUCCESS) then
            call MPI_Comm_flush_buffer(MPI_COMM_WORLD, ierr)
            call require(ierr == MPI_SUCCESS, "MPI_Comm_flush_buffer")
            call MPI_Comm_iflush_buffer(MPI_COMM_WORLD, request, ierr)
            if (wait_request_if_supported(request, &
                                          "MPI_Comm_iflush_buffer")) then
            end if
            call MPI_Comm_detach_buffer(MPI_COMM_WORLD, detached, bufsize, &
                                        ierr)
            call require(ierr == MPI_SUCCESS, "MPI_Comm_detach_buffer")
        else
            call require_success_or_unsupported("MPI_Comm_attach_buffer")
        end if

        csize = storage_size(buffer(1)) / 8 * size(buffer)
        call MPI_Comm_attach_buffer(MPI_COMM_WORLD, buffer, csize, ierr)
        if (ierr == MPI_SUCCESS) then
            call MPI_Comm_detach_buffer(MPI_COMM_WORLD, detached, csize, &
                                        ierr)
            call require(ierr == MPI_SUCCESS, "MPI_Comm_detach_buffer_c")
        else
            call require_success_or_unsupported("MPI_Comm_attach_buffer_c")
        end if

        call MPI_Open_port(MPI_INFO_NULL, port_name, ierr)
        call require_success_or_unsupported("MPI_Open_port")
        if (ierr == MPI_SUCCESS) then
            call MPI_Close_port(port_name, ierr)
            call require(ierr == MPI_SUCCESS, "MPI_Close_port")
        end if
    end subroutine run_buffers_and_ports

    subroutine run_sessions()
        type(MPI_Session) :: session
        type(MPI_Info) :: info
        type(MPI_Request) :: request
        type(c_ptr) :: detached
        integer, target :: buffer(1024)
        integer :: npsets, pset_len, bufsize
        integer(kind=MPI_COUNT_KIND) :: csize
        character(len=MPI_MAX_PSET_NAME_LEN) :: pset_name

        call MPI_Session_init(MPI_INFO_NULL, MPI_ERRORS_RETURN, session, &
                              ierr)
        call require_success_or_unsupported("MPI_Session_init")
        if (ierr /= MPI_SUCCESS) return

        call MPI_Session_get_info(session, info, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Session_get_info")
        call MPI_Info_free(info, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Info_free session info")
        call MPI_Session_get_num_psets(session, MPI_INFO_NULL, npsets, &
                                       ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Session_get_num_psets")
        if (npsets > 0) then
            pset_len = len(pset_name)
            call MPI_Session_get_nth_pset(session, MPI_INFO_NULL, 0, &
                                          pset_len, pset_name, ierr)
            call require(ierr == MPI_SUCCESS, "MPI_Session_get_nth_pset")
            call MPI_Session_get_pset_info(session, trim(pset_name), &
                                           info, ierr)
            call require(ierr == MPI_SUCCESS, &
                         "MPI_Session_get_pset_info")
            call MPI_Info_free(info, ierr)
            call require(ierr == MPI_SUCCESS, &
                         "MPI_Info_free pset info")
        end if

        bufsize = storage_size(buffer(1)) / 8 * size(buffer)
        call MPI_Session_attach_buffer(session, buffer, bufsize, ierr)
        if (ierr == MPI_SUCCESS) then
            call MPI_Session_flush_buffer(session, ierr)
            call require(ierr == MPI_SUCCESS, "MPI_Session_flush_buffer")
            call MPI_Session_iflush_buffer(session, request, ierr)
            if (wait_request_if_supported(request, &
                                          "MPI_Session_iflush_buffer")) then
            end if
            call MPI_Session_detach_buffer(session, detached, bufsize, ierr)
            call require(ierr == MPI_SUCCESS, "MPI_Session_detach_buffer")
        else
            call require_success_or_unsupported("MPI_Session_attach_buffer")
        end if

        csize = storage_size(buffer(1)) / 8 * size(buffer)
        call MPI_Session_attach_buffer(session, buffer, csize, ierr)
        if (ierr == MPI_SUCCESS) then
            call MPI_Session_detach_buffer(session, detached, csize, ierr)
            call require(ierr == MPI_SUCCESS, &
                         "MPI_Session_detach_buffer_c")
        else
            call require_success_or_unsupported( &
                 "MPI_Session_attach_buffer_c")
        end if

        call MPI_Session_finalize(session, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Session_finalize")
    end subroutine run_sessions

end program test_direct_comm_coverage
