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

During test development, several benchmark issues were found and fixed:

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

## Functional Validation

After building the full configured MPICH-ABI test tree, the imported f08 and local f08 tests pass except when `mpich_main_f08_datatype_typecntsf08` trips an MPICH 5.0.0 ABI wrapper assertion. That test is marked skipped only when the known `mpi_abi_util.h:140` assertion appears, so a clean run still counts as a pass.

The failing path is external to Vapaa's post-processing: Vapaa calls the ABI `MPI_Type_get_contents`, and MPICH aborts in `ABI_Datatype_from_mpi` at `src/binding/abi/mpi_abi_util.h:140`. The test legally passes an output datatype array larger than the datatype's actual contents count. MPICH's ABI wrapper allocates `max_datatypes` native slots and converts all `max_datatypes` entries back to ABI handles, including entries beyond the count populated by `internal_Type_get_contents`. Those unused entries are uninitialized, so the assertion is intermittent.

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

## Detailed Results

The detailed tables below are generated from the saved summary TSV files. Latency ratio is `Vapaa / native MPICH`, so lower is better. Rate and bandwidth ratios are also `Vapaa / native MPICH`, so higher is better.

### 2 Ranks

| benchmark | bytes | native latency us | Vapaa latency us | latency ratio | native rate/s | Vapaa rate/s | rate ratio | bandwidth ratio |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `p2p_pingpong` | 0 | 0.590 | 0.711 | 1.2059 | 1.695e+06 | 1.406e+06 | 0.8292 | 0.0000 |
| `p2p_pingpong` | 1 | 0.583 | 0.706 | 1.2101 | 1.714e+06 | 1.417e+06 | 0.8264 | 0.8264 |
| `p2p_pingpong` | 8 | 0.597 | 0.707 | 1.1828 | 1.674e+06 | 1.415e+06 | 0.8454 | 0.8454 |
| `p2p_pingpong` | 64 | 0.638 | 0.735 | 1.1514 | 1.567e+06 | 1.361e+06 | 0.8685 | 0.8685 |
| `p2p_pingpong` | 512 | 0.841 | 1.001 | 1.1896 | 1.189e+06 | 9.992e+05 | 0.8406 | 0.8406 |
| `p2p_pingpong` | 4096 | 1.470 | 1.586 | 1.0787 | 6.801e+05 | 6.305e+05 | 0.9271 | 0.9271 |
| `p2p_pingpong` | 32768 | 6.567 | 6.650 | 1.0126 | 1.523e+05 | 1.504e+05 | 0.9876 | 0.9876 |
| `p2p_pingpong` | 262144 | 23.354 | 23.405 | 1.0022 | 4.282e+04 | 4.273e+04 | 0.9978 | 0.9978 |
| `p2p_message_rate` | 8 | 15.818 | 20.565 | 1.3001 | 8.092e+06 | 6.224e+06 | 0.7692 | 0.7692 |
| `p2p_message_rate` | 64 | 19.338 | 21.874 | 1.1311 | 6.619e+06 | 5.852e+06 | 0.8841 | 0.8841 |
| `p2p_message_rate` | 512 | 29.533 | 33.633 | 1.1389 | 4.334e+06 | 3.806e+06 | 0.8781 | 0.8781 |
| `coll_bcast` | 8 | 0.155 | 0.176 | 1.1339 | 6.451e+06 | 5.689e+06 | 0.8819 | 0.8819 |
| `coll_bcast` | 64 | 0.164 | 0.182 | 1.1127 | 6.105e+06 | 5.487e+06 | 0.8987 | 0.8987 |
| `coll_bcast` | 512 | 0.325 | 0.351 | 1.0800 | 3.075e+06 | 2.847e+06 | 0.9259 | 0.9259 |
| `coll_bcast` | 4096 | 0.460 | 0.474 | 1.0303 | 2.172e+06 | 2.108e+06 | 0.9706 | 0.9706 |
| `coll_bcast` | 32768 | 3.364 | 3.537 | 1.0515 | 2.972e+05 | 2.827e+05 | 0.9510 | 0.9510 |
| `coll_bcast` | 262144 | 10.869 | 11.014 | 1.0134 | 9.201e+04 | 9.079e+04 | 0.9868 | 0.9868 |
| `coll_allreduce` | 8 | 0.704 | 0.810 | 1.1510 | 1.421e+06 | 1.234e+06 | 0.8688 | 0.8688 |
| `coll_allreduce` | 64 | 1.409 | 1.561 | 1.1077 | 7.096e+05 | 6.406e+05 | 0.9028 | 0.9028 |
| `coll_allreduce` | 512 | 1.807 | 2.093 | 1.1580 | 5.533e+05 | 4.778e+05 | 0.8635 | 0.8635 |
| `coll_allreduce` | 4096 | 2.888 | 3.117 | 1.0793 | 3.463e+05 | 3.209e+05 | 0.9265 | 0.9265 |
| `coll_allreduce` | 32768 | 13.986 | 14.135 | 1.0107 | 7.150e+04 | 7.075e+04 | 0.9895 | 0.9895 |
| `coll_allreduce` | 262144 | 48.920 | 48.762 | 0.9968 | 2.044e+04 | 2.051e+04 | 1.0032 | 1.0032 |
| `coll_alltoall` | 8 | 0.819 | 0.919 | 1.1220 | 2.442e+06 | 2.176e+06 | 0.8913 | 0.8913 |
| `coll_alltoall` | 64 | 0.838 | 0.950 | 1.1337 | 2.386e+06 | 2.104e+06 | 0.8821 | 0.8821 |
| `coll_alltoall` | 512 | 1.113 | 1.261 | 1.1329 | 1.797e+06 | 1.586e+06 | 0.8827 | 0.8827 |
| `coll_alltoall` | 4096 | 1.850 | 1.955 | 1.0565 | 1.081e+06 | 1.023e+06 | 0.9465 | 0.9465 |
| `rma_put_lock_unlock` | 8 | 2.500 | 2.992 | 1.1965 | 4.000e+05 | 3.343e+05 | 0.8358 | 0.8358 |
| `rma_put_lock_unlock` | 64 | 2.542 | 3.001 | 1.1802 | 3.933e+05 | 3.333e+05 | 0.8473 | 0.8473 |
| `rma_put_lock_unlock` | 512 | 2.638 | 3.059 | 1.1594 | 3.791e+05 | 3.269e+05 | 0.8625 | 0.8625 |
| `rma_put_lock_unlock` | 4096 | 3.835 | 4.235 | 1.1044 | 2.608e+05 | 2.361e+05 | 0.9055 | 0.9055 |
| `rma_put_lock_unlock` | 32768 | 10.903 | 11.346 | 1.0407 | 9.172e+04 | 8.813e+04 | 0.9609 | 0.9609 |
| `rma_get_lock_unlock` | 8 | 2.723 | 3.138 | 1.1525 | 3.673e+05 | 3.187e+05 | 0.8677 | 0.8677 |
| `rma_get_lock_unlock` | 64 | 2.751 | 3.150 | 1.1450 | 3.635e+05 | 3.174e+05 | 0.8733 | 0.8733 |
| `rma_get_lock_unlock` | 512 | 3.001 | 3.365 | 1.1212 | 3.332e+05 | 2.972e+05 | 0.8919 | 0.8919 |
| `rma_get_lock_unlock` | 4096 | 4.205 | 4.541 | 1.0800 | 2.378e+05 | 2.202e+05 | 0.9259 | 0.9259 |
| `rma_get_lock_unlock` | 32768 | 11.150 | 11.649 | 1.0447 | 8.968e+04 | 8.585e+04 | 0.9572 | 0.9572 |

