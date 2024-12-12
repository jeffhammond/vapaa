!
! Copyright (C) by Argonne National Laboratory
!     See COPYRIGHT in top-level directory
!

! This file created from test/mpi/f77/coll/uallreducef.f with f77tof90
!
! Test user-defined operations.  This tests a simple commutative operation
!
      subroutine uop08( cin, cout, count, datatype )
      use iso_c_binding, only: c_ptr, c_f_pointer
      use mpi_f08
      type(c_ptr), value :: cin, cout
      integer :: count
      TYPE(MPI_Datatype) :: datatype
      integer, pointer :: cin_r(:), cout_r(:)
      if (datatype .ne. MPI_INTEGER) then
         print *, 'Invalid datatype (',datatype,') passed to user_op()'
         return
      endif
      call c_f_pointer(cin, cin_r, [count])
      call c_f_pointer(cout, cout_r, [count])
      cout_r = cin_r + cout_r
      end

      subroutine uop( cin, cout, count, datatype )
      use mpi_f08
      integer, dimension(*) :: cin, cout
      integer :: count
      TYPE(MPI_Datatype) :: datatype
      integer :: i
      if (datatype .ne. MPI_INTEGER) then
         print *, 'Invalid datatype (',datatype,') passed to user_op()'
         stop
      endif
      do i=1, count
         cout(i) = cin(i) + cout(i)
      enddo
      end

      program main
      use mpi_f08
      external uop
      external uop08
      integer ierr, errs
      integer count, vin(65000), vout(65000), i, size
      TYPE(MPI_Op) sumop
      TYPE(MPI_Comm) comm

      errs = 0

      call mpi_init(ierr)
      call mpi_op_create( uop08, .true., sumop, ierr )

      comm = MPI_COMM_WORLD
      call mpi_comm_size( comm, size, ierr )
      count = 1
      do while (count .lt. 65000)
         do i=1, count
            vin(i) = i
            vout(i) = -1
         enddo
         call mpi_allreduce( vin, vout, count, MPI_INTEGER, sumop,  &
      &                       comm, ierr )
!         Check that all results are correct
         do i=1, count
            if (vout(i) .ne. i * size) then
               errs = errs + 1
               if (errs .lt. 10) print *, "vout(",i,") = ", vout(i)
            endif
         enddo
         count = count + count
      enddo

      call mpi_op_free( sumop, ierr )

      print*,errs
      call mpi_finalize(errs)
      end
