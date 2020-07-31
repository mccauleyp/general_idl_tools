function alfven_speed, b, n_e, alf_n=alf_n, b_alf=b_alf 

; ========================================================================================
;+
; NAME: 
;	ALFVEN_SPEED
;
; CATEGORY: 
;	Physics
;
; PURPOSE: 
;	Return Alfven speed for given magnetic field strength and density. Or return 
;   magnetic field strength or density given Alfven speed (see keywords)
;
; INPUTS: 
;   B = Magnetic field strength in Gauss
;
;   N_E = Electron density in m^-3. 
;         WARNING: Will accept values in cm^-3 and automatically convert them to m^-3
;         if N_E < 10^12. This works for the conditions I was working in but may cause 
;         problems for someone else
;
; OUTPUTS: 
;	RETURN = Alfven speed in km/s
;         
; KEYWORDS: 
;	ALF_N = Boolean, If this keyword is set the input B is assumed to be the Alfven 
;           speed in km/s and the return value will be the magnetic field in G
;
;   B_ALF = Boolean, If this keyword is set the input N_E is assumed to be the 
;           Alfven speed in km/s and the return value will be the electron density 
;           in cm^-3
;
; EXAMPLES:
;   ;return Alfven speed:
;   v_a = alfven_speed(b, n_e)
;
;   ;return magnetic field:
;   b = alfven_speed(v_a, n_e, /ALF_N)
;
;   ;return density:
;   n_e = alfven_speed(b, v_a, /B_ALF)
;	
;
; NOTES:
;   From Magnetohydrodynamics of the Sun by Eric Priest (2014), page 173:
;   v_a = 2.8E12 * B * n^(-.5), where v_a is in m/s, B is in G, and n is in m^-3	
;
; CALLS: 
;
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

;convert n_e from cm^-3 to m^-3
if n_e le 10.^12 AND not keyword_set(b_alf) then n_e_m = n_e / 1E-6 else n_e_m = n_e

if keyword_set(alf_n) then begin
	va = b*1000. ;km/s to m/s
	b_field = va / (2.18E12 * n_e_m^(-.5)) ;gauss
	return, b_field
endif else if keyword_set(b_alf) then begin
	va = n_e*1000. ;km/s to m/s
	dens = ((b*2.18E12)/va)^2.
	dens = dens*1E-6 ;convert to cm^-3
	return, dens
endif else  begin
	va = 2.18E12 * b * n_e_m^(-.5) ;m/s
	va = va/1000. ;m/s to km/s
	return, va
endelse

end
