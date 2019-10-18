MODULE types

IMPLICIT NONE

TYPE ltab4D
    INTEGER :: n1  ! number of grid points in x1-direction
    INTEGER :: n2  ! number of grid points in x2-direction
    REAL, DIMENSION(:), ALLOCATABLE :: x1  ! grid vector in x1-direction
    REAL, DIMENSION(:), ALLOCATABLE :: x2  ! grid vector in x1-direction
END TYPE ltab4D

CONTAINS

SUBROUTINE initialize(ltab)
    TYPE(ltab4D), INTENT(OUT) :: ltab

    ltab%n1 = 3    ! for R2
    ltab%n2 = 5    ! for log(sigma_s)

    ALLOCATE( ltab%x1(ltab%n1) )
    ALLOCATE( ltab%x2(ltab%n2) )
    
    !$acc enter data &
    !$acc create (ltab) &
    !$acc create (ltab%n1, ltab%n2) &
    !$acc create (ltab%x1, ltab%x2)

    ltab%x1 = (/  10.1, 20.1, 30.1 /)
    ltab%x2 = (/  0.1, 0.2, 0.3, 0.4, 0.5 /)
    
    !$acc update device (ltab%x1, ltab%x2)
    !$acc update device (ltab%n1, ltab%n2)

END SUBROUTINE initialize

SUBROUTINE finalize(ltab)
    TYPE(ltab4D), INTENT(INOUT) :: ltab

    !$acc exit data delete (ltab%x1, ltab%x2)
    !$acc exit data delete(ltab)

    DEALLOCATE( ltab%x1(ltab%n1) )
    DEALLOCATE( ltab%x2(ltab%n2) )

END SUBROUTINE finalize



SUBROUTINE interpolate_ltab(ltab, r2, ncloud)

  IMPLICIT NONE
  
  !$acc routine seq

  TYPE(ltab4D), INTENT(IN)  :: ltab
  REAL,     INTENT(IN)  :: r2
  REAL,     INTENT(OUT) :: ncloud
  
  INTEGER               :: n
  REAL                  :: r2_loc

  !n=ltab%n1
  r2_loc  = MIN(MAX(r2,     ltab%x1(1)), ltab%x1(ltab%n1))
  ncloud = 2*r2_loc
  

END SUBROUTINE interpolate_ltab


END MODULE types


