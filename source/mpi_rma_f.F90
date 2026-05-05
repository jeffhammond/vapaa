! SPDX-License-Identifier: MIT

#include "vapaa_constants.h"

module mpi_rma_f
    use iso_c_binding, only: c_int, c_intptr_t
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

    interface MPI_Get
        module procedure MPI_Get_f08
    end interface MPI_Get

    interface MPI_Put
        module procedure MPI_Put_f08
    end interface MPI_Put

    interface MPI_Rget
        module procedure MPI_Rget_f08
    end interface MPI_Rget

    interface MPI_Rput
        module procedure MPI_Rput_f08
    end interface MPI_Rput

    interface MPI_Accumulate
        module procedure MPI_Accumulate_f08
    end interface MPI_Accumulate

    interface MPI_Fetch_and_op
        module procedure MPI_Fetch_and_op_f08
    end interface MPI_Fetch_and_op

    contains

        subroutine MPI_Get_f08(origin_addr, origin_count, origin_datatype, &
                               target_rank, target_disp, target_count, target_datatype, &
                               win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win
            use mpi_rma_c, only: C_MPI_Get
!dir$ ignore_tkr origin_addr
            integer, dimension(*), intent(out), asynchronous :: origin_addr
            integer, intent(in) :: origin_count, target_rank, target_count
            integer(kind=c_intptr_t), intent(in) :: target_disp
            type(MPI_Datatype), intent(in) :: origin_datatype, target_datatype
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c, target_count_c, ierror_c
            integer(kind=c_intptr_t) :: target_disp_c
            origin_count_c = origin_count
            target_rank_c  = target_rank
            target_count_c = target_count
            target_disp_c  = target_disp
            call C_MPI_Get(origin_addr, origin_count_c, origin_datatype % MPI_VAL, &
                           target_rank_c, target_disp_c, target_count_c, target_datatype % MPI_VAL, &
                           win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_f08

        subroutine MPI_Put_f08(origin_addr, origin_count, origin_datatype, &
                               target_rank, target_disp, target_count, target_datatype, &
                               win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win
            use mpi_rma_c, only: C_MPI_Put
!dir$ ignore_tkr origin_addr
            integer, dimension(*), intent(in), asynchronous :: origin_addr
            integer, intent(in) :: origin_count, target_rank, target_count
            integer(kind=c_intptr_t), intent(in) :: target_disp
            type(MPI_Datatype), intent(in) :: origin_datatype, target_datatype
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c, target_count_c, ierror_c
            integer(kind=c_intptr_t) :: target_disp_c
            origin_count_c = origin_count
            target_rank_c  = target_rank
            target_count_c = target_count
            target_disp_c  = target_disp
            call C_MPI_Put(origin_addr, origin_count_c, origin_datatype % MPI_VAL, &
                           target_rank_c, target_disp_c, target_count_c, target_datatype % MPI_VAL, &
                           win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Put_f08

        subroutine MPI_Rget_f08(origin_addr, origin_count, origin_datatype, &
                                target_rank, target_disp, target_count, target_datatype, &
                                win, request, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win, MPI_Request
            use mpi_rma_c, only: C_MPI_Rget
!dir$ ignore_tkr origin_addr
            integer, dimension(*), intent(out), asynchronous :: origin_addr
            integer, intent(in) :: origin_count, target_rank, target_count
            integer(kind=c_intptr_t), intent(in) :: target_disp
            type(MPI_Datatype), intent(in) :: origin_datatype, target_datatype
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c, target_count_c, ierror_c
            integer(kind=c_intptr_t) :: target_disp_c
            origin_count_c = origin_count
            target_rank_c  = target_rank
            target_count_c = target_count
            target_disp_c  = target_disp
            call C_MPI_Rget(origin_addr, origin_count_c, origin_datatype % MPI_VAL, &
                            target_rank_c, target_disp_c, target_count_c, target_datatype % MPI_VAL, &
                            win % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Rget_f08

        subroutine MPI_Rput_f08(origin_addr, origin_count, origin_datatype, &
                                target_rank, target_disp, target_count, target_datatype, &
                                win, request, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win, MPI_Request
            use mpi_rma_c, only: C_MPI_Rput
!dir$ ignore_tkr origin_addr
            integer, dimension(*), intent(in), asynchronous :: origin_addr
            integer, intent(in) :: origin_count, target_rank, target_count
            integer(kind=c_intptr_t), intent(in) :: target_disp
            type(MPI_Datatype), intent(in) :: origin_datatype, target_datatype
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c, target_count_c, ierror_c
            integer(kind=c_intptr_t) :: target_disp_c
            origin_count_c = origin_count
            target_rank_c  = target_rank
            target_count_c = target_count
            target_disp_c  = target_disp
            call C_MPI_Rput(origin_addr, origin_count_c, origin_datatype % MPI_VAL, &
                            target_rank_c, target_disp_c, target_count_c, target_datatype % MPI_VAL, &
                            win % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Rput_f08

        subroutine MPI_Accumulate_f08(origin_addr, origin_count, origin_datatype, &
                                      target_rank, target_disp, target_count, target_datatype, &
                                      op, win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win
            use mpi_rma_c, only: C_MPI_Accumulate
!dir$ ignore_tkr origin_addr
            integer, dimension(*), intent(in), asynchronous :: origin_addr
            integer, intent(in) :: origin_count, target_rank, target_count
            integer(kind=c_intptr_t), intent(in) :: target_disp
            type(MPI_Datatype), intent(in) :: origin_datatype, target_datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c, target_count_c, ierror_c
            integer(kind=c_intptr_t) :: target_disp_c
            origin_count_c = origin_count
            target_rank_c  = target_rank
            target_count_c = target_count
            target_disp_c  = target_disp
            call C_MPI_Accumulate(origin_addr, origin_count_c, origin_datatype % MPI_VAL, &
                                  target_rank_c, target_disp_c, target_count_c, target_datatype % MPI_VAL, &
                                  op % MPI_VAL, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Accumulate_f08

        subroutine MPI_Fetch_and_op_f08(origin_addr, result_addr, datatype, &
                                        target_rank, target_disp, op, win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win
            use mpi_rma_c, only: C_MPI_Fetch_and_op
!dir$ ignore_tkr origin_addr, result_addr
            integer, dimension(*), intent(in), asynchronous :: origin_addr
            integer, dimension(*), intent(out), asynchronous :: result_addr
            integer, intent(in) :: target_rank
            integer(kind=c_intptr_t), intent(in) :: target_disp
            type(MPI_Datatype), intent(in) :: datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: target_rank_c, ierror_c
            integer(kind=c_intptr_t) :: target_disp_c
            target_rank_c = target_rank
            target_disp_c = target_disp
            call C_MPI_Fetch_and_op(origin_addr, result_addr, datatype % MPI_VAL, &
                                    target_rank_c, target_disp_c, op % MPI_VAL, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Fetch_and_op_f08

end module mpi_rma_f
