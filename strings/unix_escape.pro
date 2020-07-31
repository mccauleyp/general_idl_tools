function unix_escape, in

; ========================================================================================
;+
; NAME: 
;   UNIX_ESCAPE
;
; CATEGORY: 
;   Strings
;
; PURPOSE: 
;   Replace all of the special Unix characters in a string with that character plus the 
;   Unix escape character so they aren't interpreted with their special Unix meanings. 
;
; INPUTS: 
;   IN = (String) Input String
;
; OUTPUTS: 
;   RETURN = (String) Output string with the escape character added where applicable
;
; NOTES:
;   The special characters are: \, *, ?, [, ], ', ", $, ;, &, (, ), |, ^, <, >
;
;   Used by WGET()
;
; CALLS: 
;   STR_REPLACE
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================


special = ['\', '*', '?', '[', ']', '''', '"', '$', ';', '&', '(', ')', '|', '^', '<', '>']

out = in

for i=0, n_elements(special)-1 do out = str_replace(out, special[i], '\'+special[i])

return, out
end
