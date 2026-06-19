! SPDX-License-Identifier: MIT

block data vapaa_mpifh_block_data
    implicit none
    integer, parameter :: MPI_STATUS_SIZE = 8
    integer :: MPI_BOTTOM
    integer :: MPI_IN_PLACE
    integer :: MPI_ARGV_NULL
    integer :: MPI_ARGVS_NULL
    integer :: MPI_ERRCODES_IGNORE
    integer :: MPI_UNWEIGHTED
    integer :: MPI_WEIGHTS_EMPTY
    integer :: MPI_STATUS_IGNORE(MPI_STATUS_SIZE)
    integer :: MPI_STATUSES_IGNORE(MPI_STATUS_SIZE,1)
    common /vapaa_mpifh_sentinels/ MPI_BOTTOM, MPI_IN_PLACE, &
        MPI_ARGV_NULL, MPI_ARGVS_NULL, MPI_ERRCODES_IGNORE, &
        MPI_UNWEIGHTED, MPI_WEIGHTS_EMPTY, MPI_STATUS_IGNORE, &
        MPI_STATUSES_IGNORE
    data MPI_BOTTOM /0/
    data MPI_IN_PLACE /1/
    data MPI_ARGV_NULL /0/
    data MPI_ARGVS_NULL /0/
    data MPI_ERRCODES_IGNORE /0/
    data MPI_UNWEIGHTED /10/
    data MPI_WEIGHTS_EMPTY /11/
end block data vapaa_mpifh_block_data

module mpi_f77_support
    use iso_c_binding, only: c_int, c_int8_t
    implicit none

contains

    subroutine VAPAA_MPIFH_Init_support(ierror_c) bind(C,name="VAPAA_MPIFH_Init_support")
        use mpi_core_c, only: C_MPI_Abi_init_fortran
        use detect_sentinels_c
        integer(c_int), intent(inout) :: ierror_c
        integer, parameter :: MPI_STATUS_SIZE = 8
        integer :: MPI_BOTTOM
        integer :: MPI_IN_PLACE
        integer :: MPI_ARGV_NULL
        integer :: MPI_ARGVS_NULL
        integer :: MPI_ERRCODES_IGNORE
        integer :: MPI_UNWEIGHTED
        integer :: MPI_WEIGHTS_EMPTY
        integer :: MPI_STATUS_IGNORE(MPI_STATUS_SIZE)
        integer :: MPI_STATUSES_IGNORE(MPI_STATUS_SIZE,1)
        common /vapaa_mpifh_sentinels/ MPI_BOTTOM, MPI_IN_PLACE, &
            MPI_ARGV_NULL, MPI_ARGVS_NULL, MPI_ERRCODES_IGNORE, &
            MPI_UNWEIGHTED, MPI_WEIGHTS_EMPTY, MPI_STATUS_IGNORE, &
            MPI_STATUSES_IGNORE

#ifndef MPI_ABI
        if (ierror_c /= 0_c_int) continue
#endif

#ifdef MPI_ABI
        integer(c_int) :: abi_ierror_c
        integer(c_int) :: logical_size_c
        integer(c_int) :: integer_size_c
        integer(c_int) :: real_size_c
        integer(c_int) :: double_precision_size_c
        integer(c_int8_t) :: logical_true_bytes(8)
        integer(c_int8_t) :: logical_false_bytes(8)

        if (ierror_c == 0_c_int) then
            logical_size_c = storage_size(.true.) / 8
            if (logical_size_c <= size(logical_true_bytes)) then
                integer_size_c = storage_size(0) / 8
                real_size_c = storage_size(0.0) / 8
                double_precision_size_c = storage_size(0.0d0) / 8
                logical_true_bytes = 0_c_int8_t
                logical_false_bytes = 0_c_int8_t
                logical_true_bytes(1:logical_size_c) = &
                    transfer(.true., logical_true_bytes(1:logical_size_c))
                logical_false_bytes(1:logical_size_c) = &
                    transfer(.false., logical_false_bytes(1:logical_size_c))

                call C_MPI_Abi_init_fortran(logical_size_c, logical_true_bytes, logical_false_bytes, &
                                            integer_size_c, real_size_c, double_precision_size_c, &
                                            abi_ierror_c)
                if (abi_ierror_c /= 0_c_int) ierror_c = abi_ierror_c
            else
                ierror_c = -1_c_int
            end if
        end if
#endif

        call C_MPI_BOTTOM(MPI_BOTTOM)
        call C_MPI_STATUS_IGNORE(MPI_STATUS_IGNORE)
        call C_MPI_STATUSES_IGNORE(MPI_STATUSES_IGNORE)
        call C_MPI_ERRCODES_IGNORE(MPI_ERRCODES_IGNORE)
        call C_MPI_IN_PLACE(MPI_IN_PLACE)
        call C_MPI_ARGV_NULL(MPI_ARGV_NULL)
        call C_MPI_ARGVS_NULL(MPI_ARGVS_NULL)
        call C_MPI_UNWEIGHTED(MPI_UNWEIGHTED)
        call C_MPI_WEIGHTS_EMPTY(MPI_WEIGHTS_EMPTY)
    end subroutine VAPAA_MPIFH_Init_support

end module mpi_f77_support
