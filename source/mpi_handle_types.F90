module mpi_handle_types
    use iso_c_binding, only : c_int
    implicit none

    type :: MPI_Status
        integer :: MPI_SOURCE
        integer :: MPI_TAG
        integer :: MPI_ERROR
    end type MPI_Status

    type, bind(C) :: C_MPI_Status
        integer(kind=c_int) :: MPI_SOURCE
        integer(kind=c_int) :: MPI_TAG
        integer(kind=c_int) :: MPI_ERROR
    end type C_MPI_Status

    type :: MPI_Comm
      integer :: MPI_VAL
    end type MPI_Comm

    type :: MPI_Datatype
      integer :: MPI_VAL
    end type MPI_Datatype

    type :: MPI_File
      integer :: MPI_VAL
    end type MPI_File

    type :: MPI_Group
      integer :: MPI_VAL
    end type MPI_Group

    type :: MPI_Info
      integer :: MPI_VAL
    end type MPI_Info

    type :: MPI_Message
      integer :: MPI_VAL
    end type MPI_Message

    type :: MPI_Op
      integer :: MPI_VAL
    end type MPI_Op

    type :: MPI_Request
      integer :: MPI_VAL
    end type MPI_Request

    type :: MPI_Win
      integer :: MPI_VAL
    end type MPI_Win

end module mpi_handle_types
