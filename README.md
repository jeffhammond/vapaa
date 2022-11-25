# A standlone MPI Fortran 2008 module

An attempt to implement MPI Fortran 2018 support using only the MPI C API.

## Design limitations

1. The Fortran MPI profiling interface is not supported.  All Fortran MPI procedures call their C MPI counterparts, so all profiling information will be obtained as if the application calls MPI from C directly.

2. All of the predefined/built-in handles are initiatlized at runtime during library initialization. Nothing is a compile-time or link-time constant.

3. Applications must initiatlize MPI using the initialization procedures in this library, because of 2.

4. Fortran 2018 C interoperability features (i.e. _Technical Specification (TS) 29113 on Further Interoperability of Fortran with C_) are currently required.  This requirement will be relaxed in the future.

5. The following optional datatypes are always defined, but are unusable (i.e. `MPI_DATATYPE_NULL`) unless explicitly enabled when the module is built: `MPI_REAL2`, `MPI_COMPLEX4`, `MPI_REAL16`, `MPI_COMPLEX32`.

## Design assumptions

This library relies on the following:

### Fortran `INTEGER` is interoperable with C `int`

If you change the default `INTEGER` size in Fortran to break this, the library will not work.

### Fortran types are equivalent to C structs

```fortran
    type, bind(C) :: MPI_Request
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Request
```
is equivalent to
```c
struct MPI_Request {
    int MPI_VAL;
};
```
and thus we can pass arrays of `type(MPI_Request)` to C interfaces expecting `int[]`.


## Supported functions

Obviously, we want to support almost everything some day, but for now, we support only the following:

* Management: `MPI_Init`, `MPI_Finalize`, `MPI_Abort`,
              `MPI_Initialized`, `MPI_Finalized`, 
              `MPI_Init_therad`, `MPI_Query_thread`, 
              `MPI_Get_version`, `MPI_Get_library_version'
* Utilities: `MPI_Comm_rank`, `MPI_Comm_size`, 
             `MPI_Wtime`, `MPI_Wtick`
* Collectives: `MPI_Barrier`, `MPI_Bcast`, `MPI_Reduce`, `MPI_Allreduce,`
               `MPI_Gather`, `MPI_Allgather`, `MPI_Scatter`, `MPI_Alltoall`
* Point-to-point: `MPI_Send`, `MPI_Isend`, `MPI_Recv`, `MPI_Irecv`,
                  `MPI_Test`, `MPI_Wait`, `MPI_Testall`, `MPI_Waitall`

### Tested Functions

* Management: `MPI_Init`, `MPI_Finalize`, `MPI_Abort`,
              `MPI_Initialized`, `MPI_Finalized` (problem), 
              `MPI_Init_therad`, `MPI_Query_thread`, 
              `MPI_Get_version`, `MPI_Get_library_version'
* Utilities: `MPI_Wtime`, `MPI_Wtick`,
             `MPI_Comm_rank`, `MPI_Comm_size`
* Collectives: `MPI_Barrier`, `MPI_Bcast`, `MPI_Allreduce`
* Point-to-point: `MPI_Send`, `MPI_Isend`, `MPI_Recv`, `MPI_Irecv`,
                  `MPI_Test`, `MPI_Wait`, `MPI_Testall`, `MPI_Waitall`

### Unested Functions

* Collectives: `MPI_Reduce`,
               `MPI_Gather`, `MPI_Allgather`, `MPI_Scatter`, `MPI_Alltoall`

### Known Issues

* `MPI_COMM_WORLD` cannot be used for initializatin:
```
Error: Parameter 'mpi_comm_world' at (1) has not been declared or is a variable, which does not reduce to a constant expression
test_handles.F90:7:26:
```
