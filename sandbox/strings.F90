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

    print*,'==================='
    print*,'a=',a,loc(a)
    call foo(a)

    !allocate( j(3) ) ! cannot allocate this - it is a scalar
    j = "JJJ"         ! this does allocation

    print*,'==================='
    print*,'j=',j,loc(j)
    call foo(j)

    deallocate( j )   ! we can deallocate it though

    print*,'==================='
    print*,'y=',y,loc(y)
    call foo(y)

    print*,'==================='
    print*,'z=',z,loc(z)
    call foo(z)

end program main
