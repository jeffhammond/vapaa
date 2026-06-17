# Vapaa `mpi` Module Design

This document describes the proposed implementation of the MPI Fortran `mpi`
module, commonly called the F90 module. The upstream MPICH f90 tests imported in
`tests/mpich_main/f90` are from `pmodels/mpich` main commit
`a910f2f960d354597178c6e081585870aeefe0de`.

## Test Harness

The imported f90 tests are opt-in behind `VAPAA_ENABLE_MPI_MODULE_TESTS`.
Default builds leave the tests disabled until Vapaa has a real `module mpi`.
When enabled, the CMake adapter reads upstream `testlist`, `testlist.in`, or
`testlist.ap` metadata and registers the tests with the same process counts.

The currently registered non-spawn tests will be:

| Category | Tests |
| --- | --- |
| `attr` | `fandcattrf90`, `baseattr3f90`, `attrlangf90` |
| `datatype` | `structf`, `indtype`, `createf90`, `sizeof`, `kinds`, `trf90`, `get_elem_u` |
| `misc` | `sizeof2`, `alloc_mem` |
| `timer` | `wtimef90` |

The upstream f90 spawn sources are imported but not registered, matching the
current project scope. The upstream `ext` and `io` directories contain generator
metadata at this revision but no listed f90 tests to register.

## Goals

The `mpi` module should be a thin Fortran facade over Vapaa's existing bridge
layer. It should not duplicate MPI behavior that already exists in the C bridge
or in `mpi_f08`.

The main differences from `mpi_f08` are representation:

| Surface | `mpi_f08` | `mpi` |
| --- | --- | --- |
| Handles | Derived types such as `type(MPI_Comm)` | Default `integer` |
| Status | `type(MPI_Status)` | `integer status(MPI_STATUS_SIZE)` |
| Datatypes and ops | Derived handle types | Default `integer` |
| Callbacks | f08 typed-handle callback signatures | F90 integer-handle callback signatures |
| Choice buffers | Existing CFI path | Same CFI path |

## Layering

The implementation should add a parallel Fortran facade while reusing the
existing C ABI bridge:

1. `source/mpi.F90`

   Aggregate module that exports integer constants, sentinel objects, status
   array constants, and all `mpi_*_f90` procedure modules.

2. `source/mpi_f90_constants.F90`

   Integer-handle constants generated from `vapaa_constants.h`, for example:
   `integer, parameter :: MPI_COMM_WORLD = VAPAA_MPI_COMM_WORLD`.

   This must be separate from `mpi_global_constants`, because that module
   correctly defines f08 handles as derived-type constants.

3. `source/mpi_*_f90.F90`

   Integer-handle Fortran generics and wrappers. These should mirror the current
   `mpi_*_f.F90` files, but their handle arguments are `integer` instead of
   derived types and their status arguments are integer arrays.

4. Existing `source/mpi_*_c.F90` and `source/mpi_*.c`

   Reused unchanged wherever possible. The C bridge already accepts integer
   handle values and performs ABI `*_fromint` / `*_toint` conversion, with
   fallback translation for non-ABI runtimes.

## Constants And Sentinels

The `mpi` module needs integer constants for all handles and datatypes. It can
reuse kind and scalar constants from `mpi_global_constants` where the
representation is already correct, such as `MPI_ADDRESS_KIND`,
`MPI_COUNT_KIND`, `MPI_STATUS_SIZE`, `MPI_SOURCE`, `MPI_TAG`, and `MPI_ERROR`.

Object-like sentinels need care:

| Sentinel | `mpi` representation |
| --- | --- |
| `MPI_BOTTOM` | module integer object |
| `MPI_IN_PLACE` | module integer object |
| `MPI_UNWEIGHTED` | module integer object or array sentinel as required by each interface |
| `MPI_STATUS_IGNORE` | `integer(MPI_STATUS_SIZE)` object |
| `MPI_STATUSES_IGNORE` | integer status array object |

The sentinel detector should either share storage between `mpi_f08` and `mpi`
for common integer sentinels, or be generalized to register both modules'
sentinel addresses during initialization. The production code must not call
MPI's removed `*_f2c` / `*_c2f` routines. It should keep using Vapaa's
`*_toint` / `*_fromint` path.

