! SPDX-License-Identifier: MIT

module mpi_win_c

    interface
        subroutine C_MPI_Win_allocate(size, disp_unit, info, comm, baseptr, win, ierror) &
                   bind(C,name="C_MPI_Win_allocate")
            use iso_c_binding, only: c_int, c_size_t, c_ptr
            implicit none
            integer(kind=c_size_t), intent(in) :: size
            integer(kind=c_int), intent(in) :: disp_unit, info, comm
            type(c_ptr), intent(out) :: baseptr
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine C_MPI_Win_allocate
    end interface

    interface
        subroutine C_MPI_Win_create(base, size, disp_unit, info, comm, win, ierror) &
                   bind(C,name="C_MPI_Win_create")
            use iso_c_binding, only: c_int, c_size_t, c_ptr
            implicit none
            type(c_ptr), intent(in) :: base
            integer(kind=c_size_t), intent(in) :: size
            integer(kind=c_int), intent(in) :: disp_unit, info, comm
            integer(kind=c_int), intent(out) :: win, ierror
        end subroutine C_MPI_Win_create
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

end module mpi_win_c
