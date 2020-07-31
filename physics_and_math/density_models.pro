function density_models, heights, model=model, initial=initial

; ========================================================================================
;+
; NAME: 
;   DENSITY_MODELS
;
; CATEGORY: 
;   Physics and Math
;
; PURPOSE: 
;   Return one of several electron density models for the solar corona given a set of 
;   heights. 
;
; INPUTS: 
;   HEIGHTS = (Double Array) Optional, defaults to dindgen(3501)*0.001 + 1. (i.e. A range 
;              from 1 solar radius to 4.5 in increments of 0.001) 
;
; OUTPUTS: 
;   RETURN = (Double Array) Densities corresponding to heights in units of cm^-3
;         
; KEYWORDS: 
;   MODEL = (String) Density model to use. Options are: 
;            'SPM_EQ': Equatorial Saito, Poland & Munro, 1977 Solar Physics 55:121
;            'SPM_PC': Polar Saito et al. 1977
;            'SPM_CH': Coronal Hole Saito et al. 1977
;            'LDB':  Solar Wind from Leblanc, Dulk, & Bougeret 1998 Solar Physics 183:165
;            'CAIRNS': From Cairns et al. 2009, ApJL, 706, 265L
;            'NEWKIRK': streamer model from Newkirk 1961
;            'GORYAEV': streamer density Goryaev et al. 2014 1.5--2 Rsun
;            'GORYAEV_BG': background from same paper
;            'GIBSON':  radial power law for WSM streamer in Gibson et al. 1999
;            'BA': radial power law from Baumbach-Allen in Aschwanden book
;            'SITTLER': streamer from Sittler & Guhathakurta (1999)
;
;   INITIAL = (Float Array) [Height, n_e] to initialize models for CAIRNS model, defaults
;              to [1.5, (7E13)/1E6]
;
; EXAMPLES:
;   density1 = density_models(height, model='NEWKIRK')
;   density2 = density_models(height, model='SPM_EQ')
;   plot, heights, dens, /ylog, xtitle='Height (R_Sun)', ytitle='Density (cm^-3)'
;   oplot, heights, density2, line=2 
;
; NOTES:
;   Uses other SolarSoft modules (SPM_NE and NE_SW) for the Saito and Leblanc models. 
;
; CALLS: 
;   SPM_NE, NE_SW
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


default, heights, dindgen(3501)*0.001 + 1.
default, initial, [1.5, (7E13)/1E6] ; [Height, n_e] to initialize models, from Cairns et al 2009

default, model, 'SPM_EQ'

allowed_models = ['SPM_EQ', $ ;Equatorial Saito, Poland and Munro, Solar Physics, vol 55, pp 121-134, 1977
				  'SPM_PC', $ ;Polar ''
				  'SPM_CH', $ ;Coronal Hole ''
				  'LDB', $ ; Solar Wind from Leblanc, Dulk, and Bougeret (Solar Physics, v183, pp165-180 (1998) (from type IIIs)
				  'CAIRNS', $ ;From Cairns et al. 2009, ApJL, 706, 265L
				  'NEWKIRK', $ ;streamer model from Newkirk 1961
				  'GORYAEV', $ ;streamer density Goryaev et al. 2014 1.5--2 Rsun
				  'GORYAEV_BG', $ ;background from same paper
				  'GIBSON', $ ; radial power law for WSM streamer in Gibson et al. 1999
				  'BA', $ ;radial power law from Baumbach-Allen in Aschwanden book
				  'SITTLER' $ ; streamer from Sittler & Guhathakurta (1999)
				  ]



case strupcase(model) of 
	'SPM_EQ': output = spm_ne(heights, 0)
	'SPM_PC': output = spm_ne(heights, 1)
	'SPM_CH': output = spm_ne(heights, 2)
	'LDB': output = ne_sw(heights)
	'CAIRNS': begin
		;n_e(r) = C(r - R_s)^(-2)
		c = initial[1] / (initial[0]-1.)^(-2) 
		output = c*(heights - 1.)^(-2)
	end
	'NEWKIRK': begin
		output = 4.2E4*(10.^(4.32/heights))
	end
	'GORYAEV': begin
		coef = [1.5996e+00,1.8606e+01,-1.8230e+01,7.0165e+00] ;streamer
		output = dblarr(n_elements(heights))
		for i=0, n_elements(coef)-1 do output = output + coef[i]/(heights^i)
		output = 10.^output
	end
	'GORYAEV_BG': begin
		coef = [4.4986e+00,1.0993e+00,4.3538e+00,-1.3057e+00] ;background
		output = dblarr(n_elements(heights))
		for i=0, n_elements(coef)-1 do output = output + coef[i]/(heights^i)
		output = 10.^output
	end
	'GIBSON': begin
		coef = [3.6d8,15.3d0,0.99d8,7.34d0,0.365d8,4.31d0]
		output = coef[0]*heights^(-1*coef[1]) + coef[2]*heights^(-1*coef[3]) + coef[4]*heights^(-1*coef[5])
	end
	'BA': begin
		coef = [2.99d8,16d0,1.55d8,6.d0,0.036d8,1.5d0]
		output = coef[0]*heights^(-1*coef[1]) + coef[2]*heights^(-1*coef[3]) + coef[4]*heights^(-1*coef[5])
	end
	'SITTLER':begin
		coef = double([3.2565E-3, 3.6728, 4.8947, 7.6123, 5.9868])
		coef = double([1.2921E-3, 4.8039, 0.29696, -7.1743, 12.321])
		output = coef[0]*exp(coef[1]/heights)*(heights^(-2.))*(1. + coef[2]/heights + coef[3]/(heights^2.) + coef[4]/(heights^3.))
		;hghts = 1./heights
		;output = coef[0]*exp(coef[1]*hghts)*(hghts^2.)*(1 + coef[2]*hghts + coef[3]*hghts^2 + coef[4]*hghts^3)
	end
	else: begin
		message, 'Oops, input model not recongnized.', /info
		return, -1
	end
endcase

return, output
end