## Status Translation

F90 status arrays should be translated at the Fortran facade boundary or in a
small C helper layer:

1. Before calls with input statuses, map
   `status(MPI_SOURCE)`, `status(MPI_TAG)`, and `status(MPI_ERROR)` into the
   internal `MPI_Status` layout.
2. After calls with output statuses, map the internal status back into the
   integer array.
3. Preserve `MPI_STATUS_IGNORE` and `MPI_STATUSES_IGNORE` by address, not by
   integer value.

This mirrors the existing `MPI_Status_f082f` and `MPI_Status_f2f08` direction,
but the `mpi` module should expose the standard F90 integer-array status API.

## `MPI_Send` Example

`MPI_Send` is the simplest representative case because it has a choice buffer
and integer handles but no status output.

Public aggregate:

```fortran
module mpi
    use mpi_f90_constants
    use mpi_p2p_f90
    implicit none
end module mpi
```

Integer facade:

```fortran
module mpi_p2p_f90
    use iso_c_binding, only: c_int
    implicit none

    interface MPI_Send
        module procedure MPI_Send_f90
    end interface MPI_Send

    interface PMPI_Send
        module procedure PMPI_Send_f90
    end interface PMPI_Send

contains

    subroutine MPI_Send_f90(buffer, count, datatype, dest, tag, comm, ierror)
        type(*), dimension(..), intent(in) :: buffer
        integer, intent(in) :: count, datatype, dest, tag, comm
        integer, optional, intent(out) :: ierror

        if (present(ierror)) then
            call PMPI_Send(buffer, count, datatype, dest, tag, comm, ierror)
        else
            call PMPI_Send(buffer, count, datatype, dest, tag, comm)
        end if
    end subroutine MPI_Send_f90

    subroutine PMPI_Send_f90(buffer, count, datatype, dest, tag, comm, ierror)
        use mpi_p2p_c, only: CFI_MPI_Send
        type(*), dimension(..), intent(in) :: buffer
        integer, intent(in) :: count, datatype, dest, tag, comm
        integer, optional, intent(out) :: ierror
        integer(kind=c_int) :: count_c, datatype_c, dest_c, tag_c, comm_c
        integer(kind=c_int) :: ierror_c

        count_c = count
        datatype_c = datatype
        dest_c = dest
        tag_c = tag
        comm_c = comm

        call CFI_MPI_Send(buffer, count_c, datatype_c, dest_c, tag_c, comm_c, ierror_c)
        if (present(ierror)) ierror = ierror_c
    end subroutine PMPI_Send_f90

end module mpi_p2p_f90
```

Existing C bridge:

```c
void CFI_MPI_Send(CFI_cdesc_t *desc, int count, int datatype_f,
                  int dest, int tag, int comm_f, int *ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_FROMINT(datatype_f);
    MPI_Comm comm = C_MPI_COMM_FROMINT(comm_f);
    /* Existing contiguous and noncontiguous CFI handling remains here. */
    *ierror = MPI_Send(VAPAA_P2P_ADDR(desc), count, datatype,
                       C_MPI_DEST_F2C(dest), C_MPI_TAG_F2C(tag), comm);
    C_MPI_RC_FIX(*ierror);
}
```

This layering keeps all datatype decoding, noncontiguous buffer handling,
integer-handle translation, ABI behavior, and non-ABI fallback behavior in the
same place as `mpi_f08`.

## Implementation Order

1. Add `mpi_f90_constants` and `module mpi` with initialization, finalization,
   kind constants, integer handle constants, and sentinel registration.
2. Add p2p wrappers first and make `kinds`, `structf`, and `indtype` compile.
3. Add status conversion and request/status routines.
4. Add datatype wrappers, including F90 type constructors and envelope/content
   routines.
5. Add attr callbacks with integer-handle callback trampolines.
6. Add alloc/free memory, timer, and remaining routines needed by the imported
   f90 tests.
7. Enable `VAPAA_ENABLE_MPI_MODULE_TESTS` in routine CI once the imported
   non-spawn f90 suite passes.
