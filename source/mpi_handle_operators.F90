module mpi_handle_operators
    use mpi_handle_types
    implicit none

    !interface operator (=)
    !    module procedure F_MPI_Status_copy_f2c
    !end interface

    !interface operator (=)
    !    module procedure F_MPI_Status_copy_c2f
    !end interface

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

        pure function F_MPI_Status_copy_c2f(c) result(f)
            type(C_MPI_Status), intent(in) :: c
            type(MPI_Status) :: f
#ifdef MPICH
            f % count_lo               = c % count_lo
            f % count_hi_and_cancelled = c % count_hi_and_cancelled
#endif
            f % MPI_SOURCE = c % MPI_SOURCE
            f % MPI_TAG    = c % MPI_TAG
            f % MPI_ERROR  = c % MPI_ERROR
#ifdef OPEN_MPI
            f % cancelled = c % cancelled
            f % ucount    = c % ucount
#endif
        end function F_MPI_Status_copy_c2f

        pure subroutine F_MPI_Status_copy_array_c2f(c,f,n)
            integer, intent(in) :: n
            type(C_MPI_Status), intent(in) :: c(*)
            type(MPI_Status), intent(out) :: f(*)
            integer :: i
            do i=1,n
                f(i) = F_MPI_Status_copy_c2f(c(i))
            end do
        end subroutine F_MPI_Status_copy_array_c2f

        pure function F_MPI_Status_copy_f2c(f) result(c)
            type(MPI_Status), intent(in) :: f
            type(C_MPI_Status) :: c
#ifdef MPICH
            c % count_lo               = f % count_lo
            c % count_hi_and_cancelled = f % count_hi_and_cancelled
#endif
            c % MPI_SOURCE = int(f % MPI_SOURCE,kind=c_int)
            c % MPI_TAG    = int(f % MPI_TAG,kind=c_int)
            c % MPI_ERROR  = int(f % MPI_ERROR,kind=c_int)
#ifdef OPEN_MPI
            c % cancelled = f % cancelled
            c % ucount    = f % ucount
#endif
        end function F_MPI_Status_copy_f2c

        pure subroutine F_MPI_Status_copy_array_f2c(f,c,n)
            integer, intent(in) :: n
            type(MPI_Status), intent(in) :: f(*)
            type(C_MPI_Status), intent(out) :: c(*)
            integer :: i
            do i=1,n
                c(i) = F_MPI_Status_copy_f2c(f(i))
            end do
        end subroutine F_MPI_Status_copy_array_f2c

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

