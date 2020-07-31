function expo_linear_project, x0, params, height=height

; ========================================================================================
;+
; PROJECT: 
;	Height Time
;
; NAME: 
;	EXPO_LINEAR_PROJECT
;
; CATEGORY: 
;	Math, Kinematics
;
; PURPOSE: 
;	Project the linear+exponential (expo_linear) fit to a specified height. 
;
; CALLING SEQUENCE:
;	struct = expo_linear_project, x0, params, height=height
;
; INPUTS: 
;	X0 = (Float)
;		Initial x (time) value to start with. This is in seconds after the initial 
;		measurement time. Should correspond to less than HEIGHT. 
;	PARAMS = (Float Array)
;		Linear+exponential fit parameters from the EXPO_LINEAR function, obtained via 
;		CANNY_FIT (or possibly something else...). The function is given by: 
;			p[0]*exp((x - p[1])/p[2]) + p[3]*(x - p[1]) + p[4]
;
; OUTPUTS: 
;	RETURN = (Structure)
;		Structure containing the following tags:
;			H = Projected height (should be very close to HEIGHT)
;			T = Time corresponding to H in seconds after x-axis start time
;			V = Velocity corresponding to H in arcsec/sec
;			A = Acceleration corresponding to H in arcsec/sec^2
;         
; KEYWORDS: 
;	HEIGHT = (Integer)
;		Height to project to, defaults to 500. 
;
; MODIFICATION HISTORY: 
;	 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

if not keyword_set(height) then height = 500

x = x0+dindgen(3000)*60.

this_fit = expo_linear(x, params, d1=this_v, d2=this_a)

temp = min(abs(this_fit - height), ind)

x = x[ind]+(dindgen(3000)-1500)*0.5

this_fit = expo_linear(x, params, d1=this_v, d2=this_a)

temp = min(abs(this_fit - height), ind)

h = this_fit[ind]
t = x[ind]
v = this_v[ind]
a = this_a[ind]

if abs(h-height) ge 1 then stop


return, {t:t, h:h, v:v, a:a, ref_height:height}
end
