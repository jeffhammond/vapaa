! SPDX-License-Identifier: MIT

module mpi_f90_datatype
    use iso_c_binding, only: c_int
    implicit none
    private

    public :: MPI_Type_commit
    public :: MPI_Type_size
    public :: MPI_Type_dup
    public :: MPI_Type_free
    public :: MPI_Type_contiguous
    public :: MPI_Type_indexed
    public :: MPI_Type_create_struct
    public :: MPI_Type_create_f90_integer
    public :: MPI_Type_create_f90_real
    public :: MPI_Type_get_envelope
    public :: MPI_Type_get_contents
    public :: MPI_Type_extent
    public :: MPI_Type_get_attr
    public :: MPI_Type_set_attr
    public :: MPI_Type_free_keyval

    interface MPI_Type_commit
        module procedure MPI_Type_commit_f90
    end interface
    interface MPI_Type_size
        module procedure MPI_Type_size_f90
    end interface
    interface MPI_Type_dup
        module procedure MPI_Type_dup_f90
    end interface
    interface MPI_Type_free
        module procedure MPI_Type_free_f90
    end interface
    interface MPI_Type_contiguous
        module procedure MPI_Type_contiguous_f90
    end interface
    interface MPI_Type_indexed
        module procedure MPI_Type_indexed_f90
    end interface
    interface MPI_Type_create_struct
        module procedure MPI_Type_create_struct_f90
    end interface
    interface MPI_Type_create_f90_integer
        module procedure MPI_Type_create_f90_integer_f90
    end interface
    interface MPI_Type_create_f90_real
        module procedure MPI_Type_create_f90_real_f90
    end interface
    interface MPI_Type_get_envelope
        module procedure MPI_Type_get_envelope_f90
    end interface
    interface MPI_Type_get_contents
        module procedure MPI_Type_get_contents_f90
    end interface
    interface MPI_Type_extent
        module procedure MPI_Type_extent_f90
        module procedure MPI_Type_extent_int_f90
    end interface
    interface MPI_Type_get_attr
        module procedure MPI_Type_get_attr_aint_f90
    end interface
    interface MPI_Type_set_attr
        module procedure MPI_Type_set_attr_aint_f90
    end interface
    interface MPI_Type_free_keyval
        module procedure MPI_Type_free_keyval_f90
    end interface

