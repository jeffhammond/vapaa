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

#define ERRHANDLER_WRAPPER(FNAME,CBTYPE,CNAME) \
        subroutine FNAME(fn, errhandler, ierror); \
            use mpi_handle_types, only: MPI_Errhandler; \
            procedure(CBTYPE) :: fn; \
            type(MPI_Errhandler), intent(out) :: errhandler; \
            integer, optional, intent(out) :: ierror; \
            integer(c_int) :: ierror_c; \
            call CNAME(c_funloc(fn), errhandler % MPI_VAL, ierror_c); \
            call finish_ierror(ierror, ierror_c); \
        end subroutine FNAME

        ERRHANDLER_WRAPPER(MPI_Comm_create_errhandler_f08,MPI_Comm_errhandler_function,VAPAA_MPI_Comm_create_errhandler)
        ERRHANDLER_WRAPPER(MPI_File_create_errhandler_f08,MPI_File_errhandler_function,VAPAA_MPI_File_create_errhandler)
        ERRHANDLER_WRAPPER(MPI_Win_create_errhandler_f08,MPI_Win_errhandler_function,VAPAA_MPI_Win_create_errhandler)
        ERRHANDLER_WRAPPER(MPI_Session_create_errhandler_f08,MPI_Session_errhandler_function,VAPAA_MPI_Session_create_errhandler)

#define KEYVAL_WRAPPER(FNAME,COPYTYPE,DELTYPE,CNAME) \
        subroutine FNAME(copy_fn, delete_fn, keyval, extra_state, ierror); \
            use mpi_global_constants, only: MPI_ADDRESS_KIND; \
            procedure(COPYTYPE) :: copy_fn; \
            procedure(DELTYPE) :: delete_fn; \
            integer, intent(out) :: keyval; \
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: extra_state; \
            integer, optional, intent(out) :: ierror; \
            integer(c_int) :: keyval_c, ierror_c; \
            call CNAME(c_funloc(copy_fn), c_funloc(delete_fn), keyval_c, int(extra_state,c_intptr_t), ierror_c); \
            keyval = keyval_c; \
            call finish_ierror(ierror, ierror_c); \
        end subroutine FNAME

        KEYVAL_WRAPPER(MPI_Comm_create_keyval_f08,MPI_Comm_copy_attr_function,MPI_Comm_delete_attr_function,VAPAA_MPI_Comm_create_keyval)
        KEYVAL_WRAPPER(MPI_Type_create_keyval_f08,MPI_Type_copy_attr_function,MPI_Type_delete_attr_function,VAPAA_MPI_Type_create_keyval)
        KEYVAL_WRAPPER(MPI_Win_create_keyval_f08,MPI_Win_copy_attr_function,MPI_Win_delete_attr_function,VAPAA_MPI_Win_create_keyval)

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
                                          int(extra_state,c_intptr_t), request % MPI_VAL, ierror_c)
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
