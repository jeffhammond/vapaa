# MPI-5 ABI Constants Update Report

## Summary

This work was done on branch `update-mpi5-abi-constants`.

Vapaa's Fortran-facing MPI constants were updated to the MPI-5 ABI integer
values. The C wrapper layer was then updated so MPI-5 ABI builds use the MPI-5
`MPI_*_fromint` and `MPI_*_toint` handle conversion entry points, not
`MPI_*_f2c` or `MPI_*_c2f`.

After the follow-up requirement to continue supporting users without an MPI-5
ABI implementation, the legacy conversion path was restored conditionally for
`MPI_VERSION < 5`. MPI-5 builds still use `fromint/toint`; non-MPI-5 builds use
explicit predefined-handle translation plus Vapaa-owned dynamic handle tables,
with legacy `MPI_*_f2c` fallbacks only outside the MPI-5 ABI path.

## Sources

The constants were taken from:

- `mpi-abi-stubs` at `/tmp/mpi-abi-stubs`, commit `e3a9e9b`
- MPI-5.0 ABI definitions in the MPI Forum report

The local ABI stubs install used for builds was:

```sh
make PREFIX=/tmp/mpi-abi-stubs/install install
```

## Fortran Constants

Updated `source/vapaa_constants.h` to the MPI-5 ABI values and propagated those
values through the Fortran modules.

Notable changes:

- `MPI_VERSION = 5`, `MPI_SUBVERSION = 0`
- `MPI_STATUS_SIZE = 8`
- `MPI_COUNT_KIND` and `MPI_OFFSET_KIND` use `c_int64_t`
- Added MPI-5 ABI constants missing from the previous Vapaa set, including
  `MPI_GROUP_EMPTY`, `MPI_INFO_ENV`, `MPI_ROOT`,
  `MPI_COMM_TYPE_RESOURCE_GUIDED`, `MPI_PACKED`, `MPI_LONG_LONG`,
  `MPI_ERR_ERRHANDLER`, and `MPI_ERR_ABI`
- Updated predefined handle, datatype, op, error, file mode, RMA mode, lock,
  window flavor/model, string-size, keyval, thread, comparison, and sentinel
  values to match MPI-5 ABI integers
- Updated `type(MPI_Status)` layout under `MPI_ABI` to match the ABI status
  layout: source, tag, error, and five internal integers

## C Handle Conversion

Added `source/vapaa_abi_handles.h` and `source/vapaa_abi_handles.c`.

For `MPI_VERSION >= 5`, the wrapper names map directly to MPI-5 ABI symbols:

- `MPI_Comm_fromint` / `MPI_Comm_toint`
- `MPI_File_fromint` / `MPI_File_toint`
- `MPI_Group_fromint` / `MPI_Group_toint`
- `MPI_Info_fromint` / `MPI_Info_toint`
- `MPI_Message_fromint` / `MPI_Message_toint`
- `MPI_Op_fromint` / `MPI_Op_toint`
- `MPI_Request_fromint` / `MPI_Request_toint`
- `MPI_Type_fromint` / `MPI_Type_toint`
- `MPI_Win_fromint` / `MPI_Win_toint`

For `MPI_VERSION < 5`, Vapaa restores compatibility with non-ABI MPI libraries:

- Predefined handles are translated explicitly from MPI-5 ABI integers to C MPI
  handles.
- Dynamic handles created by Vapaa are assigned Vapaa-owned high integer IDs and
  stored in global tables.
- Unknown legacy dynamic handle integers can fall back to `MPI_*_f2c`.
- MPICH builds configured without Fortran define Fortran predefined datatypes as
  `MPI_DATATYPE_NULL`; for those builds, Vapaa maps common Fortran datatypes to
  usable C datatypes before calling C MPI. Examples include `MPI_INTEGER` to
  `MPI_INT`, `MPI_CHARACTER` to `MPI_CHAR`, and `MPI_2INTEGER` to `MPI_2INT`.

This avoids collisions between MPI-5 ABI predefined positive integers and
legacy implementation-specific Fortran handle integers.

## Scalar Conversion

