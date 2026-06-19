! SPDX-License-Identifier: MIT

module mpi_missing_f
    use iso_c_binding, only: c_int, c_int64_t, c_intptr_t, c_ptr
    implicit none

    interface MPI_Aint_add
        module procedure MPI_Aint_add_f08
    end interface MPI_Aint_add

    interface MPI_Aint_diff
        module procedure MPI_Aint_diff_f08
    end interface MPI_Aint_diff

    interface MPI_Alloc_mem
        module procedure MPI_Alloc_mem_f08
    end interface MPI_Alloc_mem

    interface MPI_Get_count
        module procedure MPI_Get_count_f08
        module procedure MPI_Get_count_c_f08
    end interface MPI_Get_count

    interface MPI_Get_elements
        module procedure MPI_Get_elements_f08
        module procedure MPI_Get_elements_c_f08
    end interface MPI_Get_elements

    interface MPI_Get_elements_x
        module procedure MPI_Get_elements_x_f08
    end interface MPI_Get_elements_x

    interface MPI_Type_size_x
        module procedure MPI_Type_size_x_f08
    end interface MPI_Type_size_x

    interface MPI_Type_get_extent
        module procedure MPI_Type_get_extent_f08
    end interface MPI_Type_get_extent

    interface MPI_Type_get_extent_x
        module procedure MPI_Type_get_extent_x_f08
    end interface MPI_Type_get_extent_x

    interface MPI_Type_get_true_extent
        module procedure MPI_Type_get_true_extent_f08
    end interface MPI_Type_get_true_extent

    interface MPI_Type_get_true_extent_x
        module procedure MPI_Type_get_true_extent_x_f08
    end interface MPI_Type_get_true_extent_x

    interface MPI_Type_create_resized
        module procedure MPI_Type_create_resized_f08
    end interface MPI_Type_create_resized

    interface MPI_Type_create_hvector
        module procedure MPI_Type_create_hvector_f08
        module procedure MPI_Type_create_hvector_c_f08
    end interface MPI_Type_create_hvector

    interface MPI_Type_create_hindexed
        module procedure MPI_Type_create_hindexed_f08
        module procedure MPI_Type_create_hindexed_c_f08
    end interface MPI_Type_create_hindexed

    interface MPI_Type_create_hindexed_block
        module procedure MPI_Type_create_hindexed_block_f08
        module procedure MPI_Type_create_hindexed_block_c_f08
    end interface MPI_Type_create_hindexed_block

    interface MPI_Type_create_indexed_block
        module procedure MPI_Type_create_indexed_block_f08
        module procedure MPI_Type_create_indexed_block_c_f08
    end interface MPI_Type_create_indexed_block

    interface MPI_Type_indexed
        module procedure MPI_Type_indexed_f08
        module procedure MPI_Type_indexed_c_f08
    end interface MPI_Type_indexed

    interface MPI_Type_create_struct
        module procedure MPI_Type_create_struct_f08
        module procedure MPI_Type_create_struct_c_f08
    end interface MPI_Type_create_struct

    interface MPI_Type_create_darray
        module procedure MPI_Type_create_darray_f08
        module procedure MPI_Type_create_darray_c_f08
    end interface MPI_Type_create_darray

    interface MPI_Type_create_f90_integer
        module procedure MPI_Type_create_f90_integer_f08
    end interface MPI_Type_create_f90_integer

    interface MPI_Type_create_f90_real
        module procedure MPI_Type_create_f90_real_f08
    end interface MPI_Type_create_f90_real

    interface MPI_Type_create_f90_complex
        module procedure MPI_Type_create_f90_complex_f08
    end interface MPI_Type_create_f90_complex

    interface MPI_Type_get_envelope
        module procedure MPI_Type_get_envelope_f08
        module procedure MPI_Type_get_envelope_c_f08
    end interface MPI_Type_get_envelope

    interface MPI_Type_get_contents
        module procedure MPI_Type_get_contents_f08
        module procedure MPI_Type_get_contents_c_f08
    end interface MPI_Type_get_contents

    interface MPI_Type_match_size
        module procedure MPI_Type_match_size_f08
    end interface MPI_Type_match_size

    interface MPI_Type_get_value_index
        module procedure MPI_Type_get_value_index_f08
    end interface MPI_Type_get_value_index

    interface MPI_Type_delete_attr
        module procedure MPI_Type_delete_attr_f08
    end interface MPI_Type_delete_attr

    interface MPI_Type_free_keyval
        module procedure MPI_Type_free_keyval_f08
    end interface MPI_Type_free_keyval

    interface MPI_Type_get_attr
        module procedure MPI_Type_get_attr_f08
    end interface MPI_Type_get_attr

    interface MPI_Type_set_attr
        module procedure MPI_Type_set_attr_f08
    end interface MPI_Type_set_attr

