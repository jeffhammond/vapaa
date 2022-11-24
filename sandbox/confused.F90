module f
    use iso_c_binding
    implicit none

    interface test
        module procedure test_f08
        module procedure test_f08ts
    end interface test

    contains

        subroutine test_f08(buf) bind(C)
            integer :: buf
        end subroutine test_f08

        subroutine test_f08ts(buffer) bind(C)
            type(*), dimension(..), intent(inout) :: buffer
        end subroutine test_f08ts

end module f
