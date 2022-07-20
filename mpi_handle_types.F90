module mpi_handle_types
    use iso_c_binding, only: c_int
    implicit none

    ! MPI_VAL is supposed to be a Fortran integer
    ! but in practice it is a C int, and I do not want
    ! to deal with compiler warnings.

    type, bind(C) :: MPI_Comm
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Comm

    type, bind(C) :: MPI_Group
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Group

    type, bind(C) :: MPI_Win
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Win

    type, bind(C) :: MPI_File
      integer(kind=c_int) :: MPI_VAL
    end type MPI_File

    type, bind(C) :: MPI_Op
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Op

    type, bind(C) :: MPI_Datatype
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Datatype

    type, bind(C) :: MPI_Info
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Info

    type, bind(C) :: MPI_Request
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Request

    type, bind(C) :: MPI_Message
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Message

end module mpi_handle_types
