! SPDX-License-Identifier: MIT

module mpi_direct_callback_f
    use iso_c_binding, only: c_char, c_funloc, c_funptr, c_int, c_intptr_t, c_null_char
    use mpi_f08_callbacks
    implicit none

    interface MPI_Comm_create_errhandler
        module procedure MPI_Comm_create_errhandler_f08
    end interface
    interface MPI_File_create_errhandler
        module procedure MPI_File_create_errhandler_f08
    end interface
    interface MPI_Win_create_errhandler
        module procedure MPI_Win_create_errhandler_f08
    end interface
    interface MPI_Session_create_errhandler
        module procedure MPI_Session_create_errhandler_f08
    end interface
    interface MPI_Comm_create_keyval
        module procedure MPI_Comm_create_keyval_f08
    end interface
    interface MPI_Type_create_keyval
        module procedure MPI_Type_create_keyval_f08
    end interface
    interface MPI_Win_create_keyval
        module procedure MPI_Win_create_keyval_f08
    end interface
    interface MPI_Keyval_create
        module procedure MPI_Keyval_create_f08
    end interface
    interface MPI_Grequest_start
        module procedure MPI_Grequest_start_f08
    end interface
    interface MPI_Grequest_complete
        module procedure MPI_Grequest_complete_f08
    end interface
    interface MPI_Op_create_c
        module procedure MPI_Op_create_c_f08
    end interface
    interface MPI_Register_datarep
        module procedure MPI_Register_datarep_f08
    end interface
    interface MPI_Register_datarep_c
        module procedure MPI_Register_datarep_c_f08
    end interface
    interface MPI_Comm_spawn
        module procedure MPI_Comm_spawn_f08
    end interface
    interface MPI_Comm_spawn_multiple
        module procedure MPI_Comm_spawn_multiple_f08
    end interface

#ifdef HAVE_PGIF
    integer, parameter :: VAPAA_PGIF_KEYVAL_SLOTS = 256

    type :: pgif_comm_keyval_slot
        logical :: in_use = .false.
        integer(c_int) :: keyval = 0_c_int
        integer(c_intptr_t) :: extra_state = 0_c_intptr_t
        procedure(MPI_Comm_copy_attr_function), pointer, nopass :: copy_fn => null()
        procedure(MPI_Comm_delete_attr_function), pointer, nopass :: delete_fn => null()
    end type pgif_comm_keyval_slot

    type :: pgif_type_keyval_slot
        logical :: in_use = .false.
        integer(c_int) :: keyval = 0_c_int
        integer(c_intptr_t) :: extra_state = 0_c_intptr_t
        procedure(MPI_Type_copy_attr_function), pointer, nopass :: copy_fn => null()
        procedure(MPI_Type_delete_attr_function), pointer, nopass :: delete_fn => null()
    end type pgif_type_keyval_slot

    type :: pgif_win_keyval_slot
        logical :: in_use = .false.
        integer(c_int) :: keyval = 0_c_int
        integer(c_intptr_t) :: extra_state = 0_c_intptr_t
        procedure(MPI_Win_copy_attr_function), pointer, nopass :: copy_fn => null()
        procedure(MPI_Win_delete_attr_function), pointer, nopass :: delete_fn => null()
    end type pgif_win_keyval_slot

    type :: pgif_keyval_slot
        logical :: in_use = .false.
        integer(c_int) :: keyval = 0_c_int
        integer(c_int) :: extra_state = 0_c_int
        procedure(), pointer, nopass :: copy_fn => null()
        procedure(), pointer, nopass :: delete_fn => null()
    end type pgif_keyval_slot

    type(pgif_comm_keyval_slot), save :: pgif_comm_slots(VAPAA_PGIF_KEYVAL_SLOTS)
    type(pgif_type_keyval_slot), save :: pgif_type_slots(VAPAA_PGIF_KEYVAL_SLOTS)
    type(pgif_win_keyval_slot), save :: pgif_win_slots(VAPAA_PGIF_KEYVAL_SLOTS)
    type(pgif_keyval_slot), save :: pgif_keyval_slots(VAPAA_PGIF_KEYVAL_SLOTS)
