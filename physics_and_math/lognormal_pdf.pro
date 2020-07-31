function lognormal_pdf, x, p

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	LOGNORMAL_PDF
;
; CATEGORY: 
;	Math, Statistics 
;
; PURPOSE: 
;	Return the lognormal probability distribution function (PDF) for a given set of  
;	parameters and x positions. 
;
; CALLING SEQUENCE:
;	yfit = lognormal_pdf(x, p)
;
; INPUTS: 
;	X = (Float Array)
;		X-values (independent variables) over which to compute the CDF. 
;	P = (Float Array)
;		Lognormal parameters [scale factor, sigma, mu]. The scale factor (first element) 
;		is used to scale the height up to whatever data values you're working with (i.e. 
;		it doesn't change the shape of the curve, which is what's important). 
;
; OUTPUTS: 
;	RETURN = (Float Array)
;		Array of PDF values at X. 
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
;	The lognormal PDF is given by: f(X) = [1/(sqrt(2pi)*sigma*x)]*exp[-((ln(x)-mu)^2)/(2*sigma^2)]
;
;	Note that the CDF is used to do the fitting via LOGNORMAL_CDF in FILAMENT_CGPROBPLOT. 
;	This routine is then used to plot the fitted parameters onto histogram distributions. 
;
; MODIFICATION HISTORY: 
;	 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

;p[0] = scale factor
;p[1] = sigma
;p[2] = mu 

if n_elements(p) ne 3 then stop
p = double(p)

ymod1 = 1./(sqrt(2.*!pi)*p[1]*x)
ymod2 = (-1.*(alog(x)-p[2])^2.)/(2.*p[1]^2)

ymod = p[0]*ymod1*exp(ymod2)

return, ymod
end
