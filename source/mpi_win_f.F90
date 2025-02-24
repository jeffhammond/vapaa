#include "vapaa_constants.h"

module mpi_win_f
    use iso_c_binding, only: c_int
    implicit none

    ! RMA mode constants
    integer, parameter :: MPI_MODE_NOCHECK          = VAPAA_MPI_MODE_NOCHECK
    integer, parameter :: MPI_MODE_NOPRECEDE        = VAPAA_MPI_MODE_NOPRECEDE
    integer, parameter :: MPI_MODE_NOPUT            = VAPAA_MPI_MODE_NOPUT
    integer, parameter :: MPI_MODE_NOSTORE          = VAPAA_MPI_MODE_NOSTORE
    integer, parameter :: MPI_MODE_NOSUCCEED        = VAPAA_MPI_MODE_NOSUCCEED

    ! other constants
    integer, parameter :: MPI_LOCK_SHARED            = VAPAA_MPI_LOCK_SHARED
    integer, parameter :: MPI_LOCK_EXCLUSIVE         = VAPAA_MPI_LOCK_EXCLUSIVE

    interface MPI_Win_create
#ifdef HAVE_CFI
        module procedure MPI_Win_create_f08ts
#else
        module procedure MPI_Win_create_f08
#endif
    end interface MPI_Win_create

    interface MPI_Win_allocate
        module procedure MPI_Win_allocate_f08
    end interface MPI_Win_allocate

    interface MPI_Win_allocate_shared
        module procedure MPI_Win_allocate_shared_f08
    end interface MPI_Win_allocate_shared

    interface MPI_Win_shared_query
        module procedure MPI_Win_shared_query_f08
    end interface MPI_Win_shared_query

    interface MPI_Win_create_dynamic
        module procedure MPI_Win_create_dynamic_f08
    end interface MPI_Win_create_dynamic

    interface MPI_Win_attach
#ifdef HAVE_CFI
        module procedure MPI_Win_attach_f08ts
#else
        module procedure MPI_Win_attach_f08
#endif
    end interface MPI_Win_attach

    interface MPI_Win_detach
#ifdef HAVE_CFI
        module procedure MPI_Win_detach_f08ts
#else
        module procedure MPI_Win_detach_f08
