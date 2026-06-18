# MPI-5 ABI Performance Report

## Scope

This report covers the new Vapaa performance microbenchmarks and the methodology for comparing Vapaa over MPICH's MPI-5 ABI with MPICH's own `mpi_f08` bindings. The focus is contiguous-buffer overhead for point-to-point, RMA, and collective operations.

The benchmark source is `perf/vapaa_perf_f08.F90`. It is compiled in two ways:

- Native MPICH baseline: `mpifort -cpp -O3 -DVAPAA_PERF_BINDING=\"mpich-f08\"`.
- Vapaa ABI path: CMake builds Vapaa against the MPI ABI stubs with `MPI_VENDOR=MPI_ABI`, then the executable is run with `LD_PRELOAD=$MPICH_PREFIX/lib/libmpi_abi.so`.

## Environment

The comparison run used:

- MPICH prefix: `/home/jehammond/mpich-5.0.0-abi-fort-install`
- MPICH version: `5.0.0`
- MPICH ABI: `18:0:6`
- MPICH device: `ch4:ucx`
- MPICH configure line: `--with-device=ch4:ucx --with-ucx=/usr --enable-shared --disable-static --enable-fortran=all --enable-mpi-abi`
- MPI ABI stubs prefix: `/home/jehammond/mpi-abi-stubs-install`

The MPICH ABI library exports the required MPI-5 ABI symbols used by Vapaa:

```text
MPI_Abi_set_fortran_info
MPI_Comm_toint
MPI_Comm_fromint
MPI_Type_toint
MPI_Type_fromint
```

The Vapaa benchmark executable links to the ABI stubs library:

```text
libmpi_abi.so.0 => /home/jehammond/mpi-abi-stubs-install/lib/libmpi_abi.so.0
```

The native baseline executable links to MPICH's native Fortran and C libraries:

```text
libmpifort.so.12 => /home/jehammond/mpich-5.0.0-abi-fort-install/lib/libmpifort.so.12
libmpi.so.12 => /home/jehammond/mpich-5.0.0-abi-fort-install/lib/libmpi.so.12
```

## Coverage

The current benchmark rows cover:

- `p2p_pingpong`: blocking `MPI_BYTE` send/receive latency and bandwidth.
- `p2p_message_rate`: windowed nonblocking bidirectional `MPI_BYTE` message rate.
- `coll_bcast`: `MPI_BYTE` broadcast latency and aggregate payload rate.
- `coll_allreduce`: `MPI_INTEGER8` allreduce latency and payload rate.
- `coll_alltoall`: `MPI_BYTE` all-to-all latency and aggregate payload rate.
- `rma_put_lock_unlock`: passive-target `MPI_BYTE` put latency/rate.
- `rma_get_lock_unlock`: passive-target `MPI_BYTE` get latency/rate.

The benchmark is intentionally contiguous. It measures ABI and binding overhead without folding in Vapaa's descriptor datatype construction cost.

During test development, two benchmark bugs were found and fixed:

- Large-message bandwidth arithmetic overflowed default Fortran integers before conversion to `real64`.
- `p2p_message_rate` deadlocked at `np > 2` because ranks above 1 posted sends/receives to rank 0 while rank 0 only talked to rank 1.
- The original byte-size rows used `MPI_INTEGER8` buffers, which rounded sub-8-byte p2p payloads up to 8 bytes. The byte-counted paths now use `MPI_BYTE`, while allreduce keeps `MPI_INTEGER8` and only uses multiples of eight bytes.
- Collective, p2p, and RMA timings now report the maximum elapsed rank instead of rank 0's local elapsed time.

## Noncontiguous-Buffer Status

The communication wrapper audit found that the blocking p2p path supports noncontiguous CFI descriptors by constructing derived datatypes, and the blocking simple collective path supports several noncontiguous cases. However, Vapaa still has explicit contiguous-buffer guards in `source/mpi_direct_collective.c` for nonblocking and persistent collectives, neighborhood collectives, `Alltoallw`, and `Isendrecv` variants. The blocking `source/mpi_coll.c` path still aborts for noncontiguous reductions and vector collectives such as `Gatherv`, `Scatterv`, `Allgatherv`, and `Alltoallv`.

