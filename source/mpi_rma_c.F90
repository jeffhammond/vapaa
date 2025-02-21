module mpi_rma_c
    use, intrinsic :: iso_c_binding

    interface
        subroutine C_MPI_Compare_and_swap(origin_addr, compare_addr, result_addr, &
                                         datatype, target_rank, target_disp, &
                                         win, ierror) &
                                         bind(C, name="C_MPI_Compare_and_swap")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: compare_addr
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: result_addr
            integer(kind=c_int), value :: datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Compare_and_swap

        subroutine C_MPI_Fetch_and_op(origin_addr, result_addr, datatype, &
                                     target_rank, target_disp, op, win, ierror) &
                                     bind(C, name="C_MPI_Fetch_and_op")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: result_addr
            integer(kind=c_int), value :: datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
            integer(kind=c_int), value :: op
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Fetch_and_op

#ifdef HAVE_CFI
        subroutine CFI_MPI_Compare_and_swap(origin_addr, compare_addr, result_addr, &
                                           datatype, target_rank, target_disp, &
                                           win, ierror) &
                                           bind(C, name="CFI_MPI_Compare_and_swap")
            use, intrinsic :: iso_c_binding
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            type(*), dimension(..), intent(in), asynchronous :: compare_addr
            type(*), dimension(..), intent(inout), asynchronous :: result_addr
            integer(kind=c_int), value :: datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Compare_and_swap

        subroutine CFI_MPI_Fetch_and_op(origin_addr, result_addr, datatype, &
                                       target_rank, target_disp, op, win, ierror) &
                                       bind(C, name="CFI_MPI_Fetch_and_op")
            use, intrinsic :: iso_c_binding
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            type(*), dimension(..), intent(inout), asynchronous :: result_addr
            integer(kind=c_int), value :: datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            type(*), dimension(..), intent(inout), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: result_addr
            integer(kind=c_int), value :: result_count
            integer(kind=c_int), value :: result_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            type(*), dimension(..), intent(inout), asynchronous :: result_addr
            integer(kind=c_int), value :: result_count
            integer(kind=c_int), value :: result_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            integer(kind=c_int), dimension(*), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), dimension(*), intent(out), asynchronous :: result_addr
            integer(kind=c_int), value :: result_count
            integer(kind=c_int), value :: result_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            type(*), dimension(..), intent(inout), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
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
            type(*), dimension(..), intent(in), asynchronous :: origin_addr
            integer(kind=c_int), value :: origin_count
            integer(kind=c_int), value :: origin_datatype
            type(*), dimension(..), intent(inout), asynchronous :: result_addr
            integer(kind=c_int), value :: result_count
            integer(kind=c_int), value :: result_datatype
            integer(kind=c_int), value :: target_rank
            integer(c_int64_t), value :: target_disp
            integer(kind=c_int), value :: target_count
            integer(kind=c_int), value :: target_datatype
            integer(kind=c_int), value :: op
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: request
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Rget_accumulate
#endif

    end interface

    interface
        ! Window synchronization
        subroutine C_MPI_Win_fence(assert, win, ierror) &
                                  bind(C, name="C_MPI_Win_fence")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: assert
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_fence

        subroutine C_MPI_Win_start(group, assert, win, ierror) &
                                  bind(C, name="C_MPI_Win_start")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: group
            integer(kind=c_int), value :: assert
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_start

        subroutine C_MPI_Win_complete(win, ierror) &
                                     bind(C, name="C_MPI_Win_complete")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_complete

        subroutine C_MPI_Win_post(group, assert, win, ierror) &
                                 bind(C, name="C_MPI_Win_post")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: group
            integer(kind=c_int), value :: assert
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_post

        subroutine C_MPI_Win_wait(win, ierror) &
                                 bind(C, name="C_MPI_Win_wait")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_wait

        subroutine C_MPI_Win_test(win, flag, ierror) &
                                 bind(C, name="C_MPI_Win_test")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: flag
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_test

        ! Lock/unlock
        subroutine C_MPI_Win_lock(lock_type, rank, assert, win, ierror) &
                                 bind(C, name="C_MPI_Win_lock")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: lock_type
            integer(kind=c_int), value :: rank
            integer(kind=c_int), value :: assert
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_lock

        subroutine C_MPI_Win_unlock(rank, win, ierror) &
                                   bind(C, name="C_MPI_Win_unlock")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: rank
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_unlock

        subroutine C_MPI_Win_lock_all(assert, win, ierror) &
                                     bind(C, name="C_MPI_Win_lock_all")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: assert
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_lock_all

        subroutine C_MPI_Win_unlock_all(win, ierror) &
                                       bind(C, name="C_MPI_Win_unlock_all")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_unlock_all

        ! Flush operations
        subroutine C_MPI_Win_flush(rank, win, ierror) &
                                  bind(C, name="C_MPI_Win_flush")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: rank
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_flush

        subroutine C_MPI_Win_flush_all(win, ierror) &
                                      bind(C, name="C_MPI_Win_flush_all")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_flush_all

        subroutine C_MPI_Win_flush_local(rank, win, ierror) &
                                        bind(C, name="C_MPI_Win_flush_local")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: rank
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_flush_local

        subroutine C_MPI_Win_flush_local_all(win, ierror) &
                                            bind(C, name="C_MPI_Win_flush_local_all")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_flush_local_all

        subroutine C_MPI_Win_sync(win, ierror) &
                                 bind(C, name="C_MPI_Win_sync")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_sync

    end interface

    interface
        subroutine C_MPI_Win_create(base, size, disp_unit, info, comm, win, ierror) &
                                   bind(C, name="C_MPI_Win_create")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), dimension(*), asynchronous :: base
            integer(c_int64_t), value :: size
            integer(kind=c_int), value :: disp_unit
            integer(kind=c_int), value :: info
            integer(kind=c_int), value :: comm
            integer(kind=c_int) :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_create

        subroutine C_MPI_Win_allocate(size, disp_unit, info, comm, baseptr, win, ierror) &
                                     bind(C, name="C_MPI_Win_allocate")
            use, intrinsic :: iso_c_binding
            integer(c_int64_t), value :: size
            integer(kind=c_int), value :: disp_unit
            integer(kind=c_int), value :: info
            integer(kind=c_int), value :: comm
            type(c_ptr) :: baseptr
            integer(kind=c_int) :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_allocate

        subroutine C_MPI_Win_allocate_shared(size, disp_unit, info, comm, baseptr, win, ierror) &
                                            bind(C, name="C_MPI_Win_allocate_shared")
            use, intrinsic :: iso_c_binding
            integer(c_int64_t), value :: size
            integer(kind=c_int), value :: disp_unit
            integer(kind=c_int), value :: info
            integer(kind=c_int), value :: comm
            type(c_ptr) :: baseptr
            integer(kind=c_int) :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_allocate_shared

        subroutine C_MPI_Win_shared_query(win, rank, size, disp_unit, baseptr, ierror) &
                                         bind(C, name="C_MPI_Win_shared_query")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: win
            integer(kind=c_int), value :: rank
            integer(c_int64_t) :: size
            integer(kind=c_int) :: disp_unit
            type(c_ptr) :: baseptr
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_shared_query

        subroutine C_MPI_Win_create_dynamic(info, comm, win, ierror) &
                                          bind(C, name="C_MPI_Win_create_dynamic")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: info
            integer(kind=c_int), value :: comm
            integer(kind=c_int) :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_create_dynamic

        subroutine C_MPI_Win_attach(win, base, size, ierror) &
                                   bind(C, name="C_MPI_Win_attach")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: win
            integer(kind=c_int), dimension(*), asynchronous :: base
            integer(c_int64_t), value :: size
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_attach

        subroutine C_MPI_Win_detach(win, base, ierror) &
                                   bind(C, name="C_MPI_Win_detach")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: win
            integer(kind=c_int), dimension(*), asynchronous :: base
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_detach

        subroutine C_MPI_Win_free(win, ierror) &
                                 bind(C, name="C_MPI_Win_free")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int) :: win
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_free

        subroutine C_MPI_Win_get_group(win, group, ierror) &
                                      bind(C, name="C_MPI_Win_get_group")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: win
            integer(kind=c_int) :: group
            integer(kind=c_int) :: ierror
        end subroutine C_MPI_Win_get_group

#ifdef HAVE_CFI
        subroutine CFI_MPI_Win_create(base, size, disp_unit, info, comm, win, ierror) &
                                     bind(C, name="CFI_MPI_Win_create")
            use, intrinsic :: iso_c_binding
            type(*), dimension(..), asynchronous :: base
            integer(c_int64_t), value :: size
            integer(kind=c_int), value :: disp_unit
            integer(kind=c_int), value :: info
            integer(kind=c_int), value :: comm
            integer(kind=c_int) :: win
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Win_create

        subroutine CFI_MPI_Win_attach(win, base, size, ierror) &
                                     bind(C, name="CFI_MPI_Win_attach")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: win
            type(*), dimension(..), asynchronous :: base
            integer(c_int64_t), value :: size
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Win_attach

        subroutine CFI_MPI_Win_detach(win, base, ierror) &
                                     bind(C, name="CFI_MPI_Win_detach")
            use, intrinsic :: iso_c_binding
            integer(kind=c_int), value :: win
            type(*), dimension(..), asynchronous :: base
            integer(kind=c_int) :: ierror
        end subroutine CFI_MPI_Win_detach
#endif

    end interface

end module mpi_rma_c