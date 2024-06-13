! SPDX-License-Identifier: MIT

module mpi_win_c

    interface
        subroutine C_MPI_Win_allocate(size, disp_unit, info, comm, base, win, ierror) &
                   bind(C,name="C_MPI_Win_allocate")
            use iso_c_binding, only: c_int, c_size_t, c_ptr
            implicit none
            integer(kind=c_size_t), intent(in), value :: size
            integer(kind=c_int), intent(in), value :: disp_unit, info, comm
            type(c_ptr), intent(out) :: base
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine C_MPI_Win_allocate
    end interface

    interface
        subroutine C_MPI_Win_create(base, size, disp_unit, info, comm, win, ierror) &
                   bind(C,name="C_MPI_Win_create")
            use iso_c_binding, only: c_int, c_size_t
            implicit none
!dir$ ignore_tkr base
            integer, dimension(*), intent(in), asynchronous :: base
            integer(kind=c_size_t), intent(in), value :: size
            integer(kind=c_int), intent(in), value :: disp_unit, info, comm
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine C_MPI_Win_create
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Win_create(base, size, disp_unit, info, comm, win, ierror) &
                   bind(C,name="CFI_MPI_Win_create")
            use iso_c_binding, only: c_int, c_size_t, c_ptr
            implicit none
            type(*), dimension(..), asynchronous :: base
            integer(kind=c_size_t), intent(in), value :: size
            integer(kind=c_int), intent(in), value :: disp_unit, info, comm
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine CFI_MPI_Win_create
    end interface
#endif

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
        subroutine C_MPI_Alloc_mem(size, info, baseptr, ierror) &
                   bind(C,name="C_MPI_Alloc_mem")
            use iso_c_binding, only: c_int, c_size_t, c_ptr
            implicit none
            integer(kind=c_size_t), intent(in), value :: size
            integer(kind=c_int), intent(in), value :: info
            type(c_ptr), intent(out) :: baseptr
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Alloc_mem
    end interface

    interface
        subroutine C_MPI_Free_mem(base, ierror) &
                   bind(C,name="C_MPI_Free_mem")
            use iso_c_binding, only: c_int
            implicit none
!dir$ ignore_tkr base
            integer, dimension(*), intent(in), asynchronous :: base
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Free_mem
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Free_mem(base, ierror) &
                   bind(C,name="CFI_MPI_Free_mem")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: base
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Free_mem
    end interface
#endif

end module mpi_win_c
