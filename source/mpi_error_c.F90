! SPDX-License-Identifier: MIT

module mpi_error_c

    interface
        subroutine C_MPI_Error_string(errorcode, string, resultlen, ierror) &
                   bind(C,name="C_MPI_Error_string")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: errorcode
            integer(kind=c_int), intent(out) :: resultlen, ierror
            character(kind=c_char), dimension(*), intent(out) :: string
        end subroutine C_MPI_Error_string
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Error_string(errorcode, string, resultlen, ierror) &
                   bind(C,name="CFI_MPI_Error_string")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: errorcode
            integer(kind=c_int), intent(out) :: resultlen, ierror
            type(*), dimension(..), intent(inout) :: string
        end subroutine CFI_MPI_Error_string
    end interface
#endif

    interface
        subroutine C_MPI_Error_class(errorcode, errorclass, ierror) &
                   bind(C,name="C_MPI_Error_class")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: errorcode
            integer(kind=c_int), intent(out) :: errorclass, ierror
        end subroutine C_MPI_Error_class
    end interface

    interface
        subroutine C_MPI_Add_error_class(errorclass, ierror) &
                   bind(C,name="C_MPI_Add_error_class")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(out) :: errorclass, ierror
        end subroutine C_MPI_Add_error_class
    end interface

    interface
        subroutine C_MPI_Add_error_code(errorclass, errorcode, ierror) &
                   bind(C,name="C_MPI_Add_error_code")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: errorclass
            integer(kind=c_int), intent(out) :: errorcode, ierror
        end subroutine C_MPI_Add_error_code
    end interface

    interface
        subroutine C_MPI_Add_error_string(errorcode, string, ierror) &
                   bind(C,name="C_MPI_Add_error_string")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: errorcode
            character(kind=c_char), dimension(*), intent(in) :: string
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Add_error_string
    end interface

    interface
        subroutine C_MPI_Remove_error_class(errorclass, ierror) &
                   bind(C,name="C_MPI_Remove_error_class")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: errorclass
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Remove_error_class
    end interface

    interface
        subroutine C_MPI_Remove_error_code(errorcode, ierror) &
                   bind(C,name="C_MPI_Remove_error_code")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: errorcode
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Remove_error_code
    end interface

    interface
        subroutine C_MPI_Remove_error_string(errorcode, ierror) &
                   bind(C,name="C_MPI_Remove_error_string")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: errorcode
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Remove_error_string
    end interface

    interface
        subroutine C_MPI_Errhandler_free(errhandler, ierror) &
                   bind(C,name="C_MPI_Errhandler_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: errhandler
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Errhandler_free
    end interface

    interface
        subroutine C_MPI_Comm_call_errhandler(comm, errorcode, ierror) &
                   bind(C,name="C_MPI_Comm_call_errhandler")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, errorcode
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Comm_call_errhandler
    end interface

    interface
        subroutine C_MPI_Comm_get_errhandler(comm, errhandler, ierror) &
                   bind(C,name="C_MPI_Comm_get_errhandler")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: errhandler, ierror
        end subroutine C_MPI_Comm_get_errhandler
    end interface

    interface
        subroutine C_MPI_Comm_set_errhandler(comm, errhandler, ierror) &
                   bind(C,name="C_MPI_Comm_set_errhandler")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, errhandler
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Comm_set_errhandler
    end interface

    interface
        subroutine C_MPI_File_call_errhandler(file, errorcode, ierror) &
                   bind(C,name="C_MPI_File_call_errhandler")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: file, errorcode
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_call_errhandler
    end interface

    interface
        subroutine C_MPI_File_get_errhandler(file, errhandler, ierror) &
                   bind(C,name="C_MPI_File_get_errhandler")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: file
            integer(kind=c_int), intent(out) :: errhandler, ierror
        end subroutine C_MPI_File_get_errhandler
    end interface

    interface
        subroutine C_MPI_File_set_errhandler(file, errhandler, ierror) &
                   bind(C,name="C_MPI_File_set_errhandler")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: file, errhandler
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_File_set_errhandler
    end interface

    interface
        subroutine C_MPI_Win_call_errhandler(win, errorcode, ierror) &
                   bind(C,name="C_MPI_Win_call_errhandler")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win, errorcode
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Win_call_errhandler
    end interface

    interface
        subroutine C_MPI_Win_get_errhandler(win, errhandler, ierror) &
                   bind(C,name="C_MPI_Win_get_errhandler")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win
            integer(kind=c_int), intent(out) :: errhandler, ierror
        end subroutine C_MPI_Win_get_errhandler
    end interface

    interface
        subroutine C_MPI_Win_set_errhandler(win, errhandler, ierror) &
                   bind(C,name="C_MPI_Win_set_errhandler")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: win, errhandler
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Win_set_errhandler
    end interface

    interface
        subroutine C_MPI_Session_call_errhandler(session, errorcode, ierror) &
                   bind(C,name="C_MPI_Session_call_errhandler")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: session, errorcode
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Session_call_errhandler
    end interface

    interface
        subroutine C_MPI_Session_get_errhandler(session, errhandler, ierror) &
                   bind(C,name="C_MPI_Session_get_errhandler")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: session
            integer(kind=c_int), intent(out) :: errhandler, ierror
        end subroutine C_MPI_Session_get_errhandler
    end interface

    interface
        subroutine C_MPI_Session_set_errhandler(session, errhandler, ierror) &
                   bind(C,name="C_MPI_Session_set_errhandler")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: session, errhandler
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Session_set_errhandler
    end interface

end module mpi_error_c
