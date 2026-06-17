! SPDX-License-Identifier: MIT

module mpi_missing_c
    use iso_c_binding, only: c_int, c_int64_t, c_intptr_t, c_ptr
    use mpi_handle_types, only: MPI_Status
    implicit none

    interface
        function VAPAA_MPI_Aint_add(base, disp) result(res) &
                 bind(C,name="VAPAA_MPI_Aint_add")
            use iso_c_binding, only: c_intptr_t
            implicit none
            integer(kind=c_intptr_t), value :: base, disp
            integer(kind=c_intptr_t) :: res
        end function VAPAA_MPI_Aint_add

        function VAPAA_MPI_Aint_diff(addr1, addr2) result(res) &
                 bind(C,name="VAPAA_MPI_Aint_diff")
            use iso_c_binding, only: c_intptr_t
            implicit none
            integer(kind=c_intptr_t), value :: addr1, addr2
            integer(kind=c_intptr_t) :: res
        end function VAPAA_MPI_Aint_diff
    end interface

#ifdef HAVE_CFI
    interface
        subroutine VAPAA_MPI_Get_address(location, address, ierror) &
                   bind(C,name="VAPAA_MPI_Get_address")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), asynchronous :: location
            integer(kind=c_intptr_t), intent(out) :: address
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Get_address

        subroutine VAPAA_MPI_Free_mem(base, ierror) &
                   bind(C,name="VAPAA_MPI_Free_mem")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in), asynchronous :: base
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Free_mem
    end interface
