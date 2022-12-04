module mpi_group_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Group_rank
        module procedure MPI_Group_rank_f08
    end interface MPI_Group_rank

    interface MPI_Group_size
        module procedure MPI_Group_size_f08
    end interface MPI_Group_size

#if 0
    interface MPI_Group_translate_ranks
        module procedure MPI_Group_translate_ranks_f08
    end interface MPI_Group_translate_ranks
#endif

    interface MPI_Group_compare
        module procedure MPI_Group_compare_f08
    end interface MPI_Group_compare

#if 0
    interface MPI_Group_union
        module procedure MPI_Group_union_f08
    end interface MPI_Group_union

    interface MPI_Group_intersection
        module procedure MPI_Group_intersection_f08
    end interface MPI_Group_intersection

    interface MPI_Group_difference
        module procedure MPI_Group_difference_f08
    end interface MPI_Group_difference

    interface MPI_Group_incl
        module procedure MPI_Group_incl_f08
    end interface MPI_Group_incl

    interface MPI_Group_excl
        module procedure MPI_Group_excl_f08
    end interface MPI_Group_excl

    interface MPI_Group_free
        module procedure MPI_Group_free_f08
    end interface MPI_Group_free
#endif

    contains

        subroutine MPI_Group_rank_f08(group, rank, ierror)
            use mpi_handle_types, only: MPI_Group
            use mpi_group_c, only: C_MPI_Group_rank
            type(MPI_Group), intent(in) :: group
            integer, intent(out) :: rank
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: rank_c, ierror_c
            call C_MPI_Group_rank(group % MPI_VAL, rank_c, ierror_c)
            rank = rank_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Group_rank_f08

        subroutine MPI_Group_size_f08(group, size, ierror)
            use mpi_handle_types, only: MPI_Group
            use mpi_group_c, only: C_MPI_Group_size
            type(MPI_Group), intent(in) :: group
            integer, intent(out) :: size
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: size_c, ierror_c
            call C_MPI_Group_size(group % MPI_VAL, size_c, ierror_c)
            size = size_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Group_size_f08

        subroutine MPI_Group_compare_f08(group1, group2, result, ierror)
            use mpi_handle_types, only: MPI_Group
            use mpi_group_c, only: C_MPI_Group_compare
            type(MPI_Group), intent(in) :: group1, group2
            integer, intent(out) :: result
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: result_c, ierror_c
            call C_MPI_Group_compare(group1 % MPI_VAL, group2 % MPI_VAL, result_c, ierror_c)
            result = result_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Group_compare_f08




        subroutine MPI_Group_free_f08(group, ierror)
            use mpi_handle_types, only: MPI_Group
            use mpi_group_c, only: C_MPI_Group_free
            type(MPI_Group), intent(inout) :: group
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Group_free(group % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Group_free_f08

end module mpi_group_f