The reason is semantic, not just mechanical: predefined reduction operations are not valid on arbitrary derived datatypes in MPICH, so noncontiguous reductions require staging contiguous temporary buffers. For nonblocking and persistent collectives, those temporaries and any generated datatypes must live until request completion or persistent-request free, which needs request-lifetime ownership in Vapaa's handle layer.

## Reproducible Driver

The comparison driver is:

```bash
perf/run_mpich_abi_compare.sh
```

Default locations:

```bash
MPICH_PREFIX=$HOME/mpich-5.0.0-abi-fort-install
ABI_STUBS_PREFIX=$HOME/mpi-abi-stubs-install
NP_LIST="2 4"
VAPAA_PERF_ITERS=5000
VAPAA_PERF_SKIP=500
```

Each run writes:

- `mpich-native-np<N>.tsv`
- `vapaa-abi-np<N>.tsv`
- `summary-np<N>.tsv`

The summary columns are:

```text
benchmark bytes native_latency_us vapaa_latency_us latency_ratio native_message_rate_s vapaa_message_rate_s rate_ratio native_bandwidth_MB_s vapaa_bandwidth_MB_s bandwidth_ratio
```

## Interpretation

For small messages, latency and message-rate ratios are the most relevant numbers because the binding call path dominates. For larger messages, bandwidth ratios should converge as MPI transport cost dominates. RMA rows include lock/unlock overhead by design; they are useful for comparing binding overhead in passive-target epochs, not for peak RMA throughput.

The key ABI validation condition is that the Vapaa executable is compiled against the MPI ABI stubs and succeeds only when MPICH's `libmpi_abi.so` is preloaded. That demonstrates the MPI-5 ABI path instead of accidentally using MPICH's native headers and libraries at build time.

## Results

Final raw result directory:

```text
perf/results/mpich50-abi-final-byte-accurate-20260618T195848Z/
```

Run settings:

```text
NP_LIST="2 4"
VAPAA_PERF_ITERS=5000
VAPAA_PERF_SKIP=500
```

Average ratios by benchmark are shown below. Latency ratio is `Vapaa / native MPICH`, so lower is better. Rate ratio is also `Vapaa / native MPICH`, so higher is better.

| ranks | benchmark | latency ratio avg | rate ratio avg |
| --- | --- | ---: | ---: |
| 2 | `p2p_pingpong` | 1.1292 | 0.8903 |
| 2 | `p2p_message_rate` | 1.1900 | 0.8438 |
| 2 | `coll_bcast` | 1.0703 | 0.9358 |
| 2 | `coll_allreduce` | 1.0839 | 0.9257 |
| 2 | `coll_alltoall` | 1.1113 | 0.9007 |
| 2 | `rma_put_lock_unlock` | 1.1362 | 0.8824 |
| 2 | `rma_get_lock_unlock` | 1.1087 | 0.9032 |
| 4 | `p2p_pingpong` | 1.0901 | 0.9213 |
| 4 | `p2p_message_rate` | 1.2134 | 0.8252 |
| 4 | `coll_bcast` | 1.0194 | 0.9917 |
| 4 | `coll_allreduce` | 0.9814 | 1.0527 |
| 4 | `coll_alltoall` | 0.6916 | 1.4479 |
| 4 | `rma_put_lock_unlock` | 0.4932 | 2.0426 |
| 4 | `rma_get_lock_unlock` | 0.4950 | 2.0302 |

Interpretation for this run:

- Vapaa-over-ABI is close to native MPICH for large blocking ping-pong messages, but this corrected run shows extra overhead for small p2p messages and for the windowed p2p message-rate test.
- The 2-rank collective and RMA rows are mostly slower through Vapaa in this run, generally by about 7-19 percent on average.
- The 4-rank run shows mixed results: bcast is nearly equal, allreduce is slightly faster through Vapaa on average, and alltoall/RMA are substantially faster through Vapaa in this local single-node measurement.
- These are single-node local-rank microbenchmark results, not a network fabric study. The raw TSVs should be used for detailed per-size inspection.
