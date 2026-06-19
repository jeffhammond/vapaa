! SPDX-License-Identifier: MIT

module mpi_f90_core
    use iso_c_binding, only: c_int
    implicit none
    private

    public :: MPI_Init
    public :: MPI_Finalize
    public :: MPI_Init_thread
    public :: MPI_Initialized
    public :: MPI_Finalized
    public :: MPI_Query_thread
    public :: MPI_Is_thread_main
    public :: MPI_Abort
    public :: MPI_Get_version
    public :: MPI_Get_library_version
    public :: MPI_Get_processor_name
    public :: MPI_Wtime
    public :: PMPI_Wtime
    public :: MPI_Wtick
    public :: PMPI_Wtick
    public :: MPI_Pcontrol

    interface MPI_Init
        module procedure MPI_Init_f90
    end interface
    interface MPI_Finalize
        module procedure MPI_Finalize_f90
    end interface
    interface MPI_Init_thread
        module procedure MPI_Init_thread_f90
    end interface
    interface MPI_Initialized
        module procedure MPI_Initialized_f90
    end interface
    interface MPI_Finalized
        module procedure MPI_Finalized_f90
    end interface
    interface MPI_Query_thread
        module procedure MPI_Query_thread_f90
    end interface
    interface MPI_Is_thread_main
        module procedure MPI_Is_thread_main_f90
    end interface
    interface MPI_Abort
        module procedure MPI_Abort_f90
    end interface
    interface MPI_Get_version
        module procedure MPI_Get_version_f90
    end interface
    interface MPI_Get_library_version
        module procedure MPI_Get_library_version_f90
    end interface
    interface MPI_Get_processor_name
        module procedure MPI_Get_processor_name_f90
    end interface
    interface MPI_Wtime
        module procedure MPI_Wtime_f90
    end interface
    interface PMPI_Wtime
        module procedure MPI_Wtime_f90
    end interface
    interface MPI_Wtick
        module procedure MPI_Wtick_f90
    end interface
    interface PMPI_Wtick
        module procedure MPI_Wtick_f90
    end interface
    interface MPI_Pcontrol
        module procedure MPI_Pcontrol_f90
    end interface

contains

    subroutine F90_Check_design_assumptions()
        use iso_c_binding, only: c_sizeof, c_int
        if (c_sizeof(int(0,c_int)) /= c_sizeof(0)) then
            print *, 'Vapaa mpi module requires default INTEGER to match C int'
            stop 1
        end if
    end subroutine F90_Check_design_assumptions

    subroutine F90_MPI_INIT_ADDRESS_SENTINELS()
        use detect_sentinels_c
        use mpi_f90_constants, only: MPI_ARGV_NULL, MPI_ARGVS_NULL, MPI_BOTTOM, MPI_ERRCODES_IGNORE, &
                                     MPI_IN_PLACE, MPI_STATUSES_IGNORE, MPI_STATUS_IGNORE, &
                                     MPI_UNWEIGHTED, MPI_WEIGHTS_EMPTY
        call C_MPI_BOTTOM(MPI_BOTTOM)
        call C_MPI_STATUS_IGNORE(MPI_STATUS_IGNORE)
        call C_MPI_STATUSES_IGNORE(MPI_STATUSES_IGNORE)
        call C_MPI_ERRCODES_IGNORE(MPI_ERRCODES_IGNORE)
        call C_MPI_IN_PLACE(MPI_IN_PLACE)
        call C_MPI_ARGV_NULL(MPI_ARGV_NULL)
        call C_MPI_ARGVS_NULL(MPI_ARGVS_NULL)
        call C_MPI_UNWEIGHTED(MPI_UNWEIGHTED)
        call C_MPI_WEIGHTS_EMPTY(MPI_WEIGHTS_EMPTY)
    end subroutine F90_MPI_INIT_ADDRESS_SENTINELS

    subroutine F90_MPI_INIT_ABI_FORTRAN(ierror_c)
        use iso_c_binding, only: c_int, c_int8_t
        use mpi_core_c, only: C_MPI_Abi_init_fortran
        integer(c_int), intent(inout) :: ierror_c
