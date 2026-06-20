program test_cfi_matrix_io
    use, intrinsic :: iso_fortran_env, only : real64
    use mpi_f08
    implicit none

    integer, parameter :: nrow = 4, ncol = 4, nelem = nrow * ncol
    integer :: ierr, rank
    type(MPI_File) :: fh
    character(len=64) :: filename
    integer(kind=MPI_OFFSET_KIND) :: next_offset

    call MPI_Init(ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Init")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_rank")

    write(filename, '("vapaa_cfi_matrix_io_", i0, ".dat")') rank
    call MPI_File_open(MPI_COMM_SELF, trim(filename), &
                       ior(ior(MPI_MODE_CREATE, MPI_MODE_RDWR), &
                           MPI_MODE_DELETE_ON_CLOSE), &
                       MPI_INFO_NULL, fh, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_File_open")
    call MPI_File_set_size(fh, 0_MPI_OFFSET_KIND, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_File_set_size")

    next_offset = 0_MPI_OFFSET_KIND
    call run_integer_patterns()
    call run_real_patterns()
    call run_double_patterns()
    call run_double_complex_patterns()

    call MPI_File_close(fh, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_File_close")

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

    function reserve_offset() result(offset)
        integer(kind=MPI_OFFSET_KIND) :: offset

        offset = next_offset
        next_offset = next_offset + 4096_MPI_OFFSET_KIND
    end function reserve_offset

    subroutine io_write_at_read_at(label, sendbuf, count, datatype, recvbuf)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: count
        type(MPI_Datatype), intent(in) :: datatype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Status) :: status
        integer(kind=MPI_OFFSET_KIND) :: offset

        offset = reserve_offset()
        call MPI_File_write_at(fh, offset, sendbuf, count, datatype, status, &
                               ierr)
        call require(ierr == MPI_SUCCESS, label // " write_at")
        call MPI_File_read_at(fh, offset, recvbuf, count, datatype, status, &
                              ierr)
        call require(ierr == MPI_SUCCESS, label // " read_at")
    end subroutine io_write_at_read_at

    subroutine io_write_at_all_read_at_all(label, sendbuf, count, datatype, &
                                           recvbuf)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: count
        type(MPI_Datatype), intent(in) :: datatype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Status) :: status
        integer(kind=MPI_OFFSET_KIND) :: offset

        offset = reserve_offset()
        call MPI_File_write_at_all(fh, offset, sendbuf, count, datatype, &
                                   status, ierr)
        call require(ierr == MPI_SUCCESS, label // " write_at_all")
        call MPI_File_read_at_all(fh, offset, recvbuf, count, datatype, &
                                  status, ierr)
        call require(ierr == MPI_SUCCESS, label // " read_at_all")
    end subroutine io_write_at_all_read_at_all

    subroutine io_write_read(label, sendbuf, count, datatype, recvbuf)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: count
        type(MPI_Datatype), intent(in) :: datatype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Status) :: status
        integer(kind=MPI_OFFSET_KIND) :: offset

        offset = reserve_offset()
        call MPI_File_seek(fh, offset, MPI_SEEK_SET, ierr)
        call require(ierr == MPI_SUCCESS, label // " seek write")
        call MPI_File_write(fh, sendbuf, count, datatype, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " write")
        call MPI_File_seek(fh, offset, MPI_SEEK_SET, ierr)
        call require(ierr == MPI_SUCCESS, label // " seek read")
        call MPI_File_read(fh, recvbuf, count, datatype, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " read")
    end subroutine io_write_read

    subroutine io_write_all_read_all(label, sendbuf, count, datatype, recvbuf)
        character(len=*), intent(in) :: label
        type(*), dimension(..), intent(in), asynchronous :: sendbuf
        integer, intent(in) :: count
        type(MPI_Datatype), intent(in) :: datatype
        type(*), dimension(..), asynchronous :: recvbuf
        type(MPI_Status) :: status
        integer(kind=MPI_OFFSET_KIND) :: offset

        offset = reserve_offset()
        call MPI_File_seek(fh, offset, MPI_SEEK_SET, ierr)
        call require(ierr == MPI_SUCCESS, label // " seek write_all")
        call MPI_File_write_all(fh, sendbuf, count, datatype, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " write_all")
        call MPI_File_seek(fh, offset, MPI_SEEK_SET, ierr)
        call require(ierr == MPI_SUCCESS, label // " seek read_all")
        call MPI_File_read_all(fh, recvbuf, count, datatype, status, ierr)
        call require(ierr == MPI_SUCCESS, label // " read_all")
    end subroutine io_write_all_read_all

    subroutine run_integer_patterns()
        integer, target :: a(8, 8), contig(nrow, ncol), recv(nrow, ncol)
        integer, target :: target_matrix(8, 8), expected(nrow, ncol)

        call fill_integer(a)
        contig = a(1:nrow, 1:ncol)
        call run_integer_send_case("integer contig", contig, contig, recv)
        expected = a(1:nrow, 1:8:2)
        call run_integer_send_case("integer column stride", a(1:nrow, 1:8:2), &
                                   expected, recv)
        expected = a(1:8:2, 1:ncol)
        call run_integer_send_case("integer row stride", a(1:8:2, 1:ncol), &
                                   expected, recv)
        expected = a(1:8:2, 1:8:2)
        call run_integer_send_case("integer checkerboard", a(1:8:2, 1:8:2), &
                                   expected, recv)

        target_matrix = -9999
        call io_write_at_read_at("integer read noncontig column", expected, &
                                 nelem, MPI_INTEGER, &
                                 target_matrix(1:nrow, 1:8:2))
        call require(all(target_matrix(1:nrow, 1:8:2) == expected), &
                     "integer read noncontig column payload")
    end subroutine run_integer_patterns

    subroutine run_integer_send_case(label, sendbuf, expected, recv)
        character(len=*), intent(in) :: label
        integer, intent(in), asynchronous :: sendbuf(:, :), expected(:, :)
        integer, intent(inout), asynchronous :: recv(:, :)

        recv = -9999
        call io_write_at_read_at(label, sendbuf, nelem, MPI_INTEGER, recv)
        call require(all(recv == expected), label // " write_at payload")
        recv = -9999
        call io_write_at_all_read_at_all(label, sendbuf, nelem, MPI_INTEGER, &
                                         recv)
        call require(all(recv == expected), label // " write_at_all payload")
        recv = -9999
        call io_write_read(label, sendbuf, nelem, MPI_INTEGER, recv)
        call require(all(recv == expected), label // " write payload")
        recv = -9999
        call io_write_all_read_all(label, sendbuf, nelem, MPI_INTEGER, recv)
        call require(all(recv == expected), label // " write_all payload")
    end subroutine run_integer_send_case

    subroutine run_real_patterns()
        real, target :: a(8, 8), contig(nrow, ncol), recv(nrow, ncol)
        real :: expected(nrow, ncol)

        call fill_real(a)
        contig = a(1:nrow, 1:ncol)
        call run_real_send_case("real contig", contig, contig, recv)
        expected = a(1:nrow, 1:8:2)
        call run_real_send_case("real column stride", a(1:nrow, 1:8:2), &
                                expected, recv)
        expected = a(1:8:2, 1:ncol)
        call run_real_send_case("real row stride", a(1:8:2, 1:ncol), &
                                expected, recv)
        expected = a(1:8:2, 1:8:2)
        call run_real_send_case("real checkerboard", a(1:8:2, 1:8:2), &
                                expected, recv)
    end subroutine run_real_patterns

    subroutine run_real_send_case(label, sendbuf, expected, recv)
        character(len=*), intent(in) :: label
        real, intent(in), asynchronous :: sendbuf(:, :), expected(:, :)
        real, intent(inout), asynchronous :: recv(:, :)

        recv = -9999.0
        call io_write_at_read_at(label, sendbuf, nelem, MPI_REAL, recv)
        call require(all(abs(recv - expected) < 1.0e-6), label // " payload")
    end subroutine run_real_send_case

    subroutine run_double_patterns()
        real(real64), target :: a(8, 8), contig(nrow, ncol), recv(nrow, ncol)
        real(real64) :: expected(nrow, ncol)

        call fill_double(a)
        contig = a(1:nrow, 1:ncol)
        call run_double_send_case("double contig", contig, contig, recv)
        expected = a(1:nrow, 1:8:2)
        call run_double_send_case("double column stride", a(1:nrow, 1:8:2), &
                                  expected, recv)
        expected = a(1:8:2, 1:ncol)
        call run_double_send_case("double row stride", a(1:8:2, 1:ncol), &
                                  expected, recv)
        expected = a(1:8:2, 1:8:2)
        call run_double_send_case("double checkerboard", a(1:8:2, 1:8:2), &
                                  expected, recv)
    end subroutine run_double_patterns

    subroutine run_double_send_case(label, sendbuf, expected, recv)
        character(len=*), intent(in) :: label
        real(real64), intent(in), asynchronous :: sendbuf(:, :), expected(:, :)
        real(real64), intent(inout), asynchronous :: recv(:, :)

        recv = -9999.0_real64
        call io_write_at_read_at(label, sendbuf, nelem, MPI_DOUBLE_PRECISION, &
                                 recv)
        call require(all(abs(recv - expected) < 1.0e-12_real64), &
                     label // " payload")
    end subroutine run_double_send_case

    subroutine run_double_complex_patterns()
        complex(real64), target :: a(8, 8), contig(nrow, ncol)
        complex(real64), target :: recv(nrow, ncol)
        complex(real64) :: expected(nrow, ncol)

        call fill_double_complex(a)
        contig = a(1:nrow, 1:ncol)
        call run_double_complex_send_case("double complex contig", contig, &
                                          contig, recv)
        expected = a(1:nrow, 1:8:2)
        call run_double_complex_send_case("double complex column stride", &
                                          a(1:nrow, 1:8:2), expected, recv)
        expected = a(1:8:2, 1:ncol)
        call run_double_complex_send_case("double complex row stride", &
                                          a(1:8:2, 1:ncol), expected, recv)
        expected = a(1:8:2, 1:8:2)
        call run_double_complex_send_case("double complex checkerboard", &
                                          a(1:8:2, 1:8:2), expected, recv)
    end subroutine run_double_complex_patterns

    subroutine run_double_complex_send_case(label, sendbuf, expected, recv)
        character(len=*), intent(in) :: label
        complex(real64), intent(in), asynchronous :: sendbuf(:, :), expected(:, :)
        complex(real64), intent(inout), asynchronous :: recv(:, :)

        recv = cmplx(-9999.0_real64, 9999.0_real64, kind=real64)
        call io_write_at_read_at(label, sendbuf, nelem, MPI_DOUBLE_COMPLEX, &
                                 recv)
        call require(all(abs(recv - expected) < 1.0e-12_real64), &
                     label // " payload")
    end subroutine run_double_complex_send_case

    subroutine fill_integer(a)
        integer, intent(out) :: a(:, :)
        integer :: i, j
        do j = 1, size(a, 2)
            do i = 1, size(a, 1)
                a(i, j) = 1000 * rank + 100 * j + i
            end do
        end do
    end subroutine fill_integer

    subroutine fill_real(a)
        real, intent(out) :: a(:, :)
        integer :: i, j
        do j = 1, size(a, 2)
            do i = 1, size(a, 1)
                a(i, j) = real(1000 * rank + 100 * j + i) / 8.0
            end do
        end do
    end subroutine fill_real

    subroutine fill_double(a)
        real(real64), intent(out) :: a(:, :)
        integer :: i, j
        do j = 1, size(a, 2)
            do i = 1, size(a, 1)
                a(i, j) = real(1000 * rank + 100 * j + i, real64) / 11.0_real64
            end do
        end do
    end subroutine fill_double

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

end program test_cfi_matrix_io
