module mpi_comm_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_COMM_WORLD(comm_f) &
                   bind(C,name="C_MPI_COMM_WORLD")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_f
        end subroutine C_MPI_COMM_WORLD
    end interface

    interface
        subroutine C_MPI_COMM_SELF(comm_f) &
                   bind(C,name="C_MPI_COMM_SELF")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_f
        end subroutine C_MPI_COMM_SELF
    end interface

    interface
        subroutine C_MPI_COMM_NULL(comm_f) &
                   bind(C,name="C_MPI_COMM_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_f
        end subroutine C_MPI_COMM_NULL
    end interface

    ! STANDARD STUFF

    interface
        subroutine C_MPI_Comm_rank(comm_c, rank_c, ierror_c) &
                   bind(C,name="C_MPI_Comm_rank")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, rank_c, ierror_c
        end subroutine C_MPI_Comm_rank
    end interface

    interface
        subroutine C_MPI_Comm_size(comm_c, size_c, ierror_c) &
                   bind(C,name="C_MPI_Comm_size")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, size_c, ierror_c
        end subroutine C_MPI_Comm_size
    end interface

    interface
        subroutine C_MPI_Comm_compare(comm1_c, comm2_c, result_c, ierror_c) &
                   bind(C,name="C_MPI_Comm_compare")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm1_c, comm2_c, result_c, ierror_c
        end subroutine C_MPI_Comm_compare
    end interface

    interface
        subroutine C_MPI_Comm_dup(comm_c, newcomm_c, ierror_c) &
                   bind(C,name="C_MPI_Comm_dup")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, newcomm_c, ierror_c
        end subroutine C_MPI_Comm_dup
    end interface

    interface
        subroutine C_MPI_Comm_dup_with_info(comm_c, info_c, newcomm_c, ierror_c) &
                   bind(C,name="C_MPI_Comm_dup_with_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, info_c, newcomm_c, ierror_c
        end subroutine C_MPI_Comm_dup_with_info
    end interface

    interface
        subroutine C_MPI_Comm_idup(comm_c, newcomm_c, request_c, ierror_c) &
                   bind(C,name="C_MPI_Comm_idup")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, newcomm_c, request_c, ierror_c
        end subroutine C_MPI_Comm_idup
    end interface

    interface
        subroutine C_MPI_Comm_idup_with_info(comm_c, info_c, newcomm_c, request_c, ierror_c) &
                   bind(C,name="C_MPI_Comm_idup_with_info")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, info_c, newcomm_c, request_c, ierror_c
        end subroutine C_MPI_Comm_idup_with_info
    end interface

    interface
        subroutine C_MPI_Comm_create(comm_c, group_c, newcomm_c, ierror_c) &
                   bind(C,name="C_MPI_Comm_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, group_c, newcomm_c, ierror_c
        end subroutine C_MPI_Comm_create
    end interface

    interface
        subroutine C_MPI_Comm_create_group(comm_c, group_c, tag_c, newcomm_c, ierror_c) &
                   bind(C,name="C_MPI_Comm_create_group")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, group_c, tag_c, newcomm_c, ierror_c
        end subroutine C_MPI_Comm_create_group
    end interface

    interface
        subroutine C_MPI_Comm_split(comm_c, color_c, key_c, newcomm_c, ierror_c) &
                   bind(C,name="C_MPI_Comm_split")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, color_c, key_c, newcomm_c, ierror_c
        end subroutine C_MPI_Comm_split
    end interface

    interface
        subroutine C_MPI_Comm_split_type(comm_c, type_c, key_c, info_c, newcomm_c, ierror_c) &
                   bind(C,name="C_MPI_Comm_split_type")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, type_c, key_c, info_c, newcomm_c, ierror_c
        end subroutine C_MPI_Comm_split_type
    end interface

    interface
        subroutine C_MPI_Comm_free(comm_c, ierror_c) &
                   bind(C,name="C_MPI_Comm_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, ierror_c
        end subroutine C_MPI_Comm_free
    end interface

    interface
        subroutine C_MPI_Cart_create(comm_c, ndims_c, dims_c, periods_c, reorder_c, newcomm_c, ierror_c) &
                   bind(C,name="C_MPI_Cart_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, ndims_c, reorder_c, newcomm_c, ierror_c
            integer(kind=c_int) :: dims_c(*), periods_c(*)
        end subroutine C_MPI_Cart_create
    end interface

    interface
        subroutine C_MPI_Dims_create(nnodes_c, ndims_c, dims_c, ierror_c) &
                   bind(C,name="C_MPI_Dims_create")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: nnodes_c, ndims_c, ierror_c
            integer(kind=c_int) :: dims_c(*)
        end subroutine C_MPI_Dims_create
    end interface

    interface
        subroutine C_MPI_Cart_coords(comm_c, rank_c, maxdims_c, coords_c, ierror_c) &
                   bind(C,name="C_MPI_Cart_coords")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: comm_c, rank_c, maxdims_c, ierror_c
            integer(kind=c_int) :: coords_c(*)
        end subroutine C_MPI_Cart_coords
    end interface

end module mpi_comm_c
