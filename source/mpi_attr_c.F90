! SPDX-License-Identifier: MIT

module mpi_attr_c

    interface
        subroutine VAPAA_MPI_Attr_delete(comm, keyval, ierror) &
                   bind(C,name="VAPAA_MPI_Attr_delete")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, keyval
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Attr_delete
    end interface

    interface
        subroutine VAPAA_MPI_Attr_get(comm, keyval, attrval, flag, ierror) &
                   bind(C,name="VAPAA_MPI_Attr_get")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, keyval
            integer(kind=c_int), intent(out) :: attrval
            integer(kind=c_int), intent(out) :: flag, ierror
        end subroutine VAPAA_MPI_Attr_get
    end interface

    interface
        subroutine VAPAA_MPI_Attr_put(comm, keyval, attrval, ierror) &
                   bind(C,name="VAPAA_MPI_Attr_put")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, keyval, attrval
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Attr_put
    end interface

    interface
        subroutine VAPAA_MPI_Keyval_free(keyval, ierror) &
                   bind(C,name="VAPAA_MPI_Keyval_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: keyval
            integer(kind=c_int), intent(out) :: ierror
        end subroutine VAPAA_MPI_Keyval_free
    end interface

    interface
        subroutine C_MPI_Type_get_name(datatype, name, resultlen, ierror) &
                   bind(C,name="C_MPI_Type_get_name")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            character(kind=c_char), dimension(*), intent(out) :: name
            integer(kind=c_int), intent(out) :: resultlen
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Type_get_name
    end interface

    interface
        subroutine CFI_MPI_Type_get_name(datatype, name, resultlen, ierror) &
                   bind(C,name="CFI_MPI_Type_get_name")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            type(*), dimension(..), intent(inout) :: name
            integer(kind=c_int), intent(out) :: resultlen
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Type_get_name
    end interface

    interface
        subroutine C_MPI_Type_set_name(datatype, name, ierror) &
                   bind(C,name="C_MPI_Type_set_name")
            use iso_c_binding, only: c_int, c_char
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            character(kind=c_char), dimension(*), intent(in) :: name
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Type_set_name
    end interface

    interface
        subroutine CFI_MPI_Type_set_name(datatype, name, ierror) &
                   bind(C,name="CFI_MPI_Type_set_name")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: datatype
            type(*), dimension(..), intent(in) :: name
            integer(kind=c_int), intent(out) :: ierror
        end subroutine CFI_MPI_Type_set_name
    end interface

end module mpi_attr_c
