# Vapaa Full Compiler x MPI Sweep

- Source: `/home/jehammond/vapaa`
- Git: `1a8b4641b662` on `update-mpi5-abi-constants`
- Results root: `/tmp/vapaa-full-sweep-20260620T233546Z`
- Completed: `2026-06-21T01:36:51Z`
- Matrix: 5 compilers x 8 MPI roots = 40 combinations
- Outcomes: 40 passed, 0 failed, 0 skipped

## Matrix Results

| Compiler | MPI | Vendor | Status | Tests | Failed | Skipped | Warnings | Build warnings | Seconds |
|---|---|---:|---|---:|---:|---:|---:|---:|---:|
| `gfortran11` | `openmpi-system` | `OPEN_MPI` | PASS | 259 | 0 | 1 | 0 | 0 | 64 |
| `gfortran16` | `openmpi-system` | `OPEN_MPI` | PASS | 259 | 0 | 1 | 0 | 0 | 66 |
| `ifx` | `openmpi-system` | `OPEN_MPI` | PASS | 250 | 0 | 4 | 0 | 0 | 66 |
| `nvfortran` | `openmpi-system` | `OPEN_MPI` | PASS | 244 | 0 | 4 | 1 | 0 | 68 |
| `flang22` | `openmpi-system` | `OPEN_MPI` | PASS | 259 | 0 | 1 | 0 | 0 | 90 |
| `gfortran11` | `mpich` | `MPICH` | PASS | 260 | 0 | 0 | 0 | 0 | 26 |
| `gfortran16` | `mpich` | `MPICH` | PASS | 260 | 0 | 0 | 0 | 0 | 26 |
| `ifx` | `mpich` | `MPICH` | PASS | 260 | 0 | 3 | 0 | 0 | 28 |
| `nvfortran` | `mpich` | `MPICH` | PASS | 247 | 0 | 3 | 1 | 0 | 32 |
| `flang22` | `mpich` | `MPICH` | PASS | 260 | 0 | 0 | 0 | 0 | 47 |
| `gfortran11` | `mpich-debug` | `MPICH` | PASS | 260 | 0 | 0 | 0 | 0 | 27 |
| `gfortran16` | `mpich-debug` | `MPICH` | PASS | 260 | 0 | 0 | 0 | 0 | 27 |
| `ifx` | `mpich-debug` | `MPICH` | PASS | 260 | 0 | 3 | 0 | 0 | 29 |
| `nvfortran` | `mpich-debug` | `MPICH` | PASS | 247 | 0 | 3 | 1 | 0 | 32 |
| `flang22` | `mpich-debug` | `MPICH` | PASS | 260 | 0 | 0 | 0 | 0 | 51 |
| `gfortran11` | `openmpi5-abi` | `MPI_ABI` | PASS | 246 | 0 | 0 | 0 | 0 | 34 |
| `gfortran16` | `openmpi5-abi` | `MPI_ABI` | PASS | 246 | 0 | 0 | 0 | 0 | 36 |
| `ifx` | `openmpi5-abi` | `MPI_ABI` | PASS | 235 | 0 | 3 | 0 | 0 | 37 |
| `nvfortran` | `openmpi5-abi` | `MPI_ABI` | PASS | 235 | 0 | 3 | 1 | 0 | 42 |
| `flang22` | `openmpi5-abi` | `MPI_ABI` | PASS | 246 | 0 | 0 | 0 | 0 | 57 |
| `gfortran11` | `intel-mpi` | `INTEL_MPI` | PASS | 256 | 0 | 0 | 0 | 0 | 78 |
| `gfortran16` | `intel-mpi` | `INTEL_MPI` | PASS | 256 | 0 | 0 | 0 | 0 | 79 |
| `ifx` | `intel-mpi` | `INTEL_MPI` | PASS | 256 | 0 | 3 | 0 | 0 | 82 |
| `nvfortran` | `intel-mpi` | `INTEL_MPI` | PASS | 245 | 0 | 3 | 1 | 0 | 83 |
| `flang22` | `intel-mpi` | `INTEL_MPI` | PASS | 256 | 0 | 0 | 0 | 0 | 102 |
| `gfortran11` | `hpcx-12.9-2.20` | `NVIDIA_HPCX` | PASS | 259 | 0 | 1 | 0 | 0 | 396 |
| `gfortran16` | `hpcx-12.9-2.20` | `NVIDIA_HPCX` | PASS | 259 | 0 | 1 | 0 | 0 | 399 |
| `ifx` | `hpcx-12.9-2.20` | `NVIDIA_HPCX` | PASS | 250 | 0 | 4 | 0 | 0 | 386 |
| `nvfortran` | `hpcx-12.9-2.20` | `NVIDIA_HPCX` | PASS | 244 | 0 | 4 | 1 | 0 | 390 |
| `flang22` | `hpcx-12.9-2.20` | `NVIDIA_HPCX` | PASS | 259 | 0 | 1 | 0 | 0 | 422 |
| `gfortran11` | `hpcx-12.9-2.25.1` | `NVIDIA_HPCX` | PASS | 259 | 0 | 1 | 0 | 0 | 393 |
| `gfortran16` | `hpcx-12.9-2.25.1` | `NVIDIA_HPCX` | PASS | 259 | 0 | 1 | 0 | 0 | 395 |
| `ifx` | `hpcx-12.9-2.25.1` | `NVIDIA_HPCX` | PASS | 250 | 0 | 4 | 0 | 0 | 398 |
| `nvfortran` | `hpcx-12.9-2.25.1` | `NVIDIA_HPCX` | PASS | 244 | 0 | 3 | 1 | 0 | 382 |
| `flang22` | `hpcx-12.9-2.25.1` | `NVIDIA_HPCX` | PASS | 259 | 0 | 1 | 0 | 0 | 417 |
| `gfortran11` | `hpcx-13.1-2.25.1` | `NVIDIA_HPCX` | PASS | 259 | 0 | 1 | 0 | 0 | 391 |
| `gfortran16` | `hpcx-13.1-2.25.1` | `NVIDIA_HPCX` | PASS | 259 | 0 | 1 | 0 | 0 | 393 |
| `ifx` | `hpcx-13.1-2.25.1` | `NVIDIA_HPCX` | PASS | 250 | 0 | 4 | 0 | 0 | 390 |
| `nvfortran` | `hpcx-13.1-2.25.1` | `NVIDIA_HPCX` | PASS | 244 | 0 | 3 | 1 | 0 | 387 |
| `flang22` | `hpcx-13.1-2.25.1` | `NVIDIA_HPCX` | PASS | 259 | 0 | 1 | 0 | 0 | 411 |

