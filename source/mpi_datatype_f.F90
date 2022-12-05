#include "vapaa_constants.h"

module mpi_datatype_f
    use iso_c_binding, only: c_int
    use mpi_global_constants, only: MPI_Datatype
    implicit none

    ! Fortran types come first
    type(MPI_Datatype), parameter :: MPI_CHARACTER              = MPI_Datatype(MPI_VAL = VAPAA_MPI_CHARACTER)
    type(MPI_Datatype), parameter :: MPI_LOGICAL                = MPI_Datatype(MPI_VAL = VAPAA_MPI_LOGICAL)
    type(MPI_Datatype), parameter :: MPI_INTEGER                = MPI_Datatype(MPI_VAL = VAPAA_MPI_INTEGER)
    type(MPI_Datatype), parameter :: MPI_REAL                   = MPI_Datatype(MPI_VAL = VAPAA_MPI_REAL)
    type(MPI_Datatype), parameter :: MPI_DOUBLE_PRECISION       = MPI_Datatype(MPI_VAL = VAPAA_MPI_DOUBLE_PRECISION)
    type(MPI_Datatype), parameter :: MPI_COMPLEX                = MPI_Datatype(MPI_VAL = VAPAA_MPI_COMPLEX)
    type(MPI_Datatype), parameter :: MPI_DOUBLE_COMPLEX         = MPI_Datatype(MPI_VAL = VAPAA_MPI_DOUBLE_COMPLEX)
    type(MPI_Datatype), parameter :: MPI_INTEGER1               = MPI_Datatype(MPI_VAL = VAPAA_MPI_INTEGER1)
    type(MPI_Datatype), parameter :: MPI_INTEGER2               = MPI_Datatype(MPI_VAL = VAPAA_MPI_INTEGER2)
    type(MPI_Datatype), parameter :: MPI_INTEGER4               = MPI_Datatype(MPI_VAL = VAPAA_MPI_INTEGER4)
    type(MPI_Datatype), parameter :: MPI_INTEGER8               = MPI_Datatype(MPI_VAL = VAPAA_MPI_INTEGER8)
#if HAVE_MPI_INTEGER16
    type(MPI_Datatype), parameter :: MPI_INTEGER16              = MPI_Datatype(MPI_VAL = VAPAA_MPI_INTEGER16)
#endif
#ifdef HAVE_MPI_REAL2
    type(MPI_Datatype), parameter :: MPI_REAL2                  = MPI_Datatype(MPI_VAL = VAPAA_MPI_REAL2)
#endif
    type(MPI_Datatype), parameter :: MPI_REAL4                  = MPI_Datatype(MPI_VAL = VAPAA_MPI_REAL4)
    type(MPI_Datatype), parameter :: MPI_REAL8                  = MPI_Datatype(MPI_VAL = VAPAA_MPI_REAL8)
#ifdef HAVE_MPI_REAL16
    type(MPI_Datatype), parameter :: MPI_REAL16                 = MPI_Datatype(MPI_VAL = VAPAA_MPI_REAL16)
#endif
#ifdef HAVE_MPI_COMPLEX4
    type(MPI_Datatype), parameter :: MPI_COMPLEX4               = MPI_Datatype(MPI_VAL = VAPAA_MPI_COMPLEX4)
#endif
    type(MPI_Datatype), parameter :: MPI_COMPLEX8               = MPI_Datatype(MPI_VAL = VAPAA_MPI_COMPLEX8)
    type(MPI_Datatype), parameter :: MPI_COMPLEX16              = MPI_Datatype(MPI_VAL = VAPAA_MPI_COMPLEX16)
#ifdef HAVE_MPI_COMPLEX32
    type(MPI_Datatype), parameter :: MPI_COMPLEX32              = MPI_Datatype(MPI_VAL = VAPAA_MPI_COMPLEX32)
