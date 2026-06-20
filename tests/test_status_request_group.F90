program main
    use iso_c_binding, only: c_int64_t
    use mpi_f08
    implicit none

    integer :: ierr, rank, nproc, errors

    errors = 0

    call MPI_Init(ierr)
    call record(ierr == MPI_SUCCESS, 'MPI_Init')
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call record(ierr == MPI_SUCCESS, 'MPI_Comm_rank')
    call MPI_Comm_size(MPI_COMM_WORLD, nproc, ierr)
    call record(ierr == MPI_SUCCESS, 'MPI_Comm_size')

    call exercise_status()
    call exercise_request_status()
    call exercise_groups()

    call MPI_Finalize(ierr)
    call record(ierr == MPI_SUCCESS, 'MPI_Finalize')

    if (errors == 0) then
        print *, 'Test passed'
    else
        print *, 'Test failed with ', errors, ' errors'
        error stop 1
    end if

contains

    subroutine record(ok, label)
        logical, intent(in) :: ok
        character(len=*), intent(in) :: label
        if (.not. ok) then
            errors = errors + 1
            print *, 'failure: ', trim(label)
        end if
    end subroutine record

    subroutine record_success_or_unsupported(ierr_value, label)
        integer, intent(in) :: ierr_value
        character(len=*), intent(in) :: label
        call record(ierr_value == MPI_SUCCESS .or. &
                    ierr_value == MPI_ERR_UNSUPPORTED_OPERATION, label)
    end subroutine record_success_or_unsupported

    subroutine exercise_status()
        type(MPI_Status) :: status, status_copy
        integer :: status_f(MPI_STATUS_SIZE)
        integer :: value, count
        integer(c_int64_t) :: count_x
        logical :: flag

        status_f = 0
        status_f(MPI_SOURCE) = rank
        status_f(MPI_TAG) = 77
        status_f(MPI_ERROR) = MPI_SUCCESS
        call MPI_Status_f2f08(status_f, status)

        value = -1
        call MPI_Status_get_source(status, value, ierr)
        call record(ierr == MPI_SUCCESS .and. value == rank, &
                    'MPI_Status_get_source')

        call MPI_Status_set_source(status, rank + 10, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Status_set_source')
        call MPI_Status_get_source(status, value, ierr)
        call record(ierr == MPI_SUCCESS .and. value == rank + 10, &
                    'MPI_Status_get_source after set')

        call MPI_Status_set_tag(status, 123, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Status_set_tag')
        call MPI_Status_get_tag(status, value, ierr)
        call record(ierr == MPI_SUCCESS .and. value == 123, &
                    'MPI_Status_get_tag')

        call MPI_Status_set_error(status, MPI_SUCCESS, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Status_set_error')
        call MPI_Status_get_error(status, value, ierr)
        call record(ierr == MPI_SUCCESS .and. value == MPI_SUCCESS, &
                    'MPI_Status_get_error')

        count = 3
        call MPI_Status_set_elements(status, MPI_INTEGER, count, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Status_set_elements')
        value = -1
        call MPI_Get_elements(status, MPI_INTEGER, value, ierr)
        call record(ierr == MPI_SUCCESS .and. value == count, &
                    'MPI_Get_elements after status set')

        count_x = 5_c_int64_t
        call MPI_Status_set_elements_x(status, MPI_INTEGER, count_x, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Status_set_elements_x')
        count_x = -1_c_int64_t
        call MPI_Get_elements_x(status, MPI_INTEGER, count_x, ierr)
        call record(ierr == MPI_SUCCESS .and. count_x == 5_c_int64_t, &
                    'MPI_Get_elements_x after status set')

        call MPI_Status_set_cancelled(status, .true., ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Status_set_cancelled')
        call MPI_Test_cancelled(status, flag, ierr)
        call record(ierr == MPI_SUCCESS .and. flag, 'MPI_Test_cancelled')

        call MPI_Status_f082f(status, status_f)
        call MPI_Status_f2f08(status_f, status_copy)
        call MPI_Status_get_tag(status_copy, value, ierr)
        call record(ierr == MPI_SUCCESS .and. value == 123, &
                    'MPI_Status_f082f/f2f08 round trip')
    end subroutine exercise_status

    subroutine exercise_request_status()
        type(MPI_Request) :: requests(2)
        type(MPI_Status) :: status, statuses(2)
        integer :: index, outcount, indices(2)
        logical :: flag

        requests = MPI_REQUEST_NULL

        call MPI_Request_get_status(requests(1), flag, status, ierr)
        call record(ierr == MPI_SUCCESS .and. flag, 'MPI_Request_get_status')

        statuses(1) = status
        statuses(2) = status
        call MPI_Request_get_status_all(2, requests, flag, statuses, ierr)
        call record_success_or_unsupported(ierr, 'MPI_Request_get_status_all')
        if (ierr == MPI_SUCCESS) then
            call record(flag, 'MPI_Request_get_status_all flag')
        end if

        index = -99
        call MPI_Request_get_status_any(2, requests, index, flag, status, ierr)
        call record_success_or_unsupported(ierr, 'MPI_Request_get_status_any')

        indices = -99
        outcount = -99
        call MPI_Request_get_status_some(2, requests, outcount, indices, &
                                         statuses, ierr)
        call record_success_or_unsupported(ierr, 'MPI_Request_get_status_some')
    end subroutine exercise_request_status

    subroutine exercise_groups()
        type(MPI_Group) :: world_group, one_group, union_group
        type(MPI_Group) :: intersection_group, difference_group
        type(MPI_Group) :: excl_group, range_incl_group, range_excl_group
        integer :: ranks1(1), ranks2(1), ranges(3,1)
        integer :: group_size, result

        call MPI_Comm_group(MPI_COMM_WORLD, world_group, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Comm_group')

        ranks1 = 0
        call MPI_Group_incl(world_group, 1, ranks1, one_group, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_incl')

        ranks2 = -1
        call MPI_Group_translate_ranks(one_group, 1, ranks1, world_group, &
                                       ranks2, ierr)
        call record(ierr == MPI_SUCCESS .and. ranks2(1) == 0, &
                    'MPI_Group_translate_ranks')

        call MPI_Group_union(one_group, world_group, union_group, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_union')
        call MPI_Group_size(union_group, group_size, ierr)
        call record(ierr == MPI_SUCCESS .and. group_size == nproc, &
                    'MPI_Group_union size')

        call MPI_Group_intersection(one_group, world_group, intersection_group, &
                                    ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_intersection')
        call MPI_Group_size(intersection_group, group_size, ierr)
        call record(ierr == MPI_SUCCESS .and. group_size == 1, &
                    'MPI_Group_intersection size')

        call MPI_Group_difference(world_group, one_group, difference_group, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_difference')
        call MPI_Group_size(difference_group, group_size, ierr)
        call record(ierr == MPI_SUCCESS .and. group_size == max(nproc - 1, 0), &
                    'MPI_Group_difference size')

        call MPI_Group_excl(world_group, 1, ranks1, excl_group, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_excl')

        ranges(:,1) = (/ 0, nproc - 1, 1 /)
        call MPI_Group_range_incl(world_group, 1, ranges, range_incl_group, &
                                  ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_range_incl')
        call MPI_Group_compare(world_group, range_incl_group, result, ierr)
        call record(ierr == MPI_SUCCESS .and. result == MPI_IDENT, &
                    'MPI_Group_range_incl compare')

        ranges(:,1) = (/ 0, 0, 1 /)
        call MPI_Group_range_excl(world_group, 1, ranges, range_excl_group, &
                                  ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_range_excl')

        call MPI_Group_free(range_excl_group, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_free range_excl')
        call MPI_Group_free(range_incl_group, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_free range_incl')
        call MPI_Group_free(excl_group, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_free excl')
        call MPI_Group_free(difference_group, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_free difference')
        call MPI_Group_free(intersection_group, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_free intersection')
        call MPI_Group_free(union_group, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_free union')
        call MPI_Group_free(one_group, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_free one')
        call MPI_Group_free(world_group, ierr)
        call record(ierr == MPI_SUCCESS, 'MPI_Group_free world')
    end subroutine exercise_groups

end program main