## Failures

None.

## Warning Logs

- `nvfortran` / `openmpi-system`: 1 warning-pattern matches, `/tmp/vapaa-full-sweep-20260620T233546Z/logs/nvfortran__openmpi-system.warnings.log`
- `nvfortran` / `mpich`: 1 warning-pattern matches, `/tmp/vapaa-full-sweep-20260620T233546Z/logs/nvfortran__mpich.warnings.log`
- `nvfortran` / `mpich-debug`: 1 warning-pattern matches, `/tmp/vapaa-full-sweep-20260620T233546Z/logs/nvfortran__mpich-debug.warnings.log`
- `nvfortran` / `openmpi5-abi`: 1 warning-pattern matches, `/tmp/vapaa-full-sweep-20260620T233546Z/logs/nvfortran__openmpi5-abi.warnings.log`
- `nvfortran` / `intel-mpi`: 1 warning-pattern matches, `/tmp/vapaa-full-sweep-20260620T233546Z/logs/nvfortran__intel-mpi.warnings.log`
- `nvfortran` / `hpcx-12.9-2.20`: 1 warning-pattern matches, `/tmp/vapaa-full-sweep-20260620T233546Z/logs/nvfortran__hpcx-12.9-2.20.warnings.log`
- `nvfortran` / `hpcx-12.9-2.25.1`: 1 warning-pattern matches, `/tmp/vapaa-full-sweep-20260620T233546Z/logs/nvfortran__hpcx-12.9-2.25.1.warnings.log`
- `nvfortran` / `hpcx-13.1-2.25.1`: 1 warning-pattern matches, `/tmp/vapaa-full-sweep-20260620T233546Z/logs/nvfortran__hpcx-13.1-2.25.1.warnings.log`

## Inventory

