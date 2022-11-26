module mpi_datatype_c

    interface
        subroutine C_MPI_Type_commit(datatype_c, ierror_c) &
                   bind(C,name="C_MPI_Type_commit")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: datatype_c
            integer(kind=c_int), intent(out) :: ierror_c
        end subroutine C_MPI_Type_commit
    end interface

    interface
        subroutine C_MPI_Type_free(datatype_c, ierror_c) &
                   bind(C,name="C_MPI_Type_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: datatype_c
            integer(kind=c_int), intent(out) :: ierror_c
        end subroutine C_MPI_Type_free
    end interface

    interface
        subroutine C_MPI_Type_contiguous(count_c, oldtype_c, newtype_c, ierror_c) &
                   bind(C,name="C_MPI_Type_contiguous")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: count_c, oldtype_c
            integer(kind=c_int), intent(out) :: newtype_c, ierror_c
        end subroutine C_MPI_Type_contiguous
    end interface

    interface
        subroutine C_MPI_Type_vector(count_c, blocklength_c, stride_c, oldtype_c, newtype_c, ierror_c) &
                   bind(C,name="C_MPI_Type_vector")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: count_c, blocklength_c, stride_c, oldtype_c
            integer(kind=c_int), intent(out) :: newtype_c, ierror_c
        end subroutine C_MPI_Type_vector
    end interface

    interface
        subroutine C_MPI_Type_create_subarray(ndims_c, array_of_sizes, array_of_subsizes, &
                                              array_of_starts, order_c, oldtype_c, newtype_c, ierror_c) &
                   bind(C,name="C_MPI_Type_create_subarray")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: ndims_c, order_c, oldtype_c
            integer(kind=c_int), intent(in), dimension(ndims_c) :: array_of_sizes, array_of_subsizes, array_of_starts
            integer(kind=c_int), intent(out) :: newtype_c, ierror_c
        end subroutine C_MPI_Type_create_subarray
    end interface

end module mpi_datatype_c

