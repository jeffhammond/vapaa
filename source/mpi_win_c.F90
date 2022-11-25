module mpi_win_c

    ! NOT STANDARD STUFF

    interface
        subroutine C_MPI_WIN_NULL(win_f) &
                   bind(C,name="C_MPI_WIN_NULL")
            use iso_c_binding, only: c_int
            implicit none
            integer(kind=c_int) :: win_f
        end subroutine C_MPI_WIN_NULL
    end interface

    ! STANDARD STUFF

end module mpi_win_c
