function plasma_beta, n, t, b

; ========================================================================================
;+
; NAME: 
;   PLASMA_BETA
;
; CATEGORY: 
;   Physics and Math
;
; PURPOSE: 
;   Return the plasma beta given density, temperature, and magnetic field
;
; INPUTS: 
;   N = (Float) Electron density in cm^-3
;
;   T = (Float) Temperature in K
;
;   B = (Float) Magnetic field strength in G
;
; OUTPUTS: 
;   RETURN = (Float) plasma beta
;
; NOTES:
;   n_e = n / 1E-6 ;convert to m^-3
;   beta = (3.5E-21)*n_e*t*(b^(-2.))
;   See Magnetohydrodynamics of the Sun (Priest, 2014)
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

n_e = n / 1E-6 ;convert to m^-3
beta = (3.5E-21)*n_e*t*(b^(-2.))

return, beta
end