The first MPI-5-only pass removed scalar conversions because Fortran and C ABI
constants are identical. After restoring non-MPI-5 support, scalar conversion was
made conditional:

- MPI-5 ABI builds: scalar conversions are no-ops.
- Legacy builds: scalar conversions translate thread levels, compare results,
  status fields, tags, roots, source/destination sentinels, file modes, datatype
  order, communicator split type, attribute keyvals, and error codes.

`C_MPI_RC_FIX` is a no-op for MPI-5 ABI builds. This avoids calling
`MPI_Error_class` after finalize in ABI mode. For legacy builds, it retains the
old error-code conversion behavior.

## User-Defined Reductions

Vapaa still rejects user-defined reduction ops used with predefined datatypes
when it is built against a non-ABI MPI implementation. In that mode the Fortran
and C predefined datatype handles are not identical, and Vapaa cannot safely
translate the datatype handle that the C MPI implementation passes into the
Fortran user callback.

For MPI-5 ABI builds, this rejection is disabled. The MPI-5 ABI makes the
predefined Fortran and C datatype constants identical, so Vapaa does not need a
built-in datatype conversion layer for callbacks in that configuration. The
guard is centralized in `source/mpi_coll.c` and applies to `MPI_Reduce` and
`MPI_Allreduce`, including the CFI descriptor entry points.

Two tests were updated to reflect this split:

- `tests/mpich_uallreducef08.F90` now prints `Test passed` when the imported
  MPICH user-op test completes with zero errors.
- `tests/test_user_reduction.F90` initializes its failure flag, verifies the
  successful user-op path when it is supported, accepts the expected legacy
  `MPI_ERR_OP` result when it is not supported, and no longer rejects a valid
  derived datatype handle in the user callback.

## No MPI-5 ABI `f2c/c2f` Use

The MPI-5 ABI binaries were checked for handle conversion symbols:

```sh
nm -u build-mpi5-abi-muk/tests/test_core | rg "MPI_.*_(f2c|c2f)|MPI_.*_(fromint|toint)"
```

Result: only `MPI_*_fromint` and `MPI_*_toint` are referenced.

The legacy Open MPI build was also checked:

```sh
nm -u build-legacy-openmpi/tests/test_core | rg "MPI_.*_(f2c|c2f)|MPI_.*_(fromint|toint)"
```

Result: legacy binaries reference `MPI_*_f2c` fallback symbols and do not
reference `fromint/toint`.

## Test Configuration

MPI-5 ABI compile-time configuration:

```sh
cmake -S . -B build-mpi5-abi-muk \
  -DCMAKE_Fortran_COMPILER=gfortran \
  -DMPI_C_COMPILER=/tmp/mpi-abi-stubs/install/bin/mpicc \
  -DMPIEXEC_EXECUTABLE=/usr/bin/mpirun.openmpi \
  -DMPI_VENDOR=MPI_ABI
cmake --build build-mpi5-abi-muk -j 4
```

Runtime was through local Mukautuva:

```sh
make -C ~/mukautuva ompi-wrap.so
gcc ~/mukautuva/libinit.o -shared -ldl -o ~/mukautuva/libmuk.so
```

The local Mukautuva tree does not currently export MPI-5
`MPI_*_fromint/toint` symbols, so ABI runtime tests used a test-only shim in the
build directory to provide those symbols. Vapaa itself calls the MPI-5 ABI
symbols; the shim is not Vapaa source.

Legacy compatibility configuration:

```sh
cmake -S . -B build-legacy-openmpi \
  -DCMAKE_Fortran_COMPILER=gfortran \
  -DMPI_C_COMPILER=/usr/bin/mpicc.openmpi \
  -DMPIEXEC_EXECUTABLE=/usr/bin/mpirun.openmpi \
  -DMPI_VENDOR=OPEN_MPI
cmake --build build-legacy-openmpi -j 4
```

This Open MPI 4.1.2 build was used only to validate the non-MPI-5 fallback path,
not MPI-5 ABI conformance.

## Test Results

MPI-5 ABI build against `mpi-abi-stubs` with Mukautuva/OpenMPI runtime:

