MODULE my_math

IMPLICIT NONE

CONTAINS

SUBROUTINE multiply(n, a, b, c)
    INTEGER, INTENT(IN) :: n
    REAL, INTENT(IN) :: a(:), b(:)
    REAL, INTENT(OUT):: c(:)

    INTEGER :: i, k

    k = 10

    !$acc parallel async default(present)
    !$acc loop
    DO i=1,n
        c(i) = a(i)*b(i)+k
    ENDDO
    !$acc end parallel

END SUBROUTINE multiply

END MODULE my_math
