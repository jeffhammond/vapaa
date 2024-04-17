! /opt/llvm/latest/bin/flang-new -c uop08.F90

module m

    use iso_c_binding, only: c_int

    type, bind(C) :: MPI_Datatype
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Datatype

    type, bind(C) :: MPI_Op
      integer(kind=c_int) :: MPI_VAL
    end type MPI_Op

    abstract interface
        subroutine MPI_User_function(invec, inoutvec, len, datatype)
            use, intrinsic :: iso_c_binding, only: c_ptr
            import MPI_Datatype
            type(c_ptr), value :: invec, inoutvec
            integer :: len
            type(MPI_Datatype) :: datatype
        end subroutine MPI_User_function
    end interface

    interface MPI_Op_create
        subroutine MPI_Op_create_f08(user_fn, commute, op, ierror)
            import MPI_Op
            import MPI_User_function
            procedure(MPI_User_function) :: user_fn
            logical, intent(in) :: commute
            type(MPI_Op), intent(out) :: op
            integer, optional, intent(out) :: ierror
        end subroutine MPI_Op_create_f08
    end interface MPI_Op_create

end module m

subroutine uop( cin, cout, count, datatype )
    use m
    integer, dimension(*) :: cin, cout
    integer :: count
    type(MPI_Datatype) :: datatype
    integer :: i
    do i=1, count
     cout(i) = cin(i) + cout(i)
    enddo
end

subroutine uop08( cin, cout, count, datatype )
    use iso_c_binding, only: c_ptr, c_f_pointer
    use m
    type(c_ptr), value :: cin, cout
    integer :: count
    type(MPI_Datatype) :: datatype
    integer, pointer :: cin_r(:), cout_r(:)
    call c_f_pointer(cin, cin_r, [count])
    call c_f_pointer(cout, cout_r, [count])
    cout_r = cin_r + cout_r
end

program main
    use m
    external :: uop
    external :: uop08
    integer :: ierr
    type(MPI_Op) :: sumop, sumop08
    call MPI_Op_create( uop, .true., sumop, ierr )
    call MPI_Op_create( uop08, .true., sumop08, ierr )
end
