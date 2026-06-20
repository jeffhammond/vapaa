# Test Coverage Expansion Prompt

Date: 2026-06-20
Branch: update-mpi5-abi-constants

## User Prompt

> need way more testing. write tests until you have 75% coverage at least. write a function that tests the contig and noncontig behavior of every function. create a matrix and pass contig, column stride, row stride and checkerboard subarrays. do this for every comm function. collectives, all p2p, I/O, RMA. test integer, real, double, complex double elements.

## Scope Captured

- Expanded noncontiguous CFI matrix tests for p2p, collectives, MPI-IO, and RMA paths.
- Exercised contiguous, row-stride, column-stride, and checkerboard matrix sections.
- Added integer, real, double precision, and double-complex coverage where the tested MPI operation semantics support those element categories.
- Added broader direct wrapper, callback, datatype, mpif.h, and PGIF descriptor utility coverage to raise measured source coverage above the requested threshold.

## Verification Snapshot

- Open MPI/GCC normal test suite: 181/181 tests passed.
- GCC 11 gcov coverage run: 256/256 tests passed.
- gcovr source coverage: 76.0% line coverage, 77.3% function coverage, and 44.2% branch coverage.
