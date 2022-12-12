module mpi_handle_types
    use iso_c_binding, only : c_int
    implicit none

#if !defined(MPICH) && !defined(OPEN_MPI)
#error Sadly, you must compile with an ABIFLAG.
#endif

    type :: MPI_Status
#ifdef MPICH
        integer(kind=c_int)    :: count_lo
        integer(kind=c_int)    :: count_hi_and_cancelled
#endif
        integer    :: MPI_SOURCE
        integer    :: MPI_TAG
        integer    :: MPI_ERROR
#ifdef OPEN_MPI
        integer(kind=c_int)    :: cancelled
        integer(kind=c_size_t) :: ucount
#endif
    end type MPI_Status

    type, bind(C) :: C_MPI_Status
#ifdef MPICH
        integer(kind=c_int)    :: count_lo
        integer(kind=c_int)    :: count_hi_and_cancelled
#endif
        integer(kind=c_int) :: MPI_SOURCE
        integer(kind=c_int) :: MPI_TAG
        integer(kind=c_int) :: MPI_ERROR
#ifdef OPEN_MPI
        integer(kind=c_int)    :: cancelled
        integer(kind=c_size_t) :: ucount
#endif
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
