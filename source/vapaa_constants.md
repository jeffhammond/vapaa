# Notes on `vapaa_constants.h`

This file is included in C and Fortran source code.
Therefore, it must not include any comments, which
are language-specific.

This file is supposed to contain the information
that would otherwise be comments in that file.

All constants that represent closed sets are positive.
For example, thread levels are a closed set, and
for these we use the values that MPICH and Open-MPI
both use.

Constants that represent members of much larger sets
are always negative.
For example, built-in ops and datatypes are negative
numbers in a sequence, as are error codes.
