!
! Copyright (C) by Argonne National Laboratory
!     See COPYRIGHT in top-level directory
!

        program main
          use mpi_f08
          implicit none
          integer err
          double precision time1

          call mpi_init(err)

          time1 = mpi_wtime()
          time1 = time1 + mpi_wtick()
! Add a test on time1 to ensure that the compiler does not remove the calls
! (The compiler should call them anyway because they aren't pure, but
! including these operations ensures that a buggy compiler doesn't
! pass this test by mistake).
          if (time1 .lt. 0.0d0) then
             err = 1
          endif

          call mpi_finalize(err)

        end
