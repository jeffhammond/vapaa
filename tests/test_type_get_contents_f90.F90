program test_type_get_contents_f90
    use mpi
    implicit none

    integer :: ierr, errs

    errs = 0
    call MPI_Init(ierr)
    call require(ierr == MPI_SUCCESS, 'MPI_Init failed', errs)

    call check_vector_contents(errs)
    call check_f90_integer_contents(errs)

    call MPI_Finalize(ierr)
    call require(ierr == MPI_SUCCESS, 'MPI_Finalize failed', errs)

    if (errs == 0) print *, 'Test passed'

contains

    subroutine require(condition, message, errs)
        logical, intent(in) :: condition
        character(len=*), intent(in) :: message
        integer, intent(inout) :: errs
        if (.not. condition) then
            errs = errs + 1
            print *, trim(message)
        end if
    end subroutine require

    subroutine check_extra_datatypes_null(types, first_extra, last_extra, errs)
        integer, intent(in) :: types(:)
        integer, intent(in) :: first_extra, last_extra
        integer, intent(inout) :: errs
        integer :: i

        do i = first_extra, last_extra
            call require(types(i) == MPI_DATATYPE_NULL, &
                         'extra datatype slot was not MPI_DATATYPE_NULL', errs)
        end do
    end subroutine check_extra_datatypes_null

    subroutine check_same_type_size(actual, expected, message, errs)
        integer, intent(in) :: actual, expected
        character(len=*), intent(in) :: message
        integer, intent(inout) :: errs
        integer :: actual_size, expected_size, ierr

        call MPI_Type_size(actual, actual_size, ierr)
        call require(ierr == MPI_SUCCESS, 'MPI_Type_size(actual) failed', errs)
        call MPI_Type_size(expected, expected_size, ierr)
        call require(ierr == MPI_SUCCESS, 'MPI_Type_size(expected) failed', errs)
        call require(actual_size == expected_size, message, errs)
    end subroutine check_same_type_size

    subroutine check_vector_contents(errs)
        integer, intent(inout) :: errs
        integer :: dtype
        integer, allocatable :: ints(:), types(:), small_ints(:), small_types(:)
        integer(kind=MPI_ADDRESS_KIND), allocatable :: addrs(:), small_addrs(:)
        integer :: ierr, ni, na, nd, combiner
        integer :: max_i, max_a, max_d

        call MPI_Type_vector(10, 1, 30, MPI_DOUBLE_PRECISION, dtype, ierr)
        call require(ierr == MPI_SUCCESS, 'MPI_Type_vector failed', errs)

        call MPI_Type_get_envelope(dtype, ni, na, nd, combiner, ierr)
        call require(ierr == MPI_SUCCESS, 'MPI_Type_get_envelope(vector) failed', errs)
        call require(nd == 1, 'vector envelope should contain one datatype', errs)

        max_i = ni + 4
        max_a = na + 4
        max_d = nd + 4
        allocate(ints(max_i), addrs(max_a), types(max_d))
        call MPI_Type_get_contents(dtype, max_i, max_a, max_d, ints, addrs, types, ierr)
        call require(ierr == MPI_SUCCESS, 'MPI_Type_get_contents(vector oversized) failed', errs)
        call check_same_type_size(types(1), MPI_DOUBLE_PRECISION, &
                                  'vector contained datatype had unexpected size', errs)
        call check_extra_datatypes_null(types, nd + 1, max_d, errs)

        allocate(small_ints(max_i), small_addrs(max_a), small_types(0))
        call MPI_Type_get_contents(dtype, max_i, max_a, 0, small_ints, small_addrs, small_types, ierr)
        call require(ierr /= MPI_SUCCESS, 'undersized vector contents call unexpectedly succeeded', errs)

        deallocate(ints, addrs, types, small_ints, small_addrs, small_types)
        call MPI_Type_free(dtype, ierr)
        call require(ierr == MPI_SUCCESS, 'MPI_Type_free(vector) failed', errs)
    end subroutine check_vector_contents

    subroutine check_f90_integer_contents(errs)
        integer, intent(inout) :: errs
        integer :: dtype
        integer :: dummy_types(1)
        integer :: ierr, ni, na, nd, combiner
        integer :: ints(2)
        integer(kind=MPI_ADDRESS_KIND) :: addrs(1)

        call MPI_Type_create_f90_integer(9, dtype, ierr)
        call require(ierr == MPI_SUCCESS, 'MPI_Type_create_f90_integer failed', errs)

        call MPI_Type_get_envelope(dtype, ni, na, nd, combiner, ierr)
        call require(ierr == MPI_SUCCESS, 'MPI_Type_get_envelope(f90 integer) failed', errs)
        call require(ni == 1 .and. na == 0 .and. nd == 0, &
                     'f90 integer envelope had unexpected sizes', errs)
        call require(combiner == MPI_COMBINER_F90_INTEGER, &
                     'f90 integer envelope had unexpected combiner', errs)

        ints = -1
        call MPI_Type_get_contents(dtype, 2, 0, 0, ints, addrs, dummy_types, ierr)
        call require(ierr == MPI_SUCCESS, 'MPI_Type_get_contents(f90 integer) failed', errs)
        call require(ints(1) == 9, 'f90 integer contents did not return requested range', errs)
        call require(ints(2) == -1, 'unused f90 integer contents slot changed unexpectedly', errs)

        call MPI_Type_get_contents(dtype, 0, 0, 0, ints, addrs, dummy_types, ierr)
        call require(ierr /= MPI_SUCCESS, 'undersized f90 integer contents call unexpectedly succeeded', errs)
    end subroutine check_f90_integer_contents

end program test_type_get_contents_f90
