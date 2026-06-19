program main
    use iso_fortran_env, only: int32, int64
    use mpi_f08
    implicit none

    character(len=64) :: mode
    integer :: ierror, rank, nprocs

    call get_command_argument(1, mode)
    if (len_trim(mode) == 0) mode = "match_integer"

    call MPI_Init(ierror)
    call check_ierror(ierror, "MPI_Init")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierror)
    call check_ierror(ierror, "MPI_Comm_rank")
    call MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierror)
    call check_ierror(ierror, "MPI_Comm_size")

    select case (trim(mode))
    case ("match_integer")
        call run_match_integer()
    case ("warn_byte")
        call run_warn_byte()
    case ("match_int32")
        call run_match_int32()
    case ("warn_int32_as_int64")
        call run_warn_int32_as_int64()
    case ("match_character")
        call run_match_character()
    case ("match_packed")
        call run_match_packed()
    case ("match_2integer")
        call run_match_2integer()
    case ("user_dtype_mismatch")
        call run_user_dtype_mismatch()
    case ("user_dtype_match")
        call run_user_dtype_match()
    case default
        call fail("unknown test mode: " // trim(mode))
    end select

    if (rank == 0) print *, "Test passed"
    call MPI_Finalize(ierror)
    call check_ierror(ierror, "MPI_Finalize")

contains

    subroutine check_ierror(ierror_value, context)
        integer, intent(in) :: ierror_value
        character(len=*), intent(in) :: context

        if (ierror_value /= MPI_SUCCESS) then
            call fail(trim(context) // " failed")
        end if
    end subroutine check_ierror

    subroutine fail(message)
        character(len=*), intent(in) :: message
        integer :: abort_ierror

        print *, "ERROR: ", trim(message)
        call MPI_Abort(MPI_COMM_WORLD, 1, abort_ierror)
        stop 1
    end subroutine fail

    subroutine run_match_integer()
        integer :: value

        if (rank == 0) then
            value = 314159
        else
            value = -1
        end if
        call MPI_Bcast(value, 1, MPI_INTEGER, 0, MPI_COMM_WORLD, ierror)
        call check_ierror(ierror, "MPI_Bcast(MPI_INTEGER)")
        if (value /= 314159) call fail("integer broadcast produced the wrong value")
    end subroutine run_match_integer

    subroutine run_warn_byte()
        integer :: value
        integer :: byte_count

        byte_count = storage_size(value) / 8
        if (rank == 0) then
            value = 271828
        else
            value = -1
        end if
        call MPI_Bcast(value, byte_count, MPI_BYTE, 0, MPI_COMM_WORLD, ierror)
        call check_ierror(ierror, "MPI_Bcast(MPI_BYTE)")
        if (value /= 271828) call fail("MPI_BYTE broadcast produced the wrong value")
    end subroutine run_warn_byte

    subroutine run_match_int32()
        integer(int32) :: value

        if (rank == 0) then
            value = 12345_int32
        else
            value = -1_int32
        end if
        call MPI_Bcast(value, 1, MPI_INT32_T, 0, MPI_COMM_WORLD, ierror)
        call check_ierror(ierror, "MPI_Bcast(MPI_INT32_T)")
        if (value /= 12345_int32) call fail("MPI_INT32_T broadcast produced the wrong value")
    end subroutine run_match_int32

    subroutine run_warn_int32_as_int64()
        integer(int32) :: value(2)

        if (rank == 0) then
            value = [12345_int32, 67890_int32]
        else
            value = [-1_int32, -1_int32]
        end if
        call MPI_Bcast(value, 1, MPI_INT64_T, 0, MPI_COMM_WORLD, ierror)
        call check_ierror(ierror, "MPI_Bcast(MPI_INT64_T)")
        if (any(value /= [12345_int32, 67890_int32])) then
            call fail("MPI_INT64_T broadcast produced the wrong value")
        end if
    end subroutine run_warn_int32_as_int64

    subroutine run_match_character()
        character(len=16) :: text

        if (rank == 0) then
            text = "abcdefghijklmnop"
        else
            text = ""
        end if
        call MPI_Bcast(text, len(text), MPI_CHARACTER, 0, MPI_COMM_WORLD, ierror)
        call check_ierror(ierror, "MPI_Bcast(MPI_CHARACTER)")
        if (text /= "abcdefghijklmnop") call fail("character broadcast produced the wrong value")
    end subroutine run_match_character

    subroutine run_match_packed()
        character(len=16) :: packed

        if (rank == 0) then
            packed = "packed-message!!"
        else
            packed = ""
        end if
        call MPI_Bcast(packed, len(packed), MPI_PACKED, 0, MPI_COMM_WORLD, ierror)
        call check_ierror(ierror, "MPI_Bcast(MPI_PACKED)")
        if (packed /= "packed-message!!") call fail("MPI_PACKED broadcast produced the wrong value")
    end subroutine run_match_packed

    subroutine run_match_2integer()
        integer :: input_pair(2)
        integer :: output_pair(2)

        input_pair = [rank, rank]
        output_pair = [-1, -1]
        call MPI_Allreduce(input_pair, output_pair, 1, MPI_2INTEGER, MPI_MAXLOC, &
                           MPI_COMM_WORLD, ierror)
        call check_ierror(ierror, "MPI_Allreduce(MPI_2INTEGER)")
        if (output_pair(1) /= nprocs - 1 .or. output_pair(2) /= nprocs - 1) then
            call fail("MPI_2INTEGER allreduce produced the wrong value")
        end if
    end subroutine run_match_2integer

    subroutine run_user_dtype_mismatch()
        integer(int64) :: value
        type(MPI_Datatype) :: datatype

        call MPI_Type_contiguous(1, MPI_DOUBLE_PRECISION, datatype, ierror)
        call check_ierror(ierror, "MPI_Type_contiguous(MPI_DOUBLE_PRECISION)")
        call MPI_Type_commit(datatype, ierror)
        call check_ierror(ierror, "MPI_Type_commit")
        if (rank == 0) then
            value = 123456789_int64
        else
            value = -1_int64
        end if
        call MPI_Bcast(value, 1, datatype, 0, MPI_COMM_WORLD, ierror)
        call check_ierror(ierror, "MPI_Bcast(user mismatch)")
        call MPI_Type_free(datatype, ierror)
        call check_ierror(ierror, "MPI_Type_free")
        if (value /= 123456789_int64) call fail("user datatype broadcast produced the wrong value")
    end subroutine run_user_dtype_mismatch

    subroutine run_user_dtype_match()
        integer(int32) :: value
        type(MPI_Datatype) :: datatype

        call MPI_Type_contiguous(1, MPI_INT32_T, datatype, ierror)
        call check_ierror(ierror, "MPI_Type_contiguous(MPI_INT32_T)")
        call MPI_Type_commit(datatype, ierror)
        call check_ierror(ierror, "MPI_Type_commit")
        if (rank == 0) then
            value = 24680_int32
        else
            value = -1_int32
        end if
        call MPI_Bcast(value, 1, datatype, 0, MPI_COMM_WORLD, ierror)
        call check_ierror(ierror, "MPI_Bcast(user match)")
        call MPI_Type_free(datatype, ierror)
        call check_ierror(ierror, "MPI_Type_free")
        if (value /= 24680_int32) call fail("matching user datatype broadcast produced the wrong value")
    end subroutine run_user_dtype_match

end program main
