module mpi_rma_c
    use, intrinsic :: iso_c_binding

    interface
        subroutine C_MPI_Compare_and_swap(origin_addr, compare_addr, result_addr, &
                                         datatype, target_rank, target_disp, &
                                         win, ierror) &
                                         bind(C, name="C_MPI_Compare_and_swap")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: compare_addr
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: result_addr
            integer(kind=c_int), value :: datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Compare_and_swap

#ifdef HAVE_CFI
        subroutine CFI_MPI_Compare_and_swap(origin_addr, compare_addr, result_addr, &
                                           datatype, target_rank, target_disp, &
                                           win, ierror) &
                                           bind(C, name="CFI_MPI_Compare_and_swap")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            type(*), dimension(..), intent(in), asynchronous :: compare_addr
            type(*), dimension(..), intent(inout), asynchronous :: result_addr
            integer(kind=c_int), value :: datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Compare_and_swap
#endif

        subroutine C_MPI_Fetch_and_op(origin_addr, result_addr, datatype, &
                                     target_rank, target_disp, op, win, ierror) &
                                     bind(C, name="C_MPI_Fetch_and_op")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: result_addr
            integer(kind=c_int), value :: datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: op
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Fetch_and_op

#ifdef HAVE_CFI
        subroutine CFI_MPI_Fetch_and_op(origin_addr, result_addr, datatype, &
                                       target_rank, target_disp, op, win, ierror) &
                                       bind(C, name="CFI_MPI_Fetch_and_op")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            type(*), dimension(..), intent(inout), asynchronous :: result_addr
            integer(kind=c_int), value :: datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: op
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Fetch_and_op
#endif

    end interface

    interface
        subroutine C_MPI_Put(origin_addr, origin_count, origin_datatype, &
                            target_rank, target_disp, target_count, target_datatype, &
                            win, ierror) &
                            bind(C, name="C_MPI_Put")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Put

#ifdef HAVE_CFI
        subroutine CFI_MPI_Put(origin_addr, origin_count, origin_datatype, &
                              target_rank, target_disp, target_count, &
                              target_datatype, win, ierror) &
                              bind(C, name="CFI_MPI_Put")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Put
#endif

    end interface

    interface
        subroutine C_MPI_Get(origin_addr, origin_count, origin_datatype, &
                            target_rank, target_disp, target_count, target_datatype, &
                            win, ierror) &
                            bind(C, name="C_MPI_Get")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Get

#ifdef HAVE_CFI
        subroutine CFI_MPI_Get(origin_addr, origin_count, origin_datatype, &
                              target_rank, target_disp, target_count, &
                              target_datatype, win, ierror) &
                              bind(C, name="CFI_MPI_Get")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            type(*), dimension(..), intent(inout), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Get
#endif

    end interface

    interface
        subroutine C_MPI_Accumulate(origin_addr, origin_count, origin_datatype, &
                                   target_rank, target_disp, target_count, &
                                   target_datatype, op, win, ierror) &
                                   bind(C, name="C_MPI_Accumulate")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: op
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Accumulate

        subroutine C_MPI_Get_accumulate(origin_addr, origin_count, origin_datatype, &
                                       result_addr, result_count, result_datatype, &
                                       target_rank, target_disp, target_count, &
                                       target_datatype, op, win, ierror) &
                                       bind(C, name="C_MPI_Get_accumulate")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: result_addr
            integer(kind=c_int), value :: result_count
            integer(kind=c_int), value :: result_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: op
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Get_accumulate

#ifdef HAVE_CFI
        subroutine CFI_MPI_Accumulate(origin_addr, origin_count, origin_datatype, &
                                     target_rank, target_disp, target_count, &
                                     target_datatype, op, win, ierror) &
                                     bind(C, name="CFI_MPI_Accumulate")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: op
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Accumulate

        subroutine CFI_MPI_Get_accumulate(origin_addr, origin_count, origin_datatype, &
                                         result_addr, result_count, result_datatype, &
                                         target_rank, target_disp, target_count, &
                                         target_datatype, op, win, ierror) &
                                         bind(C, name="CFI_MPI_Get_accumulate")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            type(*), dimension(..), intent(inout), asynchronous :: result_addr
            integer(kind=c_int), value :: result_count
            integer(kind=c_int), value :: result_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: op
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Get_accumulate
#endif

    end interface

    interface
        subroutine C_MPI_Rput(origin_addr, origin_count, origin_datatype, &
                             target_rank, target_disp, target_count, &
                             target_datatype, win, request, ierror) &
                             bind(C, name="C_MPI_Rput")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: request
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Rput

        subroutine C_MPI_Rget(origin_addr, origin_count, origin_datatype, &
                             target_rank, target_disp, target_count, &
                             target_datatype, win, request, ierror) &
                             bind(C, name="C_MPI_Rget")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: request
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Rget

        subroutine C_MPI_Raccumulate(origin_addr, origin_count, origin_datatype, &
                                    target_rank, target_disp, target_count, &
                                    target_datatype, op, win, request, ierror) &
                                    bind(C, name="C_MPI_Raccumulate")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: op
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: request
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Raccumulate

        subroutine C_MPI_Rget_accumulate(origin_addr, origin_count, origin_datatype, &
                                        result_addr, result_count, result_datatype, &
                                        target_rank, target_disp, target_count, &
                                        target_datatype, op, win, request, ierror) &
                                        bind(C, name="C_MPI_Rget_accumulate")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: result_addr
            integer(kind=c_int), value :: result_count
            integer(kind=c_int), value :: result_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: op
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: request
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Rget_accumulate

#ifdef HAVE_CFI
        subroutine CFI_MPI_Rput(origin_addr, origin_count, origin_datatype, &
                               target_rank, target_disp, target_count, &
                               target_datatype, win, request, ierror) &
                               bind(C, name="CFI_MPI_Rput")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: request
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Rput

        subroutine CFI_MPI_Rget(origin_addr, origin_count, origin_datatype, &
                               target_rank, target_disp, target_count, &
                               target_datatype, win, request, ierror) &
                               bind(C, name="CFI_MPI_Rget")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            type(*), dimension(..), intent(inout), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: request
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Rget

        subroutine CFI_MPI_Raccumulate(origin_addr, origin_count, origin_datatype, &
                                      target_rank, target_disp, target_count, &
                                      target_datatype, op, win, request, ierror) &
                                      bind(C, name="CFI_MPI_Raccumulate")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: op
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: request
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Raccumulate

        subroutine CFI_MPI_Rget_accumulate(origin_addr, origin_count, origin_datatype, &
                                          result_addr, result_count, result_datatype, &
                                          target_rank, target_disp, target_count, &
                                          target_datatype, op, win, request, ierror) &
                                          bind(C, name="CFI_MPI_Rget_accumulate")
            use, intrinsic :: iso_c_binding
            use mpi_global_constants, only: MPI_ADDRESS_KIND
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            type(*), dimension(..), intent(inout), asynchronous :: result_addr
            integer(kind=c_int), value :: result_count
            integer(kind=c_int), value :: result_datatype
            integer(kind=c_int), value :: target_rank
            integer(kind=MPI_ADDRESS_KIND), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: op
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: request
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Rget_accumulate
#endif

    end interface

end module mpi_rma_c
