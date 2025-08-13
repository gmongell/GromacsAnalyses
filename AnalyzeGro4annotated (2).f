	program Build
	implicit none
	integer MxN
	parameter(MxN=22000)
	real*8 xyz(3,MxN), dx(3), PL(3), drxy
	real*8 R(MxN)
	real*8 sum_nTop,sum_nBot, sum_nTot,sum_nMax
	integer idum,ires, j, j2, k, Nat, iframe
	integer nTop,nBot,nTot,iNotTop,iNotBot, ihit
	character*3 tn
	character*4 resID(MxN),resTarg

c.. MxN denotes the upper limit on the expected 
c.. number of atoms in the system, which can be determined from the
c.. .gro file

c.. the input file is md.gro
	open(unit=39, file='md_lowf.gro', status='unknown')
c.. the output file is r.dat
	open(unit=49, file='r.dat', status='unknown')

c.. read in 'the code' of the molecule you are analyzing
	write(*,*) 'enter molecule type'
	read(*,*) resTarg
	
	sum_nTop=0.d0
	sum_nBot=0.d0
	sum_nTot=0.d0
	sum_nMax=0.d0

c.. loop through the number of frames in the simulation (simulation-time-dependent var)
	do iframe =1,11460

c.. write out occasionally so you know where you are
	if (mod(iframe,10).eq.0) write(*,*) iframe

c.. read a junk line, then the number of atoms
	read(39,*) tn
	read(39,*) Nat

c.. tn is the atom type
c.. Nat is the number of atoms
	
c.. loop through all atoms, j is a counting variable
 	do j=1,Nat     
    
c.. read atom info: type of atom and position
          read(39,129) ires, resID(j), tn, idum, 
     $        xyz(1,j),xyz(2,j),xyz(3,j)

c.. ires is 
c.. resID is the atom number
c.. tn is 

c.. set size of atom based on its type
          R(j)=0.02d0
	  if (tn.eq.' OW'.or.tn.eq.' EO') then
	     R(j)=.152
	  endif
	  if (tn.eq.'EC1'.or.tn.eq.'EC2'.or.
     $        tn.eq.' C1'.or.tn.eq.' C2'.or.
     $        tn.eq.'CH3'.or.tn.eq.'  C') then
	      R(j)=.170
	  endif
	  if (tn.eq.'  H'.or.tn.eq.' EH'.or.
     $        tn.eq.'HW1'.or.tn.eq.'HW2') then
	      R(j)=.120
	  endif
c.. this checks if an error and size not assigned
	  if (R(j).lt.0.03) then 
	    write(*,*) 'xxxxx'
	  endif

	enddo

c.. read junk line to get ready for next frame
	read(39,130) PL(1),PL(2),PL(3)
	
	nTop=0
	nBot=0
	nTot=0

c.. loop through all atoms; if its part of target molecule, proceed with analysis
	do j=1,Nat
	  if (resID(j).eq.resTarg) then
	    iNotTop=0
	    iNotBot=0
	    
c.. loop through all atoms; if NOT part of target molecule, proceed with analysis
	    do j2=1,Nat
	      if (resID(j2).ne.resTarg) then
          
c.. find distance in xy plane between atom in target molecule and other atom
c.. apply periodic boundary conditions
	        do k=1,2
	          dx(k)=(xyz(k,j2)-xyz(k,j))
	          if(dabs(dx(k)+PL(k)).lt.dabs(dx(k)))dx(k)=dx(k)+PL(k)
	          if(dabs(dx(k)-PL(k)).lt.dabs(dx(k)))dx(k)=dx(k)-PL(k)
	        enddo	     
	        drxy= dsqrt( dx(1)**2 +dx(2)**2 )

c.. find distance in z direction between atom in target molecule and other atom
c.. NO periodic boundary conditions
		if(xyz(3,j2).gt.0.7*PL(3))xyz(3,j2)=xyz(3,j2)-PL(3)
	          dx(3)=(xyz(3,j2)-xyz(3,j))
	        
c.. if distance in xy plane is less than sum of atom radii -- then its an overlap
	        ihit=0
	        if (drxy.lt.R(j)+R(j2)) ihit=1
	     
c.. for overlaps, find out if atom in target molecule is on top or bottom
	        if (ihit.eq.1) then
	          if (dx(3).gt.0.d0) then
	            iNotTop=1
	          else
	            iNotBot=1
	          endif
	          if (iNotTop.gt.0.and.iNotBot.gt.0) goto 10
	        endif
	      endif
	    enddo
	    if (iNotTop.eq.0) nTop=nTop+1
	    if (iNotBot.eq.0) nBot=nBot+1
10	    continue
	    nTot=nTot+1
	    
	  endif
	enddo
c.. What do iNotTop and iNotBot represent?
 
c..	write(49,*) nTop, nBot, nTot
	sum_nTop=sum_nTop +nTop
	sum_nBot=sum_nBot +nBot
	sum_nTot=sum_nTot +nTot
	if (nTop.gt.nBot) then
	  sum_nMax=sum_nMax +nTop
	else
	  sum_nMax=sum_nMax +nBot
	endif

c.. nMax is 0 initially, but then it is
c.. nTop or nBot, whichever is greater

c.. for each frame, there are five digits written
c.. the first set goes to the screen and the second set goes
c.. to the r.dat file
	write(*,101) sum_nMax/sum_nTot,
     $              sum_nTop/sum_nTot, sum_nBot/sum_nTot,
     $             dble(nTop)/dble(nTot),dble(nBot)/dble(nTot)
	write(49,101) sum_nMax/sum_nTot,
     $              sum_nTop/sum_nTot, sum_nBot/sum_nTot,
     $             dble(nTop)/dble(nTot),dble(nBot)/dble(nTot)
	enddo

c.. the first number reported is nMax over the total number
c.. the second number is nTop over the total number
c.. the third number is nBot over the total number
c.. the fourth number is double precision nTop over total
c.. the fifth number is double precision nBot over total

c.. These lines are telling the rest of the code about the form of the
c.. inputs and outputs.
 
101	format(5f12.3)	       
129	format(i5,a4,3x,a3,i5,3f8.3)
130	format(3f10.3)

	stop
	end	       	       
	     
	       	       
	       	       
