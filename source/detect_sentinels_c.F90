module detect_sentinels_c

    interface
        subroutine C_MPI_BOTTOM(inplace) &
                   bind(C,name="C_MPI_BOTTOM")
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
            implicit none
#ifdef HAVE_CFI
            type(*) :: inplace(..)
#else
            class(*) :: inplace(..)
#endif
        end subroutine C_MPI_STATUSES_IGNORE
    end interface

    interface
        subroutine C_MPI_ERRCODES_IGNORE(inplace) &
                   bind(C,name="C_MPI_ERRCODES_IGNORE")
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
            implicit none
#ifdef HAVE_CFI
            type(*) :: inplace
#else
            class(*) :: inplace
#endif
        end subroutine C_MPI_WEIGHTS_EMPTY
    end interface

end module detect_sentinels_c
