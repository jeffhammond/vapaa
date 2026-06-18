# Vapaa MPI-5 ABI Update Report

## Scope

This branch updates Vapaa's standalone `mpi_f08` implementation for the MPI-5 ABI constant set and broadens the regression suite with MPICH `test/mpi/f08`, `test/mpi/f90`, and `test/mpi/f77` coverage from upstream `main`.

The work intentionally excludes `comm_spawn` tests from CTest registration, per request. The spawn sources are present in the imported MPICH tree for reference, but Vapaa does not run them in this suite.

## Implementation Summary

- Updated the Fortran-visible MPI constants to the MPI-5 ABI values from the MPI ABI stubs project.
- Updated C-side constant conversion tables for MPI-5 ABI values.
- Kept production MPI-5 handle conversion on `MPI_*_toint` and `MPI_*_fromint`. Vapaa does not require `MPI_*_f2c` or `MPI_*_c2f` in MPI-5 ABI builds.
- Restored non-ABI handle conversion support for users on MPI implementations without the MPI-5 ABI. Those fallback paths are compiled only for `MPI_VERSION < 5`.
- Removed unnecessary conversions where the Fortran and C constants are identical under the MPI-5 ABI.
- Added ABI initialization through `MPI_Abi_set_fortran_booleans` and `MPI_Abi_set_fortran_info`.
- Added MPICH 4.3-compatible type translation support for non-ABI builds.
- Allowed user-defined reduction operations with built-in datatypes when the MPI-5 ABI is active. Non-ABI builds still XFAIL those cases because Vapaa cannot safely avoid built-in datatype conversion there.
- Added `VAPAA_CFI_ASSERT_ZERO_LOWER_BOUNDS`; nonzero CFI lower bounds now fail explicitly instead of being silently decoded incorrectly.
- Replaced reliance on compiler runtime `CFI_is_contiguous` with Vapaa's local `VAPAA_CFI_is_contiguous` helper. This avoids mixed runtime link failures and keeps descriptor handling in one place.
- Added a standard-compliant datatype decoder for `VAPAA_CFI_CREATE_INDEXED` using `MPI_Type_get_envelope` and `MPI_Type_get_contents`.
- Added MPICH `MPIX_Iov` fast path when available, with runtime controls:
  - default: use `MPIX_Iov` on suitable MPICH builds;
  - environment override: switch to the standard decoder;
  - debug mode: run both decoders and compare results.
- Added in-place collective fixes for OpenMPI4 behavior seen in imported MPICH f08 tests.
- Fixed MPI-IO seek constants and Fortran fixed-length string handling.
- Added missing support code for attributes, callbacks, status conversion, profiling interception, datatype names, window names, and MPI-IO cases exercised by the imported tests.
- Added a generated MPI-5 ABI-compliant `mpi.fh` / `mpif.h` include header from `source/vapaa_constants.h`.
- Added the `mpif.h` compatibility layer needed by legacy Fortran tests: F77 entry-point shims, status-array translation, sentinel common-block registration, callback trampolines, external datarep strings, info string handling, legacy `MPI_TYPE_HINDEXED` displacement conversion, and F77 user-op datatype translation.
- Imported and registered the MPICH `test/mpi/f77` suite behind `VAPAA_ENABLE_MPIFH_TESTS`.

## Imported MPICH f08 Tests

The MPICH f08 test import was checked against upstream MPICH `main`:

- Repository: `https://github.com/pmodels/mpich`
- Upstream commit checked: `cfe2bef3bea5660dc0947a10ec6187ff5cafc8e4`
- Upstream date: `2026-06-16T19:05:26-05:00`

All relevant source tests under `test/mpi/f08` are present locally. The only upstream files not imported are `Makefile.am` files. Local extra I/O files are generated MPICH harness outputs used as concrete tests in Vapaa.

The CTest registration skips the `spawn` category. It also skips `misc/statusconv` outside MPICH because that test's C helper uses MPICH-specific `MPI_F08_status`.

## Test Matrix

| Backend | Build / Run | Result |
| --- | --- | --- |
| MPICH native | `/opt/mpich/bin/mpicc`, `MPI_VENDOR=MPICH` | `152/152` passed |
| IntelMPI | IntelMPI `mpicc` with GNU Fortran, `MPI_VENDOR=MPICH` | `152/152` passed |
| OpenMPI 4 | `/usr/bin/mpicc.openmpi`, Open MPI 4.1.2, `MPI_VENDOR=OPEN_MPI` | `151/151` passed |
| MPI ABI stubs + MPICH ABI | Built against `/tmp/mpi-abi-stubs/install`, preloaded `/tmp/mpich-5.0.0-abi-fort-install/lib/libmpi_abi.so.0.0.0` | `151/151` passed |
| MPI ABI stubs + MPICH ABI without Fortran support | Built against ABI stubs, preloaded `/tmp/mpich-5.0.0-abi-install/lib/libmpi_abi.so.0.0.0` | `143/151` passed; see root cause below |
| OpenMPI 5 / Howard ABI branch | Not available under `/opt`, `/usr/local`, `/home/jehammond`, or `/tmp` on this machine | Not run |

