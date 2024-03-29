! SPDX-License-Identifier: MIT

module mpi_handle_operators
    use mpi_handle_types
    implicit none

    interface operator (==)
        module procedure F_MPI_Handle_Comm_eq
    end interface

    interface operator (==)
        module procedure F_MPI_Handle_Datatype_eq
    end interface

    interface operator (==)
        module procedure F_MPI_Handle_File_eq
    end interface

    interface operator (==)
        module procedure F_MPI_Handle_Group_eq
    end interface

    interface operator (==)
        module procedure F_MPI_Handle_Info_eq
    end interface

    interface operator (==)
        module procedure F_MPI_Handle_Message_eq
    end interface

    interface operator (==)
        module procedure F_MPI_Handle_Op_eq
    end interface

    interface operator (==)
        module procedure F_MPI_Handle_Request_eq
    end interface

    interface operator (==)
        module procedure F_MPI_Handle_Win_eq
    end interface

    interface operator (/=)
        module procedure F_MPI_Handle_Comm_ne
    end interface

    interface operator (/=)
        module procedure F_MPI_Handle_Datatype_ne
    end interface

    interface operator (/=)
        module procedure F_MPI_Handle_File_ne
    end interface

    interface operator (/=)
        module procedure F_MPI_Handle_Group_ne
    end interface

    interface operator (/=)
        module procedure F_MPI_Handle_Info_ne
    end interface

    interface operator (/=)
        module procedure F_MPI_Handle_Message_ne
    end interface

    interface operator (/=)
        module procedure F_MPI_Handle_Op_ne
    end interface

    interface operator (/=)
        module procedure F_MPI_Handle_Request_ne
    end interface

    interface operator (/=)
        module procedure F_MPI_Handle_Win_ne
    end interface

    contains

        pure function F_MPI_Handle_Comm_eq(a,b) result (r)
            use mpi_handle_types, only: MPI_Comm
            type(MPI_Comm), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .eq. (b % MPI_VAL)
        end function F_MPI_Handle_Comm_eq

        pure function F_MPI_Handle_Datatype_eq(a,b) result (r)
            use mpi_handle_types, only: MPI_Datatype
            type(MPI_Datatype), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .eq. (b % MPI_VAL)
        end function F_MPI_Handle_Datatype_eq

        pure function F_MPI_Handle_File_eq(a,b) result (r)
            use mpi_handle_types, only: MPI_File
            type(MPI_File), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .eq. (b % MPI_VAL)
        end function F_MPI_Handle_File_eq

        pure function F_MPI_Handle_Group_eq(a,b) result (r)
            use mpi_handle_types, only: MPI_Group
            type(MPI_Group), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .eq. (b % MPI_VAL)
        end function F_MPI_Handle_Group_eq

        pure function F_MPI_Handle_Info_eq(a,b) result (r)
            use mpi_handle_types, only: MPI_Info
            type(MPI_Info), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .eq. (b % MPI_VAL)
        end function F_MPI_Handle_Info_eq

        pure function F_MPI_Handle_Message_eq(a,b) result (r)
            use mpi_handle_types, only: MPI_Message
            type(MPI_Message), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .eq. (b % MPI_VAL)
        end function F_MPI_Handle_Message_eq

        pure function F_MPI_Handle_Op_eq(a,b) result (r)
            use mpi_handle_types, only: MPI_Op
            type(MPI_Op), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .eq. (b % MPI_VAL)
        end function F_MPI_Handle_Op_eq

        pure function F_MPI_Handle_Request_eq(a,b) result (r)
            use mpi_handle_types, only: MPI_Request
            type(MPI_Request), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .eq. (b % MPI_VAL)
        end function F_MPI_Handle_Request_eq

        pure function F_MPI_Handle_Win_eq(a,b) result (r)
            use mpi_handle_types, only: MPI_Win
            type(MPI_Win), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .eq. (b % MPI_VAL)
        end function F_MPI_Handle_Win_eq

        pure function F_MPI_Handle_Comm_ne(a,b) result (r)
            use mpi_handle_types, only: MPI_Comm
            type(MPI_Comm), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .ne. (b % MPI_VAL)
        end function F_MPI_Handle_Comm_ne

        pure function F_MPI_Handle_Datatype_ne(a,b) result (r)
            use mpi_handle_types, only: MPI_Datatype
            type(MPI_Datatype), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .ne. (b % MPI_VAL)
        end function F_MPI_Handle_Datatype_ne

        pure function F_MPI_Handle_File_ne(a,b) result (r)
            use mpi_handle_types, only: MPI_File
            type(MPI_File), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .ne. (b % MPI_VAL)
        end function F_MPI_Handle_File_ne

        pure function F_MPI_Handle_Group_ne(a,b) result (r)
            use mpi_handle_types, only: MPI_Group
            type(MPI_Group), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .ne. (b % MPI_VAL)
        end function F_MPI_Handle_Group_ne

        pure function F_MPI_Handle_Info_ne(a,b) result (r)
            use mpi_handle_types, only: MPI_Info
            type(MPI_Info), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .ne. (b % MPI_VAL)
        end function F_MPI_Handle_Info_ne

        pure function F_MPI_Handle_Message_ne(a,b) result (r)
            use mpi_handle_types, only: MPI_Message
            type(MPI_Message), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .ne. (b % MPI_VAL)
        end function F_MPI_Handle_Message_ne

        pure function F_MPI_Handle_Op_ne(a,b) result (r)
            use mpi_handle_types, only: MPI_Op
            type(MPI_Op), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .ne. (b % MPI_VAL)
        end function F_MPI_Handle_Op_ne

        pure function F_MPI_Handle_Request_ne(a,b) result (r)
            use mpi_handle_types, only: MPI_Request
            type(MPI_Request), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .ne. (b % MPI_VAL)
        end function F_MPI_Handle_Request_ne

        pure function F_MPI_Handle_Win_ne(a,b) result (r)
            use mpi_handle_types, only: MPI_Win
            type(MPI_Win), intent(in) :: a,b
            logical :: r
            r = (a % MPI_VAL) .ne. (b % MPI_VAL)
        end function F_MPI_Handle_Win_ne

end module mpi_handle_operators

! 
! #/bin/bash
! 
! for h in Comm Datatype File Group Info Message Op Request Win ; do
! 
! echo "
!     interface operator (==)
!         module procedure F_MPI_Handle_${h}_eq
!     end interface "
! 
! done
! 
! echo "
!     contains "
! 
! for h in Comm Datatype File Group Info Message Op Request Win ; do
! 
! echo "
!         pure function F_MPI_Handle_${h}_eq(a,b) result (r)
!             use mpi_handle_types, only: MPI_${h}
!             type(MPI_${h}), intent(in) :: a,b
!             logical :: r
!             r = (a % MPI_VAL) .eq. (b % MPI_VAL)
!         end function F_MPI_Handle_${h}_eq "
! 
! done
! 

