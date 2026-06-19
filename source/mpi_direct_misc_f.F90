! SPDX-License-Identifier: MIT

module mpi_direct_misc_f
    use iso_c_binding, only: c_char, c_int, c_intptr_t, c_null_char
    implicit none

#if defined(HAVE_CFI) || defined(HAVE_PGIF)
    interface MPI_Sendrecv_replace
        module procedure MPI_Sendrecv_replace_f08ts
    end interface
    interface MPI_Scan
        module procedure MPI_Scan_f08ts
    end interface
    interface MPI_Exscan
        module procedure MPI_Exscan_f08ts
    end interface
    interface MPI_Reduce_scatter
        module procedure MPI_Reduce_scatter_f08ts
    end interface
    interface MPI_Reduce_scatter_block
        module procedure MPI_Reduce_scatter_block_f08ts
    end interface
    interface MPI_Reduce_local
        module procedure MPI_Reduce_local_f08ts
    end interface
    interface MPI_Pack_external
        module procedure MPI_Pack_external_f08ts
    end interface
    interface MPI_Unpack_external
        module procedure MPI_Unpack_external_f08ts
    end interface
#endif

    interface MPI_Pack_size
        module procedure MPI_Pack_size_f08
    end interface
    interface MPI_Pack_external_size
        module procedure MPI_Pack_external_size_f08
    end interface
    interface MPI_Op_commutative
        module procedure MPI_Op_commutative_f08
    end interface

    contains

        subroutine make_c_string(f, c)
            character(len=*), intent(in) :: f
            character(kind=c_char), allocatable, intent(out) :: c(:)
            integer :: i, n
            n = len(f)
            allocate(c(n + 1))
            c = c_null_char
            do i = 1, n
                c(i) = f(i:i)
            end do
        end subroutine make_c_string

