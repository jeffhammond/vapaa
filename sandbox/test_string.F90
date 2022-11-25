program main
    use, intrinsic :: iso_c_binding
    implicit none
    integer :: i
    character(len=100) :: a
    character(len=1), dimension(100) :: b
    ! b=a is legal, but produces the wrong answer
    ! a=b is illegal
    a = '123456789'
    print*,'a=',a
    do i = 1,max(len(a),size(b))
        b(i) = a(i:i)
    enddo
    print*,'b=',b ! '1' x 100
    print*,len(trim(a)),c_sizeof(b)
    print*,len(a(5:5))
end program main
