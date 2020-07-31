function strip_html, input_string, delimiter=delimiter

; ========================================================================================
;+
; PROJECT: 
;	General
;
; NAME: 
;	STRIP_HTML
;
; CATEGORY: 
;	HTML
;
; PURPOSE: 
;	Remove HTML formatting tags from a string. 
;
; CALLING SEQUENCE:
;	result = strip_html(input_string [,delimiter=delimiter] )
;
; INPUTS: 
;	INPUT_STRING - (String)
;				Formatted HTML text. Can be an array.
;
; OUTPUTS: 
;	RETURN - (String)
;			Text with HTML tags removed. 
;         
; KEYWORDS: 
;	DELIMITER - (String)
;			By default, text from neighboring HTML tags will be separated by a space. This 
;			keyword can be used so that they're separated by any arbitrary character.
;
; EXAMPLES:
;	IDL> print, strip_html('<A HREF="link">text</A>')
;	text
;
; NOTES:
;	This routine identifies HTML tags by searching for < and > symbols, so it'll get 
;	confused and quit if it finds unequal numbers of those symbols.	
;
; MODIFICATION HISTORY: 
;	2014/01/20 - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

if not keyword_set(delimiter) then delimiter = ' '

output = strarr(n_elements(input_string))

for j=0, n_elements(input_string)-1 do begin

	in = input_string[j]

	if strpos(in, '<') eq -1 then return, in

	;find <
	pos = intarr(strlen(in))-1
	i=0 & ind=0
	repeat begin
		now = strpos(in, '<', ind)
		ind = now+1
		pos[i] = now
		i=i+1
	endrep until now eq -1
	pos = pos[where(pos ne -1)]

	pos1 = pos

	;find >
	pos = intarr(strlen(in))-1
	i=0 & ind=0
	repeat begin
		now = strpos(in, '>', ind)
		ind = now+1
		pos[i] = now
		i=i+1
	endrep until now eq -1
	pos = pos[where(pos ne -1)]

	pos2 = pos

	if n_elements(pos1) ne n_elements(pos2) then begin
		message, 'Found different number of < than >', /info
		return, in
	endif

	out = strarr(n_elements(pos1)-1)
	for i=0, n_elements(pos1)-2 do out[i] = strmid(in, pos2[i]+1, pos1[i+1]-pos2[i]-1)	
	out = str_replace(out, '&nbsp;', ' ')
	out = trim(out) ;trim leading and trailing spaces
	want = where(out ne '', count) ;find nonblank entries
	if count gt 0 then out = out[want] else out = ' '
	out = strjoin(out, delimiter)
	out = str_replace(out, '  ', ' ') ;replace any double spaces with single ones
	output[j] = out 
	
endfor

if n_elements(output) eq 1 then output = output[0]

return, output
end
