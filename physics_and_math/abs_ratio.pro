function abs_ratio, wavelength, base=base

; ========================================================================================
;+
; PROJECT: 
;	Column Density
;
; NAME: 
;	ABS_RATIO
;
; CATEGORY: 
;	Math
;
; PURPOSE: 
;	Return the ratio of absorption cross sections
;
; CALLING SEQUENCE:
;	ratio = abs_ratio(wavelength, [,base=base])
;
; INPUTS: 
;	WAVELENGTH = (Integer)
;		Wavelength in Angstroms
;
; OUTPUTS: 
;	RETURN = (Float)
;		WAVELENGTH absorption cross section divided by BASE cross section. 
;         
; KEYWORDS: 
;	BASE = (Integer)
;		Base wavelength in Angstrom for ratio. Defaults to 211. 
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

if not keyword_set(base) then base = 211.

wv = float(wavelength)

output = abs_cross(wv, 'he2') / abs_cross(base, 'he2')

return, output
end
