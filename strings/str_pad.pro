function str_pad, in, len, front=front, back=back

; ========================================================================================
;+
; NAME: 
;   STR_PAD
;
; CATEGORY: 
;   Strings
;
; PURPOSE: 
;   Pad a string with spaces to a desired length
;
; INPUTS: 
;   IN = (String) input string
;
;   LEN = (Int) length to be padded to
;
; OUTPUTS: 
;   RETURN = (String) Padded string
;         
; KEYWORDS: 
;   FRONT = (Boolean) pad to the front
;
;   BACK (Boolean) pad to the back (default=1)
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


in_len = strlen(in)

if in_len ge len then begin
	message, 'strlen(in) ge len, returning unmodified.', /info
	return, in
endif

pad_count = len - in_len

if keyword_set(front) then out = strjoin(strarr(pad_count)+' ')+in
if keyword_set(back) then out = in+strjoin(strarr(pad_count)+' ')

if n_elements(out) eq 0 then begin 
	out = strjoin(strarr(pad_count/2)+' ')+in+strjoin(strarr(pad_count/2)+' ')
	if (pad_count mod 2) eq 1 then out = out+' '
endif

return, out
end
