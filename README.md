# Vapaa

Implementing MPI Fortran 2018 support using only the MPI C API, mostly.  The goal is a feature-complete MPI F08 module that works with any MPI library for all the compilers, even imperfect ones.

The name cames from the Finnish word, vapaa, which means "free" in the sense of "free-range chickens" or "Dobby is a free elf".

## Design limitations

1. The Fortran MPI profiling interface is not supported.  All Fortran MPI procedures call their C MPI counterparts, so all profiling information will be obtained as if the application calls MPI from C directly.

2. Applications must initiatlize MPI using the initialization procedures in this library.  We may be able to relax this restriction later.

3. Fortran 2018 C interoperability features (i.e. _Technical Specification (TS) 29113 on Further Interoperability of Fortran with C_) are currently required.  This requirement will be relaxed in the future.

4. The following optional datatypes are always defined, but are unusable (i.e. `MPI_DATATYPE_NULL`) unless explicitly enabled when the module is built: `MPI_REAL2`, `MPI_COMPLEX4`, `MPI_REAL16`, `MPI_COMPLEX32`.

5. User-defined reduction operations will not receive the correct value of the `MPI_Datatype` argument.  This is not solvable ([details](https://github.com/mpi-forum/mpi-issues/issues/654)) without hard-coding the built-in datatype compile-time constants for the implementation, which is impractical.

6. Non-contiguous subarrays cannot be used as buffer arguments with user-defined datatypes in all cases.  When supported, the implementation may not be optimal.

7. Reductions with non-contiguous subarrays may not be supported in all cases.  When supported, the implementation may not be optimal.  This is related to an issue in the MPI standard ([details](https://github.com/mpi-forum/mpi-issues/issues/663)).

8. V/W-collectives with non-contiguous subarrays may not be supported in all cases.  When supported, the implementation may not be optimal.

## Design assumptions

This library relies on the following:

### C and Fortran default integers are the same size

Users must not modify the default Fortran `INTEGER` size.  It must match C `int`.
The library verifies this assumption on initialization.

### Fortran types are equivalent to C structs

```fortran
    type, bind(C) :: MPI_Request
      integer(kind=c_int) :: MPI_VAL ! not the default Fortran integer
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

## Known Issues

### User-defined reductions

It is impossible to obtain the correct value of a built-in datatype handle in a user-defined reduction.
See https://github.com/mpi-forum/mpi-issues/issues/654 for details.
If you want to use user-defined reductions, you must either _also_ use user-defined datatypes,
or not rely on the datatype argument to figure out what the type of the buffer argument is.

I may at some point implement an extension that supports modern Fortran better,
similar to what is descrbied in https://github.com/jeffhammond/mpi_f08_userdef_reductions.
