MODULE types

IMPLICIT NONE

INTEGER, PARAMETER :: n = 1000000

TYPE base
    REAL, POINTER :: member1(:)
    REAL, POINTER :: member2(:)
END TYPE base

CONTAINS

SUBROUTINE initialize(obj)
    TYPE(base), INTENT(INOUT) :: obj

    INTEGER :: i

    ALLOCATE(obj%member1(n))
    ALLOCATE(obj%member2(n))
    !$acc enter data create(obj) async
    !$acc enter data create(obj%member1) async

    !$acc parallel default(present) async
    !$acc loop
    DO i=1,n
        obj%member1(i) = 2.0
    ENDDO
    !$acc end parallel
    
    obj%member2(:) = 3.0

END SUBROUTINE initialize

SUBROUTINE finalize(obj)
    TYPE(base), INTENT(INOUT) :: obj

    INTEGER :: i

    !$acc exit data delete(obj%member1) async
    !$acc exit data delete(obj) async
    !$acc wait
    DEALLOCATE(obj%member1)
    DEALLOCATE(obj%member2)

END SUBROUTINE finalize

END MODULE types
