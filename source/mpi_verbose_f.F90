! SPDX-License-Identifier: MIT

module mpi_verbose_f
    use iso_c_binding, only: c_char, c_int, c_null_char
    implicit none
    private

    public :: VAPAA_VERBOSE_INIT

contains

    subroutine VAPAA_VERBOSE_INIT(binding)
        use iso_fortran_env, only: compiler_options, compiler_version
        use mpi_core_c, only: C_MPI_Verbose_init
        character(len=*), intent(in) :: binding
        character(kind=c_char), allocatable :: binding_c(:), compiler_version_c(:)
        character(kind=c_char), allocatable :: compiler_options_c(:)
        integer(c_int) :: logical_size_c, integer_size_c, real_size_c
        integer(c_int) :: double_precision_size_c

        call make_c_string(binding, binding_c)
        call make_c_string(compiler_version(), compiler_version_c)
        call make_c_string(compiler_options(), compiler_options_c)

        logical_size_c = storage_size(.true.) / 8
        integer_size_c = storage_size(0) / 8
        real_size_c = storage_size(0.0) / 8
        double_precision_size_c = storage_size(0.0d0) / 8

        call C_MPI_Verbose_init(binding_c, compiler_version_c, compiler_options_c, &
                                logical_size_c, integer_size_c, real_size_c, &
                                double_precision_size_c)
    end subroutine VAPAA_VERBOSE_INIT

    subroutine make_c_string(fortran_string, c_string)
        character(len=*), intent(in) :: fortran_string
        character(kind=c_char), allocatable, intent(out) :: c_string(:)
        integer :: i, n

        n = len_trim(fortran_string)
        allocate(c_string(n + 1))
        do i = 1, n
            c_string(i) = fortran_string(i:i)
        end do
        c_string(n + 1) = c_null_char
    end subroutine make_c_string

end module mpi_verbose_f
