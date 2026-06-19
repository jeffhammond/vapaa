! SPDX-License-Identifier: MIT

module mpi_f90_misc
    use iso_c_binding, only: c_int
    implicit none
    private

    public :: MPI_Get_address
    public :: MPI_Get_elements
    public :: MPI_Alloc_mem
    public :: MPI_Free_mem
    public :: MPI_Sizeof

    interface MPI_Get_address
        module procedure MPI_Get_address_f90
    end interface
    interface MPI_Get_elements
        module procedure MPI_Get_elements_f90
    end interface
    interface MPI_Alloc_mem
        module procedure MPI_Alloc_mem_f90
    end interface
    interface MPI_Free_mem
        module procedure MPI_Free_mem_f90
    end interface
    interface MPI_Sizeof
        module procedure MPI_Sizeof_i_scalar_f90
        module procedure MPI_Sizeof_i_rank1_f90
        module procedure MPI_Sizeof_r_scalar_f90
        module procedure MPI_Sizeof_r_rank1_f90
        module procedure MPI_Sizeof_d_scalar_f90
        module procedure MPI_Sizeof_d_rank1_f90
        module procedure MPI_Sizeof_c_scalar_f90
        module procedure MPI_Sizeof_c_rank1_f90
        module procedure MPI_Sizeof_ch_scalar_f90
        module procedure MPI_Sizeof_ch_rank1_f90
        module procedure MPI_Sizeof_l_scalar_f90
        module procedure MPI_Sizeof_l_rank1_f90
    end interface

contains

    subroutine MPI_Get_address_f90(location, address, ierror)
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
#ifdef HAVE_CFI
        use mpi_missing_c, only: VAPAA_MPI_Get_address
#else
        use mpi_missing_c, only: VAPAA_MPI_Get_address_nocfi
#endif
        use mpi_f90_util, only: f90_finish_ierror
#ifdef HAVE_CFI
        type(*), dimension(..), asynchronous :: location
#else
!dir$ ignore_tkr location
        integer, dimension(*), asynchronous :: location
#endif
        integer(kind=MPI_ADDRESS_KIND), intent(out) :: address
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
#ifdef HAVE_CFI
        call VAPAA_MPI_Get_address(location, address, ierror_c)
#else
        call VAPAA_MPI_Get_address_nocfi(location, address, ierror_c)
