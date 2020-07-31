function newkirk_radius, frequency, nfold=nfold

; ========================================================================================
;+
; NAME: 
;   NEWKIRK_RADIUS
;
; CATEGORY: 
;   Physics and Math
;
; PURPOSE: 
;   Return the height of the plasma frequency layer in solar radii given the Newkirk 
;   (1961) background solar coronal electron density model. 
;
; INPUTS: 
;   FREQUENCY = (Float) Frequency in MHz
;
; OUTPUTS: 
;   RETURN = (Float) Height of plasma frequency layer in solar radii
;         
; KEYWORDS: 
;   NFOLD = (Int or Float) Multiplicative factor to consider an n-fold density 
;           enhancement over the standard background model.  

; CALLS: 
;   FREQUENCY_TO_DENSITY
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

rsun_km = 696342. ;from SOHO Mercury transit
frequency = double(frequency)

if n_elements(nfold) eq 0 then begin
	
	;this is the default expression I've been using the whole time, which wraps an approximation 
	;for the plasma frequency into the newkirk model. The result is almost the same as 
	;when setting nfold=1, which uses more precise numbers, but I've left this as the default
	;for consistency 
	
	r = (9.95/(2.*alog(frequency) - 1.22));-1
	;r = r*rsun_km

endif else begin

	;use the nfold keyword of you want the height corresponding to a nfold x Newkirk 
	;model. (e.g. nfold=3 gives you height for 3x Newkirk model)

	r = 4.32/alog10(frequency_to_density(frequency)/(4.2E4*nfold))

endelse

return, r
end
