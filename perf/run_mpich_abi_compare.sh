#!/usr/bin/env bash
# Compare Vapaa's mpi_f08 layer over the MPI-5 ABI with MPICH's native
# Fortran bindings, using the same Fortran benchmark source for both paths.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

MPICH_PREFIX="${MPICH_PREFIX:-$HOME/mpich-5.0.0-abi-fort-install}"
ABI_STUBS_PREFIX="${ABI_STUBS_PREFIX:-$HOME/mpi-abi-stubs-install}"
BUILD_DIR="${BUILD_DIR:-$repo_root/build-perf-vapaa-mpi5-abi-mpich50}"
NATIVE_BUILD_DIR="${NATIVE_BUILD_DIR:-$repo_root/build-perf-native-mpich50}"
RESULT_DIR="${RESULT_DIR:-$repo_root/perf/results/$(date -u +%Y%m%dT%H%M%SZ)}"
NP_LIST="${NP_LIST:-2 4}"
VAPAA_PERF_ITERS="${VAPAA_PERF_ITERS:-5000}"
VAPAA_PERF_SKIP="${VAPAA_PERF_SKIP:-500}"
JOBS="${JOBS:-$(nproc)}"

MPIRUN="${MPIRUN:-$MPICH_PREFIX/bin/mpirun}"
MPIFORT="${MPIFORT:-$MPICH_PREFIX/bin/mpifort}"
ABI_MPICC="${ABI_MPICC:-$ABI_STUBS_PREFIX/bin/mpicc}"
MPI_ABI_LIB="${MPI_ABI_LIB:-$MPICH_PREFIX/lib/libmpi_abi.so}"

native_exe="$NATIVE_BUILD_DIR/perf/mpich_perf_f08"
vapaa_exe="$BUILD_DIR/perf/vapaa_perf_f08"

die() {
    printf 'run_mpich_abi_compare: ERROR: %s\n' "$*" >&2
    exit 1
}

log() {
    printf 'run_mpich_abi_compare: %s\n' "$*"
}

require_file() {
    [[ -e "$1" ]] || die "missing required path: $1"
}

require_file "$MPIRUN"
require_file "$MPIFORT"
require_file "$ABI_MPICC"
require_file "$MPI_ABI_LIB"

mkdir -p "$RESULT_DIR" "$NATIVE_BUILD_DIR/perf"

log "repo=$repo_root"
log "mpich_prefix=$MPICH_PREFIX"
log "abi_stubs_prefix=$ABI_STUBS_PREFIX"
log "result_dir=$RESULT_DIR"
log "np_list=$NP_LIST iters=$VAPAA_PERF_ITERS skip=$VAPAA_PERF_SKIP"

log "building native MPICH Fortran benchmark"
"$MPIFORT" -cpp -O3 -DVAPAA_PERF_BINDING=\"mpich-f08\" \
    "$repo_root/perf/vapaa_perf_f08.F90" -o "$native_exe"

log "configuring Vapaa MPI-5 ABI benchmark"
cmake -S "$repo_root" -B "$BUILD_DIR" \
    -DCMAKE_C_COMPILER="${CMAKE_C_COMPILER:-cc}" \
    -DCMAKE_Fortran_COMPILER="${CMAKE_Fortran_COMPILER:-gfortran}" \
    -DMPI_C_COMPILER="$ABI_MPICC" \
    -DMPIEXEC_EXECUTABLE="$MPIRUN" \
    -DMPI_VENDOR=MPI_ABI \
    -DVAPAA_ENABLE_MPI_MODULE_TESTS=OFF \
    -DVAPAA_ENABLE_MPIFH_TESTS=OFF \
    -DVAPAA_ENABLE_PERF_TESTS=ON

log "building Vapaa MPI-5 ABI benchmark"
cmake --build "$BUILD_DIR" -j "$JOBS" --target vapaa_perf_f08

export VAPAA_PERF_ITERS
export VAPAA_PERF_SKIP

for np in $NP_LIST; do
    native_out="$RESULT_DIR/mpich-native-np${np}.tsv"
    vapaa_out="$RESULT_DIR/vapaa-abi-np${np}.tsv"
    summary_out="$RESULT_DIR/summary-np${np}.tsv"

    log "running native MPICH Fortran np=$np"
    env LD_LIBRARY_PATH="$MPICH_PREFIX/lib:${LD_LIBRARY_PATH:-}" \
        "$MPIRUN" -n "$np" "$native_exe" | tee "$native_out"

    log "running Vapaa over MPI-5 ABI np=$np"
    env LD_LIBRARY_PATH="$MPICH_PREFIX/lib:$ABI_STUBS_PREFIX/lib:${LD_LIBRARY_PATH:-}" \
        LD_PRELOAD="$MPI_ABI_LIB" \
        "$MPIRUN" -n "$np" "$vapaa_exe" | tee "$vapaa_out"

    log "writing comparison summary np=$np"
    awk '
        BEGIN {
            print "# benchmark bytes native_latency_us vapaa_latency_us latency_ratio native_message_rate_s vapaa_message_rate_s rate_ratio native_bandwidth_MB_s vapaa_bandwidth_MB_s bandwidth_ratio"
        }
        FNR == NR {
            if ($1 !~ /^#/ && NF >= 7) {
                key = $1 SUBSEP $2
                native_latency[key] = $5
                native_rate[key] = $6
                native_bandwidth[key] = $7
                native_keys[key] = $1 " " $2
            }
            next
        }
        $1 !~ /^#/ && NF >= 7 {
            key = $1 SUBSEP $2
            if (key in native_latency) {
                latency_ratio = (native_latency[key] == 0) ? 0 : $5 / native_latency[key]
                rate_ratio = (native_rate[key] == 0) ? 0 : $6 / native_rate[key]
                bandwidth_ratio = (native_bandwidth[key] == 0) ? 0 : $7 / native_bandwidth[key]
                printf "%s %s %.8e %.8e %.6f %.8e %.8e %.6f %.8e %.8e %.6f\n", \
                       $1, $2, native_latency[key], $5, latency_ratio, \
                       native_rate[key], $6, rate_ratio, \
                       native_bandwidth[key], $7, bandwidth_ratio
            }
        }
    ' "$native_out" "$vapaa_out" > "$summary_out"
done

log "done"
