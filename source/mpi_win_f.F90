! SPDX-License-Identifier: MIT

module mpi_win_f
    use iso_c_binding, only: c_int
    implicit none

    !interface MPI_Win_allocate
    !    module procedure MPI_Win_allocate_f08
    !end interface MPI_Win_allocate

    interface MPI_Win_create
#ifdef HAVE_CFI
        module procedure MPI_Win_create_f08ts
#else
        module procedure MPI_Win_create_f08
#endif
    end interface MPI_Win_create

    interface MPI_Win_free
        module procedure MPI_Win_free_f08
    end interface MPI_Win_free

    contains

        subroutine MPI_Win_create_f08(base, size, disp_unit, info, comm,  win, ierror)
            use iso_c_binding, only: c_int, c_size_t
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Win, MPI_Info
            use mpi_win_c, only: C_MPI_Win_create
!dir$ ignore_tkr base
            integer, dimension(*), intent(in), asynchronous :: base
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
            integer, intent(in) :: disp_unit
            type(MPI_info), intent(in) :: info
            type(MPI_Win), intent(in) :: comm
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: disp_unit_c, ierror_c
            integer(kind=c_size_t) :: size_c
            size_c      = size
            disp_unit_c = disp_unit
            call C_MPI_Win_create(base, size, disp_unit, info % MPI_VAL, comm % MPI_VAL, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_create_f08

#ifdef HAVE_CFI
        subroutine MPI_Win_create_f08ts(base, size, disp_unit, info, comm,  win, ierror)
            use iso_c_binding, only: c_int, c_size_t
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Win, MPI_Info
            use mpi_comm_c, only: CFI_MPI_Win_create
            type(*), dimension(..), asynchronous :: base
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
            integer, intent(in) :: disp_unit
            type(MPI_info), intent(in) :: info
            type(MPI_Win), intent(in) :: comm
            type(MPI_Win), intent(out) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: disp_unit_c, ierror_c
            integer(kind=c_size_t) :: size_c
            size_c      = size
            disp_unit_c = disp_unit
            call CFI_MPI_Win_create(base, size, disp_unit, info % MPI_VAL, comm % MPI_VAL, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_create_f08
#endif

        subroutine MPI_Win_free_f08(comm, ierror)
            use mpi_handle_types, only: MPI_Win
            use mpi_win_c, only: C_MPI_Win_free
            type(MPI_Win), intent(inout) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Win_free(comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Win_free_f08

end module mpi_win_f
