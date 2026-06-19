! SPDX-License-Identifier: MIT

module mpi_f90_status
    use iso_c_binding, only: c_int, c_size_t
    use mpi_f90_constants, only: MPI_ERROR, MPI_SOURCE, MPI_STATUS_SIZE, MPI_TAG
    use mpi_handle_types, only: MPI_Status
    implicit none

contains

    subroutine mpi_f90_status_from_f08(status_f08, status_f90)
        type(MPI_Status), intent(in) :: status_f08
        integer, intent(out) :: status_f90(MPI_STATUS_SIZE)
#ifndef MPI_ABI
        integer(c_int) :: ucount_words(2)
#endif
        status_f90 = 0
        status_f90(MPI_SOURCE) = status_f08 % MPI_SOURCE
        status_f90(MPI_TAG) = status_f08 % MPI_TAG
        status_f90(MPI_ERROR) = status_f08 % MPI_ERROR
#ifdef MPI_ABI
        status_f90(4:8) = status_f08 % MPI_internal
#else
        status_f90(4) = status_f08 % count_lo
        status_f90(5) = status_f08 % count_hi_and_cancelled
        status_f90(6) = status_f08 % cancelled
        ucount_words = transfer(status_f08 % ucount, ucount_words)
        status_f90(7:8) = ucount_words
#endif
    end subroutine mpi_f90_status_from_f08

    subroutine mpi_f90_status_to_f08(status_f90, status_f08)
        integer, intent(in) :: status_f90(MPI_STATUS_SIZE)
        type(MPI_Status), intent(out) :: status_f08
#ifndef MPI_ABI
        integer(c_int) :: ucount_words(2)
#endif
#ifdef MPI_ABI
        status_f08 % MPI_SOURCE = status_f90(MPI_SOURCE)
        status_f08 % MPI_TAG = status_f90(MPI_TAG)
        status_f08 % MPI_ERROR = status_f90(MPI_ERROR)
        status_f08 % MPI_internal = status_f90(4:8)
#else
        status_f08 % count_lo = status_f90(4)
        status_f08 % count_hi_and_cancelled = status_f90(5)
        status_f08 % MPI_SOURCE = status_f90(MPI_SOURCE)
        status_f08 % MPI_TAG = status_f90(MPI_TAG)
        status_f08 % MPI_ERROR = status_f90(MPI_ERROR)
        status_f08 % cancelled = status_f90(6)
        ucount_words = status_f90(7:8)
        status_f08 % ucount = transfer(ucount_words, status_f08 % ucount)
#endif
    end subroutine mpi_f90_status_to_f08

end module mpi_f90_status
