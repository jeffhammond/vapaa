program test_datatype_more_coverage
    use mpi_f08
    implicit none

    integer :: ierr, rank, nranks
    integer :: type_size, combiner, ni, na, nd
    integer :: int_blocks(2), int_disps(2)
    integer :: gsizes(2), distribs(2), dargs(2), psizes(2)
    integer :: ints(8)
    integer(kind=MPI_ADDRESS_KIND) :: aint_disps(2), lb, extent
    integer(kind=MPI_COUNT_KIND) :: count_blocks(2), count_disps(2)
    integer(kind=MPI_COUNT_KIND) :: c_gsizes(2)
    integer(kind=MPI_COUNT_KIND) :: ni_c, na_c, nl_c, nd_c
    integer(kind=MPI_COUNT_KIND) :: c_size, c_lb, c_extent
    type(MPI_Datatype) :: dtype, dtype2, pairtype
    type(MPI_Datatype) :: source_types(2), contents_types(4)
    integer(kind=MPI_ADDRESS_KIND) :: contents_addrs(8)
    integer(kind=MPI_COUNT_KIND) :: contents_counts(8)

    call MPI_Init(ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Init")
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_rank")
    call MPI_Comm_size(MPI_COMM_WORLD, nranks, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_size")
    call MPI_Comm_set_errhandler(MPI_COMM_SELF, MPI_ERRORS_RETURN, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Comm_set_errhandler self")
    call require(nranks == 4, "this test expects four ranks")

    int_blocks = [1, 2]
    int_disps = [0, 3]
    aint_disps = [0_MPI_ADDRESS_KIND, 32_MPI_ADDRESS_KIND]
    count_blocks = [1_MPI_COUNT_KIND, 2_MPI_COUNT_KIND]
    count_disps = [0_MPI_COUNT_KIND, 32_MPI_COUNT_KIND]
    source_types = [MPI_INTEGER, MPI_DOUBLE_PRECISION]

    call MPI_Type_size_x(MPI_INTEGER, c_size, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_size_x")
    call require(c_size > 0_MPI_COUNT_KIND, "MPI_Type_size_x payload")

    call MPI_Type_get_extent(MPI_INTEGER, lb, extent, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_get_extent")
    call MPI_Type_get_extent(MPI_INTEGER, c_lb, c_extent, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_get_extent_c")
    call MPI_Type_get_true_extent(MPI_INTEGER, lb, extent, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_get_true_extent")
    call MPI_Type_get_true_extent(MPI_INTEGER, c_lb, c_extent, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_get_true_extent_c")

    call MPI_Type_create_resized(MPI_INTEGER, 0_MPI_ADDRESS_KIND, &
                                 64_MPI_ADDRESS_KIND, dtype, ierr)
    call commit_and_free(dtype, "MPI_Type_create_resized")

    call MPI_Type_create_hvector(2, 1, 16_MPI_ADDRESS_KIND, &
                                 MPI_INTEGER, dtype, ierr)
    call commit_and_free(dtype, "MPI_Type_create_hvector")

    call MPI_Type_create_hvector(2_MPI_COUNT_KIND, 1_MPI_COUNT_KIND, &
                                 16_MPI_COUNT_KIND, MPI_INTEGER, dtype, ierr)
    call commit_and_free(dtype, "MPI_Type_create_hvector_c")

    call MPI_Type_create_hindexed(2, int_blocks, aint_disps, &
                                  MPI_INTEGER, dtype, ierr)
    call commit_and_free(dtype, "MPI_Type_create_hindexed")

    call MPI_Type_create_hindexed(2_MPI_COUNT_KIND, count_blocks, &
                                  count_disps, MPI_INTEGER, dtype, ierr)
    call commit_and_free(dtype, "MPI_Type_create_hindexed_c")

    call MPI_Type_create_hindexed_block(2, 1, aint_disps, &
                                        MPI_INTEGER, dtype, ierr)
    call commit_and_free(dtype, "MPI_Type_create_hindexed_block")

    call MPI_Type_create_hindexed_block(2_MPI_COUNT_KIND, &
                                        1_MPI_COUNT_KIND, count_disps, &
                                        MPI_INTEGER, dtype, ierr)
    call commit_and_free(dtype, "MPI_Type_create_hindexed_block_c")

    call MPI_Type_create_indexed_block(2, 1, int_disps, &
                                       MPI_INTEGER, dtype, ierr)
    call commit_and_free(dtype, "MPI_Type_create_indexed_block")

    call MPI_Type_create_indexed_block(2_MPI_COUNT_KIND, &
                                       1_MPI_COUNT_KIND, count_disps, &
                                       MPI_INTEGER, dtype, ierr)
    call commit_and_free(dtype, "MPI_Type_create_indexed_block_c")

    call MPI_Type_indexed(2, int_blocks, int_disps, MPI_INTEGER, &
                          dtype, ierr)
    call commit_and_free(dtype, "MPI_Type_indexed")

    call MPI_Type_indexed(2_MPI_COUNT_KIND, count_blocks, count_disps, &
                          MPI_INTEGER, dtype, ierr)
    call commit_and_free(dtype, "MPI_Type_indexed_c")

    call MPI_Type_create_struct(2, int_blocks, aint_disps, source_types, &
                                dtype, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_create_struct")
    call inspect_contents(dtype)
    call MPI_Type_free(dtype, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_free struct")

    call MPI_Type_create_struct(2_MPI_COUNT_KIND, count_blocks, &
                                count_disps, source_types, dtype, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_create_struct_c")
    call inspect_contents_c(dtype)
    call MPI_Type_free(dtype, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_free struct_c")

    gsizes = [8, 8]
    c_gsizes = [8_MPI_COUNT_KIND, 8_MPI_COUNT_KIND]
    distribs = [MPI_DISTRIBUTE_BLOCK, MPI_DISTRIBUTE_BLOCK]
    dargs = [MPI_DISTRIBUTE_DFLT_DARG, MPI_DISTRIBUTE_DFLT_DARG]
    psizes = [2, 2]
    call MPI_Type_create_darray(4, rank, 2, gsizes, distribs, dargs, &
                                psizes, MPI_ORDER_FORTRAN, MPI_INTEGER, &
                                dtype, ierr)
    call commit_and_free(dtype, "MPI_Type_create_darray")

    call MPI_Type_create_darray(4, rank, 2, c_gsizes, distribs, dargs, &
                                psizes, MPI_ORDER_FORTRAN, MPI_INTEGER, &
                                dtype, ierr)
    call commit_and_free(dtype, "MPI_Type_create_darray_c")

    call MPI_Type_create_f90_integer(9, dtype, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_create_f90_integer")
    call MPI_Type_create_f90_integer(9, dtype2, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_create_f90_integer cached")
    call require(dtype % MPI_VAL == dtype2 % MPI_VAL, "f90 integer cache")

    call MPI_Type_create_f90_real(6, 30, dtype, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_create_f90_real")
    call MPI_Type_create_f90_complex(6, 30, dtype, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_create_f90_complex")

    call MPI_Type_match_size(MPI_TYPECLASS_INTEGER, 4, dtype, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_match_size integer")
    call MPI_Type_match_size(MPI_TYPECLASS_REAL, 8, dtype, ierr)
    call require(ierr == MPI_SUCCESS, "MPI_Type_match_size real")

    call MPI_Type_get_value_index(MPI_DOUBLE_PRECISION, MPI_INTEGER, &
                                  pairtype, ierr)
    call require(ierr == MPI_SUCCESS .or. &
                 ierr == MPI_ERR_UNSUPPORTED_OPERATION, &
                 "MPI_Type_get_value_index")

    if (rank == 0) print *, "Test passed"
    call MPI_Finalize(ierr)

contains

    subroutine require(ok, label)
        logical, intent(in) :: ok
        character(len=*), intent(in) :: label

        if (.not. ok) then
            print *, "FAIL:", trim(label), "rank", rank, "ierr", ierr
            call MPI_Abort(MPI_COMM_WORLD, 1, ierr)
        end if
    end subroutine require

    subroutine commit_and_free(datatype, label)
        type(MPI_Datatype), intent(inout) :: datatype
        character(len=*), intent(in) :: label

        call require(ierr == MPI_SUCCESS, label)
        call MPI_Type_commit(datatype, ierr)
        call require(ierr == MPI_SUCCESS, trim(label) // " commit")
        call MPI_Type_size(datatype, type_size, ierr)
        call require(ierr == MPI_SUCCESS, trim(label) // " size")
        call require(type_size > 0, trim(label) // " payload")
        call MPI_Type_free(datatype, ierr)
        call require(ierr == MPI_SUCCESS, trim(label) // " free")
    end subroutine commit_and_free

    subroutine inspect_contents(datatype)
        type(MPI_Datatype), intent(in) :: datatype

        ni = -1
        na = -1
        nd = -1
        combiner = -1
        call MPI_Type_get_envelope(datatype, ni, na, nd, combiner, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_get_envelope struct")
        ints = -1
        contents_addrs = -1
        contents_types = MPI_DATATYPE_NULL
        call MPI_Type_get_contents(datatype, 8, 8, 4, ints, &
                                   contents_addrs, contents_types, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_get_contents struct")
        call require(contents_types(1) == MPI_INTEGER, &
                     "contents struct type 1")
        call require(contents_types(2) == MPI_DOUBLE_PRECISION, &
                     "contents struct type 2")
    end subroutine inspect_contents

    subroutine inspect_contents_c(datatype)
        type(MPI_Datatype), intent(in) :: datatype
        integer(kind=MPI_COUNT_KIND) :: max_l

        ni_c = -1_MPI_COUNT_KIND
        na_c = -1_MPI_COUNT_KIND
        nl_c = -1_MPI_COUNT_KIND
        nd_c = -1_MPI_COUNT_KIND
        combiner = -1
        call MPI_Type_get_envelope(datatype, ni_c, na_c, nl_c, nd_c, &
                                   combiner, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_get_envelope_c")
        max_l = nl_c
        ints = -1
        contents_addrs = -1
        contents_counts = -1
        contents_types = MPI_DATATYPE_NULL
        call MPI_Type_get_contents(datatype, 8_MPI_COUNT_KIND, &
                                   8_MPI_COUNT_KIND, max_l, &
                                   4_MPI_COUNT_KIND, ints, &
                                   contents_addrs, contents_counts, &
                                   contents_types, ierr)
        call require(ierr == MPI_SUCCESS, "MPI_Type_get_contents_c")
        call require(contents_types(1) == MPI_INTEGER, &
                     "contents_c struct type 1")
        call require(contents_types(2) == MPI_DOUBLE_PRECISION, &
                     "contents_c struct type 2")
    end subroutine inspect_contents_c

end program test_datatype_more_coverage