#endif
    end interface MPI_Win_detach

    interface MPI_Win_free
        module procedure MPI_Win_free_f08
    end interface MPI_Win_free

    interface MPI_Win_get_group
        module procedure MPI_Win_get_group_f08
    end interface MPI_Win_get_group

    interface MPI_Win_fence
        module procedure MPI_Win_fence_f08
    end interface MPI_Win_fence

    interface MPI_Win_post
        module procedure MPI_Win_post_f08
    end interface MPI_Win_post

    interface MPI_Win_start
        module procedure MPI_Win_start_f08
    end interface MPI_Win_start

    interface MPI_Win_complete
        module procedure MPI_Win_complete_f08
    end interface MPI_Win_complete

    interface MPI_Win_wait
        module procedure MPI_Win_wait_f08
    end interface MPI_Win_wait

    interface MPI_Win_test
        module procedure MPI_Win_test_f08
    end interface MPI_Win_test

    interface MPI_Win_lock
        module procedure MPI_Win_lock_f08
    end interface MPI_Win_lock

    interface MPI_Win_unlock
        module procedure MPI_Win_unlock_f08
    end interface MPI_Win_unlock

    interface MPI_Win_lock_all
        module procedure MPI_Win_lock_all_f08
    end interface MPI_Win_lock_all

    interface MPI_Win_unlock_all
        module procedure MPI_Win_unlock_all_f08
    end interface MPI_Win_unlock_all

    interface MPI_Win_flush
        module procedure MPI_Win_flush_f08
    end interface MPI_Win_flush

    interface MPI_Win_flush_all
        module procedure MPI_Win_flush_all_f08
    end interface MPI_Win_flush_all

    interface MPI_Win_flush_local
        module procedure MPI_Win_flush_local_f08
    end interface MPI_Win_flush_local

    interface MPI_Win_flush_local_all
        module procedure MPI_Win_flush_local_all_f08
    end interface MPI_Win_flush_local_all

    interface MPI_Win_sync
        module procedure MPI_Win_sync_f08
    end interface MPI_Win_sync

    contains

        subroutine MPI_Win_fence_f08(assert, win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_fence
            integer, intent(in) :: assert
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: assert_c, ierror_c

            assert_c = assert
            call C_MPI_Win_fence(assert_c, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_fence_f08

        subroutine MPI_Win_start_f08(group, assert, win, ierror)
            use mpi_handle_types, only: MPI_Group, MPI_Win
            use mpi_win_c, only: C_MPI_Win_start
            type(MPI_Group), intent(in) :: group
            integer, intent(in) :: assert
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: assert_c, ierror_c

            assert_c = assert
            call C_MPI_Win_start(group % MPI_VAL, assert_c, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_start_f08

        subroutine MPI_Win_complete_f08(win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_complete
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c

            call C_MPI_Win_complete(win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_complete_f08

        subroutine MPI_Win_post_f08(group, assert, win, ierror)
            use mpi_handle_types, only: MPI_Group, MPI_Win
            use mpi_win_c, only: C_MPI_Win_post
            type(MPI_Group), intent(in) :: group
            integer, intent(in) :: assert
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: assert_c, ierror_c

            assert_c = assert
            call C_MPI_Win_post(group % MPI_VAL, assert_c, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_post_f08

        subroutine MPI_Win_wait_f08(win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_wait
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c

            call C_MPI_Win_wait(win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_wait_f08

        subroutine MPI_Win_test_f08(win, flag, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_test
            type(MPI_Win), intent(in) :: win
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: flag_c, ierror_c

            call C_MPI_Win_test(win % MPI_VAL, flag_c, ierror_c)
            flag = (flag_c /= 0)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_test_f08

        subroutine MPI_Win_lock_f08(lock_type, rank, assert, win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_lock
            integer, intent(in) :: lock_type
            integer, intent(in) :: rank
            integer, intent(in) :: assert
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: lock_type_c, rank_c, assert_c, ierror_c

            lock_type_c = lock_type
            rank_c = rank
            assert_c = assert
            call C_MPI_Win_lock(lock_type_c, rank_c, assert_c, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_lock_f08

        subroutine MPI_Win_unlock_f08(rank, win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_unlock
            integer, intent(in) :: rank
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, ierror_c

            rank_c = rank
            call C_MPI_Win_unlock(rank_c, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_unlock_f08

        subroutine MPI_Win_lock_all_f08(assert, win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_lock_all
            integer, intent(in) :: assert
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: assert_c, ierror_c

            assert_c = assert
            call C_MPI_Win_lock_all(assert_c, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_lock_all_f08

        subroutine MPI_Win_unlock_all_f08(win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_unlock_all
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c

            call C_MPI_Win_unlock_all(win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_unlock_all_f08

        subroutine MPI_Win_flush_f08(rank, win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_flush
            integer, intent(in) :: rank
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, ierror_c

            rank_c = rank
            call C_MPI_Win_flush(rank_c, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_flush_f08

        subroutine MPI_Win_flush_all_f08(win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_flush_all
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c

            call C_MPI_Win_flush_all(win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_flush_all_f08

        subroutine MPI_Win_flush_local_f08(rank, win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_flush_local
            integer, intent(in) :: rank
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, ierror_c

            rank_c = rank
            call C_MPI_Win_flush_local(rank_c, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_flush_local_f08

        subroutine MPI_Win_flush_local_all_f08(win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_flush_local_all
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c

            call C_MPI_Win_flush_local_all(win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_flush_local_all_f08

        subroutine MPI_Win_sync_f08(win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_sync
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c

            call C_MPI_Win_sync(win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_sync_f08

        subroutine MPI_Win_create_f08(base, size, disp_unit, info, comm, win, ierror)
            use mpi_handle_types, only: MPI_Info, MPI_Comm, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_win_c, only: C_MPI_Win_create
!dir$ ignore_tkr base
            integer, dimension(*), asynchronous :: base
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
            integer, intent(in) :: disp_unit
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: disp_unit_c, win_c, ierror_c

            disp_unit_c = disp_unit
            call C_MPI_Win_create(base, size, disp_unit_c, info % MPI_VAL, &
                                comm % MPI_VAL, win_c, ierror_c)
            win % MPI_VAL = win_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_create_f08

        subroutine MPI_Win_allocate_f08(size, disp_unit, info, comm, baseptr, win, ierror)
            use mpi_handle_types, only: MPI_Info, MPI_Comm, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_win_c, only: C_MPI_Win_allocate
            use, intrinsic :: iso_c_binding, only: c_ptr, c_f_pointer
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
            integer, intent(in) :: disp_unit
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            integer, dimension(:), pointer, intent(out) :: baseptr
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: disp_unit_c, win_c, ierror_c
            type(c_ptr) :: baseptr_c

            disp_unit_c = disp_unit
            call C_MPI_Win_allocate(size, disp_unit_c, info % MPI_VAL, &
                                  comm % MPI_VAL, baseptr_c, win_c, ierror_c)
            call c_f_pointer(baseptr_c, baseptr, [size])
            win % MPI_VAL = win_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_allocate_f08

        subroutine MPI_Win_allocate_shared_f08(size, disp_unit, info, comm, baseptr, win, ierror)
            use mpi_handle_types, only: MPI_Info, MPI_Comm, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_win_c, only: C_MPI_Win_allocate_shared
            use, intrinsic :: iso_c_binding, only: c_ptr, c_f_pointer
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
            integer, intent(in) :: disp_unit
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            integer, dimension(:), pointer, intent(out) :: baseptr
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: disp_unit_c, win_c, ierror_c
            type(c_ptr) :: baseptr_c

            disp_unit_c = disp_unit
            call C_MPI_Win_allocate_shared(size, disp_unit_c, info % MPI_VAL, &
                                         comm % MPI_VAL, baseptr_c, win_c, ierror_c)
            call c_f_pointer(baseptr_c, baseptr, [size])
            win % MPI_VAL = win_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_allocate_shared_f08

        subroutine MPI_Win_shared_query_f08(win, rank, size, disp_unit, baseptr, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_win_c, only: C_MPI_Win_shared_query
            use, intrinsic :: iso_c_binding, only: c_ptr, c_f_pointer
            type(MPI_Win), intent(in) :: win
            integer, intent(in) :: rank
            integer(kind=MPI_ADDRESS_KIND), intent(out) :: size
            integer, intent(out) :: disp_unit
            integer, dimension(:), pointer, intent(out) :: baseptr
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, disp_unit_c, ierror_c
            type(c_ptr) :: baseptr_c

            rank_c = rank
            call C_MPI_Win_shared_query(win % MPI_VAL, rank_c, size, disp_unit_c, &
                                      baseptr_c, ierror_c)
            disp_unit = disp_unit_c
            call c_f_pointer(baseptr_c, baseptr, [size])
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_shared_query_f08

        subroutine MPI_Win_create_dynamic_f08(info, comm, win, ierror)
            use mpi_handle_types, only: MPI_Info, MPI_Comm, MPI_Win
            use mpi_win_c, only: C_MPI_Win_create_dynamic
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: win_c, ierror_c

            call C_MPI_Win_create_dynamic(info % MPI_VAL, comm % MPI_VAL, &
                                        win_c, ierror_c)
            win % MPI_VAL = win_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_create_dynamic_f08

        subroutine MPI_Win_attach_f08(win, base, size, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_win_c, only: C_MPI_Win_attach
!dir$ ignore_tkr base
            type(MPI_Win), intent(in) :: win
            integer, dimension(*), asynchronous :: base
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c

            call C_MPI_Win_attach(win % MPI_VAL, base, size, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_attach_f08

        subroutine MPI_Win_detach_f08(win, base, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_detach
!dir$ ignore_tkr base
            type(MPI_Win), intent(in) :: win
            integer, dimension(*), asynchronous :: base
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c

            call C_MPI_Win_detach(win % MPI_VAL, base, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_detach_f08

        subroutine MPI_Win_free_f08(win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_free
            type(MPI_Win), intent(inout) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c

            call C_MPI_Win_free(win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_free_f08

        subroutine MPI_Win_get_group_f08(win, group, ierror)
            use mpi_handle_types, only: MPI_Win, MPI_Group
            use mpi_win_c, only: C_MPI_Win_get_group
            type(MPI_Win), intent(in) :: win
            type(MPI_Group), intent(out) :: group
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: group_c, ierror_c

            call C_MPI_Win_get_group(win % MPI_VAL, group_c, ierror_c)
            group % MPI_VAL = group_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_get_group_f08

#ifdef HAVE_CFI
        subroutine MPI_Win_create_f08ts(base, size, disp_unit, info, comm, win, ierror)
            use mpi_handle_types, only: MPI_Info, MPI_Comm, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_win_c, only: CFI_MPI_Win_create
            type(*), dimension(..), asynchronous :: base
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
            integer, intent(in) :: disp_unit
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: disp_unit_c, win_c, ierror_c

            disp_unit_c = disp_unit
            call CFI_MPI_Win_create(base, size, disp_unit_c, info % MPI_VAL, &
                                  comm % MPI_VAL, win_c, ierror_c)
            win % MPI_VAL = win_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_create_f08ts

        subroutine MPI_Win_attach_f08ts(win, base, size, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_win_c, only: CFI_MPI_Win_attach
            type(MPI_Win), intent(in) :: win
            type(*), dimension(..), asynchronous :: base
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c

            call CFI_MPI_Win_attach(win % MPI_VAL, base, size, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_attach_f08ts

        subroutine MPI_Win_detach_f08ts(win, base, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: CFI_MPI_Win_detach
            type(MPI_Win), intent(in) :: win
            type(*), dimension(..), asynchronous :: base
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c

            call CFI_MPI_Win_detach(win % MPI_VAL, base, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_detach_f08ts
#endif

end module mpi_win_f
