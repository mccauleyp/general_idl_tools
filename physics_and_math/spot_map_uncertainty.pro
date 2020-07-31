function spot_map_uncertainty, bmaj, flux, err

; ========================================================================================
;+
; NAME: 
;   SPOT_MAP_UNCERTAINTY
;
; CATEGORY: 
;   Physics and Math
;
; PURPOSE: 
;   Calculate the uncertainty for a "spot mapping" radio observation (see Notes) 
;
; INPUTS: 
;   BMAJ = (Float) Major axis of the of the primary beam in degrees. 
;
;   FLUX = (Float) Measured flux density
;
;   ERR = (Float) Instrumental noise uncertainty (sigma)
;
; OUTPUTS: 
;   RETURN = Uncertainty in degrees
;
; NOTES:
;   This approach assumes that the source size is << than the beam size, in which case 
;   the position uncertainty can be reduced by a factor inversely proportional to the 
;   signal-to-noise ratio. Formula here taken from Equation 1 of Reid et al. (1988):
;
;   http://adsabs.harvard.edu/abs/1988ApJ...330..809R
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


;from Equation 1 of Reid et al. (1988): http://adsabs.harvard.edu/abs/1988ApJ...330..809R

output = ( (4./!const.pi)^(0.25) )*( bmaj/sqrt(8.*alog(2.)) )*( err/flux )

return, output
end