contains

    subroutine MPI_Type_commit_f90(datatype, ierror)
        use mpi_datatype_c, only: C_MPI_Type_commit
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(inout) :: datatype
        integer, optional, intent(out) :: ierror
        integer(c_int) :: datatype_c, ierror_c
        datatype_c = datatype
        call C_MPI_Type_commit(datatype_c, ierror_c)
        datatype = datatype_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_commit_f90

    subroutine MPI_Type_size_f90(datatype, size, ierror)
        use mpi_datatype_c, only: C_MPI_Type_size
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: datatype
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        integer(c_int) :: size_c, ierror_c
        call C_MPI_Type_size(int(datatype,c_int), size_c, ierror_c)
        size = size_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_size_f90

    subroutine MPI_Type_dup_f90(oldtype, newtype, ierror)
        use mpi_datatype_c, only: C_MPI_Type_dup
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: oldtype
        integer, intent(out) :: newtype
        integer, optional, intent(out) :: ierror
        integer(c_int) :: newtype_c, ierror_c
        call C_MPI_Type_dup(int(oldtype,c_int), newtype_c, ierror_c)
        newtype = newtype_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_dup_f90

    subroutine MPI_Type_free_f90(datatype, ierror)
        use mpi_datatype_c, only: C_MPI_Type_free
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(inout) :: datatype
        integer, optional, intent(out) :: ierror
        integer(c_int) :: datatype_c, ierror_c
        datatype_c = datatype
        call C_MPI_Type_free(datatype_c, ierror_c)
        datatype = datatype_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_free_f90

    subroutine MPI_Type_contiguous_f90(count, oldtype, newtype, ierror)
        use mpi_datatype_c, only: C_MPI_Type_contiguous
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: count, oldtype
        integer, intent(out) :: newtype
        integer, optional, intent(out) :: ierror
        integer(c_int) :: newtype_c, ierror_c
        call C_MPI_Type_contiguous(int(count,c_int), int(oldtype,c_int), newtype_c, ierror_c)
        newtype = newtype_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_contiguous_f90

    subroutine MPI_Type_indexed_f90(count, blocklengths, displacements, oldtype, newtype, ierror)
        use mpi_missing_c, only: VAPAA_MPI_Type_indexed
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: count, oldtype
        integer, intent(in) :: blocklengths(*), displacements(*)
        integer, intent(out) :: newtype
        integer, optional, intent(out) :: ierror
        integer(c_int) :: newtype_c, ierror_c
        call VAPAA_MPI_Type_indexed(int(count,c_int), blocklengths, displacements, &
                                    int(oldtype,c_int), newtype_c, ierror_c)
        newtype = newtype_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_indexed_f90

    subroutine MPI_Type_create_struct_f90(count, blocklengths, displacements, datatypes, newtype, ierror)
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_missing_c, only: VAPAA_MPI_Type_create_struct
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: count
        integer, intent(in) :: blocklengths(*), datatypes(*)
        integer(kind=MPI_ADDRESS_KIND), intent(in) :: displacements(*)
        integer, intent(out) :: newtype
        integer, optional, intent(out) :: ierror
        integer(c_int) :: newtype_c, ierror_c
        call VAPAA_MPI_Type_create_struct(int(count,c_int), blocklengths, displacements, &
                                          datatypes, newtype_c, ierror_c)
        newtype = newtype_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_create_struct_f90

    subroutine MPI_Type_create_f90_integer_f90(r, newtype, ierror)
        use mpi_missing_c, only: VAPAA_MPI_Type_create_f90_integer
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: r
        integer, intent(out) :: newtype
        integer, optional, intent(out) :: ierror
        integer(c_int) :: newtype_c, ierror_c
        call VAPAA_MPI_Type_create_f90_integer(int(r,c_int), newtype_c, ierror_c)
        newtype = newtype_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_create_f90_integer_f90

    subroutine MPI_Type_create_f90_real_f90(p, r, newtype, ierror)
        use mpi_missing_c, only: VAPAA_MPI_Type_create_f90_real
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: p, r
        integer, intent(out) :: newtype
        integer, optional, intent(out) :: ierror
        integer(c_int) :: newtype_c, ierror_c
        call VAPAA_MPI_Type_create_f90_real(int(p,c_int), int(r,c_int), newtype_c, ierror_c)
        newtype = newtype_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_create_f90_real_f90

    subroutine MPI_Type_get_envelope_f90(datatype, num_integers, num_addresses, num_datatypes, combiner, ierror)
        use mpi_missing_c, only: VAPAA_MPI_Type_get_envelope
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: datatype
        integer, intent(out) :: num_integers, num_addresses, num_datatypes, combiner
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ni_c, na_c, nd_c, combiner_c, ierror_c
        call VAPAA_MPI_Type_get_envelope(int(datatype,c_int), ni_c, na_c, nd_c, combiner_c, ierror_c)
        num_integers = ni_c
        num_addresses = na_c
        num_datatypes = nd_c
        combiner = combiner_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_get_envelope_f90

    subroutine MPI_Type_get_contents_f90(datatype, max_integers, max_addresses, max_datatypes, &
                                         array_of_integers, array_of_addresses, array_of_datatypes, ierror)
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_missing_c, only: VAPAA_MPI_Type_get_contents
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: datatype, max_integers, max_addresses, max_datatypes
        integer, intent(out) :: array_of_integers(*), array_of_datatypes(*)
        integer(kind=MPI_ADDRESS_KIND), intent(out) :: array_of_addresses(*)
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
        call VAPAA_MPI_Type_get_contents(int(datatype,c_int), int(max_integers,c_int), &
                                         int(max_addresses,c_int), int(max_datatypes,c_int), &
                                         array_of_integers, array_of_addresses, array_of_datatypes, ierror_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_get_contents_f90

    subroutine MPI_Type_extent_f90(datatype, extent, ierror)
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_missing_c, only: VAPAA_MPI_Type_get_extent
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: datatype
        integer(kind=MPI_ADDRESS_KIND), intent(out) :: extent
        integer, optional, intent(out) :: ierror
        integer(kind=MPI_ADDRESS_KIND) :: lb
        integer(c_int) :: ierror_c
        call VAPAA_MPI_Type_get_extent(int(datatype,c_int), lb, extent, ierror_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_extent_f90

    subroutine MPI_Type_extent_int_f90(datatype, extent, ierror)
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_missing_c, only: VAPAA_MPI_Type_get_extent
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: datatype
        integer, intent(out) :: extent
        integer, optional, intent(out) :: ierror
        integer(kind=MPI_ADDRESS_KIND) :: lb, extent_aint
        integer(c_int) :: ierror_c
        call VAPAA_MPI_Type_get_extent(int(datatype,c_int), lb, extent_aint, ierror_c)
        extent = int(extent_aint)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_extent_int_f90

    subroutine MPI_Type_get_attr_aint_f90(datatype, type_keyval, attribute_val, flag, ierror)
        use iso_c_binding, only: c_intptr_t
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_missing_c, only: VAPAA_MPI_Type_get_attr
        use mpi_f90_util, only: f90_finish_ierror, f90_logical_from_c
        integer, intent(in) :: datatype, type_keyval
        integer(kind=MPI_ADDRESS_KIND), intent(out) :: attribute_val
        logical, intent(out) :: flag
        integer, optional, intent(out) :: ierror
        integer(c_intptr_t) :: attribute_val_c
        integer(c_int) :: flag_c, ierror_c
        call VAPAA_MPI_Type_get_attr(int(datatype,c_int), int(type_keyval,c_int), &
                                     attribute_val_c, flag_c, ierror_c)
        attribute_val = attribute_val_c
        flag = f90_logical_from_c(flag_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_get_attr_aint_f90

    subroutine MPI_Type_set_attr_aint_f90(datatype, type_keyval, attribute_val, ierror)
        use iso_c_binding, only: c_intptr_t
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_missing_c, only: VAPAA_MPI_Type_set_attr
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: datatype, type_keyval
        integer(kind=MPI_ADDRESS_KIND), intent(in) :: attribute_val
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
        call VAPAA_MPI_Type_set_attr(int(datatype,c_int), int(type_keyval,c_int), &
                                     int(attribute_val,c_intptr_t), ierror_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_set_attr_aint_f90

    subroutine MPI_Type_free_keyval_f90(type_keyval, ierror)
        use mpi_missing_c, only: VAPAA_MPI_Type_free_keyval
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(inout) :: type_keyval
        integer, optional, intent(out) :: ierror
        integer(c_int) :: keyval_c, ierror_c
        keyval_c = type_keyval
        call VAPAA_MPI_Type_free_keyval(keyval_c, ierror_c)
        type_keyval = keyval_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Type_free_keyval_f90

end module mpi_f90_datatype
