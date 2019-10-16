PROGRAM async_test

    USE my_math, ONLY: multiply

    INTEGER, PARAMETER :: n = 1000000
    REAL :: a(n), b(n), c(n)

    INTEGER :: i

    !$acc data create(a, b, c)

    !$acc parallel async
    !$acc loop
    DO i=1,n
        a(i) = 2
    ENDDO
    !$acc end parallel

    !$acc parallel async
    !$acc loop
    DO i=1,n
        b(i) = 4
    ENDDO
    !$acc end parallel

    CALL multiply(n, a, b, c)

    !$acc wait
    !$acc update host(c)
    WRITE(*,*) 'result: ', c(1)

    !$acc end data


END PROGRAM async_test
