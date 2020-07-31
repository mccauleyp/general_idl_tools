function anderson_darling_lognormal, data, params, struct=struct, normal=normal

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	ANDERSONG_DARLING_LOGNORMAL
;
; CATEGORY: 
;	Math, Statistics
;
; PURPOSE: 
;	Compute the Anderson-Darling goodness-of-fit statistic for a (log)normal fit. 
;
; CALLING SEQUENCE:
;	a_sqrd = anderson_darling_lognormal(data, params [,struct=struct] [,/normal])
;
; INPUTS: 
;	DATA = (Float Array)
;			Distribution data. Need not be sorted in any way. 
;	PARAMS = (Float Array)
;			(Log)normal fit parameters, [sigma, mu], to be tested. 
;
; OUTPUTS: 
;	RETURN = (Float)
;			A^2 statistic.
;	         
; KEYWORDS: 
;	STRUCT = (Structure)
;			Output structure containing the following tags:
;				A_SQRD = A^2 goodness-of-fit statistic, same as the RETURN value. 
;				P = approximate (interpolated) significance level (p-value). Will be NaN if 
;					if had to be extrapolated from D'Agostino & Stephens (1986) Table 4.9
;				Q = approximate (interpolated) lower-tail significance level. Will be NaN if 
;					if had to be extrapolated from D'Agostino & Stephens (1986) Table 4.9
;				ALPHA = Significances levels (p-values) corresponding the P_CRITICAL. If 
;						A^2 > P_CRITICAL[i], then the null hypothesis can be rejected at 
;						the ALPHA[i] significance level. 
;				P_CRITICAL = Critical A^2 values corresponding to ALPHA. See ALPHA note. 
;				Q_CRITICAL = Critical A^2 values corresponding to ALPHA for lower tail 
;							 significance. See ALPHA note. 
;				A = Value for which P(A^2 < a) = q, depends on number of elements in DATA. 
;					From D'Agostino & Stephens (1986) Table 4.8
;				Q = Tabulated Q values for A-calculated from D'Agostino & Stephens (1986) Table 4.8
;	NORMAL = (Boolean)
;			Set if PARAMS refers to a normal (Gaussian) distribution instead of a lognormal one. 
;
; EXAMPLES:
;
; NOTES:
;	Based on Chapter 4 of D'Agostino & Stephens (1986) "Goodness-of-fit Techniques"	
;
;	Critical values and approximate p-values can be returned through the STRUCT keyword. 
;	See the note about that in the keywords section for info. 
;
; MODIFICATION HISTORY: 
;	 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

;From D'Agostino & Stephens (1986) "Goodness-of-fit Techniques"

n = double(n_elements(data))
d2 = data[sort(data)]

ind = dindgen(n)+1
if keyword_set(normal) then $
	a_sqrd = (2.*ind-1.)*(alog(normal_cdf(d2[ind-1], params))+alog(1.-normal_cdf(d2[(n-ind+1)-1], params))) $
else $
	a_sqrd = (2.*ind-1.)*(alog(lognormal_cdf(d2[ind-1], params))+alog(1.-lognormal_cdf(d2[(n-ind+1)-1], params)))
	
a_sqrd = (-1.*n) - (1./n)*total(a_sqrd)

;modification for small sample
a_sqrd = a_sqrd*(1. + 0.75/n + 2.25/n^2)

;From D'Agostino & Stephens (1986) Table 4.7
alpha = [0.5, 0.25, 0.15, 0.1, 0.05, 0.025, 0.01, 0.005] ;significance level
p_critical = [0.341, 0.470, 0.561, 0.631, 0.752, 0.873, 1.1035, 1.159] ;upper tail
q_critical = [0.341, 0.249, 0.226, 0.188, 0.160, 0.139, 0.119, 0] ;lower tail 

;From D'Agostino & Stephens (1986) Table 4.8
q_tab = [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.50, 0.55, $
		0.60, 0.65, 0.70, 0.75, 0.80, 0.85, 0.90, 0.95, 0.975, 0.99, 0.995]
b0_tab = -1*[0.512, 0.522, 0.608, 0.643, 0.707, 0.735, 0.722, 0.770, 0.778, 0.779, 0.803, $
			0.818, 0.818, 0.801, 0.800, 0.756, 0.749, 0.750, 0.795, 0.881, 1.013, 1.063]
b1_tab = [2.10, 1.25, 1.07, 0.93, 1.03, 1.02, 1.04, 0.90, 0.80, 0.67, 0.70, $
		0.58, 0.42, 0.12, -0.09, -0.39, -0.59, -0.80, -0.89, -0.94, -0.93, -1.34]
a_inf_tab = [0.1674, 0.1938, 0.2147, 0.2333, 0.2509, 0.2681, 0.2853, 0.3030, 0.3213, 0.3405, 0.3612, $
			0.3836, 0.4085, 0.4367, 0.4695, 0.5091 ,0.5597, 0.6305, 0.7514, 0.8728, 1.0348, 1.1578]
			
;Value of a for which P(A^2 < a) = q
a_tab = a_inf_tab*(1. + b0_tab/n + b1_tab/n^2)

;From D'Agostino & Stephens (1986) Table 4.9
z = [0.2, 0.340, 0.60]
if a_sqrd lt z[0] then begin
	logq = -13.436 + 101.14*a_sqrd - 223.73*a_sqrd^2
	q = exp(logq)
	p = !values.f_nan
endif else if a_sqrd ge z[0] AND a_sqrd lt z[1] then begin
	logq = -8.318 + 42.796*a_sqrd - 59.938*a_sqrd^2
	q = exp(logq)
	p = !values.f_nan
endif else if a_sqrd ge z[1] AND a_sqrd lt z[2] then begin
	logp = 0.9177 - 4.279*a_sqrd - 1.38*a_sqrd^2
	p = exp(logp)
	q = !values.f_nan
endif else begin
	logp = 1.2937 - 5.709*a_sqrd + 0.0186*a_sqrd^2
	p = exp(logp)
	q = !values.f_nan
endelse

want = where(a_sqrd gt p_critical, count)

struct = {a_sqrd:a_sqrd, p:p, q:q, alpha:alpha, p_critical:p_critical, q_critical:q_critical, a:a_tab, q_tab:q_tab}

return, a_sqrd
end
