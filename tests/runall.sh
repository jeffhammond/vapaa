#!/bin/bash

MPIRUN=/opt/mpich/bin/mpirun

for f in `ls -1 *.x` ; do
    ${MPIRUN} -n 4 ./$f || echo $f failed
done
