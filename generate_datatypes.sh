#!/bin/bash

if [0] ; then

for t in INTEGER REAL DOUBLE_PRECISION COMPLEX LOGICAL CHARACTER BYTE ; do
    echo "            call C_MPI_${t}(datatype_c)"
    echo "            MPI_${t} % MPI_VAL = datatype_c"
done

fi

for t in INTEGER REAL DOUBLE_PRECISION COMPLEX LOGICAL CHARACTER BYTE ; do
    echo "void C_MPI_${t}(int * datatype)"
    echo "{"
    echo "    *datatype = MPI_Type_c2f(MPI_${t});"
    echo "}"
    echo ""
done

exit

for t in INTEGER REAL DOUBLE_PRECISION COMPLEX LOGICAL CHARACTER BYTE ; do
    echo "    interface"
    echo "        subroutine C_MPI_${t}(datatype_f) bind(C,name=\"C_MPI_${t}\")"
    echo "            use iso_c_binding, only: c_int"
    echo "            implicit none"
    echo "            integer(kind=c_int) :: datatype_f"
    echo "        end subroutine C_MPI_${t}"
    echo "    end interface"
    echo ""
done