```text
Sweep root: /tmp/vapaa-full-sweep-20260620T233546Z
Started: 2026-06-20T23:35:49Z
Source: /home/jehammond/vapaa
Git branch: update-mpi5-abi-constants
Git HEAD: 1a8b4641b662
Git status:
 M CMakeLists.txt
 M source/cfi_util.c
 M source/convert_handles.h
 M source/detect_builtins.h
 M source/mpi_attr.c
 M source/mpi_direct_callback.c
 M source/mpi_direct_collective_pgif.c
 M source/mpi_error.c
 M source/mpi_op.c
 M source/vapaa_abi_handles.c
 M source/vapaa_abi_handles.h
 M source/vapaa_error_handling.c
 M tests/CMakeLists.txt
 M tests/mpich_main/CMakeLists.txt
 M tests/mpich_main/f77/CMakeLists.txt
 M tests/mpich_main/f90/CMakeLists.txt
 M tests/mpich_main/include/vapaa_test_handle_compat.h

Compilers:
gfortran11 C=/usr/bin/gcc-11 [gcc-11 (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0] Fortran=/usr/bin/gfortran-11 [GNU Fortran (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0]
gfortran16 C=/usr/bin/gcc-16 [gcc-16 (Ubuntu 16-20260315-1ubuntu1~22~ppa1) 16.0.1 20260315 (experimental) [trunk r16-8100-g3aca3bae8ee]] Fortran=/usr/bin/gfortran-16 [GNU Fortran (Ubuntu 16-20260315-1ubuntu1~22~ppa1) 16.0.1 20260315 (experimental) [trunk r16-8100-g3aca3bae8ee]]
ifx C=icx [Intel(R) oneAPI DPC++/C++ Compiler 2026.0.0 (2026.0.0.20260331)] Fortran=ifx [ifx (IFX) 2026.0.0 20260331]
nvfortran C=/opt/nvidia/hpc_sdk/Linux_x86_64/26.3/compilers/bin/nvc [] Fortran=/opt/nvidia/hpc_sdk/Linux_x86_64/26.3/compilers/bin/nvfortran []
flang22 C=/usr/bin/gcc-16 [gcc-16 (Ubuntu 16-20260315-1ubuntu1~22~ppa1) 16.0.1 20260315 (experimental) [trunk r16-8100-g3aca3bae8ee]] Fortran=/usr/bin/flang-22 [Ubuntu flang version 22.1.8 (++20260613092327+e80beda6e255-1~exp1~20260613092437.81)]

MPI libraries:
openmpi-system vendor=OPEN_MPI mpicc=/usr/bin/mpicc mpiexec=/usr/bin/mpiexec
mpicc: /usr/bin/mpicc: Open MPI 4.1.2 (Language: C)
mpiexec: mpiexec (OpenRTE) 4.1.2
mpich vendor=MPICH mpicc=/opt/mpich/bin/mpicc mpiexec=/opt/mpich/bin/mpiexec
mpicc: gcc: error: unrecognized command-line option ‘--showme:version’
mpiexec: HYDRA build details:
mpich-debug vendor=MPICH mpicc=/opt/mpich-debug/bin/mpicc mpiexec=/opt/mpich-debug/bin/mpiexec
mpicc: gcc: error: unrecognized command-line option ‘--showme:version’
mpiexec: HYDRA build details:
openmpi5-abi vendor=MPI_ABI mpicc=/opt/openmpi5-howard-abi/bin/mpicc_abi mpiexec=/opt/openmpi5-howard-abi/bin/mpiexec
mpicc: mpicc_abi: Open MPI 6.1.0a1 (Language: C)
mpiexec: mpiexec (Open MPI) 6.1.0a1
intel-mpi vendor=INTEL_MPI mpicc=/opt/intel/oneapi/mpi/2021.18/bin/mpicc mpiexec=/opt/intel/oneapi/mpi/2021.18/bin/mpiexec
mpicc: gcc: error: unrecognized command-line option ‘--showme:version’
mpiexec: Intel(R) MPI Library for Linux* OS, Version 2021.18.0 Build 20260327 (id: 821f207)
hpcx-12.9-2.20 vendor=NVIDIA_HPCX mpicc=/opt/nvidia/hpc_sdk/Linux_x86_64/26.3/comm_libs/12.9/hpcx/hpcx-2.20/ompi/bin/mpicc mpiexec=/opt/nvidia/hpc_sdk/Linux_x86_64/26.3/comm_libs/12.9/hpcx/hpcx-2.20/ompi/bin/mpiexec
mpicc: /opt/nvidia/hpc_sdk/Linux_x86_64/26.3/comm_libs/12.9/hpcx/hpcx-2.20/ompi/bin/.bin/mpicc: Open MPI 4.1.7a1 (Language: C)
mpiexec: mpiexec (OpenRTE) 4.1.7a1
hpcx-12.9-2.25.1 vendor=NVIDIA_HPCX mpicc=/opt/nvidia/hpc_sdk/Linux_x86_64/26.3/comm_libs/12.9/hpcx/hpcx-2.25.1/ompi/bin/mpicc mpiexec=/opt/nvidia/hpc_sdk/Linux_x86_64/26.3/comm_libs/12.9/hpcx/hpcx-2.25.1/ompi/bin/mpiexec
mpicc: /opt/nvidia/hpc_sdk/Linux_x86_64/26.3/comm_libs/12.9/hpcx/hpcx-2.25.1/ompi/bin/.bin/mpicc: Open MPI 4.1.9a1 (Language: C)
mpiexec: mpiexec (OpenRTE) 4.1.9a1
hpcx-13.1-2.25.1 vendor=NVIDIA_HPCX mpicc=/opt/nvidia/hpc_sdk/Linux_x86_64/26.3/comm_libs/13.1/hpcx/hpcx-2.25.1/ompi/bin/mpicc mpiexec=/opt/nvidia/hpc_sdk/Linux_x86_64/26.3/comm_libs/13.1/hpcx/hpcx-2.25.1/ompi/bin/mpiexec
mpicc: /opt/nvidia/hpc_sdk/Linux_x86_64/26.3/comm_libs/13.1/hpcx/hpcx-2.25.1/ompi/bin/.bin/mpicc: Open MPI 4.1.9a1 (Language: C)
mpiexec: mpiexec (OpenRTE) 4.1.9a1

```
