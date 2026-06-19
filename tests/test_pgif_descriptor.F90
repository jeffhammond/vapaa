program main
    implicit none

    interface
        subroutine pgif_check_descriptor(buffer, ierror)
            type(*), dimension(..), intent(in) :: buffer
!pgi$ ignore_tkr(c) buffer
            integer, intent(out) :: ierror
        end subroutine pgif_check_descriptor
    end interface

    integer :: ierror
    integer :: a(6,8)

    a = 0
    a(2,3) = 12345
    call pgif_check_descriptor(a(2:6:2,3:8:2), ierror)
    if (ierror /= 0) then
        stop ierror
    end if

    print *, 'PGI descriptor support is okay'
    print *, 'Test passed'
end program main
