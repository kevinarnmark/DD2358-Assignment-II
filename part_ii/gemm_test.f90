module matmult
        interface
                subroutine c_matmul(n, C, A, B) bind(c, name="matmul")
                        use iso_c_binding
                        implicit none
                        integer(kind=c_int) :: n
                        real(kind=c_double) :: C, A, B
                end subroutine
        end interface
end module matmult


module matrix 
        use iso_fortran_env, only : real64
        implicit none
                
        type matrix_t
                integer, dimension(2) :: d ! dimension
                real(kind=real64), dimension(:,:), allocatable :: data
        contains
                procedure, pass(this) :: init
        end type

        interface operator(*)
                module procedure c_matmult
        end interface operator(*)

contains
        subroutine init(this, m, n)
                class(matrix_t), intent(inout) :: this
                integer, intent(in) :: m, n
                
                call matrix_free(this)

                allocate(this%data(m, n))
                this%d(1) = n
                this%d(2) = m
        end subroutine init

        subroutine matrix_free(A)
                type(matrix_t), intent(inout) :: A
                if (allocated(A%data)) then
                        deallocate(A%data)
                end if
                A%d(1) = 0
                A%d(2) = 0
        end subroutine matrix_free

        function c_matmult(A, B) result(C)
                !use, intrinsic :: iso_c_binding, only: c_double, c_int, c_loc, c_ptr
                use matmult
                use iso_fortran_env, only : real64
                implicit none
                type(matrix_t), target :: C
                type(matrix_t), intent(in) :: A, B
                integer :: n
                real(kind=real64), dimension(A%d(1),A%d(1)) :: AT, BT
                AT = transpose(A%data)
                BT = transpose(B%data)
                n = A%d(1)
                call C%init(n, n) 
                call c_matmul(n, C%data(1, 1), AT(1, 1), BT(1, 1))
                C%data = transpose(C%data)
        end function c_matmult
end module matrix


program gemm_test
      use matrix
      implicit none
      type(matrix_t) :: A, B, C, D
      call A%init(2, 2)
      call B%init(2, 2)
      call C%init(2, 2)
      call D%init(2, 2)
      A%data(1,1) = 1.0
      A%data(1,2) = 4.0
      A%data(2,1) = 2.0
      A%data(2,2) = 3.0
      B%data(1,1) = -2.0
      B%data(1,2) = 0.5
      B%data(2,1) = 3.0
      B%data(2,2) = 3.0

      write(*,*) 'A: ', A%data
      write(*,*) 'B: ', B%data
      write(*,*) 'C: ', C%data
      C = A * B
      write(*,*) 'C: ', C%data
      D = matrix_multiplication(A, B)
      write(*,*) 'Controll resulting matrix D using fortran matrix multiplication: ',''
      write(*,*) 'D: ', D%data
contains
        subroutine matmult_test()
                use matrix
                implicit none

                type(matrix_t) :: A, B, C
      
                call A%init(10, 10)
                call B%init(10, 10)
                call C%init(10, 10)
                A%data = 1.0
                B%data = 1.5
                write(*,*) 'A: ', A%data
                write(*,*) 'B: ', B%data
                write(*,*) 'C: ', C%data
                C = A * B
                write(*,*) 'C: ', C%data
        end subroutine

        function matrix_multiplication(A, B) result(C)
                use matrix
                type(matrix_t), intent(in) :: A
                type(matrix_t), intent(in) :: B
                type(matrix_t) :: C
                integer :: i, j, k

                call C%init(A%d(1), B%d(2)) 
                
                iloop: do i = 1, C%d(1)
                        jloop: do j = 1, C%d(2)
                                kloop: do k = 1, A%d(2)
                                        C%data(i, j) = C%data(i,j) + A%data(i, k) * B%data(k, j)
                                end do kloop
                        end do jloop
                end do iloop
        end function matrix_multiplication

end program gemm_test
