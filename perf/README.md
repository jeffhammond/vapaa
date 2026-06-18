# Vapaa MPI-5 ABI Performance Benchmarks

This directory contains a small `mpi_f08` microbenchmark suite used to compare:

- MPICH's native Fortran bindings, built with `mpifort`.
- Vapaa's `mpi_f08` implementation compiled against the MPI ABI stubs and run by preloading MPICH's MPI-5 ABI library.

The benchmark source is shared by both paths so the measured difference is the binding and ABI path rather than benchmark logic.

## Benchmarks

`vapaa_perf_f08.F90` reports whitespace-separated rows:

```text
benchmark bytes iterations seconds latency_us message_rate_s bandwidth_MB_s
```

It currently covers:

- `p2p_pingpong`: blocking `MPI_Send`/`MPI_Recv` latency and bandwidth.
- `p2p_message_rate`: bidirectional windowed `MPI_Isend`/`MPI_Irecv` message rate.
- `coll_bcast`: `MPI_Bcast` latency/rate.
- `coll_allreduce`: `MPI_Allreduce` latency/rate.
- `coll_alltoall`: `MPI_Alltoall` latency/rate.
- `rma_put_lock_unlock`: `MPI_Win_lock`/`MPI_Put`/`MPI_Win_unlock`.
- `rma_get_lock_unlock`: `MPI_Win_lock`/`MPI_Get`/`MPI_Win_unlock`.

The benchmark intentionally uses contiguous buffers. Vapaa's noncontiguous descriptor path is a functional feature with datatype construction overhead; it should be measured separately once all nonblocking and persistent collective request-lifetime cases are implemented.

## Running The MPICH ABI Comparison

The comparison driver expects:

- MPICH built with Fortran and MPI ABI support under `~/mpich-5.0.0-abi-fort-install`.
- MPI ABI stubs installed under `~/mpi-abi-stubs-install`.

Run:

```bash
perf/run_mpich_abi_compare.sh
```

Useful overrides:

```bash
MPICH_PREFIX=$HOME/mpich-5.0.0-abi-fort-install \
ABI_STUBS_PREFIX=$HOME/mpi-abi-stubs-install \
NP_LIST="2 4" \
VAPAA_PERF_ITERS=5000 \
VAPAA_PERF_SKIP=500 \
perf/run_mpich_abi_compare.sh
```

Results are written to `perf/results/<timestamp>/`:

- `mpich-native-np<N>.tsv`
- `vapaa-abi-np<N>.tsv`
- `summary-np<N>.tsv`

The summary includes latency ratios (`Vapaa / MPICH`) and throughput ratios (`Vapaa / MPICH`).
