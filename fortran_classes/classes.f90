MODULE classes

IMPLICIT NONE

INTEGER, PARAMETER :: n = 1000000

TYPE base
    REAL, POINTER :: member1(:)
    REAL, POINTER :: member2(:)
    CONTAINS
        PROCEDURE :: alloc => initialize
        PROCEDURE :: dealloc => finalize
END TYPE base

CONTAINS

SUBROUTINE initialize(this)
    CLASS(base), INTENT(INOUT) :: this

    INTEGER :: i

    ALLOCATE(this%member1(n))
    ALLOCATE(this%member2(n))
    !$acc enter data create(this) async
    !$acc enter data create(this%member1) async

    !$acc parallel default(present) async
    !$acc loop
    DO i=1,n
        this%member1(i) = 2.0
    ENDDO
    !$acc end parallel
    
    this%member2(:) = 3.0

END SUBROUTINE initialize

SUBROUTINE finalize(this)
    CLASS(base), INTENT(INOUT) :: this

    INTEGER :: i

    !$acc exit data delete(this%member1)
    !$acc exit data delete(this)
    DEALLOCATE(this%member1)
    DEALLOCATE(this%member2)

END SUBROUTINE finalize

END MODULE classes
