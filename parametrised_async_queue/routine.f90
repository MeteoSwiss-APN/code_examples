!Test routine directive
MODULE m_compute

implicit none

CONTAINS

SUBROUTINE fake_turb_trans(flux_t, tile, n, gpu )
  INTEGER :: i, tile, n
  REAL*8 :: flux_t(:)
  REAL*8 :: tmp(n) 
  LOGICAL :: gpu

  tmp(:) = 0.0

  !$acc enter data create(tmp) async(tile) IF(gpu)

  !$acc parallel async(tile) IF(gpu)
  !$acc loop seq
  DO i=1,n
    tmp(i) = i*i + i + tile
  END DO
  !$acc end parallel

  !$acc parallel async(tile) IF(gpu)
  !$acc loop gang vector
  DO i=1,n
    flux_t(i) = flux_t(i) + tmp(i)
  END DO
  !$acc end parallel

  !$acc exit data delete(tmp) async(tile) IF(gpu)

END SUBROUTINE fake_turb_trans

END MODULE m_compute
