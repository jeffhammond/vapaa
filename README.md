# A standlone MPI Fortran 2008 module

An attempt to implement MPI Fortran 2018 support using only the MPI C API.

## Design limitations

1. The Fortran MPI profiling interface is not supported.  All Fortran MPI procedures call their C MPI counterparts, so all profiling information will be obtained as if the application calls MPI from C directly.

2. All of the predefined/built-in handles are initiatlized at runtime during library initialization. Nothing is a compile-time or link-time constant.

3. Applications must initiatlize MPI using the initialization procedures in this library, because of 2.

4. Fortran 2018 C interoperability features (i.e. _Technical Specification (TS) 29113 on Further Interoperability of Fortran with C_) are currently required.  This requirement will be relaxed in the future.

5. The following optional datatypes are always defined, but are unusable (i.e. MPI_DATATYPE_NULL) unless explicitly enabled when the module is built: `MPI_REAL2`, `MPI_COMPLEX4`, `MPI_REAL16`, `MPI_COMPLEX32`.
