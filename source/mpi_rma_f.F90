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

    interface MPI_Compare_and_swap
#ifdef HAVE_CFI
        module procedure MPI_Compare_and_swap_f08ts
#else
        module procedure MPI_Compare_and_swap_f08
#endif
    end interface MPI_Compare_and_swap

    interface MPI_Fetch_and_op
#ifdef HAVE_CFI
        module procedure MPI_Fetch_and_op_f08ts
#else
        module procedure MPI_Fetch_and_op_f08
#endif
    end interface MPI_Fetch_and_op

    interface MPI_Put
#ifdef HAVE_CFI
        module procedure MPI_Put_f08ts
#else
        module procedure MPI_Put_f08
#endif
    end interface MPI_Put

    interface MPI_Get
#ifdef HAVE_CFI
        module procedure MPI_Get_f08ts
#else
        module procedure MPI_Get_f08
#endif
    end interface MPI_Get

    interface MPI_Accumulate
#ifdef HAVE_CFI
        module procedure MPI_Accumulate_f08ts
#else
        module procedure MPI_Accumulate_f08
#endif
    end interface MPI_Accumulate

    interface MPI_Get_accumulate
#ifdef HAVE_CFI
        module procedure MPI_Get_accumulate_f08ts
#else
        module procedure MPI_Get_accumulate_f08
#endif
    end interface MPI_Get_accumulate

    interface MPI_Rput
#ifdef HAVE_CFI
        module procedure MPI_Rput_f08ts
#else
        module procedure MPI_Rput_f08
#endif
    end interface MPI_Rput

    interface MPI_Rget
#ifdef HAVE_CFI
        module procedure MPI_Rget_f08ts
#else
        module procedure MPI_Rget_f08
#endif
    end interface MPI_Rget

    interface MPI_Raccumulate
#ifdef HAVE_CFI
        module procedure MPI_Raccumulate_f08ts
#else
        module procedure MPI_Raccumulate_f08
#endif
    end interface MPI_Raccumulate

    interface MPI_Rget_accumulate
#ifdef HAVE_CFI
        module procedure MPI_Rget_accumulate_f08ts
#else
        module procedure MPI_Rget_accumulate_f08
