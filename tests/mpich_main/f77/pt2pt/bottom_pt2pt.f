C
C Keep MPI_BOTTOM calls in a separate source file so GCC does not compare
C scalar sentinel actuals with typed user buffers in legacy mpif.h tests.
C
       subroutine recv_bottom(source, tag, comm, status, ierr)
       implicit none
       include 'mpif.h'
       integer source, tag, comm, status(MPI_STATUS_SIZE), ierr
       call MPI_Recv(MPI_BOTTOM, 0, MPI_INTEGER, source, tag,
     .               comm, status, ierr)
       end

       subroutine send_bottom(dest, tag, comm, ierr)
       implicit none
       include 'mpif.h'
       integer dest, tag, comm, ierr
       call MPI_Send(MPI_BOTTOM, 0, MPI_INTEGER, dest, tag,
     .               comm, ierr)
       end
