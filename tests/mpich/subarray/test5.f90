!
! Copyright (C) by Argonne National Laboratory
!     See COPYRIGHT in top-level directory
!

program main
    use mpi_f08
    implicit none

    integer :: size, rank, ierr, errs
    logical :: verbose
    common /flags/ verbose

    character (len=10) :: name='test5'
    character (len=80) :: title='test 5: Send/Recv 2d array - iar(9,9)'

    integer :: i, j
    integer, dimension(9,9) :: iar_2d
    type(MPI_Status) status

    errs = 0
    verbose = .false.

    call mpi_Init(ierr)
    call mpi_comm_size(MPI_COMM_WORLD, size, ierr)
    call mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)

    if (rank .eq. 0) then
        if (verbose) print *, ' ===== ', trim(title), ' ====='

        do i=1,9
            do j=1,9
                iar_2d(j,i) = (j * 10) + i
            end do
        end do

        do j=1,9
            if (verbose) print *, (iar_2d(i,j),i=1,9)
        end do

    else
        do i=1,9
            do j=1,9
                iar_2d(j,i) = 0
            end do
        end do

    endif

    call MPI_Barrier(MPI_COMM_WORLD, ierr);
    if (ierr .ne. MPI_SUCCESS) then
        print *,"PE ",rank,": ",name,": A: mpi_barrier exited in error (",ierr,")"
        errs = errs + 1
    endif

    if (rank .eq. 0) then
        call mpi_send(iar_2d, 81, MPI_INTEGER, 1, 890, MPI_COMM_WORLD, ierr);
        if (ierr .ne. MPI_SUCCESS) then
            print *,"PE ",rank,": ",name,": mpi_send exited in error (",ierr,")"
            errs = errs + 1
        endif
    else if (rank .eq. 1) then
        call mpi_recv(iar_2d, 81, MPI_INTEGER, 0, 890, MPI_COMM_WORLD, status, ierr);
        if (ierr .ne. MPI_SUCCESS) then
            print *,"PE ",rank,": ",name,"mpi_recv exited in error (",ierr,")"
            errs = errs + 1
        endif

        do i=1,9
            do j=1,9
                if (iar_2d(j,i) .ne. (j * 10) + i) then
                    print *, "rank 1: iar_2d(", j, ",", i, ")=", iar_2d(j,i), ", expected ", (j * 10) + i
                    errs = errs + 1
                endif
            end do
        end do
        if (errs .eq. 0) then
            if (verbose) print *, "PE ", rank,": PASS - ", trim(title)
        else
            print *, "PE ", rank,": FAIL - ", trim(title)
        endif
        do j=1,9
            if (verbose) print *, (iar_2d(i,j),i=1,9)
        end do
    endif

    call mpi_Finalize(errs)
end program