#endif

    interface
        subroutine VAPAA_MPI_Comm_create_errhandler(fn, errhandler, ierror) bind(C,name="VAPAA_MPI_Comm_create_errhandler")
            use iso_c_binding, only: c_funptr, c_int
            implicit none
            type(c_funptr), value :: fn
            integer(c_int), intent(out) :: errhandler, ierror
        end subroutine
        subroutine VAPAA_MPI_File_create_errhandler(fn, errhandler, ierror) bind(C,name="VAPAA_MPI_File_create_errhandler")
            use iso_c_binding, only: c_funptr, c_int
            implicit none
            type(c_funptr), value :: fn
            integer(c_int), intent(out) :: errhandler, ierror
        end subroutine
        subroutine VAPAA_MPI_Win_create_errhandler(fn, errhandler, ierror) bind(C,name="VAPAA_MPI_Win_create_errhandler")
            use iso_c_binding, only: c_funptr, c_int
            implicit none
            type(c_funptr), value :: fn
            integer(c_int), intent(out) :: errhandler, ierror
        end subroutine
        subroutine VAPAA_MPI_Session_create_errhandler(fn, errhandler, ierror) &
                   bind(C,name="VAPAA_MPI_Session_create_errhandler")
            use iso_c_binding, only: c_funptr, c_int
            implicit none
            type(c_funptr), value :: fn
            integer(c_int), intent(out) :: errhandler, ierror
        end subroutine

        subroutine VAPAA_MPI_Comm_create_keyval(copy_fn, delete_fn, keyval, extra_state, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_create_keyval")
            use iso_c_binding, only: c_funptr, c_int, c_intptr_t
            implicit none
            type(c_funptr), value :: copy_fn, delete_fn
            integer(c_int), intent(out) :: keyval, ierror
            integer(c_intptr_t), intent(in) :: extra_state
        end subroutine
        subroutine VAPAA_MPI_Type_create_keyval(copy_fn, delete_fn, keyval, extra_state, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_keyval")
            use iso_c_binding, only: c_funptr, c_int, c_intptr_t
            implicit none
            type(c_funptr), value :: copy_fn, delete_fn
            integer(c_int), intent(out) :: keyval, ierror
            integer(c_intptr_t), intent(in) :: extra_state
        end subroutine
        subroutine VAPAA_MPI_Win_create_keyval(copy_fn, delete_fn, keyval, extra_state, ierror) &
                   bind(C,name="VAPAA_MPI_Win_create_keyval")
            use iso_c_binding, only: c_funptr, c_int, c_intptr_t
            implicit none
            type(c_funptr), value :: copy_fn, delete_fn
            integer(c_int), intent(out) :: keyval, ierror
            integer(c_intptr_t), intent(in) :: extra_state
        end subroutine
        subroutine VAPAA_MPI_Keyval_create(copy_fn, delete_fn, keyval, extra_state, ierror) &
                   bind(C,name="VAPAA_MPI_Keyval_create")
            use iso_c_binding, only: c_funptr, c_int
            implicit none
            type(c_funptr), value :: copy_fn, delete_fn
            integer(c_int), intent(out) :: keyval, ierror
            integer(c_int), intent(in) :: extra_state
        end subroutine

        subroutine VAPAA_MPI_Grequest_start(query_fn, free_fn, cancel_fn, extra_state, request, ierror) &
                   bind(C,name="VAPAA_MPI_Grequest_start")
            use iso_c_binding, only: c_funptr, c_int, c_intptr_t
            implicit none
            type(c_funptr), value :: query_fn, free_fn, cancel_fn
            integer(c_intptr_t), intent(in) :: extra_state
            integer(c_int), intent(out) :: request, ierror
        end subroutine
        subroutine VAPAA_MPI_Grequest_complete(request, ierror) bind(C,name="VAPAA_MPI_Grequest_complete")
            use iso_c_binding, only: c_int
            implicit none
            integer(c_int), intent(in) :: request
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_Op_create_c(fn, commute, op, ierror) bind(C,name="VAPAA_MPI_Op_create_c")
            use iso_c_binding, only: c_funptr, c_int
            implicit none
            type(c_funptr), value :: fn
            integer(c_int), intent(in) :: commute
            integer(c_int), intent(out) :: op, ierror
        end subroutine
        subroutine VAPAA_MPI_Register_datarep(datarep, read_fn, write_fn, extent_fn, extra_state, ierror) &
                   bind(C,name="VAPAA_MPI_Register_datarep")
            use iso_c_binding, only: c_char, c_funptr, c_int, c_intptr_t
            implicit none
            character(kind=c_char), intent(in) :: datarep(*)
            type(c_funptr), value :: read_fn, write_fn, extent_fn
            integer(c_intptr_t), intent(in) :: extra_state
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_Register_datarep_c(datarep, read_fn, write_fn, extent_fn, extra_state, ierror) &
                   bind(C,name="VAPAA_MPI_Register_datarep_c")
            use iso_c_binding, only: c_char, c_funptr, c_int, c_intptr_t
            implicit none
            character(kind=c_char), intent(in) :: datarep(*)
            type(c_funptr), value :: read_fn, write_fn, extent_fn
            integer(c_intptr_t), intent(in) :: extra_state
            integer(c_int), intent(out) :: ierror
        end subroutine
        subroutine VAPAA_MPI_Comm_spawn(command, maxprocs, info, root, comm, intercomm, errcodes, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_spawn")
            use iso_c_binding, only: c_char, c_int
            implicit none
            character(kind=c_char), intent(in) :: command(*)
            integer(c_int), intent(in) :: maxprocs, info, root, comm
            integer(c_int), intent(out) :: intercomm, ierror
            integer(c_int) :: errcodes(*)
        end subroutine
        subroutine VAPAA_MPI_Comm_spawn_multiple(count, commands, command_len, maxprocs, infos, root, comm, &
                                                 intercomm, errcodes, ierror) &
                   bind(C,name="VAPAA_MPI_Comm_spawn_multiple")
            use iso_c_binding, only: c_char, c_int
            implicit none
            integer(c_int), intent(in) :: count, command_len, root, comm
            character(kind=c_char), intent(in) :: commands(*)
            integer(c_int), intent(in) :: maxprocs(*), infos(*)
            integer(c_int), intent(out) :: intercomm, ierror
            integer(c_int) :: errcodes(*)
        end subroutine
    end interface

    contains

#ifdef HAVE_PGIF
        integer function pgif_comm_slot_alloc(copy_fn, delete_fn, extra_state) result(slot)
            procedure(MPI_Comm_copy_attr_function) :: copy_fn
            procedure(MPI_Comm_delete_attr_function) :: delete_fn
            integer(c_intptr_t), intent(in) :: extra_state
            integer :: i
            slot = 0
            do i = 1, VAPAA_PGIF_KEYVAL_SLOTS
                if (.not. pgif_comm_slots(i) % in_use) then
                    pgif_comm_slots(i) % in_use = .true.
                    pgif_comm_slots(i) % keyval = 0_c_int
                    pgif_comm_slots(i) % extra_state = extra_state
                    pgif_comm_slots(i) % copy_fn => copy_fn
                    pgif_comm_slots(i) % delete_fn => delete_fn
                    slot = i
                    exit
                end if
            end do
        end function pgif_comm_slot_alloc

        integer function pgif_type_slot_alloc(copy_fn, delete_fn, extra_state) result(slot)
            procedure(MPI_Type_copy_attr_function) :: copy_fn
            procedure(MPI_Type_delete_attr_function) :: delete_fn
            integer(c_intptr_t), intent(in) :: extra_state
            integer :: i
            slot = 0
            do i = 1, VAPAA_PGIF_KEYVAL_SLOTS
                if (.not. pgif_type_slots(i) % in_use) then
                    pgif_type_slots(i) % in_use = .true.
                    pgif_type_slots(i) % keyval = 0_c_int
                    pgif_type_slots(i) % extra_state = extra_state
                    pgif_type_slots(i) % copy_fn => copy_fn
                    pgif_type_slots(i) % delete_fn => delete_fn
                    slot = i
                    exit
                end if
            end do
        end function pgif_type_slot_alloc

        integer function pgif_win_slot_alloc(copy_fn, delete_fn, extra_state) result(slot)
            procedure(MPI_Win_copy_attr_function) :: copy_fn
            procedure(MPI_Win_delete_attr_function) :: delete_fn
            integer(c_intptr_t), intent(in) :: extra_state
            integer :: i
            slot = 0
            do i = 1, VAPAA_PGIF_KEYVAL_SLOTS
                if (.not. pgif_win_slots(i) % in_use) then
                    pgif_win_slots(i) % in_use = .true.
                    pgif_win_slots(i) % keyval = 0_c_int
                    pgif_win_slots(i) % extra_state = extra_state
                    pgif_win_slots(i) % copy_fn => copy_fn
                    pgif_win_slots(i) % delete_fn => delete_fn
                    slot = i
                    exit
                end if
            end do
        end function pgif_win_slot_alloc

        integer function pgif_keyval_slot_alloc(copy_fn, delete_fn, extra_state) result(slot)
            procedure() :: copy_fn
            procedure() :: delete_fn
            integer(c_int), intent(in) :: extra_state
            integer :: i
            slot = 0
            do i = 1, VAPAA_PGIF_KEYVAL_SLOTS
                if (.not. pgif_keyval_slots(i) % in_use) then
                    pgif_keyval_slots(i) % in_use = .true.
                    pgif_keyval_slots(i) % keyval = 0_c_int
                    pgif_keyval_slots(i) % extra_state = extra_state
                    pgif_keyval_slots(i) % copy_fn => copy_fn
                    pgif_keyval_slots(i) % delete_fn => delete_fn
                    slot = i
                    exit
                end if
            end do
        end function pgif_keyval_slot_alloc

        subroutine pgif_comm_slot_release(slot)
            integer, intent(in) :: slot
            if (slot < 1 .or. slot > VAPAA_PGIF_KEYVAL_SLOTS) return
            pgif_comm_slots(slot) % in_use = .false.
            pgif_comm_slots(slot) % keyval = 0_c_int
            pgif_comm_slots(slot) % extra_state = 0_c_intptr_t
            nullify(pgif_comm_slots(slot) % copy_fn)
            nullify(pgif_comm_slots(slot) % delete_fn)
        end subroutine pgif_comm_slot_release

        subroutine pgif_type_slot_release(slot)
            integer, intent(in) :: slot
            if (slot < 1 .or. slot > VAPAA_PGIF_KEYVAL_SLOTS) return
            pgif_type_slots(slot) % in_use = .false.
            pgif_type_slots(slot) % keyval = 0_c_int
            pgif_type_slots(slot) % extra_state = 0_c_intptr_t
            nullify(pgif_type_slots(slot) % copy_fn)
            nullify(pgif_type_slots(slot) % delete_fn)
        end subroutine pgif_type_slot_release

        subroutine pgif_win_slot_release(slot)
            integer, intent(in) :: slot
            if (slot < 1 .or. slot > VAPAA_PGIF_KEYVAL_SLOTS) return
            pgif_win_slots(slot) % in_use = .false.
            pgif_win_slots(slot) % keyval = 0_c_int
            pgif_win_slots(slot) % extra_state = 0_c_intptr_t
            nullify(pgif_win_slots(slot) % copy_fn)
            nullify(pgif_win_slots(slot) % delete_fn)
        end subroutine pgif_win_slot_release

        subroutine pgif_keyval_slot_release(slot)
            integer, intent(in) :: slot
            if (slot < 1 .or. slot > VAPAA_PGIF_KEYVAL_SLOTS) return
            pgif_keyval_slots(slot) % in_use = .false.
            pgif_keyval_slots(slot) % keyval = 0_c_int
            pgif_keyval_slots(slot) % extra_state = 0_c_int
            nullify(pgif_keyval_slots(slot) % copy_fn)
            nullify(pgif_keyval_slots(slot) % delete_fn)
        end subroutine pgif_keyval_slot_release

        subroutine VAPAA_PGIF_Comm_keyval_release(keyval)
            integer, intent(in) :: keyval
            integer :: i
            do i = 1, VAPAA_PGIF_KEYVAL_SLOTS
                if (pgif_comm_slots(i) % in_use) then
                    if (pgif_comm_slots(i) % keyval == int(keyval, c_int)) then
                        call pgif_comm_slot_release(i)
                        exit
                    end if
                end if
            end do
        end subroutine VAPAA_PGIF_Comm_keyval_release

        subroutine VAPAA_PGIF_Type_keyval_release(keyval)
            integer, intent(in) :: keyval
            integer :: i
            do i = 1, VAPAA_PGIF_KEYVAL_SLOTS
                if (pgif_type_slots(i) % in_use) then
                    if (pgif_type_slots(i) % keyval == int(keyval, c_int)) then
                        call pgif_type_slot_release(i)
                        exit
                    end if
                end if
            end do
        end subroutine VAPAA_PGIF_Type_keyval_release

        subroutine VAPAA_PGIF_Win_keyval_release(keyval)
            integer, intent(in) :: keyval
            integer :: i
            do i = 1, VAPAA_PGIF_KEYVAL_SLOTS
                if (pgif_win_slots(i) % in_use) then
                    if (pgif_win_slots(i) % keyval == int(keyval, c_int)) then
                        call pgif_win_slot_release(i)
                        exit
                    end if
                end if
            end do
        end subroutine VAPAA_PGIF_Win_keyval_release

        subroutine VAPAA_PGIF_Keyval_release(keyval)
            integer, intent(in) :: keyval
            integer :: i
            do i = 1, VAPAA_PGIF_KEYVAL_SLOTS
                if (pgif_keyval_slots(i) % in_use) then
                    if (pgif_keyval_slots(i) % keyval == int(keyval, c_int)) then
                        call pgif_keyval_slot_release(i)
                        exit
                    end if
                end if
            end do
        end subroutine VAPAA_PGIF_Keyval_release

        logical function pgif_valid_comm_slot(slot) result(valid)
            integer, intent(in) :: slot
            valid = slot >= 1 .and. slot <= VAPAA_PGIF_KEYVAL_SLOTS
            if (valid) valid = pgif_comm_slots(slot) % in_use
            if (valid) valid = associated(pgif_comm_slots(slot) % copy_fn)
        end function pgif_valid_comm_slot

        logical function pgif_valid_type_slot(slot) result(valid)
            integer, intent(in) :: slot
            valid = slot >= 1 .and. slot <= VAPAA_PGIF_KEYVAL_SLOTS
            if (valid) valid = pgif_type_slots(slot) % in_use
            if (valid) valid = associated(pgif_type_slots(slot) % copy_fn)
        end function pgif_valid_type_slot

        logical function pgif_valid_win_slot(slot) result(valid)
            integer, intent(in) :: slot
            valid = slot >= 1 .and. slot <= VAPAA_PGIF_KEYVAL_SLOTS
            if (valid) valid = pgif_win_slots(slot) % in_use
            if (valid) valid = associated(pgif_win_slots(slot) % copy_fn)
        end function pgif_valid_win_slot

        logical function pgif_valid_keyval_slot(slot) result(valid)
            integer, intent(in) :: slot
            valid = slot >= 1 .and. slot <= VAPAA_PGIF_KEYVAL_SLOTS
            if (valid) valid = pgif_keyval_slots(slot) % in_use
            if (valid) valid = associated(pgif_keyval_slots(slot) % copy_fn)
        end function pgif_valid_keyval_slot

        subroutine VAPAA_PGIF_Keyval_copy_trampoline(oldcomm_c, keyval_c, slot_c, &
                                                     attr_in_c, attr_out_c, &
                                                     flag_c, ierror_c) bind(C)
            use mpi_error_f, only: MPI_ERR_OTHER, MPI_SUCCESS
            use mpi_handle_types, only: MPI_Comm
            integer(c_int), intent(in) :: oldcomm_c, keyval_c, slot_c, attr_in_c
            integer(c_int), intent(out) :: attr_out_c, flag_c, ierror_c
            type(MPI_Comm) :: oldcomm
            integer :: slot, keyval, extra_state, attr_in, attr_out, ierror_f
            logical :: flag
            slot = int(slot_c)
            if (.not. pgif_valid_keyval_slot(slot)) then
                attr_out_c = 0_c_int
                flag_c = 0_c_int
                ierror_c = int(MPI_ERR_OTHER, c_int)
                return
            end if
            oldcomm % MPI_VAL = oldcomm_c
            keyval = int(keyval_c)
            extra_state = int(pgif_keyval_slots(slot) % extra_state)
            attr_in = int(attr_in_c)
            attr_out = 0
            flag = .false.
            ierror_f = MPI_SUCCESS
            call pgif_keyval_slots(slot) % copy_fn(oldcomm, keyval, extra_state, &
                                                   attr_in, attr_out, flag, ierror_f)
            attr_out_c = int(attr_out, c_int)
            flag_c = merge(1_c_int, 0_c_int, flag)
            ierror_c = int(ierror_f, c_int)
        end subroutine VAPAA_PGIF_Keyval_copy_trampoline

        subroutine VAPAA_PGIF_Keyval_delete_trampoline(comm_c, keyval_c, attr_c, &
                                                       slot_c, ierror_c) bind(C)
            use mpi_error_f, only: MPI_ERR_OTHER, MPI_SUCCESS
            use mpi_handle_types, only: MPI_Comm
            integer(c_int), intent(in) :: comm_c, keyval_c, attr_c, slot_c
            integer(c_int), intent(out) :: ierror_c
            type(MPI_Comm) :: comm
            integer :: slot, keyval, attr, extra_state, ierror_f
            slot = int(slot_c)
            if (.not. pgif_valid_keyval_slot(slot)) then
                ierror_c = int(MPI_ERR_OTHER, c_int)
                return
            end if
            comm % MPI_VAL = comm_c
            keyval = int(keyval_c)
            attr = int(attr_c)
            extra_state = int(pgif_keyval_slots(slot) % extra_state)
            ierror_f = MPI_SUCCESS
            call pgif_keyval_slots(slot) % delete_fn(comm, keyval, attr, extra_state, ierror_f)
            ierror_c = int(ierror_f, c_int)
        end subroutine VAPAA_PGIF_Keyval_delete_trampoline

        subroutine VAPAA_PGIF_Comm_copy_trampoline(oldcomm_c, keyval_c, slot_c, attr_in_c, &
                                                   attr_out_c, flag_c, ierror_c) bind(C)
            use mpi_error_f, only: MPI_ERR_OTHER, MPI_SUCCESS
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Comm
            integer(c_int), intent(in) :: oldcomm_c, keyval_c
            integer(c_intptr_t), intent(in) :: slot_c, attr_in_c
            integer(c_intptr_t), intent(out) :: attr_out_c
            integer(c_int), intent(out) :: flag_c, ierror_c
            type(MPI_Comm) :: oldcomm
            integer :: slot, keyval, ierror_f
            integer(kind=MPI_ADDRESS_KIND) :: attr_in, attr_out, extra_state
            logical :: flag
            slot = int(slot_c)
            if (.not. pgif_valid_comm_slot(slot)) then
                attr_out_c = 0_c_intptr_t
                flag_c = 0_c_int
                ierror_c = int(MPI_ERR_OTHER, c_int)
                return
            end if
            oldcomm % MPI_VAL = oldcomm_c
            keyval = int(keyval_c)
            extra_state = pgif_comm_slots(slot) % extra_state
            attr_in = attr_in_c
            attr_out = 0
            flag = .false.
            ierror_f = MPI_SUCCESS
            call pgif_comm_slots(slot) % copy_fn(oldcomm, keyval, extra_state, attr_in, &
                                                 attr_out, flag, ierror_f)
            attr_out_c = int(attr_out, c_intptr_t)
            flag_c = merge(1_c_int, 0_c_int, flag)
            ierror_c = int(ierror_f, c_int)
        end subroutine VAPAA_PGIF_Comm_copy_trampoline

        subroutine VAPAA_PGIF_Comm_delete_trampoline(comm_c, keyval_c, attr_c, slot_c, &
                                                     ierror_c) bind(C)
            use mpi_error_f, only: MPI_ERR_OTHER, MPI_SUCCESS
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Comm
            integer(c_int), intent(in) :: comm_c, keyval_c
            integer(c_intptr_t), intent(in) :: attr_c, slot_c
            integer(c_int), intent(out) :: ierror_c
            type(MPI_Comm) :: comm
            integer :: slot, keyval, ierror_f
            integer(kind=MPI_ADDRESS_KIND) :: attr, extra_state
            slot = int(slot_c)
            if (.not. pgif_valid_comm_slot(slot)) then
                ierror_c = int(MPI_ERR_OTHER, c_int)
                return
            end if
            comm % MPI_VAL = comm_c
            keyval = int(keyval_c)
            extra_state = pgif_comm_slots(slot) % extra_state
            attr = attr_c
            ierror_f = MPI_SUCCESS
            call pgif_comm_slots(slot) % delete_fn(comm, keyval, attr, extra_state, ierror_f)
            ierror_c = int(ierror_f, c_int)
        end subroutine VAPAA_PGIF_Comm_delete_trampoline

        subroutine VAPAA_PGIF_Type_copy_trampoline(oldtype_c, keyval_c, slot_c, attr_in_c, &
                                                   attr_out_c, flag_c, ierror_c) bind(C)
            use mpi_error_f, only: MPI_ERR_OTHER, MPI_SUCCESS
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            integer(c_int), intent(in) :: oldtype_c, keyval_c
            integer(c_intptr_t), intent(in) :: slot_c, attr_in_c
            integer(c_intptr_t), intent(out) :: attr_out_c
            integer(c_int), intent(out) :: flag_c, ierror_c
            type(MPI_Datatype) :: oldtype
            integer :: slot, keyval, ierror_f
            integer(kind=MPI_ADDRESS_KIND) :: attr_in, attr_out, extra_state
            logical :: flag
            slot = int(slot_c)
            if (.not. pgif_valid_type_slot(slot)) then
                attr_out_c = 0_c_intptr_t
                flag_c = 0_c_int
                ierror_c = int(MPI_ERR_OTHER, c_int)
                return
            end if
            oldtype % MPI_VAL = oldtype_c
            keyval = int(keyval_c)
            extra_state = pgif_type_slots(slot) % extra_state
            attr_in = attr_in_c
            attr_out = 0
            flag = .false.
            ierror_f = MPI_SUCCESS
            call pgif_type_slots(slot) % copy_fn(oldtype, keyval, extra_state, attr_in, &
                                                 attr_out, flag, ierror_f)
            attr_out_c = int(attr_out, c_intptr_t)
            flag_c = merge(1_c_int, 0_c_int, flag)
            ierror_c = int(ierror_f, c_int)
        end subroutine VAPAA_PGIF_Type_copy_trampoline

        subroutine VAPAA_PGIF_Type_delete_trampoline(datatype_c, keyval_c, attr_c, slot_c, &
                                                     ierror_c) bind(C)
            use mpi_error_f, only: MPI_ERR_OTHER, MPI_SUCCESS
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            integer(c_int), intent(in) :: datatype_c, keyval_c
            integer(c_intptr_t), intent(in) :: attr_c, slot_c
            integer(c_int), intent(out) :: ierror_c
            type(MPI_Datatype) :: datatype
            integer :: slot, keyval, ierror_f
            integer(kind=MPI_ADDRESS_KIND) :: attr, extra_state
            slot = int(slot_c)
            if (.not. pgif_valid_type_slot(slot)) then
                ierror_c = int(MPI_ERR_OTHER, c_int)
                return
            end if
            datatype % MPI_VAL = datatype_c
            keyval = int(keyval_c)
            extra_state = pgif_type_slots(slot) % extra_state
            attr = attr_c
            ierror_f = MPI_SUCCESS
            call pgif_type_slots(slot) % delete_fn(datatype, keyval, attr, extra_state, ierror_f)
            ierror_c = int(ierror_f, c_int)
        end subroutine VAPAA_PGIF_Type_delete_trampoline

        subroutine VAPAA_PGIF_Win_copy_trampoline(oldwin_c, keyval_c, slot_c, attr_in_c, &
                                                  attr_out_c, flag_c, ierror_c) bind(C)
            use mpi_error_f, only: MPI_ERR_OTHER, MPI_SUCCESS
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Win
            integer(c_int), intent(in) :: oldwin_c, keyval_c
            integer(c_intptr_t), intent(in) :: slot_c, attr_in_c
            integer(c_intptr_t), intent(out) :: attr_out_c
            integer(c_int), intent(out) :: flag_c, ierror_c
            type(MPI_Win) :: oldwin
            integer :: slot, keyval, ierror_f
            integer(kind=MPI_ADDRESS_KIND) :: attr_in, attr_out, extra_state
            logical :: flag
            slot = int(slot_c)
            if (.not. pgif_valid_win_slot(slot)) then
                attr_out_c = 0_c_intptr_t
                flag_c = 0_c_int
                ierror_c = int(MPI_ERR_OTHER, c_int)
                return
            end if
            oldwin % MPI_VAL = oldwin_c
            keyval = int(keyval_c)
            extra_state = pgif_win_slots(slot) % extra_state
            attr_in = attr_in_c
            attr_out = 0
            flag = .false.
            ierror_f = MPI_SUCCESS
            call pgif_win_slots(slot) % copy_fn(oldwin, keyval, extra_state, attr_in, &
                                                attr_out, flag, ierror_f)
            attr_out_c = int(attr_out, c_intptr_t)
            flag_c = merge(1_c_int, 0_c_int, flag)
            ierror_c = int(ierror_f, c_int)
        end subroutine VAPAA_PGIF_Win_copy_trampoline

        subroutine VAPAA_PGIF_Win_delete_trampoline(win_c, keyval_c, attr_c, slot_c, &
                                                    ierror_c) bind(C)
            use mpi_error_f, only: MPI_ERR_OTHER, MPI_SUCCESS
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Win
            integer(c_int), intent(in) :: win_c, keyval_c
            integer(c_intptr_t), intent(in) :: attr_c, slot_c
            integer(c_int), intent(out) :: ierror_c
            type(MPI_Win) :: win
            integer :: slot, keyval, ierror_f
            integer(kind=MPI_ADDRESS_KIND) :: attr, extra_state
            slot = int(slot_c)
            if (.not. pgif_valid_win_slot(slot)) then
                ierror_c = int(MPI_ERR_OTHER, c_int)
                return
            end if
            win % MPI_VAL = win_c
            keyval = int(keyval_c)
            extra_state = pgif_win_slots(slot) % extra_state
            attr = attr_c
            ierror_f = MPI_SUCCESS
            call pgif_win_slots(slot) % delete_fn(win, keyval, attr, extra_state, ierror_f)
            ierror_c = int(ierror_f, c_int)
        end subroutine VAPAA_PGIF_Win_delete_trampoline
#endif

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

        subroutine finish_ierror(ierror, ierror_c)
            integer, optional, intent(out) :: ierror
            integer(c_int), intent(in) :: ierror_c
            if (present(ierror)) ierror = ierror_c
        end subroutine finish_ierror

        subroutine MPI_Comm_create_errhandler_f08(fn, errhandler, ierror)
            use mpi_handle_types, only: MPI_Errhandler
            procedure(MPI_Comm_errhandler_function) :: fn
            type(MPI_Errhandler), intent(out) :: errhandler
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Comm_create_errhandler(c_funloc(fn), errhandler % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine MPI_Comm_create_errhandler_f08

        subroutine MPI_File_create_errhandler_f08(fn, errhandler, ierror)
            use mpi_handle_types, only: MPI_Errhandler
            procedure(MPI_File_errhandler_function) :: fn
            type(MPI_Errhandler), intent(out) :: errhandler
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_File_create_errhandler(c_funloc(fn), errhandler % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine MPI_File_create_errhandler_f08

        subroutine MPI_Win_create_errhandler_f08(fn, errhandler, ierror)
            use mpi_handle_types, only: MPI_Errhandler
            procedure(MPI_Win_errhandler_function) :: fn
            type(MPI_Errhandler), intent(out) :: errhandler
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_create_errhandler(c_funloc(fn), errhandler % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine MPI_Win_create_errhandler_f08

        subroutine MPI_Session_create_errhandler_f08(fn, errhandler, ierror)
            use mpi_handle_types, only: MPI_Errhandler
            procedure(MPI_Session_errhandler_function) :: fn
            type(MPI_Errhandler), intent(out) :: errhandler
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Session_create_errhandler(c_funloc(fn), errhandler % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine MPI_Session_create_errhandler_f08

        subroutine MPI_Comm_create_keyval_f08(copy_fn, delete_fn, keyval, extra_state, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
#ifdef HAVE_PGIF
            use mpi_error_f, only: MPI_ERR_NO_MEM
#endif
            procedure(MPI_Comm_copy_attr_function) :: copy_fn
            procedure(MPI_Comm_delete_attr_function) :: delete_fn
            integer, intent(out) :: keyval
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: extra_state
            integer, optional, intent(out) :: ierror
            integer(c_int) :: keyval_c, ierror_c
#ifdef HAVE_PGIF
            integer :: slot
            integer(c_intptr_t) :: slot_c
            slot = pgif_comm_slot_alloc(copy_fn, delete_fn, int(extra_state,c_intptr_t))
            if (slot == 0) then
                keyval = 0
                call finish_ierror(ierror, int(MPI_ERR_NO_MEM, c_int))
                return
            end if
            slot_c = int(slot, c_intptr_t)
            call VAPAA_MPI_Comm_create_keyval(c_funloc(VAPAA_PGIF_Comm_copy_trampoline), &
                                              c_funloc(VAPAA_PGIF_Comm_delete_trampoline), &
                                              keyval_c, slot_c, ierror_c)
            if (ierror_c == 0_c_int) then
                pgif_comm_slots(slot) % keyval = keyval_c
            else
                call pgif_comm_slot_release(slot)
            end if
#else
            call VAPAA_MPI_Comm_create_keyval(c_funloc(copy_fn), c_funloc(delete_fn), keyval_c, &
                                              int(extra_state,c_intptr_t), ierror_c)
#endif
            keyval = keyval_c
            call finish_ierror(ierror, ierror_c)
        end subroutine MPI_Comm_create_keyval_f08

        subroutine MPI_Type_create_keyval_f08(copy_fn, delete_fn, keyval, extra_state, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
#ifdef HAVE_PGIF
            use mpi_error_f, only: MPI_ERR_NO_MEM
#endif
            procedure(MPI_Type_copy_attr_function) :: copy_fn
            procedure(MPI_Type_delete_attr_function) :: delete_fn
            integer, intent(out) :: keyval
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: extra_state
            integer, optional, intent(out) :: ierror
            integer(c_int) :: keyval_c, ierror_c
#ifdef HAVE_PGIF
            integer :: slot
            integer(c_intptr_t) :: slot_c
            slot = pgif_type_slot_alloc(copy_fn, delete_fn, int(extra_state,c_intptr_t))
            if (slot == 0) then
                keyval = 0
                call finish_ierror(ierror, int(MPI_ERR_NO_MEM, c_int))
                return
            end if
            slot_c = int(slot, c_intptr_t)
            call VAPAA_MPI_Type_create_keyval(c_funloc(VAPAA_PGIF_Type_copy_trampoline), &
                                              c_funloc(VAPAA_PGIF_Type_delete_trampoline), &
                                              keyval_c, slot_c, ierror_c)
            if (ierror_c == 0_c_int) then
                pgif_type_slots(slot) % keyval = keyval_c
            else
                call pgif_type_slot_release(slot)
            end if
#else
            call VAPAA_MPI_Type_create_keyval(c_funloc(copy_fn), c_funloc(delete_fn), keyval_c, &
                                              int(extra_state,c_intptr_t), ierror_c)
#endif
            keyval = keyval_c
            call finish_ierror(ierror, ierror_c)
        end subroutine MPI_Type_create_keyval_f08

        subroutine MPI_Win_create_keyval_f08(copy_fn, delete_fn, keyval, extra_state, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
#ifdef HAVE_PGIF
            use mpi_error_f, only: MPI_ERR_NO_MEM
#endif
            procedure(MPI_Win_copy_attr_function) :: copy_fn
            procedure(MPI_Win_delete_attr_function) :: delete_fn
            integer, intent(out) :: keyval
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: extra_state
            integer, optional, intent(out) :: ierror
            integer(c_int) :: keyval_c, ierror_c
#ifdef HAVE_PGIF
            integer :: slot
            integer(c_intptr_t) :: slot_c
            slot = pgif_win_slot_alloc(copy_fn, delete_fn, int(extra_state,c_intptr_t))
            if (slot == 0) then
                keyval = 0
                call finish_ierror(ierror, int(MPI_ERR_NO_MEM, c_int))
                return
            end if
            slot_c = int(slot, c_intptr_t)
            call VAPAA_MPI_Win_create_keyval(c_funloc(VAPAA_PGIF_Win_copy_trampoline), &
                                             c_funloc(VAPAA_PGIF_Win_delete_trampoline), &
                                             keyval_c, slot_c, ierror_c)
            if (ierror_c == 0_c_int) then
                pgif_win_slots(slot) % keyval = keyval_c
            else
                call pgif_win_slot_release(slot)
            end if
#else
            call VAPAA_MPI_Win_create_keyval(c_funloc(copy_fn), c_funloc(delete_fn), keyval_c, &
                                             int(extra_state,c_intptr_t), ierror_c)
#endif
            keyval = keyval_c
            call finish_ierror(ierror, ierror_c)
        end subroutine MPI_Win_create_keyval_f08

        subroutine MPI_Keyval_create_f08(copy_fn, delete_fn, keyval, extra_state, ierror)
#ifdef HAVE_PGIF
            use mpi_error_f, only: MPI_ERR_NO_MEM
#endif
            procedure() :: copy_fn
            procedure() :: delete_fn
            integer, intent(out) :: keyval
            integer, intent(in) :: extra_state
            integer, optional, intent(out) :: ierror
            integer(c_int) :: keyval_c, ierror_c
#ifdef HAVE_PGIF
            integer :: slot
            integer(c_int) :: slot_c
            slot = pgif_keyval_slot_alloc(copy_fn, delete_fn, int(extra_state,c_int))
            if (slot == 0) then
                keyval = 0
                call finish_ierror(ierror, int(MPI_ERR_NO_MEM, c_int))
                return
            end if
            slot_c = int(slot, c_int)
            call VAPAA_MPI_Keyval_create(c_funloc(VAPAA_PGIF_Keyval_copy_trampoline), &
                                         c_funloc(VAPAA_PGIF_Keyval_delete_trampoline), &
                                         keyval_c, slot_c, ierror_c)
            if (ierror_c == 0_c_int) then
                pgif_keyval_slots(slot) % keyval = keyval_c
            else
                call pgif_keyval_slot_release(slot)
            end if
#else
            call VAPAA_MPI_Keyval_create(c_funloc(copy_fn), c_funloc(delete_fn), keyval_c, &
                                         int(extra_state,c_int), ierror_c)
#endif
            keyval = keyval_c
            call finish_ierror(ierror, ierror_c)
        end subroutine MPI_Keyval_create_f08

        subroutine MPI_Grequest_start_f08(query_fn, free_fn, cancel_fn, extra_state, request, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Request
            procedure(MPI_Grequest_query_function) :: query_fn
            procedure(MPI_Grequest_free_function) :: free_fn
            procedure(MPI_Grequest_cancel_function) :: cancel_fn
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: extra_state
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Grequest_start(c_funloc(query_fn), c_funloc(free_fn), c_funloc(cancel_fn), &
                                          extra_state, request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Grequest_complete_f08(request, ierror)
            use mpi_handle_types, only: MPI_Request
            type(MPI_Request), intent(in) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Grequest_complete(request % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Op_create_c_f08(user_fn, commute, op, ierror)
            use mpi_handle_types, only: MPI_Op
            procedure(MPI_User_function_c) :: user_fn
            logical, intent(in) :: commute
            type(MPI_Op), intent(out) :: op
            integer, optional, intent(out) :: ierror
            integer(c_int) :: commute_c, ierror_c
            commute_c = merge(1_c_int, 0_c_int, commute)
            call VAPAA_MPI_Op_create_c(c_funloc(user_fn), commute_c, op % MPI_VAL, ierror_c)
            call finish_ierror(ierror, ierror_c)
        end subroutine

        subroutine MPI_Register_datarep_f08(datarep, read_conversion_fn, write_conversion_fn, dtype_file_extent_fn, &
                                            extra_state, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            character(len=*), intent(in) :: datarep
            procedure(MPI_Datarep_conversion_function) :: read_conversion_fn, write_conversion_fn
            procedure(MPI_Datarep_extent_function) :: dtype_file_extent_fn
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: extra_state
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: datarep_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(datarep, datarep_c)
            call VAPAA_MPI_Register_datarep(datarep_c, c_funloc(read_conversion_fn), c_funloc(write_conversion_fn), &
                                            c_funloc(dtype_file_extent_fn), int(extra_state,c_intptr_t), ierror_c)
            call finish_ierror(ierror, ierror_c)
            deallocate(datarep_c)
        end subroutine

        subroutine MPI_Register_datarep_c_f08(datarep, read_conversion_fn, write_conversion_fn, dtype_file_extent_fn, &
                                              extra_state, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            character(len=*), intent(in) :: datarep
            procedure(MPI_Datarep_conversion_function_c) :: read_conversion_fn, write_conversion_fn
            procedure(MPI_Datarep_extent_function) :: dtype_file_extent_fn
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: extra_state
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: datarep_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(datarep, datarep_c)
            call VAPAA_MPI_Register_datarep_c(datarep_c, c_funloc(read_conversion_fn), c_funloc(write_conversion_fn), &
                                              c_funloc(dtype_file_extent_fn), int(extra_state,c_intptr_t), ierror_c)
            call finish_ierror(ierror, ierror_c)
            deallocate(datarep_c)
        end subroutine

        subroutine MPI_Comm_spawn_f08(command, argv, maxprocs, info, root, comm, intercomm, array_of_errcodes, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info
            character(len=*), intent(in) :: command
            character(len=*), intent(in), target :: argv(*)
            integer, intent(in) :: maxprocs, root
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Comm), intent(out) :: intercomm
            integer, target :: array_of_errcodes(*)
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: command_c(:)
            integer(c_int) :: ierror_c
            if (.false.) print *, len(argv(1))
            call make_c_string(command, command_c)
            call VAPAA_MPI_Comm_spawn(command_c, int(maxprocs,c_int), info % MPI_VAL, int(root,c_int), &
                                      comm % MPI_VAL, intercomm % MPI_VAL, array_of_errcodes, ierror_c)
            call finish_ierror(ierror, ierror_c)
            deallocate(command_c)
        end subroutine

        subroutine MPI_Comm_spawn_multiple_f08(count, array_of_commands, array_of_argv, array_of_maxprocs, &
                                               array_of_info, root, comm, intercomm, array_of_errcodes, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info
            integer, intent(in) :: count
            character(len=*), intent(in), target :: array_of_commands(*)
            character(len=*), intent(in), target :: array_of_argv(count, *)
            integer, intent(in) :: array_of_maxprocs(count)
            type(MPI_Info), intent(in) :: array_of_info(count)
            integer, intent(in) :: root
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Comm), intent(out) :: intercomm
            integer, target :: array_of_errcodes(*)
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: commands_c(:)
            integer(c_int), allocatable :: infos_c(:)
            integer(c_int) :: ierror_c
            integer :: i, j, clen
            if (.false.) print *, len(array_of_argv(1,1))
            clen = len(array_of_commands(1)) + 1
            allocate(commands_c(clen * count), infos_c(count))
            commands_c = c_null_char
            do i = 1, count
                do j = 1, len_trim(array_of_commands(i))
                    commands_c((i - 1) * clen + j) = array_of_commands(i)(j:j)
                end do
                infos_c(i) = array_of_info(i) % MPI_VAL
            end do
            call VAPAA_MPI_Comm_spawn_multiple(int(count,c_int), commands_c, int(clen,c_int), array_of_maxprocs, &
                                               infos_c, int(root,c_int), comm % MPI_VAL, intercomm % MPI_VAL, &
                                               array_of_errcodes, ierror_c)
            call finish_ierror(ierror, ierror_c)
            deallocate(commands_c, infos_c)
        end subroutine

end module mpi_direct_callback_f
