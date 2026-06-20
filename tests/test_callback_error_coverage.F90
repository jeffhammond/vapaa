program test_callback_error_coverage
    use iso_c_binding, only: c_associated, c_ptr
    use iso_fortran_env, only: error_unit
    use mpi_f08
    implicit none

    integer :: ierr, rank
    integer :: comm_handler_calls, file_handler_calls, win_handler_calls
    integer :: session_handler_calls
    integer :: comm_copy_calls, comm_delete_calls
    integer :: type_copy_calls, type_delete_calls, win_delete_calls
    integer :: old_copy_calls, old_delete_calls
    integer :: greq_query_calls, greq_free_calls, greq_cancel_calls
    integer :: datarep_extent_calls, datarep_read_calls, datarep_write_calls
    integer :: datarep_read_c_calls, datarep_write_c_calls
    integer(kind=MPI_ADDRESS_KIND) :: greq_extra

    comm_handler_calls = 0
    file_handler_calls = 0
    win_handler_calls = 0
    session_handler_calls = 0
    comm_copy_calls = 0
    comm_delete_calls = 0
    type_copy_calls = 0
    type_delete_calls = 0
    win_delete_calls = 0
    old_copy_calls = 0
    old_delete_calls = 0
    greq_query_calls = 0
    greq_free_calls = 0
    greq_cancel_calls = 0
    datarep_extent_calls = 0
    datarep_read_calls = 0
    datarep_write_calls = 0
    datarep_read_c_calls = 0
    datarep_write_c_calls = 0
    greq_extra = 12345_MPI_ADDRESS_KIND

    call MPI_Init(ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Init")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_rank")
    call MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_set_errhandler world")
    call MPI_Comm_set_errhandler(MPI_COMM_SELF, MPI_ERRORS_RETURN, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_set_errhandler self")

    call run_errhandlers()
    call run_comm_attrs()
    call run_type_attrs()
    call run_win_attrs()
    call run_legacy_attrs()
    call run_grequests()
    call run_datarep_registration()

    if (rank == 0) print *, "Test passed"
    call MPI_Finalize(ierr)

contains

    subroutine require(ok, label)
        logical, intent(in) :: ok
        character(len=*), intent(in) :: label

        if (.not. ok) then
            write(error_unit, *) "FAIL:", trim(label), "rank", rank, &
                "ierr", ierr
            flush(error_unit)
            call MPI_Abort(MPI_COMM_WORLD, 1, ierr)
        end if
    end subroutine require

    subroutine require_success_or_unsupported(label)
        character(len=*), intent(in) :: label

        call require(ierr == MPI_SUCCESS .or. &
                     ierr == MPI_ERR_UNSUPPORTED_OPERATION, label)
    end subroutine require_success_or_unsupported

    subroutine run_errhandlers()
        type(MPI_Errhandler) :: comm_handler, file_handler, win_handler
        type(MPI_Errhandler) :: session_handler, current_handler
        type(MPI_Comm) :: comm
        type(MPI_File) :: fh
        type(MPI_Win) :: win
        type(MPI_Session) :: session
        integer, target :: winbuf(4)
        integer(kind=MPI_ADDRESS_KIND) :: winsize
        integer :: disp_unit
        character(len=96) :: filename

        call MPI_Comm_dup(MPI_COMM_SELF, comm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_dup errhandler")
        call MPI_Comm_create_errhandler(comm_errhandler, comm_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_create_errhandler")
        call MPI_Comm_set_errhandler(comm, comm_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_set_errhandler custom")
        call MPI_Comm_get_errhandler(comm, current_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_get_errhandler")
        call MPI_Errhandler_free(current_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Errhandler_free comm get")
        call MPI_Comm_call_errhandler(comm, MPI_ERR_OTHER, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_call_errhandler")
        call require(comm_handler_calls == 1, "comm errhandler callback")
        call MPI_Comm_set_errhandler(comm, MPI_ERRORS_RETURN, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_set_errhandler restore")
        call MPI_Errhandler_free(comm_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Errhandler_free comm")
        call MPI_Comm_free(comm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_free errhandler")

        write(filename, '("test_callback_error_",I0,".dat")') rank
        call MPI_File_open(MPI_COMM_SELF, trim(filename), &
                           MPI_MODE_CREATE + MPI_MODE_RDWR + &
                           MPI_MODE_DELETE_ON_CLOSE, MPI_INFO_NULL, fh, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_File_open errhandler")
        call MPI_File_create_errhandler(file_errhandler, file_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_File_create_errhandler")
        call MPI_File_set_errhandler(fh, file_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_File_set_errhandler custom")
        call MPI_File_get_errhandler(fh, current_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_File_get_errhandler")
        call MPI_Errhandler_free(current_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Errhandler_free file get")
        call MPI_File_call_errhandler(fh, MPI_ERR_OTHER, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_File_call_errhandler")
        call require(file_handler_calls == 1, "file errhandler callback")
        call MPI_File_set_errhandler(fh, MPI_ERRORS_RETURN, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_File_set_errhandler restore")
        call MPI_Errhandler_free(file_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Errhandler_free file")
        call MPI_File_close(fh, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_File_close errhandler")

        winbuf = rank
        winsize = int(size(winbuf) * storage_size(winbuf(1)) / 8, &
                      MPI_ADDRESS_KIND)
        disp_unit = storage_size(winbuf(1)) / 8
        call MPI_Win_create(winbuf, winsize, disp_unit, MPI_INFO_NULL, &
                            MPI_COMM_SELF, win, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Win_create errhandler")
        call MPI_Win_create_errhandler(win_errhandler, win_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Win_create_errhandler")
        call MPI_Win_set_errhandler(win, win_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Win_set_errhandler custom")
        call MPI_Win_get_errhandler(win, current_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Win_get_errhandler")
        call MPI_Errhandler_free(current_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Errhandler_free win get")
        call MPI_Win_call_errhandler(win, MPI_ERR_OTHER, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Win_call_errhandler")
        call require(win_handler_calls == 1, "win errhandler callback")
        call MPI_Win_set_errhandler(win, MPI_ERRORS_RETURN, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Win_set_errhandler restore")
        call MPI_Errhandler_free(win_handler, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Errhandler_free win")
        call MPI_Win_free(win, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Win_free errhandler")

        call MPI_Session_create_errhandler(session_errhandler, &
                                           session_handler, ierr)
        if (ierr == MPI_SUCCESS) then
            call MPI_Session_init(MPI_INFO_NULL, session_handler, session, &
                                  ierr)
            if (ierr == MPI_SUCCESS) then
                call MPI_Session_get_errhandler(session, current_handler, &
                                                ierr)
                call require(ierr == MPI_SUCCESS, &
                             "MPI_Session_get_errhandler")
                call MPI_Errhandler_free(current_handler, ierr)
                call require(ierr == MPI_SUCCESS, &
                             "MPI_Errhandler_free session get")
                call MPI_Session_set_errhandler(session, session_handler, &
                                                ierr)
                call require(ierr == MPI_SUCCESS, &
                             "MPI_Session_set_errhandler")
                call MPI_Session_call_errhandler(session, MPI_ERR_OTHER, &
                                                 ierr)
                call require(ierr == MPI_SUCCESS, &
                             "MPI_Session_call_errhandler")
                call require(session_handler_calls == 1, &
                             "session errhandler callback")
                call MPI_Session_finalize(session, ierr)
                call require(ierr == MPI_SUCCESS, "MPI_Session_finalize")
            else
                call require_success_or_unsupported("MPI_Session_init")
            end if
            call MPI_Errhandler_free(session_handler, ierr)
            call require(ierr == MPI_SUCCESS, "MPI_Errhandler_free session")
        else
            call require_success_or_unsupported( &
                 "MPI_Session_create_errhandler")
        end if
    end subroutine run_errhandlers

    subroutine run_comm_attrs()
        type(MPI_Comm) :: comm, copied
        integer :: keyval
        integer(kind=MPI_ADDRESS_KIND) :: extra, attr, got
        logical :: flag

        extra = 7_MPI_ADDRESS_KIND
        attr = 100_MPI_ADDRESS_KIND + rank
        call MPI_Comm_create_keyval(comm_copy_cb, comm_delete_cb, keyval, &
                                    extra, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_create_keyval")
        call MPI_Comm_dup(MPI_COMM_SELF, comm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_dup attr base")
        call MPI_Comm_set_attr(comm, keyval, attr, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_set_attr")
        call MPI_Comm_dup(comm, copied, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_dup attr copy")
        call require(comm_copy_calls == 1, "comm attr copy callback")
        call MPI_Comm_get_attr(copied, keyval, got, flag, ierr)
        call require(ierr == MPI_SUCCESS .and. flag, "MPI_Comm_get_attr")
        call require(got == attr + extra, "comm copied attr payload")
        call MPI_Comm_delete_attr(copied, keyval, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_delete_attr copied")
        call MPI_Comm_free(copied, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_free attr copied")
        call MPI_Comm_delete_attr(comm, keyval, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_delete_attr base")
        call MPI_Comm_free(comm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_free attr base")
        call MPI_Comm_free_keyval(keyval, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_free_keyval")
        call require(comm_delete_calls == 2, "comm attr delete callbacks")
    end subroutine run_comm_attrs

    subroutine run_type_attrs()
        type(MPI_Datatype) :: dtype, copied
        integer :: keyval
        integer(kind=MPI_ADDRESS_KIND) :: extra, attr, got
        logical :: flag

        extra = 11_MPI_ADDRESS_KIND
        attr = 200_MPI_ADDRESS_KIND + rank
        call MPI_Type_create_keyval(type_copy_cb, type_delete_cb, keyval, &
                                    extra, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_create_keyval")
        call MPI_Type_contiguous(2, MPI_INTEGER, dtype, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_contiguous attr")
        call MPI_Type_commit(dtype, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_commit attr")
        call MPI_Type_set_attr(dtype, keyval, attr, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_set_attr")
        call MPI_Type_dup(dtype, copied, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_dup attr copy")
        call require(type_copy_calls == 1, "type attr copy callback")
        call MPI_Type_get_attr(copied, keyval, got, flag, ierr)
        call require(ierr == MPI_SUCCESS .and. flag, "MPI_Type_get_attr")
        call require(got == attr + extra, "type copied attr payload")
        call MPI_Type_delete_attr(copied, keyval, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_delete_attr copied")
        call MPI_Type_free(copied, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_free copied")
        call MPI_Type_delete_attr(dtype, keyval, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_delete_attr base")
        call MPI_Type_free(dtype, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_free base")
        call MPI_Type_free_keyval(keyval, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_free_keyval")
        call require(type_delete_calls == 2, "type attr delete callbacks")
    end subroutine run_type_attrs

    subroutine run_win_attrs()
        type(MPI_Win) :: win
        integer, target :: winbuf(2)
        integer :: keyval, disp_unit
        integer(kind=MPI_ADDRESS_KIND) :: winsize, extra, attr, got
        logical :: flag

        extra = 13_MPI_ADDRESS_KIND
        attr = 300_MPI_ADDRESS_KIND + rank
        winbuf = rank
        winsize = int(size(winbuf) * storage_size(winbuf(1)) / 8, &
                      MPI_ADDRESS_KIND)
        disp_unit = storage_size(winbuf(1)) / 8
        call MPI_Win_create_keyval(win_copy_cb, win_delete_cb, keyval, &
                                   extra, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Win_create_keyval")
        call MPI_Win_create(winbuf, winsize, disp_unit, MPI_INFO_NULL, &
                            MPI_COMM_SELF, win, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Win_create attr")
        call MPI_Win_set_attr(win, keyval, attr, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Win_set_attr")
        call MPI_Win_get_attr(win, keyval, got, flag, ierr)
        call require(ierr == MPI_SUCCESS .and. flag, "MPI_Win_get_attr")
        call require(got == attr, "win attr payload")
        call MPI_Win_delete_attr(win, keyval, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Win_delete_attr")
        call MPI_Win_free(win, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Win_free attr")
        call MPI_Win_free_keyval(keyval, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Win_free_keyval")
        call require(win_delete_calls == 1, "win attr delete callback")
    end subroutine run_win_attrs

    subroutine run_legacy_attrs()
        type(MPI_Comm) :: comm, copied
        integer :: keyval, attr, got
        logical :: flag

        attr = 400 + rank
        call MPI_Keyval_create(old_copy_cb, old_delete_cb, keyval, 5, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Keyval_create")
        call MPI_Comm_dup(MPI_COMM_SELF, comm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_dup legacy attr")
        call MPI_Attr_put(comm, keyval, attr, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Attr_put")
        call MPI_Comm_dup(comm, copied, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_dup legacy copy")
        call require(old_copy_calls == 1, "legacy attr copy callback")
        call MPI_Attr_get(copied, keyval, got, flag, ierr)
        call require(ierr == MPI_SUCCESS .and. flag, "MPI_Attr_get")
        call require(got == attr + 5, "legacy attr payload")
        call MPI_Attr_delete(copied, keyval, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Attr_delete copied")
        call MPI_Comm_free(copied, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_free legacy copied")
        call MPI_Attr_delete(comm, keyval, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Attr_delete base")
        call MPI_Comm_free(comm, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Comm_free legacy base")
        call MPI_Keyval_free(keyval, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Keyval_free")
        call require(old_delete_calls == 2, "legacy attr delete callbacks")
    end subroutine run_legacy_attrs

    subroutine run_grequests()
        type(MPI_Request) :: request
        type(MPI_Status) :: status

        call MPI_Grequest_start(greq_query_cb, greq_free_cb, &
                                greq_cancel_cb, greq_extra, request, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Grequest_start complete")
        call MPI_Grequest_complete(request, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Grequest_complete")
        call MPI_Wait(request, status, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Wait grequest")
        call require(greq_query_calls == 1, "grequest query callback")
        call require(greq_free_calls == 1, "grequest free callback")

        call MPI_Grequest_start(greq_query_cb, greq_free_cb, &
                                greq_cancel_cb, greq_extra, request, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Grequest_start cancel")
        call MPI_Cancel(request, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Cancel grequest")
        call MPI_Grequest_complete(request, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Grequest_complete cancel")
        call MPI_Wait(request, status, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Wait grequest cancel")
        call require(greq_cancel_calls == 1, "grequest cancel callback")
        call require(greq_query_calls == 2, "grequest second query")
        call require(greq_free_calls == 2, "grequest second free")
    end subroutine run_grequests

    subroutine run_datarep_registration()
        character(len=64) :: name

        write(name, '("vapaa_cb_datarep_",I0)') rank
        call MPI_Register_datarep(trim(name), datarep_read_cb, &
                                  datarep_write_cb, datarep_extent_cb, &
                                  19_MPI_ADDRESS_KIND, ierr)
        call require(ierr == MPI_SUCCESS .or. &
                     ierr == MPI_ERR_CONVERSION .or. &
                     ierr == MPI_ERR_UNSUPPORTED_DATAREP .or. &
                     ierr == MPI_ERR_UNSUPPORTED_OPERATION .or. &
                     ierr == MPI_ERR_OTHER, &
                     "MPI_Register_datarep")

        write(name, '("vapaa_cb_datarep_c_",I0)') rank
        call MPI_Register_datarep_c(trim(name), datarep_read_c_cb, &
                                    datarep_write_c_cb, datarep_extent_cb, &
                                    23_MPI_ADDRESS_KIND, ierr)
        call require(ierr == MPI_SUCCESS .or. &
                     ierr == MPI_ERR_CONVERSION .or. &
                     ierr == MPI_ERR_UNSUPPORTED_DATAREP .or. &
                     ierr == MPI_ERR_UNSUPPORTED_OPERATION .or. &
                     ierr == MPI_ERR_OTHER, &
                     "MPI_Register_datarep_c")
    end subroutine run_datarep_registration

    subroutine comm_errhandler(comm, error_code)
        type(MPI_Comm) :: comm
        integer :: error_code

        if (comm % MPI_VAL == MPI_COMM_NULL % MPI_VAL) then
            ierr = MPI_ERR_COMM
        end if
        call require(error_code == MPI_ERR_OTHER, "comm errhandler code")
        comm_handler_calls = comm_handler_calls + 1
    end subroutine comm_errhandler

    subroutine file_errhandler(file, error_code)
        type(MPI_File) :: file
        integer :: error_code

        if (file % MPI_VAL == MPI_FILE_NULL % MPI_VAL) then
            ierr = MPI_ERR_FILE
        end if
        call require(error_code == MPI_ERR_OTHER, "file errhandler code")
        file_handler_calls = file_handler_calls + 1
    end subroutine file_errhandler

    subroutine win_errhandler(win, error_code)
        type(MPI_Win) :: win
        integer :: error_code

        if (win % MPI_VAL == MPI_WIN_NULL % MPI_VAL) then
            ierr = MPI_ERR_WIN
        end if
        call require(error_code == MPI_ERR_OTHER, "win errhandler code")
        win_handler_calls = win_handler_calls + 1
    end subroutine win_errhandler

    subroutine session_errhandler(session, error_code)
        type(MPI_Session) :: session
        integer :: error_code

        if (session % MPI_VAL == MPI_SESSION_NULL % MPI_VAL) then
            ierr = MPI_ERR_SESSION
        end if
        call require(error_code == MPI_ERR_OTHER, "session errhandler code")
        session_handler_calls = session_handler_calls + 1
    end subroutine session_errhandler

    subroutine comm_copy_cb(oldcomm, comm_keyval, extra_state, &
                            attribute_val_in, attribute_val_out, flag, &
                            cb_ierr)
        type(MPI_Comm) :: oldcomm
        integer :: comm_keyval, cb_ierr
        integer(kind=MPI_ADDRESS_KIND) :: extra_state
        integer(kind=MPI_ADDRESS_KIND) :: attribute_val_in
        integer(kind=MPI_ADDRESS_KIND) :: attribute_val_out
        logical :: flag

        if (oldcomm % MPI_VAL == MPI_COMM_NULL % MPI_VAL) cb_ierr = MPI_ERR_COMM
        if (comm_keyval == MPI_KEYVAL_INVALID) cb_ierr = MPI_ERR_KEYVAL
        attribute_val_out = attribute_val_in + extra_state
        flag = .true.
        cb_ierr = MPI_SUCCESS
        comm_copy_calls = comm_copy_calls + 1
    end subroutine comm_copy_cb

    subroutine comm_delete_cb(comm, comm_keyval, attribute_val, &
                              extra_state, cb_ierr)
        type(MPI_Comm) :: comm
        integer :: comm_keyval, cb_ierr
        integer(kind=MPI_ADDRESS_KIND) :: attribute_val, extra_state

        if (comm % MPI_VAL == MPI_COMM_NULL % MPI_VAL) cb_ierr = MPI_ERR_COMM
        if (comm_keyval == MPI_KEYVAL_INVALID) cb_ierr = MPI_ERR_KEYVAL
        if (attribute_val < extra_state) cb_ierr = MPI_ERR_OTHER
        cb_ierr = MPI_SUCCESS
        comm_delete_calls = comm_delete_calls + 1
    end subroutine comm_delete_cb

    subroutine type_copy_cb(oldtype, type_keyval, extra_state, &
                            attribute_val_in, attribute_val_out, flag, &
                            cb_ierr)
        type(MPI_Datatype) :: oldtype
        integer :: type_keyval, cb_ierr
        integer(kind=MPI_ADDRESS_KIND) :: extra_state
        integer(kind=MPI_ADDRESS_KIND) :: attribute_val_in
        integer(kind=MPI_ADDRESS_KIND) :: attribute_val_out
        logical :: flag

        if (oldtype % MPI_VAL == MPI_DATATYPE_NULL % MPI_VAL) cb_ierr = MPI_ERR_TYPE
        if (type_keyval == MPI_KEYVAL_INVALID) cb_ierr = MPI_ERR_KEYVAL
        attribute_val_out = attribute_val_in + extra_state
        flag = .true.
        cb_ierr = MPI_SUCCESS
        type_copy_calls = type_copy_calls + 1
    end subroutine type_copy_cb

    subroutine type_delete_cb(datatype, type_keyval, attribute_val, &
                              extra_state, cb_ierr)
        type(MPI_Datatype) :: datatype
        integer :: type_keyval, cb_ierr
        integer(kind=MPI_ADDRESS_KIND) :: attribute_val, extra_state

        if (datatype % MPI_VAL == MPI_DATATYPE_NULL % MPI_VAL) cb_ierr = MPI_ERR_TYPE
        if (type_keyval == MPI_KEYVAL_INVALID) cb_ierr = MPI_ERR_KEYVAL
        if (attribute_val < extra_state) cb_ierr = MPI_ERR_OTHER
        cb_ierr = MPI_SUCCESS
        type_delete_calls = type_delete_calls + 1
    end subroutine type_delete_cb

    subroutine win_copy_cb(oldwin, win_keyval, extra_state, &
                           attribute_val_in, attribute_val_out, flag, &
                           cb_ierr)
        type(MPI_Win) :: oldwin
        integer :: win_keyval, cb_ierr
        integer(kind=MPI_ADDRESS_KIND) :: extra_state
        integer(kind=MPI_ADDRESS_KIND) :: attribute_val_in
        integer(kind=MPI_ADDRESS_KIND) :: attribute_val_out
        logical :: flag

        if (oldwin % MPI_VAL == MPI_WIN_NULL % MPI_VAL) cb_ierr = MPI_ERR_WIN
        if (win_keyval == MPI_KEYVAL_INVALID) cb_ierr = MPI_ERR_KEYVAL
        attribute_val_out = attribute_val_in + extra_state
        flag = .true.
        cb_ierr = MPI_SUCCESS
    end subroutine win_copy_cb

    subroutine win_delete_cb(win, win_keyval, attribute_val, extra_state, &
                             cb_ierr)
        type(MPI_Win) :: win
        integer :: win_keyval, cb_ierr
        integer(kind=MPI_ADDRESS_KIND) :: attribute_val, extra_state

        if (win % MPI_VAL == MPI_WIN_NULL % MPI_VAL) cb_ierr = MPI_ERR_WIN
        if (win_keyval == MPI_KEYVAL_INVALID) cb_ierr = MPI_ERR_KEYVAL
        if (attribute_val < extra_state) cb_ierr = MPI_ERR_OTHER
        cb_ierr = MPI_SUCCESS
        win_delete_calls = win_delete_calls + 1
    end subroutine win_delete_cb

    subroutine old_copy_cb(oldcomm, comm_keyval, extra_state, &
                           attribute_val_in, attribute_val_out, flag, &
                           cb_ierr)
        type(MPI_Comm) :: oldcomm
        integer :: comm_keyval, extra_state, attribute_val_in
        integer :: attribute_val_out, cb_ierr
        logical :: flag

        if (oldcomm % MPI_VAL == MPI_COMM_NULL % MPI_VAL) cb_ierr = MPI_ERR_COMM
        if (comm_keyval == MPI_KEYVAL_INVALID) cb_ierr = MPI_ERR_KEYVAL
        attribute_val_out = attribute_val_in + extra_state
        flag = .true.
        cb_ierr = MPI_SUCCESS
        old_copy_calls = old_copy_calls + 1
    end subroutine old_copy_cb

    subroutine old_delete_cb(comm, comm_keyval, attribute_val, extra_state, &
                             cb_ierr)
        type(MPI_Comm) :: comm
        integer :: comm_keyval, attribute_val, extra_state, cb_ierr

        if (comm % MPI_VAL == MPI_COMM_NULL % MPI_VAL) cb_ierr = MPI_ERR_COMM
        if (comm_keyval == MPI_KEYVAL_INVALID) cb_ierr = MPI_ERR_KEYVAL
        if (attribute_val < extra_state) cb_ierr = MPI_ERR_OTHER
        cb_ierr = MPI_SUCCESS
        old_delete_calls = old_delete_calls + 1
    end subroutine old_delete_cb

    subroutine greq_query_cb(extra_state, status, cb_ierr)
        integer(kind=MPI_ADDRESS_KIND) :: extra_state
        type(MPI_Status) :: status
        integer :: cb_ierr

        call require(extra_state == greq_extra, "grequest query extra")
        status % MPI_SOURCE = MPI_UNDEFINED
        status % MPI_TAG = MPI_UNDEFINED
        status % MPI_ERROR = MPI_SUCCESS
        cb_ierr = MPI_SUCCESS
        greq_query_calls = greq_query_calls + 1
    end subroutine greq_query_cb

    subroutine greq_free_cb(extra_state, cb_ierr)
        integer(kind=MPI_ADDRESS_KIND) :: extra_state
        integer :: cb_ierr

        call require(extra_state == greq_extra, "grequest free extra")
        cb_ierr = MPI_SUCCESS
        greq_free_calls = greq_free_calls + 1
    end subroutine greq_free_cb

    subroutine greq_cancel_cb(extra_state, complete, cb_ierr)
        integer(kind=MPI_ADDRESS_KIND) :: extra_state
        logical :: complete
        integer :: cb_ierr

        call require(extra_state == greq_extra, "grequest cancel extra")
        cb_ierr = MPI_SUCCESS
        if (.not. complete) greq_cancel_calls = greq_cancel_calls + 1
    end subroutine greq_cancel_cb

    subroutine datarep_extent_cb(datatype, extent, extra_state, cb_ierr)
        type(MPI_Datatype) :: datatype
        integer(kind=MPI_ADDRESS_KIND) :: extent, extra_state
        integer :: cb_ierr
        integer(kind=MPI_ADDRESS_KIND) :: lb

        extent = 0_MPI_ADDRESS_KIND
        call MPI_Type_get_extent(datatype, lb, extent, cb_ierr)
        if (extra_state < 0_MPI_ADDRESS_KIND) cb_ierr = MPI_ERR_OTHER
        datarep_extent_calls = datarep_extent_calls + 1
    end subroutine datarep_extent_cb

    subroutine datarep_read_cb(userbuf, datatype, count, filebuf, position, &
                               extra_state, cb_ierr)
        type(c_ptr), value :: userbuf, filebuf
        type(MPI_Datatype) :: datatype
        integer :: count, cb_ierr
        integer(kind=MPI_OFFSET_KIND) :: position
        integer(kind=MPI_ADDRESS_KIND) :: extra_state

        if (count < 0) cb_ierr = MPI_ERR_COUNT
        if (position < 0_MPI_OFFSET_KIND) cb_ierr = MPI_ERR_OTHER
        if (extra_state < 0_MPI_ADDRESS_KIND) cb_ierr = MPI_ERR_OTHER
        if (datatype % MPI_VAL == MPI_DATATYPE_NULL % MPI_VAL) cb_ierr = MPI_ERR_TYPE
        cb_ierr = MPI_SUCCESS
        datarep_read_calls = datarep_read_calls + 1
        if (c_associated(userbuf, filebuf)) cb_ierr = MPI_SUCCESS
    end subroutine datarep_read_cb

    subroutine datarep_write_cb(userbuf, datatype, count, filebuf, position, &
                                extra_state, cb_ierr)
        type(c_ptr), value :: userbuf, filebuf
        type(MPI_Datatype) :: datatype
        integer :: count, cb_ierr
        integer(kind=MPI_OFFSET_KIND) :: position
        integer(kind=MPI_ADDRESS_KIND) :: extra_state

        if (count < 0) cb_ierr = MPI_ERR_COUNT
        if (position < 0_MPI_OFFSET_KIND) cb_ierr = MPI_ERR_OTHER
        if (extra_state < 0_MPI_ADDRESS_KIND) cb_ierr = MPI_ERR_OTHER
        if (datatype % MPI_VAL == MPI_DATATYPE_NULL % MPI_VAL) cb_ierr = MPI_ERR_TYPE
        cb_ierr = MPI_SUCCESS
        datarep_write_calls = datarep_write_calls + 1
        if (c_associated(userbuf, filebuf)) cb_ierr = MPI_SUCCESS
    end subroutine datarep_write_cb

    subroutine datarep_read_c_cb(userbuf, datatype, count, filebuf, position, &
                                 extra_state, cb_ierr)
        type(c_ptr), value :: userbuf, filebuf
        type(MPI_Datatype) :: datatype
        integer(kind=MPI_COUNT_KIND) :: count
        integer(kind=MPI_OFFSET_KIND) :: position
        integer(kind=MPI_ADDRESS_KIND) :: extra_state
        integer :: cb_ierr

        if (count < 0_MPI_COUNT_KIND) cb_ierr = MPI_ERR_COUNT
        if (position < 0_MPI_OFFSET_KIND) cb_ierr = MPI_ERR_OTHER
        if (extra_state < 0_MPI_ADDRESS_KIND) cb_ierr = MPI_ERR_OTHER
        if (datatype % MPI_VAL == MPI_DATATYPE_NULL % MPI_VAL) cb_ierr = MPI_ERR_TYPE
        cb_ierr = MPI_SUCCESS
        datarep_read_c_calls = datarep_read_c_calls + 1
        if (c_associated(userbuf, filebuf)) cb_ierr = MPI_SUCCESS
    end subroutine datarep_read_c_cb

    subroutine datarep_write_c_cb(userbuf, datatype, count, filebuf, &
                                  position, extra_state, cb_ierr)
        type(c_ptr), value :: userbuf, filebuf
        type(MPI_Datatype) :: datatype
        integer(kind=MPI_COUNT_KIND) :: count
        integer(kind=MPI_OFFSET_KIND) :: position
        integer(kind=MPI_ADDRESS_KIND) :: extra_state
        integer :: cb_ierr

        if (count < 0_MPI_COUNT_KIND) cb_ierr = MPI_ERR_COUNT
        if (position < 0_MPI_OFFSET_KIND) cb_ierr = MPI_ERR_OTHER
        if (extra_state < 0_MPI_ADDRESS_KIND) cb_ierr = MPI_ERR_OTHER
        if (datatype % MPI_VAL == MPI_DATATYPE_NULL % MPI_VAL) cb_ierr = MPI_ERR_TYPE
        cb_ierr = MPI_SUCCESS
        datarep_write_c_calls = datarep_write_c_calls + 1
        if (c_associated(userbuf, filebuf)) cb_ierr = MPI_SUCCESS
    end subroutine datarep_write_c_cb

end program test_callback_error_coverage