OpenMPI4 has one expected difference from MPICH: `misc/statusconv` is skipped because it depends on MPICH internals. OpenMPI4 also XFAILs `io/atomicityf90`; native OpenMPI's own f08 module fails the same MPICH test, so this is not a Vapaa regression.

## Imported MPICH f77 Tests

The MPICH f77 test import was checked against upstream MPICH `main`:

- Repository: `https://github.com/pmodels/mpich`
- Upstream commit checked: `a910f2f960d354597178c6e081585870aeefe0de`
- Upstream date: `2026-06-17T13:13:28-05:00`

The imported tree lives under `tests/mpich_main/f77`. The CMake harness reads the upstream f77 testlists, skips categories without a local f77 directory, and registers the runnable non-spawn tests behind `VAPAA_ENABLE_MPIFH_TESTS`.

The generated include files are:

- `source/mpi.fh`
- `source/mpif.h`

Both are generated by `source/generate_mpi_fh.sh` from `source/vapaa_constants.h`. The header uses the MPI-5 ABI integer values, MPI-5 status-array indices, ABI kind constants, legacy MPI-1/2 combiner aliases required by old `mpif.h` code, and common-block storage for address and ignore sentinels.

The f77 compatibility layer is implemented in:

- `source/mpi_f77.c`
- `source/mpi_f77_support.F90`

The layer uses the existing Vapaa integer-handle conversion path. It does not require MPI-5 `MPI_*_f2c` or `MPI_*_c2f` symbols; imported C helper tests are compiled with `vapaa_test_handle_compat.h`, which redirects those test-side compatibility calls to Vapaa's `*_toint` / `*_fromint` helpers.

### F77 Validation

The MPICH f77 validation build was:

```sh
cmake -S . -B build-test-mpich-f77 \
  -DCMAKE_C_COMPILER=/opt/mpich/bin/mpicc \
  -DCMAKE_Fortran_COMPILER=gfortran \
  -DMPI_C_COMPILER=/opt/mpich/bin/mpicc \
  -DMPIEXEC_EXECUTABLE=/opt/mpich/bin/mpiexec \
  -DMPI_VENDOR=-DMPICH \
  -DVAPAA_ENABLE_MPI_MODULE_TESTS=ON \
  -DVAPAA_ENABLE_MPIFH_TESTS=ON
cmake --build build-test-mpich-f77 -j8
ctest --test-dir build-test-mpich-f77 -R '^mpich_main_f77_' --output-on-failure
```

Result:

```text
100% tests passed, 0 tests failed out of 62
```

One f77 test, `mpich_main_f77_coll_uallreducef`, is an expected failure under non-ABI MPICH for the same user-defined-op-with-built-in-datatype collective limitation tracked for the f08 tests. `mpich_main_f77_coll_reducelocalf` now passes normally because the f77 op trampoline can translate the callback datatype handle before calling the Fortran user function.

A full MPICH build-tree CTest run was also done with the MPICH runtime library path supplied externally:

```sh
LD_LIBRARY_PATH=/opt/mpich/lib:${LD_LIBRARY_PATH:-} \
  ctest --test-dir build-test-mpich-f77 --output-on-failure
```

Result:

```text
100% tests passed, 0 tests failed out of 226
```

## ABI Preload Details

The correct MPI ABI preload target for MPICH is `libmpi_abi.so`, not `libmpi.so`.

Preloading `libmpi.so` made the executable pass ABI constants directly to MPICH's native-handle entry points. The first visible failure was:

```text
MPI_Comm_set_errhandler(comm=0x101, errh=0x143) failed: Invalid communicator
```

Preloading MPICH's ABI entry library fixes that:

```sh
env LD_PRELOAD=/tmp/mpich-5.0.0-abi-fort-install/lib/libmpi_abi.so.0.0.0 \
    LD_LIBRARY_PATH=/tmp/mpi-abi-stubs/install/lib \
    ctest --test-dir build-mpi5-abi-mpich50-fort-preload --timeout 60 -j 4
```

The ABI path also verifies the lower-overhead behavior requested for user reductions: `mpich_uallreducef08`, `mpich_main_f08_coll_uallreducef08`, `mpich_main_f08_coll_reducelocalf08`, and `test_user_reduction` pass normally under MPI-5 ABI. On non-ABI builds, the corresponding user-op/built-in datatype tests are marked XFAIL because Vapaa must still reject that unsafe conversion path.

## Failure Root Causes

### MPICH ABI without Fortran Support

