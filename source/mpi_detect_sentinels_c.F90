module mpi_detect_sentinels_c

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
        subroutine C_MPI_BOTTOM(bottom) &
                   bind(C,name="C_MPI_BOTTOM")
            use iso_c_binding, only: c_intptr_t 
            implicit none
#ifdef HAVE_CFI
            type(*) :: bottom
#else
            class(*) :: bottom
#endif
        end subroutine C_MPI_BOTTOM
    end interface

end module mpi_detect_sentinels_c

