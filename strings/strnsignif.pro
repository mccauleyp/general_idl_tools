function strnsignif,number,digits

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	STRNSIGNIF
;
; CATEGORY: 
;	Utility
;
; PURPOSE: 
;	Convert a number to a string with a fixed number of significant digits.
;
; CALLING SEQUENCE:
;	num = strnsignif(number, digits)
;
; INPUTS: 
;	NUMBER = (Number; Float, Double, etc.)
;			Input number to be converted to string. Can be an array.
;	DIGITS = (Integer)
;			Number of significant figures to return. Should either have 1 element 
;			or the same number of elements as NUMBER.
;
; OUTPUTS: 
;	RETURN = (String)
;			NUMBER converted to string with DIGITS significant figures. 
;         
; KEYWORDS: 
;	None.
;
; EXAMPLES:
;	print, strnsignif(42.42, 2)
;
; NOTES:
;	None.
;
; MODIFICATION HISTORY: 
;	 - 1999-03-29 Version 1 written by Eric W. Deutsch & Brooke Skelton
;	 - 2015-03-31 Added handling for array input - Patrick McCauley
;
;-
; ========================================================================================


if (n_params(0) lt 2) then begin
	message, 'Oops, forgot inputs.', /info
	return, -1
endif

;Handling for array input
if n_elements(number) gt 1 then begin
	if n_elements(digits) ne n_elements(number) AND n_elements(digits) ne 1 then begin
		message, 'Oops, DIGITS should have either 1 element or the same as NUMBER', /info
		return, -1
	endif

	out = strarr(n_elements(number))
	if n_elements(digits) eq 1 then duse = intarr(n_elements(number))+digits else duse = digits

	for i=0, n_elements(number)-1 do out[i] = strnsignif(number[i], duse[i])
	return, out
endif

expon=fix(alog10(number))
if (number lt 1) then expon=expon-1

c=round(number/10.0^(expon-(digits-1)))*10.0^(expon-(digits-1))

if (c gt 10^(digits-1)) then d = strn(round(c)) $
	else d = strn(string(c,format='(f20.'+strn(digits-1-expon)+')'))

return,d

end
