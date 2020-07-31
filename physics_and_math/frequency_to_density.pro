function frequency_to_density, frequency, harmonic=harmonic

; ========================================================================================
;+
; NAME: 
;   FREQUENCY_TO_DENSITY
;
; CATEGORY: 
;   Physics and Math
;
; PURPOSE: 
;   Convert a frequency to a density assuming that the frequency corresponds to the  
;   fundamental or harmonic electron plasma frequency.
;
; INPUTS: 
;   FREQUENCY = (Float or Array) Electron plasma frequencies in MHz
;
; OUTPUTS: 
;   RETURN = (Float or Array) Electron densities in cm^-3
;         
; KEYWORDS: 
;   HARMONIC (Boolean) Set to return the harmonic plasma frequency for DENSITY instead 
;            of the fundamental
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

;input = frequency in MHz
;output = density in cm^-3

freq = frequency*1E6

const = ( 4.*(!const.pi^2)*!const.me*!const.eps0 ) / ( !const.e^2 )

if keyword_set(harmonic) then dens = const*((freq/2.)^2) $
	else dens = const*(freq^2)

density = dens / (100.^3.) 

return, density
end
