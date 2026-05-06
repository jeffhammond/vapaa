! SPDX-License-Identifier: MIT

module mpi_win_f
    use iso_c_binding, only: c_int, c_intptr_t, c_ptr
    implicit none

    interface MPI_Win_create
#ifdef HAVE_CFI
        module procedure MPI_Win_create_f08ts
#else
        module procedure MPI_Win_create_f08
#endif
    end interface MPI_Win_create

    interface MPI_Win_create_dynamic
        module procedure MPI_Win_create_dynamic_f08
    end interface MPI_Win_create_dynamic

    interface MPI_Win_allocate
        module procedure MPI_Win_allocate_f08
    end interface MPI_Win_allocate

    interface MPI_Win_free
        module procedure MPI_Win_free_f08
    end interface MPI_Win_free

    interface MPI_Win_fence
        module procedure MPI_Win_fence_f08
    end interface MPI_Win_fence

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

    contains

        subroutine MPI_Win_create_f08(base, size, disp_unit, info, comm, win, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info, MPI_Win
            use mpi_win_c, only: C_MPI_Win_create
!dir$ ignore_tkr base
            integer, dimension(*), intent(in) :: base
            integer(kind=c_intptr_t), intent(in) :: size
            integer, intent(in) :: disp_unit
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: disp_unit_c, ierror_c
            integer(kind=c_intptr_t) :: size_c
            size_c = size
            disp_unit_c = disp_unit
            call C_MPI_Win_create(base, size_c, disp_unit_c, info % MPI_VAL, &
                                  comm % MPI_VAL, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_create_f08

#ifdef HAVE_CFI
        subroutine MPI_Win_create_f08ts(base, size, disp_unit, info, comm, win, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info, MPI_Win
            use mpi_win_c, only: CFI_MPI_Win_create
            type(*), dimension(..), intent(in) :: base
            integer(kind=c_intptr_t), intent(in) :: size
            integer, intent(in) :: disp_unit
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: disp_unit_c, ierror_c
            integer(kind=c_intptr_t) :: size_c
            size_c = size
            disp_unit_c = disp_unit
            call CFI_MPI_Win_create(base, size_c, disp_unit_c, info % MPI_VAL, &
                                    comm % MPI_VAL, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_create_f08ts
#endif

        subroutine MPI_Win_create_dynamic_f08(info, comm, win, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info, MPI_Win
            use mpi_win_c, only: C_MPI_Win_create_dynamic
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Win_create_dynamic(info % MPI_VAL, comm % MPI_VAL, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_create_dynamic_f08

        subroutine MPI_Win_allocate_f08(size, disp_unit, info, comm, baseptr, win, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info, MPI_Win
            use mpi_win_c, only: C_MPI_Win_allocate
            integer(kind=c_intptr_t), intent(in) :: size
            integer, intent(in) :: disp_unit
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(in) :: comm
            type(c_ptr), intent(out) :: baseptr
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: disp_unit_c, ierror_c
            integer(kind=c_intptr_t) :: size_c
            size_c = size
            disp_unit_c = disp_unit
            call C_MPI_Win_allocate(size_c, disp_unit_c, info % MPI_VAL, &
                                    comm % MPI_VAL, baseptr, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_allocate_f08

        subroutine MPI_Win_free_f08(win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_free
            type(MPI_Win), intent(inout) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Win_free(win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_free_f08

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

        subroutine MPI_Win_lock_f08(lock_type, rank, assert, win, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_lock
            integer, intent(in) :: lock_type, rank, assert
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

end module mpi_win_f
