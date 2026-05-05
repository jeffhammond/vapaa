! SPDX-License-Identifier: MIT

module mpi_rma_c

    interface
        subroutine C_MPI_Get(origin_addr, origin_count, origin_datatype, &
                             target_rank, target_disp, target_count, target_datatype, &
                             win, ierror) &
                   bind(C,name="C_MPI_Get")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: origin_addr
            integer(kind=c_int), intent(in), value :: origin_count, origin_datatype
            integer(kind=c_int), intent(in), value :: target_rank, target_count, target_datatype
            integer(kind=c_intptr_t), intent(in), value :: target_disp
            integer(kind=c_int), intent(in), value :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Get
    end interface

    interface
        subroutine C_MPI_Put(origin_addr, origin_count, origin_datatype, &
                             target_rank, target_disp, target_count, target_datatype, &
                             win, ierror) &
                   bind(C,name="C_MPI_Put")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), intent(in), value :: origin_count, origin_datatype
            integer(kind=c_int), intent(in), value :: target_rank, target_count, target_datatype
            integer(kind=c_intptr_t), intent(in), value :: target_disp
            integer(kind=c_int), intent(in), value :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Put
    end interface

    interface
        subroutine C_MPI_Rget(origin_addr, origin_count, origin_datatype, &
                              target_rank, target_disp, target_count, target_datatype, &
                              win, request, ierror) &
                   bind(C,name="C_MPI_Rget")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: origin_addr
            integer(kind=c_int), intent(in), value :: origin_count, origin_datatype
            integer(kind=c_int), intent(in), value :: target_rank, target_count, target_datatype
            integer(kind=c_intptr_t), intent(in), value :: target_disp
            integer(kind=c_int), intent(in), value :: win
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Rget
    end interface

    interface
        subroutine C_MPI_Rput(origin_addr, origin_count, origin_datatype, &
                              target_rank, target_disp, target_count, target_datatype, &
                              win, request, ierror) &
                   bind(C,name="C_MPI_Rput")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), intent(in), value :: origin_count, origin_datatype
            integer(kind=c_int), intent(in), value :: target_rank, target_count, target_datatype
            integer(kind=c_intptr_t), intent(in), value :: target_disp
            integer(kind=c_int), intent(in), value :: win
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Rput
    end interface

    interface
        subroutine C_MPI_Accumulate(origin_addr, origin_count, origin_datatype, &
                                    target_rank, target_disp, target_count, target_datatype, &
                                    op, win, ierror) &
                   bind(C,name="C_MPI_Accumulate")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), intent(in), value :: origin_count, origin_datatype
            integer(kind=c_int), intent(in), value :: target_rank, target_count, target_datatype
            integer(kind=c_intptr_t), intent(in), value :: target_disp
            integer(kind=c_int), intent(in), value :: op, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Accumulate
    end interface

    interface
        subroutine C_MPI_Fetch_and_op(origin_addr, result_addr, datatype, &
                                      target_rank, target_disp, op, win, ierror) &
                   bind(C,name="C_MPI_Fetch_and_op")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: result_addr
            integer(kind=c_int), intent(in), value :: datatype, target_rank, op, win
            integer(kind=c_intptr_t), intent(in), value :: target_disp
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Fetch_and_op
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Get(origin_addr, origin_count, origin_datatype, &
                               target_rank, target_disp, target_count, target_datatype, &
                               win, ierror) &
                   bind(C,name="CFI_MPI_Get")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), asynchronous :: origin_addr
            integer(kind=c_int), intent(in), value :: origin_count, origin_datatype
            integer(kind=c_int), intent(in), value :: target_rank, target_count, target_datatype
            integer(kind=c_intptr_t), intent(in), value :: target_disp
            integer(kind=c_int), intent(in), value :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Get
    end interface

    interface
        subroutine CFI_MPI_Put(origin_addr, origin_count, origin_datatype, &
                               target_rank, target_disp, target_count, target_datatype, &
                               win, ierror) &
                   bind(C,name="CFI_MPI_Put")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), asynchronous :: origin_addr
            integer(kind=c_int), intent(in), value :: origin_count, origin_datatype
            integer(kind=c_int), intent(in), value :: target_rank, target_count, target_datatype
            integer(kind=c_intptr_t), intent(in), value :: target_disp
            integer(kind=c_int), intent(in), value :: win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Put
    end interface

    interface
        subroutine CFI_MPI_Rget(origin_addr, origin_count, origin_datatype, &
                                target_rank, target_disp, target_count, target_datatype, &
                                win, request, ierror) &
                   bind(C,name="CFI_MPI_Rget")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), asynchronous :: origin_addr
            integer(kind=c_int), intent(in), value :: origin_count, origin_datatype
            integer(kind=c_int), intent(in), value :: target_rank, target_count, target_datatype
            integer(kind=c_intptr_t), intent(in), value :: target_disp
            integer(kind=c_int), intent(in), value :: win
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Rget
    end interface

    interface
        subroutine CFI_MPI_Rput(origin_addr, origin_count, origin_datatype, &
                                target_rank, target_disp, target_count, target_datatype, &
                                win, request, ierror) &
                   bind(C,name="CFI_MPI_Rput")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), asynchronous :: origin_addr
            integer(kind=c_int), intent(in), value :: origin_count, origin_datatype
            integer(kind=c_int), intent(in), value :: target_rank, target_count, target_datatype
            integer(kind=c_intptr_t), intent(in), value :: target_disp
            integer(kind=c_int), intent(in), value :: win
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine CFI_MPI_Rput
    end interface

    interface
        subroutine CFI_MPI_Accumulate(origin_addr, origin_count, origin_datatype, &
                                      target_rank, target_disp, target_count, target_datatype, &
                                      op, win, ierror) &
                   bind(C,name="CFI_MPI_Accumulate")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), asynchronous :: origin_addr
            integer(kind=c_int), intent(in), value :: origin_count, origin_datatype
            integer(kind=c_int), intent(in), value :: target_rank, target_count, target_datatype
            integer(kind=c_intptr_t), intent(in), value :: target_disp
            integer(kind=c_int), intent(in), value :: op, win
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Accumulate
    end interface

    interface
        subroutine CFI_MPI_Fetch_and_op(origin_addr, result_addr, datatype, &
                                        target_rank, target_disp, op, win, ierror) &
                   bind(C,name="CFI_MPI_Fetch_and_op")
            use iso_c_binding, only: c_int, c_intptr_t
            implicit none
            type(*), dimension(..), asynchronous :: origin_addr
            type(*), dimension(..), asynchronous :: result_addr
            integer(kind=c_int), intent(in), value :: datatype, target_rank, op, win
            integer(kind=c_intptr_t), intent(in), value :: target_disp
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Fetch_and_op
    end interface
#endif

end module mpi_rma_c
