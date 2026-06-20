program test_cfi_matrix_p2p
    use, intrinsic :: iso_c_binding, only : c_ptr
    use, intrinsic :: iso_fortran_env, only : real64
    use mpi_f08
    implicit none

    integer :: ierr, rank, bsend_bytes
    integer, allocatable, target :: bsend_buffer(:)
    type(c_ptr) :: detached_buffer
    integer :: detached_size
    integer :: tag_counter = 17000

    call MPI_Init(ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Init")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_rank")

    bsend_bytes = 1024 * 1024
    allocate(bsend_buffer((bsend_bytes + storage_size(bsend_buffer) / 8 - 1) &
                          / (storage_size(bsend_buffer) / 8)))
    call MPI_Buffer_attach(bsend_buffer, bsend_bytes, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Buffer_attach")

    call run_integer_patterns()
    call run_real_patterns()
    call run_double_patterns()
    call run_double_complex_patterns()

    call MPI_Buffer_detach(detached_buffer, detached_size, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Buffer_detach")
    deallocate(bsend_buffer)

    if (rank == 0) print *, "Test passed"
    call MPI_Finalize(ierr)

contains

    subroutine require(ok, label)
        logical, intent(in) :: ok
        character(len=*), intent(in) :: label

        if (.not. ok) then
            print *, "FAIL:", trim(label), "rank", rank
            call MPI_Abort(MPI_COMM_WORLD, 1, ierr)
        end if
    end subroutine require

    integer function next_tag() result(tag)
        tag = tag_counter
        tag_counter = tag_counter + 1
    end function next_tag

    subroutine exercise_send_side(label, sendbuf, sendcount, sendtype, recvbuf)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount
        type(MPI_Datatype), intent(in) :: sendtype
        type(*), dimension(..), asynchronous :: recvbuf

        call op_send_recv(label // " MPI_Send/MPI_Recv", sendbuf, sendcount, &
                          sendtype, recvbuf, sendcount, sendtype)
        call op_pmpi_send_recv(label // " PMPI_Send/PMPI_Recv", sendbuf, &
                               sendcount, sendtype, recvbuf, sendcount, &
                               sendtype)
        call op_send_recv_count_kind(label // " MPI_Send count kind", sendbuf, &
                                     sendcount, sendtype, recvbuf, sendcount, &
                                     sendtype)
        call op_ssend_recv(label // " MPI_Ssend", sendbuf, sendcount, &
                           sendtype, recvbuf, sendcount, sendtype)
        call op_rsend_recv(label // " MPI_Rsend", sendbuf, sendcount, &
                           sendtype, recvbuf, sendcount, sendtype)
        call op_bsend_recv(label // " MPI_Bsend", sendbuf, sendcount, &
                           sendtype, recvbuf, sendcount, sendtype)
        call op_isend_irecv(label // " MPI_Isend/MPI_Irecv", sendbuf, &
                            sendcount, sendtype, recvbuf, sendcount, sendtype)
        call op_issend_irecv(label // " MPI_Issend", sendbuf, sendcount, &
                             sendtype, recvbuf, sendcount, sendtype)
        call op_irsend_irecv(label // " MPI_Irsend", sendbuf, sendcount, &
                             sendtype, recvbuf, sendcount, sendtype)
        call op_ibsend_irecv(label // " MPI_Ibsend", sendbuf, sendcount, &
                             sendtype, recvbuf, sendcount, sendtype)
        call op_sendrecv(label // " MPI_Sendrecv", sendbuf, sendcount, &
                         sendtype, recvbuf, sendcount, sendtype)
        call op_persistent(label // " MPI_Send_init/MPI_Recv_init", sendbuf, &
                           sendcount, sendtype, recvbuf, sendcount, sendtype, &
                           "send")
        call op_persistent(label // " MPI_Ssend_init/MPI_Recv_init", sendbuf, &
                           sendcount, sendtype, recvbuf, sendcount, sendtype, &
                           "ssend")
        call op_persistent(label // " MPI_Rsend_init/MPI_Recv_init", sendbuf, &
                           sendcount, sendtype, recvbuf, sendcount, sendtype, &
                           "rsend")
        call op_persistent(label // " MPI_Bsend_init/MPI_Recv_init", sendbuf, &
                           sendcount, sendtype, recvbuf, sendcount, sendtype, &
                           "bsend")
        call op_mprobe(label // " MPI_Mprobe/MPI_Mrecv", sendbuf, sendcount, &
                       sendtype, recvbuf, sendcount, sendtype)
        call op_improbe(label // " MPI_Improbe/MPI_Imrecv", sendbuf, &
                        sendcount, sendtype, recvbuf, sendcount, sendtype)
        call op_pack_unpack(label // " MPI_Pack/MPI_Unpack", sendbuf, &
                            sendcount, sendtype, recvbuf, sendcount, sendtype)
    end subroutine exercise_send_side

    subroutine exercise_recv_side(label, sendbuf, sendcount, sendtype, recvbuf)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount
        type(MPI_Datatype), intent(in) :: sendtype
        type(*), dimension(..), asynchronous :: recvbuf

        call op_send_recv(label // " MPI_Recv noncontig", sendbuf, sendcount, &
                          sendtype, recvbuf, sendcount, sendtype)
        call op_send_recv_count_kind(label // " MPI_Recv count kind noncontig", &
                                     sendbuf, sendcount, sendtype, recvbuf, &
                                     sendcount, sendtype)
        call op_isend_irecv(label // " MPI_Irecv noncontig", sendbuf, &
                            sendcount, sendtype, recvbuf, sendcount, sendtype)
        call op_mprobe(label // " MPI_Mrecv noncontig", sendbuf, sendcount, &
                       sendtype, recvbuf, sendcount, sendtype)
        call op_improbe(label // " MPI_Imrecv noncontig", sendbuf, sendcount, &
                        sendtype, recvbuf, sendcount, sendtype)
        call op_pack_unpack(label // " MPI_Unpack noncontig", sendbuf, &
                            sendcount, sendtype, recvbuf, sendcount, sendtype)
    end subroutine exercise_recv_side

    subroutine op_send_recv(label, sendbuf, sendcount, sendtype, recvbuf, &
                            recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Request) :: request
        type(MPI_Status) :: status
        integer :: tag

        tag = next_tag()
        call MPI_Irecv(recvbuf, recvcount, recvtype, rank, tag, MPI_COMM_WORLD, &
                       request, ierr)
        call require(ierr == MPI_SUCCESS, label // " Irecv")
        call MPI_Send(sendbuf, sendcount, sendtype, rank, tag, MPI_COMM_WORLD, &
                      ierr)
        call require(ierr == MPI_SUCCESS, label // " Send")
        call MPI_Wait(request, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " Wait")
    end subroutine op_send_recv

    subroutine op_pmpi_send_recv(label, sendbuf, sendcount, sendtype, recvbuf, &
                                 recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Request) :: request, zero_request
        type(MPI_Status) :: status
        integer :: tag, zero_tag

        tag = next_tag()
        call MPI_Irecv(recvbuf, recvcount, recvtype, rank, tag, MPI_COMM_WORLD, &
                       request, ierr)
        call require(ierr == MPI_SUCCESS, label // " Irecv")
        call PMPI_Send(sendbuf, sendcount, sendtype, rank, tag, MPI_COMM_WORLD, &
                       ierr)
        call require(ierr == MPI_SUCCESS, label // " PMPI_Send")
        call MPI_Wait(request, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " Wait")

        zero_tag = next_tag()
        call MPI_Isend(sendbuf, 0, sendtype, rank, zero_tag, MPI_COMM_WORLD, &
                       zero_request, ierr)
        call require(ierr == MPI_SUCCESS, label // " Isend zero")
        call PMPI_Recv(recvbuf, 0, recvtype, rank, zero_tag, MPI_COMM_WORLD, &
                       status, ierr)
        call require(ierr == MPI_SUCCESS, label // " PMPI_Recv zero")
        call MPI_Wait(zero_request, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " Wait zero")
    end subroutine op_pmpi_send_recv

    subroutine op_send_recv_count_kind(label, sendbuf, sendcount, sendtype, &
                                       recvbuf, recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Request) :: request
        type(MPI_Status) :: status
        integer :: tag

        tag = next_tag()
        call MPI_Irecv(recvbuf, recvcount, recvtype, rank, tag, MPI_COMM_WORLD, &
                       request, ierr)
        call require(ierr == MPI_SUCCESS, label // " Irecv")
        call MPI_Send(sendbuf, int(sendcount, MPI_COUNT_KIND), sendtype, rank, &
                      tag, MPI_COMM_WORLD, ierr)
        call require(ierr == MPI_SUCCESS, label // " Send")
        call MPI_Wait(request, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " Wait")
    end subroutine op_send_recv_count_kind

    subroutine op_ssend_recv(label, sendbuf, sendcount, sendtype, recvbuf, &
                             recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Request) :: request
        type(MPI_Status) :: status
        integer :: tag

        tag = next_tag()
        call MPI_Irecv(recvbuf, recvcount, recvtype, rank, tag, MPI_COMM_WORLD, &
                       request, ierr)
        call require(ierr == MPI_SUCCESS, label // " Irecv")
        call MPI_Ssend(sendbuf, sendcount, sendtype, rank, tag, MPI_COMM_WORLD, &
                       ierr)
        call require(ierr == MPI_SUCCESS, label // " Ssend")
        call MPI_Wait(request, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " Wait")
    end subroutine op_ssend_recv

    subroutine op_rsend_recv(label, sendbuf, sendcount, sendtype, recvbuf, &
                             recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Request) :: request
        type(MPI_Status) :: status
        integer :: tag

        tag = next_tag()
        call MPI_Irecv(recvbuf, recvcount, recvtype, rank, tag, MPI_COMM_WORLD, &
                       request, ierr)
        call require(ierr == MPI_SUCCESS, label // " Irecv")
        call MPI_Rsend(sendbuf, sendcount, sendtype, rank, tag, MPI_COMM_WORLD, &
                       ierr)
        call require(ierr == MPI_SUCCESS, label // " Rsend")
        call MPI_Wait(request, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " Wait")
    end subroutine op_rsend_recv

    subroutine op_bsend_recv(label, sendbuf, sendcount, sendtype, recvbuf, &
                             recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Request) :: request
        type(MPI_Status) :: status
        integer :: tag

        tag = next_tag()
        call MPI_Irecv(recvbuf, recvcount, recvtype, rank, tag, MPI_COMM_WORLD, &
                       request, ierr)
        call require(ierr == MPI_SUCCESS, label // " Irecv")
        call MPI_Bsend(sendbuf, sendcount, sendtype, rank, tag, MPI_COMM_WORLD, &
                       ierr)
        call require(ierr == MPI_SUCCESS, label // " Bsend")
        call MPI_Wait(request, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " Wait")
    end subroutine op_bsend_recv

    subroutine op_isend_irecv(label, sendbuf, sendcount, sendtype, recvbuf, &
                              recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Request) :: request(2)
        integer :: tag

        tag = next_tag()
        call MPI_Irecv(recvbuf, recvcount, recvtype, rank, tag, MPI_COMM_WORLD, &
                       request(1), ierr)
        call require(ierr == MPI_SUCCESS, label // " Irecv")
        call MPI_Isend(sendbuf, sendcount, sendtype, rank, tag, MPI_COMM_WORLD, &
                       request(2), ierr)
        call require(ierr == MPI_SUCCESS, label // " Isend")
        call MPI_Waitall(2, request, MPI_STATUSES_IGNORE, ierr)
        call require(ierr == MPI_SUCCESS, label // " Waitall")
    end subroutine op_isend_irecv

    subroutine op_issend_irecv(label, sendbuf, sendcount, sendtype, recvbuf, &
                               recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Request) :: request(2)
        integer :: tag

        tag = next_tag()
        call MPI_Irecv(recvbuf, recvcount, recvtype, rank, tag, MPI_COMM_WORLD, &
                       request(1), ierr)
        call require(ierr == MPI_SUCCESS, label // " Irecv")
        call MPI_Issend(sendbuf, sendcount, sendtype, rank, tag, MPI_COMM_WORLD, &
                        request(2), ierr)
        call require(ierr == MPI_SUCCESS, label // " Issend")
        call MPI_Waitall(2, request, MPI_STATUSES_IGNORE, ierr)
        call require(ierr == MPI_SUCCESS, label // " Waitall")
    end subroutine op_issend_irecv

    subroutine op_irsend_irecv(label, sendbuf, sendcount, sendtype, recvbuf, &
                               recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Request) :: request(2)
        integer :: tag

        tag = next_tag()
        call MPI_Irecv(recvbuf, recvcount, recvtype, rank, tag, MPI_COMM_WORLD, &
                       request(1), ierr)
        call require(ierr == MPI_SUCCESS, label // " Irecv")
        call MPI_Irsend(sendbuf, sendcount, sendtype, rank, tag, MPI_COMM_WORLD, &
                        request(2), ierr)
        call require(ierr == MPI_SUCCESS, label // " Irsend")
        call MPI_Waitall(2, request, MPI_STATUSES_IGNORE, ierr)
        call require(ierr == MPI_SUCCESS, label // " Waitall")
    end subroutine op_irsend_irecv

    subroutine op_ibsend_irecv(label, sendbuf, sendcount, sendtype, recvbuf, &
                               recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Request) :: request(2)
        integer :: tag

        tag = next_tag()
        call MPI_Irecv(recvbuf, recvcount, recvtype, rank, tag, MPI_COMM_WORLD, &
                       request(1), ierr)
        call require(ierr == MPI_SUCCESS, label // " Irecv")
        call MPI_Ibsend(sendbuf, sendcount, sendtype, rank, tag, MPI_COMM_WORLD, &
                        request(2), ierr)
        call require(ierr == MPI_SUCCESS, label // " Ibsend")
        call MPI_Waitall(2, request, MPI_STATUSES_IGNORE, ierr)
        call require(ierr == MPI_SUCCESS, label // " Waitall")
    end subroutine op_ibsend_irecv

    subroutine op_sendrecv(label, sendbuf, sendcount, sendtype, recvbuf, &
                           recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Status) :: status
        integer :: tag

        tag = next_tag()
        call MPI_Sendrecv(sendbuf, sendcount, sendtype, rank, tag, recvbuf, &
                          recvcount, recvtype, rank, tag, MPI_COMM_WORLD, &
                          status, ierr)
        call require(ierr == MPI_SUCCESS, label)
    end subroutine op_sendrecv

    subroutine op_persistent(label, sendbuf, sendcount, sendtype, recvbuf, &
                             recvcount, recvtype, mode)
        character(len=*), intent(in) :: label, mode
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Request) :: request(2)
        integer :: tag

        tag = next_tag()
        call MPI_Recv_init(recvbuf, recvcount, recvtype, rank, tag, &
                           MPI_COMM_WORLD, request(1), ierr)
        call require(ierr == MPI_SUCCESS, label // " Recv_init")
        select case (mode)
        case ("send")
            call MPI_Send_init(sendbuf, sendcount, sendtype, rank, tag, &
                               MPI_COMM_WORLD, request(2), ierr)
        case ("ssend")
            call MPI_Ssend_init(sendbuf, sendcount, sendtype, rank, tag, &
                                MPI_COMM_WORLD, request(2), ierr)
        case ("rsend")
            call MPI_Rsend_init(sendbuf, sendcount, sendtype, rank, tag, &
                                MPI_COMM_WORLD, request(2), ierr)
        case ("bsend")
            call MPI_Bsend_init(sendbuf, sendcount, sendtype, rank, tag, &
                                MPI_COMM_WORLD, request(2), ierr)
        end select
        call require(ierr == MPI_SUCCESS, label // " Send_init")
        call MPI_Startall(2, request, ierr)
        call require(ierr == MPI_SUCCESS, label // " Startall")
        call MPI_Waitall(2, request, MPI_STATUSES_IGNORE, ierr)
        call require(ierr == MPI_SUCCESS, label // " Waitall")
        call MPI_Request_free(request(1), ierr)
        call require(ierr == MPI_SUCCESS, label // " Request_free recv")
        call MPI_Request_free(request(2), ierr)
        call require(ierr == MPI_SUCCESS, label // " Request_free send")
    end subroutine op_persistent

    subroutine op_mprobe(label, sendbuf, sendcount, sendtype, recvbuf, &
                         recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Request) :: request
        type(MPI_Message) :: message
        type(MPI_Status) :: status
        integer :: tag

        tag = next_tag()
        call MPI_Isend(sendbuf, sendcount, sendtype, rank, tag, MPI_COMM_WORLD, &
                       request, ierr)
        call require(ierr == MPI_SUCCESS, label // " Isend")
        call MPI_Mprobe(rank, tag, MPI_COMM_WORLD, message, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " Mprobe")
        call MPI_Mrecv(recvbuf, recvcount, recvtype, message, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " Mrecv")
        call MPI_Wait(request, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " Wait")
    end subroutine op_mprobe

    subroutine op_improbe(label, sendbuf, sendcount, sendtype, recvbuf, &
                          recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Request) :: request(2)
        type(MPI_Message) :: message
        type(MPI_Status) :: status
        logical :: flag
        integer :: tag

        tag = next_tag()
        flag = .false.
        call MPI_Isend(sendbuf, sendcount, sendtype, rank, tag, MPI_COMM_WORLD, &
                       request(1), ierr)
        call require(ierr == MPI_SUCCESS, label // " Isend")
        do while (.not. flag)
            call MPI_Improbe(rank, tag, MPI_COMM_WORLD, flag, message, status, &
                             ierr)
            call require(ierr == MPI_SUCCESS, label // " Improbe")
        end do
        call MPI_Imrecv(recvbuf, recvcount, recvtype, message, request(2), ierr)
        call require(ierr == MPI_SUCCESS, label // " Imrecv")
        call MPI_Waitall(2, request, MPI_STATUSES_IGNORE, ierr)
        call require(ierr == MPI_SUCCESS, label // " Waitall")
    end subroutine op_improbe

    subroutine op_pack_unpack(label, sendbuf, sendcount, sendtype, recvbuf, &
                              recvcount, recvtype)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: sendcount, recvcount
        type(MPI_Datatype), intent(in) :: sendtype, recvtype
        type(*), dimension(..), asynchronous :: recvbuf
        integer, allocatable :: packbuf(:)
        integer :: pack_size, position, word_bytes, words

        call MPI_Pack_size(sendcount, sendtype, MPI_COMM_WORLD, pack_size, ierr)
        call require(ierr == MPI_SUCCESS, label // " Pack_size")
        word_bytes = storage_size(words) / 8
        words = max(1, (pack_size + word_bytes - 1) / word_bytes)
        allocate(packbuf(words))
        position = 0
        call MPI_Pack(sendbuf, sendcount, sendtype, packbuf, pack_size, &
                      position, MPI_COMM_WORLD, ierr)
        call require(ierr == MPI_SUCCESS, label // " Pack")
        position = 0
        call MPI_Unpack(packbuf, pack_size, position, recvbuf, recvcount, &
                        recvtype, MPI_COMM_WORLD, ierr)
        call require(ierr == MPI_SUCCESS, label // " Unpack")
        deallocate(packbuf)
    end subroutine op_pack_unpack

    subroutine run_integer_patterns()
        integer, target :: a(8, 8), contig(4, 4), expected(4, 4)
        integer, target :: recv(4, 4), target_matrix(8, 8)

        call fill_integer(a)
        contig = a(1:4, 1:4)
        call run_integer_send_case("integer contig", contig, contig, recv)
        expected = a(1:4, 1:8:2)
        call run_integer_send_case("integer column stride", a(1:4, 1:8:2), &
                                   expected, recv)
        expected = a(1:8:2, 1:4)
        call run_integer_send_case("integer row stride", a(1:8:2, 1:4), &
                                   expected, recv)
        expected = a(1:8:2, 1:8:2)
        call run_integer_send_case("integer checkerboard", a(1:8:2, 1:8:2), &
                                   expected, recv)

        call run_integer_recv_case("integer recv contig", contig, &
                                   target_matrix(1:4, 1:4), contig, &
                                   target_matrix)
        expected = a(1:4, 1:8:2)
        call run_integer_recv_case("integer recv column stride", expected, &
                                   target_matrix(1:4, 1:8:2), expected, &
                                   target_matrix)
        expected = a(1:8:2, 1:4)
        call run_integer_recv_case("integer recv row stride", expected, &
                                   target_matrix(1:8:2, 1:4), expected, &
                                   target_matrix)
        expected = a(1:8:2, 1:8:2)
        call run_integer_recv_case("integer recv checkerboard", expected, &
                                   target_matrix(1:8:2, 1:8:2), expected, &
                                   target_matrix)
    end subroutine run_integer_patterns

    subroutine run_integer_send_case(label, sendbuf, expected, recv)
        character(len=*), intent(in) :: label
        integer, intent(in), asynchronous :: sendbuf(:, :), expected(:, :)
        integer, intent(inout), asynchronous :: recv(:, :)

        recv = -9999
        call exercise_send_side(label, sendbuf, size(expected), MPI_INTEGER, &
                                recv)
        call require(all(recv == expected), label // " payload")
    end subroutine run_integer_send_case

    subroutine run_integer_recv_case(label, sendbuf, recvbuf, expected, whole)
        character(len=*), intent(in) :: label
        integer, intent(in), asynchronous :: sendbuf(:, :), expected(:, :)
        integer, intent(inout), asynchronous :: recvbuf(:, :), whole(:, :)

        whole = -9999
        call exercise_recv_side(label, sendbuf, size(expected), MPI_INTEGER, &
                                recvbuf)
        call require(all(recvbuf == expected), label // " payload")
    end subroutine run_integer_recv_case

    subroutine fill_integer(a)
        integer, intent(out) :: a(:, :)
        integer :: i, j

        do j = 1, size(a, 2)
            do i = 1, size(a, 1)
                a(i, j) = 1000 * rank + 100 * j + i
            end do
        end do
    end subroutine fill_integer

    subroutine run_real_patterns()
        real, target :: a(8, 8), contig(4, 4), expected(4, 4)
        real, target :: recv(4, 4), target_matrix(8, 8)

        call fill_real(a)
        contig = a(1:4, 1:4)
        call run_real_send_case("real contig", contig, contig, recv)
        expected = a(1:4, 1:8:2)
        call run_real_send_case("real column stride", a(1:4, 1:8:2), &
                                expected, recv)
        expected = a(1:8:2, 1:4)
        call run_real_send_case("real row stride", a(1:8:2, 1:4), expected, &
                                recv)
        expected = a(1:8:2, 1:8:2)
        call run_real_send_case("real checkerboard", a(1:8:2, 1:8:2), &
                                expected, recv)

        call run_real_recv_case("real recv contig", contig, &
                                target_matrix(1:4, 1:4), contig, &
                                target_matrix)
        expected = a(1:4, 1:8:2)
        call run_real_recv_case("real recv column stride", expected, &
                                target_matrix(1:4, 1:8:2), expected, &
                                target_matrix)
        expected = a(1:8:2, 1:4)
        call run_real_recv_case("real recv row stride", expected, &
                                target_matrix(1:8:2, 1:4), expected, &
                                target_matrix)
        expected = a(1:8:2, 1:8:2)
        call run_real_recv_case("real recv checkerboard", expected, &
                                target_matrix(1:8:2, 1:8:2), expected, &
                                target_matrix)
    end subroutine run_real_patterns

    subroutine run_real_send_case(label, sendbuf, expected, recv)
        character(len=*), intent(in) :: label
        real, intent(in), asynchronous :: sendbuf(:, :), expected(:, :)
        real, intent(inout), asynchronous :: recv(:, :)

        recv = -9999.0
        call exercise_send_side(label, sendbuf, size(expected), MPI_REAL, recv)
        call require(all(abs(recv - expected) < 1.0e-6), label // " payload")
    end subroutine run_real_send_case

    subroutine run_real_recv_case(label, sendbuf, recvbuf, expected, whole)
        character(len=*), intent(in) :: label
        real, intent(in), asynchronous :: sendbuf(:, :), expected(:, :)
        real, intent(inout), asynchronous :: recvbuf(:, :), whole(:, :)

        whole = -9999.0
        call exercise_recv_side(label, sendbuf, size(expected), MPI_REAL, &
                                recvbuf)
        call require(all(abs(recvbuf - expected) < 1.0e-6), label // " payload")
    end subroutine run_real_recv_case

    subroutine fill_real(a)
        real, intent(out) :: a(:, :)
        integer :: i, j

        do j = 1, size(a, 2)
            do i = 1, size(a, 1)
                a(i, j) = real(1000 * rank + 100 * j + i) / 8.0
            end do
        end do
    end subroutine fill_real

    subroutine run_double_patterns()
        real(real64), target :: a(8, 8), contig(4, 4), expected(4, 4)
        real(real64), target :: recv(4, 4), target_matrix(8, 8)

        call fill_double(a)
        contig = a(1:4, 1:4)
        call run_double_send_case("double contig", contig, contig, recv)
        expected = a(1:4, 1:8:2)
        call run_double_send_case("double column stride", a(1:4, 1:8:2), &
                                  expected, recv)
        expected = a(1:8:2, 1:4)
        call run_double_send_case("double row stride", a(1:8:2, 1:4), &
                                  expected, recv)
        expected = a(1:8:2, 1:8:2)
        call run_double_send_case("double checkerboard", a(1:8:2, 1:8:2), &
                                  expected, recv)

        call run_double_recv_case("double recv contig", contig, &
                                  target_matrix(1:4, 1:4), contig, &
                                  target_matrix)
        expected = a(1:4, 1:8:2)
        call run_double_recv_case("double recv column stride", expected, &
                                  target_matrix(1:4, 1:8:2), expected, &
                                  target_matrix)
        expected = a(1:8:2, 1:4)
        call run_double_recv_case("double recv row stride", expected, &
                                  target_matrix(1:8:2, 1:4), expected, &
                                  target_matrix)
        expected = a(1:8:2, 1:8:2)
        call run_double_recv_case("double recv checkerboard", expected, &
                                  target_matrix(1:8:2, 1:8:2), expected, &
                                  target_matrix)
    end subroutine run_double_patterns

    subroutine run_double_send_case(label, sendbuf, expected, recv)
        character(len=*), intent(in) :: label
        real(real64), intent(in), asynchronous :: sendbuf(:, :), expected(:, :)
        real(real64), intent(inout), asynchronous :: recv(:, :)

        recv = -9999.0_real64
        call exercise_send_side(label, sendbuf, size(expected), &
                                MPI_DOUBLE_PRECISION, recv)
        call require(all(abs(recv - expected) < 1.0e-12_real64), &
                     label // " payload")
    end subroutine run_double_send_case

    subroutine run_double_recv_case(label, sendbuf, recvbuf, expected, whole)
        character(len=*), intent(in) :: label
        real(real64), intent(in), asynchronous :: sendbuf(:, :), expected(:, :)
        real(real64), intent(inout), asynchronous :: recvbuf(:, :), whole(:, :)

        whole = -9999.0_real64
        call exercise_recv_side(label, sendbuf, size(expected), &
                                MPI_DOUBLE_PRECISION, recvbuf)
        call require(all(abs(recvbuf - expected) < 1.0e-12_real64), &
                     label // " payload")
    end subroutine run_double_recv_case

    subroutine fill_double(a)
        real(real64), intent(out) :: a(:, :)
        integer :: i, j

        do j = 1, size(a, 2)
            do i = 1, size(a, 1)
                a(i, j) = real(1000 * rank + 100 * j + i, real64) / 11.0_real64
            end do
        end do
    end subroutine fill_double

    subroutine run_double_complex_patterns()
        complex(real64), target :: a(8, 8), contig(4, 4), expected(4, 4)
        complex(real64), target :: recv(4, 4), target_matrix(8, 8)

        call fill_double_complex(a)
        contig = a(1:4, 1:4)
        call run_double_complex_send_case("double complex contig", contig, &
                                          contig, recv)
        expected = a(1:4, 1:8:2)
        call run_double_complex_send_case("double complex column stride", &
                                          a(1:4, 1:8:2), expected, recv)
        expected = a(1:8:2, 1:4)
        call run_double_complex_send_case("double complex row stride", &
                                          a(1:8:2, 1:4), expected, recv)
        expected = a(1:8:2, 1:8:2)
        call run_double_complex_send_case("double complex checkerboard", &
                                          a(1:8:2, 1:8:2), expected, recv)

        call run_double_complex_recv_case("double complex recv contig", contig, &
                                          target_matrix(1:4, 1:4), contig, &
                                          target_matrix)
        expected = a(1:4, 1:8:2)
        call run_double_complex_recv_case("double complex recv column stride", &
                                          expected, target_matrix(1:4, 1:8:2), &
                                          expected, target_matrix)
        expected = a(1:8:2, 1:4)
        call run_double_complex_recv_case("double complex recv row stride", &
                                          expected, target_matrix(1:8:2, 1:4), &
                                          expected, target_matrix)
        expected = a(1:8:2, 1:8:2)
        call run_double_complex_recv_case("double complex recv checkerboard", &
                                          expected, &
                                          target_matrix(1:8:2, 1:8:2), &
                                          expected, target_matrix)
    end subroutine run_double_complex_patterns

    subroutine run_double_complex_send_case(label, sendbuf, expected, recv)
        character(len=*), intent(in) :: label
        complex(real64), intent(in), asynchronous :: sendbuf(:, :), expected(:, :)
        complex(real64), intent(inout), asynchronous :: recv(:, :)

        recv = cmplx(-9999.0_real64, 9999.0_real64, kind=real64)
        call exercise_send_side(label, sendbuf, size(expected), &
                                MPI_DOUBLE_COMPLEX, recv)
        call require(all(abs(recv - expected) < 1.0e-12_real64), &
                     label // " payload")
    end subroutine run_double_complex_send_case

    subroutine run_double_complex_recv_case(label, sendbuf, recvbuf, expected, &
                                            whole)
        character(len=*), intent(in) :: label
        complex(real64), intent(in), asynchronous :: sendbuf(:, :), expected(:, :)
        complex(real64), intent(inout), asynchronous :: recvbuf(:, :), whole(:, :)

        whole = cmplx(-9999.0_real64, 9999.0_real64, kind=real64)
        call exercise_recv_side(label, sendbuf, size(expected), &
                                MPI_DOUBLE_COMPLEX, recvbuf)
        call require(all(abs(recvbuf - expected) < 1.0e-12_real64), &
                     label // " payload")
    end subroutine run_double_complex_recv_case

    subroutine fill_double_complex(a)
        complex(real64), intent(out) :: a(:, :)
        integer :: i, j
        real(real64) :: r

        do j = 1, size(a, 2)
            do i = 1, size(a, 1)
                r = real(1000 * rank + 100 * j + i, real64)
                a(i, j) = cmplx(r / 13.0_real64, -r / 17.0_real64, kind=real64)
            end do
        end do
    end subroutine fill_double_complex

end program test_cfi_matrix_p2p
