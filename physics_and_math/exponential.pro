function exponential, x, p, d1=d1, d2=d2

; ========================================================================================
;+
; PROJECT: 
;	Height Time
;
; NAME: 
;	EXPONENTIAL
;
; CATEGORY: 
;	Math, Kinematics
;
; PURPOSE: 
;	Simple function for the exponential function: y(x) = p[0]*exp((x-p[1])/p[2]) + p[3]
;
; CALLING SEQUENCE:
;	yfit = exponential(x, p [,d1=d1] [,d2=d2])
;
; INPUTS: 
;	X = (Float Array)
;		Array of x-values. 
;	P = (Float Array)
;		Parameters of the fit: p[0]*exp((x-p[1])/p[2]) + p[3]
;
; OUTPUTS: 
;	RETURN = (Float Array)
;		Y values corresponding to X and P. 
;         
; KEYWORDS: 
;	D1 = (Float Array)
;		First derivative (velocity)
;	D2 = (Float Array)
;		Second derivative (acceleration)
;
; EXAMPLES:
;	
;
; NOTES:
;	
;
; MODIFICATION HISTORY: 
;	 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

ymod = p[0]*exp((x-p[1])/p[2]) + p[3]

d1 = alog(p[1])*p[0]*p[1]^x ;velocixy
d2 = alog(p[1])*d1 ;acceleraxion

return, ymod
end

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