The no-Fortran MPICH ABI preload passed 143 tests and failed 8. The failures were:

- `test_reduce_mxxloc`
- `test_serialization`
- `test_serialization_2`
- `mpich_main_f08_datatype_typecntsf08`
- `mpich_main_f08_datatype_packef08`
- `mpich_main_f08_datatype_structf`
- `mpich_main_f08_datatype_sizeof`
- `mpich_main_f08_misc_sizeof2`

Root cause: the preloaded MPICH ABI library was built without Fortran datatype support. MPICH's `MPI_Abi_set_fortran_info` implementation only accepts size keys for `MPI_LOGICAL`, `MPI_INTEGER`, `MPI_REAL`, and `MPI_DOUBLE_PRECISION`, plus supported flags for kind-specific integer, real, logical, complex kinds and `MPI_DOUBLE_COMPLEX`. It does not dynamically configure every default Fortran datatype such as `MPI_COMPLEX`, `MPI_CHARACTER`, or `MPI_2INTEGER` when the library itself was not built with Fortran support.

The individual symptoms match that limitation:

- `test_reduce_mxxloc`: `MPI_2INTEGER` with `MPI_MINLOC`/`MPI_MAXLOC` produced zeros because the ABI library had no usable Fortran pair datatype mapping.
- `test_serialization` and `test_serialization_2`: Vapaa's standard datatype decoder called `MPI_Type_get_envelope` on a datatype that MPICH's ABI library could not recognize as a valid configured Fortran datatype.
- `typecntsf08`: MPICH's ABI `MPI_Type_get_contents` asserted while translating a datatype whose predefined Fortran components were not in the ABI built-in table.
- `packef08`, `structf`, `sizeof`, and `sizeof2`: `MPI_CHARACTER` and/or `MPI_COMPLEX` had size zero or invalid packing behavior because they were not configured in the no-Fortran ABI runtime.

Using the Fortran-enabled MPICH ABI library resolves all eight failures with no Vapaa code change.

### IntelMPI with Intel Fortran

An IntelMPI build using Intel C/Fortran compilers was also tested diagnostically. It built, but 14 tests failed:

- 13 failures were direct consequences of the requested nonzero CFI lower-bound assertion. Intel Fortran descriptors report lower bound `1` for several array sections where GNU descriptors report `0`.
- `test_user_reduction` segfaulted inside IntelMPI after Vapaa correctly warned that non-ABI user-defined reductions with built-in datatypes are unsupported.

The accepted IntelMPI regression run uses IntelMPI's C compiler with GNU Fortran, which keeps CFI descriptor layout consistent and passes the full suite.

### OpenMPI4 Atomicity

`mpich_main_f08_io_atomicityf90` fails with OpenMPI4's native f08 implementation as well, so Vapaa marks it XFAIL under `MPI_VENDOR=OPEN_MPI`. This is tracked as an OpenMPI4 behavior difference, not a Vapaa regression.

## Notes on `MPI_Abi_set_fortran_info`

MPICH does support `MPI_Abi_set_fortran_info`, but a no-Fortran MPICH ABI runtime does not become a full Fortran-capable MPI implementation just because Vapaa supplies ABI Fortran info. For Vapaa's full f08 behavior, the ABI implementation must provide or preconfigure all predefined Fortran datatypes needed by MPI f08 semantics. The Fortran-enabled MPICH ABI build does this and passes.

## Main-Branch Comparison

A direct MPICH baseline was run from the existing `/tmp/vapaa-main` worktree at `main` commit `d9da3f0`.

| Tree | MPICH result |
| --- | --- |
| `main` (`d9da3f0`) | `16/25` passed |
| this branch | `152/152` passed |

The `main` failures were:

- `mpich_uallreducef08`
- `test_matrix_noncontig`
- `test_matrix_noncontig_2`
- `test_reduce_mxxloc`
- `test_serialization`
- `test_serialization_2`
- `test_tensor_noncontig`
- `test_user_reduction`
- `test_vector_noncontig`

Those failures correspond to the work on this branch: noncontiguous datatype decoding, `MPI_2INTEGER`/`MINLOC`/`MAXLOC` translation, user-op handling, and the ABI-aware fallback/XFAIL split.

The branch is therefore strictly broader than `main` in the tested areas:

- MPI-5 ABI constants are updated.
- ABI handle conversion uses `toint/fromint`.
- Non-ABI users retain fallback handle conversion support.
- MPICH f08 coverage is imported and passing across the runnable backends.
- MPIX_Iov and standard datatype decoding cover noncontiguous serialization cases that `main` did not handle.
- The known backend-specific failures are either fixed, skipped for implementation-specific helpers, or XFAILed with matching native-backend evidence.

No regression was found in the tested MPICH, IntelMPI/GNU, OpenMPI4, or MPI ABI stubs + MPICH ABI configurations.
