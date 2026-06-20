# GCC/gcov Coverage Report

Date: 2026-06-20

This report records the first GCC/gcov coverage pass over Vapaa after the flang
descriptor work.  GCC's gcov documentation recommends compiling with coverage
instrumentation and low/no optimization so that line execution data maps cleanly
back to the source.  The coverage workflow added here uses `-O0 -g --coverage`,
runs the full test suite, then generates text, HTML, and JSON reports with
`gcovr` using the matching `gcov` executable.

## Workflow

Use:

```sh
scripts/run_gcov_coverage.sh build-gcov
```

The script configures a coverage build with:

- `VAPAA_ENABLE_MPI_MODULE_TESTS=ON`
- `VAPAA_ENABLE_MPIFH_TESTS=ON`
- `--coverage` for C, Fortran, and executable linking
- `gcovr --filter source/ --exclude tests/`

It also uses `--merge-mode-functions merge-use-line-min` because GCC/gcov can
emit multiple fragments for a source file with slightly different function line
metadata after incremental rebuilds.

## Results

The final full coverage run used Open MPI compatibility, GCC/gfortran, and the
imported MPICH f08/f90/f77 suites.

```text
ctest --test-dir build-gcov-full --timeout 120 --output-on-failure
100% tests passed, 0 tests failed out of 242

lines:     55.4% (5213 out of 9413)
functions: 51.9% (797 out of 1536)
branches:  33.5% (2275 out of 6793)
```

Baseline observations before fixes:

- Default local tests only: about 41.0% line coverage and 33.0% function
  coverage.
- Full imported-suite coverage before local coverage tests: about 51.9% line
  coverage and 47.8% function coverage.
- `mpi_abi.c`, `mpi_status.c`, and `mpi_f77_missing.c` were effectively
  untested in the full imported-suite profile.

After fixes:

- `source/mpi_abi.c`: 100% line coverage.
- `source/mpi_status.c`: 100% line coverage.
- `source/mpi_group.c`: 94% line coverage.
- `source/mpi_request.c`: 75% line coverage.
- `source/mpi_f77_missing.c`: improved from 0% to 10.8% line coverage.

## Fixes Made

Added `tests/test_status_request_group.F90` to cover:

- `MPI_Status_get_*`
- `MPI_Status_set_*`
- `MPI_Status_set_elements`
- `MPI_Status_set_elements_x`
- `MPI_Test_cancelled`
- `MPI_Request_get_status*`
- `MPI_Group_translate_ranks`, set operations, range operations, and frees

Added `tests/test_mpifh_coverage.f` to exercise selected `mpif.h` legacy paths
that the imported MPICH f77 tests do not currently hit:

- ABI info routines
- `MPI_Aint_add` and `MPI_Aint_diff`
- f77 status accessor and element-count wrappers
- f77 request status wrappers
- f77 group set/range wrappers

The new f08 status test found a real binding defect:

- `C_MPI_Status_set_elements_x` declared the datatype argument by reference in
  the Fortran `bind(C)` interface.
- The C implementation expects the datatype integer by value.
- This made `MPI_Status_set_elements_x` fail through the f08 path while the
  legacy C-to-C `mpif.h` path worked.
- Fixed by adding `value` to the datatype argument in
  `source/mpi_status_c.F90`.

## Remaining Coverage Gaps

Top remaining uncovered source files from the final report:

```text
source/mpi_f77_missing.c          10.8% line coverage
source/cfi_util.c                 62.3% line coverage
source/mpi_missing.c              43.2% line coverage
source/mpi_p2p.c                  65.6% line coverage
source/mpi_f77.c                  78.2% line coverage
source/mpi_direct_comm.c          19.5% line coverage
source/mpi_direct_collective.c    45.9% line coverage
source/mpi_direct_win.c           43.3% line coverage
source/pgif_util.c                 0.0% line coverage
source/mpi_op.c                   37.0% line coverage
```

Interpretation:

- `pgif_util.c` remains uncovered in a GCC/gcov build because that backend is
  only active for NVHPC/PGI descriptor support. GCC gcov is the wrong tool for
  proving that path; it needs NVHPC-specific testing.
- `mpi_f77_missing.c` is a large compatibility layer for legacy entry points
  that are not well covered by the imported MPICH f77 suite. The new local test
  covers core status/request/group/ABI helpers, but MPI-IO, RMA, persistent
  collectives, session, port/name, graph, and neighborhood routines still need
  targeted f77 tests.
- `mpi_direct_comm.c`, `mpi_direct_collective.c`, and `mpi_direct_win.c` are
  mostly uncovered for less common direct MPI-4/5 entry points: sessions,
  intercommunicator setup, buffer attach/flush, neighborhood collectives, and
  RMA variants.
- `mpi_op.c` and `mpi_op_f.F90` need additional user-op tests beyond the
  existing reduction coverage.
- `cfi_util.c` has broad coverage of normal descriptor paths, but many rare
  element-type mappings, optional debug paths, failure branches, and fallback
  datatype-construction paths remain uncovered.

## Next Tests To Add

Highest-value coverage additions:

1. f77 MPI-IO smoke test for open/read/write/view/get-info/get-group/error
   handler wrappers in `mpi_f77_missing.c`.
2. f77 RMA smoke test for win create/fence/put/get/flush/free and win error
   handler wrappers.
3. f08/f77 persistent collective and neighborhood collective tests to hit
   `*_init` wrappers.
4. User-defined operation tests that exercise `MPI_Op_create`,
   `MPI_Op_commutative`, callback invocation, and free paths.
5. CFI negative-path tests for unsupported element kinds, nonzero lower bounds,
   allocation failures where injectable, and both MPIX_Iov and standard
   datatype-decoding paths.
6. NVHPC-specific coverage or equivalent descriptor tests for `pgif_util.c`.
