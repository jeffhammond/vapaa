        subroutine TNAME(a, b, c, d) bind(C)
            type(c_ptr), value :: a, b
            integer(c_int), intent(in) :: c, d
            call f08_op_dispatch(TSLOT, a, b, c, d)
        end subroutine TNAME
