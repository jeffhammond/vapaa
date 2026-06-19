! SPDX-License-Identifier: MIT

module mpi_f90_coll
    use iso_c_binding, only: c_int
    implicit none
    private

    public :: MPI_Barrier
    public :: MPI_Allreduce

    interface MPI_Barrier
        module procedure MPI_Barrier_f90
    end interface
    interface MPI_Allreduce
        module procedure MPI_Allreduce_f90
    end interface

contains

    subroutine MPI_Barrier_f90(comm, ierror)
        use mpi_coll_c, only: C_MPI_Barrier
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: comm
        integer, optional, intent(out) :: ierror
        integer(c_int) :: comm_c, ierror_c
        comm_c = comm
        call C_MPI_Barrier(comm_c, ierror_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Barrier_f90

    subroutine MPI_Allreduce_f90(sendbuf, recvbuf, count, datatype, op, comm, ierror)
#ifdef HAVE_CFI
        use mpi_coll_c, only: CFI_MPI_Allreduce
#else
        use mpi_coll_c, only: C_MPI_Allreduce
#endif
        use mpi_f90_util, only: f90_finish_ierror
#ifdef HAVE_CFI
        type(*), dimension(..), intent(in) :: sendbuf
        type(*), dimension(..), intent(inout) :: recvbuf
#else
!dir$ ignore_tkr sendbuf, recvbuf
        integer, dimension(*), intent(in) :: sendbuf
        integer, dimension(*), intent(inout) :: recvbuf
#endif
        integer, intent(in) :: count, datatype, op, comm
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
#ifdef HAVE_CFI
        call CFI_MPI_Allreduce(sendbuf, recvbuf, int(count,c_int), int(datatype,c_int), &
                               int(op,c_int), int(comm,c_int), ierror_c)
#else
        call C_MPI_Allreduce(sendbuf, recvbuf, int(count,c_int), int(datatype,c_int), &
                             int(op,c_int), int(comm,c_int), ierror_c)
#endif
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Allreduce_f90

end module mpi_f90_coll
