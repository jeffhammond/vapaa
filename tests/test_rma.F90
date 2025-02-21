module rma_test
    use mpi_f08
    implicit none
    private

    public :: test_rma_operations

    ! Window creation methods
    integer, parameter :: WIN_CREATE = 1
    integer, parameter :: WIN_ALLOCATE = 2
    integer, parameter :: WIN_CREATE_DYNAMIC = 3
    integer, parameter :: WIN_ALLOCATE_SHARED = 4

    type :: test_config
        integer :: win_type        ! Window creation method
        integer :: datatype_enum  ! INTEGER or REAL
        integer :: buffer_size    ! Number of elements
    end type test_config

contains
    subroutine test_rma_operations(config, success)
        implicit none
        type(test_config), intent(in) :: config
        logical, intent(out) :: success
        
        type(MPI_Win) :: win
        type(MPI_Datatype) :: dtype
        type(MPI_Info) :: info
        type(MPI_Comm) :: comm
        integer :: rank, size, target_rank
        integer :: disp_unit
        integer(kind=MPI_ADDRESS_KIND) :: win_size
        integer :: ierr
        
        ! Dynamic arrays for data
        integer, allocatable, target :: int_buffer(:), int_result(:)
        real, allocatable, target :: real_buffer(:), real_result(:)
        integer, pointer :: int_win_buffer(:) => null()
        real, pointer :: real_win_buffer(:) => null()

        success = .false.
        
        call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
        call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)
        if (size < 2) then
            if (rank == 0) print *, "Need at least 2 processes"
            return
        end if

        ! Set up target rank (circular)
        target_rank = mod(rank + 1, size)
        
        ! Set up datatype and allocate buffers
        select case (config%datatype_enum)
            case (1)
                dtype = MPI_INTEGER
                allocate(int_buffer(config%buffer_size))
                allocate(int_result(config%buffer_size))
                int_buffer = rank  ! Initialize with rank
                int_result = -1    ! Initialize with sentinel
            case (2)
                dtype = MPI_REAL
                allocate(real_buffer(config%buffer_size))
                allocate(real_result(config%buffer_size))
                real_buffer = real(rank)  ! Initialize with rank
                real_result = -1.0        ! Initialize with sentinel
        end select

        ! Window creation
        disp_unit = 1
        win_size = config%buffer_size * storage_size(int_buffer(1))/8
        call MPI_Info_create(info, ierr)
        
        select case (config%win_type)
            case (WIN_CREATE)
                if (config%datatype_enum == 1) then
                    call MPI_Win_create(int_buffer, win_size, disp_unit, info, &
                                      MPI_COMM_WORLD, win, ierr)
                else
                    call MPI_Win_create(real_buffer, win_size, disp_unit, info, &
                                      MPI_COMM_WORLD, win, ierr)
                end if

            case (WIN_ALLOCATE)
                if (config%datatype_enum == 2) then
                    call MPI_Win_allocate(win_size, disp_unit, info, MPI_COMM_WORLD, &
                                        int_win_buffer, win, ierr)
                    int_win_buffer = rank
                else
                    call MPI_Win_allocate(win_size, disp_unit, info, MPI_COMM_WORLD, &
                                          real_win_buffer, win, ierr)
                    real_win_buffer = real(rank)
                end if

            case (WIN_CREATE_DYNAMIC)
                call MPI_Win_create_dynamic(info, MPI_COMM_WORLD, win, ierr)
                if (config%datatype_enum == 1) then
                    call MPI_Win_attach(win, int_buffer, win_size, ierr)
                else
                    call MPI_Win_attach(win, real_buffer, win_size, ierr)
                end if

            case (WIN_ALLOCATE_SHARED)
                if (config%datatype_enum == 1) then
                    call MPI_Win_allocate_shared(win_size, disp_unit, info, &
                                               MPI_COMM_WORLD, int_win_buffer, win, ierr)
                    int_win_buffer = rank
                else
                    call MPI_Win_allocate_shared(win_size, disp_unit, info, &
                                               MPI_COMM_WORLD, real_win_buffer, win, ierr)
                    real_win_buffer = real(rank)
                end if
        end select

        ! Perform RMA operations
        call MPI_Win_fence(0, win, ierr)

        ! Put operation
        if (config%datatype_enum == 1) then
            call MPI_Put(int_buffer, config%buffer_size, dtype, target_rank, &
                        0_MPI_ADDRESS_KIND, config%buffer_size, dtype, win, ierr)
        else
            call MPI_Put(real_buffer, config%buffer_size, dtype, target_rank, &
                        0_MPI_ADDRESS_KIND, config%buffer_size, dtype, win, ierr)
        end if

        call MPI_Win_fence(0, win, ierr)

        ! Accumulate operation (add)
        if (config%datatype_enum == 1) then
            call MPI_Accumulate(int_buffer, config%buffer_size, dtype, target_rank, &
                              0_MPI_ADDRESS_KIND, config%buffer_size, dtype, MPI_SUM, win, ierr)
        else
            call MPI_Accumulate(real_buffer, config%buffer_size, dtype, target_rank, &
                              0_MPI_ADDRESS_KIND, config%buffer_size, dtype, MPI_SUM, win, ierr)
        end if

        call MPI_Win_fence(0, win, ierr)

        ! Get operation
        if (config%datatype_enum == 1) then
            call MPI_Get(int_result, config%buffer_size, dtype, target_rank, &
                        0_MPI_ADDRESS_KIND, config%buffer_size, dtype, win, ierr)
        else
            call MPI_Get(real_result, config%buffer_size, dtype, target_rank, &
                        0_MPI_ADDRESS_KIND, config%buffer_size, dtype, win, ierr)
        end if

        call MPI_Win_fence(0, win, ierr)

        ! Verify results
        if (config%datatype_enum == 1) then
            ! Expected value is source_rank + target_rank due to accumulate
            success = all(int_result == mod(rank - 1 + size, size) + mod(rank - 1 + size, size))
        else
            success = all(abs(real_result - (real(mod(rank - 1 + size, size)) + &
                                           real(mod(rank - 1 + size, size)))) < 1.0e-5)
        end if

        ! Cleanup
        if (config%win_type == WIN_CREATE_DYNAMIC) then
            if (config%datatype_enum == 1) then
                call MPI_Win_detach(win, int_buffer, ierr)
            else
                call MPI_Win_detach(win, real_buffer, ierr)
            end if
        end if

        call MPI_Win_free(win, ierr)
        call MPI_Info_free(info, ierr)

        if (allocated(int_buffer)) deallocate(int_buffer)
        if (allocated(int_result)) deallocate(int_result)
        if (allocated(real_buffer)) deallocate(real_buffer)
        if (allocated(real_result)) deallocate(real_result)
    end subroutine test_rma_operations
end module rma_test

program test_rma
    use mpi_f08
    use rma_test
    implicit none

    type(test_config) :: config
    logical :: success
    integer :: ierr, rank
    character(len=32) :: arg

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

    ! Get runtime configuration (you could read from command line or input file)
    if (command_argument_count() >= 3) then
        call get_command_argument(1, arg)
        read(arg, *) config%win_type
        call get_command_argument(2, arg)
        read(arg, *) config%datatype_enum
        call get_command_argument(3, arg)
        read(arg, *) config%buffer_size
    else
        ! Default configuration
        config%win_type = WIN_ALLOCATE
        config%datatype_enum = 1
        config%buffer_size = 100
    end if

    call test_rma_operations(config, success)

    if (rank == 0) then
        if (success) then
            print *, "Test passed!"
        else
            print *, "Test failed!"
        end if
    end if

    call MPI_Finalize(ierr)
end program test_rma
