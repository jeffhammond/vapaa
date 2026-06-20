#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_dir="${1:-${root_dir}/build-gcov}"

cmake_args=(
  -S "${root_dir}"
  -B "${build_dir}"
  -DCMAKE_BUILD_TYPE=Debug
  "-DCMAKE_C_COMPILER=${CC:-gcc}"
  "-DCMAKE_Fortran_COMPILER=${FC:-gfortran}"
  "-DCMAKE_C_FLAGS=-O0 -g --coverage"
  "-DCMAKE_Fortran_FLAGS=-O0 -g --coverage"
  "-DCMAKE_EXE_LINKER_FLAGS=--coverage"
  -DVAPAA_ENABLE_MPI_MODULE_TESTS=ON
  -DVAPAA_ENABLE_MPIFH_TESTS=ON
)

cmake "${cmake_args[@]}"
cmake --build "${build_dir}" -j"${VAPAA_BUILD_JOBS:-8}"
ctest --test-dir "${build_dir}" --timeout "${VAPAA_CTEST_TIMEOUT:-120}" \
  --output-on-failure

coverage_dir="${build_dir}/coverage"
mkdir -p "${coverage_dir}"

gcov_exe="${GCOV:-}"
if [[ -z "${gcov_exe}" ]]; then
  gcc_major="$(gcc -dumpversion | cut -d. -f1)"
  if command -v "gcov-${gcc_major}" >/dev/null 2>&1; then
    gcov_exe="gcov-${gcc_major}"
  else
    gcov_exe="gcov"
  fi
fi

gcovr --root "${root_dir}" \
  --object-directory "${build_dir}" \
  --gcov-executable "${gcov_exe}" \
  --filter 'source/' \
  --exclude 'tests/' \
  --txt \
  --sort uncovered-number \
  --merge-mode-functions merge-use-line-min \
  --print-summary \
  --html-details "${coverage_dir}/index.html" \
  --json "${coverage_dir}/coverage.json"
