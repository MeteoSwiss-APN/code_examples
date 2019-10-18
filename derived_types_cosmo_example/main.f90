PROGRAM type_test

    USE types, ONLY: ltab4D, initialize, finalize, interpolate_ltab

    TYPE(ltab4D) :: ltab
    REAL :: arr(10,10), ncloud(10,10)

    INTEGER :: i, k

    CALL initialize(ltab)

    !$acc enter data create(arr, ncloud)

    !$acc data present(arr,ncloud)

    !$acc parallel
    !$acc loop gang
    DO k=1,10
      !$acc loop vector
      DO i=1,10
        ncloud(i,k)=0.0
        arr(i,k)    =2.0*(i+k)
      END DO
    END DO
    !$acc end parallel

    !$acc parallel
    !$acc loop seq
    DO k=1,10
      !$acc loop vector
      DO i=1,10
        call interpolate_ltab(ltab, arr(i,k), ncloud(i,k))
        !ncloud(i,k)  = MIN(MAX(ltab%x1(1),arr(i,k)),ltab%x1(3))
      END DO
    END DO
    !$acc end parallel

    !$acc update host (ncloud,arr)
    DO k=1,10
      WRITE(*,*) "ncloud element (1,", k,") is: ", ncloud(1,k)
      WRITE(*,*) "arr element (1,", k,") is: ", arr(1,k)
    END DO
    CALL finalize(ltab)
    !$acc end data 
    !$acc exit data delete(arr, ncloud)
END PROGRAM type_test