#ifdef HAVE_CFI
    interface MPI_Get_address
        module procedure MPI_Get_address_f08ts
    end interface MPI_Get_address

    interface MPI_Free_mem
        module procedure MPI_Free_mem_f08ts
    end interface MPI_Free_mem
#endif

    contains

        function MPI_Aint_add_f08(base, disp) result(res)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_missing_c, only: VAPAA_MPI_Aint_add
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: base, disp
            integer(kind=MPI_ADDRESS_KIND) :: res
            res = VAPAA_MPI_Aint_add(base, disp)
        end function MPI_Aint_add_f08

        function MPI_Aint_diff_f08(addr1, addr2) result(res)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_missing_c, only: VAPAA_MPI_Aint_diff
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: addr1, addr2
            integer(kind=MPI_ADDRESS_KIND) :: res
            res = VAPAA_MPI_Aint_diff(addr1, addr2)
        end function MPI_Aint_diff_f08

#ifdef HAVE_CFI
        subroutine MPI_Get_address_f08ts(location, address, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_missing_c, only: VAPAA_MPI_Get_address
            type(*), dimension(..), asynchronous :: location
            integer(kind=MPI_ADDRESS_KIND), intent(out) :: address
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Get_address(location, address, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_address_f08ts
#endif

        subroutine MPI_Alloc_mem_f08(size, info, baseptr, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Info
            use mpi_missing_c, only: VAPAA_MPI_Alloc_mem
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: size
            type(MPI_Info), intent(in) :: info
            type(c_ptr), intent(out) :: baseptr
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Alloc_mem(size, info % MPI_VAL, baseptr, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Alloc_mem_f08

#ifdef HAVE_CFI
        subroutine MPI_Free_mem_f08ts(base, ierror)
            use mpi_missing_c, only: VAPAA_MPI_Free_mem
            type(*), dimension(..), intent(in), asynchronous :: base
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Free_mem(base, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Free_mem_f08ts
#endif

        subroutine MPI_Get_count_f08(status, datatype, count, ierror)
            use mpi_handle_types, only: MPI_Status, MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Get_count
            type(MPI_Status), intent(in), target :: status
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(out) :: count
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            call VAPAA_MPI_Get_count(status, datatype % MPI_VAL, count_c, ierror_c)
            count = count_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_count_f08

        subroutine MPI_Get_count_c_f08(status, datatype, count, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Status, MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Get_count_c
            type(MPI_Status), intent(in), target :: status
            type(MPI_Datatype), intent(in) :: datatype
            integer(kind=MPI_COUNT_KIND), intent(out) :: count
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Get_count_c(status, datatype % MPI_VAL, count, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_count_c_f08

        subroutine MPI_Get_elements_f08(status, datatype, count, ierror)
            use mpi_handle_types, only: MPI_Status, MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Get_elements
            type(MPI_Status), intent(in), target :: status
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(out) :: count
            integer, optional, intent(out) :: ierror
            integer(c_int) :: count_c, ierror_c
            call VAPAA_MPI_Get_elements(status, datatype % MPI_VAL, count_c, ierror_c)
            count = count_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_elements_f08

        subroutine MPI_Get_elements_c_f08(status, datatype, count, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Status, MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Get_elements_c
            type(MPI_Status), intent(in), target :: status
            type(MPI_Datatype), intent(in) :: datatype
            integer(kind=MPI_COUNT_KIND), intent(out) :: count
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Get_elements_c(status, datatype % MPI_VAL, count, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_elements_c_f08

        subroutine MPI_Get_elements_x_f08(status, datatype, count, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Status, MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Get_elements_x
            type(MPI_Status), intent(in), target :: status
            type(MPI_Datatype), intent(in) :: datatype
            integer(kind=MPI_COUNT_KIND), intent(out) :: count
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Get_elements_x(status, datatype % MPI_VAL, count, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_elements_x_f08

        subroutine MPI_Type_size_x_f08(datatype, size, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_size_x
            type(MPI_Datatype), intent(in) :: datatype
            integer(kind=MPI_COUNT_KIND), intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_size_x(datatype % MPI_VAL, size, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_size_x_f08

        subroutine MPI_Type_get_extent_f08(datatype, lb, extent, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_get_extent
            type(MPI_Datatype), intent(in) :: datatype
            integer(kind=MPI_ADDRESS_KIND), intent(out) :: lb, extent
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_get_extent(datatype % MPI_VAL, lb, extent, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_get_extent_f08

        subroutine MPI_Type_get_extent_x_f08(datatype, lb, extent, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_get_extent_x
            type(MPI_Datatype), intent(in) :: datatype
            integer(kind=MPI_COUNT_KIND), intent(out) :: lb, extent
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_get_extent_x(datatype % MPI_VAL, lb, extent, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_get_extent_x_f08

        subroutine MPI_Type_get_true_extent_f08(datatype, true_lb, true_extent, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_get_true_extent
            type(MPI_Datatype), intent(in) :: datatype
            integer(kind=MPI_ADDRESS_KIND), intent(out) :: true_lb, true_extent
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_get_true_extent(datatype % MPI_VAL, true_lb, true_extent, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_get_true_extent_f08

        subroutine MPI_Type_get_true_extent_x_f08(datatype, true_lb, true_extent, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_get_true_extent_x
            type(MPI_Datatype), intent(in) :: datatype
            integer(kind=MPI_COUNT_KIND), intent(out) :: true_lb, true_extent
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_get_true_extent_x(datatype % MPI_VAL, true_lb, true_extent, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_get_true_extent_x_f08

        subroutine MPI_Type_create_resized_f08(oldtype, lb, extent, newtype, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_resized
            type(MPI_Datatype), intent(in) :: oldtype
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: lb, extent
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_create_resized(oldtype % MPI_VAL, lb, extent, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_resized_f08

        subroutine MPI_Type_create_hvector_f08(count, blocklength, stride, oldtype, newtype, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_hvector
            integer, intent(in) :: count, blocklength
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: stride
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_create_hvector(int(count,c_int), int(blocklength,c_int), stride, &
                                               oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_hvector_f08

        subroutine MPI_Type_create_hvector_c_f08(count, blocklength, stride, oldtype, newtype, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_hvector_c
            integer(kind=MPI_COUNT_KIND), intent(in) :: count, blocklength, stride
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_create_hvector_c(count, blocklength, stride, oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_hvector_c_f08

        subroutine MPI_Type_create_hindexed_f08(count, array_of_blocklengths, array_of_displacements, oldtype, newtype, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_hindexed
            integer, intent(in) :: count
            integer, intent(in) :: array_of_blocklengths(count)
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: array_of_displacements(count)
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: blocklengths_c(count), ierror_c
            blocklengths_c = array_of_blocklengths
            call VAPAA_MPI_Type_create_hindexed(int(count,c_int), blocklengths_c, array_of_displacements, &
                                                oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_hindexed_f08

        subroutine MPI_Type_create_hindexed_c_f08(count, array_of_blocklengths, array_of_displacements, oldtype, newtype, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_hindexed_c
            integer(kind=MPI_COUNT_KIND), intent(in) :: count
            integer(kind=MPI_COUNT_KIND), intent(in) :: array_of_blocklengths(count), array_of_displacements(count)
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_create_hindexed_c(count, array_of_blocklengths, array_of_displacements, &
                                                  oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_hindexed_c_f08

        subroutine MPI_Type_create_hindexed_block_f08(count, blocklength, array_of_displacements, oldtype, newtype, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_hindexed_block
            integer, intent(in) :: count, blocklength
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: array_of_displacements(count)
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_create_hindexed_block(int(count,c_int), int(blocklength,c_int), array_of_displacements, &
                                                      oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_hindexed_block_f08

        subroutine MPI_Type_create_hindexed_block_c_f08(count, blocklength, array_of_displacements, oldtype, newtype, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_hindexed_block_c
            integer(kind=MPI_COUNT_KIND), intent(in) :: count, blocklength
            integer(kind=MPI_COUNT_KIND), intent(in) :: array_of_displacements(count)
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_create_hindexed_block_c(count, blocklength, array_of_displacements, &
                                                        oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_hindexed_block_c_f08

        subroutine MPI_Type_create_indexed_block_f08(count, blocklength, array_of_displacements, oldtype, newtype, ierror)
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_indexed_block
            integer, intent(in) :: count, blocklength
            integer, intent(in) :: array_of_displacements(count)
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: displacements_c(count), ierror_c
            displacements_c = array_of_displacements
            call VAPAA_MPI_Type_create_indexed_block(int(count,c_int), int(blocklength,c_int), displacements_c, &
                                                     oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_indexed_block_f08

        subroutine MPI_Type_create_indexed_block_c_f08(count, blocklength, array_of_displacements, oldtype, newtype, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_indexed_block_c
            integer(kind=MPI_COUNT_KIND), intent(in) :: count, blocklength
            integer(kind=MPI_COUNT_KIND), intent(in) :: array_of_displacements(count)
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_create_indexed_block_c(count, blocklength, array_of_displacements, &
                                                       oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_indexed_block_c_f08

        subroutine MPI_Type_indexed_f08(count, array_of_blocklengths, array_of_displacements, oldtype, newtype, ierror)
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_indexed
            integer, intent(in) :: count
            integer, intent(in) :: array_of_blocklengths(count), array_of_displacements(count)
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: blocklengths_c(count), displacements_c(count), ierror_c
            blocklengths_c = array_of_blocklengths
            displacements_c = array_of_displacements
            call VAPAA_MPI_Type_indexed(int(count,c_int), blocklengths_c, displacements_c, &
                                        oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_indexed_f08

        subroutine MPI_Type_indexed_c_f08(count, array_of_blocklengths, array_of_displacements, oldtype, newtype, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_indexed_c
            integer(kind=MPI_COUNT_KIND), intent(in) :: count
            integer(kind=MPI_COUNT_KIND), intent(in) :: array_of_blocklengths(count), array_of_displacements(count)
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_indexed_c(count, array_of_blocklengths, array_of_displacements, &
                                          oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_indexed_c_f08

        subroutine MPI_Type_create_struct_f08(count, array_of_blocklengths, array_of_displacements, array_of_types, newtype, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_struct
            integer, intent(in) :: count
            integer, intent(in) :: array_of_blocklengths(count)
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: array_of_displacements(count)
            type(MPI_Datatype), intent(in) :: array_of_types(count)
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: blocklengths_c(count), types_c(count), ierror_c
            integer :: i
            blocklengths_c = array_of_blocklengths
            do i = 1, count
                types_c(i) = array_of_types(i) % MPI_VAL
            end do
            call VAPAA_MPI_Type_create_struct(int(count,c_int), blocklengths_c, array_of_displacements, &
                                              types_c, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_struct_f08

        subroutine MPI_Type_create_struct_c_f08(count, array_of_blocklengths, array_of_displacements, &
                                                array_of_types, newtype, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_struct_c
            integer(kind=MPI_COUNT_KIND), intent(in) :: count
            integer(kind=MPI_COUNT_KIND), intent(in) :: array_of_blocklengths(count), array_of_displacements(count)
            type(MPI_Datatype), intent(in) :: array_of_types(count)
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: types_c(count), ierror_c
            integer :: i
            do i = 1, int(count)
                types_c(i) = array_of_types(i) % MPI_VAL
            end do
            call VAPAA_MPI_Type_create_struct_c(count, array_of_blocklengths, array_of_displacements, &
                                                types_c, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_struct_c_f08

        subroutine MPI_Type_create_darray_f08(size, rank, ndims, array_of_gsizes, array_of_distribs, &
                                              array_of_dargs, array_of_psizes, order, oldtype, newtype, ierror)
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_darray
            integer, intent(in) :: size, rank, ndims, order
            integer, intent(in) :: array_of_gsizes(ndims), array_of_distribs(ndims), array_of_dargs(ndims), array_of_psizes(ndims)
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: gsizes_c(ndims), distribs_c(ndims), dargs_c(ndims), psizes_c(ndims), ierror_c
            gsizes_c = array_of_gsizes
            distribs_c = array_of_distribs
            dargs_c = array_of_dargs
            psizes_c = array_of_psizes
            call VAPAA_MPI_Type_create_darray(int(size,c_int), int(rank,c_int), int(ndims,c_int), gsizes_c, distribs_c, &
                                              dargs_c, psizes_c, int(order,c_int), oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_darray_f08

        subroutine MPI_Type_create_darray_c_f08(size, rank, ndims, array_of_gsizes, array_of_distribs, &
                                                array_of_dargs, array_of_psizes, order, oldtype, newtype, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_darray_c
            integer, intent(in) :: size, rank, ndims, order
            integer(kind=MPI_COUNT_KIND), intent(in) :: array_of_gsizes(ndims)
            integer, intent(in) :: array_of_distribs(ndims), array_of_dargs(ndims), array_of_psizes(ndims)
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: distribs_c(ndims), dargs_c(ndims), psizes_c(ndims), ierror_c
            distribs_c = array_of_distribs
            dargs_c = array_of_dargs
            psizes_c = array_of_psizes
            call VAPAA_MPI_Type_create_darray_c(int(size,c_int), int(rank,c_int), int(ndims,c_int), array_of_gsizes, &
                                                distribs_c, dargs_c, psizes_c, int(order,c_int), &
                                                oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_darray_c_f08

        subroutine MPI_Type_create_f90_integer_f08(r, newtype, ierror)
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_f90_integer
            integer, intent(in) :: r
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_create_f90_integer(int(r,c_int), newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_f90_integer_f08

        subroutine MPI_Type_create_f90_real_f08(p, r, newtype, ierror)
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_f90_real
            integer, intent(in) :: p, r
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_create_f90_real(int(p,c_int), int(r,c_int), newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_f90_real_f08

        subroutine MPI_Type_create_f90_complex_f08(p, r, newtype, ierror)
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_create_f90_complex
            integer, intent(in) :: p, r
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_create_f90_complex(int(p,c_int), int(r,c_int), newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_f90_complex_f08

        subroutine MPI_Type_get_envelope_f08(datatype, num_integers, num_addresses, num_datatypes, combiner, ierror)
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_get_envelope
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(out) :: num_integers, num_addresses, num_datatypes, combiner
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ni_c, na_c, nd_c, combiner_c, ierror_c
            call VAPAA_MPI_Type_get_envelope(datatype % MPI_VAL, ni_c, na_c, nd_c, combiner_c, ierror_c)
            num_integers = ni_c
            num_addresses = na_c
            num_datatypes = nd_c
            combiner = combiner_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_get_envelope_f08

        subroutine MPI_Type_get_envelope_c_f08(datatype, num_integers, num_addresses, num_large_counts, &
                                               num_datatypes, combiner, ierror)
            use mpi_global_constants, only: MPI_COUNT_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_get_envelope_c
            type(MPI_Datatype), intent(in) :: datatype
            integer(kind=MPI_COUNT_KIND), intent(out) :: num_integers, num_addresses, num_large_counts, num_datatypes
            integer, intent(out) :: combiner
            integer, optional, intent(out) :: ierror
            integer(c_int) :: combiner_c, ierror_c
            call VAPAA_MPI_Type_get_envelope_c(datatype % MPI_VAL, num_integers, num_addresses, num_large_counts, &
                                               num_datatypes, combiner_c, ierror_c)
            combiner = combiner_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_get_envelope_c_f08

        subroutine MPI_Type_get_contents_f08(datatype, max_integers, max_addresses, max_datatypes, &
                                             array_of_integers, array_of_addresses, array_of_datatypes, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND, MPI_DATATYPE_NULL
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_get_contents
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(in) :: max_integers, max_addresses, max_datatypes
            integer, intent(out) :: array_of_integers(max_integers)
            integer(kind=MPI_ADDRESS_KIND), intent(out) :: array_of_addresses(max_addresses)
            type(MPI_Datatype), intent(out) :: array_of_datatypes(max_datatypes)
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ints_c(max_integers), types_c(max_datatypes), ierror_c
            integer(kind=MPI_ADDRESS_KIND) :: addrs_c(max_addresses)
            integer :: i
            array_of_integers = 0
            array_of_addresses = 0_MPI_ADDRESS_KIND
            ints_c = 0_c_int
            addrs_c = 0_MPI_ADDRESS_KIND
            types_c = MPI_DATATYPE_NULL % MPI_VAL
            do i = 1, max_datatypes
                array_of_datatypes(i) % MPI_VAL = MPI_DATATYPE_NULL % MPI_VAL
            end do
            call VAPAA_MPI_Type_get_contents(datatype % MPI_VAL, int(max_integers,c_int), int(max_addresses,c_int), &
                                             int(max_datatypes,c_int), ints_c, addrs_c, types_c, ierror_c)
            if (ierror_c == 0_c_int) then
                array_of_integers = ints_c
                array_of_addresses = addrs_c
                do i = 1, max_datatypes
                    array_of_datatypes(i) % MPI_VAL = types_c(i)
                end do
            end if
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_get_contents_f08

        subroutine MPI_Type_get_contents_c_f08(datatype, max_integers, max_addresses, max_large_counts, &
                                               max_datatypes, array_of_integers, array_of_addresses, &
                                               array_of_large_counts, array_of_datatypes, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND, MPI_COUNT_KIND, MPI_DATATYPE_NULL
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_get_contents_c
            type(MPI_Datatype), intent(in) :: datatype
            integer(kind=MPI_COUNT_KIND), intent(in) :: max_integers, max_addresses, max_large_counts, max_datatypes
            integer, intent(out) :: array_of_integers(max_integers)
            integer(kind=MPI_ADDRESS_KIND), intent(out) :: array_of_addresses(max_addresses)
            integer(kind=MPI_COUNT_KIND), intent(out) :: array_of_large_counts(max_large_counts)
            type(MPI_Datatype), intent(out) :: array_of_datatypes(max_datatypes)
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ints_c(max_integers), types_c(max_datatypes), ierror_c
            integer(kind=MPI_ADDRESS_KIND) :: addrs_c(max_addresses)
            integer(kind=MPI_COUNT_KIND) :: counts_c(max_large_counts)
            integer(kind=MPI_COUNT_KIND) :: i
            array_of_integers = 0
            array_of_addresses = 0_MPI_ADDRESS_KIND
            array_of_large_counts = 0_MPI_COUNT_KIND
            ints_c = 0_c_int
            addrs_c = 0_MPI_ADDRESS_KIND
            counts_c = 0_MPI_COUNT_KIND
            types_c = MPI_DATATYPE_NULL % MPI_VAL
            do i = 1_MPI_COUNT_KIND, max_datatypes
                array_of_datatypes(i) % MPI_VAL = MPI_DATATYPE_NULL % MPI_VAL
            end do
            call VAPAA_MPI_Type_get_contents_c(datatype % MPI_VAL, max_integers, max_addresses, max_large_counts, max_datatypes, &
                                               ints_c, addrs_c, counts_c, types_c, ierror_c)
            if (ierror_c == 0_c_int) then
                array_of_integers = ints_c
                array_of_addresses = addrs_c
                array_of_large_counts = counts_c
                do i = 1_MPI_COUNT_KIND, max_datatypes
                    array_of_datatypes(i) % MPI_VAL = types_c(i)
                end do
            end if
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_get_contents_c_f08

        subroutine MPI_Type_match_size_f08(typeclass, size, datatype, ierror)
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_match_size
            integer, intent(in) :: typeclass, size
            type(MPI_Datatype), intent(out) :: datatype
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_match_size(int(typeclass,c_int), int(size,c_int), datatype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_match_size_f08

        subroutine MPI_Type_get_value_index_f08(value_type, index_type, pair_type, ierror)
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_get_value_index
            type(MPI_Datatype), intent(in) :: value_type, index_type
            type(MPI_Datatype), intent(out) :: pair_type
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_get_value_index(value_type % MPI_VAL, index_type % MPI_VAL, pair_type % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_get_value_index_f08

        subroutine MPI_Type_delete_attr_f08(datatype, type_keyval, ierror)
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_delete_attr
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(in) :: type_keyval
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_delete_attr(datatype % MPI_VAL, int(type_keyval,c_int), ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_delete_attr_f08

        subroutine MPI_Type_free_keyval_f08(type_keyval, ierror)
            use mpi_missing_c, only: VAPAA_MPI_Type_free_keyval
#ifdef HAVE_PGIF
            use mpi_direct_callback_f, only: VAPAA_PGIF_Type_keyval_release
#endif
            integer, intent(inout) :: type_keyval
            integer, optional, intent(out) :: ierror
            integer(c_int) :: keyval_c, old_keyval_c, ierror_c
            keyval_c = type_keyval
            old_keyval_c = keyval_c
            call VAPAA_MPI_Type_free_keyval(keyval_c, ierror_c)
#ifdef HAVE_PGIF
            if (ierror_c == 0_c_int) call VAPAA_PGIF_Type_keyval_release(int(old_keyval_c))
#endif
            type_keyval = keyval_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_free_keyval_f08

        subroutine MPI_Type_get_attr_f08(datatype, type_keyval, attribute_val, flag, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_get_attr
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(in) :: type_keyval
            integer(kind=MPI_ADDRESS_KIND), intent(out) :: attribute_val
            logical, intent(out) :: flag
            integer, optional, intent(out) :: ierror
            integer(c_int) :: flag_c, ierror_c
            call VAPAA_MPI_Type_get_attr(datatype % MPI_VAL, int(type_keyval,c_int), attribute_val, flag_c, ierror_c)
            flag = flag_c /= 0
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_get_attr_f08

        subroutine MPI_Type_set_attr_f08(datatype, type_keyval, attribute_val, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_missing_c, only: VAPAA_MPI_Type_set_attr
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(in) :: type_keyval
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: attribute_val
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Type_set_attr(datatype % MPI_VAL, int(type_keyval,c_int), attribute_val, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_set_attr_f08

end module mpi_missing_f
