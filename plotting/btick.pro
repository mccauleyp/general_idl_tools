function btick, length

; ========================================================================================
;+
; NAME: 
;	BTICK
;
; CATEGORY: 
;	Plotting
;
; PURPOSE: 
;	Return a string array of LENGTH filled with single spaces
;
; INPUTS: 
;	LENGTH = Optional, int, defaults to 20
;
; OUTPUTS: 
;	RETURN = String array
;
; NOTES:
;	I just use this as shorthand for strarr(20)+' ' for plotting keywords. For example:
;
; CALLS: 
;   plot, indgen(10), indgen(10), xtickname=btick(), ytickname=btick()   
;
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;
;-
; ========================================================================================

if n_elements(length) eq 0 then length=20

return, strarr(length)+' '
end
