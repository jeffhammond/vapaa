module m
    abstract interface
        subroutine MPI_User_function(invec, inoutvec, len, datatype)
            use, intrinsic :: iso_c_binding, only: c_ptr
            use mpi_handle_types, only: MPI_Datatype
            type(c_ptr), value :: invec, inoutvec
            integer :: len
            type(MPI_Datatype) :: datatype
        end subroutine MPI_User_function
    end interface
end module m

program main
    use module m



end program main
