! SPDX-License-Identifier: MIT

#include "vapaa_constants.h"

module mpi_rma_f
    use iso_c_binding, only: c_int
    implicit none

    ! RMA mode constants
    integer, parameter :: MPI_MODE_NOCHECK          = VAPAA_MPI_MODE_NOCHECK
    integer, parameter :: MPI_MODE_NOPRECEDE        = VAPAA_MPI_MODE_NOPRECEDE
    integer, parameter :: MPI_MODE_NOPUT            = VAPAA_MPI_MODE_NOPUT
    integer, parameter :: MPI_MODE_NOSTORE          = VAPAA_MPI_MODE_NOSTORE
    integer, parameter :: MPI_MODE_NOSUCCEED        = VAPAA_MPI_MODE_NOSUCCEED

    ! other constants
    integer, parameter :: MPI_LOCK_SHARED            = VAPAA_MPI_LOCK_SHARED
    integer, parameter :: MPI_LOCK_EXCLUSIVE         = VAPAA_MPI_LOCK_EXCLUSIVE

    contains

end module mpi_rma_f