#ifdef MPI_ABI
        integer(c_int) :: abi_ierror_c
        integer(c_int) :: logical_size_c, integer_size_c, real_size_c, double_precision_size_c
        integer(c_int8_t) :: logical_true_bytes(8), logical_false_bytes(8)

        if (ierror_c /= 0) return

        logical_size_c = storage_size(.true.) / 8
        if (logical_size_c > size(logical_true_bytes)) then
            ierror_c = -1
            return
        end if

        integer_size_c = storage_size(0) / 8
        real_size_c = storage_size(0.0) / 8
        double_precision_size_c = storage_size(0.0d0) / 8
        logical_true_bytes = 0_c_int8_t
        logical_false_bytes = 0_c_int8_t
        logical_true_bytes(1:logical_size_c) = transfer(.true., logical_true_bytes(1:logical_size_c))
        logical_false_bytes(1:logical_size_c) = transfer(.false., logical_false_bytes(1:logical_size_c))

        call C_MPI_Abi_init_fortran(logical_size_c, logical_true_bytes, logical_false_bytes, &
                                    integer_size_c, real_size_c, double_precision_size_c, abi_ierror_c)
        if (abi_ierror_c /= 0) ierror_c = abi_ierror_c
#else
        if (ierror_c /= 0) continue
#endif
    end subroutine F90_MPI_INIT_ABI_FORTRAN

    subroutine MPI_Init_f90(ierror)
        use mpi_core_c, only: C_MPI_Init
        use mpi_f90_util, only: f90_finish_ierror
        use mpi_verbose_f, only: VAPAA_VERBOSE_INIT
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
        call C_MPI_Init(ierror_c)
        call F90_MPI_INIT_ABI_FORTRAN(ierror_c)
        call F90_MPI_INIT_ADDRESS_SENTINELS()
        call F90_Check_design_assumptions()
        if (ierror_c == 0_c_int) call VAPAA_VERBOSE_INIT('mpi')
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Init_f90

    subroutine MPI_Init_thread_f90(required, provided, ierror)
        use mpi_core_c, only: C_MPI_Init_thread
        use mpi_f90_util, only: f90_finish_ierror
        use mpi_verbose_f, only: VAPAA_VERBOSE_INIT
        integer, intent(in) :: required
        integer, intent(out) :: provided
        integer, optional, intent(out) :: ierror
        integer(c_int) :: required_c, provided_c, ierror_c
        required_c = required
        call C_MPI_Init_thread(required_c, provided_c, ierror_c)
        provided = provided_c
        call F90_MPI_INIT_ABI_FORTRAN(ierror_c)
        call F90_MPI_INIT_ADDRESS_SENTINELS()
        call F90_Check_design_assumptions()
        if (ierror_c == 0_c_int) call VAPAA_VERBOSE_INIT('mpi')
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Init_thread_f90

    subroutine MPI_Finalize_f90(ierror)
        use mpi_core_c, only: C_MPI_Finalize
        use mpi_f90_util, only: f90_finish_ierror
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
        call C_MPI_Finalize(ierror_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Finalize_f90

    subroutine MPI_Initialized_f90(flag, ierror)
        use mpi_core_c, only: C_MPI_Initialized
        use mpi_f90_util, only: f90_finish_ierror, f90_logical_from_c
        logical, intent(out) :: flag
        integer, optional, intent(out) :: ierror
        integer(c_int) :: flag_c, ierror_c
        call C_MPI_Initialized(flag_c, ierror_c)
        flag = f90_logical_from_c(flag_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Initialized_f90

    subroutine MPI_Finalized_f90(flag, ierror)
        use mpi_core_c, only: C_MPI_Finalized
        use mpi_f90_util, only: f90_finish_ierror, f90_logical_from_c
        logical, intent(out) :: flag
        integer, optional, intent(out) :: ierror
        integer(c_int) :: flag_c, ierror_c
        call C_MPI_Finalized(flag_c, ierror_c)
        flag = f90_logical_from_c(flag_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Finalized_f90

    subroutine MPI_Query_thread_f90(provided, ierror)
        use mpi_core_c, only: C_MPI_Query_thread
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(out) :: provided
        integer, optional, intent(out) :: ierror
        integer(c_int) :: provided_c, ierror_c
        call C_MPI_Query_thread(provided_c, ierror_c)
        provided = provided_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Query_thread_f90

    subroutine MPI_Is_thread_main_f90(flag, ierror)
        use mpi_core_c, only: C_MPI_Is_thread_main
        use mpi_f90_util, only: f90_finish_ierror, f90_logical_from_c
        logical, intent(out) :: flag
        integer, optional, intent(out) :: ierror
        integer(c_int) :: flag_c, ierror_c
        call C_MPI_Is_thread_main(flag_c, ierror_c)
        flag = f90_logical_from_c(flag_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Is_thread_main_f90

    subroutine MPI_Abort_f90(comm, errorcode, ierror)
        use mpi_core_c, only: C_MPI_Abort
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: comm, errorcode
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
        call C_MPI_Abort(int(comm,c_int), int(errorcode,c_int), ierror_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Abort_f90

    subroutine MPI_Get_version_f90(version, subversion, ierror)
        use mpi_core_c, only: C_MPI_Get_version
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(out) :: version, subversion
        integer, optional, intent(out) :: ierror
        integer(c_int) :: version_c, subversion_c, ierror_c
        call C_MPI_Get_version(version_c, subversion_c, ierror_c)
        version = version_c
        subversion = subversion_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Get_version_f90

    subroutine MPI_Get_library_version_f90(version, resultlen, ierror)
#ifdef HAVE_CFI
        use mpi_core_c, only: CFI_MPI_Get_library_version
#else
        use mpi_core_c, only: C_MPI_Get_library_version
#endif
        use mpi_f90_util, only: f90_finish_ierror
        character(len=*), intent(out) :: version
        integer, intent(out) :: resultlen
        integer, optional, intent(out) :: ierror
        integer(c_int) :: resultlen_c, ierror_c
#ifdef HAVE_CFI
        call CFI_MPI_Get_library_version(version, resultlen_c, ierror_c)
#else
        call C_MPI_Get_library_version(version, resultlen_c, ierror_c)
#endif
        resultlen = resultlen_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Get_library_version_f90

    subroutine MPI_Get_processor_name_f90(name, resultlen, ierror)
        use mpi_core_c, only: C_MPI_Get_processor_name
        use mpi_f90_util, only: f90_finish_ierror
        character(len=*), intent(out) :: name
        integer, intent(out) :: resultlen
        integer, optional, intent(out) :: ierror
        integer(c_int) :: resultlen_c, ierror_c
        call C_MPI_Get_processor_name(name, resultlen_c, ierror_c)
        resultlen = resultlen_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Get_processor_name_f90

    double precision function MPI_Wtime_f90()
        use mpi_core_c, only: C_MPI_Wtime
        MPI_Wtime_f90 = C_MPI_Wtime()
    end function MPI_Wtime_f90

    double precision function MPI_Wtick_f90()
        use mpi_core_c, only: C_MPI_Wtick
        MPI_Wtick_f90 = C_MPI_Wtick()
    end function MPI_Wtick_f90

    subroutine MPI_Pcontrol_f90(level, ierror)
        use mpi_core_c, only: C_MPI_Pcontrol
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: level
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
        call C_MPI_Pcontrol(int(level,c_int), ierror_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Pcontrol_f90

end module mpi_f90_core