#endif
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Get_address_f90

    subroutine MPI_Get_elements_f90(status, datatype, count, ierror)
        use mpi_f90_constants, only: MPI_STATUS_SIZE
        use mpi_f90_status, only: mpi_f90_status_to_f08
        use mpi_f90_util, only: f90_finish_ierror
        use mpi_handle_types, only: MPI_Status
        use mpi_missing_c, only: VAPAA_MPI_Get_elements
        integer, intent(in) :: status(MPI_STATUS_SIZE)
        integer, intent(in) :: datatype
        integer, intent(out) :: count
        integer, optional, intent(out) :: ierror
        type(MPI_Status) :: status_f08
        integer(c_int) :: count_c, ierror_c
        call mpi_f90_status_to_f08(status, status_f08)
        call VAPAA_MPI_Get_elements(status_f08, int(datatype,c_int), count_c, ierror_c)
        count = count_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Get_elements_f90

    subroutine MPI_Alloc_mem_f90(size, info, baseptr, ierror)
        use iso_c_binding, only: c_ptr
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_missing_c, only: VAPAA_MPI_Alloc_mem
        use mpi_f90_util, only: f90_finish_ierror
        integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
        integer, intent(in) :: info
        type(c_ptr), intent(out) :: baseptr
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
        call VAPAA_MPI_Alloc_mem(size, int(info,c_int), baseptr, ierror_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Alloc_mem_f90

    subroutine MPI_Free_mem_f90(base, ierror)
#ifdef HAVE_CFI
        use mpi_missing_c, only: VAPAA_MPI_Free_mem
#else
        use mpi_missing_c, only: VAPAA_MPI_Free_mem_nocfi
#endif
        use mpi_f90_util, only: f90_finish_ierror
#ifdef HAVE_CFI
        type(*), dimension(..), intent(in), asynchronous :: base
#else
!dir$ ignore_tkr base
        integer, dimension(*), intent(in), asynchronous :: base
#endif
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
#ifdef HAVE_CFI
        call VAPAA_MPI_Free_mem(base, ierror_c)
#else
        call VAPAA_MPI_Free_mem_nocfi(base, ierror_c)
#endif
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Free_mem_f90

    subroutine finish_sizeof(size, ierror, bytes)
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        integer, intent(in) :: bytes
        size = bytes
        call f90_finish_ierror(ierror, 0_c_int)
    end subroutine finish_sizeof

    subroutine MPI_Sizeof_i_scalar_f90(x, size, ierror)
        integer, intent(in) :: x
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        call finish_sizeof(size, ierror, storage_size(x) / 8)
    end subroutine MPI_Sizeof_i_scalar_f90

    subroutine MPI_Sizeof_i_rank1_f90(x, size, ierror)
        integer, intent(in) :: x(:)
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        call finish_sizeof(size, ierror, storage_size(x) / 8)
    end subroutine MPI_Sizeof_i_rank1_f90

    subroutine MPI_Sizeof_r_scalar_f90(x, size, ierror)
        real, intent(in) :: x
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        call finish_sizeof(size, ierror, storage_size(x) / 8)
    end subroutine MPI_Sizeof_r_scalar_f90

    subroutine MPI_Sizeof_r_rank1_f90(x, size, ierror)
        real, intent(in) :: x(:)
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        call finish_sizeof(size, ierror, storage_size(x) / 8)
    end subroutine MPI_Sizeof_r_rank1_f90

    subroutine MPI_Sizeof_d_scalar_f90(x, size, ierror)
        double precision, intent(in) :: x
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        call finish_sizeof(size, ierror, storage_size(x) / 8)
    end subroutine MPI_Sizeof_d_scalar_f90

    subroutine MPI_Sizeof_d_rank1_f90(x, size, ierror)
        double precision, intent(in) :: x(:)
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        call finish_sizeof(size, ierror, storage_size(x) / 8)
    end subroutine MPI_Sizeof_d_rank1_f90

    subroutine MPI_Sizeof_c_scalar_f90(x, size, ierror)
        complex, intent(in) :: x
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        call finish_sizeof(size, ierror, storage_size(x) / 8)
    end subroutine MPI_Sizeof_c_scalar_f90

    subroutine MPI_Sizeof_c_rank1_f90(x, size, ierror)
        complex, intent(in) :: x(:)
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        call finish_sizeof(size, ierror, storage_size(x) / 8)
    end subroutine MPI_Sizeof_c_rank1_f90

    subroutine MPI_Sizeof_ch_scalar_f90(x, size, ierror)
        character(len=*), intent(in) :: x
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        call finish_sizeof(size, ierror, storage_size(x) / 8)
    end subroutine MPI_Sizeof_ch_scalar_f90

    subroutine MPI_Sizeof_ch_rank1_f90(x, size, ierror)
        character(len=*), intent(in) :: x(:)
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        call finish_sizeof(size, ierror, storage_size(x) / 8)
    end subroutine MPI_Sizeof_ch_rank1_f90

    subroutine MPI_Sizeof_l_scalar_f90(x, size, ierror)
        logical, intent(in) :: x
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        call finish_sizeof(size, ierror, storage_size(x) / 8)
    end subroutine MPI_Sizeof_l_scalar_f90

    subroutine MPI_Sizeof_l_rank1_f90(x, size, ierror)
        logical, intent(in) :: x(:)
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        call finish_sizeof(size, ierror, storage_size(x) / 8)
    end subroutine MPI_Sizeof_l_rank1_f90

end module mpi_f90_misc
