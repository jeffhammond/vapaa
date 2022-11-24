module mpi_coll_f
    implicit none
    interface MPI_Bcast
        subroutine MPI_Bcast_f08(buf) 
            integer :: buf
        end subroutine MPI_Bcast_f08
        subroutine MPI_Bcast_f08ts(buffer) 
            type(*), dimension(..), intent(inout) :: buffer
        end subroutine MPI_Bcast_f08ts
    end interface MPI_Bcast
end module mpi_coll_f

