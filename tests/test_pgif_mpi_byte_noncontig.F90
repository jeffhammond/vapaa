program main
    use iso_fortran_env, only: int32
    use mpi_f08
    implicit none

    integer :: ierror, rank, size, i
    integer :: bytes_per_int, nbytes
    integer(int32) :: sendbuf(8)
    integer(int32) :: recvbuf(4)
    type(MPI_Status) :: status

    call MPI_Init(ierror)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierror)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierror)

    if (size < 2) then
        if (rank == 0) print *, 'test requires at least 2 ranks'
        call MPI_Abort(MPI_COMM_WORLD, 1, ierror)
    end if

    bytes_per_int = storage_size(sendbuf(1)) / 8
    nbytes = 4 * bytes_per_int

    sendbuf = [(int(100 + i, int32), i = 1, 8)]
    recvbuf = -1_int32

    if (rank == 0) then
        call MPI_Send(sendbuf(2:8:2), nbytes, MPI_BYTE, 1, 17, &
                      MPI_COMM_WORLD, ierror)
    else if (rank == 1) then
        call MPI_Recv(recvbuf, nbytes, MPI_BYTE, 0, 17, MPI_COMM_WORLD, &
                      status, ierror)
        if (any(recvbuf /= [102_int32, 104_int32, 106_int32, 108_int32])) then
            print *, 'bad MPI_BYTE strided receive:', recvbuf
            call MPI_Abort(MPI_COMM_WORLD, 2, ierror)
        end if
    end if

    call MPI_Finalize(ierror)

    if (rank == 0) then
        print *, 'PGI descriptor MPI_BYTE noncontiguous support is okay'
        print *, 'Test passed'
    end if
end program main
