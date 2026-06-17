# Notes on `vapaa_constants.h`

`vapaa_constants.h` is included by both C and Fortran sources, so it must stay
free of language-specific comments.

The constants in this header mirror the MPI-5 ABI integer values from the MPI
Forum ABI stubs project and the MPI-5.0 report. The intent is that Vapaa's
Fortran handle, datatype, operation, error, mode, thread, comparison, and
sentinel constants have the same integer values as the MPI-5 C ABI.

For MPI-5 ABI builds, handle conversion uses the MPI-5 `MPI_*_fromint` and
`MPI_*_toint` entry points. Vapaa must not use `MPI_*_f2c` or `MPI_*_c2f` in
that build mode because those symbols are not part of the MPI-5 C ABI.

For non-MPI-5 MPI libraries, Vapaa keeps a compatibility path. Predefined
handles are translated explicitly from the MPI-5 ABI integer values to the
provider's C handles. Dynamic handles created by Vapaa are stored in Vapaa-owned
integer tables so they cannot collide with positive MPI-5 ABI predefined handle
values. Unknown legacy dynamic handle integers can still fall back to the
provider's `MPI_*_f2c` functions.

Scalar constants are direct pass-through for MPI-5 ABI builds. For older MPI
libraries, Vapaa translates scalar values such as thread levels, comparison
results, status fields, file modes, tags, roots, and datatype array order values
to the provider's C constants.
