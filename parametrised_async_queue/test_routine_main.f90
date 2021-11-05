!Test routine directive
program main 
    USE m_compute, only : fake_turb_trans
    implicit none 
    real*8, allocatable :: flux_t_cpu(:,:), flux_cpu(:),tmp_gpu1(:,:), flux_gpu1(:), flux_t_gpu1(:,:), flux(:), flux_t(:,:)
    integer :: ntiles, tile
    integer :: nargs,i
    character*10 arg 
    integer :: n1
    real*8 :: rtcpu, rtgpu1, rtgpu2
    INTEGER ::  icountnew, icountold, icountrate, icountmax 

    !init
    ntiles=8
    n1=100
    tmp_gpu1(:,:)=0.0
    flux_gpu1(:)=0.0
    flux(:)=0.0

    nargs = command_argument_count() 
  
    if( nargs == 1 ) then 
       call getarg( 1, arg ) 
       read(arg,'(i)') n1
    else 
       stop('usage ./test n1') 
    endif 
    
  ALLOCATE(flux_t_cpu(n1,ntiles), flux_cpu(n1),tmp_gpu1(n1,ntiles), flux_gpu1(n1), flux_t_gpu1(n1,ntiles), flux(n1), flux_t(n1,ntiles))
  
  !$acc data create(tmp_gpu1, flux_gpu1, flux_t_gpu1, flux, flux_t)
  !$acc update device(tmp_gpu1, flux_gpu1, flux_t_gpu1, flux, flux_t)
  
  !------------------------------------------------------------------- 
  !    1) CPU
  CALL SYSTEM_CLOCK(COUNT=icountold,COUNT_RATE=icountrate,COUNT_MAX=icountmax) 
  !Compute CPU ref

  PRINT*, 'starting CPU run'
  

  DO tile=1,ntiles
    call fake_turb_trans(flux_t_cpu(:,tile), tile, n1, gpu=.FALSE.)
  END DO

  DO tile=1,ntiles
    DO i=1, n1
      flux_cpu(i) = flux_cpu(i) + flux_t_cpu(i,tile)
    END DO
  END DO
  
  
  CALL SYSTEM_CLOCK(COUNT=icountnew) 
  !get time
  rtcpu = ( REAL(icountnew) - REAL(icountold) ) / REAL(icountrate) 
  
  PRINT*, 'finished CPU run'

  !------------------------------------------------------------------- 
  !    2) GPU 1, direct implementation
  
  !$acc wait
  CALL SYSTEM_CLOCK(COUNT=icountold,COUNT_RATE=icountrate,COUNT_MAX=icountmax) 
  
  PRINT*, 'starting GPU 1 run'

  DO tile=1,ntiles
    !$acc parallel async(tile)
    !$acc loop seq
    DO i=1,n1
      tmp_gpu1(i, tile) = i*i + i + tile
    END DO
    !$acc end parallel
    !$acc wait

    !$acc parallel async(tile)
    !$acc loop gang vector
    DO i=1,n1
      flux_t_gpu1(i, tile) = flux_t_gpu1(i, tile) + tmp_gpu1(i, tile)
    END DO
    !$acc end parallel
  END DO

  !$acc parallel
  !$acc loop seq
  DO tile=1,ntiles
    !$acc loop gang vector
    DO i=1, n1
      flux_gpu1(i) = flux_gpu1(i) + flux_t_gpu1(i,tile)
    END DO
  END DO
  !$acc end parallel

  PRINT*, 'finishing GPU 1 run'

  
  !$acc wait
  CALL SYSTEM_CLOCK(COUNT=icountnew) 
  !$acc update host(flux_gpu1)
  
  !get time
  rtgpu1 = ( REAL(icountnew) - REAL(icountold) ) / REAL(icountrate) 
  
  !check results, test 1
  IF (sum(abs(flux_cpu-flux_gpu1)) > 0) THEN
     PRINT*, 'TEST 1 FAIL'
     PRINT*, 'Sum flux_cpu,flux_gpu1', sum(flux_cpu), sum(flux_gpu1)
  ELSE
     PRINT*, 'TEST 1 OK'
  END IF
  
  !------------------------------------------------------------------- 
  !    3) GPU 2, using atomic
  !$acc wait
  CALL SYSTEM_CLOCK(COUNT=icountold,COUNT_RATE=icountrate,COUNT_MAX=icountmax)
  
  PRINT*, 'starting GPU 2 run'

  DO tile=1,ntiles
    call fake_turb_trans(flux_t(:,tile),tile, n1, gpu=.TRUE.)
  END DO

  !$acc wait
  !$acc update host(flux_t)

  !$acc parallel
  !$acc loop seq
  DO tile=1,ntiles
    !$acc loop gang vector
    DO i=1, n1
      flux(i) = flux(i) + flux_t(i,tile)
    END DO
  END DO
  !$acc end parallel


  PRINT*, 'finishing GPU 2 run'


  CALL SYSTEM_CLOCK(COUNT=icountnew) 
  !$acc update host(flux)
  !get time
  rtgpu2 = ( REAL(icountnew) - REAL(icountold) ) / REAL(icountrate) 
  
  
  
  !check results, test 2
  IF (sum(abs(flux_cpu-flux)) > 0) THEN
     PRINT*, 'TEST 2 FAIL'
     PRINT*, 'Sum flux_cpu,flux', sum(flux_cpu), sum(flux)
  ELSE
     PRINT*, 'TEST 2 OK'
  END IF
  
   
   print*, 'n1,n2',n1
  ! print*, aref
  ! print*, agpu1
  ! print*, agpu2
  ! print*, 'sum' , sum(aref) , nindref
   write(*,"(A,ES10.2,A)") 'time cpu'  , rtcpu*1e3, ' ms'
   write(*,"(A,ES10.2,A)") 'time gpu 1', rtgpu1*1e3, ' ms'
   write(*,"(A,ES10.2,A)") 'time gpu 2', rtgpu2*1e3, ' ms'
  
  
  !$acc end data
  deallocate(tmp_gpu1, flux_gpu1, flux_t_gpu1, flux, flux_t)
  
  
  end program main 
  