function abs_cross, wavelength, species

; ========================================================================================
;+
; PROJECT: 
;	Column Density
;
; NAME: 
;	ABS_CROSS
;
; CATEGORY: 
;	Math
;
; PURPOSE: 
;	Return the absorption cross sections of HI, HeI, and HeII for a given wavelength
;	in angstroms.
;
;
; CALLING SEQUENCE:
;	abs = abs_cross(wavelength, species)
;
; INPUTS: 
;	WAVELENGTH = (String)
;		Wavelength IN ANGSTROMS
;	SPECIES = (String)
;		Atom to return cross section for. Options are 'h1', 'he1', or 'he2', for neutral 
;		Hydrogen, neutral Helium, and singly-ionized Helium.
;
; OUTPUTS: 
;	RETURN = (Float)
;		Absorption cross section in units cm^2. 
;         
; KEYWORDS: 
;	None. 
;
; EXAMPLES:
;	
;
; NOTES:
;	Based on Verner et al (1996), "Atomic Data for Astrophysics. II. 
;	New Analytic Fits for Photoionization Cross Sections of Atoms and Ions," ApJ, 
;	465, 487
;
; MODIFICATION HISTORY: 
;	 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================


;Purpose: Return the absorption cross sections of HI, HeI, and HeII for a given wavelength
;		  in angstroms. Based on Verner et al (1996), "Atomic Data for Astrophysics. II. 
;		  New Analytic Fits for Photoionization Cross Sections of Atoms and Ions," ApJ, 
;		  465, 487
;
;Inputs:
;	wavelength = in angstroms
;	species = options are 'h1', 'he1', or 'he2'
;
;Output: Photoionization absorption cross section in cm^2
;
;Written: Patrick McCauley (pmccauley@cfa.harvard.edu)
;

allowed = ['h1', 'he1', 'he2']
want = where(species eq allowed, count)
if count eq 0 then begin
	message, 'Oops, species input not right. Choose one of:'+ strjoin(allowed, ', '), /info
	return, -1
endif

;Copied from Table 1 of Verner et al. (1996)
case species of
	'h1': begin ;neutral hydrogen 
			z = 1.
			n = 1.
			e_th = 1.360E+1 ;eV
			e_max = 5.000E+4 ;eV
			e_0 = 4.298E-1 ;eV
			sig_0 = 5.475E+4 ;Mb (1 Mb = 10^-18 cm^2)
			y_a = 3.288E+1 
			p = 2.963E+0
			y_w = 0.000E+0
			y_0 = 0.000E+0
			y_1 = 0.000E+0
		end
	'he1': begin ;neutral helium
			z = 2.
			n = 2.
			e_th = 2.459E+1
			e_max = 5.000E+4
			e_0 = 1.361E+1
			sig_0 = 9.492E+2
			y_a = 1.469E+0
			p = 3.188E+0
			y_w = 2.039E+0
			y_0 = 4.434E-1
			y_1 = 2.136E+0  
		end
	'he2': begin ;singly ionized helium
			z = 2.
			n = 1.
			e_th = 5.442E+1
			e_max = 5.000E+4
			e_0 = 1.720E+0
			sig_0 = 1.369E+4
			y_a = 3.288E+1
			p = 2.963E+0
			y_w = 0.000E+0
			y_0 = 0.000E+0
			y_1 = 0.000E+0
		end
endcase

micrometers = wavelength*1.E-4 ;wavelength in micrometers
e = 1.2398 / micrometers ;photon energy in eV

;Equation 1 from Verner et al. (1996)
x = (e / e_0) - y_0
y = sqrt(x^2 + y_1^2)
f_y = [ (x-1.)^2. + y_w^2 ] * [ y^(0.5*p - 5.5) ] * [ (1 + sqrt(y/y_a))^(-p) ]
sig_a = sig_0*f_y ;result in Mb 

output = sig_a * 10.^(-18) ;convert to cm^2

return, output
end