#if defined(HAVE_CFI) || defined(HAVE_PGIF)
        subroutine MPI_Sendrecv_replace_f08ts(buf, count, datatype, dest, sendtag, source, recvtag, comm, status, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Status
            use mpi_direct_misc_c, only: VAPAA_MPI_Sendrecv_replace
            type(*), dimension(..), intent(inout) :: buf
!pgi$ ignore_tkr(c) buf
            integer, intent(in) :: count, dest, sendtag, source, recvtag
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Status), intent(out), target :: status
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Sendrecv_replace(buf, int(count,c_int), datatype % MPI_VAL, int(dest,c_int), &
                                            int(sendtag,c_int), int(source,c_int), int(recvtag,c_int), &
                                            comm % MPI_VAL, status, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Sendrecv_replace_f08ts

        subroutine MPI_Scan_f08ts(sendbuf, recvbuf, count, datatype, op, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Op
            use mpi_direct_misc_c, only: VAPAA_MPI_Scan
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Scan(sendbuf, recvbuf, int(count,c_int), datatype % MPI_VAL, op % MPI_VAL, &
                                comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Scan_f08ts

        subroutine MPI_Exscan_f08ts(sendbuf, recvbuf, count, datatype, op, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Op
            use mpi_direct_misc_c, only: VAPAA_MPI_Exscan
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Exscan(sendbuf, recvbuf, int(count,c_int), datatype % MPI_VAL, op % MPI_VAL, &
                                  comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Exscan_f08ts

        subroutine MPI_Reduce_scatter_f08ts(sendbuf, recvbuf, recvcounts, datatype, op, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Op
            use mpi_direct_misc_c, only: VAPAA_MPI_Reduce_scatter
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: recvcounts(*)
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Reduce_scatter(sendbuf, recvbuf, recvcounts, datatype % MPI_VAL, op % MPI_VAL, &
                                          comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Reduce_scatter_f08ts

        subroutine MPI_Reduce_scatter_block_f08ts(sendbuf, recvbuf, recvcount, datatype, op, comm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype, MPI_Op
            use mpi_direct_misc_c, only: VAPAA_MPI_Reduce_scatter_block
            type(*), dimension(..), intent(in) :: sendbuf
!pgi$ ignore_tkr(c) sendbuf
            type(*), dimension(..) :: recvbuf
!pgi$ ignore_tkr(c) recvbuf
            integer, intent(in) :: recvcount
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Comm), intent(in) :: comm
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Reduce_scatter_block(sendbuf, recvbuf, int(recvcount,c_int), datatype % MPI_VAL, &
                                                op % MPI_VAL, comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Reduce_scatter_block_f08ts

        subroutine MPI_Reduce_local_f08ts(inbuf, inoutbuf, count, datatype, op, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Op
            use mpi_direct_misc_c, only: VAPAA_MPI_Reduce_local
            type(*), dimension(..), intent(in) :: inbuf
!pgi$ ignore_tkr(c) inbuf
            type(*), dimension(..), intent(inout) :: inoutbuf
!pgi$ ignore_tkr(c) inoutbuf
            integer, intent(in) :: count
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            integer, optional, intent(out) :: ierror
            integer(c_int) :: ierror_c
            call VAPAA_MPI_Reduce_local(inbuf, inoutbuf, int(count,c_int), datatype % MPI_VAL, op % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Reduce_local_f08ts

        subroutine MPI_Pack_external_f08ts(datarep, inbuf, incount, datatype, outbuf, outsize, position, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_direct_misc_c, only: VAPAA_MPI_Pack_external
            character(len=*), intent(in) :: datarep
            type(*), dimension(..), intent(in) :: inbuf
!pgi$ ignore_tkr(c) inbuf
            integer, intent(in) :: incount
            type(MPI_Datatype), intent(in) :: datatype
            type(*), dimension(..) :: outbuf
!pgi$ ignore_tkr(c) outbuf
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: outsize
            integer(kind=MPI_ADDRESS_KIND), intent(inout) :: position
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: datarep_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(datarep, datarep_c)
            call VAPAA_MPI_Pack_external(datarep_c, inbuf, int(incount,c_int), datatype % MPI_VAL, outbuf, &
                                         int(outsize,c_intptr_t), position, ierror_c)
            if (present(ierror)) ierror = ierror_c
            deallocate(datarep_c)
        end subroutine MPI_Pack_external_f08ts

        subroutine MPI_Unpack_external_f08ts(datarep, inbuf, insize, position, outbuf, outcount, datatype, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_direct_misc_c, only: VAPAA_MPI_Unpack_external
            character(len=*), intent(in) :: datarep
            type(*), dimension(..), intent(in) :: inbuf
!pgi$ ignore_tkr(c) inbuf
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: insize
            integer(kind=MPI_ADDRESS_KIND), intent(inout) :: position
            type(*), dimension(..) :: outbuf
!pgi$ ignore_tkr(c) outbuf
            integer, intent(in) :: outcount
            type(MPI_Datatype), intent(in) :: datatype
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: datarep_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(datarep, datarep_c)
            call VAPAA_MPI_Unpack_external(datarep_c, inbuf, int(insize,c_intptr_t), position, outbuf, &
                                           int(outcount,c_int), datatype % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
            deallocate(datarep_c)
        end subroutine MPI_Unpack_external_f08ts
#endif

        subroutine MPI_Pack_size_f08(incount, datatype, comm, size, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Datatype
            use mpi_direct_misc_c, only: VAPAA_MPI_Pack_size
            integer, intent(in) :: incount
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(c_int) :: size_c, ierror_c
            call VAPAA_MPI_Pack_size(int(incount,c_int), datatype % MPI_VAL, comm % MPI_VAL, size_c, ierror_c)
            size = size_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Pack_size_f08

        subroutine MPI_Pack_external_size_f08(datarep, incount, datatype, size, ierror)
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_handle_types, only: MPI_Datatype
            use mpi_direct_misc_c, only: VAPAA_MPI_Pack_external_size
            character(len=*), intent(in) :: datarep
            integer, intent(in) :: incount
            type(MPI_Datatype), intent(in) :: datatype
            integer(kind=MPI_ADDRESS_KIND), intent(out) :: size
            integer, optional, intent(out) :: ierror
            character(kind=c_char), allocatable :: datarep_c(:)
            integer(c_int) :: ierror_c
            call make_c_string(datarep, datarep_c)
            call VAPAA_MPI_Pack_external_size(datarep_c, int(incount,c_int), datatype % MPI_VAL, size, ierror_c)
            if (present(ierror)) ierror = ierror_c
            deallocate(datarep_c)
        end subroutine MPI_Pack_external_size_f08

        subroutine MPI_Op_commutative_f08(op, commute, ierror)
            use mpi_handle_types, only: MPI_Op
            use mpi_direct_misc_c, only: VAPAA_MPI_Op_commutative
            type(MPI_Op), intent(in) :: op
            logical, intent(out) :: commute
            integer, optional, intent(out) :: ierror
            integer(c_int) :: commute_c, ierror_c
            call VAPAA_MPI_Op_commutative(op % MPI_VAL, commute_c, ierror_c)
            commute = commute_c /= 0
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Op_commutative_f08

end module mpi_direct_misc_f
