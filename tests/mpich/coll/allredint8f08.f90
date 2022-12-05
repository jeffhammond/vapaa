!
! Copyright (C) by Argonne National Laboratory
!     See COPYRIGHT in top-level directory
!

      program main
      use mpi_f08
      integer inbuf, outbuf
      integer errs, ierr

      errs = 0

      call mpi_init( ierr )
!

      call mpi_allreduce(inbuf, outbuf, 1, MPI_INTEGER, MPI_SUM,  &
      &                   MPI_COMM_WORLD, ierr)

      call mpi_finalize( errs )
      end
