module cfi
    interface
        subroutine foo(buffer) bind(C,name="foo")
            implicit none
            type(*), dimension(..) :: buffer
        end subroutine foo
    end interface
end module cfi

program main
    use iso_c_binding
    use cfi
    implicit none
    character(len=3) :: a="AAA"
    !character(len=*) :: b="BBB" ! only allowed for dummy or parameter

    character(:), allocatable :: j

    character(len=1) :: y = "Y"
    character :: z = "Z"

    print*,'a=',a
    call foo(a)

    !allocate( j(3) ) ! cannot allocate this - it is a scalar
    j = "JJJ"         ! this does allocation

    print*,'j=',j
    call foo(j)

    deallocate( j )   ! we can deallocate it though

    print*,'y=',y
    call foo(y)

    print*,'z=',z
    call foo(z)

end program main
