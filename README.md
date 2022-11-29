# A standalone MPI Fortran 2008 module

An attempt to implement MPI Fortran 2018 support using only the MPI C API.

## Design limitations

1. The Fortran MPI profiling interface is not supported.  All Fortran MPI procedures call their C MPI counterparts, so all profiling information will be obtained as if the application calls MPI from C directly.

2. Applications must initiatlize MPI using the initialization procedures in this library.

3. Fortran 2018 C interoperability features (i.e. _Technical Specification (TS) 29113 on Further Interoperability of Fortran with C_) are currently required.  This requirement will be relaxed in the future.

4. The following optional datatypes are always defined, but are unusable (i.e. `MPI_DATATYPE_NULL`) unless explicitly enabled when the module is built: `MPI_REAL2`, `MPI_COMPLEX4`, `MPI_REAL16`, `MPI_COMPLEX32`.

5. User-defined reduction operations will not receive the correct value of the `MPI_Datatype` argument.  This is not solvable ([details](https://github.com/mpi-forum/mpi-issues/issues/654)) without hard-coding the built-in datatype compile-time constants for the implementation, which is impractical.

## Design assumptions

This library relies on the following:

### C and Fortran default integers are the same size

Users must not modify the default Fortran `INTEGER` size.  It must match C `int`.
The library verifies this assumption on initialization.

### Fortran types are equivalent to C structs

```fortran
    type, bind(C) :: MPI_Request
      integer(kind=c_int) :: MPI_VAL // not the default Fortran integer
    end type MPI_Request
```
is equivalent to
```c
struct MPI_Request {
    int MPI_VAL; // not MPI_Fint
};
```
and thus we can pass arrays of `type(MPI_Request)` to C interfaces expecting `int[]`.
We are not using this right now, but reserve the right to implement it later.

## Supported functions

The following list is likely incorrect.  Please use `git grep` to get the latest information.

Obviously, we want to support almost everything some day, but for now, we support only the following:

### Tested Functions

* Management: `MPI_Init`, `MPI_Finalize`, `MPI_Abort`,
              `MPI_Initialized`, `MPI_Finalized` (problem), 
              `MPI_Init_therad`, `MPI_Query_thread`, 
              `MPI_Get_version`, `MPI_Get_library_version`
* Utilities: `MPI_Wtime`, `MPI_Wtick`,
             `MPI_Comm_rank`, `MPI_Comm_size`
* Collectives: `MPI_Barrier`, `MPI_Bcast`, `MPI_Allreduce`
* Point-to-point: `MPI_Send`, `MPI_Isend`, `MPI_Recv`, `MPI_Irecv`,
                  `MPI_Test`, `MPI_Wait`, `MPI_Testall`, `MPI_Waitall`
* I/O: `MPI_File_open`, `MPI_File_close`
* Errors: `MPI_Error_string`

### Untested Functions

* Collectives: `MPI_Reduce`,
               `MPI_Gather`, `MPI_Allgather`, `MPI_Scatter`, `MPI_Alltoall`
* Errors: `MPI_Error_class`

### Known Issues
