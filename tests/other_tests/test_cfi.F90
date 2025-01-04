module cfi
    interface
        subroutine foo(buffer) bind(C,name="foo")
            implicit none
            ! dimension(*) will not pass a CFI_cdesc_t correctly
#ifdef __NVCOMPILER
            !!!pgi$ ignore_tkr buffer
            class(*), dimension(..) :: buffer
#else
            type(*), dimension(..) :: buffer
#endif
        end subroutine foo
    end interface
end module cfi 

program main
    use iso_c_binding
    use cfi
    implicit none
    integer, dimension(10,10) :: a

    a = -1

    call foo(a)
    call foo(a(:,:))

    call foo(a(:,1:5))
    call foo(a(:,6:10))

    call foo(a(1:5,:))
    call foo(a(6:10,:))

    call foo(a(1:5,1:5))
    call foo(a(6:10,6:10))

end program main
