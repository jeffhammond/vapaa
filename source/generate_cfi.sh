#!/bin/bash

# Mac
SED=gsed

for t in "signed char" "short" "int" "long" "long long" \
         "size_t" \
         "int8_t" "int16_t" "int32_t" "int64_t" \
         "int_least8_t" "int_least16_t" "int_least32_t" "int_least64_t" \
         "int_fast8_t" "int_fast16_t" "int_fast32_t" "int_fast64_t" \
         "intmax_t" "intptr_t" "ptrdiff_t" \
         "float" "double" "long double" "float _Complex" "double _Complex" "long double _Complex" ; do

    #echo ${t}
    u=`echo ${t} | ${SED} "s/ /_/g"`
    #echo ${u}
    v=`echo ${u} | ${SED} "s/__/_/g"`
    w="CFI_type_${v}"
    #echo ${w}
    echo "if (type==${w}) printf(\"type is %s\n\", \"${t}\");"

done
