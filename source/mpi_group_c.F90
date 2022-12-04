module mpi_group_c

    interface
        subroutine C_MPI_Group_rank(group_c, rank_c, ierror_c) &
                   bind(C,name="C_MPI_Group_rank")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group_c
            integer(kind=c_int), intent(out) :: rank_c, ierror_c
        end subroutine C_MPI_Group_rank
    end interface

    interface
        subroutine C_MPI_Group_size(group_c, size_c, ierror_c) &
                   bind(C,name="C_MPI_Group_size")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group_c
            integer(kind=c_int), intent(out) :: size_c, ierror_c
        end subroutine C_MPI_Group_size
    end interface

    interface
        subroutine C_MPI_Group_translate_ranks(group1_c, n_c, ranks1_c, group2_c, ranks2_c, ierror_c) &
                   bind(C,name="C_MPI_Group_translate_ranks")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group1_c, group2_c
            integer(kind=c_int), intent(in) :: n_c, ranks1_c(n_c)
            integer(kind=c_int), intent(out) :: ranks2_c(n_c), ierror_c
        end subroutine C_MPI_Group_translate_ranks
    end interface

    interface
        subroutine C_MPI_Group_compare(group1_c, group2_c, result_c, ierror_c) &
                   bind(C,name="C_MPI_Group_compare")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group1_c, group2_c
            integer(kind=c_int), intent(out) :: result_c, ierror_c
        end subroutine C_MPI_Group_compare
    end interface

    interface
        subroutine C_MPI_Group_union(group1_c, group2_c, newgroup_c, ierror_c) &
                   bind(C,name="C_MPI_Group_union")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group1_c, group2_c
            integer(kind=c_int), intent(out) :: newgroup_c, ierror_c
        end subroutine C_MPI_Group_union
    end interface

    interface
        subroutine C_MPI_Group_intersection(group1_c, group2_c, newgroup_c, ierror_c) &
                   bind(C,name="C_MPI_Group_intersection")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group1_c, group2_c
            integer(kind=c_int), intent(out) :: newgroup_c, ierror_c
        end subroutine C_MPI_Group_intersection
    end interface

    interface
        subroutine C_MPI_Group_difference(group1_c, group2_c, newgroup_c, ierror_c) &
                   bind(C,name="C_MPI_Group_difference")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group1_c, group2_c
            integer(kind=c_int), intent(out) :: newgroup_c, ierror_c
        end subroutine C_MPI_Group_difference
    end interface

    interface
        subroutine C_MPI_Group_incl(group_c, n_c, ranks_c, newgroup_c, ierror_c) &
                   bind(C,name="C_MPI_Group_incl")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group_c
            integer(kind=c_int), intent(in) :: n_c, ranks_c(n_c)
            integer(kind=c_int), intent(out) :: newgroup_c, ierror_c
        end subroutine C_MPI_Group_incl
    end interface

    interface
        subroutine C_MPI_Group_excl(group_c, n_c, ranks_c, newgroup_c, ierror_c) &
                   bind(C,name="C_MPI_Group_excl")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group_c
            integer(kind=c_int), intent(in) :: n_c, ranks_c(n_c)
            integer(kind=c_int), intent(out) :: newgroup_c, ierror_c
        end subroutine C_MPI_Group_excl
    end interface

    interface
        subroutine C_MPI_Group_free(group_c, ierror_c) &
                   bind(C,name="C_MPI_Group_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: group_c
            integer(kind=c_int), intent(out) :: ierror_c
        end subroutine C_MPI_Group_free
    end interface

end module mpi_group_c
