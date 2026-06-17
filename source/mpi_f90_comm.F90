! SPDX-License-Identifier: MIT

module mpi_f90_comm
    use iso_c_binding, only: c_int
    implicit none
    private

    public :: MPI_Comm_rank
    public :: MPI_Comm_size
    public :: MPI_Comm_dup
    public :: MPI_Comm_free
    public :: MPI_Comm_split
    public :: MPI_Comm_get_parent
    public :: MPI_Comm_remote_size
    public :: MPI_Comm_get_attr
    public :: MPI_Comm_set_attr
    public :: MPI_Comm_free_keyval

    interface MPI_Comm_rank
        module procedure MPI_Comm_rank_f90
    end interface
    interface MPI_Comm_size
        module procedure MPI_Comm_size_f90
    end interface
    interface MPI_Comm_dup
        module procedure MPI_Comm_dup_f90
    end interface
    interface MPI_Comm_free
        module procedure MPI_Comm_free_f90
    end interface
    interface MPI_Comm_split
        module procedure MPI_Comm_split_f90
    end interface
    interface MPI_Comm_get_parent
        module procedure MPI_Comm_get_parent_f90
    end interface
    interface MPI_Comm_remote_size
        module procedure MPI_Comm_remote_size_f90
    end interface
    interface MPI_Comm_get_attr
        module procedure MPI_Comm_get_attr_aint_f90
        module procedure MPI_Comm_get_attr_int_f90
    end interface
    interface MPI_Comm_set_attr
        module procedure MPI_Comm_set_attr_aint_f90
        module procedure MPI_Comm_set_attr_int_f90
    end interface
    interface MPI_Comm_free_keyval
        module procedure MPI_Comm_free_keyval_f90
    end interface

