! SPDX-License-Identifier: MIT

module mpi_f90_p2p
    use iso_c_binding, only: c_int
    implicit none
    private

    public :: MPI_Send
    public :: MPI_Ssend
    public :: MPI_Recv
    public :: MPI_Unpack

    interface MPI_Send
        module procedure MPI_Send_f90
    end interface
    interface MPI_Ssend
        module procedure MPI_Ssend_f90
    end interface
    interface MPI_Recv
        module procedure MPI_Recv_f90
    end interface
    interface MPI_Unpack
        module procedure MPI_Unpack_f90
    end interface

contains

    subroutine MPI_Send_f90(buffer, count, datatype, dest, tag, comm, ierror)
#ifdef HAVE_CFI
        use mpi_p2p_c, only: CFI_MPI_Send
#else
        use mpi_p2p_c, only: C_MPI_Send
#endif
        use mpi_f90_util, only: f90_finish_ierror
#ifdef HAVE_CFI
        type(*), dimension(..), intent(in) :: buffer
#else
!dir$ ignore_tkr buffer
        integer, dimension(*), intent(in) :: buffer
#endif
        integer, intent(in) :: count, datatype, dest, tag, comm
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
#ifdef HAVE_CFI
        call CFI_MPI_Send(buffer, int(count,c_int), int(datatype,c_int), int(dest,c_int), &
                          int(tag,c_int), int(comm,c_int), ierror_c)
#else
        call C_MPI_Send(buffer, int(count,c_int), int(datatype,c_int), int(dest,c_int), &
                        int(tag,c_int), int(comm,c_int), ierror_c)
#endif
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Send_f90

    subroutine MPI_Ssend_f90(buffer, count, datatype, dest, tag, comm, ierror)
#ifdef HAVE_CFI
        use mpi_p2p_c, only: CFI_MPI_Ssend
#else
        use mpi_p2p_c, only: C_MPI_Ssend
#endif
        use mpi_f90_util, only: f90_finish_ierror
#ifdef HAVE_CFI
        type(*), dimension(..), intent(in) :: buffer
#else
!dir$ ignore_tkr buffer
        integer, dimension(*), intent(in) :: buffer
#endif
        integer, intent(in) :: count, datatype, dest, tag, comm
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
#ifdef HAVE_CFI
        call CFI_MPI_Ssend(buffer, int(count,c_int), int(datatype,c_int), int(dest,c_int), &
                           int(tag,c_int), int(comm,c_int), ierror_c)
#else
        call C_MPI_Ssend(buffer, int(count,c_int), int(datatype,c_int), int(dest,c_int), &
                         int(tag,c_int), int(comm,c_int), ierror_c)
#endif
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Ssend_f90

    subroutine MPI_Recv_f90(buffer, count, datatype, source, tag, comm, status, ierror)
        use mpi_f90_constants, only: MPI_STATUS_SIZE
        use mpi_f90_status, only: mpi_f90_status_from_f08
        use mpi_f90_util, only: f90_finish_ierror
        use mpi_handle_types, only: MPI_Status
#ifdef HAVE_CFI
        use mpi_p2p_c, only: CFI_MPI_Recv
#else
        use mpi_p2p_c, only: C_MPI_Recv
#endif
#ifdef HAVE_CFI
        type(*), dimension(..), intent(inout) :: buffer
#else
!dir$ ignore_tkr buffer
        integer, dimension(*), intent(out) :: buffer
#endif
        integer, intent(in) :: count, datatype, source, tag, comm
        integer, intent(out) :: status(MPI_STATUS_SIZE)
        integer, optional, intent(out) :: ierror
        type(MPI_Status) :: status_f08
        integer(c_int) :: ierror_c
#ifdef HAVE_CFI
        call CFI_MPI_Recv(buffer, int(count,c_int), int(datatype,c_int), int(source,c_int), &
                          int(tag,c_int), int(comm,c_int), status_f08, ierror_c)
#else
        call C_MPI_Recv(buffer, int(count,c_int), int(datatype,c_int), int(source,c_int), &
                        int(tag,c_int), int(comm,c_int), status_f08, ierror_c)
#endif
        call mpi_f90_status_from_f08(status_f08, status)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Recv_f90

    subroutine MPI_Unpack_f90(inbuf, insize, position, outbuf, outcount, datatype, comm, ierror)
#ifdef HAVE_CFI
        use mpi_p2p_c, only: CFI_MPI_Unpack
#else
        use mpi_p2p_c, only: C_MPI_Unpack
#endif
        use mpi_f90_util, only: f90_finish_ierror
#ifdef HAVE_CFI
        type(*), dimension(..), intent(in) :: inbuf
#else
!dir$ ignore_tkr inbuf
        integer, dimension(*), intent(in) :: inbuf
#endif
        integer, intent(in) :: insize, outcount, datatype, comm
        integer, intent(inout) :: position
#ifdef HAVE_CFI
        type(*), dimension(..), intent(inout) :: outbuf
#else
!dir$ ignore_tkr outbuf
        integer, dimension(*), intent(out) :: outbuf
#endif
        integer, optional, intent(out) :: ierror
        integer(c_int) :: position_c, ierror_c
        position_c = position
#ifdef HAVE_CFI
        call CFI_MPI_Unpack(inbuf, int(insize,c_int), position_c, outbuf, int(outcount,c_int), &
                            int(datatype,c_int), int(comm,c_int), ierror_c)
#else
        call C_MPI_Unpack(inbuf, int(insize,c_int), position_c, outbuf, int(outcount,c_int), &
                          int(datatype,c_int), int(comm,c_int), ierror_c)
#endif
        position = position_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Unpack_f90

end module mpi_f90_p2p
