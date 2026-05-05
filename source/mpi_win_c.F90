! SPDX-License-Identifier: MIT

module mpi_win_c

    interface
        subroutine C_MPI_Win_create(base, size, disp_unit, info, comm, win, ierror) &
                   bind(C,name="C_MPI_Win_create")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), dimension(*), intent(in) :: base
            integer(kind=c_intptr_t), intent(in), value :: size
            integer(kind=c_int), intent(in), value :: disp_unit, info, comm
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine C_MPI_Win_create
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Win_create(base, size, disp_unit, info, comm, win, ierror) &
                   bind(C,name="CFI_MPI_Win_create")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), intent(in) :: base
            integer(kind=c_intptr_t), intent(in), value :: size
            integer(kind=c_int), intent(in), value :: disp_unit, info, comm
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine CFI_MPI_Win_create
    end interface
#endif

    interface
        subroutine C_MPI_Win_create_dynamic(info, comm, win, ierror) &
                   bind(C,name="C_MPI_Win_create_dynamic")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: info, comm
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine C_MPI_Win_create_dynamic
    end interface

    interface
        subroutine C_MPI_Win_allocate(size, disp_unit, info, comm, baseptr, win, ierror) &
                   bind(C,name="C_MPI_Win_allocate")
            use iso_c_binding, only: c_int, c_intptr_t, c_ptr
            implicit none
            integer(kind=c_intptr_t), intent(in), value :: size
            integer(kind=c_int), intent(in), value :: disp_unit, info, comm
            type(c_ptr), intent(out) :: baseptr
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine C_MPI_Win_allocate
    end interface

    interface
        subroutine C_MPI_Win_free(win, ierror) &
                   bind(C,name="C_MPI_Win_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Win_free
    end interface

    interface
        subroutine C_MPI_Win_fence(assert, win, ierror) &
                   bind(C,name="C_MPI_Win_fence")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: assert, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Win_fence
    end interface

    interface
        subroutine C_MPI_Win_lock(lock_type, rank, assert, win, ierror) &
                   bind(C,name="C_MPI_Win_lock")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: lock_type, rank, assert, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Win_lock
    end interface

    interface
        subroutine C_MPI_Win_unlock(rank, win, ierror) &
                   bind(C,name="C_MPI_Win_unlock")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: rank, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Win_unlock
    end interface

    interface
        subroutine C_MPI_Win_lock_all(assert, win, ierror) &
                   bind(C,name="C_MPI_Win_lock_all")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: assert, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Win_lock_all
    end interface

    interface
        subroutine C_MPI_Win_unlock_all(win, ierror) &
                   bind(C,name="C_MPI_Win_unlock_all")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Win_unlock_all
    end interface

    interface
        subroutine C_MPI_Win_flush(rank, win, ierror) &
                   bind(C,name="C_MPI_Win_flush")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: rank, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Win_flush
    end interface

    interface
        subroutine C_MPI_Win_flush_all(win, ierror) &
                   bind(C,name="C_MPI_Win_flush_all")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Win_flush_all
    end interface

end module mpi_win_c
