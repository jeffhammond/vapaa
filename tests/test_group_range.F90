! SPDX-License-Identifier: MIT
!
! Comprehensive test for MPI_Group_range_incl and MPI_Group_range_excl.
!
! Cases covered:
!   1.  range_incl positive stride          — size and membership
!   2.  range_excl positive stride          — size and membership
!   3.  complement (positive stride)        — union == world (SIMILAR)
!   4.  range_incl negative stride          — size, rank ordering preserved
!   5.  range_excl negative stride          — size and membership
!   6.  complement (negative stride)        — union == world (SIMILAR)
!   7.  range_incl multiple triplets        — size and membership
!   8.  range_excl multiple triplets        — size and membership
!   9.  range_excl all ranks               — result is MPI_GROUP_EMPTY
!  10.  range_incl single rank             — size and world-rank mapping
!  11.  range_excl single rank             — excluded rank is MPI_UNDEFINED
!  12.  range_incl n=0                     — result is MPI_GROUP_EMPTY
!  13.  range_excl n=0                     — result is IDENT to world
!  14.  range_incl all ranks               — result is IDENT to world
!
! Requires >= 4 MPI processes.  CMakeLists.txt runs tests with 4 by default.

program test_group_range
    use mpi_f08
    implicit none

    integer :: ierror, me, np
    integer :: error_count = 0
    integer :: total_errors
    type(MPI_Group) :: world_group, incl_group, excl_group, union_group
    integer :: grp_size, result
    integer :: ranges(3, 2)   ! room for up to 2 triplets
    integer :: rin(1), rout(1)

    call MPI_Init(ierror)
    call MPI_Comm_rank(MPI_COMM_WORLD, me)
    call MPI_Comm_size(MPI_COMM_WORLD, np)

    if (np < 4) then
        if (me == 0) print *, 'test_group_range: need >= 4 processes, got', np
        call MPI_Abort(MPI_COMM_WORLD, 1)
    end if

    call MPI_Comm_group(MPI_COMM_WORLD, world_group)

    ! -----------------------------------------------------------------------
    ! Test 1: range_incl, positive stride
    !   range (0, np-1, 2) => includes {0, 2, 4, ...}
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 1: range_incl positive stride'
    ranges(1,1) = 0;  ranges(2,1) = np-1;  ranges(3,1) = 2
    call MPI_Group_range_incl(world_group, 1, ranges, incl_group, ierror)
    if (ierror /= MPI_SUCCESS) then
        if (me == 0) print *, '  FAIL: ierror =', ierror
        error_count = error_count + 1
    end if
    call MPI_Group_size(incl_group, grp_size)
    if (grp_size /= (np+1)/2) then
        if (me == 0) print *, '  FAIL: size =', grp_size, ' expected', (np+1)/2
        error_count = error_count + 1
    end if
    ! incl rank 0 => world rank 0
    rin(1) = 0
    call MPI_Group_translate_ranks(incl_group, 1, rin, world_group, rout)
    if (rout(1) /= 0) then
        if (me == 0) print *, '  FAIL: incl rank 0 => world', rout(1), 'expected 0'
        error_count = error_count + 1
    end if
    ! incl rank 1 => world rank 2
    if (grp_size >= 2) then
        rin(1) = 1
        call MPI_Group_translate_ranks(incl_group, 1, rin, world_group, rout)
        if (rout(1) /= 2) then
            if (me == 0) print *, '  FAIL: incl rank 1 => world', rout(1), 'expected 2'
            error_count = error_count + 1
        end if
    end if
    ! world rank 1 must NOT appear in incl_group
    rin(1) = 1
    call MPI_Group_translate_ranks(world_group, 1, rin, incl_group, rout)
    if (rout(1) /= MPI_UNDEFINED) then
        if (me == 0) print *, '  FAIL: world rank 1 in incl_group as', rout(1), 'expected UNDEFINED'
        error_count = error_count + 1
    end if
    call MPI_Group_free(incl_group)

    ! -----------------------------------------------------------------------
    ! Test 2: range_excl, positive stride
    !   same range (0, np-1, 2) => excludes {0, 2, ...}, leaves {1, 3, ...}
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 2: range_excl positive stride'
    ranges(1,1) = 0;  ranges(2,1) = np-1;  ranges(3,1) = 2
    call MPI_Group_range_excl(world_group, 1, ranges, excl_group, ierror)
    if (ierror /= MPI_SUCCESS) then
        if (me == 0) print *, '  FAIL: ierror =', ierror
        error_count = error_count + 1
    end if
    call MPI_Group_size(excl_group, grp_size)
    if (grp_size /= np/2) then
        if (me == 0) print *, '  FAIL: size =', grp_size, ' expected', np/2
        error_count = error_count + 1
    end if
    ! excl rank 0 => world rank 1 (first odd rank)
    rin(1) = 0
    call MPI_Group_translate_ranks(excl_group, 1, rin, world_group, rout)
    if (rout(1) /= 1) then
        if (me == 0) print *, '  FAIL: excl rank 0 => world', rout(1), 'expected 1'
        error_count = error_count + 1
    end if
    ! world rank 0 must NOT appear in excl_group
    rin(1) = 0
    call MPI_Group_translate_ranks(world_group, 1, rin, excl_group, rout)
    if (rout(1) /= MPI_UNDEFINED) then
        if (me == 0) print *, '  FAIL: world rank 0 in excl_group as', rout(1), 'expected UNDEFINED'
        error_count = error_count + 1
    end if
    call MPI_Group_free(excl_group)

    ! -----------------------------------------------------------------------
    ! Test 3: complement — union(range_incl, range_excl) same range == world
    !   MPI_Group_union produces groups in incl order then remaining excl,
    !   so ordering differs from world => SIMILAR (not IDENT) is expected.
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 3: complement (positive stride) union == world'
    ranges(1,1) = 0;  ranges(2,1) = np-1;  ranges(3,1) = 2
    call MPI_Group_range_incl(world_group, 1, ranges, incl_group)
    call MPI_Group_range_excl(world_group, 1, ranges, excl_group)
    call MPI_Group_union(incl_group, excl_group, union_group)
    call MPI_Group_size(union_group, grp_size)
    if (grp_size /= np) then
        if (me == 0) print *, '  FAIL: union size =', grp_size, ' expected', np
        error_count = error_count + 1
    end if
    call MPI_Group_compare(union_group, world_group, result)
    if (result /= MPI_SIMILAR .and. result /= MPI_IDENT) then
        if (me == 0) print *, '  FAIL: compare =', result, ' expected SIMILAR or IDENT'
        error_count = error_count + 1
    end if
    call MPI_Group_free(incl_group)
    call MPI_Group_free(excl_group)
    call MPI_Group_free(union_group)

    ! -----------------------------------------------------------------------
    ! Test 4: range_incl, negative stride
    !   range (np-1, 0, -2) => includes {np-1, np-3, ...} in that order
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 4: range_incl negative stride'
    ranges(1,1) = np-1;  ranges(2,1) = 0;  ranges(3,1) = -2
    call MPI_Group_range_incl(world_group, 1, ranges, incl_group, ierror)
    if (ierror /= MPI_SUCCESS) then
        if (me == 0) print *, '  FAIL: ierror =', ierror
        error_count = error_count + 1
    end if
    call MPI_Group_size(incl_group, grp_size)
    if (grp_size /= (np+1)/2) then
        if (me == 0) print *, '  FAIL: size =', grp_size, ' expected', (np+1)/2
        error_count = error_count + 1
    end if
    ! incl rank 0 => world rank np-1 (first in range)
    rin(1) = 0
    call MPI_Group_translate_ranks(incl_group, 1, rin, world_group, rout)
    if (rout(1) /= np-1) then
        if (me == 0) print *, '  FAIL: incl rank 0 => world', rout(1), 'expected', np-1
        error_count = error_count + 1
    end if
    ! incl rank 1 => world rank np-3 (next step of -2)
    if (grp_size >= 2) then
        rin(1) = 1
        call MPI_Group_translate_ranks(incl_group, 1, rin, world_group, rout)
        if (rout(1) /= np-3) then
            if (me == 0) print *, '  FAIL: incl rank 1 => world', rout(1), 'expected', np-3
            error_count = error_count + 1
        end if
    end if
    call MPI_Group_free(incl_group)

    ! -----------------------------------------------------------------------
    ! Test 5: range_excl, negative stride
    !   range (np-1, 0, -2) => excludes {np-1, np-3, ...}, leaves {0, 2, ...}
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 5: range_excl negative stride'
    ranges(1,1) = np-1;  ranges(2,1) = 0;  ranges(3,1) = -2
    call MPI_Group_range_excl(world_group, 1, ranges, excl_group, ierror)
    if (ierror /= MPI_SUCCESS) then
        if (me == 0) print *, '  FAIL: ierror =', ierror
        error_count = error_count + 1
    end if
    call MPI_Group_size(excl_group, grp_size)
    if (grp_size /= np/2) then
        if (me == 0) print *, '  FAIL: size =', grp_size, ' expected', np/2
        error_count = error_count + 1
    end if
    ! excl rank 0 => world rank 0 (lowest even rank, first non-excluded in order)
    rin(1) = 0
    call MPI_Group_translate_ranks(excl_group, 1, rin, world_group, rout)
    if (rout(1) /= 0) then
        if (me == 0) print *, '  FAIL: excl rank 0 => world', rout(1), 'expected 0'
        error_count = error_count + 1
    end if
    ! world rank np-1 must NOT appear in excl_group
    rin(1) = np-1
    call MPI_Group_translate_ranks(world_group, 1, rin, excl_group, rout)
    if (rout(1) /= MPI_UNDEFINED) then
        if (me == 0) print *, '  FAIL: world rank', np-1, 'in excl_group as', rout(1), 'expected UNDEFINED'
        error_count = error_count + 1
    end if
    call MPI_Group_free(excl_group)

    ! -----------------------------------------------------------------------
    ! Test 6: complement — negative stride
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 6: complement (negative stride) union == world'
    ranges(1,1) = np-1;  ranges(2,1) = 0;  ranges(3,1) = -2
    call MPI_Group_range_incl(world_group, 1, ranges, incl_group)
    call MPI_Group_range_excl(world_group, 1, ranges, excl_group)
    call MPI_Group_union(incl_group, excl_group, union_group)
    call MPI_Group_size(union_group, grp_size)
    if (grp_size /= np) then
        if (me == 0) print *, '  FAIL: union size =', grp_size, ' expected', np
        error_count = error_count + 1
    end if
    call MPI_Group_compare(union_group, world_group, result)
    if (result /= MPI_SIMILAR .and. result /= MPI_IDENT) then
        if (me == 0) print *, '  FAIL: compare =', result, ' expected SIMILAR or IDENT'
        error_count = error_count + 1
    end if
    call MPI_Group_free(incl_group)
    call MPI_Group_free(excl_group)
    call MPI_Group_free(union_group)

    ! -----------------------------------------------------------------------
    ! Test 7: range_incl, two triplets
    !   (0,0,1) + (2,np-1,1) => includes {0, 2, 3, ..., np-1}  (skips rank 1)
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 7: range_incl two triplets'
    ranges(1,1) = 0;     ranges(2,1) = 0;    ranges(3,1) = 1
    ranges(1,2) = 2;     ranges(2,2) = np-1; ranges(3,2) = 1
    call MPI_Group_range_incl(world_group, 2, ranges, incl_group, ierror)
    if (ierror /= MPI_SUCCESS) then
        if (me == 0) print *, '  FAIL: ierror =', ierror
        error_count = error_count + 1
    end if
    call MPI_Group_size(incl_group, grp_size)
    ! Includes rank 0 plus ranks 2..np-1 => np-1 ranks
    if (grp_size /= np-1) then
        if (me == 0) print *, '  FAIL: size =', grp_size, ' expected', np-1
        error_count = error_count + 1
    end if
    ! incl rank 0 => world rank 0
    rin(1) = 0
    call MPI_Group_translate_ranks(incl_group, 1, rin, world_group, rout)
    if (rout(1) /= 0) then
        if (me == 0) print *, '  FAIL: incl rank 0 => world', rout(1), 'expected 0'
        error_count = error_count + 1
    end if
    ! incl rank 1 => world rank 2  (first rank from second triplet)
    rin(1) = 1
    call MPI_Group_translate_ranks(incl_group, 1, rin, world_group, rout)
    if (rout(1) /= 2) then
        if (me == 0) print *, '  FAIL: incl rank 1 => world', rout(1), 'expected 2'
        error_count = error_count + 1
    end if
    ! world rank 1 must NOT appear in incl_group
    rin(1) = 1
    call MPI_Group_translate_ranks(world_group, 1, rin, incl_group, rout)
    if (rout(1) /= MPI_UNDEFINED) then
        if (me == 0) print *, '  FAIL: world rank 1 in incl_group as', rout(1), 'expected UNDEFINED'
        error_count = error_count + 1
    end if
    call MPI_Group_free(incl_group)

    ! -----------------------------------------------------------------------
    ! Test 8: range_excl, two triplets
    !   same triplets as Test 7 => excludes {0, 2, ..., np-1}, leaves {1}
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 8: range_excl two triplets'
    ranges(1,1) = 0;     ranges(2,1) = 0;    ranges(3,1) = 1
    ranges(1,2) = 2;     ranges(2,2) = np-1; ranges(3,2) = 1
    call MPI_Group_range_excl(world_group, 2, ranges, excl_group, ierror)
    if (ierror /= MPI_SUCCESS) then
        if (me == 0) print *, '  FAIL: ierror =', ierror
        error_count = error_count + 1
    end if
    call MPI_Group_size(excl_group, grp_size)
    if (grp_size /= 1) then
        if (me == 0) print *, '  FAIL: size =', grp_size, ' expected 1'
        error_count = error_count + 1
    end if
    ! excl rank 0 => world rank 1  (the only surviving rank)
    rin(1) = 0
    call MPI_Group_translate_ranks(excl_group, 1, rin, world_group, rout)
    if (rout(1) /= 1) then
        if (me == 0) print *, '  FAIL: excl rank 0 => world', rout(1), 'expected 1'
        error_count = error_count + 1
    end if
    call MPI_Group_free(excl_group)

    ! -----------------------------------------------------------------------
    ! Test 9: range_excl all ranks => MPI_GROUP_EMPTY
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 9: range_excl all ranks => MPI_GROUP_EMPTY'
    ranges(1,1) = 0;  ranges(2,1) = np-1;  ranges(3,1) = 1
    call MPI_Group_range_excl(world_group, 1, ranges, excl_group, ierror)
    if (ierror /= MPI_SUCCESS) then
        if (me == 0) print *, '  FAIL: ierror =', ierror
        error_count = error_count + 1
    end if
    call MPI_Group_compare(excl_group, MPI_GROUP_EMPTY, result)
    if (result /= MPI_IDENT) then
        if (me == 0) print *, '  FAIL: compare =', result, ' expected IDENT to MPI_GROUP_EMPTY'
        error_count = error_count + 1
    end if
    call MPI_Group_free(excl_group)

    ! -----------------------------------------------------------------------
    ! Test 10: range_incl single rank (rank 1)
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 10: range_incl single rank'
    ranges(1,1) = 1;  ranges(2,1) = 1;  ranges(3,1) = 1
    call MPI_Group_range_incl(world_group, 1, ranges, incl_group, ierror)
    if (ierror /= MPI_SUCCESS) then
        if (me == 0) print *, '  FAIL: ierror =', ierror
        error_count = error_count + 1
    end if
    call MPI_Group_size(incl_group, grp_size)
    if (grp_size /= 1) then
        if (me == 0) print *, '  FAIL: size =', grp_size, ' expected 1'
        error_count = error_count + 1
    end if
    rin(1) = 0
    call MPI_Group_translate_ranks(incl_group, 1, rin, world_group, rout)
    if (rout(1) /= 1) then
        if (me == 0) print *, '  FAIL: incl rank 0 => world', rout(1), 'expected 1'
        error_count = error_count + 1
    end if
    call MPI_Group_free(incl_group)

    ! -----------------------------------------------------------------------
    ! Test 11: range_excl single rank (rank 1)
    !   excludes {1}, leaves {0, 2, 3, ..., np-1}
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 11: range_excl single rank'
    ranges(1,1) = 1;  ranges(2,1) = 1;  ranges(3,1) = 1
    call MPI_Group_range_excl(world_group, 1, ranges, excl_group, ierror)
    if (ierror /= MPI_SUCCESS) then
        if (me == 0) print *, '  FAIL: ierror =', ierror
        error_count = error_count + 1
    end if
    call MPI_Group_size(excl_group, grp_size)
    if (grp_size /= np-1) then
        if (me == 0) print *, '  FAIL: size =', grp_size, ' expected', np-1
        error_count = error_count + 1
    end if
    ! world rank 1 must not appear
    rin(1) = 1
    call MPI_Group_translate_ranks(world_group, 1, rin, excl_group, rout)
    if (rout(1) /= MPI_UNDEFINED) then
        if (me == 0) print *, '  FAIL: world rank 1 in excl_group as', rout(1), 'expected UNDEFINED'
        error_count = error_count + 1
    end if
    ! world rank 0 must appear as excl rank 0
    rin(1) = 0
    call MPI_Group_translate_ranks(world_group, 1, rin, excl_group, rout)
    if (rout(1) /= 0) then
        if (me == 0) print *, '  FAIL: world rank 0 => excl', rout(1), 'expected 0'
        error_count = error_count + 1
    end if
    call MPI_Group_free(excl_group)

    ! -----------------------------------------------------------------------
    ! Test 12: range_incl with n=0 => MPI_GROUP_EMPTY
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 12: range_incl n=0 => MPI_GROUP_EMPTY'
    call MPI_Group_range_incl(world_group, 0, ranges, incl_group, ierror)
    if (ierror /= MPI_SUCCESS) then
        if (me == 0) print *, '  FAIL: ierror =', ierror
        error_count = error_count + 1
    end if
    call MPI_Group_compare(incl_group, MPI_GROUP_EMPTY, result)
    if (result /= MPI_IDENT) then
        if (me == 0) print *, '  FAIL: compare =', result, ' expected IDENT to MPI_GROUP_EMPTY'
        error_count = error_count + 1
    end if
    call MPI_Group_free(incl_group)

    ! -----------------------------------------------------------------------
    ! Test 13: range_excl with n=0 => IDENT to original group
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 13: range_excl n=0 => IDENT to world'
    call MPI_Group_range_excl(world_group, 0, ranges, excl_group, ierror)
    if (ierror /= MPI_SUCCESS) then
        if (me == 0) print *, '  FAIL: ierror =', ierror
        error_count = error_count + 1
    end if
    call MPI_Group_compare(excl_group, world_group, result)
    if (result /= MPI_IDENT) then
        if (me == 0) print *, '  FAIL: compare =', result, ' expected IDENT to world'
        error_count = error_count + 1
    end if
    call MPI_Group_free(excl_group)

    ! -----------------------------------------------------------------------
    ! Test 14: range_incl all ranks => IDENT to world
    ! -----------------------------------------------------------------------
    if (me == 0) print *, 'Test 14: range_incl all ranks => IDENT to world'
    ranges(1,1) = 0;  ranges(2,1) = np-1;  ranges(3,1) = 1
    call MPI_Group_range_incl(world_group, 1, ranges, incl_group, ierror)
    if (ierror /= MPI_SUCCESS) then
        if (me == 0) print *, '  FAIL: ierror =', ierror
        error_count = error_count + 1
    end if
    call MPI_Group_compare(incl_group, world_group, result)
    if (result /= MPI_IDENT) then
        if (me == 0) print *, '  FAIL: compare =', result, ' expected IDENT to world'
        error_count = error_count + 1
    end if
    call MPI_Group_free(incl_group)

    ! -----------------------------------------------------------------------
    ! Collect errors across all ranks and report
    ! -----------------------------------------------------------------------
    call MPI_Group_free(world_group)
    call MPI_Reduce(error_count, total_errors, 1, MPI_INTEGER, MPI_SUM, 0, MPI_COMM_WORLD)

    if (me == 0) then
        if (total_errors == 0) then
            print *, 'Test passed'
        else
            print *, 'FAILED: total errors =', total_errors
        end if
    end if

    call MPI_Finalize(ierror)

end program test_group_range
