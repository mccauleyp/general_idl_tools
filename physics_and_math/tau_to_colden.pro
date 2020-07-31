function tau_to_colden, tau, wavelength, colden_to_tau=colden_to_tau

; ========================================================================================
;+
; PROJECT: 
;	Column Density
;
; NAME: 
;	TAU_TO_COLDEN
;
; CATEGORY: 
;	Physics and Math
;
; PURPOSE: 
;	Convert optical depth (tau) to column density (N)
;
; CALLING SEQUENCE:
;	colden = tau_to_colden(tau, wavelength)
;
; INPUTS: 
;	TAU = (Float)
;		Optical depth obtained from ABS_DEPTH
;	WAVELENGTH = (Integer)
;		Wavelength in Angstrom used to get absorption cross section
;
; OUTPUTS: 
;	RETURN = (Float)
;		Column density (Units cm^-2)
;
; MODIFICATION HISTORY: 
;	 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;-
; ========================================================================================

a = 0.0851 ;fractional He abundance from Grevesse et al. (2007), SSRv, 130, 105
abs_cross = abs_cross(wavelength, 'he2')

if keyword_set(colden_to_tau) then begin
	;tau = colden in this case and output = tau
	if n_elements(tau) gt 1 AND n_elements(abs_cross) eq 1 then output = tau * (2.*a*abs_cross[0]) $
	else output = tau * (2.*a*abs_cross)
endif else begin 
	if n_elements(tau) gt 1 AND n_elements(abs_cross) eq 1 then output = tau / (2.*a*abs_cross[0]) $
	else output = tau / (2.*a*abs_cross)
endelse

return, output
end
