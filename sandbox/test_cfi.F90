module cfi
    interface
        subroutine foo(buffer) bind(C,name="foo")
            implicit none
            ! dimension(*) will not pass a CFI_cdesc_t correctly
            type(*), dimension(..) :: buffer
        end subroutine foo
    end interface
end module cfi 

program test
    use iso_c_binding
    use cfi
    implicit none
    integer :: i
    integer, dimension(10,10) :: a

    a = reshape([(i, i = 1,size(a,1)*size(a,2))],[size(a,1),size(a,2)])
    write(*,'(a,100(i5),a)') 'a=[',a,']'
    print*,'shape(a)=',shape(a)

#if 0
    ! all of these are contiguous
    print*,'----------------------'
    call foo(a)
    print*,'......................'
    call foo(a(:,:))
    print*,'----------------------'
    call foo(a(:,1:5))
    print*,'......................'
    call foo(a(:,6:10))
#endif
    ! all of these are non-contiguous
    print*,'----------------------'
    call foo(a(1:5,:))
    print*,'......................'
    call foo(a(6:10,:))
    print*,'----------------------'
    call foo(a(1:5,1:5))
    print*,'......................'
    call foo(a(6:10,6:10))
    print*,'----------------------'

end program test