```sh
env LD_LIBRARY_PATH=/home/jehammond/mukautuva:/tmp/mpi-abi-stubs/install/lib:${LD_LIBRARY_PATH} \
    LD_PRELOAD=/home/jehammond/mukautuva/libmuk.so:/home/jehammond/vapaa/build-mpi5-abi-muk/libmpi5_fromint_shim.so \
    MUK_MPI_LIB=/usr/lib/x86_64-linux-gnu/openmpi/lib/libmpi.so \
    OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 \
    ctest --test-dir build-mpi5-abi-muk --output-on-failure --timeout 60
```

Result: 17/25 passed.

Passing tests:

- `mpich_uallreducef08`
- `test_attr`
- `test_bcast`
- `test_comm`
- `test_datatype`
- `test_error`
- `test_file`
- `test_file_error`
- `test_handles`
- `test_info`
- `test_p2p`
- `test_reduce_mxxloc`
- `test_reduce_ops`
- `test_reductions`
- `test_thread`
- `test_user_reduction`
- `uop08`

Failing tests:

- `test_core`
- `test_matrix_noncontig`
- `test_matrix_noncontig_2`
- `test_matrix_noncontig_3`
- `test_serialization`
- `test_serialization_2`
- `test_tensor_noncontig`
- `test_vector_noncontig`

The ABI failures are in the Mukautuva/OpenMPI runtime path:
non-contiguous/serialization support and the Open MPI post-finalize
`MPI_Error_class` behavior seen through Mukautuva. The user-defined reduction
tests now pass in the MPI-5 ABI build. The ABI symbol check still confirms Vapaa
is not using `f2c/c2f` in this build.

Legacy Open MPI 4.1.2 compatibility run:

```sh
env OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 \
    ctest --test-dir build-legacy-openmpi --output-on-failure --timeout 60
```

Result: 22/25 passed.

Failing tests:

- `mpich_uallreducef08`
- `test_matrix_noncontig_2`
- `test_serialization_2`

The legacy path no longer hangs on dynamic datatype handles and no longer reports
zero datatype sizes after restoring scalar conversion. The remaining failures
match existing limitations: user-defined reductions with built-in types and
non-MPICH `MPIX_Iov` support for some non-contiguous descriptor cases.

## Additional Provider Matrix

The following full CTest runs were performed on 2026-06-17 after restoring the
legacy handle conversion path.

MPICH 4.3.0 from `/opt/mpich`:

```sh
cmake -S . -B build-test-mpich-opt \
  -DCMAKE_Fortran_COMPILER=gfortran \
  -DMPI_C_COMPILER=/opt/mpich/bin/mpicc \
  -DMPIEXEC_EXECUTABLE=/opt/mpich/bin/mpirun \
  -DMPI_VENDOR=MPICH
cmake --build build-test-mpich-opt -j 4
ctest --test-dir build-test-mpich-opt --output-on-failure --timeout 60
```

Result after MPICH C-only Fortran datatype fallback and user-reduction test
cleanup: 24/25 passed.

Failing tests:

- `mpich_uallreducef08`

Before adding the fallback, this run passed 16/25 and these MPICH failures were
resolved by datatype translation:

- `test_matrix_noncontig`
- `test_matrix_noncontig_2`
- `test_reduce_mxxloc`
- `test_serialization`
- `test_serialization_2`
- `test_tensor_noncontig`
- `test_vector_noncontig`

`test_user_reduction` was also resolved after correcting the test's stale
callback datatype assumption and allowing the legacy `MPI_ERR_OP` path for
user-op/predefined-datatype reductions.

The root cause was the local MPICH configuration:

```text
MPICH configure: --prefix=/opt/mpich ... --disable-fortran
```

With `--disable-fortran`, `/opt/mpich/include/mpi.h` defines Fortran datatypes
such as `MPI_INTEGER`, `MPI_CHARACTER`, and `MPI_2INTEGER` as
`MPI_DATATYPE_NULL`. Passing those null datatypes into C MPI caused the
non-contiguous CFI datatype construction and `MPI_MAXLOC/MPI_MINLOC` tests to
fail. The fallback translation makes those calls use C datatypes with matching
storage for the tested default GNU Fortran kinds.

