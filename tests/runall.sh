#!/bin/bash

MPIRUN=$MPI_ROOT/bin/mpirun

for f in `ls -1 *.x` ; do
    echo "rnning $f "
    ${MPIRUN} -n 4 ./$f || echo $f failed
done
