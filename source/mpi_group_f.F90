! SPDX-License-Identifier: MIT

module mpi_group_f
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Group_rank
        module procedure MPI_Group_rank_f08
    end interface MPI_Group_rank

    interface MPI_Group_size
        module procedure MPI_Group_size_f08
    end interface MPI_Group_size

    interface MPI_Group_translate_ranks
        module procedure MPI_Group_translate_ranks_f08
    end interface MPI_Group_translate_ranks

    interface MPI_Group_compare
        module procedure MPI_Group_compare_f08
    end interface MPI_Group_compare

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

        subroutine MPI_Group_translate_ranks_f08(group1, n, ranks1, group2, ranks2, ierror)
            use mpi_handle_types, only: MPI_Group
            use mpi_group_c, only: C_MPI_Group_translate_ranks
            type(MPI_Group), intent(in) :: group1, group2
            integer, intent(in) :: n, ranks1(n)
            integer, intent(out) :: ranks2(n)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: n_c, ranks1_c(n), ranks2_c(n), ierror_c
            ! in theory, if n is large, this routine will segfault due to stackoverflow
            ! so we will issue a warning if n is potentially problematic
            if (n.gt.500) then
                write(*,'(a37,i6,a50)') 'MPI_Group_translate_ranks: vector of ',n, &
                                        ' elements may cause segfault due to stack overflow'
            end if
            ! of course, i could also allocate the temporary or just pass it through
            ! because i assume F integer = C int, but whatever.
            n_c = n
            ranks1_c = ranks1
            call C_MPI_Group_translate_ranks(group1 % MPI_VAL, n_c, ranks1_c, group2 % MPI_VAL, ranks2_c, ierror_c)
            ranks2 = ranks2_c
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Group_translate_ranks_f08

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

        subroutine MPI_Group_union_f08(group1, group2, newgroup, ierror)
            use mpi_handle_types, only: MPI_Group
            use mpi_group_c, only: C_MPI_Group_union
            type(MPI_Group), intent(in) :: group1, group2
            type(MPI_Group), intent(out) :: newgroup
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Group_union(group1 % MPI_VAL, group2 % MPI_VAL, newgroup % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Group_union_f08

        subroutine MPI_Group_intersection_f08(group1, group2, newgroup, ierror)
            use mpi_handle_types, only: MPI_Group
            use mpi_group_c, only: C_MPI_Group_intersection
            type(MPI_Group), intent(in) :: group1, group2
            type(MPI_Group), intent(out) :: newgroup
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Group_intersection(group1 % MPI_VAL, group2 % MPI_VAL, newgroup % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Group_intersection_f08

        subroutine MPI_Group_difference_f08(group1, group2, newgroup, ierror)
            use mpi_handle_types, only: MPI_Group
            use mpi_group_c, only: C_MPI_Group_difference
            type(MPI_Group), intent(in) :: group1, group2
            type(MPI_Group), intent(out) :: newgroup
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: ierror_c
            call C_MPI_Group_difference(group1 % MPI_VAL, group2 % MPI_VAL, newgroup % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Group_difference_f08

        subroutine MPI_Group_incl_f08(group, n, ranks, newgroup, ierror)
            use mpi_handle_types, only: MPI_Group
            use mpi_group_c, only: C_MPI_Group_incl
            type(MPI_Group), intent(in) :: group
            type(MPI_Group), intent(out) :: newgroup
            integer, intent(in) :: n, ranks(n)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: n_c, ranks_c(n), ierror_c
            ! in theory, if n is large, this routine will segfault due to stackoverflow
            ! so we will issue a warning if n is potentially problematic.
            if (n.gt.500) then
                write(*,'(a37,i6,a50)') 'MPI_Group_incl: vector of ',n, &
                                        ' elements may cause segfault due to stack overflow'
            end if
            ! of course, i could also allocate the temporary or just pass it through
            ! because i assume F integer = C int, but whatever.
            n_c = n
            ranks_c = ranks
            call C_MPI_Group_incl(group % MPI_VAL, n_c, ranks_c, newgroup % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Group_incl_f08

        subroutine MPI_Group_excl_f08(group, n, ranks, newgroup, ierror)
            use mpi_handle_types, only: MPI_Group
            use mpi_group_c, only: C_MPI_Group_excl
            type(MPI_Group), intent(in) :: group
            type(MPI_Group), intent(out) :: newgroup
            integer, intent(in) :: n, ranks(n)
            integer, optional, intent(out) :: ierror
            integer(kind=c_int) :: n_c, ranks_c(n), ierror_c
            ! in theory, if n is large, this routine will segfault due to stackoverflow
            ! so we will issue a warning if n is potentially problematic.
            if (n.gt.500) then
                write(*,'(a37,i6,a50)') 'MPI_Group_excl: vector of ',n, &
                                        ' elements may cause segfault due to stack overflow'
            end if
            ! of course, i could also allocate the temporary or just pass it through
            ! because i assume F integer = C int, but whatever.
            n_c = n
            ranks_c = ranks
            call C_MPI_Group_excl(group % MPI_VAL, n_c, ranks_c, newgroup % MPI_VAL, ierror_c)
            if (present(ierror)) ierror = ierror_c
        end subroutine MPI_Group_excl_f08

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
