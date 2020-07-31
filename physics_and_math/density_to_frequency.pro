function density_to_frequency, density, harmonic=harmonic

; ========================================================================================
;+
; NAME: 
;   DENSITY_TO_FREQUENCY
;
; CATEGORY: 
;   Physics and Math
;
; PURPOSE: 
;   Convert a density to the corresponding fundamental (or harmonic) plasma frequency.
;
; INPUTS: 
;   DENSITY = (Float or Array) Electron densities in cm^-3
;
; OUTPUTS: 
;   RETURN = (Float or Array) Electron plasma frequencies corresponding to DENSITY in MHz
;         
; KEYWORDS: 
;   HARMONIC (Boolean) Set to return the harmonic plasma frequency for DENSITY instead 
;            of the fundamental
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


;input = density in cm^-3
;output = frequency in MHz

dens = density * (100.^3.) ;convert to m^-3

const = ( 4.*(!const.pi^2)*!const.me*!const.eps0 ) / ( !const.e^2 )

freq = sqrt(dens / const)

frequency = freq/1E6

if keyword_set(harmonic) then frequency = frequency*2

return, frequency
end