contains

    subroutine MPI_Comm_rank_f90(comm, rank, ierror)
        use mpi_comm_c, only: C_MPI_Comm_rank
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: comm
        integer, intent(out) :: rank
        integer, optional, intent(out) :: ierror
        integer(c_int) :: rank_c, ierror_c
        call C_MPI_Comm_rank(int(comm,c_int), rank_c, ierror_c)
        rank = rank_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Comm_rank_f90

    subroutine MPI_Comm_size_f90(comm, size, ierror)
        use mpi_comm_c, only: C_MPI_Comm_size
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: comm
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        integer(c_int) :: size_c, ierror_c
        call C_MPI_Comm_size(int(comm,c_int), size_c, ierror_c)
        size = size_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Comm_size_f90

    subroutine MPI_Comm_dup_f90(comm, newcomm, ierror)
        use mpi_comm_c, only: C_MPI_Comm_dup
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: comm
        integer, intent(out) :: newcomm
        integer, optional, intent(out) :: ierror
        integer(c_int) :: newcomm_c, ierror_c
        call C_MPI_Comm_dup(int(comm,c_int), newcomm_c, ierror_c)
        newcomm = newcomm_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Comm_dup_f90

    subroutine MPI_Comm_free_f90(comm, ierror)
        use mpi_comm_c, only: C_MPI_Comm_free
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(inout) :: comm
        integer, optional, intent(out) :: ierror
        integer(c_int) :: comm_c, ierror_c
        comm_c = comm
        call C_MPI_Comm_free(comm_c, ierror_c)
        comm = comm_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Comm_free_f90

    subroutine MPI_Comm_split_f90(comm, color, key, newcomm, ierror)
        use mpi_comm_c, only: C_MPI_Comm_split
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: comm, color, key
        integer, intent(out) :: newcomm
        integer, optional, intent(out) :: ierror
        integer(c_int) :: newcomm_c, ierror_c
        call C_MPI_Comm_split(int(comm,c_int), int(color,c_int), int(key,c_int), newcomm_c, ierror_c)
        newcomm = newcomm_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Comm_split_f90

    subroutine MPI_Comm_get_parent_f90(parent, ierror)
        use mpi_direct_comm_c, only: VAPAA_MPI_Comm_get_parent
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(out) :: parent
        integer, optional, intent(out) :: ierror
        integer(c_int) :: parent_c, ierror_c
        call VAPAA_MPI_Comm_get_parent(parent_c, ierror_c)
        parent = parent_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Comm_get_parent_f90

    subroutine MPI_Comm_remote_size_f90(comm, size, ierror)
        use mpi_direct_comm_c, only: VAPAA_MPI_Comm_remote_size
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: comm
        integer, intent(out) :: size
        integer, optional, intent(out) :: ierror
        integer(c_int) :: size_c, ierror_c
        call VAPAA_MPI_Comm_remote_size(int(comm,c_int), size_c, ierror_c)
        size = size_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Comm_remote_size_f90

    subroutine MPI_Comm_get_attr_aint_f90(comm, comm_keyval, attribute_val, flag, ierror)
        use iso_c_binding, only: c_intptr_t
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_direct_comm_c, only: VAPAA_MPI_Comm_get_attr
        use mpi_f90_util, only: f90_finish_ierror, f90_logical_from_c
        integer, intent(in) :: comm, comm_keyval
        integer(kind=MPI_ADDRESS_KIND), intent(out) :: attribute_val
        logical, intent(out) :: flag
        integer, optional, intent(out) :: ierror
        integer(c_intptr_t) :: attribute_val_c
        integer(c_int) :: flag_c, ierror_c
        call VAPAA_MPI_Comm_get_attr(int(comm,c_int), int(comm_keyval,c_int), attribute_val_c, flag_c, ierror_c)
        attribute_val = attribute_val_c
        flag = f90_logical_from_c(flag_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Comm_get_attr_aint_f90

    subroutine MPI_Comm_get_attr_int_f90(comm, comm_keyval, attribute_val, flag, ierror)
        use iso_c_binding, only: c_intptr_t
        use mpi_direct_comm_c, only: VAPAA_MPI_Comm_get_attr
        use mpi_f90_util, only: f90_finish_ierror, f90_logical_from_c
        integer, intent(in) :: comm, comm_keyval
        integer, intent(out) :: attribute_val
        logical, intent(out) :: flag
        integer, optional, intent(out) :: ierror
        integer(c_intptr_t) :: attribute_val_c
        integer(c_int) :: flag_c, ierror_c
        call VAPAA_MPI_Comm_get_attr(int(comm,c_int), int(comm_keyval,c_int), attribute_val_c, flag_c, ierror_c)
        attribute_val = int(attribute_val_c)
        flag = f90_logical_from_c(flag_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Comm_get_attr_int_f90

    subroutine MPI_Comm_set_attr_aint_f90(comm, comm_keyval, attribute_val, ierror)
        use iso_c_binding, only: c_intptr_t
        use mpi_f90_constants, only: MPI_ADDRESS_KIND
        use mpi_direct_comm_c, only: VAPAA_MPI_Comm_set_attr
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: comm, comm_keyval
        integer(kind=MPI_ADDRESS_KIND), intent(in) :: attribute_val
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
        call VAPAA_MPI_Comm_set_attr(int(comm,c_int), int(comm_keyval,c_int), int(attribute_val,c_intptr_t), ierror_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Comm_set_attr_aint_f90

    subroutine MPI_Comm_set_attr_int_f90(comm, comm_keyval, attribute_val, ierror)
        use iso_c_binding, only: c_intptr_t
        use mpi_direct_comm_c, only: VAPAA_MPI_Comm_set_attr
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(in) :: comm, comm_keyval, attribute_val
        integer, optional, intent(out) :: ierror
        integer(c_int) :: ierror_c
        call VAPAA_MPI_Comm_set_attr(int(comm,c_int), int(comm_keyval,c_int), int(attribute_val,c_intptr_t), ierror_c)
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Comm_set_attr_int_f90

    subroutine MPI_Comm_free_keyval_f90(comm_keyval, ierror)
        use mpi_direct_comm_c, only: VAPAA_MPI_Comm_free_keyval
        use mpi_f90_util, only: f90_finish_ierror
        integer, intent(inout) :: comm_keyval
        integer, optional, intent(out) :: ierror
        integer(c_int) :: keyval_c, ierror_c
        keyval_c = comm_keyval
        call VAPAA_MPI_Comm_free_keyval(keyval_c, ierror_c)
        comm_keyval = keyval_c
        call f90_finish_ierror(ierror, ierror_c)
    end subroutine MPI_Comm_free_keyval_f90

end module mpi_f90_comm
