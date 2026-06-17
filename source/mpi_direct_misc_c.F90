! SPDX-License-Identifier: MIT

module mpi_direct_misc_c
    use iso_c_binding, only: c_char, c_int, c_intptr_t
    implicit none

    interface
#ifdef HAVE_CFI
        subroutine VAPAA_MPI_Sendrecv_replace(buf, count, datatype, dest, sendtag, source, recvtag, comm, &
                                             status, ierror) bind(C,name="VAPAA_MPI_Sendrecv_replace")
            use iso_c_binding, only: c_int
            use mpi_handle_types, only: MPI_Status
            implicit none
            type(*), dimension(..), intent(inout) :: buf
            integer(kind=c_int), intent(in) :: count, datatype, dest, sendtag, source, recvtag, comm
            type(MPI_Status), intent(out) :: status
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Sendrecv_replace

        subroutine VAPAA_MPI_Scan(sendbuf, recvbuf, count, datatype, op, comm, ierror) &
                   bind(C,name="VAPAA_MPI_Scan")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
            type(*), dimension(..) :: recvbuf
            integer(kind=c_int), intent(in) :: count, datatype, op, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Scan

        subroutine VAPAA_MPI_Exscan(sendbuf, recvbuf, count, datatype, op, comm, ierror) &
                   bind(C,name="VAPAA_MPI_Exscan")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
            type(*), dimension(..) :: recvbuf
            integer(kind=c_int), intent(in) :: count, datatype, op, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Exscan

        subroutine VAPAA_MPI_Reduce_scatter(sendbuf, recvbuf, recvcounts, datatype, op, comm, ierror) &
                   bind(C,name="VAPAA_MPI_Reduce_scatter")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
            type(*), dimension(..) :: recvbuf
            integer(kind=c_int), intent(in) :: recvcounts(*)
            integer(kind=c_int), intent(in) :: datatype, op, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Reduce_scatter

        subroutine VAPAA_MPI_Reduce_scatter_block(sendbuf, recvbuf, recvcount, datatype, op, comm, ierror) &
                   bind(C,name="VAPAA_MPI_Reduce_scatter_block")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: sendbuf
            type(*), dimension(..) :: recvbuf
            integer(kind=c_int), intent(in) :: recvcount, datatype, op, comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Reduce_scatter_block

        subroutine VAPAA_MPI_Reduce_local(inbuf, inoutbuf, count, datatype, op, ierror) &
                   bind(C,name="VAPAA_MPI_Reduce_local")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in) :: inbuf
            type(*), dimension(..), intent(inout) :: inoutbuf
            integer(kind=c_int), intent(in) :: count, datatype, op
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Reduce_local

        subroutine VAPAA_MPI_Pack_external(datarep, inbuf, incount, datatype, outbuf, outsize, position, &
                                           ierror) bind(C,name="VAPAA_MPI_Pack_external")
            use iso_c_binding, only: c_char, c_int, c_intptr_t
            implicit none
            character(kind=c_char), intent(in) :: datarep(*)
            type(*), dimension(..), intent(in) :: inbuf
            integer(kind=c_int), intent(in) :: incount, datatype
            type(*), dimension(..) :: outbuf
            integer(kind=c_intptr_t), intent(in) :: outsize
            integer(kind=c_intptr_t), intent(inout) :: position
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Pack_external

        subroutine VAPAA_MPI_Unpack_external(datarep, inbuf, insize, position, outbuf, outcount, datatype, &
                                             ierror) bind(C,name="VAPAA_MPI_Unpack_external")
            use iso_c_binding, only: c_char, c_int, c_intptr_t
            implicit none
            character(kind=c_char), intent(in) :: datarep(*)
            type(*), dimension(..), intent(in) :: inbuf
            integer(kind=c_intptr_t), intent(in) :: insize
            integer(kind=c_intptr_t), intent(inout) :: position
            type(*), dimension(..) :: outbuf
            integer(kind=c_int), intent(in) :: outcount, datatype
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Unpack_external
#endif

        subroutine VAPAA_MPI_Pack_size(incount, datatype, comm, size, ierror) bind(C,name="VAPAA_MPI_Pack_size")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: incount, datatype, comm
            integer(kind=c_int), intent(out) :: size, ierror
        end subroutine VAPAA_MPI_Pack_size

        subroutine VAPAA_MPI_Pack_external_size(datarep, incount, datatype, size, ierror) &
                   bind(C,name="VAPAA_MPI_Pack_external_size")
            use iso_c_binding, only: c_char, c_int, c_intptr_t
            implicit none
            character(kind=c_char), intent(in) :: datarep(*)
            integer(kind=c_int), intent(in) :: incount, datatype
            integer(kind=c_intptr_t), intent(out) :: size
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Pack_external_size

        subroutine VAPAA_MPI_Op_commutative(op, commute, ierror) bind(C,name="VAPAA_MPI_Op_commutative")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: op
            integer(kind=c_int), intent(out) :: commute, ierror
        end subroutine VAPAA_MPI_Op_commutative
    end interface

end module mpi_direct_misc_c
