function abs_depth, i_obs, i_0, tau=tau, colden=colden, wavelength=wavelength, $
			foreground=foreground, filling_factor=filling_factor, g=g, qstop=qstop

; ========================================================================================
;+
; PROJECT: 
;	Column Density
;
; NAME: 
;	ABS_DEPTH
;
; CATEGORY: 
;	Math
;
; PURPOSE: 
;	Return the absorption depth given the measured intensity and assumed back/foreground. 
;
; CALLING SEQUENCE:
;	depth = abs_depth(i_obs, i_0 [,tau=tau] [,colden=colden] [,wavelength=wavelength])
;
; INPUTS: 
;	I_OBS = (Float)
;		Observed intensity
;	I_0 = (Float)
;		Assumed Background + Foreground (I_b + I_f)
;
; OUTPUTS: 
;	RETURN = (Float)
;		Absorption depth, d = 1 - (I_obs / I_0)
;         
; KEYWORDS: 
;	TAU = (Float)
;		Output for Optical Depth
;	COLDEN = (Float)
;		Output for Column Density via TAU_TO_COLDEN (must supply WAVELENGTH)
;	WAVELENGTH = (Integer)
;		Wavelength in Angstroms
;	FOREGROUND = (Float)
;		Float value between 0. and 1. that specifies what fraction of the I_0 input 
;		variable is foreground. 
;	FILLING_FACTOR = (Float)
;		Float value between 0. and 1. that specifies the fraction of the resolution 
;		element that's filled with prominence plasma
;	G = (Float)
;		Float value between 0. and 1. that combines the FOREGROUND and FILLING_FACTOR 
;		terms into one "geometric factor". Supplying this value will supersede the 
;		FOREGROUND and/or FILLING_FACTOR terms. 
;		G = filling factor * ( background / (background + foreground) )
;
; EXAMPLES:
;	
;
; NOTES:
;	From Kucera et al. (1998): d = 1 - (I_obs / I_0), where I_0 = I_b + I_f, where 
;	I_b = background, I_f = foreground, I_obs = observations, and d = absorption depth
;
;	Uses TAU_TO_COLDEN to return column density. 
;
; MODIFICATION HISTORY: 
;	 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================	

forward_function tau_to_colden

;Set default filling factor (1) and foreground component (0)
if not keyword_set(filling_factor) then filling_factor = 1.
if not keyword_set(foreground) then foreground = 0. 

;Determine geometric factor (G) if not supplied
if not keyword_set(g) then begin 
	i_b = i_0 - i_0*foreground ;background intensity
	g = filling_factor * ( i_b / i_0 )
endif

if keyword_set(qstop) then stop

;Ensure that values that must be from 0 to 1 actually are:
if filling_factor lt 0 OR filling_factor gt 1 then begin
	message, 'Oops, FILLING_FACTOR not between 0 and 1.', /info
	tau = -1
	return, -1
endif

if foreground lt 0 OR foreground gt 1 then begin
	message, 'Oops, FOREGROUND not between 0 and 1.', /info
	tau = -1
	return, -1
endif

if min(g) lt 0 OR max(g) gt 1 then begin
	message, 'Oops, G not between 0 and 1.', /info
	tau = -1
	return, -1
endif


output = 1. - (i_obs / i_0)

tau = -alog(1. - output/g)

if keyword_set(wavelength) then colden = tau_to_colden(tau, wavelength)

return, output
end
