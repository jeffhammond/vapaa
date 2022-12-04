module mpi_group_c

    interface
        subroutine C_MPI_Group_rank(group, rank, ierror) &
                   bind(C,name="C_MPI_Group_rank")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group
            integer(kind=c_int), intent(out) :: rank, ierror
        end subroutine C_MPI_Group_rank
    end interface

    interface
        subroutine C_MPI_Group_size(group, size, ierror) &
                   bind(C,name="C_MPI_Group_size")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group
            integer(kind=c_int), intent(out) :: size, ierror
        end subroutine C_MPI_Group_size
    end interface

    interface
        subroutine C_MPI_Group_translate_ranks(group1_c, n, ranks1_c, group2_c, ranks2_c, ierror) &
                   bind(C,name="C_MPI_Group_translate_ranks")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group1_c, group2_c
            integer(kind=c_int), intent(in) :: n, ranks1_c(n)
            integer(kind=c_int), intent(out) :: ranks2_c(n), ierror
        end subroutine C_MPI_Group_translate_ranks
    end interface

    interface
        subroutine C_MPI_Group_compare(group1_c, group2_c, result, ierror) &
                   bind(C,name="C_MPI_Group_compare")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group1_c, group2_c
            integer(kind=c_int), intent(out) :: result, ierror
        end subroutine C_MPI_Group_compare
    end interface

    interface
        subroutine C_MPI_Group_union(group1_c, group2_c, newgroup, ierror) &
                   bind(C,name="C_MPI_Group_union")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group1_c, group2_c
            integer(kind=c_int), intent(out) :: newgroup, ierror
        end subroutine C_MPI_Group_union
    end interface

    interface
        subroutine C_MPI_Group_intersection(group1_c, group2_c, newgroup, ierror) &
                   bind(C,name="C_MPI_Group_intersection")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group1_c, group2_c
            integer(kind=c_int), intent(out) :: newgroup, ierror
        end subroutine C_MPI_Group_intersection
    end interface

    interface
        subroutine C_MPI_Group_difference(group1_c, group2_c, newgroup, ierror) &
                   bind(C,name="C_MPI_Group_difference")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group1_c, group2_c
            integer(kind=c_int), intent(out) :: newgroup, ierror
        end subroutine C_MPI_Group_difference
    end interface

    interface
        subroutine C_MPI_Group_incl(group, n, ranks, newgroup, ierror) &
                   bind(C,name="C_MPI_Group_incl")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group
            integer(kind=c_int), intent(in) :: n, ranks(n)
            integer(kind=c_int), intent(out) :: newgroup, ierror
        end subroutine C_MPI_Group_incl
    end interface

    interface
        subroutine C_MPI_Group_excl(group, n, ranks, newgroup, ierror) &
                   bind(C,name="C_MPI_Group_excl")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(in) :: group
            integer(kind=c_int), intent(in) :: n, ranks(n)
            integer(kind=c_int), intent(out) :: newgroup, ierror
        end subroutine C_MPI_Group_excl
    end interface

    interface
        subroutine C_MPI_Group_free(group, ierror) &
                   bind(C,name="C_MPI_Group_free")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int), intent(inout) :: group
            integer(kind=c_int), intent(out) :: ierror
        end subroutine C_MPI_Group_free
    end interface

end module mpi_group_c
