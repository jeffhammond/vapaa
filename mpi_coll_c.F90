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
            integer(kind=c_int), dimension(*), intent(inout) :: buffer
            integer(kind=c_int) :: count_c, datatype_c, root_c, comm_c, ierror_c
        end subroutine C_MPI_Bcast
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Bcast(buffer, count_c, datatype_c, root_c, comm_c, &
                                 ierror_c) bind(C,name="CFI_MPI_Bcast")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(inout) :: buffer
            integer(kind=c_int) :: count_c, datatype_c, root_c, comm_c, ierror_c
        end subroutine CFI_MPI_Bcast
    end interface
#endif

    interface
        subroutine C_MPI_Reduce(input, output, count_c, datatype_c, op_c, root_c, comm_c, &
                               ierror_c) bind(C,name="C_MPI_Reduce")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int) :: count_c, datatype_c, op_c, root_c, comm_c, ierror_c
        end subroutine C_MPI_Reduce
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Reduce(input, output, count_c, datatype_c, op_c, root_c, comm_c, &
                                 ierror_c) bind(C,name="CFI_MPI_Reduce")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int) :: count_c, datatype_c, op_c, root_c, comm_c, ierror_c
        end subroutine CFI_MPI_Reduce
    end interface
#endif

    interface
        subroutine C_MPI_Allreduce(input, output, count_c, datatype_c, op_c, comm_c, &
                               ierror_c) bind(C,name="C_MPI_Allreduce")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int) :: count_c, datatype_c, op_c, comm_c, ierror_c
        end subroutine C_MPI_Allreduce
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Allreduce(input, output, count_c, datatype_c, op_c, comm_c, &
                                 ierror_c) bind(C,name="CFI_MPI_Allreduce")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int) :: count_c, datatype_c, op_c, comm_c, ierror_c
        end subroutine CFI_MPI_Allreduce
    end interface
#endif

    interface
        subroutine C_MPI_Gather(input, scount_c, stype_c, output, rcount_c, rtype_c, root_c, comm_c, &
                                ierror_c) bind(C,name="C_MPI_Gather")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int) :: scount_c, stype_c, rcount_c, rtype_c, root_c, comm_c, ierror_c
        end subroutine C_MPI_Gather
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Gather(input, scount_c, stype_c, output, rcount_c, rtype_c, root_c, comm_c, &
                                  ierror_c) bind(C,name="CFI_MPI_Gather")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int) :: scount_c, stype_c, rcount_c, rtype_c, root_c, comm_c, ierror_c
        end subroutine CFI_MPI_Gather
    end interface
#endif

    interface
        subroutine C_MPI_Allgather(input, scount_c, stype_c, output, rcount_c, rtype_c, comm_c, &
                                   ierror_c) bind(C,name="C_MPI_Allgather")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), dimension(*), intent(in)    :: input
            integer(kind=c_int), dimension(*), intent(inout) :: output
            integer(kind=c_int) :: scount_c, stype_c, rcount_c, rtype_c, comm_c, ierror_c
        end subroutine C_MPI_Allgather
    end interface

#ifdef HAVE_CFI
    interface
        subroutine CFI_MPI_Allgather(input, scount_c, stype_c, output, rcount_c, rtype_c, comm_c, &
                                     ierror_c) bind(C,name="CFI_MPI_Allgather")
            use iso_c_binding, only: c_int
            implicit none
            type(*), dimension(..), intent(in)    :: input
            type(*), dimension(..), intent(inout) :: output
            integer(kind=c_int) :: scount_c, stype_c, rcount_c, rtype_c, comm_c, ierror_c
        end subroutine CFI_MPI_Allgather
    end interface
#endif

end module mpi_coll_c
