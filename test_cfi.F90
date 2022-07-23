module cfi
    interface
        subroutine foo(buffer) bind(C,name="foo")
            implicit none
            type(*), dimension(*) :: buffer
        end subroutine foo
    end interface
end module cfi 

program test
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

end program test
