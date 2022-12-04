module mpi_datatype_c

    interface
        subroutine C_MPI_Type_commit(datatype, ierror) &
                   bind(C,name="C_MPI_Type_commit")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: datatype
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Type_commit
    end interface

    interface
        subroutine C_MPI_Type_free(datatype, ierror) &
                   bind(C,name="C_MPI_Type_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: datatype
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Type_free
    end interface

    interface
        subroutine C_MPI_Type_contiguous(count, oldtype, newtype, ierror) &
                   bind(C,name="C_MPI_Type_contiguous")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: count, oldtype
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine C_MPI_Type_contiguous
    end interface

    interface
        subroutine C_MPI_Type_vector(count, blocklength, stride, oldtype, newtype, ierror) &
                   bind(C,name="C_MPI_Type_vector")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: count, blocklength, stride, oldtype
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine C_MPI_Type_vector
    end interface

    interface
        subroutine C_MPI_Type_create_subarray(ndims, array_of_sizes, array_of_subsizes, &
                                              array_of_starts, order, oldtype, newtype, ierror) &
                   bind(C,name="C_MPI_Type_create_subarray")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: ndims, order, oldtype
            integer(kind=c_int), intent(in), dimension(ndims) :: array_of_sizes, array_of_subsizes, array_of_starts
            integer(kind=c_int), intent(out) :: newtype, ierror
        end subroutine C_MPI_Type_create_subarray
    end interface

end module mpi_datatype_c
