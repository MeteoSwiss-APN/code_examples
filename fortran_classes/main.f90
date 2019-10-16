PROGRAM class_test

    USE classes, ONLY: base, n

    TYPE(base) :: obj
    REAL :: arr(n)

    INTEGER :: i, k

    CALL obj%alloc

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
    WRITE(*,*) "obj member2 element 1 is: ", obj%member2(1)

    CALL obj%dealloc

END PROGRAM class_test
