#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/.." && pwd)
constants_h="${repo_root}/source/vapaa_constants.h"
output="${repo_root}/source/mpi.fh"

{
    cat <<'EOF'
C SPDX-License-Identifier: MIT
C
C This file is generated from source/vapaa_constants.h.
C Keep fixed-form lines short enough for legacy Fortran compilers.

EOF

    awk '
        /^#define[ \t]+VAPAA_(MPI|MPIX)_[A-Z0-9_]+[ \t]+-?[0-9]+/ {
            name = $2
            value = $3
            sub(/^VAPAA_/, "", name)
            printf("      integer %s\n", name)
            printf("      parameter (%s=%s)\n", name, value)
        }
    ' "${constants_h}"

    cat <<'EOF'

      integer MPI_LASTUSECODE
      parameter (MPI_LASTUSECODE=MPI_LASTUSEDCODE)

C Legacy MPI-1/2 Fortran combiner names retained for mpif.h users.
      integer MPI_COMBINER_HVECTOR_INTEGER
      parameter (MPI_COMBINER_HVECTOR_INTEGER=MPI_COMBINER_HVECTOR)
      integer MPI_COMBINER_HINDEXED_INTEGER
      parameter (MPI_COMBINER_HINDEXED_INTEGER=MPI_COMBINER_HINDEXED)
      integer MPI_COMBINER_STRUCT_INTEGER
      parameter (MPI_COMBINER_STRUCT_INTEGER=MPI_COMBINER_STRUCT)

      integer MPI_VERSION
      parameter (MPI_VERSION=5)
      integer MPI_SUBVERSION
      parameter (MPI_SUBVERSION=0)

      integer MPI_STATUS_SIZE
      parameter (MPI_STATUS_SIZE=8)
      integer MPI_SOURCE
      parameter (MPI_SOURCE=1)
      integer MPI_TAG
      parameter (MPI_TAG=2)
      integer MPI_ERROR
      parameter (MPI_ERROR=3)

      integer MPI_ADDRESS_KIND
      parameter (MPI_ADDRESS_KIND=selected_int_kind(18))
      integer MPI_COUNT_KIND
      parameter (MPI_COUNT_KIND=selected_int_kind(18))
      integer MPI_INTEGER_KIND
      parameter (MPI_INTEGER_KIND=kind(0))
      integer MPI_OFFSET_KIND
      parameter (MPI_OFFSET_KIND=selected_int_kind(18))

      logical MPI_SUBARRAYS_SUPPORTED
      parameter (MPI_SUBARRAYS_SUPPORTED=.false.)
      logical MPI_ASYNC_PROTECTS_NONBLOCKING
      parameter (MPI_ASYNC_PROTECTS_NONBLOCKING=.true.)

C Address sentinels and ignore arrays are variables in the mpif.h API.
      integer MPI_BOTTOM
      integer MPI_IN_PLACE
      integer MPI_ARGV_NULL
      integer MPI_ARGVS_NULL
      integer MPI_ERRCODES_IGNORE
      integer MPI_UNWEIGHTED
      integer MPI_WEIGHTS_EMPTY
      integer MPI_STATUS_IGNORE(MPI_STATUS_SIZE)
      integer MPI_STATUSES_IGNORE(MPI_STATUS_SIZE,1)
      common /vapaa_mpifh_sentinels/ MPI_BOTTOM, MPI_IN_PLACE,
     & MPI_ARGV_NULL, MPI_ARGVS_NULL, MPI_ERRCODES_IGNORE,
     & MPI_UNWEIGHTED, MPI_WEIGHTS_EMPTY, MPI_STATUS_IGNORE,
     & MPI_STATUSES_IGNORE
      save /vapaa_mpifh_sentinels/

C Attribute callback sentinels are external procedures in mpif.h.
      external MPI_NULL_COPY_FN
      external MPI_NULL_DELETE_FN
      external MPI_COMM_NULL_COPY_FN
      external MPI_COMM_NULL_DELETE_FN
      external MPI_COMM_DUP_FN
      external MPI_TYPE_NULL_COPY_FN
      external MPI_TYPE_NULL_DELETE_FN
      external MPI_TYPE_DUP_FN
      external MPI_WIN_NULL_COPY_FN
      external MPI_WIN_NULL_DELETE_FN
      external MPI_WIN_DUP_FN
EOF

    cat <<'EOF'

C Generated MPI procedure declarations for legacy mpif.h users.
      double precision MPI_Wtime
      external MPI_Wtime
      double precision MPI_Wtick
      external MPI_Wtick
      integer(kind=MPI_ADDRESS_KIND) MPI_Aint_add
      external MPI_Aint_add
      integer(kind=MPI_ADDRESS_KIND) MPI_Aint_diff
      external MPI_Aint_diff
EOF

    awk '
        /^[ \t]*interface[ \t]+MPI_[A-Za-z0-9_]+/ {
            name = $0
            sub(/^[ \t]*interface[ \t]+/, "", name)
            sub(/[^A-Za-z0-9_].*/, "", name)
            print name
        }
    ' "${repo_root}/source"/*.F90 \
        | sort -u \
        | awk '
            $1 == "MPI_Wtime" || $1 == "MPI_Wtick" { next }
            $1 == "MPI_Aint_add" || $1 == "MPI_Aint_diff" { next }
            $1 == "MPI_Sizeof" { next }
            $1 == "MPI_Status_f082f" || $1 == "MPI_Status_f2f08" { next }
            { printf("      external %s\n", $1) }
        '
} > "${output}"

cp "${output}" "${repo_root}/source/mpif.h"
