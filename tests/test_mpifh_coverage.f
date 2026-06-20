      program test_mpifh_coverage
      implicit none
      include 'mpif.h'
      integer ierr, errors, rank, nproc
      integer source, tag, error_code, count
      integer status(MPI_STATUS_SIZE)
      integer statuses(MPI_STATUS_SIZE,2)
      integer requests(2), indices(2), outcount
      integer world_group, one_group, union_group
      integer intersection_group, difference_group
      integer excl_group, range_incl_group, range_excl_group
      integer ranks1(1), ranks2(1), ranges(3,1), group_size
      integer abi_major, abi_minor, info, logical_size
      integer(kind=MPI_ADDRESS_KIND) base, disp, sum_addr, diff_addr
      integer(kind=MPI_COUNT_KIND) count_x
      logical flag, logical_true, logical_false, is_set

      errors = 0
      call MPI_Init(ierr)
      call check_success(ierr, errors)
      call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_size(MPI_COMM_WORLD, nproc, ierr)
      call check_success(ierr, errors)

      base = 10
      disp = 5
      sum_addr = MPI_Aint_add(base, disp)
      if (sum_addr .ne. 15) errors = errors + 1
      diff_addr = MPI_Aint_diff(sum_addr, base)
      if (diff_addr .ne. 5) errors = errors + 1

      status = 0
      source = rank
      call MPI_Status_set_source(status, source, ierr)
      call check_success(ierr, errors)
      source = -1
      call MPI_Status_get_source(status, source, ierr)
      call check_success(ierr, errors)
      if (source .ne. rank) errors = errors + 1

      tag = 321
      call MPI_Status_set_tag(status, tag, ierr)
      call check_success(ierr, errors)
      tag = -1
      call MPI_Status_get_tag(status, tag, ierr)
      call check_success(ierr, errors)
      if (tag .ne. 321) errors = errors + 1

      error_code = MPI_SUCCESS
      call MPI_Status_set_error(status, error_code, ierr)
      call check_success(ierr, errors)
      error_code = -1
      call MPI_Status_get_error(status, error_code, ierr)
      call check_success(ierr, errors)
      if (error_code .ne. MPI_SUCCESS) errors = errors + 1

      count = 3
      call MPI_Status_set_elements(status, MPI_INTEGER, count, ierr)
      call check_success(ierr, errors)
      count = -1
      call MPI_Get_elements(status, MPI_INTEGER, count, ierr)
      call check_success(ierr, errors)
      if (count .ne. 3) errors = errors + 1

      count_x = 5
      call MPI_Status_set_elements_x(status, MPI_INTEGER, count_x, ierr)
      call check_success(ierr, errors)
      count_x = -1
      call MPI_Get_elements_x(status, MPI_INTEGER, count_x, ierr)
      call check_success(ierr, errors)
      if (count_x .ne. 5) errors = errors + 1

      flag = .false.
      call MPI_Status_set_cancelled(status, .true., ierr)
      call check_success(ierr, errors)
      call MPI_Test_cancelled(status, flag, ierr)
      call check_success(ierr, errors)
      if (.not. flag) errors = errors + 1

      requests(1) = MPI_REQUEST_NULL
      requests(2) = MPI_REQUEST_NULL
      statuses = 0
      flag = .false.
      call MPI_Request_get_status(requests(1), flag, status, ierr)
      call check_success(ierr, errors)
      if (.not. flag) errors = errors + 1

      call MPI_Request_get_status_all(2, requests, flag, statuses, ierr)
      call check_success_or_unsupported(ierr, errors)
      call MPI_Request_get_status_any(2, requests, outcount, flag,
     &                                status, ierr)
      call check_success_or_unsupported(ierr, errors)
      indices = 0
      outcount = 0
      call MPI_Request_get_status_some(2, requests, outcount, indices,
     &                                 statuses, ierr)
      call check_success_or_unsupported(ierr, errors)

      call MPI_Comm_group(MPI_COMM_WORLD, world_group, ierr)
      call check_success(ierr, errors)
      ranks1(1) = 0
      call MPI_Group_incl(world_group, 1, ranks1, one_group, ierr)
      call check_success(ierr, errors)
      ranks2(1) = -1
      call MPI_Group_translate_ranks(one_group, 1, ranks1, world_group,
     &                               ranks2, ierr)
      call check_success(ierr, errors)
      if (ranks2(1) .ne. 0) errors = errors + 1

      call MPI_Group_union(one_group, world_group, union_group, ierr)
      call check_success(ierr, errors)
      call MPI_Group_size(union_group, group_size, ierr)
      call check_success(ierr, errors)
      if (group_size .ne. nproc) errors = errors + 1

      call MPI_Group_intersection(one_group, world_group,
     &                            intersection_group, ierr)
      call check_success(ierr, errors)
      call MPI_Group_difference(world_group, one_group, difference_group,
     &                          ierr)
      call check_success(ierr, errors)
      call MPI_Group_excl(world_group, 1, ranks1, excl_group, ierr)
      call check_success(ierr, errors)

      ranges(1,1) = 0
      ranges(2,1) = nproc - 1
      ranges(3,1) = 1
      call MPI_Group_range_incl(world_group, 1, ranges, range_incl_group,
     &                          ierr)
      call check_success(ierr, errors)
      ranges(1,1) = 0
      ranges(2,1) = 0
      ranges(3,1) = 1
      call MPI_Group_range_excl(world_group, 1, ranges, range_excl_group,
     &                          ierr)
      call check_success(ierr, errors)

      call MPI_Group_free(range_excl_group, ierr)
      call check_success(ierr, errors)
      call MPI_Group_free(range_incl_group, ierr)
      call check_success(ierr, errors)
      call MPI_Group_free(excl_group, ierr)
      call check_success(ierr, errors)
      call MPI_Group_free(difference_group, ierr)
      call check_success(ierr, errors)
      call MPI_Group_free(intersection_group, ierr)
      call check_success(ierr, errors)
      call MPI_Group_free(union_group, ierr)
      call check_success(ierr, errors)
      call MPI_Group_free(one_group, ierr)
      call check_success(ierr, errors)
      call MPI_Group_free(world_group, ierr)
      call check_success(ierr, errors)

      logical_size = 4
      logical_true = .true.
      logical_false = .false.
      call MPI_Abi_set_fortran_booleans(logical_size, logical_true,
     &                                  logical_false, ierr)
      call check_success_or_unsupported(ierr, errors)
      is_set = .false.
      call MPI_Abi_get_fortran_booleans(logical_size, logical_true,
     &                                  logical_false, is_set, ierr)
      call check_success_or_unsupported(ierr, errors)
      call MPI_Abi_get_version(abi_major, abi_minor, ierr)
      call check_success_or_unsupported(ierr, errors)
      info = MPI_INFO_NULL
      call MPI_Abi_get_info(info, ierr)
      call check_success_or_unsupported(ierr, errors)
      if (ierr .eq. MPI_SUCCESS .and. info .ne. MPI_INFO_NULL) then
          call MPI_Info_free(info, ierr)
          call check_success(ierr, errors)
      endif
      info = MPI_INFO_NULL
      call MPI_Abi_get_fortran_info(info, ierr)
      call check_success_or_unsupported(ierr, errors)
      if (ierr .eq. MPI_SUCCESS .and. info .ne. MPI_INFO_NULL) then
          call MPI_Info_free(info, ierr)
          call check_success(ierr, errors)
      endif
      call MPI_Info_create(info, ierr)
      call check_success(ierr, errors)
      if (ierr .eq. MPI_SUCCESS) then
          call MPI_Abi_set_fortran_info(info, ierr)
          call check_success_or_unsupported(ierr, errors)
          call MPI_Info_free(info, ierr)
          call check_success(ierr, errors)
      endif

      call MPI_Finalize(ierr)
      call check_success(ierr, errors)

      if (errors .eq. 0) then
          print *, 'Test passed'
      else
          print *, 'Test failed with ', errors, ' errors'
          stop 1
      endif
      end

      subroutine check_success(ierr, errors)
      implicit none
      include 'mpif.h'
      integer ierr, errors
      if (ierr .ne. MPI_SUCCESS) errors = errors + 1
      end

      subroutine check_success_or_unsupported(ierr, errors)
      implicit none
      include 'mpif.h'
      integer ierr, errors
      if (ierr .ne. MPI_SUCCESS .and.
     &    ierr .ne. MPI_ERR_UNSUPPORTED_OPERATION) errors = errors + 1
      end
