! SPDX-License-Identifier: MIT

module mpi_handle_types
    use iso_c_binding, only: c_int, c_size_t
    implicit none

    type, bind(C) :: MPI_Status
        ! MPICH
        integer(kind=c_int)    :: count_lo
        integer(kind=c_int)    :: count_hi_and_cancelled
        ! public / standard
        integer(kind=c_int)    :: MPI_SOURCE
        integer(kind=c_int)    :: MPI_TAG
        integer(kind=c_int)    :: MPI_ERROR
        ! Open-MPI                
        integer(kind=c_int)    :: cancelled
        integer(kind=c_size_t) :: ucount
    end type MPI_Status

    ! MPI_VAL is supposed to be a Fortran integer
    ! but in practice it is a C int, and I do not want
    ! to deal with compiler warnings.
    !
    ! Also, this prevents people from breaking everything
    ! by changing INTEGER to something that is not equivalent
    ! to a C integer.

    type, bind(C) :: MPI_Comm
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Comm

    type, bind(C) :: MPI_Datatype
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Datatype

    type, bind(C) :: MPI_File
      integer(kind=c_int) :: MPI_VAL
    end type MPI_File

    type, bind(C) :: MPI_Group
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Group

    type, bind(C) :: MPI_Info
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Info

    type, bind(C) :: MPI_Message
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Message

    type, bind(C) :: MPI_Op
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Op

    type, bind(C) :: MPI_Request
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Request

    type, bind(C) :: MPI_Win
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Win

end module mpi_handle_types