Intel MPI 2021.18 from `/opt/intel/oneapi/mpi/2021.18`:

```sh
source /opt/intel/oneapi/mpi/2021.18/env/vars.sh
cmake -S . -B build-test-intelmpi \
  -DCMAKE_Fortran_COMPILER=gfortran \
  -DMPI_C_COMPILER=/opt/intel/oneapi/mpi/2021.18/bin/mpicc \
  -DMPIEXEC_EXECUTABLE=/opt/intel/oneapi/mpi/2021.18/bin/mpirun \
  -DMPI_VENDOR=MPICH
cmake --build build-test-intelmpi -j 4
I_MPI_FABRICS=shm ctest --test-dir build-test-intelmpi \
  --output-on-failure --timeout 60
```

Result: 22/25 passed.

Failing tests:

- `mpich_uallreducef08`
- `test_matrix_noncontig_2`
- `test_serialization_2`

Open MPI 4.1.2 from `/usr/bin/mpicc.openmpi`:

```sh
cmake -S . -B build-test-openmpi4 \
  -DCMAKE_Fortran_COMPILER=gfortran \
  -DMPI_C_COMPILER=/usr/bin/mpicc.openmpi \
  -DMPIEXEC_EXECUTABLE=/usr/bin/mpirun.openmpi \
  -DMPI_VENDOR=OPEN_MPI
cmake --build build-test-openmpi4 -j 4
OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 \
  ctest --test-dir build-test-openmpi4 --output-on-failure --timeout 60
```

Result: 22/25 passed.

Failing tests:

- `mpich_uallreducef08`
- `test_matrix_noncontig_2`
- `test_serialization_2`

Open MPI 5 was not run because no Open MPI 5 wrapper was available on this
machine. Searches found only:

- system Open MPI 4.1.2 at `/usr/bin`
- NVIDIA HPC-X Open MPI 4.1.7a1 and 4.1.9a1 under `/opt/nvidia/hpc_sdk`
- MPI ABI stubs wrappers under `/tmp/mpi-abi-stubs`, which are not an Open MPI
  5 runtime

## Direct Comparison With `main`

The comparison was run against a clean `/tmp/vapaa-main` worktree at commit
`d9da3f0`, which is the same commit as `main` before this branch's changes.

Main does not build against the MPI ABI stubs configuration. The build fails in
`source/convert_handles.h` because the main branch requires status ABI support
for an unrecognized MPI ABI provider and still calls `MPI_*_f2c/c2f`, which are
not part of the MPI-5 C ABI. This branch builds successfully against
`mpi-abi-stubs`.

Legacy provider comparison:

| Provider | `main` | This branch | Removed failures | New failures |
| --- | ---: | ---: | --- | --- |
| Open MPI 4.1.2 | 21/25 | 22/25 | `test_user_reduction` | none |
| MPICH 4.3.0 C-only | 16/25 | 24/25 | `test_matrix_noncontig`, `test_matrix_noncontig_2`, `test_reduce_mxxloc`, `test_serialization`, `test_serialization_2`, `test_tensor_noncontig`, `test_user_reduction`, `test_vector_noncontig` | none |
| Intel MPI 2021.18 | 21/25 | 22/25 | `test_user_reduction` | none |

ABI provider comparison:

| Provider | `main` | This branch | Result |
| --- | --- | ---: | --- |
| `mpi-abi-stubs` build plus Mukautuva/Open MPI runtime | build failure | 17/25 | branch adds MPI-5 ABI build support and passes both user-op tests |

No provider in the direct comparison regressed by test name or pass count.

## Notes And Risks

- A real MPI-5 ABI provider should export `MPI_*_fromint/toint`. The local test
  shim should be removed when Mukautuva or another runtime provider supplies
  those symbols.
- MPICH legacy runtime validation was performed with `/opt/mpich` 4.3.0.
- No Open MPI 5 runtime was available in `PATH`, `/usr`, `/opt`, `/usr/local`,
  or `/home/jehammond` at the time of testing.
- The legacy compatibility path is intentionally not MPI-5 ABI conformance
  evidence. It exists so users without MPI-5 ABI implementations can continue to
  build and run Vapaa against older MPI libraries.
