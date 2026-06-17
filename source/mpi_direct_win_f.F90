! SPDX-License-Identifier: MIT

module mpi_direct_win_f
    use iso_c_binding, only: c_char, c_int, c_intptr_t, c_null_char, c_ptr
    implicit none

    interface MPI_Win_allocate
        module procedure MPI_Win_allocate_f08
        module procedure MPI_Win_allocate_c_f08
    end interface
    interface MPI_Win_allocate_shared
        module procedure MPI_Win_allocate_shared_f08
        module procedure MPI_Win_allocate_shared_c_f08
    end interface
    interface MPI_Win_create_dynamic
        module procedure MPI_Win_create_dynamic_f08
    end interface
    interface MPI_Win_free
        module procedure MPI_Win_free_f08
    end interface
    interface MPI_Win_shared_query
        module procedure MPI_Win_shared_query_f08
        module procedure MPI_Win_shared_query_c_f08
    end interface
    interface MPI_Win_get_group
        module procedure MPI_Win_get_group_f08
    end interface
    interface MPI_Win_get_info
        module procedure MPI_Win_get_info_f08
    end interface
    interface MPI_Win_set_info
        module procedure MPI_Win_set_info_f08
    end interface
    interface MPI_Win_delete_attr
        module procedure MPI_Win_delete_attr_f08
    end interface
    interface MPI_Win_free_keyval
        module procedure MPI_Win_free_keyval_f08
    end interface
    interface MPI_Win_get_attr
        module procedure MPI_Win_get_attr_f08
    end interface
    interface MPI_Win_set_attr
        module procedure MPI_Win_set_attr_f08
    end interface
    interface MPI_Win_fence
        module procedure MPI_Win_fence_f08
    end interface
    interface MPI_Win_start
        module procedure MPI_Win_start_f08
    end interface
    interface MPI_Win_complete
        module procedure MPI_Win_complete_f08
    end interface
    interface MPI_Win_post
        module procedure MPI_Win_post_f08
    end interface
    interface MPI_Win_wait
        module procedure MPI_Win_wait_f08
    end interface
    interface MPI_Win_test
        module procedure MPI_Win_test_f08
    end interface
    interface MPI_Win_lock
        module procedure MPI_Win_lock_f08
    end interface
    interface MPI_Win_unlock
        module procedure MPI_Win_unlock_f08
    end interface
    interface MPI_Win_lock_all
        module procedure MPI_Win_lock_all_f08
    end interface
    interface MPI_Win_unlock_all
        module procedure MPI_Win_unlock_all_f08
    end interface
    interface MPI_Win_flush
        module procedure MPI_Win_flush_f08
    end interface
    interface MPI_Win_flush_all
        module procedure MPI_Win_flush_all_f08
    end interface
    interface MPI_Win_flush_local
        module procedure MPI_Win_flush_local_f08
    end interface
    interface MPI_Win_flush_local_all
        module procedure MPI_Win_flush_local_all_f08
    end interface
    interface MPI_Win_sync
        module procedure MPI_Win_sync_f08
    end interface

#ifdef HAVE_CFI
    interface MPI_Put
        module procedure MPI_Put_f08ts
    end interface
    interface MPI_Get
        module procedure MPI_Get_f08ts
    end interface
    interface MPI_Accumulate
        module procedure MPI_Accumulate_f08ts
    end interface
    interface MPI_Get_accumulate
        module procedure MPI_Get_accumulate_f08ts
    end interface
    interface MPI_Rput
        module procedure MPI_Rput_f08ts
    end interface
    interface MPI_Rget
        module procedure MPI_Rget_f08ts
    end interface
    interface MPI_Raccumulate
        module procedure MPI_Raccumulate_f08ts
    end interface
    interface MPI_Rget_accumulate
        module procedure MPI_Rget_accumulate_f08ts
    end interface
    interface MPI_Compare_and_swap
        module procedure MPI_Compare_and_swap_f08ts
    end interface
    interface MPI_Fetch_and_op
        module procedure MPI_Fetch_and_op_f08ts
    end interface

    interface MPI_Win_create
        module procedure MPI_Win_create_f08ts
    end interface
    interface MPI_Win_attach
        module procedure MPI_Win_attach_f08ts
    end interface
    interface MPI_Win_detach
        module procedure MPI_Win_detach_f08ts
    end interface
    interface MPI_Win_get_name
        module procedure MPI_Win_get_name_f08
    end interface
    interface MPI_Win_set_name
        module procedure MPI_Win_set_name_f08
    end interface
