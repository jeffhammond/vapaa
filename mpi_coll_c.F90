module mpi_coll_c

    ! STANDARD STUFF

    interface
        subroutine C_MPI_Barrier(comm_c, ierror_c) bind(C,name="C_MPI_Barrier")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, ierror_c
        end subroutine C_MPI_Barrier
    end interface

    interface
        subroutine C_MPI_Bcast(buffer, count_c, datatype_c, root_c, comm_c, &
                               ierror_c) bind(C,name="C_MPI_Bcast")
            use iso_c_binding, only: c_int
            implicit none
#ifdef __NVCOMPILER
            class(*), dimension(..), intent(inout) :: buffer
#else
            type(*), dimension(..), intent(inout) :: buffer
#endif
            integer(kind=c_int) :: count_c, datatype_c, root_c, comm_c, ierror_c
        end subroutine C_MPI_Bcast
    end interface

    interface
        subroutine CFI_MPI_Bcast(buffer, count_c, datatype_c, root_c, comm_c, &
                                 ierror_c) bind(C,name="CFI_MPI_Bcast")
            use iso_c_binding, only: c_int
            implicit none
#ifdef __NVCOMPILER
            class(*), dimension(..), intent(inout) :: buffer
#else
            type(*), dimension(..), intent(inout) :: buffer
#endif
            integer(kind=c_int) :: count_c, datatype_c, root_c, comm_c, ierror_c
        end subroutine CFI_MPI_Bcast
    end interface

    interface
        subroutine C_MPI_Reduce(input, output, count_c, datatype_c, op_c, root_c, comm_c, &
                               ierror_c) bind(C,name="C_MPI_Reduce")
            use iso_c_binding, only: c_int
            implicit none
#ifdef __NVCOMPILER
            class(*), dimension(..), intent(in)    :: input
            class(*), dimension(..), intent(inout) :: output
#else
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
#endif
            integer(kind=c_int) :: count_c, datatype_c, op_c, root_c, comm_c, ierror_c
        end subroutine C_MPI_Reduce
    end interface

    interface
        subroutine CFI_MPI_Reduce(input, output, count_c, datatype_c, op_c, root_c, comm_c, &
                                 ierror_c) bind(C,name="CFI_MPI_Reduce")
            use iso_c_binding, only: c_int
            implicit none
#ifdef __NVCOMPILER
            class(*), dimension(..), intent(in)    :: input
            class(*), dimension(..), intent(inout) :: output
#else
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
#endif
            integer(kind=c_int) :: count_c, datatype_c, op_c, root_c, comm_c, ierror_c
        end subroutine CFI_MPI_Reduce
    end interface

    interface
        subroutine C_MPI_Allreduce(input, output, count_c, datatype_c, op_c, comm_c, &
                               ierror_c) bind(C,name="C_MPI_Allreduce")
            use iso_c_binding, only: c_int
            implicit none
#ifdef __NVCOMPILER
            class(*), dimension(..), intent(in)    :: input
            class(*), dimension(..), intent(inout) :: output
#else
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
#endif
            integer(kind=c_int) :: count_c, datatype_c, op_c, comm_c, ierror_c
        end subroutine C_MPI_Allreduce
    end interface

    interface
        subroutine CFI_MPI_Allreduce(input, output, count_c, datatype_c, op_c, comm_c, &
                                 ierror_c) bind(C,name="CFI_MPI_Allreduce")
            use iso_c_binding, only: c_int
            implicit none
#ifdef __NVCOMPILER
            class(*), dimension(..), intent(in)    :: input
            class(*), dimension(..), intent(inout) :: output
#else
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
#endif
            integer(kind=c_int) :: count_c, datatype_c, op_c, comm_c, ierror_c
        end subroutine CFI_MPI_Allreduce
    end interface

end module mpi_coll_c