#endif

    interface
        subroutine VAPAA_MPI_Alloc_mem(size, info, baseptr, ierror) &
                   bind(C,name="VAPAA_MPI_Alloc_mem")
            use iso_c_binding, only: c_int, c_intptr_t, c_ptr
            implicit none
            integer(kind=c_intptr_t), intent(in) :: size
            integer(kind=c_int), intent(in) :: info
            type(c_ptr), intent(out) :: baseptr
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Alloc_mem

        subroutine VAPAA_MPI_Get_count(status, datatype, count, ierror) &
                   bind(C,name="VAPAA_MPI_Get_count")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(in) :: status
            integer(kind=c_int), intent(in) :: datatype
            integer(kind=c_int), intent(out) :: count
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Get_count

        subroutine VAPAA_MPI_Get_count_c(status, datatype, count, ierror) &
                   bind(C,name="VAPAA_MPI_Get_count_c")
            use iso_c_binding, only: c_int, c_int64_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(in) :: status
            integer(kind=c_int), intent(in) :: datatype
            integer(kind=c_int64_t), intent(out) :: count
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Get_count_c

        subroutine VAPAA_MPI_Get_elements(status, datatype, count, ierror) &
                   bind(C,name="VAPAA_MPI_Get_elements")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(in) :: status
            integer(kind=c_int), intent(in) :: datatype
            integer(kind=c_int), intent(out) :: count
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Get_elements

        subroutine VAPAA_MPI_Get_elements_c(status, datatype, count, ierror) &
                   bind(C,name="VAPAA_MPI_Get_elements_c")
            use iso_c_binding, only: c_int, c_int64_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(in) :: status
            integer(kind=c_int), intent(in) :: datatype
            integer(kind=c_int64_t), intent(out) :: count
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Get_elements_c

        subroutine VAPAA_MPI_Get_elements_x(status, datatype, count, ierror) &
                   bind(C,name="VAPAA_MPI_Get_elements_x")
            use iso_c_binding, only: c_int, c_int64_t
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(MPI_Status), intent(in) :: status
            integer(kind=c_int), intent(in) :: datatype
            integer(kind=c_int64_t), intent(out) :: count
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Get_elements_x

        subroutine VAPAA_MPI_Type_size_x(datatype, size, ierror) &
                   bind(C,name="VAPAA_MPI_Type_size_x")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            integer(kind=c_int64_t), intent(out) :: size
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Type_size_x

        subroutine VAPAA_MPI_Type_get_extent(datatype, lb, extent, ierror) &
                   bind(C,name="VAPAA_MPI_Type_get_extent")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            integer(kind=c_intptr_t), intent(out) :: lb, extent
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Type_get_extent

        subroutine VAPAA_MPI_Type_get_extent_x(datatype, lb, extent, ierror) &
                   bind(C,name="VAPAA_MPI_Type_get_extent_x")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            integer(kind=c_int64_t), intent(out) :: lb, extent
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Type_get_extent_x

        subroutine VAPAA_MPI_Type_get_true_extent(datatype, lb, extent, ierror) &
                   bind(C,name="VAPAA_MPI_Type_get_true_extent")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            integer(kind=c_intptr_t), intent(out) :: lb, extent
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Type_get_true_extent

        subroutine VAPAA_MPI_Type_get_true_extent_x(datatype, lb, extent, ierror) &
                   bind(C,name="VAPAA_MPI_Type_get_true_extent_x")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            integer(kind=c_int64_t), intent(out) :: lb, extent
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Type_get_true_extent_x

        subroutine VAPAA_MPI_Type_create_resized(oldtype, lb, extent, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_resized")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: oldtype
            integer(kind=c_intptr_t), intent(in) :: lb, extent
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_resized

        subroutine VAPAA_MPI_Type_create_hvector(count, blocklength, stride, oldtype, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_hvector")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: count, blocklength, oldtype
            integer(kind=c_intptr_t), intent(in) :: stride
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_hvector

        subroutine VAPAA_MPI_Type_create_hvector_c(count, blocklength, stride, oldtype, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_hvector_c")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int64_t), intent(in) :: count, blocklength, stride
            integer(kind=c_int), intent(in) :: oldtype
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_hvector_c

        subroutine VAPAA_MPI_Type_create_hindexed(count, blocklengths, displacements, oldtype, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_hindexed")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: count, oldtype
            integer(kind=c_int), intent(in), dimension(*) :: blocklengths
            integer(kind=c_intptr_t), intent(in), dimension(*) :: displacements
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_hindexed

        subroutine VAPAA_MPI_Type_create_hindexed_c(count, blocklengths, displacements, oldtype, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_hindexed_c")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int64_t), intent(in) :: count
            integer(kind=c_int64_t), intent(in), dimension(*) :: blocklengths, displacements
            integer(kind=c_int), intent(in) :: oldtype
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_hindexed_c

        subroutine VAPAA_MPI_Type_create_hindexed_block(count, blocklength, displacements, oldtype, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_hindexed_block")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: count, blocklength, oldtype
            integer(kind=c_intptr_t), intent(in), dimension(*) :: displacements
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_hindexed_block

        subroutine VAPAA_MPI_Type_create_hindexed_block_c(count, blocklength, displacements, oldtype, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_hindexed_block_c")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int64_t), intent(in) :: count, blocklength
            integer(kind=c_int64_t), intent(in), dimension(*) :: displacements
            integer(kind=c_int), intent(in) :: oldtype
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_hindexed_block_c

        subroutine VAPAA_MPI_Type_create_indexed_block(count, blocklength, displacements, oldtype, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_indexed_block")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: count, blocklength, oldtype
            integer(kind=c_int), intent(in), dimension(*) :: displacements
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_indexed_block

        subroutine VAPAA_MPI_Type_create_indexed_block_c(count, blocklength, displacements, oldtype, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_indexed_block_c")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int64_t), intent(in) :: count, blocklength
            integer(kind=c_int64_t), intent(in), dimension(*) :: displacements
            integer(kind=c_int), intent(in) :: oldtype
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_indexed_block_c

        subroutine VAPAA_MPI_Type_indexed(count, blocklengths, displacements, oldtype, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_indexed")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: count, oldtype
            integer(kind=c_int), intent(in), dimension(*) :: blocklengths, displacements
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_indexed

        subroutine VAPAA_MPI_Type_indexed_c(count, blocklengths, displacements, oldtype, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_indexed_c")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int64_t), intent(in) :: count
            integer(kind=c_int64_t), intent(in), dimension(*) :: blocklengths, displacements
            integer(kind=c_int), intent(in) :: oldtype
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_indexed_c

        subroutine VAPAA_MPI_Type_create_struct(count, blocklengths, displacements, datatypes, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_struct")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: count
            integer(kind=c_int), intent(in), dimension(*) :: blocklengths, datatypes
            integer(kind=c_intptr_t), intent(in), dimension(*) :: displacements
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_struct

        subroutine VAPAA_MPI_Type_create_struct_c(count, blocklengths, displacements, datatypes, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_struct_c")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int64_t), intent(in) :: count
            integer(kind=c_int64_t), intent(in), dimension(*) :: blocklengths, displacements
            integer(kind=c_int), intent(in), dimension(*) :: datatypes
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_struct_c

        subroutine VAPAA_MPI_Type_create_darray(size, rank, ndims, gsizes, distribs, dargs, psizes, &
                                                order, oldtype, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_darray")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: size, rank, ndims, order, oldtype
            integer(kind=c_int), intent(in), dimension(*) :: gsizes, distribs, dargs, psizes
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_darray

        subroutine VAPAA_MPI_Type_create_darray_c(size, rank, ndims, gsizes, distribs, dargs, psizes, &
                                                  order, oldtype, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_darray_c")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), intent(in) :: size, rank, ndims, order, oldtype
            integer(kind=c_int64_t), intent(in), dimension(*) :: gsizes
            integer(kind=c_int), intent(in), dimension(*) :: distribs, dargs, psizes
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_darray_c

        subroutine VAPAA_MPI_Type_create_f90_integer(r, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_f90_integer")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: r
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_f90_integer

        subroutine VAPAA_MPI_Type_create_f90_real(p, r, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_f90_real")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: p, r
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_f90_real

        subroutine VAPAA_MPI_Type_create_f90_complex(p, r, newtype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_create_f90_complex")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: p, r
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine VAPAA_MPI_Type_create_f90_complex

        subroutine VAPAA_MPI_Type_get_envelope(datatype, ni, na, nd, combiner, ierror) &
                   bind(C,name="VAPAA_MPI_Type_get_envelope")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            integer(kind=c_int), intent(out) :: ni, na, nd, combiner, ierror
        end subroutine VAPAA_MPI_Type_get_envelope

        subroutine VAPAA_MPI_Type_get_envelope_c(datatype, ni, na, nl, nd, combiner, ierror) &
                   bind(C,name="VAPAA_MPI_Type_get_envelope_c")
            use iso_c_binding, only: c_int, c_int64_t
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            integer(kind=c_int64_t), intent(out) :: ni, na, nl, nd
            integer(kind=c_int), intent(out) :: combiner, ierror
        end subroutine VAPAA_MPI_Type_get_envelope_c

        subroutine VAPAA_MPI_Type_get_contents(datatype, mi, ma, md, ints, addrs, types, ierror) &
                   bind(C,name="VAPAA_MPI_Type_get_contents")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: datatype, mi, ma, md
            integer(kind=c_int), intent(out), dimension(*) :: ints, types
            integer(kind=c_intptr_t), intent(out), dimension(*) :: addrs
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Type_get_contents

        subroutine VAPAA_MPI_Type_get_contents_c(datatype, mi, ma, ml, md, ints, addrs, counts, types, ierror) &
                   bind(C,name="VAPAA_MPI_Type_get_contents_c")
            use iso_c_binding, only: c_int, c_int64_t, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            integer(kind=c_int64_t), intent(in) :: mi, ma, ml, md
            integer(kind=c_int), intent(out), dimension(*) :: ints, types
            integer(kind=c_intptr_t), intent(out), dimension(*) :: addrs
            integer(kind=c_int64_t), intent(out), dimension(*) :: counts
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Type_get_contents_c

        subroutine VAPAA_MPI_Type_match_size(typeclass, size, datatype, ierror) &
                   bind(C,name="VAPAA_MPI_Type_match_size")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: typeclass, size
            integer(kind=c_int), intent(out) :: datatype, ierror
        end subroutine VAPAA_MPI_Type_match_size

        subroutine VAPAA_MPI_Type_get_value_index(value_type, index_type, pair_type, ierror) &
                   bind(C,name="VAPAA_MPI_Type_get_value_index")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: value_type, index_type
            integer(kind=c_int), intent(out) :: pair_type, ierror
        end subroutine VAPAA_MPI_Type_get_value_index

        subroutine VAPAA_MPI_Type_delete_attr(datatype, keyval, ierror) &
                   bind(C,name="VAPAA_MPI_Type_delete_attr")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: datatype, keyval
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Type_delete_attr

        subroutine VAPAA_MPI_Type_free_keyval(keyval, ierror) &
                   bind(C,name="VAPAA_MPI_Type_free_keyval")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: keyval
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Type_free_keyval

        subroutine VAPAA_MPI_Type_get_attr(datatype, keyval, attrval, flag, ierror) &
                   bind(C,name="VAPAA_MPI_Type_get_attr")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: datatype, keyval
            integer(kind=c_intptr_t), intent(out) :: attrval
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine VAPAA_MPI_Type_get_attr

        subroutine VAPAA_MPI_Type_set_attr(datatype, keyval, attrval, ierror) &
                   bind(C,name="VAPAA_MPI_Type_set_attr")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), intent(in) :: datatype, keyval
            integer(kind=c_intptr_t), intent(in) :: attrval
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Type_set_attr
    end interface

end module mpi_missing_c
