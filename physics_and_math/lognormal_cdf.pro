function lognormal_cdf, x, p, params=params, _extra=extra

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	LOGNORMAL_CDF
;
; CATEGORY: 
;	Math, Statistics 
;
; PURPOSE: 
;	Return the lognormal cumulative distribution function (CDF) for a given set of  
;	parameters and x positions. 
;
; CALLING SEQUENCE:
;	yfit = lognormal_cdf(x, p [,params=params] [,_extra=extra])
;
; INPUTS: 
;	X = (Float Array)
;		X-values (independent variables) over which to compute the CDF. 
;	P = (Float Array)
;		Lognormal parameters [sigma, mu]. 
;
; OUTPUTS: 
;	RETURN = (Float Array)
;		Array of CDF values at X. 
;         
; KEYWORDS: 
;	PARAMS = (Float Array)
;		Same as P input. Exists to supply input via keyword inheritance for some peculiar 
;		reason that I forget now...
;
; EXAMPLES:
;	
;
; NOTES:
;	The lognormal CDF is given by: F(X) = 0.5 + 0.5*erf((alog(x)-mu)/(sqrt(2)*sigma))
;
;	This routine is used to fit empirical distributions in FILAMENT_CGPROBPLOT using 
;	MPFIT. 
;
; MODIFICATION HISTORY: 
;	 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

;p[0] = sigma
;p[1] = mu

if n_elements(params) eq 2 then p = double(params)
if n_elements(p) ne 2 then stop

cdf = 0.5D + 0.5D*erf((alog(double(x))-p[1])/(sqrt(2D)*p[0]))

return, cdf
end
