module mpi_comm_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Comm_rank
        module procedure MPI_Comm_rank_f08
    end interface MPI_Comm_rank

    interface MPI_Comm_size
        module procedure MPI_Comm_size_f08
    end interface MPI_Comm_size

    interface MPI_Comm_compare
        module procedure MPI_Comm_compare_f08
    end interface MPI_Comm_compare

    interface MPI_Comm_dup
        module procedure MPI_Comm_dup_f08
    end interface MPI_Comm_dup

    interface MPI_Comm_dup_with_info
        module procedure MPI_Comm_dup_with_info_f08
    end interface MPI_Comm_dup_with_info

    interface MPI_Comm_idup
        module procedure MPI_Comm_idup_f08
    end interface MPI_Comm_idup

#if 0
    interface MPI_Comm_idup_with_info
        module procedure MPI_Comm_idup_with_info_f08
    end interface MPI_Comm_idup_with_info
#endif

    interface MPI_Comm_create
        module procedure MPI_Comm_create_f08
    end interface MPI_Comm_create

    interface MPI_Comm_create_group
        module procedure MPI_Comm_create_group_f08
    end interface MPI_Comm_create_group

    interface MPI_Comm_split
        module procedure MPI_Comm_split_f08
    end interface MPI_Comm_split

    interface MPI_Comm_split_type
        module procedure MPI_Comm_split_type_f08
    end interface MPI_Comm_split_type

    interface MPI_Comm_free
        module procedure MPI_Comm_free_f08
    end interface MPI_Comm_free

    interface MPI_Cart_create
        module procedure MPI_Cart_create_f08
    end interface MPI_Cart_create

    interface MPI_Dims_create
        module procedure MPI_Dims_create_f08
    end interface MPI_Dims_create

    interface MPI_Cart_coords
        module procedure MPI_Cart_coords_f08
    end interface MPI_Cart_coords

    contains

        subroutine MPI_Comm_rank_f08(comm, rank, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_rank
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: rank
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, ierror_c
            call C_MPI_Comm_rank(comm % MPI_VAL, rank_c, ierror_c)
            rank = rank_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_rank_f08

        subroutine MPI_Comm_size_f08(comm, size, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_size
            type(MPI_Comm), intent(in) :: comm
            integer, intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: size_c, ierror_c
            call C_MPI_Comm_size(comm % MPI_VAL, size_c, ierror_c)
            size = size_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_size_f08

        subroutine MPI_Comm_compare_f08(comm1, comm2, result, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_compare
            type(MPI_Comm), intent(in) :: comm1, comm2
            integer, intent(out) :: result
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: result_c, ierror_c
            call C_MPI_Comm_compare(comm1 % MPI_VAL, comm2 % MPI_VAL, result_c, ierror_c)
            result = result_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_compare_f08

        subroutine MPI_Comm_dup_f08(comm, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_dup
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_dup(comm % MPI_VAL, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_dup_f08

        subroutine MPI_Comm_dup_with_info_f08(comm, info, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info
            use mpi_comm_c, only: C_MPI_Comm_dup_with_info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_dup_with_info(comm % MPI_VAL, info % MPI_VAL, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_dup_with_info_f08

        subroutine MPI_Comm_idup_f08(comm, newcomm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Request
            use mpi_comm_c, only: C_MPI_Comm_idup
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Comm), intent(out), asynchronous :: newcomm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_idup(comm % MPI_VAL, newcomm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_idup_f08

#if MPI_VERSION >= 4
        subroutine MPI_Comm_idup_with_info_f08(comm, info, newcomm, request, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info, MPI_Request
            use mpi_comm_c, only: C_MPI_Comm_idup_with_info
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(out), asynchronous :: newcomm
            type(MPI_Request), intent(out) :: request
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_idup_with_info(comm % MPI_VAL, info % MPI_VAL, newcomm % MPI_VAL, request % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_idup_with_info_f08
#endif

        subroutine MPI_Comm_create_f08(comm, group, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Group
            use mpi_comm_c, only: C_MPI_Comm_create
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Group), intent(in) :: group
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_create(comm % MPI_VAL, group % MPI_VAL, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_create_f08

        subroutine MPI_Comm_create_group_f08(comm, group, tag, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Group
            use mpi_comm_c, only: C_MPI_Comm_create_group
            type(MPI_Comm), intent(in) :: comm
            type(MPI_Group), intent(in) :: group
            integer, intent(in) :: tag
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: tag_c, ierror_c
            tag_c = tag
            call C_MPI_Comm_create_group(comm % MPI_VAL, group % MPI_VAL, tag_c, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_create_group_f08

        subroutine MPI_Comm_split_f08(comm, color, key, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_split
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: color, key
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: color_c, key_c, ierror_c
            color_c = color
            key_c = key
            call C_MPI_Comm_split(comm % MPI_VAL, color_c, key_c, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_split_f08

        subroutine MPI_Comm_split_type_f08(comm, type, key, info, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm, MPI_Info
            use mpi_comm_c, only: C_MPI_Comm_split_type
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: type, key
            type(MPI_Info), intent(in) :: info
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: type_c, key_c, ierror_c
            type_c = type
            key_c = key
            call C_MPI_Comm_split_type(comm % MPI_VAL, type_c, key_c, info % MPI_VAL, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_split_type_f08

        subroutine MPI_Comm_free_f08(comm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Comm_free
            type(MPI_Comm), intent(inout) :: comm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Comm_free(comm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Comm_free_f08

        subroutine MPI_Cart_create_f08(comm, ndims, dims, periods, reorder, newcomm, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Cart_create
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: ndims, dims(ndims)
            logical, intent(in) :: periods(ndims), reorder
            type(MPI_Comm), intent(out) :: newcomm
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ndims_c, reorder_c, dims_c(ndims), periods_c(ndims), ierror_c
            ndims_c = ndims
            if (reorder) then
                reorder_c = 1
            else
                reorder_c = 0
            end if
            dims_c = dims
            where (periods)
                periods_c = 1
            elsewhere
                periods_c = 0
            end where
            call C_MPI_Cart_create(comm % MPI_VAL, ndims_c, dims_c, periods_c, reorder_c, newcomm % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Cart_create_f08

        subroutine MPI_Dims_create_f08(nnodes, ndims, dims, ierror)
            use mpi_comm_c, only: C_MPI_Dims_create
            integer, intent(in) :: nnodes, ndims
            integer, intent(inout) :: dims(ndims)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: nnodes_c, ndims_c, dims_c(ndims), ierror_c
            nnodes_c = nnodes
            ndims_c = ndims
            dims_c = dims
            call C_MPI_Dims_create(nnodes_c, ndims_c, dims_c, ierror_c)
            dims = dims_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Dims_create_f08

        subroutine MPI_Cart_coords_f08(comm, rank, maxdims, coords, ierror)
            use mpi_handle_types, only: MPI_Comm
            use mpi_comm_c, only: C_MPI_Cart_coords
            type(MPI_Comm), intent(in) :: comm
            integer, intent(in) :: rank, maxdims
            integer, intent(out) :: coords(maxdims)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, maxdims_c, coords_c(maxdims), ierror_c
            rank_c = rank
            maxdims_c = maxdims
            call C_MPI_Cart_coords(comm % MPI_VAL, rank_c, maxdims_c, coords_c, ierror_c)
            coords = coords_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Cart_coords_f08

end module mpi_comm_f
