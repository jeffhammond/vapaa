#!/bin/bash

#MPIRUN=$MPI_ROOT/bin/mpirun
MPIRUN=/opt/homebrew/Cellar/mpich/5.0.1/bin/mpirun

for f in `ls -1 *.x` ; do
    echo "*************************************************************"
    echo "running $f "
    ${MPIRUN} -n 4 ./$f || echo $f failed
    echo "*************************************************************"
    echo " " 
done