### 4 Ranks

| benchmark | bytes | native latency us | Vapaa latency us | latency ratio | native rate/s | Vapaa rate/s | rate ratio | bandwidth ratio |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `p2p_pingpong` | 0 | 0.603 | 0.697 | 1.1560 | 1.659e+06 | 1.435e+06 | 0.8650 | 0.0000 |
| `p2p_pingpong` | 1 | 0.605 | 0.708 | 1.1704 | 1.653e+06 | 1.412e+06 | 0.8544 | 0.8544 |
| `p2p_pingpong` | 8 | 0.612 | 0.713 | 1.1646 | 1.634e+06 | 1.403e+06 | 0.8587 | 0.8587 |
| `p2p_pingpong` | 64 | 0.666 | 0.719 | 1.0792 | 1.500e+06 | 1.390e+06 | 0.9266 | 0.9266 |
| `p2p_pingpong` | 512 | 0.864 | 0.965 | 1.1165 | 1.157e+06 | 1.037e+06 | 0.8956 | 0.8956 |
| `p2p_pingpong` | 4096 | 1.471 | 1.567 | 1.0651 | 6.798e+05 | 6.382e+05 | 0.9388 | 0.9388 |
| `p2p_pingpong` | 32768 | 6.687 | 6.569 | 0.9824 | 1.496e+05 | 1.522e+05 | 1.0179 | 1.0179 |
| `p2p_pingpong` | 262144 | 23.564 | 23.255 | 0.9869 | 4.244e+04 | 4.300e+04 | 1.0133 | 1.0133 |
| `p2p_message_rate` | 8 | 16.035 | 19.065 | 1.1889 | 7.982e+06 | 6.714e+06 | 0.8411 | 0.8411 |
| `p2p_message_rate` | 64 | 17.360 | 22.113 | 1.2738 | 7.373e+06 | 5.789e+06 | 0.7851 | 0.7851 |
| `p2p_message_rate` | 512 | 29.381 | 34.595 | 1.1775 | 4.357e+06 | 3.700e+06 | 0.8493 | 0.8493 |
| `coll_bcast` | 8 | 0.272 | 0.300 | 1.1009 | 3.674e+06 | 3.337e+06 | 0.9083 | 0.9083 |
| `coll_bcast` | 64 | 0.312 | 0.345 | 1.1050 | 3.207e+06 | 2.902e+06 | 0.9050 | 0.9050 |
| `coll_bcast` | 512 | 0.772 | 0.626 | 0.8117 | 1.296e+06 | 1.596e+06 | 1.2320 | 1.2320 |
| `coll_bcast` | 4096 | 1.067 | 1.103 | 1.0333 | 9.370e+05 | 9.068e+05 | 0.9678 | 0.9678 |
| `coll_bcast` | 32768 | 13.676 | 13.883 | 1.0151 | 7.312e+04 | 7.203e+04 | 0.9851 | 0.9851 |
| `coll_bcast` | 262144 | 52.145 | 54.764 | 1.0502 | 1.918e+04 | 1.826e+04 | 0.9522 | 0.9522 |
| `coll_allreduce` | 8 | 1.417 | 1.531 | 1.0806 | 7.058e+05 | 6.531e+05 | 0.9254 | 0.9254 |
| `coll_allreduce` | 64 | 2.793 | 3.083 | 1.1040 | 3.581e+05 | 3.243e+05 | 0.9058 | 0.9058 |
| `coll_allreduce` | 512 | 3.971 | 4.149 | 1.0448 | 2.518e+05 | 2.410e+05 | 0.9571 | 0.9571 |
| `coll_allreduce` | 4096 | 5.502 | 5.592 | 1.0165 | 1.818e+05 | 1.788e+05 | 0.9838 | 0.9838 |
| `coll_allreduce` | 32768 | 19.306 | 19.148 | 0.9918 | 5.180e+04 | 5.223e+04 | 1.0083 | 1.0083 |
| `coll_allreduce` | 262144 | 120.729 | 78.596 | 0.6510 | 8.283e+03 | 1.272e+04 | 1.5361 | 1.5361 |
| `coll_alltoall` | 8 | 2.608 | 1.895 | 0.7265 | 4.601e+06 | 6.334e+06 | 1.3765 | 1.3765 |
| `coll_alltoall` | 64 | 2.927 | 2.061 | 0.7043 | 4.100e+06 | 5.822e+06 | 1.4198 | 1.4198 |
| `coll_alltoall` | 512 | 4.462 | 2.960 | 0.6634 | 2.689e+06 | 4.053e+06 | 1.5073 | 1.5073 |
| `coll_alltoall` | 4096 | 7.343 | 4.934 | 0.6720 | 1.634e+06 | 2.432e+06 | 1.4882 | 1.4882 |
| `rma_put_lock_unlock` | 8 | 6.454 | 2.923 | 0.4530 | 1.549e+05 | 3.421e+05 | 2.2077 | 2.2077 |
| `rma_put_lock_unlock` | 64 | 6.500 | 3.030 | 0.4661 | 1.539e+05 | 3.301e+05 | 2.1455 | 2.1455 |
| `rma_put_lock_unlock` | 512 | 6.456 | 3.003 | 0.4651 | 1.549e+05 | 3.330e+05 | 2.1500 | 2.1500 |
| `rma_put_lock_unlock` | 4096 | 8.008 | 4.086 | 0.5102 | 1.249e+05 | 2.448e+05 | 1.9601 | 1.9601 |
| `rma_put_lock_unlock` | 32768 | 19.560 | 11.180 | 0.5716 | 5.113e+04 | 8.945e+04 | 1.7496 | 1.7496 |
| `rma_get_lock_unlock` | 8 | 6.554 | 3.061 | 0.4670 | 1.526e+05 | 3.267e+05 | 2.1413 | 2.1413 |
| `rma_get_lock_unlock` | 64 | 6.729 | 3.057 | 0.4543 | 1.486e+05 | 3.271e+05 | 2.2010 | 2.2010 |
| `rma_get_lock_unlock` | 512 | 6.880 | 3.367 | 0.4894 | 1.454e+05 | 2.970e+05 | 2.0435 | 2.0435 |
| `rma_get_lock_unlock` | 4096 | 8.776 | 4.476 | 0.5100 | 1.140e+05 | 2.234e+05 | 1.9608 | 1.9608 |
| `rma_get_lock_unlock` | 32768 | 20.466 | 11.343 | 0.5543 | 4.886e+04 | 8.816e+04 | 1.8042 | 1.8042 |

Interpretation for this run:

- Vapaa-over-ABI is close to native MPICH for large blocking ping-pong messages, but this corrected run shows extra overhead for small p2p messages and for the windowed p2p message-rate test.
- The 2-rank collective and RMA rows are mostly slower through Vapaa in this run, generally by about 7-19 percent on average.
- The 4-rank run shows mixed results: bcast is nearly equal, allreduce is slightly faster through Vapaa on average, and alltoall/RMA are substantially faster through Vapaa in this local single-node measurement.
- These are single-node local-rank microbenchmark results, not a network fabric study. The raw TSVs should be used for detailed per-size inspection.
