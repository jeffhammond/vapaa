#!/bin/bash

for f in `ls -1 *.x` ; do
    mpirun -n 4 ./$f
done