#endif

    contains

        subroutine make_c_string(f, c)
            character(len=*), intent(in) :: f
            character(kind=c_char), allocatable, intent(out) :: c(:)
            integer :: i, n
            n = len(f)
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
            f = c_null_char
            do i = 1, n
                f(i:i) = c(i)
            end do
        end subroutine copy_c_string

        subroutine MPI_Win_allocate_f08(size, disp_unit, info, comm, baseptr, win, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Info, MPI_Comm, MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_allocate
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
            integer, intent(in) :: disp_unit
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(c_ptr), intent(out) :: baseptr
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_allocate(size, int(disp_unit,c_int), info % MPI_VAL, comm % MPI_VAL, baseptr, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_allocate_c_f08(size, disp_unit, info, comm, baseptr, win, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Info, MPI_Comm, MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_allocate_c
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size, disp_unit
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(c_ptr), intent(out) :: baseptr
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_allocate_c(size, disp_unit, info % MPI_VAL, comm % MPI_VAL, baseptr, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_allocate_shared_f08(size, disp_unit, info, comm, baseptr, win, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Info, MPI_Comm, MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_allocate_shared
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
            integer, intent(in) :: disp_unit
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(c_ptr), intent(out) :: baseptr
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_allocate_shared(size, int(disp_unit,c_int), info % MPI_VAL, comm % MPI_VAL, baseptr, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_allocate_shared_c_f08(size, disp_unit, info, comm, baseptr, win, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Info, MPI_Comm, MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_allocate_shared_c
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size, disp_unit
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(c_ptr), intent(out) :: baseptr
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_allocate_shared_c(size, disp_unit, info % MPI_VAL, comm % MPI_VAL, baseptr, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

#ifdef HAVE_CFI
        subroutine MPI_Win_create_f08ts(base, size, disp_unit, info, comm, win, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Info, MPI_Comm, MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_create
            type(*), dimension(..), asynchronous :: base
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
            integer, intent(in) :: disp_unit
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_create(base, size, int(disp_unit,c_int), info % MPI_VAL, comm % MPI_VAL, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_attach_f08ts(win, base, size, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_attach
            type(MPI_Win), intent(in) :: win
            type(*), dimension(..), asynchronous :: base
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_attach(win % MPI_VAL, base, size, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_detach_f08ts(win, base, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_detach
            type(MPI_Win), intent(in) :: win
            type(*), dimension(..), asynchronous :: base
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_detach(win % MPI_VAL, base, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Put_f08ts(origin_addr, origin_count, origin_datatype, target_rank, target_disp, &
                                 target_count, target_datatype, win, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype, MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Put
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer, intent(in) :: origin_count, target_rank, target_count
            type(MPI_Datatype), intent(in) :: origin_datatype, target_datatype
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Put(origin_addr, int(origin_count,c_int), origin_datatype % MPI_VAL, int(target_rank,c_int), &
                               target_disp, int(target_count,c_int), target_datatype % MPI_VAL, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Get_f08ts(origin_addr, origin_count, origin_datatype, target_rank, target_disp, &
                                 target_count, target_datatype, win, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype, MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Get
            type(*), dimension(..), asynchronous :: origin_addr
            integer, intent(in) :: origin_count, target_rank, target_count
            type(MPI_Datatype), intent(in) :: origin_datatype, target_datatype
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Get(origin_addr, int(origin_count,c_int), origin_datatype % MPI_VAL, int(target_rank,c_int), &
                               target_disp, int(target_count,c_int), target_datatype % MPI_VAL, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Accumulate_f08ts(origin_addr, origin_count, origin_datatype, target_rank, target_disp, &
                                        target_count, target_datatype, op, win, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Accumulate
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer, intent(in) :: origin_count, target_rank, target_count
            type(MPI_Datatype), intent(in) :: origin_datatype, target_datatype
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Accumulate(origin_addr, int(origin_count,c_int), origin_datatype % MPI_VAL, int(target_rank,c_int), &
                                      target_disp, int(target_count,c_int), target_datatype % MPI_VAL, op % MPI_VAL, &
                                      win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Get_accumulate_f08ts(origin_addr, origin_count, origin_datatype, result_addr, &
                                            result_count, result_datatype, target_rank, target_disp, &
                                            target_count, target_datatype, op, win, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Get_accumulate
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            type(*), dimension(..), asynchronous :: result_addr
            integer, intent(in) :: origin_count, result_count, target_rank, target_count
            type(MPI_Datatype), intent(in) :: origin_datatype, result_datatype, target_datatype
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Get_accumulate(origin_addr, int(origin_count,c_int), origin_datatype % MPI_VAL, &
                                          result_addr, int(result_count,c_int), result_datatype % MPI_VAL, &
                                          int(target_rank,c_int), target_disp, int(target_count,c_int), &
                                          target_datatype % MPI_VAL, op % MPI_VAL, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Rput_f08ts(origin_addr, origin_count, origin_datatype, target_rank, target_disp, &
                                  target_count, target_datatype, win, request, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype, MPI_Win, MPI_Request
            use mpi_direct_win_c, only: VAPAA_MPI_Rput
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer, intent(in) :: origin_count, target_rank, target_count
            type(MPI_Datatype), intent(in) :: origin_datatype, target_datatype
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Rput(origin_addr, int(origin_count,c_int), origin_datatype % MPI_VAL, int(target_rank,c_int), &
                                target_disp, int(target_count,c_int), target_datatype % MPI_VAL, win % MPI_VAL, &
                                request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Rget_f08ts(origin_addr, origin_count, origin_datatype, target_rank, target_disp, &
                                  target_count, target_datatype, win, request, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype, MPI_Win, MPI_Request
            use mpi_direct_win_c, only: VAPAA_MPI_Rget
            type(*), dimension(..), asynchronous :: origin_addr
            integer, intent(in) :: origin_count, target_rank, target_count
            type(MPI_Datatype), intent(in) :: origin_datatype, target_datatype
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Rget(origin_addr, int(origin_count,c_int), origin_datatype % MPI_VAL, int(target_rank,c_int), &
                                target_disp, int(target_count,c_int), target_datatype % MPI_VAL, win % MPI_VAL, &
                                request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Raccumulate_f08ts(origin_addr, origin_count, origin_datatype, target_rank, target_disp, &
                                         target_count, target_datatype, op, win, request, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win, MPI_Request
            use mpi_direct_win_c, only: VAPAA_MPI_Raccumulate
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer, intent(in) :: origin_count, target_rank, target_count
            type(MPI_Datatype), intent(in) :: origin_datatype, target_datatype
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Raccumulate(origin_addr, int(origin_count,c_int), origin_datatype % MPI_VAL, int(target_rank,c_int), &
                                       target_disp, int(target_count,c_int), target_datatype % MPI_VAL, op % MPI_VAL, &
                                       win % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Rget_accumulate_f08ts(origin_addr, origin_count, origin_datatype, result_addr, &
                                             result_count, result_datatype, target_rank, target_disp, &
                                             target_count, target_datatype, op, win, request, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win, MPI_Request
            use mpi_direct_win_c, only: VAPAA_MPI_Rget_accumulate
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            type(*), dimension(..), asynchronous :: result_addr
            integer, intent(in) :: origin_count, result_count, target_rank, target_count
            type(MPI_Datatype), intent(in) :: origin_datatype, result_datatype, target_datatype
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Rget_accumulate(origin_addr, int(origin_count,c_int), origin_datatype % MPI_VAL, &
                                           result_addr, int(result_count,c_int), result_datatype % MPI_VAL, &
                                           int(target_rank,c_int), target_disp, int(target_count,c_int), &
                                           target_datatype % MPI_VAL, op % MPI_VAL, win % MPI_VAL, &
                                           request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Compare_and_swap_f08ts(origin_addr, compare_addr, result_addr, datatype, target_rank, &
                                              target_disp, win, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype, MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Compare_and_swap
            type(*), dimension(..), intent(in), asynchronous :: origin_addr, compare_addr
            type(*), dimension(..), asynchronous :: result_addr
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Compare_and_swap(origin_addr, compare_addr, result_addr, datatype % MPI_VAL, &
                                            int(target_rank,c_int), target_disp, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Fetch_and_op_f08ts(origin_addr, result_addr, datatype, target_rank, target_disp, op, win, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Fetch_and_op
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            type(*), dimension(..), asynchronous :: result_addr
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Fetch_and_op(origin_addr, result_addr, datatype % MPI_VAL, int(target_rank,c_int), &
                                        target_disp, op % MPI_VAL, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine
#endif

        subroutine MPI_Win_create_dynamic_f08(info, comm, win, ierror)
            use mpi_handle_types, only: MPI_Info, MPI_Comm, MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_create_dynamic
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_create_dynamic(info % MPI_VAL, comm % MPI_VAL, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_free_f08(win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_free
            type(MPI_Win), intent(inout) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_free(win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_shared_query_f08(win, rank, size, disp_unit, baseptr, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_shared_query
            type(MPI_Win), intent(in) :: win
            integer, intent(in) :: rank
            integer(kind=MPI_ADDRESS_KIND), intent(out) :: size
            integer, intent(out) :: disp_unit
            type(c_ptr), intent(out) :: baseptr
            integer, optional, intent(out) :: ierror
            integer(c_int) :: disp_unit_c, ierror_c
            call VAPAA_MPI_Win_shared_query(win % MPI_VAL, int(rank,c_int), size, disp_unit_c, baseptr, ierror_c)
            disp_unit = disp_unit_c
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_shared_query_c_f08(win, rank, size, disp_unit, baseptr, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_shared_query_c
            type(MPI_Win), intent(in) :: win
            integer, intent(in) :: rank
            integer(kind=MPI_ADDRESS_KIND), intent(out) :: size, disp_unit
            type(c_ptr), intent(out) :: baseptr
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_shared_query_c(win % MPI_VAL, int(rank,c_int), size, disp_unit, baseptr, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_get_group_f08(win, group, ierror)
            use mpi_handle_types, only: MPI_Win, MPI_Group
            use mpi_direct_win_c, only: VAPAA_MPI_Win_get_group
            type(MPI_Win), intent(in) :: win
            type(MPI_Group), intent(out) :: group
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_get_group(win % MPI_VAL, group % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_get_info_f08(win, info_used, ierror)
            use mpi_handle_types, only: MPI_Win, MPI_Info
            use mpi_direct_win_c, only: VAPAA_MPI_Win_get_info
            type(MPI_Win), intent(in) :: win
            type(MPI_Info), intent(out) :: info_used
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_get_info(win % MPI_VAL, info_used % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_set_info_f08(win, info, ierror)
            use mpi_handle_types, only: MPI_Win, MPI_Info
            use mpi_direct_win_c, only: VAPAA_MPI_Win_set_info
            type(MPI_Win), intent(in) :: win
            type(MPI_Info), intent(in) :: info
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_set_info(win % MPI_VAL, info % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

#ifdef HAVE_CFI
        subroutine MPI_Win_get_name_f08(win, win_name, resultlen, ierror)
            use mpi_global_constants, only: MPI_MAX_OBJECT_NAME
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_get_name
            type(MPI_Win), intent(in) :: win
            character(len=MPI_MAX_OBJECT_NAME), intent(out) :: win_name
            integer, intent(out) :: resultlen
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: win_name_c(:)
            integer(c_int) :: resultlen_c, ierror_c
            allocate(win_name_c(len(win_name) + 1))
            win_name_c = c_null_char
            call VAPAA_MPI_Win_get_name(win % MPI_VAL, win_name_c, resultlen_c, ierror_c)
            call copy_c_string(win_name_c, win_name)
            resultlen = resultlen_c
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_set_name_f08(win, win_name, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_set_name
            type(MPI_Win), intent(in) :: win
            character(len=*), intent(in) :: win_name
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: win_name_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(win_name, win_name_c)
            call VAPAA_MPI_Win_set_name(win % MPI_VAL, win_name_c, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine
#endif

        subroutine MPI_Win_delete_attr_f08(win, win_keyval, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_delete_attr
            type(MPI_Win), intent(in) :: win
            integer, intent(in) :: win_keyval
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_delete_attr(win % MPI_VAL, int(win_keyval,c_int), ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_free_keyval_f08(win_keyval, ierror)
            use mpi_direct_win_c, only: VAPAA_MPI_Win_free_keyval
            integer, intent(inout) :: win_keyval
            integer, optional, intent(out) :: ierror
            integer(c_int) :: keyval_c, ierror_c
            keyval_c = win_keyval
            call VAPAA_MPI_Win_free_keyval(keyval_c, ierror_c)
            win_keyval = keyval_c
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_get_attr_f08(win, win_keyval, attribute_val, flag, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_get_attr
            type(MPI_Win), intent(in) :: win
            integer, intent(in) :: win_keyval
            integer(kind=MPI_ADDRESS_KIND), intent(out) :: attribute_val
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(c_int) :: flag_c, ierror_c
            call VAPAA_MPI_Win_get_attr(win % MPI_VAL, int(win_keyval,c_int), attribute_val, flag_c, ierror_c)
            flag = flag_c /= 0
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_set_attr_f08(win, win_keyval, attribute_val, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_set_attr
            type(MPI_Win), intent(in) :: win
            integer, intent(in) :: win_keyval
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: attribute_val
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_set_attr(win % MPI_VAL, int(win_keyval,c_int), attribute_val, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

#define WIN_IERR_WRAPPER_1(FNAME,CNAME) \
        subroutine FNAME(win, ierror); \
            use mpi_handle_types, only: MPI_Win; \
            use mpi_direct_win_c, only: CNAME; \
            type(MPI_Win), intent(in) :: win; \
            integer, optional, intent(out) :: ierror; \
            integer(c_int) :: ierror_c; \
            call CNAME(win % MPI_VAL, ierror_c); \
            if (present(ierror)) ierror = ierror_c; \
        end subroutine

        subroutine MPI_Win_fence_f08(assert, win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_fence
            integer, intent(in) :: assert
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_fence(int(assert,c_int), win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_start_f08(group, assert, win, ierror)
            use mpi_handle_types, only: MPI_Win, MPI_Group
            use mpi_direct_win_c, only: VAPAA_MPI_Win_start
            type(MPI_Group), intent(in) :: group
            integer, intent(in) :: assert
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_start(group % MPI_VAL, int(assert,c_int), win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        WIN_IERR_WRAPPER_1(MPI_Win_complete_f08,VAPAA_MPI_Win_complete)

        subroutine MPI_Win_post_f08(group, assert, win, ierror)
            use mpi_handle_types, only: MPI_Win, MPI_Group
            use mpi_direct_win_c, only: VAPAA_MPI_Win_post
            type(MPI_Group), intent(in) :: group
            integer, intent(in) :: assert
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_post(group % MPI_VAL, int(assert,c_int), win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        WIN_IERR_WRAPPER_1(MPI_Win_wait_f08,VAPAA_MPI_Win_wait)

        subroutine MPI_Win_test_f08(win, flag, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_test
            type(MPI_Win), intent(in) :: win
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(c_int) :: flag_c, ierror_c
            call VAPAA_MPI_Win_test(win % MPI_VAL, flag_c, ierror_c)
            flag = flag_c /= 0
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_lock_f08(lock_type, rank, assert, win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_lock
            integer, intent(in) :: lock_type, rank, assert
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_lock(int(lock_type,c_int), int(rank,c_int), int(assert,c_int), win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_unlock_f08(rank, win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_unlock
            integer, intent(in) :: rank
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_unlock(int(rank,c_int), win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        subroutine MPI_Win_lock_all_f08(assert, win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_lock_all
            integer, intent(in) :: assert
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_lock_all(int(assert,c_int), win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        WIN_IERR_WRAPPER_1(MPI_Win_unlock_all_f08,VAPAA_MPI_Win_unlock_all)

        subroutine MPI_Win_flush_f08(rank, win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_flush
            integer, intent(in) :: rank
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_flush(int(rank,c_int), win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        WIN_IERR_WRAPPER_1(MPI_Win_flush_all_f08,VAPAA_MPI_Win_flush_all)

        subroutine MPI_Win_flush_local_f08(rank, win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_direct_win_c, only: VAPAA_MPI_Win_flush_local
            integer, intent(in) :: rank
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Win_flush_local(int(rank,c_int), win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine

        WIN_IERR_WRAPPER_1(MPI_Win_flush_local_all_f08,VAPAA_MPI_Win_flush_local_all)
        WIN_IERR_WRAPPER_1(MPI_Win_sync_f08,VAPAA_MPI_Win_sync)

end module mpi_direct_win_f
