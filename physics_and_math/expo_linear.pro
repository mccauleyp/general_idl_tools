function expo_linear, x, p, d1=d1, d2=d2

; ========================================================================================
;+
; PROJECT: 
;	Height Time
;
; NAME: 
;	EXPO_LINEAR
;
; CATEGORY: 
;	Math, Kinematics
;
; PURPOSE: 
;	Simple function for the exponential+linear equation: y(t) = c0*exp((t-t0)/tau) + c1(t-t0) + c2
;
; CALLING SEQUENCE:
;	yfit = expo_linear(x, p [,d1=d1] [,d2=d2])
;
; INPUTS: 
;	X = (Float Array)
;		Array of x-values. In the Filament Catalog implementation, this is seconds after 
;		the initial observation time. 
;	P = (Float Array)
;		Parameters of the fit: p[0]*exp((x - p[1])/p[2]) + p[3]*(x - p[1]) + p[4]
;		In the notation of Cheng et al. (2013), these correspond to:
;			P[0] = c0
;			P[1] = t0
;			P[2] = tau
;			P[3] = c1
;			P[4] = c2
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
; MODIFICATION HISTORY: 
;	 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

if n_elements(p) ne 5 then stop

ymod = p[0]*exp((x - p[1])/p[2]) + p[3]*(x - p[1]) + p[4]

d1 = (p[0]/p[2])*exp((x - p[1])/p[2]) + p[3]
d2 = (p[0]/p[2]^2.)*exp((x - p[1])/p[2])

return, ymod
end

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
