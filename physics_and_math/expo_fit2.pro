
; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	EXPO_FIT2
;
; CATEGORY: 
;	Physics and Math
;
; PURPOSE: 
;	Fit an exponential F(x) = a0*exp(-abs(x-a1)/a2)+a3 to data using CURVEFIT.
;
; CALLING SEQUENCE:
;	yfit = expo_fit2(x, y, a)
;
; INPUTS: 
;	X = (Float Array)
;	Y = (Float Array)
;
; OUTPUTS: 
;	RETURN = (Float Array)
;		Array of fitted y-values
;	A = (Float Array)
;		Exponential fit parameters. a0*exp(-abs(x-a1)/a2)+a3
;         
; KEYWORDS: 
;	None. 
;
; EXAMPLES:
;	
;
; NOTES:
;	Adapted from GAUSSFIT
;
; MODIFICATION HISTORY: 
;	 - Written by D.L. Windt, Bell Labs, March 1990
;	 - Edited by Patrick McCauley, CfA, to remove absolute value from exponent. 
;
;-
; ========================================================================================

pro	exponential2,x,a,f,pder
f = a[0]*exp((x-a[1])/a[2])+a[3]
if n_params(0) le 3 then return ;need partial?
pder = fltarr(n_elements(x),4)  ;yes, make array.
pder[0,0] = exp((x-a[1])/a[2])
pder[0,1] = -a[0]*exp((x-a[1])/a[2])/a[2]
pder[0,2] = -a[0]*(x-a[1])*exp((x-a[1])/a[2])/(a[2]^2)
pder[*,3] = 1.
return
end

function expo_fit2,x,y,a
on_error,2		
cm=check_math(0.,1.)		; Don't print math error messages.
n = n_elements(y)		;# of points.
c=poly_fit(x,y,1,yf)		; Do a straight line fit.
yd=y-yf
ymax=max(yd) & xmax=x(!c) & imax=!c ;x,y and subscript of extrema
ymin=min(yd) & xmin=x(!c) & imin=!c

if abs(ymax) gt abs(ymin) then i0=imax else i0=imin ;emiss or absorp?
i0 = i0 > 1 < (n-2)		;never take edges
dy=yd(i0)			;diff between extreme and mean
del = dy/exp(1.)		;1/e value
i=0
while ((i0+i+1) lt n) and $	;guess at 1/2 width.
  ((i0-i) gt 0) and $
  (abs(yd(i0+i)) gt abs(del)) and $
  (abs(yd(i0-i)) gt abs(del)) do i=i+1
a = [yd(i0), x(i0), abs(x(i0)-x(i0+i)),c(0)] ;estimates
!c=0				;reset cursor for plotting
return,curvefit(x,y,replicate(1.,n),a,sigmaa,funct='exponential2') 
end