#endif
    end interface MPI_Rget_accumulate

    contains

        subroutine MPI_Compare_and_swap_f08(origin_addr, compare_addr, result_addr, &
                                           datatype, target_rank, target_disp, &
                                           win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: C_MPI_Compare_and_swap
!dir$ ignore_tkr origin_addr, compare_addr, result_addr
            integer, dimension(*), intent(in) :: origin_addr
            integer, dimension(*), intent(in) :: compare_addr
            integer, dimension(*), intent(out) :: result_addr
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: target_rank_c, ierror_c

            target_rank_c = target_rank

            call C_MPI_Compare_and_swap(origin_addr, compare_addr, result_addr, &
                                       datatype % MPI_VAL, target_rank_c, &
                                       target_disp, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Compare_and_swap_f08

#ifdef HAVE_CFI
        subroutine MPI_Compare_and_swap_f08ts(origin_addr, compare_addr, result_addr, &
                                             datatype, target_rank, target_disp, &
                                             win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: CFI_MPI_Compare_and_swap
            type(*), dimension(..), intent(in) :: origin_addr
            type(*), dimension(..), intent(in) :: compare_addr
            type(*), dimension(..), intent(inout) :: result_addr
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: target_rank_c, ierror_c

            target_rank_c = target_rank

            call CFI_MPI_Compare_and_swap(origin_addr, compare_addr, result_addr, &
                                         datatype % MPI_VAL, target_rank_c, &
                                         target_disp, win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Compare_and_swap_f08ts
#endif

        subroutine MPI_Fetch_and_op_f08(origin_addr, result_addr, datatype, &
                                       target_rank, target_disp, op, win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: C_MPI_Fetch_and_op
!dir$ ignore_tkr origin_addr, result_addr
            integer, dimension(*), intent(in) :: origin_addr
            integer, dimension(*), intent(out) :: result_addr
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: target_rank_c, ierror_c

            target_rank_c = target_rank

            call C_MPI_Fetch_and_op(origin_addr, result_addr, datatype % MPI_VAL, &
                                   target_rank_c, target_disp, op % MPI_VAL, &
                                   win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Fetch_and_op_f08

#ifdef HAVE_CFI
        subroutine MPI_Fetch_and_op_f08ts(origin_addr, result_addr, datatype, &
                                         target_rank, target_disp, op, win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: CFI_MPI_Fetch_and_op
            type(*), dimension(..), intent(in) :: origin_addr
            type(*), dimension(..), intent(inout) :: result_addr
            type(MPI_Datatype), intent(in) :: datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: target_rank_c, ierror_c

            target_rank_c = target_rank

            call CFI_MPI_Fetch_and_op(origin_addr, result_addr, datatype % MPI_VAL, &
                                     target_rank_c, target_disp, op % MPI_VAL, &
                                     win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Fetch_and_op_f08ts
#endif

        subroutine MPI_Put_f08(origin_addr, origin_count, origin_datatype, &
                              target_rank, target_disp, target_count, &
                              target_datatype, win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: C_MPI_Put
!dir$ ignore_tkr origin_addr
            integer, dimension(*), intent(in) :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, ierror_c

            origin_count_c = origin_count
            target_rank_c = target_rank
            target_count_c = target_count

            call C_MPI_Put(origin_addr, origin_count_c, &
                          origin_datatype % MPI_VAL, target_rank_c, &
                          target_disp, target_count_c, &
                          target_datatype % MPI_VAL, win % MPI_VAL, &
                          ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Put_f08

        subroutine MPI_Get_f08(origin_addr, origin_count, origin_datatype, &
                              target_rank, target_disp, target_count, &
                              target_datatype, win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: C_MPI_Get
!dir$ ignore_tkr origin_addr
            integer, dimension(*), intent(out) :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, ierror_c

            origin_count_c = origin_count
            target_rank_c = target_rank
            target_count_c = target_count

            call C_MPI_Get(origin_addr, origin_count_c, &
                          origin_datatype % MPI_VAL, target_rank_c, &
                          target_disp, target_count_c, &
                          target_datatype % MPI_VAL, win % MPI_VAL, &
                          ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_f08

        subroutine MPI_Accumulate_f08(origin_addr, origin_count, origin_datatype, &
                                     target_rank, target_disp, target_count, &
                                     target_datatype, op, win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: C_MPI_Accumulate
!dir$ ignore_tkr origin_addr
            integer, dimension(*), intent(in) :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, ierror_c

            origin_count_c = origin_count
            target_rank_c = target_rank
            target_count_c = target_count

            call C_MPI_Accumulate(origin_addr, origin_count_c, &
                                 origin_datatype % MPI_VAL, target_rank_c, &
                                 target_disp, target_count_c, &
                                 target_datatype % MPI_VAL, op % MPI_VAL, &
                                 win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Accumulate_f08

        subroutine MPI_Get_accumulate_f08(origin_addr, origin_count, origin_datatype, &
                                         result_addr, result_count, result_datatype, &
                                         target_rank, target_disp, target_count, &
                                         target_datatype, op, win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: C_MPI_Get_accumulate
!dir$ ignore_tkr origin_addr, result_addr
            integer, dimension(*), intent(in) :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, dimension(*), intent(out) :: result_addr
            integer, intent(in) :: result_count
            type(MPI_Datatype), intent(in) :: result_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, result_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, ierror_c

            origin_count_c = origin_count
            result_count_c = result_count
            target_rank_c = target_rank
            target_count_c = target_count

            call C_MPI_Get_accumulate(origin_addr, origin_count_c, &
                                     origin_datatype % MPI_VAL, &
                                     result_addr, result_count_c, &
                                     result_datatype % MPI_VAL, &
                                     target_rank_c, target_disp, target_count_c, &
                                     target_datatype % MPI_VAL, op % MPI_VAL, &
                                     win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_accumulate_f08

#ifdef HAVE_CFI
        subroutine MPI_Put_f08ts(origin_addr, origin_count, origin_datatype, &
                                target_rank, target_disp, target_count, &
                                target_datatype, win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: CFI_MPI_Put
            type(*), dimension(..), intent(in) :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, ierror_c

            origin_count_c = origin_count
            target_rank_c = target_rank
            target_count_c = target_count

            call CFI_MPI_Put(origin_addr, origin_count_c, &
                            origin_datatype % MPI_VAL, target_rank_c, &
                            target_disp, target_count_c, &
                            target_datatype % MPI_VAL, win % MPI_VAL, &
                            ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Put_f08ts

        subroutine MPI_Get_f08ts(origin_addr, origin_count, origin_datatype, &
                                target_rank, target_disp, target_count, &
                                target_datatype, win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: CFI_MPI_Get
            type(*), dimension(..), intent(inout) :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, ierror_c

            origin_count_c = origin_count
            target_rank_c = target_rank
            target_count_c = target_count

            call CFI_MPI_Get(origin_addr, origin_count_c, &
                            origin_datatype % MPI_VAL, target_rank_c, &
                            target_disp, target_count_c, &
                            target_datatype % MPI_VAL, win % MPI_VAL, &
                            ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_f08ts

        subroutine MPI_Accumulate_f08ts(origin_addr, origin_count, origin_datatype, &
                                       target_rank, target_disp, target_count, &
                                       target_datatype, op, win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: CFI_MPI_Accumulate
            type(*), dimension(..), intent(in) :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, ierror_c

            origin_count_c = origin_count
            target_rank_c = target_rank
            target_count_c = target_count

            call CFI_MPI_Accumulate(origin_addr, origin_count_c, &
                                   origin_datatype % MPI_VAL, target_rank_c, &
                                   target_disp, target_count_c, &
                                   target_datatype % MPI_VAL, op % MPI_VAL, &
                                   win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Accumulate_f08ts

        subroutine MPI_Get_accumulate_f08ts(origin_addr, origin_count, origin_datatype, &
                                           result_addr, result_count, result_datatype, &
                                           target_rank, target_disp, target_count, &
                                           target_datatype, op, win, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: CFI_MPI_Get_accumulate
            type(*), dimension(..), intent(in) :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            type(*), dimension(..), intent(inout) :: result_addr
            integer, intent(in) :: result_count
            type(MPI_Datatype), intent(in) :: result_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, result_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, ierror_c

            origin_count_c = origin_count
            result_count_c = result_count
            target_rank_c = target_rank
            target_count_c = target_count

            call CFI_MPI_Get_accumulate(origin_addr, origin_count_c, &
                                       origin_datatype % MPI_VAL, &
                                       result_addr, result_count_c, &
                                       result_datatype % MPI_VAL, &
                                       target_rank_c, target_disp, target_count_c, &
                                       target_datatype % MPI_VAL, op % MPI_VAL, &
                                       win % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Get_accumulate_f08ts
#endif

        subroutine MPI_Rput_f08(origin_addr, origin_count, origin_datatype, &
                               target_rank, target_disp, target_count, &
                               target_datatype, win, request, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win, MPI_Request
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: C_MPI_Rput
!dir$ ignore_tkr origin_addr
            integer, dimension(*), intent(in), asynchronous :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, request_c, ierror_c

            origin_count_c = origin_count
            target_rank_c = target_rank
            target_count_c = target_count

            call C_MPI_Rput(origin_addr, origin_count_c, &
                           origin_datatype % MPI_VAL, target_rank_c, &
                           target_disp, target_count_c, &
                           target_datatype % MPI_VAL, win % MPI_VAL, &
                           request_c, ierror_c)
            request % MPI_VAL = request_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Rput_f08

        subroutine MPI_Rget_f08(origin_addr, origin_count, origin_datatype, &
                               target_rank, target_disp, target_count, &
                               target_datatype, win, request, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win, MPI_Request
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: C_MPI_Rget
!dir$ ignore_tkr origin_addr
            integer, dimension(*), intent(out), asynchronous :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, request_c, ierror_c

            origin_count_c = origin_count
            target_rank_c = target_rank
            target_count_c = target_count

            call C_MPI_Rget(origin_addr, origin_count_c, &
                           origin_datatype % MPI_VAL, target_rank_c, &
                           target_disp, target_count_c, &
                           target_datatype % MPI_VAL, win % MPI_VAL, &
                           request_c, ierror_c)
            request % MPI_VAL = request_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Rget_f08

        subroutine MPI_Raccumulate_f08(origin_addr, origin_count, origin_datatype, &
                                      target_rank, target_disp, target_count, &
                                      target_datatype, op, win, request, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win, MPI_Request
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: C_MPI_Raccumulate
!dir$ ignore_tkr origin_addr
            integer, dimension(*), intent(in), asynchronous :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, request_c, ierror_c

            origin_count_c = origin_count
            target_rank_c = target_rank
            target_count_c = target_count

            call C_MPI_Raccumulate(origin_addr, origin_count_c, &
                                  origin_datatype % MPI_VAL, target_rank_c, &
                                  target_disp, target_count_c, &
                                  target_datatype % MPI_VAL, op % MPI_VAL, &
                                  win % MPI_VAL, request_c, ierror_c)
            request % MPI_VAL = request_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Raccumulate_f08

        subroutine MPI_Rget_accumulate_f08(origin_addr, origin_count, origin_datatype, &
                                          result_addr, result_count, result_datatype, &
                                          target_rank, target_disp, target_count, &
                                          target_datatype, op, win, request, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win, MPI_Request
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: C_MPI_Rget_accumulate
!dir$ ignore_tkr origin_addr, result_addr
            integer, dimension(*), intent(in), asynchronous :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, dimension(*), intent(out), asynchronous :: result_addr
            integer, intent(in) :: result_count
            type(MPI_Datatype), intent(in) :: result_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, result_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, request_c, ierror_c

            origin_count_c = origin_count
            result_count_c = result_count
            target_rank_c = target_rank
            target_count_c = target_count

            call C_MPI_Rget_accumulate(origin_addr, origin_count_c, &
                                      origin_datatype % MPI_VAL, &
                                      result_addr, result_count_c, &
                                      result_datatype % MPI_VAL, &
                                      target_rank_c, target_disp, target_count_c, &
                                      target_datatype % MPI_VAL, op % MPI_VAL, &
                                      win % MPI_VAL, request_c, ierror_c)
            request % MPI_VAL = request_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Rget_accumulate_f08

#ifdef HAVE_CFI
        subroutine MPI_Rput_f08ts(origin_addr, origin_count, origin_datatype, &
                                 target_rank, target_disp, target_count, &
                                 target_datatype, win, request, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win, MPI_Request
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: CFI_MPI_Rput
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, request_c, ierror_c

            origin_count_c = origin_count
            target_rank_c = target_rank
            target_count_c = target_count

            call CFI_MPI_Rput(origin_addr, origin_count_c, &
                             origin_datatype % MPI_VAL, target_rank_c, &
                             target_disp, target_count_c, &
                             target_datatype % MPI_VAL, win % MPI_VAL, &
                             request_c, ierror_c)
            request % MPI_VAL = request_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Rput_f08ts

        subroutine MPI_Rget_f08ts(origin_addr, origin_count, origin_datatype, &
                                 target_rank, target_disp, target_count, &
                                 target_datatype, win, request, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Win, MPI_Request
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: CFI_MPI_Rget
            type(*), dimension(..), intent(inout), asynchronous :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, request_c, ierror_c

            origin_count_c = origin_count
            target_rank_c = target_rank
            target_count_c = target_count

            call CFI_MPI_Rget(origin_addr, origin_count_c, &
                             origin_datatype % MPI_VAL, target_rank_c, &
                             target_disp, target_count_c, &
                             target_datatype % MPI_VAL, win % MPI_VAL, &
                             request_c, ierror_c)
            request % MPI_VAL = request_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Rget_f08ts

        subroutine MPI_Raccumulate_f08ts(origin_addr, origin_count, origin_datatype, &
                                        target_rank, target_disp, target_count, &
                                        target_datatype, op, win, request, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win, MPI_Request
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: CFI_MPI_Raccumulate
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, request_c, ierror_c

            origin_count_c = origin_count
            target_rank_c = target_rank
            target_count_c = target_count

            call CFI_MPI_Raccumulate(origin_addr, origin_count_c, &
                                    origin_datatype % MPI_VAL, target_rank_c, &
                                    target_disp, target_count_c, &
                                    target_datatype % MPI_VAL, op % MPI_VAL, &
                                    win % MPI_VAL, request_c, ierror_c)
            request % MPI_VAL = request_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Raccumulate_f08ts

        subroutine MPI_Rget_accumulate_f08ts(origin_addr, origin_count, origin_datatype, &
                                            result_addr, result_count, result_datatype, &
                                            target_rank, target_disp, target_count, &
                                            target_datatype, op, win, request, ierror)
            use mpi_handle_types, only: MPI_Datatype, MPI_Op, MPI_Win, MPI_Request
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            use mpi_rma_c, only: CFI_MPI_Rget_accumulate
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer, intent(in) :: origin_count
            type(MPI_Datatype), intent(in) :: origin_datatype
            type(*), dimension(..), intent(inout), asynchronous :: result_addr
            integer, intent(in) :: result_count
            type(MPI_Datatype), intent(in) :: result_datatype
            integer, intent(in) :: target_rank
            integer(kind=MPI_ADDRESS_KIND), intent(in) :: target_disp
            integer, intent(in) :: target_count
            type(MPI_Datatype), intent(in) :: target_datatype
            type(MPI_Op), intent(in) :: op
            type(MPI_Win), intent(in) :: win
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: origin_count_c, result_count_c, target_rank_c
            integer(kind=c_int) :: target_count_c, request_c, ierror_c

            origin_count_c = origin_count
            result_count_c = result_count
            target_rank_c = target_rank
            target_count_c = target_count

            call CFI_MPI_Rget_accumulate(origin_addr, origin_count_c, &
                                        origin_datatype % MPI_VAL, &
                                        result_addr, result_count_c, &
                                        result_datatype % MPI_VAL, &
                                        target_rank_c, target_disp, target_count_c, &
                                        target_datatype % MPI_VAL, op % MPI_VAL, &
                                        win % MPI_VAL, request_c, ierror_c)
            request % MPI_VAL = request_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Rget_accumulate_f08ts
#endif

end module mpi_rma_f
