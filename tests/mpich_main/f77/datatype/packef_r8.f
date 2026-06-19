C
C Typed wrappers keep GCC from comparing different buffer actual types for
C the external mpif.h MPI_Pack_external procedures in one program unit.
C
       subroutine pack_external_r8(datarep, inbuf, incount, datatype,
     &                             outbuf, outsize, position, ierr)
       implicit none
       include 'mpif.h'
       character*(*) datarep
       double precision inbuf(*)
       integer incount, datatype, outbuf(*), ierr
       integer(kind=MPI_ADDRESS_KIND) outsize, position
       call mpi_pack_external(datarep, inbuf, incount, datatype,
     &                        outbuf, outsize, position, ierr)
       end

       subroutine unpack_external_r8(datarep, inbuf, insize, position,
     &                               outbuf, outcount, datatype, ierr)
       implicit none
       include 'mpif.h'
       character*(*) datarep
       integer inbuf(*), outcount, datatype, ierr
       double precision outbuf(*)
       integer(kind=MPI_ADDRESS_KIND) insize, position
       call mpi_unpack_external(datarep, inbuf, insize, position,
     &                          outbuf, outcount, datatype, ierr)
       end
