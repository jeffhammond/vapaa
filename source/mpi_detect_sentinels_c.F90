module mpi_detect_sentinels_c

    interface
        subroutine C_MPI_BOTTOM(inplace) &
                   bind(C,name="C_MPI_BOTTOM")
            use iso_c_binding, only: c_intptr_t
            implicit none
#ifdef HAVE_CFI
            type(*) :: inplace
#else
            class(*) :: inplace
#endif
        end subroutine C_MPI_BOTTOM
    end interface

    interface
        subroutine C_MPI_STATUS_IGNORE(inplace) &
                   bind(C,name="C_MPI_STATUS_IGNORE")
            use iso_c_binding, only: c_intptr_t
            implicit none
#ifdef HAVE_CFI
            type(*) :: inplace
#else
            class(*) :: inplace
#endif
        end subroutine C_MPI_STATUS_IGNORE
    end interface

    interface
        subroutine C_MPI_STATUSES_IGNORE(inplace) &
                   bind(C,name="C_MPI_STATUSES_IGNORE")
            use iso_c_binding, only: c_intptr_t
            implicit none
#ifdef HAVE_CFI
            type(*) :: inplace
#else
            class(*) :: inplace
#endif
        end subroutine C_MPI_STATUSES_IGNORE
    end interface

    interface
        subroutine C_MPI_ERRCODES_IGNORE(inplace) &
                   bind(C,name="C_MPI_ERRCODES_IGNORE")
            use iso_c_binding, only: c_intptr_t
            implicit none
#ifdef HAVE_CFI
            type(*) :: inplace
#else
            class(*) :: inplace
#endif
        end subroutine C_MPI_ERRCODES_IGNORE
    end interface

    interface
        subroutine C_MPI_IN_PLACE(inplace) &
                   bind(C,name="C_MPI_IN_PLACE")
            use iso_c_binding, only: c_intptr_t
            implicit none
#ifdef HAVE_CFI
            type(*) :: inplace
#else
            class(*) :: inplace
#endif
        end subroutine C_MPI_IN_PLACE
    end interface

    interface
        subroutine C_MPI_ARGV_NULL(inplace) &
                   bind(C,name="C_MPI_ARGV_NULL")
            use iso_c_binding, only: c_intptr_t
            implicit none
#ifdef HAVE_CFI
            type(*) :: inplace
#else
            class(*) :: inplace
#endif
        end subroutine C_MPI_ARGV_NULL
    end interface

    interface
        subroutine C_MPI_ARGVS_NULL(inplace) &
                   bind(C,name="C_MPI_ARGVS_NULL")
            use iso_c_binding, only: c_intptr_t
            implicit none
#ifdef HAVE_CFI
            type(*) :: inplace
#else
            class(*) :: inplace
#endif
        end subroutine C_MPI_ARGVS_NULL
    end interface

    interface
        subroutine C_MPI_UNWEIGHTED(inplace) &
                   bind(C,name="C_MPI_UNWEIGHTED")
            use iso_c_binding, only: c_intptr_t
            implicit none
#ifdef HAVE_CFI
            type(*) :: inplace
#else
            class(*) :: inplace
#endif
        end subroutine C_MPI_UNWEIGHTED
    end interface

    interface
        subroutine C_MPI_WEIGHTS_EMPTY(inplace) &
                   bind(C,name="C_MPI_WEIGHTS_EMPTY")
            use iso_c_binding, only: c_intptr_t
            implicit none
#ifdef HAVE_CFI
            type(*) :: inplace
#else
            class(*) :: inplace
#endif
        end subroutine C_MPI_WEIGHTS_EMPTY
    end interface

end module mpi_detect_sentinels_c
