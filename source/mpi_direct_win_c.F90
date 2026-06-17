! SPDX-License-Identifier: MIT

module mpi_direct_win_c
    use iso_c_binding, only: c_int, c_intptr_t, c_ptr
    implicit none

    interface
        subroutine VAPAA_MPI_Win_allocate(size, disp_unit, info, comm, baseptr, win, ierror) &
                   bind(C,name="VAPAA_MPI_Win_allocate")
            use iso_c_binding, only: c_int, c_intptr_t, c_ptr
            implicit none
            integer(kind=c_intptr_t), intent(in) :: size
            integer(kind=c_int), intent(in) :: disp_unit, info, comm
            type(c_ptr), intent(out) :: baseptr
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine VAPAA_MPI_Win_allocate

        subroutine VAPAA_MPI_Win_allocate_c(size, disp_unit, info, comm, baseptr, win, ierror) &
                   bind(C,name="VAPAA_MPI_Win_allocate_c")
            use iso_c_binding, only: c_int, c_intptr_t, c_ptr
            implicit none
            integer(kind=c_intptr_t), intent(in) :: size, disp_unit
            integer(kind=c_int), intent(in) :: info, comm
            type(c_ptr), intent(out) :: baseptr
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine VAPAA_MPI_Win_allocate_c

        subroutine VAPAA_MPI_Win_allocate_shared(size, disp_unit, info, comm, baseptr, win, ierror) &
                   bind(C,name="VAPAA_MPI_Win_allocate_shared")
            use iso_c_binding, only: c_int, c_intptr_t, c_ptr
            implicit none
            integer(kind=c_intptr_t), intent(in) :: size
            integer(kind=c_int), intent(in) :: disp_unit, info, comm
            type(c_ptr), intent(out) :: baseptr
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine VAPAA_MPI_Win_allocate_shared

        subroutine VAPAA_MPI_Win_allocate_shared_c(size, disp_unit, info, comm, baseptr, win, ierror) &
                   bind(C,name="VAPAA_MPI_Win_allocate_shared_c")
            use iso_c_binding, only: c_int, c_intptr_t, c_ptr
            implicit none
            integer(kind=c_intptr_t), intent(in) :: size, disp_unit
            integer(kind=c_int), intent(in) :: info, comm
            type(c_ptr), intent(out) :: baseptr
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine VAPAA_MPI_Win_allocate_shared_c

        subroutine VAPAA_MPI_Win_create_dynamic(info, comm, win, ierror) &
                   bind(C,name="VAPAA_MPI_Win_create_dynamic")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: info, comm
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine VAPAA_MPI_Win_create_dynamic

        subroutine VAPAA_MPI_Win_free(win, ierror) bind(C,name="VAPAA_MPI_Win_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_free

        subroutine VAPAA_MPI_Win_shared_query(win, rank, size, disp_unit, baseptr, ierror) &
                   bind(C,name="VAPAA_MPI_Win_shared_query")
            use iso_c_binding, only: c_int, c_intptr_t, c_ptr
            implicit none
            integer(kind=c_int), intent(in) :: win, rank
            integer(kind=c_intptr_t), intent(out) :: size
            integer(kind=c_int), intent(out) :: disp_unit
            type(c_ptr), intent(out) :: baseptr
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_shared_query

        subroutine VAPAA_MPI_Win_shared_query_c(win, rank, size, disp_unit, baseptr, ierror) &
                   bind(C,name="VAPAA_MPI_Win_shared_query_c")
            use iso_c_binding, only: c_int, c_intptr_t, c_ptr
            implicit none
            integer(kind=c_int), intent(in) :: win, rank
            integer(kind=c_intptr_t), intent(out) :: size, disp_unit
            type(c_ptr), intent(out) :: baseptr
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_shared_query_c

        subroutine VAPAA_MPI_Win_get_group(win, group, ierror) bind(C,name="VAPAA_MPI_Win_get_group")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win
            integer(kind=c_int), intent(out) :: group, ierror
        end subroutine VAPAA_MPI_Win_get_group

        subroutine VAPAA_MPI_Win_get_info(win, info_used, ierror) bind(C,name="VAPAA_MPI_Win_get_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win
            integer(kind=c_int), intent(out) :: info_used, ierror
        end subroutine VAPAA_MPI_Win_get_info

        subroutine VAPAA_MPI_Win_set_info(win, info, ierror) bind(C,name="VAPAA_MPI_Win_set_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win, info
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_set_info

        subroutine VAPAA_MPI_Win_delete_attr(win, keyval, ierror) bind(C,name="VAPAA_MPI_Win_delete_attr")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win, keyval
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_delete_attr

        subroutine VAPAA_MPI_Win_free_keyval(keyval, ierror) bind(C,name="VAPAA_MPI_Win_free_keyval")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: keyval
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_free_keyval

        subroutine VAPAA_MPI_Win_get_attr(win, keyval, attrval, flag, ierror) bind(C,name="VAPAA_MPI_Win_get_attr")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: win, keyval
            integer(kind=c_intptr_t), intent(out) :: attrval
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine VAPAA_MPI_Win_get_attr

        subroutine VAPAA_MPI_Win_set_attr(win, keyval, attrval, ierror) bind(C,name="VAPAA_MPI_Win_set_attr")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: win, keyval
            integer(kind=c_intptr_t), intent(in) :: attrval
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_set_attr

        subroutine VAPAA_MPI_Win_fence(assert, win, ierror) bind(C,name="VAPAA_MPI_Win_fence")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: assert, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_fence

        subroutine VAPAA_MPI_Win_start(group, assert, win, ierror) bind(C,name="VAPAA_MPI_Win_start")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group, assert, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_start

        subroutine VAPAA_MPI_Win_complete(win, ierror) bind(C,name="VAPAA_MPI_Win_complete")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_complete

        subroutine VAPAA_MPI_Win_post(group, assert, win, ierror) bind(C,name="VAPAA_MPI_Win_post")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group, assert, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_post

        subroutine VAPAA_MPI_Win_wait(win, ierror) bind(C,name="VAPAA_MPI_Win_wait")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_wait

        subroutine VAPAA_MPI_Win_test(win, flag, ierror) bind(C,name="VAPAA_MPI_Win_test")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine VAPAA_MPI_Win_test

        subroutine VAPAA_MPI_Win_lock(lock_type, rank, assert, win, ierror) bind(C,name="VAPAA_MPI_Win_lock")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: lock_type, rank, assert, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_lock

        subroutine VAPAA_MPI_Win_unlock(rank, win, ierror) bind(C,name="VAPAA_MPI_Win_unlock")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: rank, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_unlock

        subroutine VAPAA_MPI_Win_lock_all(assert, win, ierror) bind(C,name="VAPAA_MPI_Win_lock_all")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: assert, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_lock_all

        subroutine VAPAA_MPI_Win_unlock_all(win, ierror) bind(C,name="VAPAA_MPI_Win_unlock_all")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_unlock_all

        subroutine VAPAA_MPI_Win_flush(rank, win, ierror) bind(C,name="VAPAA_MPI_Win_flush")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: rank, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_flush

        subroutine VAPAA_MPI_Win_flush_all(win, ierror) bind(C,name="VAPAA_MPI_Win_flush_all")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_flush_all

        subroutine VAPAA_MPI_Win_flush_local(rank, win, ierror) bind(C,name="VAPAA_MPI_Win_flush_local")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: rank, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_flush_local

        subroutine VAPAA_MPI_Win_flush_local_all(win, ierror) bind(C,name="VAPAA_MPI_Win_flush_local_all")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_flush_local_all

        subroutine VAPAA_MPI_Win_sync(win, ierror) bind(C,name="VAPAA_MPI_Win_sync")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_sync
    end interface

#ifdef HAVE_CFI
    interface
        subroutine VAPAA_MPI_Put(origin_addr, origin_count, origin_datatype, target_rank, target_disp, &
                                 target_count, target_datatype, win, ierror) bind(C,name="VAPAA_MPI_Put")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), intent(in) :: origin_count, origin_datatype, target_rank, target_count, target_datatype, win
            integer(kind=c_intptr_t), intent(in) :: target_disp
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Put

        subroutine VAPAA_MPI_Get(origin_addr, origin_count, origin_datatype, target_rank, target_disp, &
                                 target_count, target_datatype, win, ierror) bind(C,name="VAPAA_MPI_Get")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), asynchronous :: origin_addr
            integer(kind=c_int), intent(in) :: origin_count, origin_datatype, target_rank, target_count, target_datatype, win
            integer(kind=c_intptr_t), intent(in) :: target_disp
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Get

        subroutine VAPAA_MPI_Accumulate(origin_addr, origin_count, origin_datatype, target_rank, target_disp, &
                                        target_count, target_datatype, op, win, ierror) bind(C,name="VAPAA_MPI_Accumulate")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), intent(in) :: origin_count, origin_datatype, target_rank, target_count, target_datatype, op, win
            integer(kind=c_intptr_t), intent(in) :: target_disp
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Accumulate

        subroutine VAPAA_MPI_Get_accumulate(origin_addr, origin_count, origin_datatype, result_addr, &
                                            result_count, result_datatype, target_rank, target_disp, &
                                            target_count, target_datatype, op, win, ierror) &
                   bind(C,name="VAPAA_MPI_Get_accumulate")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            type(*), dimension(..), asynchronous :: result_addr
            integer(kind=c_int), intent(in) :: origin_count, origin_datatype, result_count, result_datatype
            integer(kind=c_int), intent(in) :: target_rank, target_count, target_datatype, op, win
            integer(kind=c_intptr_t), intent(in) :: target_disp
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Get_accumulate

        subroutine VAPAA_MPI_Rput(origin_addr, origin_count, origin_datatype, target_rank, target_disp, &
                                  target_count, target_datatype, win, request, ierror) bind(C,name="VAPAA_MPI_Rput")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), intent(in) :: origin_count, origin_datatype, target_rank, target_count, target_datatype, win
            integer(kind=c_intptr_t), intent(in) :: target_disp
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine VAPAA_MPI_Rput

        subroutine VAPAA_MPI_Rget(origin_addr, origin_count, origin_datatype, target_rank, target_disp, &
                                  target_count, target_datatype, win, request, ierror) bind(C,name="VAPAA_MPI_Rget")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), asynchronous :: origin_addr
            integer(kind=c_int), intent(in) :: origin_count, origin_datatype, target_rank, target_count, target_datatype, win
            integer(kind=c_intptr_t), intent(in) :: target_disp
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine VAPAA_MPI_Rget

        subroutine VAPAA_MPI_Raccumulate(origin_addr, origin_count, origin_datatype, target_rank, target_disp, &
                                         target_count, target_datatype, op, win, request, ierror) &
                   bind(C,name="VAPAA_MPI_Raccumulate")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), intent(in) :: origin_count, origin_datatype, target_rank, target_count, target_datatype, op, win
            integer(kind=c_intptr_t), intent(in) :: target_disp
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine VAPAA_MPI_Raccumulate

        subroutine VAPAA_MPI_Rget_accumulate(origin_addr, origin_count, origin_datatype, result_addr, &
                                             result_count, result_datatype, target_rank, target_disp, &
                                             target_count, target_datatype, op, win, request, ierror) &
                   bind(C,name="VAPAA_MPI_Rget_accumulate")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            type(*), dimension(..), asynchronous :: result_addr
            integer(kind=c_int), intent(in) :: origin_count, origin_datatype, result_count, result_datatype
            integer(kind=c_int), intent(in) :: target_rank, target_count, target_datatype, op, win
            integer(kind=c_intptr_t), intent(in) :: target_disp
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine VAPAA_MPI_Rget_accumulate

        subroutine VAPAA_MPI_Compare_and_swap(origin_addr, compare_addr, result_addr, datatype, target_rank, &
                                              target_disp, win, ierror) bind(C,name="VAPAA_MPI_Compare_and_swap")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: origin_addr, compare_addr
            type(*), dimension(..), asynchronous :: result_addr
            integer(kind=c_int), intent(in) :: datatype, target_rank, win
            integer(kind=c_intptr_t), intent(in) :: target_disp
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Compare_and_swap

        subroutine VAPAA_MPI_Fetch_and_op(origin_addr, result_addr, datatype, target_rank, target_disp, &
                                          op, win, ierror) bind(C,name="VAPAA_MPI_Fetch_and_op")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            type(*), dimension(..), asynchronous :: result_addr
            integer(kind=c_int), intent(in) :: datatype, target_rank, op, win
            integer(kind=c_intptr_t), intent(in) :: target_disp
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Fetch_and_op

        subroutine VAPAA_MPI_Win_create(base, size, disp_unit, info, comm, win, ierror) &
                   bind(C,name="VAPAA_MPI_Win_create")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), asynchronous :: base
            integer(kind=c_intptr_t), intent(in) :: size
            integer(kind=c_int), intent(in) :: disp_unit, info, comm
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine VAPAA_MPI_Win_create

        subroutine VAPAA_MPI_Win_attach(win, base, size, ierror) bind(C,name="VAPAA_MPI_Win_attach")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: win
            type(*), dimension(..), asynchronous :: base
            integer(kind=c_intptr_t), intent(in) :: size
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_attach

        subroutine VAPAA_MPI_Win_detach(win, base, ierror) bind(C,name="VAPAA_MPI_Win_detach")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win
            type(*), dimension(..), asynchronous :: base
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_detach

        subroutine VAPAA_MPI_Win_get_name(win, name, resultlen, ierror) bind(C,name="VAPAA_MPI_Win_get_name")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win
            type(*), dimension(..), intent(inout) :: name
            integer(kind=c_int), intent(out) :: resultlen, ierror
        end subroutine VAPAA_MPI_Win_get_name

        subroutine VAPAA_MPI_Win_set_name(win, name, ierror) bind(C,name="VAPAA_MPI_Win_set_name")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win
            type(*), dimension(..), intent(in) :: name
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Win_set_name
    end interface
#endif

end module mpi_direct_win_c