#endif

    ! these are language-agnostic
    type(MPI_Datatype), parameter :: MPI_AINT                        = MPI_Datatype(MPI_VAL = VAPAA_MPI_AINT)
    type(MPI_Datatype), parameter :: MPI_COUNT                       = MPI_Datatype(MPI_VAL = VAPAA_MPI_COUNT)
    type(MPI_Datatype), parameter :: MPI_OFFSET                      = MPI_Datatype(MPI_VAL = VAPAA_MPI_OFFSET)

    ! C and C++ types are less likely
    type(MPI_Datatype), parameter :: MPI_BYTE                        = MPI_Datatype(MPI_VAL = VAPAA_MPI_BYTE)
    type(MPI_Datatype), parameter :: MPI_CHAR                        = MPI_Datatype(MPI_VAL = VAPAA_MPI_CHAR)
    type(MPI_Datatype), parameter :: MPI_UNSIGNED_CHAR               = MPI_Datatype(MPI_VAL = VAPAA_MPI_UNSIGNED_CHAR)
    type(MPI_Datatype), parameter :: MPI_SIGNED_CHAR                 = MPI_Datatype(MPI_VAL = VAPAA_MPI_SIGNED_CHAR)
    type(MPI_Datatype), parameter :: MPI_WCHAR                       = MPI_Datatype(MPI_VAL = VAPAA_MPI_WCHAR)
    type(MPI_Datatype), parameter :: MPI_SHORT                       = MPI_Datatype(MPI_VAL = VAPAA_MPI_SHORT)
    type(MPI_Datatype), parameter :: MPI_UNSIGNED_SHORT              = MPI_Datatype(MPI_VAL = VAPAA_MPI_UNSIGNED_SHORT)
    type(MPI_Datatype), parameter :: MPI_INT                         = MPI_Datatype(MPI_VAL = VAPAA_MPI_INT)
    type(MPI_Datatype), parameter :: MPI_LONG                        = MPI_Datatype(MPI_VAL = VAPAA_MPI_LONG)
    type(MPI_Datatype), parameter :: MPI_UNSIGNED                    = MPI_Datatype(MPI_VAL = VAPAA_MPI_UNSIGNED)
    type(MPI_Datatype), parameter :: MPI_UNSIGNED_LONG               = MPI_Datatype(MPI_VAL = VAPAA_MPI_UNSIGNED_LONG)
    type(MPI_Datatype), parameter :: MPI_LONG_LONG_INT               = MPI_Datatype(MPI_VAL = VAPAA_MPI_LONG_LONG_INT)
    type(MPI_Datatype), parameter :: MPI_UNSIGNED_LONG_LONG          = MPI_Datatype(MPI_VAL = VAPAA_MPI_UNSIGNED_LONG_LONG)
    type(MPI_Datatype), parameter :: MPI_FLOAT                       = MPI_Datatype(MPI_VAL = VAPAA_MPI_FLOAT)
    type(MPI_Datatype), parameter :: MPI_DOUBLE                      = MPI_Datatype(MPI_VAL = VAPAA_MPI_DOUBLE)
    type(MPI_Datatype), parameter :: MPI_LONG_DOUBLE                 = MPI_Datatype(MPI_VAL = VAPAA_MPI_LONG_DOUBLE)
    type(MPI_Datatype), parameter :: MPI_C_BOOL                      = MPI_Datatype(MPI_VAL = VAPAA_MPI_C_BOOL)
    type(MPI_Datatype), parameter :: MPI_INT8_T                      = MPI_Datatype(MPI_VAL = VAPAA_MPI_INT8_T)
    type(MPI_Datatype), parameter :: MPI_INT16_T                     = MPI_Datatype(MPI_VAL = VAPAA_MPI_INT16_T)
    type(MPI_Datatype), parameter :: MPI_INT32_T                     = MPI_Datatype(MPI_VAL = VAPAA_MPI_INT32_T)
    type(MPI_Datatype), parameter :: MPI_INT64_T                     = MPI_Datatype(MPI_VAL = VAPAA_MPI_INT64_T)
    type(MPI_Datatype), parameter :: MPI_UINT8_T                     = MPI_Datatype(MPI_VAL = VAPAA_MPI_UINT8_T)
    type(MPI_Datatype), parameter :: MPI_UINT16_T                    = MPI_Datatype(MPI_VAL = VAPAA_MPI_UINT16_T)
    type(MPI_Datatype), parameter :: MPI_UINT32_T                    = MPI_Datatype(MPI_VAL = VAPAA_MPI_UINT32_T)
    type(MPI_Datatype), parameter :: MPI_UINT64_T                    = MPI_Datatype(MPI_VAL = VAPAA_MPI_UINT64_T)
    type(MPI_Datatype), parameter :: MPI_C_COMPLEX                   = MPI_Datatype(MPI_VAL = VAPAA_MPI_C_COMPLEX)
    type(MPI_Datatype), parameter :: MPI_C_FLOAT_COMPLEX             = MPI_Datatype(MPI_VAL = VAPAA_MPI_C_FLOAT_COMPLEX)
    type(MPI_Datatype), parameter :: MPI_C_DOUBLE_COMPLEX            = MPI_Datatype(MPI_VAL = VAPAA_MPI_C_DOUBLE_COMPLEX)
    type(MPI_Datatype), parameter :: MPI_C_LONG_DOUBLE_COMPLEX       = MPI_Datatype(MPI_VAL = VAPAA_MPI_C_LONG_DOUBLE_COMPLEX)

    interface MPI_Type_commit
        module procedure MPI_Type_commit_f08
    end interface MPI_Type_commit

    interface MPI_Type_size
        module procedure MPI_Type_size_f08
    end interface MPI_Type_size

    interface MPI_Type_dup
        module procedure MPI_Type_dup_f08
    end interface MPI_Type_dup

    interface MPI_Type_free
        module procedure MPI_Type_free_f08
    end interface MPI_Type_free

    interface MPI_Type_contiguous
        module procedure MPI_Type_contiguous_f08
    end interface MPI_Type_contiguous

    interface MPI_Type_vector
        module procedure MPI_Type_vector_f08
    end interface MPI_Type_vector

    interface MPI_Type_create_subarray
        module procedure MPI_Type_create_subarray_f08
    end interface MPI_Type_create_subarray

    contains

        subroutine MPI_Type_commit_f08(datatype, ierror) 
            use mpi_handle_types, only: MPI_Datatype
            use mpi_datatype_c, only: C_MPI_Type_commit
            type(MPI_Datatype), intent(inout) :: datatype
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Type_commit(datatype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_commit_f08

        subroutine MPI_Type_size_f08(datatype, size, ierror) 
            use mpi_handle_types, only: MPI_Datatype
            use mpi_datatype_c, only: C_MPI_Type_size
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: size_c, ierror_c
            call C_MPI_Type_size(datatype % MPI_VAL, size_c, ierror_c)
            size = size_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_size_f08

        subroutine MPI_Type_dup_f08(oldtype, newtype, ierror) 
            use mpi_handle_types, only: MPI_Datatype
            use mpi_datatype_c, only: C_MPI_Type_dup
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Type_dup(oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_dup_f08

        subroutine MPI_Type_free_f08(datatype, ierror) 
            use mpi_handle_types, only: MPI_Datatype
            use mpi_datatype_c, only: C_MPI_Type_free
            type(MPI_Datatype), intent(inout) :: datatype
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Type_free(datatype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_free_f08

        subroutine MPI_Type_contiguous_f08(count, oldtype, newtype, ierror) 
            use mpi_handle_types, only: MPI_Datatype
            use mpi_datatype_c, only: C_MPI_Type_contiguous
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, ierror_c
            count_c = count
            call C_MPI_Type_contiguous(count_c, oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_contiguous_f08

        subroutine MPI_Type_vector_f08(count, blocklength, stride, oldtype, newtype, ierror) 
            use mpi_handle_types, only: MPI_Datatype
            use mpi_datatype_c, only: C_MPI_Type_vector
            integer, intent(in) :: count, blocklength, stride
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: count_c, blocklength_c, stride_c, ierror_c
            count_c = count
            blocklength_c = blocklength
            stride_c = stride
            call C_MPI_Type_vector(count_c, blocklength_c, stride_c,  oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_vector_f08

        subroutine MPI_Type_create_subarray_f08(ndims, array_of_sizes, array_of_subsizes, array_of_starts, &
                                                order, oldtype, newtype, ierror) 
            use mpi_handle_types, only: MPI_Datatype
            use mpi_datatype_c, only: C_MPI_Type_create_subarray
            integer, intent(in) :: ndims, order
            integer, dimension(ndims) :: array_of_sizes, array_of_subsizes, array_of_starts
            type(MPI_Datatype), intent(in) :: oldtype
            type(MPI_Datatype), intent(out) :: newtype
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ndims_c, order_c, ierror_c
            integer(kind=c_int), dimension(ndims) :: array_of_sizes_c, array_of_subsizes_c, array_of_starts_c
            ndims_c = ndims
            array_of_sizes_c    = array_of_sizes
            array_of_subsizes_c = array_of_subsizes
            array_of_starts_c   = array_of_starts
            order_c = order
            call C_MPI_Type_create_subarray(ndims_c, array_of_sizes_c, array_of_subsizes_c, array_of_starts_c, &
                                            order_c, oldtype % MPI_VAL, newtype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Type_create_subarray_f08

end module mpi_datatype_f
