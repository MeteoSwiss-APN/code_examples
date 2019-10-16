PROGRAM type_test

    USE types, ONLY: base, n, initialize, finalize

    TYPE(base) :: obj
    REAL :: arr(n)

    INTEGER :: i, k

    CALL initialize(obj)

    !$acc data copyout(arr)

    DO k=1,10
        !$acc parallel default(present) async
        !$acc loop
        DO i=1,n
           arr(i) = obj%member1(i)*obj%member1(i)
        ENDDO
        !$acc end parallel
    ENDDO !k

    !$acc end data
    WRITE(*,*) "array element 1 is: ", arr(1)

    CALL finalize(obj)

END PROGRAM type_test
