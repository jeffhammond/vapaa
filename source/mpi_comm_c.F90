module mpi_comm_c

    interface
        subroutine C_MPI_Comm_rank(comm, rank, ierror) &
                   bind(C,name="C_MPI_Comm_rank")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: rank, ierror
        end subroutine C_MPI_Comm_rank
    end interface

    interface
        subroutine C_MPI_Comm_size(comm, size, ierror) &
                   bind(C,name="C_MPI_Comm_size")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: size, ierror
        end subroutine C_MPI_Comm_size
    end interface

    interface
        subroutine C_MPI_Comm_compare(comm1_c, comm2_c, result, ierror) &
                   bind(C,name="C_MPI_Comm_compare")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm1_c, comm2_c
            integer(kind=c_int), intent(out) :: result, ierror
        end subroutine C_MPI_Comm_compare
    end interface

    interface
        subroutine C_MPI_Comm_dup(comm, newcomm, ierror) &
                   bind(C,name="C_MPI_Comm_dup")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Comm_dup
    end interface

    interface
        subroutine C_MPI_Comm_dup_with_info(comm, info, newcomm, ierror) &
                   bind(C,name="C_MPI_Comm_dup_with_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, info
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Comm_dup_with_info
    end interface

    interface
        subroutine C_MPI_Comm_idup(comm, newcomm, request, ierror) &
                   bind(C,name="C_MPI_Comm_idup")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm
            integer(kind=c_int), intent(out), asynchronous :: newcomm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Comm_idup
    end interface

#if 0
    interface
        subroutine C_MPI_Comm_idup_with_info(comm, info, newcomm, request, ierror) &
                   bind(C,name="C_MPI_Comm_idup_with_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, info
            integer(kind=c_int), intent(out), asynchronous :: newcomm
            integer(kind=c_int), intent(out) :: request, ierror
        end subroutine C_MPI_Comm_idup_with_info
    end interface
#endif

    interface
        subroutine C_MPI_Comm_create(comm, group, newcomm, ierror) &
                   bind(C,name="C_MPI_Comm_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, group
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Comm_create
    end interface

    interface
        subroutine C_MPI_Comm_create_group(comm, group, tag, newcomm, ierror) &
                   bind(C,name="C_MPI_Comm_create_group")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, group, tag
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Comm_create_group
    end interface

    interface
        subroutine C_MPI_Comm_split(comm, color, key, newcomm, ierror) &
                   bind(C,name="C_MPI_Comm_split")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, color, key
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Comm_split
    end interface

    interface
        subroutine C_MPI_Comm_split_type(comm, type, key, info, newcomm, ierror) &
                   bind(C,name="C_MPI_Comm_split_type")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, type, key, info
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Comm_split_type
    end interface

    interface
        subroutine C_MPI_Comm_free(comm, ierror) &
                   bind(C,name="C_MPI_Comm_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: comm
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Comm_free
    end interface

    interface
        subroutine C_MPI_Cart_create(comm, ndims, dims, periods, reorder, newcomm, ierror) &
                   bind(C,name="C_MPI_Cart_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, ndims, reorder
            integer(kind=c_int), intent(in) :: dims(*), periods(*)
            integer(kind=c_int), intent(out) :: newcomm, ierror
        end subroutine C_MPI_Cart_create
    end interface

    interface
        subroutine C_MPI_Dims_create(nnodes, ndims, dims, ierror) &
                   bind(C,name="C_MPI_Dims_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: nnodes, ndims, ierror
            integer(kind=c_int), intent(inout) :: dims(ndims)
        end subroutine C_MPI_Dims_create
    end interface

    interface
        subroutine C_MPI_Cart_coords(comm, rank, maxdims, coords, ierror) &
                   bind(C,name="C_MPI_Cart_coords")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: comm, rank, maxdims
            integer(kind=c_int), intent(out) :: coords(*), ierror
        end subroutine C_MPI_Cart_coords
    end interface

end module mpi_comm_c
